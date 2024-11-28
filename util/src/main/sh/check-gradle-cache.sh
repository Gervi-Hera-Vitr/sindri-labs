#!/usr/bin/env zsh

# shellcheck source=SDKMAN_INIT
[[ -s "$SDKMAN_INIT" ]] && source "$SDKMAN_INIT"

echo "::notice file=check-gradle-cache.sh,line=6::Agent host $(hostname): Running 'gradle clean'"

if [[ -v SDKMAN_INIT ]]; then
  echo "::notice file=check-gradle-cache.sh,line=9::Agent host $(hostname): SDK bootstrapped by $SDKMAN_INIT";
else
  echo "::error file=check-gradle-cache.sh,line=11::Agent host $(hostname): Does not provide SDK bootstrapping!";
fi

# Check if Gradle cache directory exists
GRADLE_CACHE_DIR="$HOME/.gradle/caches"

if [ -d "$GRADLE_CACHE_DIR" ]; then
  echo "::notice file=check-gradle-cache.sh,line=18::Gradle cache directory exists. Proceeding to clean it."

  # Iterate over subdirectories and print each folder size before removing it
  for folder in "$GRADLE_CACHE_DIR"/*; do
    folder_size=$(du -s "$folder" 2>/dev/null | cut -f1)
    if [[ $folder_size -gt 1000000 ]]; then
      echo "::notice file=check-gradle-cache.sh,line=24::Cache folder $folder is larger than 1gB. Size: $folder_size"
    elif [[ $folder_size -gt 3000000 ]]; then
      echo "::warning file=check-gradle-cache.sh,line=26::Cache folder $folder is larger than 3gB. Size: $folder_size"
    elif [[ $folder_size -gt 5000000 ]]; then
      echo "::error file=check-gradle-cache.sh,line=28::Cache folder $folder is larger than 5gB. Size: $folder_size"
    fi
  done
else
  echo "::warning file=check-gradle-cache.sh,line=32::Gradle cache directory $GRADLE_CACHE_DIR does not exist!"
fi
