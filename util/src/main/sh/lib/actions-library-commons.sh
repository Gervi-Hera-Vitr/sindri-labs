#!/usr/bin/env zsh
# shellcheck disable=SC2034
# shellcheck disable=SC2155
### GitHub Actions library: common functions and shared variables.
#
# Conventions:
# - Exported workflow variables are prefixed with `action_`.
# - Exported workflow functions are named in snake_case by meaning.
# - Exported system or context variables defaults postfix with `_default`.
# - Exported system or context variables OVERRIDES postfix with `_override`.
# - DEBUG is always the LAST argument passed to all functions (default: false).
#
# Exported variables:
#   SDKMAN_INIT_DEFAULT - Default SDKMAN initialization script where it would be expected to be found on the Agent.
#   summary_file - Local handle to GitHub Step Summary
#   ghenvir_file - Local handle to GitHub Environment
#   this_branch - Current branch name
#   this_project - Current project directory
#   tick - Timestamp of the current step
#
# Exported functions:
#   is_git_repo - Check if the current directory is a git repository.
#   is_at_root_of_repo - Check if the current working directory is at the root of the repository.
#   has_github_workflow_folder - Check if the current repository has the `.github/workflows` folder.
#

integer -x _index_is_git_repo=0
integer -x _index_is_at_root_of_repo=0
integer -x _index_has_github_workflow_folder=0

export -r tick="$(date +%Y_%m_%d_%H_%M_%S)"

# Global variables used by all actions
export -r SDKMAN_INIT_DEFAULT="$HOME/.sdkman/bin/sdkman-init.sh"                         # Default SDKMAN initialization script where it would be expected to be found on the Agent.

export -r summary_file="${GITHUB_STEP_SUMMARY:-$(mktemp)}"                               # Local handle to GitHub Step Summary
export -r ghenvir_file="${GITHUB_ENV:-$(mktemp)}"                                        # Local handle to GitHub Environment

export -r this_branch="${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}"
export -r this_project=$(git rev-parse --show-toplevel)

### Check if the current directory is a git repository.
#
# This function is a wrapper around `git rev-parse --is-inside-work-tree`.
#
# Arguments:
#   $1 - Optional folder to check in (default: current directory).
#   $2 - Optional debug flag (default: false).
#
# Returns 0 if the current directory is a git repository, 1 otherwise.
# shellcheck disable=SC2120 # zsh does not require exporting functions or variables
function is_git_repo() {
  (( _index_is_git_repo++ ))

  # Acquire arguments
  local captured_response captured_result

  local -r debug=${2:-false}
  local -r working_directory=$(pwd)
  local -r folder_shift_parameter="${1:-/}"
  local -r folder_shift_string="$working_directory/$folder_shift_parameter"
  local -r folder_shift=$(realpath "$folder_shift_string")

  local needs_pop=false

  # If last action directory trace exists then set it to this action directory
  if [[ -v _actions_commons_debug_last_directory ]]; then
    _actions_commons_debug_last_directory="$folder_shift <is_git_repo>"
  fi
  if [[ -v _actions_commons_debug_log ]]; then
    _actions_commons_debug_log+=( ['is_git_repo . working_directory']="($((_index_is_git_repo))) file://$working_directory" ['is_git_repo . folder_shift']="($((_index_is_git_repo))) file://$folder_shift" )
  fi

  if [[ $debug == "true" ]]; then
    echo "::group::is_git_repo of Common Functions; $(hostname), $(basename "$working_directory"); $( [[ "$folder_shift" == "$working_directory" ]] && echo "stays" || echo "shifts")."
    echo
    echo "================================================= DEBUG (is_git_repo): Acquiring arguments ==================="
    echo -e "DEBUG (is_git_repo): debug:\t\t\t $debug"
    echo -e "DEBUG (is_git_repo): folder_shift_parameter:\t $folder_shift_parameter"
    echo -e "DEBUG (is_git_repo): folder_shift_string:\t $folder_shift_string"
    echo -e "DEBUG (is_git_repo): folder_shift:\t\t file://$folder_shift"
    echo -e "DEBUG (is_git_repo): working_directory:\t\t file://$working_directory"
    echo -e "DEBUG (is_git_repo): current_directory:\t\t file://$PWD"
    echo -e "DEBUG (is_git_repo): resolved directory:\t file://$(pwd)"
    echo -e "DEBUG (is_git_repo): needs_pop:\t\t\t $needs_pop"
    echo "----------------------------- Commons container variables ---------------------------------------------------"
    echo -e "DEBUG (is_git_repo): SDKMAN_INIT_DEFAULT:\t file://$SDKMAN_INIT_DEFAULT"
    echo -e "DEBUG (is_git_repo): summary_file:\t\t file://$summary_file"
    echo -e "DEBUG (is_git_repo): ghenvir_file:\t\t file://$ghenvir_file"
    echo -e "DEBUG (is_git_repo): this_branch:\t\t $this_branch"
    echo -e "DEBUG (is_git_repo): this_project:\t\t file://$this_project"
    echo -e "DEBUG (is_git_repo): tick:\t\t\t $tick"
    echo "============================================================================================================="
  fi

  # Push directory if necessary
  if [[ "$folder_shift" == "$working_directory" ]]; then
    [[ $debug == "true" ]] && echo -e "DEBUG (is_git_repo):\t\t\t\t NO directory shift for: \n\t\t\t\t\t\t file://$working_directory"
  else
    [[ $debug == "true" ]] && echo -e "DEBUG (is_git_repo):\t\t\t\t Perform directory shift from: \n\t\t\t\t\t\t file://$working_directory \n\t\t\t\t\t\t to ==> file://$folder_shift."
    pushd "$folder_shift" || return 11
    needs_pop=true
  fi

  [[ $debug == "true" ]] && echo -e "DEBUG (is_git_repo):\t\t\t\t  Checking if \n\t\t\t\t\t\t file://$(pwd) \n\t\t\t\t\t\t is a git repository, having needs_pop: $needs_pop"

  # This runs, not calls, meaning it executes in the subshell
  captured_response=$(git rev-parse --is-inside-work-tree 2>&1)
  captured_result=$?

  if [[ $needs_pop == "true" ]]; then
    [[ $debug == "true" ]] && echo -e "DEBUG (is_git_repo):\t\t\t\t Pop directory from: \n\t\t\t\t\t\t file://$(pwd)"
    popd || exit 13
    [[ $debug == "true" ]] && echo -e "DEBUG (is_git_repo):\t\t\t\t Popped directory to: \n\t\t\t\t\t\t file://$(pwd)"
  else
    [[ $debug == "true" ]] && echo -e "DEBUG (is_git_repo):\t\t\t\t NO directory shift for: \n\t\t\t\t\t\t file://$working_directory"
  fi

  if [[ $debug == "true" ]]; then
    echo -e "DEBUG (is_git_repo): DONE \t\t\t command captured_response: $captured_response, captured_result: $captured_result"
    echo "============================================================================================================="
  echo "::endgroup::"
  fi

  [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['is_git_repo . captured_response']="($((_index_is_git_repo))) $captured_response" )
  return $captured_result
}

##
# Check if the current working directory is at the root of the git repository.
#
# This is necessary because the cleanup scripts expect to run from the root
# of the repository, since it's cleaning up the entire repository unscoped.
#
# Returns:
# - 0   if the 'working directory' is at the root of the repository,
# - 1   if the 'working directory' is not at the root of the repository, but is at a subfolder,
# - 2   if the 'working directory' is not at a git repository at all.
#
# shellcheck disable=SC2120
function is_at_root_of_repo() {
  (( _index_is_at_root_of_repo++ ))

  # Acquire arguments
  local -r working_directory=$(pwd)
  local -r repo_root=$(git rev-parse --show-toplevel 2> /dev/null)

  # If last action directory trace exists then set it to this action directory
  if [[ -v _actions_commons_debug_last_directory ]]; then
    _actions_commons_debug_last_directory="$working_directory <is_at_root_of_repo>"
  fi

  [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['is_at_root_of_repo . working_directory']="($((_index_is_at_root_of_repo))) file://$working_directory" ['is_at_root_of_repo . repo_root']="($((_index_is_at_root_of_repo))) file://$repo_root" )

  if [[ "$working_directory" == "$repo_root" ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['is_at_root_of_repo . status']="($((_index_is_at_root_of_repo))) true" ['is_at_root_of_repo . return_code']="($((_index_is_at_root_of_repo))) 0" )
    return 0
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['is_at_root_of_repo . status']="($((_index_is_at_root_of_repo))) false" )
  fi

  if is_git_repo &> /dev/null ; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['is_at_root_of_repo . status']="($((_index_is_at_root_of_repo))) false" ['is_at_root_of_repo . return_code']="($((_index_is_at_root_of_repo))) 1" ['is_at_root_of_repo . is_git_repo']="($((_index_is_at_root_of_repo))) true" )
    return 1
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['is_at_root_of_repo . is_git_repo']="($((_index_is_at_root_of_repo))) false" )
  fi

  [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['is_at_root_of_repo . status']="($((_index_is_at_root_of_repo))) false" ['is_at_root_of_repo . return_code']="($((_index_is_at_root_of_repo))) 2" )
  return 2
}

##
# Check if the current repository has the `.github/workflows` folder.
#
# Returns 0 if the folder exists, 11 otherwise.
function has_github_workflow_folder() {
  (( _index_has_github_workflow_folder++ ))
  repo_root=$(git rev-parse --show-toplevel 2> /dev/null)
  wf_folder="$repo_root/.github/workflows"

  [[ -v _actions_commons_debug_last_directory ]] && _actions_commons_debug_last_directory="$repo_root <has_github_workflow_folder>"
  [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['has_github_workflow_folder . repo_root']="($((_index_is_at_root_of_repo))) file://$repo_root" ['has_github_workflow_folder . wf_folder']="($((_index_is_at_root_of_repo))) file://$wf_folder" )

  if [[ -d "$wf_folder" ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['has_github_workflow_folder . status']="($((_index_is_at_root_of_repo))) true" ['has_github_workflow_folder . return_code']="($((_index_is_at_root_of_repo))) 0" )
    return 0
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['has_github_workflow_folder . status']="($((_index_is_at_root_of_repo))) false" ['has_github_workflow_folder . return_code']="($((_index_is_at_root_of_repo))) 11" )
    return 11
  fi
}


## Compound functions:


### Determine if the agent is fully bootstrapped in THIS workflow.
#
# Returns 0 if fully bootstrapped.
#
# A fully bootstrapped agent is one which has:
# - SDKMAN installed
# a valid SDKMAN initialization
# script ($SDKMAN_INIT_DEFAULT), is currently inside a git repository
# (is_git_repo), is at the root of the repository (is_at_root_of_repo), and has
# a .github/workflows folder (has_github_workflow_folder).
function bootstrapped() {


}

#echo "::notice file=actions-library-common.sh,line=97::Actions library Common functions loaded at $(date +%H:%M:%S) for $(hostname)."