#!/bin/bash

# Check if an argument was passed
if [ -z "$1" ]; then
  echo "Please provide a script file as an argument."
  exit 1
fi

# Assign the first argument to the SCRIPT variable
SCRIPT=$1

# Check if the file exists and is readable
if [ ! -r "$SCRIPT" ]; then
  echo "The script file $SCRIPT does not exist or is not readable."
  exit 1
fi

# Function to check if a command is a binary and not a built-in or alias
is_binary() {
  local cmd="$1"
  if [[ -z $(command -v "$cmd") ]]; then
    return 1
  elif [[ -x $(command -v "$cmd") ]]; then
    return 0
  else
    return 1
  fi
}

# Read the script line by line
while IFS= read -r line; do
  # Extract words that might be commands
  for word in $line; do
    # Skip words starting with '/', '.', or being assignments or options
    if [[ "$word" =~ ^/ || "$word" =~ ^\. || "$word" =~ ^- || "$word" =~ = ]]; then
      continue
    fi

    # Check if the word is a command
    if is_binary "$word"; then
      echo "Found binary command without absolute path: $word"
    fi
  done
done < "$SCRIPT"
