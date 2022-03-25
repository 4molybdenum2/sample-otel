namespace-k8s:
	kubectl apply -f k8s/namespace.yaml

jaeger-operator-k8s:
	# Create the jaeger operator and necessary artifacts in ns observability
	kubectl create -n observability -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.32.0/jaeger-operator.yaml

jaeger-k8s:
	kubectl apply -f k8s/jaeger.yaml

prometheus-k8s:
	kubectl apply -f k8s/prometheus

otel-collector-k8s:
	kubectl apply -f k8s/otel-collector.yaml

clean-prometheus-k8s:
	kubectl delete -f k8s/prometheus

clean-k8s:
	- kubectl delete -f k8s/otel-collector.yaml

	- kubectl delete -f k8s/prometheus

	- kubectl delete -f k8s/jaeger.yaml

	- kubectl delete -n observability -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.32.0/jaeger-operator.yaml