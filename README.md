# My First Kubernetes

An exploration in minikube and autoscaling.

## Dependencies and Prerequisites

The following system dependencies must be installed:
* GNU Make
* Docker (must NOT use `btrfs` storage driver)
* Minikube binary
* Either curl or wget


## Quickstart

To build all infrastructure, deploy the test application, and generate load,
simply run (requires `sudo`):
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

To configure minikube with the needed cert-manager:
```
    make certman
```

To close the loop on certificate DNS, we need to ensure that `test.example.com`
resolves to the minikube IP (this command requires the use of `sudo` and is only
one possible solution for hostname resolution):
```
    make set-dns
```

To confirm that the host resolution works:
```
    make check-dns
```


### Build an App Image

To build a docker image locally for the test application, run
```
    make app-build
```
This will create a local image tagged as `test-app:test`.

To to also load-test the image with `docker-run`:
```
    make app-test
```

And, to publish the image to minikube\'s registry:
```
    make app-publish
```

### Deploy an App Image

To deploy the latest app image to minikube:
```
    make app-deploy
```

This last command doubles as an initial deployment as well as updating an
existing deployment.


### Exercise the Deployment

With the app successfully deployed in minikube, we can generate load and watch
autoscaling with:
```
    make load
```

### Tearing Everything Down

To tear down the application within minikube:
```
    make clean
```

Or, more drastically, to tear down minikube itself:
```
    make destroy
```

## TODO

* Autoscale on open connection count
* Encrypt secrets (tls key) at rest
* Encrypt internal cluster traffic
