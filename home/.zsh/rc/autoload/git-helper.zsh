# Git lock file error handler
# Wraps git command to detect and handle index.lock errors

git() {
  # Store the command for potential re-execution
  local git_cmd=("$@")

  # Create a temporary file to capture error output only
  local tmp_error=$(mktemp)

  # Execute the actual git command (stdout goes directly to terminal, stderr captured)
  command git "$@" 2>| "$tmp_error"
  local exit_code=$?

  # Display stderr
  if [[ -s "$tmp_error" ]]; then
    cat "$tmp_error" >&2
  fi

  # Check for lock file error
  if [[ $exit_code -ne 0 ]] && grep -q "Unable to create.*index.lock.*File exists" "$tmp_error"; then
    # Extract the lock file path
    local lock_file=$(grep -o "Unable to create '[^']*'" "$tmp_error" | sed "s/Unable to create '\\(.*\\)'/\\1/")

    if [[ -n "$lock_file" ]]; then
      echo "" >&2
      echo "🔒 Git lock file detected: $lock_file" >&2
      echo "" >&2

      # Ask user for confirmation
      echo -n "Remove lock file and retry? [Y/n]: " >&2
      read -r response

      # Default to yes if empty
      if [[ -z "$response" ]] || [[ "$response" =~ ^[Yy]$ ]]; then
        if [[ -f "$lock_file" ]]; then
          rm -f "$lock_file"
          echo "✓ Lock file removed. Retrying command..." >&2
          echo "" >&2

          # Clean up temp file
          rm -f "$tmp_error"

          # Retry the original command
          command git "${git_cmd[@]}"
          return $?
        else
          echo "✗ Lock file not found: $lock_file" >&2
          rm -f "$tmp_error"
          return $exit_code
        fi
      else
        echo "Skipping lock file removal." >&2
        rm -f "$tmp_error"
        return $exit_code
      fi
    fi
  fi

  # Clean up temp file
  rm -f "$tmp_error"

  return $exit_code
}
