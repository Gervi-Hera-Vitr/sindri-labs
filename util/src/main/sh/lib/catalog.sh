#!/usr/bin/env zsh
# shellcheck disable=SC2155

#setopt nounset
typeset -r project_root_directory=$(git rev-parse --show-toplevel)
typeset -t _actions_commons_debug_last_directory=""
integer numeric_response=-1

echo -e "\nHostname: $(hostname); OS: $(uname); User: $(whoami); Shell: $(basename "$SHELL").\n\n"

cat <<EOF
========================================================================================================================
DevOps/MLOps Actions Functions Catalog
========================================================================================================================
EOF

echo

cat <<EOF
========================================================================================================================
INFO: Loading actions-library-commons.sh
------------------------------------------------------------------------------------------------------------------------
EOF
source "${project_root_directory}/util/src/main/sh/lib/actions-library-commons.sh"
typeset _actions_commons_debug_last_directory
typeset -Ag _actions_commons_debug_log=()

echo
echo "-----------------------------------------------------------------------------------------------------------------"
echo "|-------------------------------------------     is_git_repo           -----------------------------------------|"
echo "-----------------------------------------------------------------------------------------------------------------"

check_is_git_repo=$(is_git_repo . true 2>&1)
echo "$check_is_git_repo"
if is_git_repo &> /dev/null; then
  echo "PASS (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "FAIL (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
fi
pushd .. &> /dev/null || exit 11
_actions_commons_debug_last_directory="NOT SET"
if is_git_repo &> /dev/null; then
  echo "FAIL (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "PASS (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
fi
popd &> /dev/null || exit 13
pushd docs &> /dev/null || exit 11
_actions_commons_debug_last_directory="NOT SET"
if is_git_repo &> /dev/null; then
  echo "PASS (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "FAIL (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
fi
popd &> /dev/null || exit 13
_actions_commons_debug_last_directory="NOT SET"
if is_git_repo .. true &> /dev/null; then
  echo "FAIL (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "PASS (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
fi
_actions_commons_debug_last_directory="NOT SET"
if is_git_repo "docs" false &> /dev/null; then
  echo "PASS (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "FAIL (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
fi
if [[ -v _actions_commons_debug_log ]]; then
  # shellcheck disable=SC1009
  {
    echo '............................................  trace .............................................................'
    # shellcheck disable=SC1073
    # shellcheck disable=SC1058
    # shellcheck disable=SC1072
    for k v ("${(@kv)_actions_commons_debug_log}") printf "  %-40s: %-60s\n" "$k" "$v"
    echo '.................................................................................................................'
  } &> /dev/tty
fi
echo -e "\n\n"
echo "-----------------------------------------------------------------------------------------------------------------"
echo "|-------------------------------------------     is_at_root_of_repo    -----------------------------------------|"
echo "-----------------------------------------------------------------------------------------------------------------"
_actions_commons_debug_last_directory="NOT SET"
if is_at_root_of_repo; then
  echo "PASS (is_at_root_of_repo): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "FAIL (is_at_root_of_repo): false ==> file://$_actions_commons_debug_last_directory"
fi
_actions_commons_debug_last_directory="NOT SET"
pushd .. &> /dev/null || exit 11
if is_at_root_of_repo &> /dev/null; then
  echo "FAIL (is_at_root_of_repo): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "PASS (is_at_root_of_repo): false ==> file://$_actions_commons_debug_last_directory"
fi
is_at_root_of_repo &> /dev/null || numeric_response=$?
if [[ $numeric_response == 2 ]]; then
  echo "PASS (is_at_root_of_repo): failure code is $numeric_response"
elif [[ $numeric_response == 1 ]]; then
  echo "FAIL (is_at_root_of_repo): failure code is $numeric_response - misidentified as a child directory"
elif [[ $numeric_response == 0 ]]; then
    echo "FAIL: (is_at_root_of_repo): failure code is $numeric_response - misidentified as at repository root"
else
  echo "FAIL (is_at_root_of_repo): failure code is $numeric_response - unknown error"
fi
popd &> /dev/null || exit 13
_actions_commons_debug_last_directory="NOT SET"
pushd docs &> /dev/null || exit 11
if is_at_root_of_repo; then
  echo "FAIL (is_at_root_of_repo): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "PASS (is_at_root_of_repo): false ==> file://$_actions_commons_debug_last_directory"
fi
is_at_root_of_repo &> /dev/null || numeric_response=$?
if [[ $numeric_response == 1 ]]; then
  echo "PASS (is_at_root_of_repo): failure code is $numeric_response"
else
  echo "FAIL (is_at_root_of_repo): failure code is $numeric_response"
fi
popd &> /dev/null || exit 13
if [[ -v _actions_commons_debug_log ]]; then
  # shellcheck disable=SC1009
  {
    echo '............................................  trace .............................................................'
    # shellcheck disable=SC1073
    # shellcheck disable=SC1058
    # shellcheck disable=SC1072
    for k v ("${(@kv)_actions_commons_debug_log}") printf "  %-40s: %-60s\n" "$k" "$v"
    echo '.................................................................................................................'
  } &> /dev/tty
fi
echo -e "\n\n"
echo "-----------------------------------------------------------------------------------------------------------------"
echo "|-------------------------------------------     has_github_workflow_folder    ---------------------------------|"
echo "-----------------------------------------------------------------------------------------------------------------"
_actions_commons_debug_last_directory="NOT SET"
if has_github_workflow_folder; then
  echo "PASS (has_github_workflow_folder): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "FAIL (has_github_workflow_folder): false ==> file://$_actions_commons_debug_last_directory"
fi
_actions_commons_debug_last_directory="NOT SET"
pushd util &> /dev/null || exit 11
echo "==> $(pwd)"
if has_github_workflow_folder &> /dev/null; then
  echo "PASS (has_github_workflow_folder): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "FAIL (has_github_workflow_folder): false ==> file://$_actions_commons_debug_last_directory"
fi
popd &> /dev/null || exit 13
_actions_commons_debug_last_directory="NOT SET"
pushd docs &> /dev/null || exit 11
echo "==> $(pwd)"
if has_github_workflow_folder; then
  echo "PASS (has_github_workflow_folder): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "FAIL (has_github_workflow_folder): false ==> file://$_actions_commons_debug_last_directory"
fi
popd &> /dev/null || exit 13
_actions_commons_debug_last_directory="NOT SET"
pushd .. &> /dev/null || exit 11
echo "==> $(pwd)"
if has_github_workflow_folder; then
  echo "FAIL (has_github_workflow_folder): true  ==> file://$_actions_commons_debug_last_directory"
else
  echo "PASS (has_github_workflow_folder): false ==> file://$_actions_commons_debug_last_directory"
fi
if [[ -v _actions_commons_debug_log ]]; then
  # shellcheck disable=SC1009
  {
    echo '............................................  trace .............................................................'
    # shellcheck disable=SC1073
    # shellcheck disable=SC1058
    # shellcheck disable=SC1072
    for k v ("${(@kv)_actions_commons_debug_log}") printf "  %-40s: %-60s\n" "$k" "$v"
    echo '.................................................................................................................'
  } &> /dev/tty
fi

echo

cat <<EOF
========================================================================================================================
INFO: Loading actions-library-debug-info.sh
------------------------------------------------------------------------------------------------------------------------
EOF
source "${project_root_directory}/util/src/main/sh/lib/actions-library-debug-info.sh"

echo -e "\n\n"
echo "-----------------------------------------------------------------------------------------------------------------"
echo "|-------------------------------------------     environment_notice     ----------------------------------------|"
echo "-----------------------------------------------------------------------------------------------------------------"
environment_notice

echo -e "\n\n"
echo "-----------------------------------------------------------------------------------------------------------------"
echo "|-------------------------------------------     print_debug_info     ------------------------------------------|"
echo "-----------------------------------------------------------------------------------------------------------------"
original_unset_option_value=false
if [[ -o nounset ]]; then
  original_unset_option_value=true
  echo "INFO: Option nounset is forced by default in this shell session."
fi
if [[ $original_unset_option_value == false ]]; then
  setopt nounset
  echo "INFO: Setting option nounset for 'print_debug_info' function demo invocation."
fi

(){

  print_debug_info
}
setopt unset
