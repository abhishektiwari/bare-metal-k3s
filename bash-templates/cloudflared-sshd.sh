cat <<EOF
# SSH using Cloudflare short-lived certificate public key
# Each host will need it's own Cloudflare tunnel, application, and certificate

sudo echo  "<REPLACE-ME-WITH-CF-PUBLIC-CER-FOR-HOST>" >> /etc/ssh/ca.pub
sudo sed -i 's/^#PubkeyAuthentication\ yes/PubkeyAuthentication\ yes/g' /etc/ssh/sshd_config
sudo echo "TrustedUserCAKeys /etc/ssh/ca.pub" >> /etc/ssh/sshd_config.d/TrustedUserCAKeys.conf
sudo systemctl restart sshd
EOF