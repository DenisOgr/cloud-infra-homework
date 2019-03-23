
##Start
minikube start
minikube dashboard

##Deployment
kubectl apply -f development.yml
kubectl get deployments
kubectl delete deployments load-cpu-dev

##Pods
kubectl get pods


##Services
kubectl get services
kubectl expose deployment load-cpu-dev --type=NodePort --port=5000

##Balancer
kubectl apply -f service.yml
kubectl describe services service-node-port
minikube service load-cpu-dev --url
kubectl delete service load-cpu-dev

kubectl logs -f load-cpu-5958ccb5b8-rbn4j
