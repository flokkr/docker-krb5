#!/bin/bash
DOCKER_TAG=${DOCKER_TAG:-latest}
docker build -t elek/krb5:$DOCKER_TAG . 
