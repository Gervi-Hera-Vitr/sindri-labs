#!/usr/bin/env zsh
set -uo pipefail

readonly repository="${REPO:-$(basename "$(git rev-parse --show-toplevel)")}"
readonly branch="${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}"
echo "::notice title=Workflow Runs Cache Pruner::Starting GH CLI cache pruning in <$repository>"
echo "::notice title=Active Branch is <$branch>::As in running on $branch."

function acquire_cache_ids_and_process() {

  while IFS= read -r cache_entry_row; do
    read -r id size scale ref age age_scale passe <<< "$cache_entry_row"

    if [[ "$age_scale" == "minutes" || "$age_scale" == "minute" ]]; then
      echo "::notice:: title=Skipping minutes old::$id"
    else
      echo "::debug::Attempting to delete $id::size=$size($scale),age=$age($age_scale-$passe),branch=$ref"
      set +e
      gh actions-cache delete "$id" --confirm || true
      set -e
    fi
  done < <(gh actions-cache list --order desc --limit 100)
}

acquire_cache_ids_and_process
