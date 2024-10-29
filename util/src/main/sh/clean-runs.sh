#!/usr/bin/env zsh

# gh run list --json databaseId  -q '.[].databaseId' | xargs -I ID gh api "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions/runs/ID" -X DELETE
# gh run list --json databaseId  -q '.[].databaseId' | xargs -I ID echo "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions/runs/ID" | xargs -I ADDR gh api ADDR -X DELETE

#gh run list --json databaseId -q '.[].databaseId' | xargs -IID gh run delete ID
gh run list