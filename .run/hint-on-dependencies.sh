#!/usr/bin/env zsh

# shellcheck source=SDKMAN_INIT
[[ -s "$SDKMAN_INIT" ]] && source "$SDKMAN_INIT"
gradle --info --build-cache --no-daemon processDependencyUpdates
