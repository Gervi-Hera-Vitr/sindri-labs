#!/usr/bin/env zsh

repo=$1
ref=$2
brd=$3
brt=$4

cat <<EOF

=========================================
INFO: Checking if this branch has
  a working pull request
  to yield to.
=========================================
Repository:       $repo
Reference:        $ref
Default Branch:   $brd
Target Branch:    $brt
=========================================

EOF

# shellcheck source=SDKMAN_INIT
[[ -s "$SDKMAN_INIT" ]] && source "$SDKMAN_INIT"

echo "::notice file=push-action-check-to-yield.sh,line=6::Checking if this branch has a working pull request to yield to.";

prs=$( gh pr list \
  --repo "$repo" \
  --head "$ref" \
  --base "$brt" \
  --json title \
  --jq 'length' )

cat <<EOF

=========================================
PRs: $prs
=========================================

EOF

#if ((prs > 0)); then
#
#  echo "skip=true" >> "$GITHUB_OUTPUT";
#  echo "::warning file=push.yaml,line=55::This branch has a working pull request to yield to => `push` run is TERMINATING due to active pull request.";
#  cat docs/src/docs/markdown/template-check-yield.md |
#    sed --quiet
#    --expression="s/--disposition-title--/Yielding to PR/"
#    --expression="s/--run-disposition-decision--/Pull Request detected thus push workflow will cancel!/"
#    >> $GITHUB_STEP_SUMMARY;
#
#else
#
#  echo "skip=false" >> "$GITHUB_OUTPUT";
#  echo "::notice file=push.yaml,line=58::This branch has no working pull request to yield to =>`push` workflow marked to execute!";
#
#  cat docs/src/docs/markdown/template-check-yield.md |
#    sed --quiet
#    --expression="s/--disposition-title--/Building Push!/"
#    --expression="s/--run-disposition-decision--/Running push workflow because a PR is not detected in this branch./"
#    >> $GITHUB_STEP_SUMMARY;
#
#fi;