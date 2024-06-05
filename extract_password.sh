#!/bin/bash

# Define a regex pattern for common password fields (this may need to be adjusted for specific cases)

PASSWORD_PATTERN='[Pp]assword[[:space:]]*[=:][[:space:]]*|[Ss]ecret[[:space:]]*[=:][[:space:]]*|[Pp]ass[[:space:]]*[=:][[:space:]]*'

# Search for password patterns recursively in the /etc/ directory
echo "Extracting password fields from files in /etc/:"
/bin/egrep -nr "$PASSWORD_PATTERN" /etc/
