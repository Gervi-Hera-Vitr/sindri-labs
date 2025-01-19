#!/usr/bin/env zsh
# shellcheck disable=SC1009,SC1058,SC1072,SC1073,SC2034,SC2120,SC2155
# SC1009: `zsh` specific syntax; False positive: Double-brace directive;
# SC1058: `zsh` specific syntax; False positive: Source path can't begin with a space;
# SC1072: `zsh` specific syntax; False positive: ;

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
integer -x _index_bootstrapped=0

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
function is_at_root_of_repo() {
  (( _index_is_at_root_of_repo++ ))

  # Acquire arguments
  local -r working_directory=$(pwd)
  local -r reported_repo_root=$(git rev-parse --show-toplevel 2> /dev/null)

  # If last action directory trace exists then set it to this action directory
  if [[ -v _actions_commons_debug_last_directory ]]; then
    _actions_commons_debug_last_directory="$working_directory <is_at_root_of_repo>"
  fi

  [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['is_at_root_of_repo . working_directory']="($((_index_is_at_root_of_repo))) file://$working_directory" ['is_at_root_of_repo . reported_repo_root']="($((_index_is_at_root_of_repo))) file://$reported_repo_root" )

  if [[ "$working_directory" == "$reported_repo_root" ]]; then
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
  wf_repo_root=$(git rev-parse --show-toplevel 2> /dev/null)
  wf_folder="$wf_repo_root/.github/workflows"

  [[ -v _actions_commons_debug_last_directory ]] && _actions_commons_debug_last_directory="$wf_repo_root <has_github_workflow_folder>"
  [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['has_github_workflow_folder . wf_repo_root']="($((_index_has_github_workflow_folder))) file://$wf_repo_root" ['has_github_workflow_folder . wf_folder']="($((_index_has_github_workflow_folder))) file://$wf_folder" )

  if [[ -d "$wf_folder" ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['has_github_workflow_folder . status']="($((_index_has_github_workflow_folder))) true" ['has_github_workflow_folder . return_code']="($((_index_has_github_workflow_folder))) 0" )
    return 0
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['has_github_workflow_folder . status']="($((_index_has_github_workflow_folder))) false" ['has_github_workflow_folder . return_code']="($((_index_has_github_workflow_folder))) 11" )
    return 11
  fi
}


## Compound functions:


### Determine if the job is fully bootstrapped in THIS workflow.
#
# Returns 0 if fully bootstrapped.
#
# A fully bootstrapped agent is one which has:
# - shared variables initialized
# - shared functions loaded
# - caller's root directory is at the root of the repository
function bootstrapped() {
  (( _index_bootstrapped++ ))

  [ ! $# -gt 0 ] && echo "::error file=actions-library-common.sh,line=208::Usage: bootstrapped <caller_root> [debug]" >&2 && return 77

  # Acquire arguments
  local action_pass=true
  local -A checks_passed=( )
  local -a causes_of_failure=( )

  local -r working_directory=$(pwd)
  local -r caller=$(basename "$0")
  local -r debug=${2:-false}

  # Is working directory in a git repository?
  if is_git_repo &> /dev/null; then
    # In Git repo now, so set base root
    [[ "$debug" == "true" ]] && echo "|--> ... working folder is in a git repo"
    local -r ghw_repo_root=$(git rev-parse --show-toplevel 2> /dev/null)
    # Set caller root passed as passed or to the root of repo
    local -r caller_root_passed=${1:-$ghw_repo_root}
    local temporarily_resolved_caller_root=$(realpath "$caller_root_passed" 2> /dev/null)
    # Is caller root a real directory? - then resolve to it
    if [[ -d "$temporarily_resolved_caller_root" ]]; then
      [[ "$debug" == "true" ]] && echo "|--> ... caller root is a directory"
      local -r caller_root=$temporarily_resolved_caller_root
      local -r caller_root_resolved=$temporarily_resolved_caller_root
      [[ "$debug" == "true" ]] && echo "|==> working directory Git Root and caller root are both set"
    else  # unset caller root so the check later fails if specified path
      echo "|--> ... caller root is NOT a directory"
      local -r caller_root=''
      local -r caller_root_resolved=''
      [[ "$debug" == "true" ]] && echo "|==> working directory Git Root is set, caller root is NOT set"
    fi
    unset temporarily_resolved_caller_root
  else
    # Not in Git repo now - see if caller root is in a git repo
    echo "|--> ... working folder is NOT in a git repo"
    local -r caller_root_passed=$1
    local temporarily_resolved_caller_root=$(realpath "$caller_root_passed" 2> /dev/null)
    if [[ -d "$temporarily_resolved_caller_root" ]]; then
      # If passed root is a directory which resolves see if it's in a git repo
      echo "|--> ... caller root is a directory"
      pushd "$temporarily_resolved_caller_root" &> /dev/null || exit 11
      if is_git_repo &> /dev/null; then
        echo "|--> ... caller root is in a git repo while working directory is NOT in a git repo"
        local -r ghw_repo_root=$(git rev-parse --show-toplevel 2> /dev/null)
        local -r caller_root_resolved=$ghw_repo_root
        local -r caller_root=$temporarily_resolved_caller_root
        echo "|==> Git Root is set TO caller root Git Root"
      else
        echo "|--> ... caller root AND working directory are NOT in a git repo"
        echo "|==> No Git Projects found: Terminating useless request."
        return 17
      fi
    else
      echo "|--> ... caller root is NOT a directory while working directory is NOT in a git repo"
      echo "|==> No Git Projects found: Terminating useless request."
      return 19
    fi
    unset temporarily_resolved_caller_root
  fi

  if [[ $debug == "true" ]]; then
    local -Ar debug_header_information=( \
      ['debug']="$debug" \
      ['caller']="$caller" \
      ['caller_root']="$caller_root" \
      ['caller_root_resolved']="$caller_root_resolved" \
      ['working_directory']="$working_directory" \
      ['ghw_repo_root']="$ghw_repo_root" )

    echo "::group::bootstrapped of Common Functions; $(hostname), $(basename "$working_directory"); $( [[ "$caller_root_resolved" == "$working_directory" ]] && echo "stays" || echo "shifts")."
    echo
    echo "================================================= INIT (bootstrapped): Acquiring arguments =================="
    for k v ("${(@kv)debug_header_information}") printf "INIT  (bootstrapped): %-25s: %-60s\n" "$k" "$v"
    echo "-------------------------------------------------------------------------------------------------------------"
  fi

  [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( \
  ['bootstrapped . ghw_repo_root']="($((_index_bootstrapped))) file://$ghw_repo_root" \
  ['bootstrapped . caller']="($((_index_bootstrapped))) $caller" \
  ['bootstrapped . caller_root']="($((_index_bootstrapped))) file://$caller_root" \
  ['bootstrapped . caller_root_resolved']="($((_index_bootstrapped))) file://$caller_root_resolved" )

  if [[ "$ghw_repo_root" == "$caller_root_resolved" ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_root']="($((_index_bootstrapped))) PASS" )
    checks_passed+=( ['at repository root']="PASS: $ghw_repo_root" )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: Detected root vs. caller specified root"
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_root']="($((_index_bootstrapped))) FAIL" )
    action_pass=false
    causes_of_failure+=( "repo root mismatch: git root $ghw_repo_root vs. caller specified root $caller_root_resolved" )
    checks_passed+=( ['at repository root']="FAIL: Detected root vs. caller specified root" )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: Detected root is $ghw_repo_root vs. caller specified root $caller_root"
  fi

  if [[ "$caller" == "bootstrapped" ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_caller']="($((_index_bootstrapped))) PASS" )
    checks_passed+=( ['caller']="PASS: $caller" )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: Detected caller"
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_caller']="($((_index_bootstrapped))) UNKNOWN caller is $caller" )
    checks_passed+=( ['caller']="UNEXPECTED: Detected caller is $caller" )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): UNKNOWN: Detected caller is $caller"
  fi

  if has_github_workflow_folder; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_workflow_folder']="($((_index_bootstrapped))) PASS" )
    checks_passed+=( ['has_github_workflow_folder']="PASS" )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: Detected workflow folder"
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_workflow_folder']="($((_index_bootstrapped))) FAIL" )
    action_pass=false
    causes_of_failure+=( "GitHub workflow folder not detected" )
    checks_passed+=( ['has_github_workflow_folder']="FAIL" )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: Detected workflow folder"
  fi

  if [[ -v SDKMAN_INIT ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman_standard']="($((_index_bootstrapped))) PASS: Standard configuration detected." )
    checks_passed+=( ['sdkman_standard']="PASS: Standard Agent <SDKMAN_INIT> $SDKMAN_INIT" )

    if [[ -f "$SDKMAN_INIT" ]]; then
      [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman_standard_file']="($((_index_bootstrapped))) PASS" )
      checks_passed+=( ['sdkman_standard_file']="PASS: Standard Agent <SDKMAN_INIT> $SDKMAN_INIT" )
      [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: Standard Agent <SDKMAN_INIT> $SDKMAN_INIT is present"
    else
      [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman_standard_file']="($((_index_bootstrapped))) FAIL" )
      action_pass=false
      causes_of_failure+=( "Standard Agent <SDKMAN_INIT> $SDKMAN_INIT is declared but NOT present" )
      checks_passed+=( ['sdkman_standard_file']="FAIL: Standard Agent <SDKMAN_INIT> $SDKMAN_INIT" )
      [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: Standard Agent <SDKMAN_INIT> $SDKMAN_INIT is declared but NOT present"
    fi
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman_standard']="($((_index_bootstrapped))) UNKNOWN: Standard configuration is not detected (local or development?)" )
    checks_passed+=( ['sdkman_standard']="UNKNOWN: Standard Agent <SDKMAN_INIT> $SDKMAN_INIT" )


    if [[ -f "$SDKMAN_INIT_DEFAULT" ]]; then
      [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman_default_file']="($((_index_bootstrapped))) PASS" )
      checks_passed+=( ['sdkman_default_file']="PASS: Standard Agent <SDKMAN_INIT_DEFAULT> $SDKMAN_INIT_DEFAULT" )

      if [[ -f "$SDKMAN_INIT_DEFAULT" ]]; then
        [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman_default_file']="($((_index_bootstrapped))) PASS" )
        checks_passed+=( ['sdkman_default_file_alternative']="PASS: Standard Agent <SDKMAN_INIT_DEFAULT> $SDKMAN_INIT_DEFAULT" )
        [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: Standard Agent <SDKMAN_INIT_DEFAULT> $SDKMAN_INIT_DEFAULT is present"
      else
        [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman_default_file']="($((_index_bootstrapped))) FAIL" )
        action_pass=false
        causes_of_failure+=( "Standard Agent <SDKMAN_INIT_DEFAULT> $SDKMAN_INIT_DEFAULT is declared but NOT present" )
        checks_passed+=( ['sdkman_default_file_alternative']="FAIL: Standard Agent <SDKMAN_INIT_DEFAULT> $SDKMAN_INIT_DEFAULT" )
        [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: Standard Agent <SDKMAN_INIT_DEFAULT> $SDKMAN_INIT_DEFAULT is NOT present"
      fi

    else
      [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman_default_file']="($((_index_bootstrapped))) FAIL" )
      checks_passed+=( ['sdkman_default_file']="FAIL: Standard Agent <SDKMAN> (All): <SDKMAN_INIT> and <SDKMAN_INIT_DEFAULT> are NOT DECLARED" )

      if [[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
        [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman']="($((_index_bootstrapped))) PASS-WARNING: <SDKMAN> is found at $HOME/.sdkman/bin but NOT DECLARED in $SDKMAN_INIT_DEFAULT or $SDKMAN_INIT configurations" )
        checks_passed+=( ['sdkman']="PASS-WARNING: <SDKMAN> is found at $HOME/.sdkman/bin but NOT DECLARED in $SDKMAN_INIT_DEFAULT or $SDKMAN_INIT configurations" )
        [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): PASS-WARNING: <SDKMAN> is found at $HOME/.sdkman/bin but NOT DECLARED in <SDKMAN_INIT_DEFAULT> or <SDKMAN_INIT> configurations"
      else
        [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_sdkman']="($((_index_bootstrapped))) FAIL" )
        action_pass=false
        causes_of_failure+=( "<SDKMAN> (All): <SDKMAN_INIT> or <SDKMAN_INIT_DEFAULT> or $HOME/.sdkman/bin are NOT FOUND" )
        checks_passed+=( ['sdkman']="FAIL: <SDKMAN> (All): <SDKMAN_INIT> or <SDKMAN_INIT_DEFAULT> or $HOME/.sdkman/bin are NOT FOUND" )
        [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: <SDKMAN> (All): <SDKMAN_INIT> or <SDKMAN_INIT_DEFAULT> or $HOME/.sdkman/bin are NOT FOUND"
      fi
    fi
  fi

  if [[ -v GITHUB_STEP_SUMMARY ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_github_step_summary']="($((_index_bootstrapped))) PASS" )
    checks_passed+=( ['github_step_summary']="PASS: Standard Agent <GH Summary> $GITHUB_STEP_SUMMARY." )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: Standard Agent <GITHUB_STEP_SUMMARY> $GITHUB_STEP_SUMMARY is present"
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_github_step_summary']="($((_index_bootstrapped))) NOT running in GitHub Action" )
    checks_passed+=( ['github_step_summary']="WARNING: Standard Agent <GITHUB_STEP_SUMMARY> $GITHUB_STEP_SUMMARY is not set (NOT running in GitHub Action)" )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): WARNING: Standard Agent <GITHUB_STEP_SUMMARY> $GITHUB_STEP_SUMMARY is not set (NOT running in GitHub Action)."
  fi

  if [[ -v summary_file && -f "$summary_file" ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_summary_file']="($((_index_bootstrapped))) PASS" )
    checks_passed+=( ['summary_file']="PASS: Standard Agent <Summary> $summary_file." )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: Standard Agent <summary_file> $summary_file is present"
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_summary_file']="($((_index_bootstrapped))) FAIL" )
    action_pass=false
    causes_of_failure+=( "Standard Agent <summary_file> $summary_file is NOT present and is ALWAYS expected" )
    checks_passed+=( ['summary_file']="FAIL: Standard Agent <Summary> $summary_file." )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: Standard Agent <summary_file> $summary_file is NOT present and is ALWAYS expected"
  fi

  if [[ -v GITHUB_ENV ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_github_env']="($((_index_bootstrapped))) PASS" )
    checks_passed+=( ['github_env']="PASS: Standard Agent <GH Env> $GITHUB_ENV." )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: Standard Agent <GITHUB_ENV> $GITHUB_ENV is present"
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_github_env']="($((_index_bootstrapped))) NOT running in GitHub Action" )
    checks_passed+=( ['github_env']="WARNING: Standard Agent <GITHUB_ENV> $GITHUB_ENV is not set (NOT running in GitHub Action." )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): WARNING: Standard Agent <GITHUB_ENV> $GITHUB_ENV is not set (NOT running in GitHub Action)"
  fi

  if [[ -f "$ghenvir_file" ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_ghenvir_file']="($((_index_bootstrapped))) PASS" )
    checks_passed+=( ['ghenvir_file']="PASS: Standard Agent <GH Env> $ghenvir_file." )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: Standard Agent <ghenvir_file> $ghenvir_file is present"
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_ghenvir_file']="($((_index_bootstrapped))) FAIL" )
    action_pass=false
    causes_of_failure+=( "Standard Agent <ghenvir_file> $ghenvir_file is NOT present and is ALWAYS expected" )
    checks_passed+=( ['ghenvir_file']="FAIL: Standard Agent <GH Env> $ghenvir_file." )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: Standard Agent <ghenvir_file> $ghenvir_file is NOT present and is ALWAYS expected"
  fi

  if [[ -v this_branch ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_this_branch']="($((_index_bootstrapped))) PASS" )
    checks_passed+=( ['this_branch']="PASS: Standard Agent <Branch> $this_branch." )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: <this_branch> $this_branch is set"
  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_this_branch']="($((_index_bootstrapped))) FAIL" )
    action_pass=false
    checks_passed+=( ['this_branch']="FAIL: Standard Agent <Branch> $this_branch." )
    causes_of_failure+=( "<this_branch> $this_branch is NOT set" )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: <this_branch> $this_branch is NOT set"
  fi

  if [[ -v this_project ]]; then
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_this_project']="($((_index_bootstrapped))) PASS" )
    checks_passed+=( ['this_project']="PASS: <Project Directory> is set to  $this_project." )

    if [[ -d "$this_project" ]]; then
      [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_this_project_directory']="($((_index_bootstrapped))) PASS" )
      checks_passed+=( ['this_project_directory']="PASS: <Project Directory> exists at $this_project." )
      [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): OK: <this_project_directory> $this_project is present"
    else
      [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_this_project_directory']="($((_index_bootstrapped))) FAIL" )
      action_pass=false
      checks_passed+=( ['this_project_directory']="FAIL: <Project Directory> NOT SET $this_project." )
      causes_of_failure+=( "<this_project_directory> $this_project is set BUT NOT present and is ALWAYS expected" )
      [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: <this_project_directory> $this_project is NOT present and is ALWAYS expected"
    fi

  else
    [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_this_project']="($((_index_bootstrapped))) FAIL" )
    action_pass=false
    checks_passed+=( ['this_project']="FAIL: <Project Directory> is NOT SET $this_project." )
    causes_of_failure+=( "<this_project> is NOT set $this_project " )
    [[ "$debug" == "true" ]] && echo "DEBUG (bootstrapped): FAIL: <this_project> is NOT set $this_project"
  fi

  if [[ -v _actions_commons_debug_log && "$debug" == "true" ]]; then
    {
      echo '............................................  internal (bootstrap) trace ....................................'
      for k v ("${(@kv)_actions_commons_debug_log}") printf "  %-50s: %-70s\n" "$k" "$v"
      echo '............................................. internal (bootstrap) checks ...................................'
      for k v ("${(@kv)checks_passed}") printf "  %-50s: %-70s\n" "$k" "$v"
      echo '.............................................................................................................'
    } &> /dev/tty
  fi

  [[ -v _actions_commons_debug_log ]] && _actions_commons_debug_log+=( ['bootstrapped . status_action_pass']="($((_index_bootstrapped))) $action_pass" )
  [[ -v _actions_commons_debug_last_directory ]] && _actions_commons_debug_last_directory="$caller_root_resolved <bootstrapped>"

  if $action_pass; then
    return 0
  else
    {
      echo '............................................. Failure Causes (bootstrap) ....................................'
      for v ("${(@)causes_of_failure}") printf "  %  -  40s: $v\n"
      echo '.............................................................................................................'
    } &> /dev/tty
    return 7
  fi
}

#echo "::notice file=actions-library-common.sh,line=97::Actions library Common functions loaded at $(date +%H:%M:%S) for $(hostname)."