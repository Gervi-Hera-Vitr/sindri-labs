#!/usr/bin/env zsh

tick="$(date +%Y_%m_%d_%H_%M_%S)"
summary_file="$GITHUB_STEP_SUMMARY"
ghenvir_file="$GITHUB_ENV"

production_run=${1:-true}
restriction="UNSET"
progression=-1
parameter_restriction=${2:-'none'}
parameter_progression=${3:-0}
environment_restriction=${transient_restriction:-'none'}
environment_progression=${transient_progression:-0}

if [[ "$environment_restriction" != "none" ]]; then
  restriction=$environment_restriction
fi
if [[ "$environment_progression" != -1 ]]; then
  progression=$environment_progression
fi

if [[ "$parameter_restriction" != "none" ]]; then
  restriction=$parameter_restriction
fi
if [[ "$parameter_progression" != 0 ]]; then
  progression=$parameter_progression
fi

[[ "Darwin" == "$(uname)" ]] && production_run=false && echo "::notice file=hint-on-dependencies.sh,line=10::Running in development mode. Skipping prune actions."

echo "==> production_run=$production_run at $tick"
echo "==> summary_file=$summary_file"
echo "==> ghenvir_file=$ghenvir_file"
echo "==> parameter_restriction=$parameter_restriction"
echo "==> parameter_progression=$parameter_progression"
echo "==> environment_restriction=$environment_restriction"
echo "==> environment_progression=$environment_progression"
echo "==> restriction=$restriction"
echo "==> progression=$progression"
echo -e "\n\n"
echo "======== Rules of Cardinality ========"
echo " - Environment trumps defaults."
echo " - Parameter trumps environment."
echo -e "=======================================\n\n"
echo "======== Environment Variables ========"
echo " - **GitHub Workflow**:"
echo "   - GITHUB_JOB=$GITHUB_JOB"
echo "   - GITHUB_EVENT_NAME=$GITHUB_EVENT_NAME"
echo "   - GITHUB_EVENT_PATH=$GITHUB_EVENT_PATH"
echo "   - GITHUB_WORKFLOW=$GITHUB_WORKFLOW"
echo "   - GITHUB_RUN_ID=$GITHUB_RUN_ID"
echo "   - GITHUB_RUN_NUMBER=$GITHUB_RUN_NUMBER"
echo "   - GITHUB_RETENTION_DAYS=$GITHUB_RETENTION_DAYS"
echo "   - GITHUB_RUN_ATTEMPT=$GITHUB_RUN_ATTEMPT"
echo " - **GitHub Action**:"
echo "   - INVOCATION_ID=$INVOCATION_ID"
echo "   - GITHUB_ACTION=$GITHUB_ACTION"
echo "   - GITHUB_ACTOR=$GITHUB_ACTOR"
echo "   - GITHUB_ACTOR_ID=$GITHUB_ACTOR_ID"
echo "   - GITHUB_TRIGGERING_ACTOR=$GITHUB_TRIGGERING_ACTOR"
echo " - **Runner and Host**:"
echo "   - USER=$USER"
echo "   - RUNNER_TRACKING_ID=$RUNNER_TRACKING_ID"
echo "   - SHELL=$SHELL"
echo "   - SHLVL=$SHLVL"
echo "   - LANG=$LANG"
echo "   - RUNNER_OS=$RUNNER_OS"
echo "   - RUNNER_ARCH=$RUNNER_ARCH"
echo "   - RUNNER_NAME=$RUNNER_NAME"
echo "   - RUNNER_ENVIRONMENT=$RUNNER_ENVIRONMENT"
echo "   - RUNNER_TOOL_CACHE=$RUNNER_TOOL_CACHE"
echo "   - RUNNER_TEMP=$RUNNER_TEMP"
echo "   - RUNNER_WORKSPACE=$RUNNER_WORKSPACE"
echo "   - OLDPWD=$OLDPWD"
echo "   - ARCHFLAGS=$ARCHFLAGS"
echo "   - RUNNER_HOME=$RUNNER_HOME"
echo "   - RUNNER_BIN=$RUNNER_BIN"
echo "   - RUNNER_VAR=$RUNNER_VAR"
echo " - **Feature Data:**:"
# shellcheck disable=SC2154
echo "   - classification=$classification"
echo "   - transient_restriction=$transient_restriction"
echo "   - transient_progression=$transient_progression"
echo -e "=======================================\n"
echo "======== GITHUB_ENV Variables =========="
if [[ -f "$ghenvir_file" ]]; then
  cat "$ghenvir_file"
else
  echo "GITHUB_ENV does not exist."
fi
echo -e "=======================================\n"

if [[ "$production_run" == "true" && -f "$ghenvir_file" ]]; then
  {
    echo "step_restriction=$restriction"
    echo "step_progression=$progression"
  } >> "$ghenvir_file"
else
  echo "::warning file=push-environment.sh,line=62::GitHub environment file $ghenvir_file is inoperable."
fi

if [[ "$production_run" == "true" && -f "$summary_file" ]]; then
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
else
  echo "::error file=push-environment.sh,line=62::GitHub summary file $summary_file is inoperable."
fi
