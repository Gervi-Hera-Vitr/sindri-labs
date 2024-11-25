#!/usr/bin/env zsh

# shellcheck source=SDKMAN_INIT
[[ -s "$SDKMAN_INIT" ]] && source "$SDKMAN_INIT"

echo "::notice file=clean-gradle-cache.sh,line=6::Agent host $(hostname): Running 'gradle clean'"

if [[ -v SDKMAN_INIT ]]; then
  echo "::notice file=clean-gradle-cache.sh,line=9::Agent host $(hostname): SDK bootstrapped by $SDKMAN_INIT";
else
  echo "::error file=clean-gradle-cache.sh,line=11::Agent host $(hostname): Does not provide SDK bootstrapping!";
fi

# Check if Gradle cache directory exists
GRADLE_CACHE_DIR="$HOME/.gradle/caches"

if [ -d "$GRADLE_CACHE_DIR" ]; then
  echo "::notice file=clean-gradle-cache.sh,line=18::Gradle cache directory exists. Proceeding to clean it."

  # Iterate over subdirectories and print each folder size before removing it
  for folder in "$GRADLE_CACHE_DIR"/*; do
    folder_size=$(du -sh "$folder" 2>/dev/null | cut -f1)
    echo "::notice file=clean-gradle-cache.sh,line=22::Deleting folder $folder (Size: $folder_size)"
    rm -rf "$folder"
  done

  echo "::notice file=clean-gradle-cache.sh,line=25::Gradle cache cleanup completed."
else
  echo "::notice file=clean-gradle-cache.sh,line=27::Gradle cache directory does not exist. No cleanup needed."
fi
