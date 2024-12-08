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
env
echo -e "=======================================\n\n"
echo "======== GITHUB_ENV Variables =========="
if [[ -f "$ghenvir_file" ]]; then
  cat "$ghenvir_file"
else
  echo "GITHUB_ENV does not exist."
fi
echo -e "=======================================\n\n"

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
