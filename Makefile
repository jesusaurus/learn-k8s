# default action

.PHONY: status

status:
	kubectl get pods,services,hpa,ingress -A


# base infrastructure

.PHONY: infra check-deps minikube certman

check-deps:
	./scripts/check-deps.sh

minikube: check-deps
	minikube start
	minikube addons enable ingress
	minikube addons enable ingress-dns
	minikube addons enable metrics-server

deploy/cert-manager.crds.yaml:
	wget -O deploy/cert-manager.crds.yaml https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml

certman: deploy/cert-manager.crds.yaml
	kubectl apply -f deploy/cert-manager.crds.yaml
	kubectl apply -f deploy/selfsigned-issuer.yaml

infra: minikube certman


# app lifecycle

.PHONY: app-build app-test app-publish app-deploy app

app-build:
	docker build image/app -t test-app:test

app-test: app-build
	docker run -d -p 8080:80 --name test test-app:test
	sleep 3
	curl localhost:8080/ok
	curl localhost:8080/load
	sleep 3
	docker logs test
	docker stop test
	docker rm test

app-publish:
	docker tag test-app:test jesusaur/learn-k8s:latest
	docker push jesusaur/learn-k8s:latest

app-deploy:
	kubectl apply -f deploy/app.yaml

app: app-build app-publish app-deploy


# zero to sixty

.PHONY: check-dns set-dns load demo

check-dns:
	./scripts/check-dns.sh

set-dns:
	./scripts/set-dns.sh

load: check-dns
	kubectl get hpa fastapp-hpa
	./scripts/curl-or-wget.sh
	sleep 30
	kubectl get hpa fastapp-hpa
	sleep 30
	kubectl get hpa fastapp-hpa
	sleep 30
	kubectl get hpa fastapp-hpa


demo: infra set-dns app-deploy load


# clean up after ourselves

.PHONY: clean destroy

clean:
	kubectl delete -f deploy/app.yaml ||:

destroy: clean
	minikube delete --purge
