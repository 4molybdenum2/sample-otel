# OpenTelemetry Collector Example

This is an example which highlights how to use OpenTelemetry to record traces for an application running on Kubernetes. This example deploys a Jaeger and Prometheus backnd for fetching Traces and Metrics respectively provided to them by an OpenTelemetry Collector which collects these data from the application.

## Creating a Cluster:

I have used KinD for running a local cluster.

config.yaml
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
```

Creating the Cluster

```sh
kind create cluster --config=config.yaml
```

The above config is just for the option if you want to use Ingress (I have used port-forwarding for viewing all the Prometheus and Jaeger UI).

## Setting up the Prometheus Operator:

```sh
git clone https://github.com/prometheus-operator/kube-prometheus.git
cd kube-prometheus
kubectl create -f manifests/setup

# wait for namespaces and CRDs to become available, then
kubectl create -f manifests/
```

For deleting

```sh
kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup
```

## Creating all of the required resources

```sh
# Create the namespace
make namespace-k8s

# Deploy Jaeger operator
make jaeger-operator-k8s

# After the operator is deployed, create the Jaeger instance
make jaeger-k8s

# Then the Prometheus instance. Ensure you have enabled a Prometheus operator
# before executing (see above).
make prometheus-k8s

# Finally, deploy the OpenTelemetry Collector
make otel-collector-k8s
```

For cleaning up run

```sh
make clean-k8s

# In case k8s get stuck removing namespaces
kubectl delete namespaces observability 
```

## Running the application:

In our case just:

```sh
go run main.go
```

## Viewing Traces and Metrics:

This is just for testing. Don't use in production
```
kubectl port-forward svc/jaeger-query 16686:16686 -n observability

kubectl port-forward svc/prometheus-k8s 9090:9090 -n monitoring
```

View traces on: localhost:16686
View metrics on: localhost:9090