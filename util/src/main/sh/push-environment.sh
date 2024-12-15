#!/usr/bin/env zsh
### Push Environment Variables to GitHub Actions as Outputs
# GitHub workflows don't support global environment variables.
# To work around this, we use a GitHub Action Step outputs.
#
# See https://docs.github.com/en/actions/learn-github-actions/contexts#environment-variables
# See https://docs.github.com/en/actions/learn-github-actions/workflow-commands-for-github-actions#setting-an-output
#
# Exit 7: Sourcing the action library failed.
#

setopt nounset

# ===================================== This Script Functions ==========================================================

### source_dependencies
#
# Sources the common and info/debug action libraries.
#
# Sourcing the action libraries is critical to the proper functioning of the script.
# This function ensures that the action libraries are sourced and their variables are
# available to the script.
#
# Exit 7: Sourcing the action library failed.
function source_dependencies() {
  local root,lib_common
  echo "::group::Sourcing Dependencies: Agent host $(hostname) - $(date +%H:%M:%S)"
  root=$(git rev-parse --show-toplevel)
  if [[ ! -d "$root" ]]; then
    echo "::error file=push-environment.sh,line=28::Agent host $(hostname): Cannot source clone of the repository! Please investigate your workflow configuration.";
    echo "::endgroup::"
    exit 7
  fi

  lib_common="$root/util/src/main/sh/actions-library-common.sh"
  lib_debugs="$root/util/src/main/sh/actions-library-info-debug.sh"

  [[ -f "$lib_common" ]] && source "$root/util/src/main/sh/actions-library-common.sh"
  [[ -f "$lib_debugs" ]] && source "$root/util/src/main/sh/actions-library-info-debug.sh"

  if [[ -v tick ]]; then
    echo "::notice file=push-environment.sh,line=37::Agent host $(hostname): tick=$tick."
  else
    echo "::error file=push-environment.sh,line=39::Agent host $(hostname): tick is not defined. Please check your sourcing of the action library."
    return 7
  fi
  if [[ -v ghenvir_file ]]; then
    echo "::notice file=push-environment.sh,line=41::Agent host $(hostname): ghenvir_file=$ghenvir_file."
  else
    echo "::error file=push-environment.sh,line=14::Agent host $(hostname): ghenvir_file is not defined. Please check your sourcing of the action library."
    return 7
  fi
  if [[ -v summary_file ]]; then
    echo "::notice file=push-environment.sh,line=43::Agent host $(hostname): summary_file=$summary_file."
  else
    echo "::error file=push-environment.sh,line=15::Agent host $(hostname): summary_file is not defined. Please check your sourcing of the action library."
    return 7
  fi

  echo "::notice file=push-environment.sh,line=17::Agent host $(hostname): Dependencies loaded at $(date +%H:%M:%S) for $(hostname)."
  echo "::endgroup::"
  return 0
}

### publish_GH_env
#
# Publish the STEP environment data to the GitHub environment file.
# shellcheck disable=SC1073
# shellcheck disable=SC1058
# shellcheck disable=SC1072
# shellcheck disable=SC1009
function publish_GH_env() {
  {
    local -A kv=${1:-()}
    for k v in "${(@kv)kv}"; do
      echo "${k:-nil}=${v:-nil}"
    done
  } >> "$ghenvir_file"
}

### publish_GH_summary
#
# Publish the STEP summary data to the GitHub summary file.
function publish_GH_summary() {
  {
    echo -e "# Push Workflow Global Configuration\n"
    echo "<details>"
    echo
    echo "<summary>Configuration:</summary>"
    echo
    echo " - Restriction: $restriction"
    echo " - Progression: $progression"
    echo
    echo "</details>"
    echo
  } >> "$summary_file"
}

#====================================== This Script Main Function ======================================================

### main
#
# The main function of this script.
function main() {

  echo "In Main!"

#  [[ "$debug_info_run" == "true" ]] && notice && print_debug_info
#
#  bootstrapSDK
#
#  if [[ -f "$ghenvir_file" ]]; then publish_GH_env
#  else echo "::warning file=push-environment.sh,line=62::GitHub environment file $ghenvir_file is inoperable."; fi
#
#  if [[ -f "$summary_file" ]]; then publish_GH_summary
#  else echo "::error file=push-environment.sh,line=62::GitHub summary file $summary_file is inoperable."; fi
}

#====================================== This Script Run ================================================================


restriction="UNSET"                                                                                                     # Default to no restriction in case value is not set
progression=-1                                                                                                          # Default to invalid value in case value is not set
production_run=${1:-false}                                                                                              # Whether to run in production mode, passed parameter
debug_info_run=${2:-true}                                                                                               # Whether to run in debug mode, passed parameter
parameter_restriction=${3:-'none'}                                                                                      # Restriction extracted from the environment
parameter_progression=${4:-0}                                                                                           # Progression extracted from the environment
environment_restriction=${transient_restriction:-'none'}                                                                # Restriction passed as a parameter
environment_progression=${transient_progression:-0}                                                                     # Progression passed as a parameter

[[ "$environment_restriction" != "none" ]] && restriction=$environment_restriction                                      # If the environment restriction is set, use it
[[ "$environment_progression" != -1 ]] && progression=$environment_progression                                          # If the environment progression is set, use it
[[ "$parameter_restriction" != "none" ]] && restriction=$parameter_restriction                                          # If the parameter restriction is PASSES, overwrite all and use it
[[ "$parameter_progression" != 0 ]] && progression=$parameter_progression                                               # If the parameter progression is valid, overwrite all and use it

if source_dependencies; then

  echo "::group::Environment Export: Bootstrap: Agent host $(hostname) - $(date +%H:%M:%S)"
  # Production is ALWAYS on Linux and Development is ALWAYS on MacOS
  [[ "Darwin" == "$(uname)" ]] && production_run=false && echo "::notice file=push-environment.sh,line=24::Running in development mode."
  if production_run; then
    echo "::notice file=push-environment.sh,line=26::Running in production mode."
  fi

  [[ "$debug_info_run" == "true" ]] && notice && print_debug_info



else

  echo "::error file=push-environment.sh,line=34::Sourcing the action library failed."
  echo "::endgroup::"
  exit 7

fi

echo "::group::Environment Export for $(hostname) - $(date +%H:%M:%S)"
main
echo "::endgroup::"
