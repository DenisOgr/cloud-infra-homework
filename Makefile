include .env

APP_NAME = Homwwork Kubertets

SHELL ?= /bin/bash
ARGS = $(filter-out $@,$(MAKECMDGOALS))
CONFIG_DIR = "./kubernetes"

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
Makefile: ;              # skip prerequisite discovery

# Run make help by default
.DEFAULT_GOAL = help

.env:
	cp $@.dist $@

.PHONY: create_cluster
create_cluster: ## Create minicube claster and open dashboard
	minikube start
	minikube addons enable metrics-server
	minikube dashboard

.PHONY: destroy_cluster
destroy_cluster: ## Destroy minicube claster
	minikube stop
	minikube delete


.PHONY: create
up: ## Create deploment, services, pods, hpa`s
	kubectl apply -f  "${CONFIG_DIR}/development.yml"
	kubectl apply -f  "${CONFIG_DIR}/service.yml"
	kubectl apply -f  "${CONFIG_DIR}/autoscale-cpu.yml"
	kubectl apply -f  "${CONFIG_DIR}/autoscale-memory.yml"

.PHONY: create_from_local
create_from_local: ## Create deploment (images ONLY from local rep), services, pods, hpa`s
	kubectl apply -f  "${CONFIG_DIR}/development_local_repository.yml"
	kubectl apply -f  "${CONFIG_DIR}/service.yml"
	kubectl apply -f  "${CONFIG_DIR}/autoscale-cpu.yml"
	kubectl apply -f  "${CONFIG_DIR}/autoscale-memory.yml"

.PHONY: destroy
destroy: ## Remove deploment, services, pods, hpa`s
	kubectl delete hpa $(HPA_MEMORY_NAME)
	kubectl delete hpa $(HPA_CPU_NAME)
	kubectl delete service $(SERVICE_NODE_PORT_NAME)
	kubectl delete deployments $(DEPLOYMENT_NAME)

.PHONY: show
show: ## Show deploment, services, pods, hpa`s
	echo "Deployments:"
	echo '━━━━━━━━━━━━━━━━━━━━'
	kubectl get deployments
	echo '━━━━━━━━━━━━━━━━━━━━'
	echo ''
	@echo "Pods:"
	echo '━━━━━━━━━━━━━━━━━━━━'
	kubectl get pods
	echo '━━━━━━━━━━━━━━━━━━━━'
	echo ''
	@echo "Services:"
	echo '━━━━━━━━━━━━━━━━━━━━'
	kubectl get services
	echo '━━━━━━━━━━━━━━━━━━━━'
	echo ''
	@echo "Hpa:"
	echo '━━━━━━━━━━━━━━━━━━━━'
	kubectl get hpa
	echo '━━━━━━━━━━━━━━━━━━━━'

.PHONY: desc
desc: ## Describe deploment, services, pods, hpa`s
	echo "Deployments:"
	echo '━━━━━━━━━━━━━━━━━━━━'
	kubectl describe deployments $(DEPLOYMENT_NAME)
	echo '━━━━━━━━━━━━━━━━━━━━'
	echo ''
	@echo "Services:"
	echo '━━━━━━━━━━━━━━━━━━━━'
	kubectl describe services $(SERVICE_NODE_PORT_NAME)
	echo '━━━━━━━━━━━━━━━━━━━━'
	echo ''
	@echo "Hpa:"
	echo '━━━━━━━━━━━━━━━━━━━━'
	kubectl describe hpa $(HPA_CPU_NAME)
	echo '━━━━━━━━━━━━━━━━━━━━'
	kubectl describe hpa $(HPA_MEMORY_NAME)
	echo '━━━━━━━━━━━━━━━━━━━━'

.PHONY: load_cpu
load_cpu: ## Load CPU. Necessarily use argument secs={time}. For example: make load_cpu secs=10
	curl "${APP_URL}/run_cpu/${secs}" > /dev/null 2>&1 &
	echo "I will loaded CPUs for ${secs} seconds"
	echo "Use command \"make show\" to observe autoscaling"

.PHONY: load_memory
load_memory: ## Load memory. Necessarily use argument secs={time}. For example: make load_cpu secs=10
	curl "${APP_URL}/run_ram/${secs}"  > /dev/null 2>&1 &
	echo "I will loaded RAM for ${secs} seconds" &
	echo "Use command `make show` to observe autoscaling"

.PHONY: help
help: ## Show this help and exit (default target)
	$(info $(APP_NAME))
	echo '                   Available targets:'
	# Print all commands, which have '##' comments right of it's name.
	# Commands gives from all Makefiles included in project.
	# Sorted in alphabetical order.
	echo '                   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	grep -hE '^[a-zA-Z. 0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		 awk 'BEGIN {FS = ":.*?## " }; {printf "\033[36m%+18s\033[0m: %s\n", $$1, $$2}'
	echo '                   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	echo ''
%:
	@:
