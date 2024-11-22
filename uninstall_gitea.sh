#!/bin/bash

echo "Starting the removal of Gitea standalone installation..."

# Stop and disable the Gitea service
echo "Stopping and disabling the Gitea service..."
sudo systemctl stop gitea
sudo systemctl disable gitea

# Remove the Gitea service file
echo "Removing Gitea service file..."
sudo rm -f /etc/systemd/system/gitea.service
sudo systemctl daemon-reload

# Remove Gitea binary
echo "Removing Gitea binary..."
sudo rm -f /usr/local/bin/gitea

# Remove Gitea configuration and data
echo "Removing Gitea configuration and data..."
sudo rm -rf /etc/gitea
sudo rm -rf /var/lib/gitea
sudo rm -rf /var/log/gitea

# Remove the Gitea user and group
echo "Removing Gitea user and group..."
sudo userdel -r git 2>/dev/null || echo "Gitea user not found."
sudo groupdel git 2>/dev/null || echo "Gitea group not found."

# Clean up optional dependencies
echo "Cleaning up optional dependencies..."
sudo apt-get remove --purge -y sqlite3 git
sudo apt-get autoremove -y

# Verify no residual Gitea files remain
echo "Checking for any remaining Gitea files..."
sudo find / -name "*gitea*" -exec ls -l {} \;

# Final confirmation
echo "Gitea standalone installation has been completely removed."


