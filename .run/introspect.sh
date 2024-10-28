#!/usr/bin/env zsh

set -euo pipefail

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
