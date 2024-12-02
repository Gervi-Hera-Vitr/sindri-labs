#!/usr/bin/env zsh

skipped_mounts=(
  '/dev'
  '/run'
  '/boot'
)

version_of_jdk=${1:-'21.0.5'}
gradle_version=${2:-'8.11.1'}
agent_host=$(hostname)

# File to store summary details
github_summary="$GITHUB_STEP_SUMMARY"

echo "::group::Introspection for $(hostname) - $(date +%H:%M:%S)"

# shellcheck source=SDKMAN_INIT
if [[ -s "$SDKMAN_INIT" ]]; then
  source "$SDKMAN_INIT"
else
  echo "::error file=introspect.sh,line=9::Agent host $(hostname) does not provide SDK bootstrapping and MUST use Actions to provide required SDKs!";
fi

if [ -z "${GITHUB_ENV+xxx}" ]; then
  export GITHUB_ENV="";
  echo "::error file=introspect.sh,line=16::Agent host $(hostname) did not provide GitHub Environment file!";
fi

if [ -z "$GITHUB_ENV" ] && [ "${GITHUB_ENV+xxx}" = "xxx" ]; then
  local_temp_folder="$HOME/tmp";
  mkdir -p "$local_temp_folder";
  GITHUB_ENV="$local_temp_folder/github_env.local.$(date +%Y-%m-%d-%H-%M-%S)";
  echo "::warning file=introspect.sh,line=26::Agent host $(hostname) GitHub Environment is UNREACHABLE to Actions Runner and is simulated at $GITHUB_ENV!";
fi

# Java check
JAVA_VERSION_INSTALLED=$(java --version | head -1)
echo "java_version=$JAVA_VERSION_INSTALLED" >> "$GITHUB_ENV"
if [[ $JAVA_VERSION_INSTALLED =~ $version_of_jdk ]]; then
  echo "java_correct=true" >> "$GITHUB_ENV"
  echo "Agent host $(hostname): JDK $version_of_jdk is locally available."
else
  echo "java_correct=false" >> "$GITHUB_ENV"
  echo "::warning file=introspect.sh,line=35::Agent host $(hostname): JDK $version_of_jdk is NOT locally available."
fi

# Gradle check
GRADLE_VERSION_INSTALLED=$(gradle -v | grep Gradle | cut -d ' ' -f 2)
echo "gradle_version=$GRADLE_VERSION_INSTALLED" >> "$GITHUB_ENV"
if [[ $GRADLE_VERSION_INSTALLED =~ $gradle_version ]]; then
  echo "gradle_correct=true" >> "$GITHUB_ENV"
  echo "Agent host $(hostname): Gradle $GRADLE_VERSION_INSTALLED is locally available."
else
  echo "gradle_correct=false" >> "$GITHUB_ENV"
  echo "::warning file=introspect.sh,line=50::Agent host $(hostname): Gradle $gradle_version is NOT locally available."
fi

# Disk usage check
disk_usage_information=""
df -h | tail -n +2 | while read -r line; do
  for skipped_mount in "${skipped_mounts[@]}"; do
    if [[ "$line" == *"$skipped_mount"* ]]; then
      echo -e "| -- > Skipping $line due to \'$skipped_mount\' skipped mount."
      continue 2
    fi
  done

  usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
  mount=$(echo "$line" | awk '{print $6}')

  slug=$(echo "$mount" | tr '/' '_')

  device=$(echo "$line" | awk '{print $1}')
  size=$(echo "$line" | awk '{print $2}')
  used=$(echo "$line" | awk '{print $3}')
  available=$(echo "$line" | awk '{print $4}')

  # Add to GitHub environment variables
  echo "${agent_host}_${slug}=${usage}%" >> "$GITHUB_ENV"

  # Create disk usage summary
  # shellcheck disable=SC2030
  disk_usage_information+="- **$mount** (Device: $device, Size: $size, Used: $used, Available: $available, Usage: ${usage}%)\n"

  # Log warnings or errors based on usage
  if [[ $usage -ge 50 && $usage -lt 75 ]]; then
    echo -e "| -- > Disk usage on $slug is at $usage% - consider investigating."
  elif [[ $usage -ge 75 && $usage -lt 85 ]]; then
    echo "::warning file=introspect.sh,line=81::Disk usage on $mount is at $usage% - requires maintenance."
  elif [[ $usage -ge 85 ]]; then
    echo "::error file=introspect.sh, line=83:: Disk usage on $mount is critically low at $usage%."
  fi
done

# Write summary to GitHub summary file
cat <<EOF >> "$github_summary"
# Agent Host Checks on $agent_host

<details>
<summary>Resource Usage:</summary>

- **Host Name:** $agent_host
- **Java Version:** $JAVA_VERSION_INSTALLED
- **Gradle Version:** $GRADLE_VERSION_INSTALLED
- **Disk Usage:**
  $disk_usage_information
- **Gradle Correct:** $(grep 'gradle_correct' "$GITHUB_ENV" | cut -d '=' -f 2)
- **Java Correct:** $(grep 'java_correct' "$GITHUB_ENV" | cut -d '=' -f 2)

</details>

_Please reach out to the [Gervi Hеrа Vitr](https://github.com/Gervi-Hera-Vitr) organization members for more information._
EOF

echo "::endgroup::"
