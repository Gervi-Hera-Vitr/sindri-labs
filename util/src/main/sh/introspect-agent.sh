#!/usr/bin/env zsh

version_of_jdk=${1:-'21.0.5'}
gradle_version=${2:-'8.11.1'}
production_run=${3:-true}

agent_host=$(hostname)

local_temp_folder="$HOME/tmp";
mkdir -p "$local_temp_folder";

# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    production_run=false
fi

echo "::group::Introspection for $(hostname) - $(date +%H:%M:%S)"

if [[ "$production_run" == "true" ]]; then
  echo -e "\n\nProduction Run.\n\n"
else
  echo -e "\n\nDevelopment Run.\n\n"
fi

# shellcheck source=SDKMAN_INIT
if [[ -s "$SDKMAN_INIT" ]]; then
  source "$SDKMAN_INIT"
else
  echo "::error file=introspect-agent.sh,line=35::Agent host $(hostname) does not provide SDK bootstrapping and MUST use Actions to provide required SDKs!";
fi

if [ -z "${GITHUB_ENV+xxx}" ]; then
  export GITHUB_ENV="";
  echo "::error file=introspect-agent.sh,line=40::Agent host $(hostname) did not provide GitHub Environment file!";
fi

if [ -z "$GITHUB_ENV" ] && [ "${GITHUB_ENV+xxx}" = "xxx" ]; then
  GITHUB_ENV="$local_temp_folder/github_env.local.$(date +%Y-%m-%d-%H-%M-%S).env";
  echo "::warning file=introspect-agent.sh,line=45::Agent host $(hostname) GitHub Environment is UNREACHABLE to Actions Runner and is simulated at $GITHUB_ENV!";
fi

if [ -z "${GITHUB_STEP_SUMMARY+xxx}" ]; then
  if [[ "$production_run" == "true" ]]; then
    echo "::error file=introspect-agent.sh,line=50::Agent host $(hostname) did not provide GitHub Step Summary file!";
  else
    export GITHUB_STEP_SUMMARY="";
  fi
  if [ -z "$GITHUB_STEP_SUMMARY" ] && [ "${GITHUB_STEP_SUMMARY+xxx}" = "xxx" ]; then
    GITHUB_STEP_SUMMARY="$local_temp_folder/github_step_summary.local.$(date +%Y-%m-%d-%H-%M-%S).md";
    echo "::warning file=introspect-agent.sh,line=50::Agent host $(hostname) GitHub Step Summary is UNREACHABLE to Actions Runner and is simulated at $GITHUB_STEP_SUMMARY!";
  fi
fi

echo -e "\n\n==== SDKs ===="

# Java check
JAVA_VERSION_INSTALLED=$(java --version | head -1)
echo "java_version=$JAVA_VERSION_INSTALLED" >> "$GITHUB_ENV"
if [[ $JAVA_VERSION_INSTALLED =~ $version_of_jdk ]]; then
  echo "java_correct=true" >> "$GITHUB_ENV"
  echo "Agent host $(hostname): JDK $version_of_jdk is locally available."
else
  echo "java_correct=false" >> "$GITHUB_ENV"
  echo "::warning file=introspect-agent.sh,line=62::Agent host $(hostname): JDK $version_of_jdk is NOT locally available."
fi

# Gradle check
GRADLE_VERSION_INSTALLED=$(gradle -v | grep Gradle | cut -d ' ' -f 2)
echo "gradle_version=$GRADLE_VERSION_INSTALLED" >> "$GITHUB_ENV"
if [[ $GRADLE_VERSION_INSTALLED =~ $gradle_version ]]; then
  echo "gradle_correct=true" >> "$GITHUB_ENV"
  echo "Agent host $(hostname): Gradle $GRADLE_VERSION_INSTALLED is locally available."
else
  echo "gradle_correct=false" >> "$GITHUB_ENV"
  echo "::warning file=introspect-agent.sh,line=73::Agent host $(hostname): Gradle $gradle_version is NOT locally available."
fi


# Disk usage check
typeset -a  disk_usage_information

while read -r line; do

  device=$(echo "$line" | awk '{print $1}')
  size=$(echo "$line" | awk '{print $2}')
  used=$(echo "$line" | awk '{print $3}')
  available=$(echo "$line" | awk '{print $4}')
  usage=$(echo "$line" | awk '{print $5}' | tr -d '%')

  mount="none"
  if [[ "$production_run" == "true" ]]; then
    mount=$(echo "$line" | awk '{print $6}')
  else
    mount=$(echo "$line" | awk '{print $9}')
  fi
  mapping=$(echo "${device//\/dev\///}" | tr '/' ' '):$(echo "$mount" | tr '/' ' ')
  slug="$agent_host:${mapping// /_}"

  if [[ ! "$device" == *"/dev"* ]]; then
    echo -e "| -- > Skipping device $device."
    continue
  fi

  if [[ "$mount" == *"/dev"* ]]; then
    echo -e "| -- > Skipping mount $mount."
    continue
  fi

  if [[ "$mount" == *"/run"* ]]; then
    echo -e "| -- > Skipping mount $mount."
    continue
  fi

  if [[ "$mount" == *"/boot"* ]]; then
    echo -e "| -- > Skipping mount $mount."
    continue
  fi

  # Add to GitHub environment variables
  echo "${slug}=${usage}%" >> "$GITHUB_ENV"

  # Create disk usage summary
  disk_usage_information+=("**${usage}%** - $mount (Device: $device, Size: $size, Used: $used, Available: $available);")
  if [[ ! "$production_run" == "true" ]]; then
    echo -e "\n\nMount: $mount\nSize: $size\nUsed: $used\nAvailable: $available\nUsage: ${usage}%\n${line}\n\n"
  fi

  # Log warnings or errors based on usage
  if [[ $usage -ge 50 && $usage -lt 75 ]]; then
    echo "| -- > Disk usage on $slug is at $usage% - consider investigating."
  elif [[ $usage -ge 75 && $usage -lt 85 ]]; then
    echo "::warning file=introspect-agent.sh,line=81::Disk usage on $mount is at $usage% - requires maintenance."
  elif [[ $usage -ge 85 ]]; then
    echo "::error file=introspect-agent.sh, line=83:: Disk usage on $mount is critically low at $usage%."
  fi
done < <(df -h | tail -n +2)

# Write summary to GitHub summary file
{
echo -e "# Agent Host Checks on $agent_host\n\n"
echo "<details>"
echo "<summary>Resource Usage:</summary>"
echo
echo "- **Host Name:** $agent_host"
echo "- **Java Version:** $JAVA_VERSION_INSTALLED"
echo "- **Gradle Version:** $GRADLE_VERSION_INSTALLED"
echo "- **Disk Usage on _${agent_host}_:**"
for line in "${disk_usage_information[@]}"; do
  echo "  - $line"
done
echo "- **Gradle Correct:** $(grep 'gradle_correct' "$GITHUB_ENV" | cut -d '=' -f 2)"
echo "- **Java Correct:** $(grep 'java_correct' "$GITHUB_ENV" | cut -d '=' -f 2)"
echo
echo "_Please reach out to the [Gervi Héra Vitr](https://github.com/Gervi-Hera-Vitr) organization members for more information._"
echo
echo "</details>"
echo
}  >> "$GITHUB_STEP_SUMMARY"

if [[ "$production_run" != "true" ]]; then
  echo -e "==== Disk Usage ====\n"
  for usage_info in "${disk_usage_information[@]}"; do
      echo -e "$usage_info"
  done
  echo -e "==== Environment ====\n"
  cat "$GITHUB_ENV"
  echo -e "==== Summary ====\n"
  cat "$GITHUB_STEP_SUMMARY"
  echo -e "file://$GITHUB_STEP_SUMMARY"
  echo -e "==== End ====\n"
fi

echo "::endgroup::"
