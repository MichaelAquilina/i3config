#! /bin/bash

# Deduct -2 for the table header
update_count=$(( $(zypper --quiet lu | wc -l) - 2 ))

# If there are no updates, no lines are displayed to stdout
if [[ $update_count -eq -2 ]]; then
    echo "No updates"
else
    echo "$update_count"
fi
