#!/bin/bash

# Check if an argument was passed
if [ -z "$1" ]; then
  echo "Please provide a directory as an argument."
  exit 1
fi

# Assign the first argument to the DIR variable
DIR=$1

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "The directory $DIR does not exist."
  exit 1
fi

# Loop through each file in the directory and run the file command
echo "Running 'file' command on each file in the directory $DIR:"
for FILE in "$DIR"/*; do
  if [ -f "$FILE" ]; then
    file "$FILE"
  fi
done

