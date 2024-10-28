#!/usr/bin/env bash
set -euo pipefail

# Check if the report file exists
if [[ -f build/dependencyUpdates/report.json ]]; then

  # Extract dependencies with available updates
  latest_versions=$(jq -r '
    [.current.dependencies[] |
    select(.available.release != null) |
    {name: .group + ":" + .name, current: .version, latest: .available.release}]' \
    build/dependencyUpdates/report.json)

  ehco -e "\n\nDependencies:\n\n" > dependency-updates.text
  echo "$latest_versions" | jq -r '.[] | "\(.name) :: \(.current) ==> \(.latest)"' >> dependency-updates.text
  echo -e "\n\n" >> dependency-updates.text

else
  echo -e "\n\nNo dependency updates available.\n\n" > dependency-updates.text
fi

cat dependency-updates.text
