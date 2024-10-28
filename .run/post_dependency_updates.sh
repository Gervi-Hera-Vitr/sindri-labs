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

  # Format the updates as Markdown
  cat << EOF >> dependency-updates.md

  **Dependency Update Suggestions:**

  The following dependencies have newer versions available:

  | Dependency | Current Version | Latest Version |
  |------------|-----------------|----------------|

EOF

  echo "$latest_versions" | jq -r '.[] | "| \(.name) | \(.current) | \(.latest) |"' >> dependency-updates.md

else
  echo "No dependency updates available." > dependency-updates.md
fi

# Post the update suggestions as an issue comment
gh issue comment "$ISSUE_NUMBER" --body "$(cat dependency-updates.md)"
