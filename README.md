# Telepítési útmutató

## Előfeltételek

Az exporter futtatásához a következő szoftvereket kell telepítened a fejlesztői környezetedbe:

- **Docker** (verzió: 27.5.1)
- **Minikube** (verzió: 1.35.0)
- **Helm** (verzió: 3.17.0)

---

## 1. Lokális Kubernetes klaszter indítása

Minikube segítségével indítható el egy lokális Kubernetes klaszter az alábbi paranccsal PowerShell vagy Bash terminálból:

> **Megjegyzés:** Windows rendszeren fontos, hogy a Minikube által létrehozott klaszter ne kerüljön pl. WSL mögé vizualizáció céljából.

```bash
minikube start
```

---

## 2. Helm chart repók hozzáadása

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add grafana https://grafana.github.io/helm-charts
```

---

## 3. Redis jelszó és telepítés

> **Fontos:** A `<redis-password>` értéket módosítani kell! A Redis telepítése előtt futtasd le az alábbi `kubectl create secret` parancsot.

```bash
kubectl create secret generic redis-secret --from-literal=redis-password=<redis-password>
helm upgrade --install redis bitnami/redis -f redis-20.8.0/redis/values.yaml --version 20.8.0
```

---

## 4. Exporter Docker konténer buildelése
### Bash:
```bash
eval $(minikube docker-env)
docker build -t custom-exporter:latest .
```


---

## 5. Exporter telepítése Kubernetes klaszterbe

```bash
kubectl apply -f exporter-deployment.yaml
```

---

## 6. Prometheus és Grafana telepítése

```bash
helm upgrade --install prometheus prometheus-community/prometheus -f prometheus-values.yaml --version 27.4.0
helm upgrade --install grafana grafana/grafana --set persistence.enabled=true --version 8.10.1 -f grafana-values.yaml
```

---

## 7. Grafana inicializálása

### 1. Futó grafana pod nevének kigyűjtése

```bash
kubectl get pods | grep grafana
```

> **Fontos:** A lekért `pod` nevét mentsd el, szükséged lesz rá a belépéshez! példa : grafana-75d7db7458-96g6r

---

### 2. Grafana db migrálás

> **Fontos:** Az előzőnek lekért `pod` nevét másold be a < grafana-pod-name > placeholderbe! példa : grafana-75d7db7458-96g6r
```bash
kubectl cp ./grafana.db <grafana-pod-name>:/var/lib/grafana/grafana.db
kubectl scale deployment grafana --replicas=0
kubectl scale deployment grafana --replicas=1
```

### 3. Grafana bejelentkezés

```bash
minikube service grafana
```

Jelentkezz be a felületen:
- Felhasználónév: `admin`
- Jelszó: my1LjuVGyJkLE1KptuW21LnKPmqdr99KIaqz2eFc

---

> **Ismert hiba:** Előfordulhat, hogy az importálás után a panelek nem mutatnak adatokat. Ilyenkor kattints a panelek jobb felső sarkában található hamburger ikonra, válaszd az `Edit` opciót, majd lépj ki. Ezzel frissül a nézet.

