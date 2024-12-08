#!/usr/bin/env zsh

ref="${GITHUB_REF##*/}"
brd=$1
brt=$2

cat <<EOF

=========================================
INFO: Checking if this branch has
  a working pull request
  to yield to.
=========================================
Action Control Values:
Event:            $GITHUB_EVENT_NAME
Output File:      $GITHUB_OUTPUT
Summary File:     $GITHUB_STEP_SUMMARY
Environment File: $GITHUB_ENV

Environment Variables:
GITHUB_REPOSITORY: $GITHUB_REPOSITORY
GITHUB_REF:        $GITHUB_REF
GITHUB_REF_NAME:   $GITHUB_REF_NAME
GITHUB_SHA:        $GITHUB_SHA
GITHUB_EVENT_NAME: $GITHUB_EVENT_NAME
GITHUB_ACTION:     $GITHUB_ACTION
GITHUB_WORKFLOW:   $GITHUB_WORKFLOW

=========================================

Inferred Values:
Reference:        $ref

Passed Values:
Target Branch:    $brt (default is $brd)
=========================================

EOF

echo "::group::Yield Selector Annotations"

# shellcheck source=SDKMAN_INIT
[[ -s "$SDKMAN_INIT" ]] && source "$SDKMAN_INIT"

echo "::notice file=push-action-check-to-yield.sh,line=45::Checking if this branch has a working pull request to yield to.";

prs=$( gh pr list \
  --repo "$GITHUB_REPOSITORY" \
  --head "$ref" \
  --base "$brt" \
  --json title \
  --jq 'length' )

cat <<EOF

=========================================
PRs: $prs
=========================================

EOF

if ((prs > 0)); then
  echo "skip=true" >> "$GITHUB_OUTPUT"
  echo "::notice file=push-action-check-to-yield.sh,line=65::This branch has a working pull request to yield to => This Push run is TERMINATING due to active pull request."

  sed -e 's/--disposition-title--/Yielding to PR/' \
  -e 's/--run-disposition-decision--/Pull Request detected thus push workflow will cancel!/' \
  docs/src/docs/markdown/template-check-yield.md >> "$GITHUB_STEP_SUMMARY"
else
  echo "skip=false" >> "$GITHUB_OUTPUT"

  sed -e 's/--disposition-title--/Building Push!/' \
  -e 's/--run-disposition-decision--/Running push workflow because a PR is not detected in this branch./' \
  docs/src/docs/markdown/template-check-yield.md >> "$GITHUB_STEP_SUMMARY"
fi

echo "========================================= Runtime Environment ========================================="
env
echo "======================================================================================================="

echo "========================================= GitHub Environment =========================================="
cat "$GITHUB_ENV"
echo "======================================================================================================="

echo "::endgroup::"