#!/usr/bin/env bash

docker stop locust || true
docker run --volume ${PWD}/performance_test.sh:/performance_test.sh --volume ${PWD}/locustfile.py:/locustfile.py --env MOCKSERVER_HOST=host.docker.internal:1080 --rm --name locust -p 8089:8089 --entrypoint /performance_test.sh mockserver/mockserver:performance
