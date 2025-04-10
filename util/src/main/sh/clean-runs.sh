#!/usr/bin/env zsh

# Check if the current directory is a git repository.
#
# Returns 0 if the current directory is a git repository, 1 otherwise.
function is_git_repo() {
  git rev-parse --is-inside-work-tree &> /dev/null
  return $?
}

##
# Check if the current repository has the `.github/workflows` folder.
#
# Returns 0 if the folder exists, 11 otherwise.
function has_github_workflow_folder() {
    local repository_root;
    local github_workflow_folder;
    repository_root=$(git rev-parse --show-toplevel)
    github_workflow_folder="$repository_root/.github/workflows"

    if [ -d "$github_workflow_folder" ]; then
      return 0
    else
      return 11
    fi
}

##
# Check if the current working directory is at the root of the git repository.
#
# This is necessary because the cleanup scripts expect  run from the root
# of the repository, since it's cleaning up the entire repository unscoped.
#
# Returns 0 if the current working directory is at the root of the repository,
# 3 if it's not.
function is_at_root_of_repo() {
  if [ "$(pwd)" = "$(git rev-parse --show-toplevel)" ]; then
    return 0
  else
    return 3
  fi
}

on_branch="${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}"
on_restriction="${RESTRICTION:-no-restriction-provided}"
echo "::notice file=clean-runs.sh,line=46::Agent host $(hostname): Running on branch $on_branch with restriction $on_restriction";

if ! is_git_repo; then
  cat <<EOF
=========================================
ERROR: Current directory is NOT in a git repository.

- This script must be run from a GitHub git repository.
=========================================
EOF
  echo "::error file=clean-runs.sh,line=56::Agent host $(hostname): Current directory is NOT in a git repository! Please investigate your workflow configuration.";
  exit 7
fi
echo "::notice file=clean-runs.sh,line=59::Agent host $(hostname): Current directory is a healthy git repository.";

if ! has_github_workflow_folder; then
  cat <<EOF
=========================================
ERROR: No GitHub Workflow directory found.

- The .github/workflows directory must exist at its root.
=========================================
EOF
  echo "::error file=clean-runs.sh,line=69::Agent host $(hostname): No GitHub Workflow directory found! Please investigate your workflow configuration.";
  exit 11
fi
echo "::notice file=clean-runs.sh,line=72::Agent host $(hostname): GitHub Workflow directory found.";

if ! is_at_root_of_repo; then
  cat <<EOF
=========================================
WARNING: Not at root of repository.

Running 'gh' operations from subdirectories is not recommended.
=========================================
EOF
  echo "::warning file=clean-runs.sh,line=82::Agent host $(hostname): Not at root of repository. Running 'gh' operations from subdirectories is not recommended.";
fi
echo "::notice file=clean-runs.sh,line=84::Agent host $(hostname): Running 'gh' operations from root of repository."

#workflows_text=$(gh workflow list --json id,name,path,state -q '.[] | [ .id, .name, .path, .state ] | @csv')
workflows_text=$(gh workflow list --json id,name -q '.[] | select(.name != "Local Build Only") | [.id, .name] | @csv')

cat <<EOF
=========================================
INFO: Storing workflow details in workflows.csv
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

  if [[ -z "${workflow_id// }" ]]; then
    echo -e "\tAll good!"
    echo "::notice file=clean-runs.sh,line=109::Agent host $(hostname): Workflows have no runs to clean up.";
  else
    echo -e "\n\nProcessing workflow: $workflow_name (ID: $workflow_id)"

    # Get all runs for this workflow, sorted by created date descending, skipping the first run
    # shellcheck disable=SC2034
    run_ids_text=$(gh run list --workflow="$workflow_id" --json databaseId --limit 500 -q '.[1:] | .[].databaseId')
    # shellcheck disable=SC2296
    run_ids=("${(f)run_ids_text}")

    # Delete all but the latest run
    for run_id in "${run_ids[@]}"; do
      if [[ -z "${run_id// }" ]]; then
        echo -e "\tAll good:\t Workflow $workflow_name has no runs to clean up!"
        echo "::notice file=clean-runs.sh,line=123::Agent host $(hostname): Workflow $workflow_name has no runs to clean up.";
      else
        echo "Deleting run ID: $run_id for workflow: $workflow_name"
        gh run delete "$run_id"
        echo "::notice file=clean-runs.sh,line=127::Agent host $(hostname): Deleted run ID: $run_id for workflow: $workflow_name"
      fi
    done
  fi
done
