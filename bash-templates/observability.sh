cat <<EOF
kubectl create namespace observability
helm install observability -f ./values/prometheus.yaml prometheus-community/kube-prometheus-stack -n observability
kubectl apply -f ./manfiests/k3s-chart/templates/observability.yaml
# helm upgrade observability -f ./values/prometheus.yaml prometheus-community/kube-prometheus-stack -n observability
EOF