lint:
	hadolint Dockerfile

build:
	docker build -t mckain/my-flask-app .

upload:
	sh ./upload_docker.sh

all: lint build upload