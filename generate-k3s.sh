rm -f output/k3s.sh
rm -f output/kubectl.sh
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

cd ../bash-templates
echo $PWD
echo "# Run locally from root of this repository" > ../output/k3s.sh
echo "# Assumes k3sup is installed locally" > ../output/k3s.sh
echo "# After cluster creation kubeconfig will be created" > ../output/k3s.sh
bash cluster.sh >> ../output/k3s.sh
echo "# Run locally from root of this repository" > ../output/kubectl.sh
echo "# kubeconfig is already exporeted" > ../output/kubectl.sh
bash  helm.sh>> ../output/kubectl.sh
bash  certs.sh>> ../output/kubectl.sh
bash  auth.sh>> ../output/kubectl.sh
bash  apps.sh>> ../output/kubectl.sh
bash  observability.sh>> ../output/kubectl.sh