#!/bin/bash

# Check if an argument was passed
if [ -z "$1" ]; then
  echo "Please provide a directory or a file as an argument."
  exit 1
fi

# Assign the first argument to the TARGET variable
TARGET=$1

# Define the path to be added to the PATH environment variable
CUSTOM_PATH="/lolo9876"

# Check if a custom path is provided as a second argument
if [ ! -z "$2" ]; then
  CUSTOM_PATH="$2"
fi

# Check if the target exists
if [ ! -e "$TARGET" ]; then
  echo "The specified target $TARGET does not exist."
  exit 1
fi

# Add CUSTOM_PATH to the beginning of the PATH environment variable
export PATH="$CUSTOM_PATH:$PATH"
echo "Updated PATH: $PATH"

# Function to run strace and check for execve calls from CUSTOM_PATH
check_execve() {
  local file="$1"
  echo "Running strace on $file..."
  
  # Use strace with the -o option to write to a temporary file
  local strace_output
  strace_output=$(mktemp)

  strace -f -e trace=execve -o "$strace_output" "$file" > /dev/null 2>&1

  # Parse the strace output
  grep "execve" "$strace_output" | while read -r line; do
    if echo "$line" | grep -q "$CUSTOM_PATH"; then
      # Extract the binary name
      binary=$(echo "$line" | grep -o "$CUSTOM_PATH/[^\" ]*")
      echo "PWN: $binary"
    fi
  done

  # Clean up the temporary file
  rm -f "$strace_output"
}

# Check if the target is a directory or a file
if [ -d "$TARGET" ]; then
  # Loop through each file in the directory and run the check
  for FILE in "$TARGET"/*; do
    if [ -x "$FILE" ] && [ ! -d "$FILE" ]; then
      check_execve "$FILE"
    fi
  done
elif [ -f "$TARGET" ] && [ -x "$TARGET" ]; then
  # If the target is a single file, run the check
  check_execve "$TARGET"
else
  echo "The specified target $TARGET is neither a directory nor an executable file."
  exit 1
fi
