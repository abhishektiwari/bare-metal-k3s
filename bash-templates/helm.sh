cat <<EOF
helm repo add jetstack https://charts.jetstack.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts 
helm repo update

# Do installs and perform check
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.13.3 --set installCRDs=true
kubectl -n cert-manager get pod

# helm install prometheus prometheus-community/prometheus
# helm install grafana grafana/grafana
EOF