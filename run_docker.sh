#!/usr/bin/env bash

# Build image
docker build -t mckain/my-flask-app .

# List docker images
docker image ls

# Run flask app
docker run -p 8080:5000 -it --rm --name my-running-app mckain/my-flask-app