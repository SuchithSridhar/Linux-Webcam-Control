#!/usr/bin/env bash

SOURCE_FILE="webcam-control.py"
DESTINATION_FILE="/usr/bin/webcam-control"

# Check if the destination file already exists
if [ -f "$DESTINATION_FILE" ]; then
    echo "Error: $DESTINATION_FILE already exists. Aborting installation."
    echo "You can change the DESTINATION_FILE in the script to avoid the collision."
    exit 1
fi

# Copy the source file to the destination
echo "Copying the script to $DESTINATION_FILE"
sudo cp "$SOURCE_FILE" "$DESTINATION_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy $SOURCE_FILE to $DESTINATION_FILE."
    exit 1
fi

# Make the file executable
echo "Marking the script as executable."
sudo chmod +x "$DESTINATION_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to make $DESTINATION_FILE executable."
    exit 1
fi

# Add a line to the sudoers file
echo ""
echo "Adding line to sudoers file for convinence."
echo ""
USERNAME=$(whoami)
SUDOERS_LINE="$USERNAME ALL = (root) NOPASSWD: $DESTINATION_FILE"
if sudo grep -Fxq "$SUDOERS_LINE" /etc/sudoers; then
    echo "The sudoers file already contains the necessary line."
    echo "You can run 'sudo $DESTINATION_FILE' without a password"
else
    # Ask for confirmation
    echo "Adding the following line to the sudoers file will allow you to"
    echo "run the script as root without a password."
    echo ""
    echo "NEW LINE: $SUDOERS_LINE"
    read -p "Do you want to add the above line to the sudoers file? (y/n): " CONFIRMATION
    CONFIRMATION=$(echo "$CONFIRMATION" | tr '[:upper:]' '[:lower:]')
    if [[ "$CONFIRMATION" == "yes" || "$CONFIRMATION" == "y" ]]; then
        echo "$SUDOERS_LINE" | sudo tee -a /etc/sudoers > /dev/null
        if [ $? -ne 0 ]; then
            echo "Error: Failed to update the sudoers file."
            exit 1
        fi
        echo "Sudoers file updated successfully."
	echo "You can run 'sudo $DESTINATION_FILE' without a password"
    else
        echo "Operation cancelled. The sudoers file was not modified."
	echo "The script is still executable but will need a password with sudo."
        exit
    fi
fi

echo "Installation completed successfully."
