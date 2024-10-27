```bash helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus

eval $(minikube docker-env)
docker build -t myapp-exporter .
kubectl apply -f exporter-deployment.yaml
kubectl apply -f prometheus-config.yaml
kubectl port-forward svc/prometheus-server 9090:9090
```
