cat <<EOF

# Enable basic firewall config
sudo ufw allow ssh/tcp
sudo ufw logging on
sudo ufw logging medium
sudo ufw allow log 22/tcp
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable

EOF