#!/usr/bin/env zsh

skipped_mounts=(
  '/dev'
  '/run'
  '/boot'
)

version_of_jdk=${1:-'21.0.5'}
gradle_version=${2:-'8.11.1'}
agent_host=$(hostname)

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


JAVA_VERSION_INSTALLED=$(java --version | head -1)
echo "java_version=$JAVA_VERSION_INSTALLED" >> "$GITHUB_ENV"
if [[ $JAVA_VERSION_INSTALLED =~ $version_of_jdk ]]; then
  echo "java_correct=true" >> "$GITHUB_ENV"
  echo "Agent host $(hostname): JDK $version_of_jdk is locally available.";
else
  echo "java_correct=false" >> "$GITHUB_ENV"
  echo "::warning file=introspect.sh,line=35::Agent host $(hostname): JDK $version_of_jdk is NOT locally available.";
fi

GRADLE_VERSION_INSTALLED=$(gradle -v | grep Gradle | cut -d ' ' -f 2)
echo "gradle_version=$GRADLE_VERSION_INSTALLED" >> "$GITHUB_ENV"
if [[ $GRADLE_VERSION_INSTALLED =~ $gradle_version ]]; then
  echo "gradle_correct=true" >> "$GITHUB_ENV"
  echo "Agent host $(hostname): Gradle $GRADLE_VERSION_INSTALLED is locally available.";
else
  echo "gradle_correct=false" >> "$GITHUB_ENV"
  echo "::warning file=introspect.sh,line=81::Agent host $(hostname): Gradle $gradle_version is NOT locally available.";
fi

declare -av disk_usage    # Array to store disk usage information in summary

# Disk usage check
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

  echo -e "| -- > Disk usage on $slug is at $usage% (device: $device, size: $size, used: $used, available: $available)."


  echo "${agent_host}_${slug}=${usage}%" >> "$GITHUB_ENV"

  if [[ $usage -ge 50 && $usage -lt 75 ]]; then
    echo -e "| -- > Disk usage on $slug is at $usage% - consider investigating."
  elif [[ $usage -ge 75 && $usage -lt 85 ]]; then
    echo "::warning file=introspect.sh,line=105::Disk usage on $mount is at $usage% - requires maintenance."
  elif [[ $usage -ge 85 ]]; then
    echo ":error file=introspect.sh, line=107:: Disk usage on $mount is critically low at $usage%."
  fi
done

# ToDo: create

# Disk usage check
#Host: tom
#Filesystem                         Size  Used Avail Use% Mounted on
#udev                               3.9G     0  3.9G   0% /dev
#tmpfs                              788M  1.2M  787M   1% /run
#/dev/sda3                          6.9G  4.8G  1.7G  75% /
#tmpfs                              3.9G     0  3.9G   0% /dev/shm
#tmpfs                              5.0M  8.0K  5.0M   1% /run/lock
#/dev/mapper/tom--vg-lv--tom--home   22G   13G  8.9G  59% /home
#/dev/mapper/tom--vg-lv--tom--temp   11G  100K   11G   1% /tmp
#/dev/mapper/tom--vg-lv--tom--var   553G   97G  429G  19% /var
#/dev/sda2                          488M  149M  303M  34% /boot
#tmpfs                              788M   44K  788M   1% /run/user/1000
#
#Host: toad
#Filesystem                     Size  Used Avail Use% Mounted on
#udev                           3.9G     0  3.9G   0% /dev
#tmpfs                          791M  736K  790M   1% /run
#/dev/mapper/vg--root-lv--root   22G  3.5G   17G  17% /
#tmpfs                          3.9G     0  3.9G   0% /dev/shm
#tmpfs                          5.0M     0  5.0M   0% /run/lock
#/dev/mapper/vg--home-lv--home   77G  7.5G   69G  10% /home
#/dev/sdb1                      275M  110M  153M  42% /boot
#/dev/mapper/vg--srv-lv--srv    512G   19G  494G   4% /srv
#tmpfs                          791M     0  791M   0% /run/user/1000
#
#Host: yoshi
#Filesystem                  Size  Used Avail Use% Mounted on
#udev                        3.9G     0  3.9G   0% /dev
#tmpfs                       794M  8.7M  785M   2% /run
#/dev/mapper/yoshi--vg-root  9.9G  2.9G  6.5G  31% /
#tmpfs                       3.9G     0  3.9G   0% /dev/shm
#tmpfs                       5.0M     0  5.0M   0% /run/lock
#/dev/sda1                   455M  110M  321M  26% /boot
#/dev/mapper/yoshi--vg-home   18G  3.1G   14G  18% /home
#/dev/sdb1                   586G   21G  536G   4% /srv/prod
#tmpfs                       794M     0  794M   0% /run/user/1000
#
