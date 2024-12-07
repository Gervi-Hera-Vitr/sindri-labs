#!/usr/bin/env zsh

step_summary_file="$GITHUB_STEP_SUMMARY"
default_envX_file="$GITHUB_ENV"

tick="$(date +%Y_%m_%d_%H_%M_%S)"
build_dependencies_working_directory=$(git rev-parse --show-toplevel)/build/dependencies

production_run=${1:-true}
[[ "Darwin" == "$(uname)" ]] && production_run=false && echo "::notice file=hint-on-dependencies.sh,line=10::Running in development mode. Skipping prune actions."

[[ ! -d "$build_dependencies_working_directory" ]] && mkdir -p "$build_dependencies_working_directory"

if [[ "$production_run" == "false" ]]; then
  step_summary_file="$build_dependencies_working_directory/github_step_summary_local_$tick.md"
  default_envX_file="$build_dependencies_working_directory/github_env_extended_local_$tick.env"
  touch "$step_summary_file"
  touch "$default_envX_file"
  echo -e "==> Running in development mode."
fi

echo "==> production_run=$production_run"
echo "==> step_summary=$step_summary_file"
echo "==> default_envX=$default_envX_file"

# File paths
gradle_log_file="$build_dependencies_working_directory/gradle_dependencies_$tick.log"
report_file="$build_dependencies_working_directory/report.json"
summary_file_md="$build_dependencies_working_directory/dependency_updates_summary_$tick.md"
summary_file_json="$build_dependencies_working_directory/google_ai_labs_dependency_updates_summary_$tick.json"

touch "$gradle_log_file"

# shellcheck source=SDKMAN_INIT
if [[ -s "$SDKMAN_INIT" ]]; then
  source "$SDKMAN_INIT"
else
  if [[ "$production_run" == "true" ]]; then
    echo "::error file=hint-on-dependencies.sh,line=39::SDKMAN initialization script not found. Please ensure SDKMAN is installed and configured properly."
    {
      echo -e "# FAILED: Dependency Hints\n\n"
      echo "<details>"
      echo
      echo "<summary>Failure Reason:</summary>"
      echo
      echo "_SDKMAN initialization script not found on $(hostname) - $(whoami) - $tick. Please ensure SDKMAN is installed and configured properly..._"
      echo
      echo "_Please reach out to the [Gervi Héra Vitr](https://github.com/Gervi-Hera-Vitr) organization members for more information._"
      echo
      echo "</details>"
      echo
    }  >> "$summary_file_md"
    else
      echo "==> Run sdk c locally for SDKMAN state."
  fi
fi

# Check if Gradle command is available
if ! command -v gradle &> /dev/null; then
  echo "::error file=hint-on-dependencies.sh,line=60::Gradle command not found. Please check the SDK setup."
  {
    echo -e "## FAILED: gradle is required!\n\n"
    echo
    echo "<details>"
    echo
    echo "<summary>Failure Reason:</summary>"
    echo
    echo "_Gradle command not found on $(hostname) - $(whoami) - $tick. Terminating!_"
    echo
    echo "</details>"
    echo
  }  >> "$summary_file_md"
  [[ "$production_run" == "true" ]] && exit 1
  exit 0
fi

# Check if Gradle processDependencyUpdates command succeeds
if ! gradle --info --build-cache --no-daemon processDependencyUpdates > "$gradle_log_file"  2>&1; then
  echo "::error file=hint-on-dependencies.sh,line=79::Gradle processDependencyUpdates command failed. Please check the SDK setup."
  {
    echo -e "# FAILED: Dependency Hints\n\n"
    echo
    echo "<details>"
    echo
    echo "<summary>Failure Reason:</summary>"
    echo
    echo "_Gradle processDependencyUpdates command failed on $(hostname) - $(whoami) - $tick. Terminating!_"
    echo
    echo "_Please reach out to the [Gervi Héra Vitr](https://github.com/Gervi-Hera-Vitr) organization members for more information._"
    echo
    echo "</details>"
    echo
  }  >> "$summary_file_md"
  [[ "$production_run" == "true" ]] && exit 1
  exit 0
fi

# Check if the report file exists
if [[ ! -f "$report_file" ]]; then
    echo "::error file=hint-on-dependencies.sh,line=100::Dependency report not found at $report_file"

    {
      echo -e "# FAILED: Dependency Hints\n\n"
      echo
      echo "<details>"
      echo
      echo "<summary>Failure Reason:</summary>"
      echo
      echo "_Dependency report $report_file not found on $(hostname) - $(whoami) - $tick. Terminating!_"
      echo
      echo "_Please reach out to the [Gervi Héra Vitr](https://github.com/Gervi-Hera-Vitr) organization members for more information._"
      echo
      echo "</details>"
      echo
    }  >> "$summary_file_md"
    exit 1
fi

# Extract information from the JSON report using jq
total_count=$(jq '.count' "$report_file")
outdated_count=$(jq '.outdated.count' "$report_file")
latest_count=$(jq '.current.count' "$report_file")
undeclared_count=$(jq '.undeclared.count' "$report_file")
unresolved_count=$(jq '.unresolved.count' "$report_file")

echo "::notice file=hint-on-dependencies.sh,line=126::Total count: $total_count; Outdated count: $outdated_count; Latest count: $latest_count; Undeclared count: $undeclared_count; Unresolved count: $unresolved_count"

# Create Markdown Summary File
{
    echo "# Impromptu Dependency Hints (upgradable ${outdated_count})"
    echo
    echo "_These are running recommendations ahead of **Dependabot** and **Renovate**._"
    echo
    echo "<details>"
    echo
    echo "<summary>Dependencies Summary:</summary>"
    echo
    echo "**General Summary:**"
    echo
    echo " - ${total_count} total dependencies."
    echo " - ${outdated_count} outdated dependencies."
    echo " - ${latest_count} latest dependencies."
    echo " - ${undeclared_count} undeclared dependencies."
    echo " - ${unresolved_count} unresolved dependencies."
    echo
    echo "**Outdated Dependencies:**"
    echo
    if [[ "$outdated_count" -eq 0 ]]; then
        echo "- All dependencies are up-to-date!"
    else
        jq -r '.outdated.dependencies[] | "- \(.group):\(.name) [v\(.version) -> v\(.available.milestone // "unknown")]"' "$report_file"
    fi
    echo
    echo "**Notes:**"
    echo
    if [[ "$undeclared_count" -eq 0 ]]; then
        echo "- no undeclared dependencies."
    else
        all_undeclared=$(jq -r '.undeclared.dependencies[] | "  - \(.group):\(.name)"' "$report_file")
        echo -e "- **$undeclared_count undeclared dependencies:**\n$all_undeclared"
    fi
    if [[ "$unresolved_count" -eq 0 ]]; then
        echo "- no unresolved dependencies."
    else
        all_unresolved=$(jq -r '.unresolved.dependencies[] | "  - \(.group):\(.name)"' "$report_file")
        echo -e "- **$unresolved_count dependencies could not be resolved:**\n$all_unresolved"
    fi
    echo
} > "$summary_file_md"

jq '{
  current: { count: .current.count, dependencies: .current.dependencies },
  outdated: { count: .outdated.count, dependencies: .outdated.dependencies },
  undeclared: { count: .undeclared.count, dependencies: .undeclared.dependencies }
}' "$report_file" > "$summary_file_json"

echo "::notice file=hint-on-dependencies.sh,line=173::Dependency summary (JSON) generated at $summary_file_json."

cat "$summary_file_md" >> "$step_summary_file"
echo "DEPENDENCY_HINTS_JSON_FILE=$summary_file_json" >> "$default_envX_file"

if [[ ! "$production_run" == "true" ]]; then
  echo -e "\n==== Environment ===="
  cat "$default_envX_file"
  echo -e "=== Summary ==="
  cat "$step_summary_file"
  open "$default_envX_file"
  open "$step_summary_file"
  open "$report_file"
  open "$summary_file_json"
fi
