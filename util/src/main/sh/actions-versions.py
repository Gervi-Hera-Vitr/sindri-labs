#!/usr/bin/env python
import subprocess
# shellcheck disable=SC1083
# shellcheck disable=SC2283

actions = {
    "actions/checkout": {
        "symbolic_tag": "v4",
        "latest_tag": "main",
        "explicit_tag": "v4.2.2"
    },
    "actions/first-interaction": {
        "symbolic_tag": "v1",
        "latest_tag": "main",
        "explicit_tag": "v1.3.0"
    },
    "actions/labeler": {
        "symbolic_tag": "v5",
        "latest_tag": "main",
        "explicit_tag": "v5.0.0"
    },
    "actions/stale": {
        "symbolic_tag": "v9",
        "latest_tag": "main",
        "explicit_tag": "v9.0.0"
    },
    "actions/cache": {
        "symbolic_tag": "v4",
        "latest_tag": "main",
        "explicit_tag": "v4.1.2"
    },
    "actions/setup-java": {
        "symbolic_tag": "v4",
        "latest_tag": "main",
        "explicit_tag": "v4.5.0"
    },
    "gradle/actions": {
        "symbolic_tag": "v4",
        "latest_tag": "main",
        "explicit_tag": "v4.1.0"
    },
    "codacy/codacy-analysis-cli-action": {
        "symbolic_tag": "v4",
        "latest_tag": "master",
        "explicit_tag": "v4.4.5"
    },
    "github/codeql-action": {
        "symbolic_tag": "v3",
        "latest_tag": "main",
        "explicit_tag": "v3.27.0"
    },
    "actions/upload-pages-artifact": {
        "symbolic_tag": "v3",
        "latest_tag": "main",
        "explicit_tag": "v3.0.1"
    },
    "actions/deploy-pages": {
        "symbolic_tag": "v4",
        "latest_tag": "main",
        "explicit_tag": "v4.0.5"
    },
    "actions/jekyll-build-pages": {
        "symbolic_tag": "v1",
        "latest_tag": "main",
        "explicit_tag": "v1.0.13"
    }
}

# Function to get the commit hash for a specific tag
def get_commit_hash(repo, tag):
    try:
        result = subprocess.run(
            ["git", "ls-remote", f"https://github.com/{repo}.git", tag],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.split()[0] if result.stdout else "N/A"
    except subprocess.CalledProcessError:
        return "N/A"

# Loop through each action and print its details with hashes
for action, tags in actions.items():
    symbolic = tags["symbolic_tag"]
    latest = tags["latest_tag"]
    explicit = tags["explicit_tag"]

    # Fetch commit hashes
    symbolic_hash = get_commit_hash(action, symbolic)
    latest_hash = get_commit_hash(action, latest)
    explicit_hash = get_commit_hash(action, explicit)

    # Print in two-row format
    print(f"action: {action:<34} => symbolic: {symbolic:>3}|-> {symbolic_hash:<40};    explicit: {explicit:>7}|-> {explicit_hash:<40};    latest: {latest:>7}|-> {latest_hash:<40}")
