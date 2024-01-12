cat <<EOF
# Apply Apps Manifests
kubectl apply -f ./manfiests/k3s-chart/templates/httpbin.yaml
kubectl apply -f ./manfiests/k3s-chart/templates/whoami.yaml
kubectl apply -f ./manfiests/k3s-chart/templates/traefik-dashboard.yaml
kubectl get svc,ing -o wide
EOF