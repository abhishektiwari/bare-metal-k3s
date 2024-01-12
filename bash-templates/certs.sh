cat <<EOF

# Install cert-manager-chart and perform check
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.13.3 --set installCRDs=true
kubectl -n cert-manager get pod

# Apply manifests to create wildcard certs
kubectl create secret generic cloudflare-api-token-secret --from-env-file=./data/cf-token.env -n cert-manager
kubectl apply -f ./manfiests/k3s-chart/templates/cloudflare-acme-dns01.yaml
kubectl apply -f ./manfiests/k3s-chart/templates/wildcard-tls-d3ml-com.yaml
kubectl logs -l app=cert-manager -n cert-manager
kubectl get certificates -A
kubectl get clusterissuers -A
EOF