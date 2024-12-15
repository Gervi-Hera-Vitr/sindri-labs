#!/usr/bin/env zsh
### Test: GitHub Actions library: common functions and shared variables.
#
# Tested variables:
#   - SDKMAN_INIT_DEFAULT
#   - summary_file
#   - ghenvir_file
#   - this_branch
#   - this_project
#   - tick
#
# Tested Common Functions:
#   - is_git_repo
#   - is_at_root_of_repo
#   - has_github_workflow_folder
#

# Describe, Context, ExampleGroup
ExampleGroup "$SHELLSPEC_GROUP_ID: GitHub Actions library: common functions and shared variables: Variables!"

  Describe "$SHELLSPEC_GROUP_ID: Actions Lib. Common Variables"

    Include src/main/sh/lib/actions-library-commons.sh

    # It, Specify, Example
    Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): SDKMAN_INIT_DEFAULT variable is expected."
      #  empty, exist, file, directory, symlink, pipe, socket, readable, writable, executable, block, character, success, failure, valid, defined, undefined, blank, present, exported, readonly, successful
      The variable SDKMAN_INIT_DEFAULT should be defined
      The variable SDKMAN_INIT_DEFAULT should equal "$HOME"/.sdkman/bin/sdkman-init.sh
    End

    Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'summary_file' variable is ALWAYS allocated."
      The variable summary_file should be defined
      # shellcheck disable=SC2154
      The file "$summary_file" should be writable
    End

    Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'ghenvir_file' variable is ALWAYS allocated."
      The variable ghenvir_file should be defined
      # shellcheck disable=SC2154
      The file "$ghenvir_file" should be writable
    End

    Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'this_project' variable is expected set to Git repo root."
      The variable this_project should be defined
      # shellcheck disable=SC2154
      The directory "$this_project" should be a directory
    End

    Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'this_branch' variable is expected set to current branch."
      The variable this_branch should be defined
      # shellcheck disable=SC2154
      The variable "$this_branch" should be present
    End

  End

End

ExampleGroup "$SHELLSPEC_GROUP_ID: GitHub Actions library: common functions and shared variables: Functions!"

  ExampleGroup "$SHELLSPEC_GROUP_ID: Git repository related functions"

    Include src/main/sh/lib/actions-library-commons.sh

    ### Activate internal value tracing for debug purposes:
    #
    # When _actions_commons_debug_log exists and can be found
    #   through export then Commons library functions will use it.
    # Key positional and return information is written there.
    # Presence of this variable is detected in 'After' to print.
    #
    # BeforeAll - it is sufficient to bind it once; no need to clear.
    function before_commons(){
      typeset -Ax _actions_commons_debug_log=()
    }

    ### Set to see last working directory position stamped.
    #
    # Before - is a sufficient mapping.
    function before_git_ops(){
      typeset -x _actions_commons_debug_last_directory="NONE"
    }

    # shellcheck disable=SC1009
    ### Print out captured internal values for tracing Commons library execution.
    #
    # - If `_actions_commons_debug_last_directory` is exported; then it's printed.
    # - If `_actions_commons_debug_log` is exported; then it's printed.
    #
    # Internal values are written during execution of:
    #   - `is_git_repo`;
    #   -`is_at_root_of_repo`
    #   - `has_github_workflow_folder
    #   functions.
    #
    # After - is a sufficient mapping.
    function after_git_ops(){
      if [[ -v _actions_commons_debug_last_directory ]]; then
        printf "${SHELLSPEC_EXAMPLE_ID}: Last PWD: %s\n" "$_actions_commons_debug_last_directory"
      fi
      if [[ -v _actions_commons_debug_log ]]; then
        # shellcheck disable=SC1073
        # shellcheck disable=SC1058
        # shellcheck disable=SC1072
        for k v ("${(@kv)_actions_commons_debug_log}"); do
          printf "${SHELLSPEC_EXAMPLE_ID}: %-40s: %-60s\n" "$k" "$v"
        done
      fi
    }

#    BeforeAll 'before_commons'                # Uncomment to see internal debug trace
#    BeforeEach 'before_git_ops'               # Uncomment to see internal debug trace for Last PWD
    AfterEach 'after_git_ops'

    Describe "$SHELLSPEC_GROUP_ID: Function is_git_repo() tests"


      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_git_repo' function returns true (and status code 0) while in a git repo (here)"
        When call is_git_repo &> /dev/null
        The function is_git_repo should be defined
        The status should be success
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_git_repo' function returns false while not in a git repo"
        When call is_git_repo ../.. &> /dev/null
        The status should be failure
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_git_repo' function returns true while deeper in a git repo (docs)"
        When call is_git_repo ../docs &> /dev/null
        The status should be success
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_git_repo' function returns false while OUTSIDE a git repo - with appropriate comments - with shifted PWD"
        When call is_git_repo ../.. true
        The status should be failure
        The status should eq 128
        The output should start with '::group::is_git_repo of Common Functions; '
        The output should include '================================================= DEBUG (is_git_repo): Acquiring arguments ==================='
        The output should include 'having needs_pop: true'
        The output should include 'command captured_response: fatal: not a git repository (or any of the parent directories): .git, captured_result: 128'
        The output should end with '::endgroup::'
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_git_repo' function returns false while OUTSIDE a git repo - with appropriate comments - without shifted PWD"
        pushd ../.. &> /dev/null || exit 11
        When call is_git_repo . true
        The status should be failure
        The status should eq 128
        The output should include '================================================= DEBUG (is_git_repo): Acquiring arguments ==================='
        The output should include 'having needs_pop: false'
        The output should include 'command captured_response: fatal: not a git repository (or any of the parent directories): .git, captured_result: 128'
        The output should end with '::endgroup::'
        popd &> /dev/null || exit 13
      End

    End

    Describe "$SHELLSPEC_GROUP_ID: Function is_at_root_of_repo returns true while at the root of a git repo"


      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_at_root_of_repo' function returns false (i.e., 1) while deeper in a git repo (docs, for example)"
        When call is_at_root_of_repo &> /dev/null
        The status should be failure
        The status should eq 1
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_at_root_of_repo' function returns true (0) while AT the root of a git repo"
        pushd .. &> /dev/null || exit 11
        When call is_at_root_of_repo &> /dev/null
        The status should be success
        popd &> /dev/null || exit 13
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_at_root_of_repo' function returns false (i.e., code 2) while OUTSIDE a git repo"
        pushd ../.. &> /dev/null || exit 11
        When call is_at_root_of_repo &> /dev/null
        The status should be failure
        The status should eq 2
        popd &> /dev/null || exit 13
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_at_root_of_repo' function returns false (i.e., 1) while deeper in a git repo (docs, for example)"
        When call is_at_root_of_repo
        The status should be failure
        The status should eq 1
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'is_at_root_of_repo' function returns false (i.e., code 2) while OUTSIDE a git repo"
        pushd ../.. &> /dev/null || exit 11
        When call is_at_root_of_repo
        The status should be failure
        The status should eq 2
        popd &> /dev/null || exit 13
      End

    End

    Describe "$SHELLSPEC_GROUP_ID: Function has_github_workflow_folder returns true while the root of a git repo contains a .github/workflows folder"

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'has_github_workflow_folder' function returns true (i.e., 0) anywhere in a git repo which contains a .github/workflows folder (here)"
        When call has_github_workflow_folder
        The status should be success
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'has_github_workflow_folder' function returns false (i.e., 11) while OUTSIDE a git repo"
        pushd ../.. &> /dev/null || exit 11
        When call has_github_workflow_folder
        The status should be failure
        The status should eq 11
        popd &> /dev/null || exit 13
      End

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'has_github_workflow_folder' function returns true (i.e., 0) at the root of a git repo which contains a .github/workflows folder (root)"
        pushd .. &> /dev/null || exit 11
        When call has_github_workflow_folder
        The status should be success
        popd &> /dev/null || exit 13
      End

    End

    Describe "$SHELLSPEC_GROUP_ID: Function 'bootstrapped' returns true while the root of a git repo contains a .github/workflows folder AND a valid SDKMAN initialization script (~/.sdkman/bin/sdkman-init.sh) is present"

      Specify "$SHELLSPEC_EXAMPLE_ID ($SHELLSPEC_EXAMPLE_NO): 'bootstrapped' function returns true (i.e., 0) anywhere in a git repo which contains a .github/workflows folder (here)"
        When call bootstrapped
        The status should be success
      End

    End

  End

End