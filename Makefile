# default action

.PHONY: status

status:
	kubectl get pods,services -A


# base infrastructure

.PHONY: minikube

minikube:
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

.PHONY: demo

demo: minikube app


# clean up after ourselves

.PHONY: clean

clean:
	kubectl delete -f deploy/app.yaml ||:
