#!/usr/bin/env zsh
set -uo pipefail
declare -i MAX_PARALLEL=${MAX_PARALLEL:-100}

readonly repository="${REPO:-$(basename "$(git rev-parse --show-toplevel)")}"
readonly branch="${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}"
echo "::notice title=Workflow Runs Pruner::Starting GH CLI pruning run for <$repository>"
echo "::notice title=Active Branch Detected::<$branch>"

declare -a workflows
declare -a runs_to_prune

function acquire_workflows_to_process() {
  local -i workflow_count=0
  local -r debug="${1:-off}"

  echo "::group::Acquire workflows to inspect."
  local -r workflows_as_text="$(gh workflow list --json id,name,path,state -q '.[] | [ .id, .name, .path, .state ] | @csv')"
  while IFS= read -r workflow_row; do
    IFS=',' read -r workflow_id workflow_name workflow_path workflow_state <<< "${workflow_row//}"
    [[ "$debug" == "on" ]] && echo "::debug title=Reading a Workflow row::Workflow $workflow_name with ID $workflow_id in state $workflow_state and at path  $workflow_path."
    if [[ -z "${workflow_id// }" ]]; then
      echo "::notice title=NOOP::Workflow $workflow_name has an empty ID that makes no sense. Skipping it!"
    else
      workflows+=("$workflow_id|$workflow_name|$workflow_path|$workflow_state")
      ((workflow_count++))
    fi
  done <<< "$workflows_as_text"
  echo "::notice title=Acquired Workflows::There are $workflow_count workflows to process."
  echo "::endgroup::"
}

function prepare_workflows_to_process() {
  local -i runs_count=0 workflow_runs_count=0
  local -r debug="${1:-off}"

  echo "::group::Prepare workflows to inspect."
  for workflow_row in "${workflows[@]}"; do
    IFS='|' read -r workflow_id workflow_name workflow_path workflow_state <<< "${workflow_row//\"/}"
    echo "::notice title=Reading runs for $workflow_name::Extracting all but one runs for $workflow_state workflow with id $workflow_id and path $workflow_path."

    if ! executed_runs_text="$(gh run list --workflow="$workflow_id" --json databaseId --limit 1000 | jq -r '.[1:][]?.databaseId')"; then
      echo "::error title=Run Query Failed::Could not query runs for workflow $workflow_name"
      continue
    fi

    while IFS= read -r run_row; do
      (( runs_count++ ))
      if [[ -n "${run_row//}" ]]; then
        run_entry="$run_row|$workflow_name"
        runs_to_prune+=("$run_entry")
        (( workflow_runs_count++ ))
        echo "::notice title=Queued::$run_entry."
      fi
    done <<< "${executed_runs_text}"
  done

  echo "::notice title=Prepared workflow runs::Total $runs_count rows processed and $workflow_runs_count queued to prune."
  echo "::endgroup::"
}

function process_workflows_to_process() {
  local -r debug="${1:-off}"
  local -i requests_count=0
  echo "::group::Processing deletion requests."
  for run_delete_request in "${runs_to_prune[@]}"; do
    IFS='|' read -r run_id run_workflow_name <<< "$run_delete_request"
    if [[ -n "${run_id// }" ]]; then
      (( requests_count++ ))
      (
        gh run delete "$run_id"
        echo "::notice title=Deleted::$run_id of $run_workflow_name"
      ) &
      if (( requests_count % MAX_PARALLEL == 0 )); then
        wait
      fi
    fi
  done
  wait
  echo "::endgroup::"
}

function main() {
  acquire_workflows_to_process "${1:-off}"
  prepare_workflows_to_process "${2:-on}"
  process_workflows_to_process "${3:-off}"
}

main "$@"
