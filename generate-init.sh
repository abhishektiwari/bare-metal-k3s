# Generate bash files
rm -f output/init.sh
rm -f output/cloudflared.sh
rm -f output/cloudflared-sshd.sh
cd bash-templates
echo $PWD
echo "# Run remotely at the cluster node" > ../output/init.sh
bash update.sh >> ../output/init.sh
bash users.sh >> ../output/init.sh
bash sshd.sh >> ../output/init.sh
bash ufw-basic.sh >> ../output/init.sh
bash ufw-cluster.sh >> ../output/init.sh
bash node.sh >> ../output/init.sh
bash cloudflared.sh > ../output/cloudflared.sh
bash cloudflared-sshd.sh > ../output/cloudflared-sshd.sh