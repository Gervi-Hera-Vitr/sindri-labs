#!/usr/bin/env zsh
# shellcheck disable=SC1009,SC1073,SC1058,SC1072
autoload colors; colors
typeset -r run_only_composite_functions=false

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

if [[ "$run_only_composite_functions" == "true" ]]; then

  echo -e "\nCatalog INFO: Skipping unit functions!\n"

else

  echo
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "|------------------------------------------   is_git_repo           ------------------------------------------|"
  echo "---------------------------------------------------------------------------------------------------------------"

  check_is_git_repo=$(is_git_repo . true 2>&1)
  echo "$check_is_git_repo"
  if is_git_repo &> /dev/null; then
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
  fi
  pushd .. &> /dev/null || exit 11
  _actions_commons_debug_last_directory="NOT SET"
  if is_git_repo &> /dev/null; then
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
  fi
  popd &> /dev/null || exit 13
  pushd docs &> /dev/null || exit 11
  _actions_commons_debug_last_directory="NOT SET"
  if is_git_repo &> /dev/null; then
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
  fi
  popd &> /dev/null || exit 13
  _actions_commons_debug_last_directory="NOT SET"
  if is_git_repo .. true &> /dev/null; then
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
  fi
  _actions_commons_debug_last_directory="NOT SET"
  if is_git_repo "docs" false &> /dev/null; then
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_git_repo): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_git_repo): false ==> file://$_actions_commons_debug_last_directory"
  fi
  if [[ -v _actions_commons_debug_log ]]; then
    {
      echo '......................................... catalog functions trace: is_git_repo ............................'
      for k v ("${(@kv)_actions_commons_debug_log}") printf "  %-40s: %-60s\n" "$k" "$v"
      echo '...........................................................................................................'
    } &> /dev/tty
  fi
  echo -e "\n\n"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "|------------------------------------------   is_at_root_of_repo    ------------------------------------------|"
  echo "---------------------------------------------------------------------------------------------------------------"
  _actions_commons_debug_last_directory="NOT SET"
  if is_at_root_of_repo; then
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_at_root_of_repo): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_at_root_of_repo): false ==> file://$_actions_commons_debug_last_directory"
  fi
  _actions_commons_debug_last_directory="NOT SET"
  pushd .. &> /dev/null || exit 11
  if is_at_root_of_repo &> /dev/null; then
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_at_root_of_repo): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_at_root_of_repo): false ==> file://$_actions_commons_debug_last_directory"
  fi
  is_at_root_of_repo &> /dev/null || numeric_response=$?
  if [[ $numeric_response == 2 ]]; then
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_at_root_of_repo): failure code is $numeric_response"
  elif [[ $numeric_response == 1 ]]; then
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_at_root_of_repo): failure code is $numeric_response - misidentified as a child directory"
  elif [[ $numeric_response == 0 ]]; then
      echo "$fg_bold[red]|X| Catalog FAIL$reset_color -: (is_at_root_of_repo): failure code is $numeric_response - misidentified as at repository root"
  else
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_at_root_of_repo): failure code is $numeric_response - unknown error"
  fi
  popd &> /dev/null || exit 13
  _actions_commons_debug_last_directory="NOT SET"
  pushd docs &> /dev/null || exit 11
  if is_at_root_of_repo; then
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_at_root_of_repo): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_at_root_of_repo): false ==> file://$_actions_commons_debug_last_directory"
  fi
  is_at_root_of_repo &> /dev/null || numeric_response=$?
  if [[ $numeric_response == 1 ]]; then
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (is_at_root_of_repo): failure code is $numeric_response"
  else
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (is_at_root_of_repo): failure code is $numeric_response"
  fi
  popd &> /dev/null || exit 13
  if [[ -v _actions_commons_debug_log ]]; then
    {
      echo '......................................... catalog functions trace: is_at_root_of_repo .....................'
      for k v ("${(@kv)_actions_commons_debug_log}") printf "  %-40s: %-60s\n" "$k" "$v"
      echo '...........................................................................................................'
    } &> /dev/tty
  fi
  echo -e "\n\n"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "|------------------------------------------   has_github_workflow_folder    ----------------------------------|"
  echo "---------------------------------------------------------------------------------------------------------------"
  _actions_commons_debug_last_directory="NOT SET"
  if has_github_workflow_folder; then
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (has_github_workflow_folder): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (has_github_workflow_folder): false ==> file://$_actions_commons_debug_last_directory"
  fi
  _actions_commons_debug_last_directory="NOT SET"
  pushd util &> /dev/null || exit 11
  echo "==> $(pwd)"
  if has_github_workflow_folder &> /dev/null; then
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (has_github_workflow_folder): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (has_github_workflow_folder): false ==> file://$_actions_commons_debug_last_directory"
  fi
  popd &> /dev/null || exit 13
  _actions_commons_debug_last_directory="NOT SET"
  pushd docs &> /dev/null || exit 11
  echo "==> $(pwd)"
  if has_github_workflow_folder; then
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (has_github_workflow_folder): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (has_github_workflow_folder): false ==> file://$_actions_commons_debug_last_directory"
  fi
  popd &> /dev/null || exit 13
  _actions_commons_debug_last_directory="NOT SET"
  pushd .. &> /dev/null || exit 11
  echo "==> $(pwd)"
  if has_github_workflow_folder; then
    echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (has_github_workflow_folder): true  ==> file://$_actions_commons_debug_last_directory"
  else
    echo "$fg_bold[green]|V| Catalog pass$reset_color - (has_github_workflow_folder): false ==> file://$_actions_commons_debug_last_directory"
  fi
  if [[ -v _actions_commons_debug_log ]]; then
    {
      echo '......................................... catalog functions trace: has_github_workflow_folder .............'
      for k v ("${(@kv)_actions_commons_debug_log}") printf "  %-40s: %-60s\n" "$k" "$v"
      echo '...........................................................................................................'
    } &> /dev/tty
  fi
  popd &> /dev/null || exit 13

fi

echo -e "\n"
echo "---------------------------------------------------------------------------------------------------------------"
echo "|------------------------------------------   bootstrapped    ------------------------------------------------|"
echo "---------------------------------------------------------------------------------------------------------------"
_actions_commons_debug_last_directory="NOT SET"
_actions_commons_debug_log=()
if bootstrapped . true; then
  echo "$fg_bold[green]|V| Catalog pass$reset_color - (bootstrapped): true ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
else
  echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (bootstrapped): false ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
fi
echo "|------------------------------------------   bootstrapped - child directory   -------------------------------|"
_actions_commons_debug_last_directory="NOT SET"
_actions_commons_debug_log=()
pushd util &> /dev/null || exit 11
if bootstrapped . false; then
  echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (bootstrapped): true ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
else
  echo "$fg_bold[green]|V| Catalog pass$reset_color - (bootstrapped): false ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
fi
if bootstrapped .. false; then
  echo "$fg_bold[green]|V| Catalog pass$reset_color - (bootstrapped): true ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
else
  echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (bootstrapped): false ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
fi
popd &> /dev/null || exit 13
echo "|------------------------------------------   bootstrapped - deep child defaults   ---------------------------|"
_actions_commons_debug_last_directory="NOT SET"
_actions_commons_debug_log=()
pushd util/src/main/sh/local &> /dev/null || exit 11
if bootstrapped . false; then
  echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (bootstrapped): true ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
else
  echo "$fg_bold[green]|V| Catalog pass$reset_color - (bootstrapped): false ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
fi
if bootstrapped '' false; then
  echo "$fg_bold[green]|V| Catalog pass$reset_color - (bootstrapped): true ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
else
  echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (bootstrapped): false ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
fi
popd &> /dev/null || exit 13

echo "|------------------------------------------   bootstrapped - bellow repository root   ------------------------|"
_actions_commons_debug_last_directory="NOT SET"
_actions_commons_debug_log=()
pushd .. &> /dev/null || exit 11
if bootstrapped . false; then
  echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (bootstrapped): true ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
else
  echo "$fg_bold[green]|V| Catalog pass$reset_color - (bootstrapped): false ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
fi
if bootstrapped '' false; then
  echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (bootstrapped): true ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
else
  echo "$fg_bold[green]|V| Catalog pass$reset_color - (bootstrapped): false ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
fi
if bootstrapped google-ai-labs true; then
  echo "$fg_bold[green]|V| Catalog pass$reset_color - (bootstrapped): true ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
else
  echo "$fg_bold[red]|X| Catalog FAIL$reset_color - (bootstrapped): false ==> specifying file://$_actions_commons_debug_last_directory in location $(pwd)"
fi
popd &> /dev/null || exit 13

echo "|.............................................................................................................|"
echo "==============================================================================================================="
echo

cat <<EOF
=======================================================================================================================
INFO: Loading actions-library-debug-info.sh
-----------------------------------------------------------------------------------------------------------------------
EOF
source "${project_root_directory}/util/src/main/sh/lib/actions-library-debug-info.sh"

echo -e "\n\n"
echo "-----------------------------------------------------------------------------------------------------------------"
echo "|-------------------------------------------     environment_notice     ----------------------------------------|"
echo "-----------------------------------------------------------------------------------------------------------------"
environment_notice

echo "-----------------------------------------------------------------------------------------------------------------"
echo "|-------------------------------------------     print_debug_info     ------------------------------------------|"
echo "-----------------------------------------------------------------------------------------------------------------"
original_unset_option_value=false
if [[ -o nounset ]]; then
  original_unset_option_value=true
  echo "INFO: Option nounset is forced by default in this shell session - unsetting."
  setopt unset
else
    echo "INFO: Option nounset is not forced by default in this shell session."
fi
setopt nounset
(){
  print_debug_info
}
if [[ $original_unset_option_value == true ]]; then
  setopt nounset
  echo "INFO: Setting option nounset BACK to $original_unset_option_value ."
else
  echo "INFO: Option nounset does not need to be reset."
fi

