#!/usr/bin/env zsh
setopt RCS LOGIN

source "$HOME/.zprofile"
source "$HOME/.zshenv"
 # shellcheck source=SDKMAN_INIT
[[ -s "$SDKMAN_INIT" ]] && source "$SDKMAN_INIT"

if [ -z "${GITHUB_ENV+xxx}" ]; then
  echo -e "WARNING: GITHUB_ENV !! file !! is NOT set!";
else
  echo -e "GITHUB_ENV File is: $GITHUB_ENV";
fi


cat <<EOF

======================== Introspection ========================
| Running Dependency Check on Agent Environment               |
|                                                             |
| ------------------------------------------------------------|
|
EOF

gradle --info --build-cache --no-daemon dependencyUpdates

echo "|"
echo "==============================================================="
exit 0
