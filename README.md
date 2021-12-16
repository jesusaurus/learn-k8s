# My First Kubernetes

An exploration in minikube and autoscaling.

## Dependencies and Prerequisites

The following system dependencies must be installed:
* GNU Make
* Docker (must NOT use `btrfs` storage driver)
* Minikube binary
* Either curl or wget

In order to publish images to Docker Hub (a subcommand of `make app`),
you must be logged in to Docker Hub with an account that can publish
images to the `jesusaur` account.


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

Building an application image is not necessary, and publishing a built image
requires `jesusaur` credentials to Docker Hub:
```
    docker login
```

To build a docker image locally for the test application, run
```
    make app-build
```
This will create a local image tagged as `test-app:test`.

To build an image and test locally with `docker-run`:
```
    make app-test
```

If you are logged in with sufficient credentials, you can upload the
`test` tag as the new `latest` tag with:
```
    make app-publish
```

### Deploy an App Image

To deploy the latest app image to our local minikube:
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

* Parameterize the docker publish account
* Autoscale on open connection count
* Split build and deploy into separate projects
* Create local repository so that the demo is self-contained instead of dependent on docker hub
  - go from 2-stage (build locally, publish publically) to
    3-stage (build locally, publish and test locally, publish publically) proceses
