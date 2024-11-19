#!/usr/bin/env zsh

# shellcheck source=SDKMAN_INIT
if [[ -s "$SDKMAN_INIT" ]]; then
  source "$SDKMAN_INIT"
  echo "::warning file=introspect.sh,line=6::Agent host $(hostname) is SDK bootstrapped by $SDKMAN_INIT";
else
  echo "::error file=introspect.sh,line=8::Agent host $(hostname) does not provide SDK bootstrapping and MUST use Actions to provide required SDKs!";
fi


if [ -z "${GITHUB_ENV+xxx}" ]; then
  echo -e "WARNING: GITHUB_ENV !! file !! is NOT set!\n... exporting.";
  export GITHUB_ENV="";
  echo "::error file=introspect.sh,line=16::Agent host $(hostname) does not provide GitHub Environment file!";
else
  echo -e "GITHUB_ENV File is: $GITHUB_ENV";
  echo "::warning file=introspect.sh,line=19::Agent host $(hostname) bootstraps GitHub Environment file $GITHUB_ENV";
fi


if [ -z "$GITHUB_ENV" ] && [ "${GITHUB_ENV+xxx}" = "xxx" ]; then
  echo -e "\nWARNING:\n\tGITHUB_ENV is set but empty!\n... creating.\n";
  local_temp_folder="$HOME/tmp";
  mkdir -p "$local_temp_folder";
  export GITHUB_ENV="$local_temp_folder/github_env.local";
  echo -e "GITHUB_ENV File is: $GITHUB_ENV";
  echo "::error file=introspect.sh,line=29::Agent host $(hostname) GitHub Environment is UNREACHABLE to Actions Runner and is simulated at $GITHUB_ENV!";
fi


cat <<EOF

======================== Introspection ========================
| Checking Agent for local Java and Gradle installations      |
|                                                             |
| Expecting the following environment SDKs to be installed:   |
| - JDK:    21 Temurin                                        |
| - Gradle: 8.10                                              |
| ------------------------------------------------------------|
EOF


if [[ $$- == *l* ]]; then
    echo -e "| login shell OK                                              |"
    echo -e "| ------------------------------------------------------------|\n|"
    echo "::warning file=introspect.sh,line=46::Agent host $(hostname) offered a full login shell.";
else
    echo -e "| ERROR: NOT a login shell! Provision login shell environment |"
    echo -e "| ------------------------------------------------------------|\n|"
    echo "::warning file=introspect.sh,line=50::Agent host $(hostname) DID NOT offer a login shell! => Please, refrain from using a login shell dependent magic.";
fi


# Check for Java 21.0
JAVA_VERSION_INSTALLED=$(java -version 2>&1 | grep -o '21\.0' | head -1)
echo -e "| Java version installed:   \t$JAVA_VERSION_INSTALLED"
if [[ $JAVA_VERSION_INSTALLED =~ 21.0 ]]; then
  echo "java_correct=true" >> "$GITHUB_ENV"
  echo "JAVA_HOME=$JAVA_HOME" >> "$GITHUB_ENV"
  echo -e "| Java 21: \t\t\tOK"
  echo "::warning file=introspect.sh,line=62::Agent host $(hostname): JDK $JAVA_VERSION_INSTALLED is locally available.";
else
  echo "java_correct=false" >> "$GITHUB_ENV"
  echo -e "| Java 21: \t\t\tFAILED"
  echo "::error file=introspect.sh,line=66::Agent host $(hostname): JDK 21 is NOT locally available.";
fi
echo "| ------------------------------------------------------------|"


# Check for Gradle 8.10
GRADLE_VERSION_INSTALLED=$(gradle --version 2>&1 | grep -o '8\.10')
echo -e "| Gradle version installed: \t$GRADLE_VERSION_INSTALLED"
if [[ $GRADLE_VERSION_INSTALLED =~ 8.10 ]]; then
  echo "gradle_correct=true" >> "$GITHUB_ENV"
  echo "GRADLE_HOME=$GRADLE_HOME" >> "$GITHUB_ENV"
  echo -e "| Gradle 8.10: \t\t\tOK"
  echo "::warning file=introspect.sh,line=77::Agent host $(hostname): Gradle $GRADLE_VERSION_INSTALLED is locally available.";
else
  echo "gradle_correct=false" >> "$GITHUB_ENV"
  echo -e "| Gradle 8.10: \t\t\tFAILED"
  echo "::error file=introspect.sh,line=81::Agent host $(hostname): Gradle 8.10 is NOT locally available.";
fi
echo "| ------------------------------------------------------------|"
echo "| File contents:                                              |"
echo "| ${GITHUB_ENV}"
echo "==============================================================="
exit 0
