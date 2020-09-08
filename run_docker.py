#!/usr/bin/env bash

# Build image
docker build -t my-flask-app .

# List docker images
docker image ls

# Run flask app
docker run -it --rm --name my-running-app my-flask-app