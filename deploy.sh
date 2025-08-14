docker build . -t product
kind load docker-image product
kubectl apply -f manifests/poc.yaml
