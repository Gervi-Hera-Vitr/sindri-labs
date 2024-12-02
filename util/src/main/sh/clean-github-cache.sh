#!/usr/bin/env zsh

gh extension install actions/gh-actions-cache

echo "::notice file=clean-github-cache.sh,line=5::Checking if any global actions caches are stale."

production_run=${1:-true}
[[ "Darwin" == "$(uname)" ]] && production_run=false && echo "::notice file=clean-github-cache.sh,line=8::Running in development mode. Skipping prune actions."
echo -e "==> production_run=$production_run\n\n"

typeset -a cacheKeys && { while IFS='' read -r key; do cacheKeys+=("$key"); done < <(gh actions-cache list --limit 30 | cut -f 1); }
typeset -a cacheKeysToPrune && cacheKeysToPrune=("${cacheKeys[@]:3}")
typeset -a successfulPrunes && successfulPrunes=()
typeset -a failedPrunes && failedPrunes=()
typeset -a retainedCaches && retainedCaches=("${cacheKeys[@]:0:3}")
typeset -a pruningLogs && pruningLogs=()
echo "::notice file=clean-github-cache.sh,line=17::Processing ${#cacheKeysToPrune[@]} cache keys from ${#cacheKeys[@]} total on $(hostname)."

if [[ "$production_run" != "true" ]]; then
  echo -e "==> Cache Keys Count: ${#cacheKeys[@]}"
  echo -e "==> Cache Keys To Prune Count: ${#cacheKeysToPrune[@]}"
  echo -e "==> Retained Caches Count: ${#retainedCaches[@]}"
  echo -e "==> Successful Prunes Count: ${#successfulPrunes[@]}"
  echo -e "==> Failed Prunes Count: ${#failedPrunes[@]}"
  echo -e "==> Pruning Logs Count: ${#pruningLogs[@]}"
  echo -e "\n"
fi


if [[ ${#cacheKeysToPrune[@]} -eq 0 ]]; then
  echo "::notice file=clean-github-cache.sh,line=31::No stale caches found"
  {
    echo -e "# Cache Prune Skipped\n\n"
    echo
    echo "_There are not any stale caches to prune. Done on $(hostname)._"
    echo
    echo "_Please reach out to the [Gervi Héra Vitr](https://github.com/Gervi-Hera-Vitr) organization members for more information._"
    echo
  }  >> "$GITHUB_STEP_SUMMARY"
else
  set +e
  for cacheKey in "${cacheKeysToPrune[@]}"; do
    [[ "$production_run" != "true" ]] && echo "==> Processing cache key $cacheKey"

    outcome="noop"
    if [[ "$production_run" != "true" ]]; then
      outcome="Would have asked to deleted cache key $cacheKey"
    elif outcome=$(gh actions-cache delete "$cacheKey" --confirm); then
      echo "::notice file=clean-github-cache.sh,line=49::Successfully deleted cache key $cacheKey"
      successfulPrunes+=("$cacheKey")
    else
      echo "::warning file=clean-github-cache.sh,line=52::Failed to delete cache key $cacheKey"
      failedPrunes+=("$cacheKey")
      retainedCaches+=("$cacheKey")
    fi
    pruningLogs+=("$outcome")
    [[ "$production_run" != "true" ]] && echo "==|> $outcome"

  done
  set -e

  if [[ ${#failedPrunes[@]} -gt 0 ]]; then
    echo "::error file=clean-github-cache.sh,line=63::Failed to delete ${#failedPrunes[@]} stale caches"
  fi

  {
  echo -e "# Cache Prune on $(hostname)\n\n"
  echo "<details>"
  echo
  echo "<summary>Result Summary:</summary>"
  echo
  echo "- **Total Caches:** ${#cacheKeys[@]}"
  echo "- **Stale Caches:** ${#cacheKeysToPrune[@]}"
  echo "- **Pruned Caches:** ${#successfulPrunes[@]}"
  echo "- **Failed Prunes:** ${#failedPrunes[@]}"
  echo "- **Retained Caches:** ${#retainedCaches[@]}"
  echo "- **Log Entries:** ${#pruningLogs[@]}"
  echo "- **Itemized Log Entries:**"
  for entry in "${pruningLogs[@]}"; do
    echo "  - $entry"
  done
  echo "- **All Caches:**"
  for key in "${cacheKeys[@]}"; do
    echo "  - $key"
  done
  echo "- **Pruned Caches:**"
  for key in "${successfulPrunes[@]}"; do
    echo "  - $key"
  done
  echo "- **Retained Caches:**"
  for key in "${retainedCaches[@]}"; do
    echo "  - $key"
  done
  echo "- **Failed Prunes:**"
  for key in "${failedPrunes[@]}"; do
    echo "  - $key"
  done
  echo "</details>"
  echo
  echo "_Please reach out to the [Gervi Héra Vitr](https://github.com/Gervi-Hera-Vitr) organization members for more information._"
  echo
  }  >> "$GITHUB_STEP_SUMMARY"

  echo "::notice file=clean-github-cache.sh,line=103::Stale caches are processed."
fi

if [[ "$production_run" != "true" ]]; then
  echo -e "==== Outcome ====\n"
  echo "$outcome"
  echo -e "==== Listed Caches ====\n"
  for aKey in "${cacheKeys[@]}"; do
      echo "  - $aKey"
  done
  echo -e "==== Pruned Caches ====\n"
  for aKey in "${cacheKeysToPrune[@]}"; do
      echo "  - $aKey"
  done
  echo -e "==== Retained Caches ====\n"
  for aKey in "${retainedCaches[@]}"; do
      echo "  - $aKey"
  done
  echo -e "==== Pruning Logs ====\n"
  for aLog in "${pruningLogs[@]}"; do
      echo "  - $aLog"
  done
  echo -e "==== Status ====\n"
  cat "$GITHUB_ENV"
fi
