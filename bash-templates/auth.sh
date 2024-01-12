cat <<EOF
# Apply traefik-forward-auth manifests
kubectl create secret generic traefik-forward-auth --from-env-file=./data/google-oidc-secrets.env -n kube-system
kubectl create configmap traefik-forward-auth --from-env-file=./data/google-oidc-config.env -n kube-system
kubectl get secret traefik-forward-auth -n kube-system -o jsonpath='{.data.PROVIDERS_OIDC_CLIENT_ID}' | base64 --decode
kubectl apply -f ./manfiests/k3s-chart/templates/traefik-helmchart-config-update.yaml
kubectl apply -f ./manfiests/k3s-chart/templates/auth-deployment.yaml
kubectl apply -f ./manfiests/k3s-chart/templates/auth-ingressroute.yaml
kubectl apply -f ./manfiests/k3s-chart/templates/auth-middleware.yaml
kubectl apply -f ./manfiests/k3s-chart/templates/auth-service.yaml
EOF
