
##Start
minikube start
minikube dashboard
minikube stop
minikube delete

##Deployment
kubectl apply -f development.yml
kubectl get deployments
kubectl delete deployments load-cpu-dev

##Pods
kubectl get pods


##Services
#kubectl expose deployment load-cpu-dev --type=NodePort --port=5000
kubectl apply -f service.yml
kubectl get services
minikube service service-node-port --url
kubectl delete service service-node-port

##Autoscaling CPU
kubectl apply -f autoscale-cpu.yml
kubectl get hpa
kubectl describe hpa autoscaling-cpu-load
kubectl delete hpa autoscaling-cpu-load


##Autoscaling Memory
kubectl apply -f autoscale-memory.yml
kubectl get hpa
kubectl describe hpa autoscaling-memory-load
kubectl delete hpa autoscaling-memory-load

##Metric server
kubectl apply -f metrics-server/deploy/1.8+/
minikube addons enable metrics-server
kubectl top pods
