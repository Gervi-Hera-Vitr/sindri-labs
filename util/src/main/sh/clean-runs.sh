#!/usr/bin/env zsh

limit=500
page_size=100

# Declare an array to store workflow details
declare -a workflows

# Fetch workflow details and store them in the workflows array
for workflow in $(gh workflow list --json id,name,path,state -q '.[] | @base64'); do
  # Decode each workflow entry from base64
  workflow_decoded=$(echo "$workflow" | base64 --decode | jq -r '"\(.id) \(.name) \(.path) \(.state)"')
  workflows+=("$workflow_decoded")
  echo "$workflow_decoded"
done




## Define variables
#REPO_OWNER=$(gh repo view --json nameWithOwner -q '.nameWithOwner')
#LATEST_RUN_ID=$(gh run list --limit 1 --json databaseId -q '.[0].databaseId')
#
## Get a list of all run IDs, except the latest
#RUN_IDS=$(gh run list --json databaseId -q '.[].databaseId' | grep -v "$LATEST_RUN_ID")
#
#echo -e "Repository owner: $REPO_OWNER\nLatest run ID: $LATEST_RUN_ID\nRun IDs: $RUN_IDS"
#
## Delete each old run by its ID
#for RUN_ID in $RUN_IDS; do
#  echo "Deleting run ID: $RUN_ID"
#  gh run view "$RUN_ID"
##  gh run delete "$RUN_ID" --confirm
#done
#
#
#runs=$(gh run list --limit $page_size --json databaseId -q '.[].databaseId')
#total_count=$(echo "$runs" | wc -l)
#
#while [ "$total_count" -lt "$limit" ]; do
#    # Fetch the next page, appending to runs
#    next_runs=$(gh run list --limit $page_size --json databaseId -q '.[].databaseId' --page $((total_count / page_size + 1)))
#    runs="$runs\n$next_runs"
#    total_count=$(echo "$runs" | wc -l)
#
#    # Break if there are no more pages
#    [ -z "$next_runs" ] && break
#done
#
## Now `runs` contains up to `limit` items, which you can use for deletion
#echo "$runs" | xargs -n1 gh run delete -y



# gh run list --json databaseId  -q '.[].databaseId' | xargs -I ID gh api "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions/runs/ID" -X DELETE
# gh run list --json databaseId  -q '.[].databaseId' | xargs -I ID echo "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions/runs/ID" | xargs -I ADDR gh api ADDR -X DELETE

#gh run list --json databaseId -q '.[].databaseId' | xargs -IID gh run delete ID
#gh run list