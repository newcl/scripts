#!/bin/bash

echo "Uninstalling Docker and cleaning up residual files..."

# Remove Docker packages
sudo apt-get remove --purge -y docker docker-engine docker.io containerd runc

# Remove Docker directories
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove additional dependencies
sudo apt-get autoremove -y
sudo apt-get autoclean

echo "Docker has been uninstalled and residual files removed."

