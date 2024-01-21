cat <<EOF

# Modify sshd
sudo sed -i 's/PermitRootLogin\ yes/PermitRootLogin\ no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication\ yes/PasswordAuthentication\ no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitEmptyPasswords\ no/PermitEmptyPasswords\ no/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

EOF