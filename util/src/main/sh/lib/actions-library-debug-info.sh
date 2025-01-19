#!/usr/bin/env zsh

### Function Declarations for the script push-environment.sh               ###
#----------------------------------------------------------------------------#
#                                                                            #
# - environment_notice                                                       #
# - print_debug_info                                                         #
#                                                                            #
#----------------------------------------------------------------------------#

### environment_notice
#
# Prints the notice about how global environment variables are handled in
# GitHub Actions.
#
# Example of the method how job returns are used to expose the environment
# -----------------------------------------------------------------------
#     outputs:
#       run_classification: something from the environment
#       run_progression: something from the environment
# -----------------------------------------------------------------------
#
function environment_notice() {

  cat <<EOF
  =======================================================================
  Push Workflow Global Configuration
  =======================================================================
  Since GitHub hasn't implemented global shared environment variables,
  we must use GitHub Actions Steps to set them globally for all jobs.
  Also, shared workflows referenced with 'uses' do not have access to
  environment variables set in the current workflow.
  To work around this, we use a GitHub Action Step to set environment
  variables other workflows rely on as outputs in the current workflow.

  Example (yaml):
  -----------------------------------------------------------------------
    outputs:
      run_classification: something from the environment
      run_progression: something from the environment
  -----------------------------------------------------------------------
  The following run step only exists in the current workflow to make it
  valid and uses the opportunity to examine the behavior of GitHub
  Actions in a runtime setting.

  This job with its outputs will usually be the first jub in the pipeline.
  The values can then be used in other workflows as
  needs.shared-global-variables.outputs.run_classification
  for example.

  =======================================================================
EOF

}

### print_debug_info
#
# Debug printout of the environment and parameter values.
#
# This is useful during development to understand the behavior of the
# workflow.
#
# The variables are grouped into the following categories:
#
# * GitHub Workflow
# * GitHub Action
# * Runner and Host
# * Feature Data
#
# The rules of cardinality are:
#
# * Environment trumps defaults.
# * Parameter trumps environment.
  # shellcheck disable=SC2154
# shellcheck disable=SC1009,SC1073,SC1058,SC1072
function print_debug_info() {
  local -Ar tracked_parameters=(
    [tick]=tick
    [production_run]=${production_run:-ERROR}
   )
  echo -e "===========================================  Tracked Parameters  ==========================================="
  for k v in "${(@kv)tracked_parameters}"; do
    printf "  %-40s: %-60s\n" "$k" "$v"
  done
#  echo "==> production_run=${production_run:-ERROR} at $tick"
#  echo "==> summary_file=$summary_file"
#  echo "==> ghenvir_file=$ghenvir_file"
#  echo "==> parameter_restriction=${parameter_restriction:- NOT SET }"
#  echo "==> parameter_progression=$parameter_progression"
#  echo "==> environment_restriction=$environment_restriction"
#  echo "==> environment_progression=$environment_progression"
#  echo "==> restriction=$restriction"
#  echo "==> progression=$progression"
#  echo -e "\n\n"
#  echo "======== Rules of Cardinality ========"
#  echo " - Environment trumps defaults."
#  echo " - Parameter trumps environment."
#  echo -e "=======================================\n\n"
#  echo "======== Environment Variables ========"
#  echo " - **GitHub Workflow**:"
#  echo "   - GITHUB_JOB=$GITHUB_JOB"
#  echo "   - GITHUB_EVENT_NAME=$GITHUB_EVENT_NAME"
#  echo "   - GITHUB_EVENT_PATH=$GITHUB_EVENT_PATH"
#  echo "   - GITHUB_WORKFLOW=$GITHUB_WORKFLOW"
#  echo "   - GITHUB_RUN_ID=$GITHUB_RUN_ID"
#  echo "   - GITHUB_RUN_NUMBER=$GITHUB_RUN_NUMBER"
#  echo "   - GITHUB_RETENTION_DAYS=$GITHUB_RETENTION_DAYS"
#  echo "   - GITHUB_RUN_ATTEMPT=$GITHUB_RUN_ATTEMPT"
#  echo " - **GitHub Action**:"
#  echo "   - INVOCATION_ID=$INVOCATION_ID"
#  echo "   - GITHUB_ACTION=$GITHUB_ACTION"
#  echo "   - GITHUB_ACTOR=$GITHUB_ACTOR"
#  echo "   - GITHUB_ACTOR_ID=$GITHUB_ACTOR_ID"
#  echo "   - GITHUB_TRIGGERING_ACTOR=$GITHUB_TRIGGERING_ACTOR"
#  echo " - **Runner and Host**:"
#  echo "   - USER=$USER"
#  echo "   - RUNNER_TRACKING_ID=$RUNNER_TRACKING_ID"
#  echo "   - SHELL=$SHELL"
#  echo "   - SHLVL=$SHLVL"
#  echo "   - LANG=$LANG"
#  echo "   - RUNNER_OS=$RUNNER_OS"
#  echo "   - RUNNER_ARCH=$RUNNER_ARCH"
#  echo "   - RUNNER_NAME=$RUNNER_NAME"
#  echo "   - RUNNER_ENVIRONMENT=$RUNNER_ENVIRONMENT"
#  echo "   - RUNNER_TOOL_CACHE=$RUNNER_TOOL_CACHE"
#  echo "   - RUNNER_TEMP=$RUNNER_TEMP"
#  echo "   - RUNNER_WORKSPACE=$RUNNER_WORKSPACE"
#  echo "   - OLDPWD=$OLDPWD"
#  echo "   - ARCHFLAGS=$ARCHFLAGS"
#  echo "   - RUNNER_HOME=$RUNNER_HOME"
#  echo "   - RUNNER_BIN=$RUNNER_BIN"
#  echo "   - RUNNER_VAR=$RUNNER_VAR"
#  echo " - **Feature Data:**:"
#  # shellcheck disable=SC2154
#  echo "   - classification=$classification"
#  echo "   - transient_restriction=$transient_restriction"
#  echo "   - transient_progression=$transient_progression"
#  echo -e "=======================================\n"
#  echo "======== GITHUB_ENV Variables =========="
#  if [[ -f "$ghenvir_file" ]]; then
#    cat "$ghenvir_file"
#  else
#    echo "GITHUB_ENV does not exist."
#  fi
  echo -e "=======================================\n"
}

#echo "::notice file=actions-library-info-debug.sh,line=141::Actions library Info and Debug functions loaded at $(date +%H:%M:%S) for $(hostname)."