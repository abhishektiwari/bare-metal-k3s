cat <<EOF
# Allow to K8S API Port and CNI Subnet Range
sudo ufw allow 6443
sudo ufw allow from 10.42.0.0/16 to any
sudo ufw allow from 10.43.0.0/16 to any
EOF
for ip in `cat ../data/cluster-ips.txt`;
do
cat <<EOF
sudo ufw sudo ufw allow from ${ip}
EOF
done
cat <<EOF

# Reload the update firewall
sudo ufw reload
EOF