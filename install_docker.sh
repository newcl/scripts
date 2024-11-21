#!/bin/bash

# Update and upgrade the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install required dependencies
echo "Installing required dependencies..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
echo "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's repository
echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package database
echo "Updating package database..."
sudo apt update

# Install Docker
echo "Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Enable and start Docker
echo "Enabling and starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Optional: Allow non-root users to run Docker
echo "Allowing non-root user to run Docker..."
sudo usermod -aG docker $USER

# Install Docker Compose
echo "Installing Docker Compose..."
sudo apt install -y docker-compose

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version
docker-compose --version

# Test Docker with a hello-world container
echo "Testing Docker installation with 'hello-world' container..."
docker run hello-world

echo "Docker installation completed! Please log out and log back in to use Docker without sudo."

