#!/bin/bash

set -e

# Update system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo "Installing dependencies..."
sudo apt install -y wget git sqlite3 nano unzip curl nginx certbot python3-certbot-nginx

# Create Gitea user
echo "Creating Gitea user..."
sudo adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home /home/git git

# Download Gitea binary
VERSION=1.20.4
echo "Downloading Gitea version $VERSION..."
wget -O gitea https://dl.gitea.io/gitea/${VERSION}/gitea-${VERSION}-linux-amd64
sudo mv gitea /usr/local/bin/
sudo chmod +x /usr/local/bin/gitea

# Configure Gitea directories
echo "Setting up Gitea directories..."
sudo mkdir -p /var/lib/gitea/{custom,data,log}
sudo chown -R git:git /var/lib/gitea
sudo chmod -R 750 /var/lib/gitea
sudo mkdir -p /etc/gitea
sudo chown -R root:git /etc/gitea
sudo chmod -R 770 /etc/gitea

# Create systemd service for Gitea
echo "Creating systemd service for Gitea..."
cat <<EOF | sudo tee /etc/systemd/system/gitea.service
[Unit]
Description=Gitea (Git with a cup of tea)
After=network.target

[Service]
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea

[Install]
WantedBy=multi-user.target
EOF

# Start and enable Gitea service
echo "Starting and enabling Gitea service..."
sudo systemctl daemon-reload
sudo systemctl start gitea
sudo systemctl enable gitea

# Set up Nginx reverse proxy
echo "Configuring Nginx as a reverse proxy..."
cat <<EOF | sudo tee /etc/nginx/sites-available/gitea
server {
    listen 80;
    server_name your_domain.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/gitea /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Secure with HTTPS
echo "Securing Gitea with HTTPS using Certbot..."
sudo certbot --nginx -d your_domain.com --non-interactive --agree-tos -m admin@your_domain.com

echo "Gitea installation is complete!"
echo "Access your Gitea instance at http://your_domain.com or https://your_domain.com."

