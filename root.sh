#!/bin/bash

# Prompt for username if not provided
read -p "Enter the username to add to root privileges: " username

# Check if user exists
if id "$username" &>/dev/null; then
    echo "User $username exists, proceeding with granting root privileges..."
else
    echo "User $username does not exist. Please create the user first."
    exit 1
fi

# Add user to sudo group
echo "Adding $username to sudo group..."
sudo usermod -aG sudo "$username"

# Add user to root group 
echo "Adding $username to root group..."
sudo usermod -aG root "$username"

# Install sudo if not already installed
sudo apt-get -y install sudo

# Add user to sudoers file for full privileges
SUDOERS_FILE="/etc/sudoers.d/$username"
echo "Adding $username to sudoers file with full privileges..."
if [ ! -f "$SUDOERS_FILE" ]; then
    sudo bash -c "echo '$username ALL=(ALL:ALL) ALL' > $SUDOERS_FILE"
    sudo chmod 440 "$SUDOERS_FILE"
else
    echo "Sudoers file for $username already exists."
fi

echo "The user $username has been granted full sudo privileges."

# Update package lists
sudo apt-get update

# Switch to the specified user
sudo su - "$username" -c "
sudo apt-get -y install git &&
git clone https://github.com/l1nux-th1ngz/pt2.git &&
cd pt2 &&
chmod +x mod-all.sh &&
./mod-all.sh
"

echo "Script execution completed."
