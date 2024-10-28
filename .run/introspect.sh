#!/usr/bin/env zsh

# GitHub private Runner Specific Configuration: SDKMAN
SDKMAN_DIR="$HOME/.sdkman"
SDKMAN_BIN="$SDKMAN_DIR/bin"
SDKMAN_INIT="$SDKMAN_BIN/sdkman-init.sh"
SDKMAN_JAVA=$(readlink "$SDKMAN_DIR.sdkman/candidates/java/current")


if [[ -s "$SDKMAN_INIT" ]]; then
  echo -e "\n\nFound standard Gervi Héra Vitr GitHub Action Runner!\n"
  export JDK_HOME=$SDKMAN_JAVA
  export PATH="$PATH:$SDKMAN_DIR:$JDK_HOME/bin"
else
  echo "This is not a standard Gervi Héra Vitr GitHub Action Runner"
fi

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
