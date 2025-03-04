```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/prometheus -f prometheus-values.yaml --version 27.4.0

eval $(minikube docker-env)
docker build -t custom-exporter .
kubectl apply -f exporter-deployment.yaml
kubectl apply -f prometheus-config.yaml
minikube service prometheus-server

for i in {1..10000}; do kubectl exec -it redis-master-0 -- redis-cli -a "<redis-password>" SET "key$i" "value$i"; done

helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install redis bitnami/redis -f redis-20.8.0/redis/values.yaml --version 20.8.0
kubectl create secret generic redis-secret --from-literal=redis-password=<redis-password>

helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install grafana grafana/grafana --set persistence.enabled=false --version 8.10.1

```
