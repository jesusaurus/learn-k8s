# default action

.PHONY: status

status:
	kubectl get pods,services,hpa -A


# base infrastructure

.PHONY: minikube

minikube:
	minikube addons enable metrics-server
	minikube start


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

.PHONY: load demo

load:
	kubectl get hpa fastapp
	kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c 'for i in {1..33}; do wget -q -O- http://fastapp/load && sleep 0.1; done'
	kubectl get hpa fastapp
	sleep 10
	kubectl get hpa fastapp
	sleep 30
	kubectl get hpa fastapp
	sleep 30
	kubectl get hpa fastapp


demo: minikube app-deploy load


# clean up after ourselves

.PHONY: clean destroy

clean:
	kubectl delete -f deploy/app.yaml ||:

destroy: clean
	minikube delete
