rm -f init.sh
rm -f k3s.sh
rm -f kubectl.sh
rm -R -f manifests/k3s-chart/templates
# Generate manifests
cd k3s-chart
echo $PWD

# https://github.com/helm/helm/issues/4680
# Based on https://github.com/helm/helm/issues/4680#issuecomment-613201032
helm template --dry-run . | awk -vout=../manifests -F": " '
  $0~/^# Source: / {
    file=out"/"$2;
    if (!(file in filemap)) {
      filemap[file] = 1
      print "Creating "file;
      system ("mkdir -p $(dirname "file")");
    }
    print "---" >> file;
  }
  $0!~/^# Source: / {
    if ($0!~/^---$/) {
      if (file) {
        print $0 >> file;
      }
    }
  }'

touch ../manifests/k3s-chart/templates/.gitkeep
# Generate bash files
cd ../bash-templates
echo $PWD
echo "# Run remotely at the cluster node" > ../init.sh
bash ufw-cluster.sh >> ../init.sh
bash node.sh >> ../init.sh
echo "# Run locally from root of this repository" > ../k3s.sh
echo "# Assumes k3sup is installed locally" > ../k3s.sh
echo "# After cluster creation kubeconfig will be created" > ../k3s.sh
bash cluster.sh >> ../k3s.sh
echo "# Run locally from root of this repository" > ../kubectl.sh
echo "# kubeconfig is already exporeted" > ../kubectl.sh
bash  helm.sh>> ../kubectl.sh
bash  certs.sh>> ../kubectl.sh
bash  auth.sh>> ../kubectl.sh
bash  apps.sh>> ../kubectl.sh
bash  observability.sh>> ../kubectl.sh