#!/usr/bin/env zsh

# Explanation for working with SDKMAN and similar tools that only operate through shared public functions.
# In essence, the sha-bang above spawns a subshell. Thus to use the SDKMAN functions correctly and ordinarily,
# we need to source it. There are ways of using parent shell functions without sourcing, however, doing so
# deviates SDK MAN's philosophy of always sourcing the SDKMAN shell scripts in ana active subshell.

SDKMAN_INIT_DEFAULT=~/.sdkman/bin/sdkman-init.sh

[[ -f "$SDKMAN_INIT_DEFAULT" ]] || {
  echo "SDKMAN_INIT_DEFAULT=$SDKMAN_INIT_DEFAULT does not exist."
  exit 1
}

direct_use_attempt=$(sdk c 2>&1)
echo -e "Before sourcing SDKMAN, we get this: ($direct_use_attempt).\n"

echo "While sourcing SDKAMAN via SDKMAN_INIT_DEFAULT=$SDKMAN_INIT_DEFAULT; We get:"
echo "=========================================================================================="
# shellcheck source=SDKMAN_INIT
source "$SDKMAN_INIT_DEFAULT"
echo "=========================================================================================="

echo "After sourcing SDKMAN, we get:"
direct_use_attempt=$(sdk c 2>&1)
echo -e "... $direct_use_attempt"
