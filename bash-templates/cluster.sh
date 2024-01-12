ip_i=0
ip_master="None"
for ip in `cat ../data/cluster-ips.txt`;
do
if [[ $ip_i = 0 ]]
then
cat <<EOF
k3sup install --cluster --host ${ip} --user $(<../data/cluster-user.txt) --ssh-key $HOME/.ssh/id_ed25519 --k3s-extra-args '--secrets-encryption'
EOF
ip_i=$((ip_i + 1))
ip_master=$ip
else
cat <<EOF
k3sup join --ip ${ip} --user abhishek --server-user $(<../data/cluster-user.txt) --server-ip ${ip_master} --server --ssh-key $HOME/.ssh/id_ed25519 --k3s-extra-args '--secrets-encryption'
EOF
fi
done
cat <<EOF
export KUBECONFIG=$(<./partials/pwd)/kubeconfig
kubectl config use-context default
kubectl get node -o wide
EOF