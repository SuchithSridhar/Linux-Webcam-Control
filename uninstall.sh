#!/usr/bin/env bash

# Define the destination
DESTINATION_FILE="/usr/bin/webcam-control"

# Remove the destination file
if [ -f "$DESTINATION_FILE" ]; then
    sudo rm "$DESTINATION_FILE"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to remove $DESTINATION_FILE."
        exit 1
    fi
    echo "Removed $DESTINATION_FILE successfully."
else
    echo "Error: $DESTINATION_FILE does not exist."
    exit 1
fi

# Remove the line from the sudoers file
USERNAME=$(whoami)
SUDOERS_LINE="$USERNAME ALL = (root) NOPASSWD: $DESTINATION_FILE"
TEMP_FILE=$(mktemp)

if sudo grep -Fxq "$SUDOERS_LINE" /etc/sudoers; then
    sudo cp /etc/sudoers "$TEMP_FILE"
    sudo sed -i "\|$SUDOERS_LINE|d" "$TEMP_FILE"
    if sudo visudo -c -f "$TEMP_FILE"; then
        sudo cp "$TEMP_FILE" /etc/sudoers
        if [ $? -ne 0 ]; then
            echo "Error: Failed to update the sudoers file."
            exit 1
        fi
        echo "Sudoers file updated successfully."
    else
        echo "Error: Invalid sudoers file. Aborting uninstallation."
        exit 1
    fi
    rm "$TEMP_FILE"
else
    echo "The sudoers file does not contain the permissions line."
fi

echo "Uninstallation completed successfully."

