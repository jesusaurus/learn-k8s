# My First Kubernetes

An exploration in minikube and autoscaling.

## Dependencies and Prerequisites

The local system needs to have `make`, `docker`, and `minikube` installed.
You must also be logged in to Docker Hub with an account that can publish
images to the `jesusaur` account in order to publish images.

```
    docker login
```

## Quickstart


To build all infrastructure and deploy the test application, run:
```
    make demo
```


## Under the Hood

### Minikube

The first step in to start minikube, which can be done with:
```
    make minikube
```

The status of the kubernetes cluster can be viewed at any time with:
```
    make
```

To build a docker image locally for the test application, run
```
    make app-build
```
This will create a local `test` tag for the image.


If you are logged in with sufficient credentials, you can upload the
`test` tag as the new `latest` tag with:
```
    make app-publish
```

Once a new image has been published, it can be deployed to the local
cluster with:
```
    make app-deploy
```

## TODO

* Parameterize the docker publish account
* Switch from NodePort to LoadBalancer with `minikube tunnel`
* Load balancer ssl offloading
* Autoscale on open connection count
* Split build and deploy into separate projects
* Create local repository so that the demo is self-contained instead of dependent on docker hub
  - will require key management infrastructure
  - go from 2-stage (build locally, publish publically) to 3-step (build locally, publish and test locally, publish publically) proceses
