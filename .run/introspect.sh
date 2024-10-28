#!/usr/bin/env zsh

set -eo pipefail

# GitHub private Runner Specific Configuration
export LOCAL_BIN="$HOME/bin"
export RUNNER_HOME="$HOME/.actions"
export RUNNER_BIN="$RUNNER_HOME/bin"
export RUNNER_VAR="$HOME/var/runner"
# SDKMAN Configuration
export SDKMAN_DIR="$HOME/.sdkman"
export SDKMAN_BIN="$SDKMAN_DIR/bin"
export SDKMAN_INIT="$SDKMAN_BIN/sdkman-init.sh"

# shellcheck disable=SC2091
# shellcheck disable=SC1090
[[ -d "$RUNNER_BIN" ]] \
&& [[ -d "$SDKMAN_BIN" ]] \
&& [[ -s "$SDKMAN_INIT" ]]  \
&& $(export PATH="$PATH:$RUNNER_HOME:$RUNNER_BIN") \
&& $(source "$SDKMAN_INIT")

SDKMAN_VERSIONS=$(sdk current)
echo -e "sdkman_versions=\n\n${SDKMAN_VERSIONS}\n" >> "$GITHUB_ENV"

# Check for Java 21.0
JAVA_VERSION_INSTALLED=$(java -version 2>&1 | grep -o '21\.0')
if [[ "$JAVA_VERSION_INSTALLED" == "21.0" ]]; then
  echo "java_correct=true" >> "$GITHUB_ENV"
  echo "Java 21 is already installed"
else
  echo "java_correct=false" >> "$GITHUB_ENV"
  echo "Java 21 is not installed"
fi

# Check for Gradle 8.10
GRADLE_VERSION_INSTALLED=$(gradle --version 2>&1 | grep -o '8\.10')
if [[ "$GRADLE_VERSION_INSTALLED" == "8.10" ]]; then
  echo "gradle_correct=true" >> "$GITHUB_ENV"
  echo "Gradle 8.10 is already installed"
else
  echo "gradle_correct=false" >> "$GITHUB_ENV"
  echo "Gradle 8.10 is not installed"
fi
