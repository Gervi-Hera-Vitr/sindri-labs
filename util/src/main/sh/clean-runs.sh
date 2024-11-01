#!/usr/bin/env zsh

#workflows_text=$(gh workflow list --json id,name,path,state -q '.[] | [ .id, .name, .path, .state ] | @csv')
workflows_text=$(gh workflow list --json id,name -q '.[] | select(.name != "Dependabot Updates") | [.id, .name] | @csv')

cat <<EOF

Storing workflow details in workflows.csv
=========================================
EOF
tee workflows.csv <<<"$workflows_text"
cat <<EOF
=========================================

EOF

# shellcheck disable=SC2296
workflows=("${(f)workflows_text}")

for workflow_row in "${workflows[@]}"; do
  IFS=, read -rA workflow <<< "$workflow_row"
  workflow_id=${workflow[1]}
  workflow_name=${workflow[2]}

  echo -e "\n\nProcessing workflow: $workflow_name (ID: $workflow_id)"

  # Get all runs for this workflow, sorted by created date descending, skipping the first run
  # shellcheck disable=SC2034
  run_ids_text=$(gh run list --workflow="$workflow_id" --json databaseId --limit 500 -q '.[1:] | .[].databaseId')
  # shellcheck disable=SC2296
  run_ids=("${(f)run_ids_text}")

  # Delete all but the latest run
  for run_id in "${run_ids[@]}"; do
    echo "Deleting run ID: $run_id for workflow: $workflow_name"
    gh run delete "$run_id"
  done
done

