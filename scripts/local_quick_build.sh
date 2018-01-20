#!/usr/bin/env bash

set -e

function runCommand {
    echo
    echo "$1"
    echo
    eval $1
    sleep 10
}

echo "+++ start docker"
runCommand "docker run -d -p 1080:1080 --name mockserver jamesdbloom/mockserver:latest /opt/mockserver/run_mockserver.sh -logLevel INFO -serverPort 1080"

echo "+++ JVM warm up"
runCommand "wrk --latency -c 5 -t 5 -d 10s http://localhost:1080/simple"
runCommand "wrk --latency -c 5 -t 5 -d 10s https://localhost:1080/simple"

echo "+++ HTTP 1 Thread"
runCommand "wrk --latency -c 1 -t 1 -d 180s http://localhost:1080/simple"
echo "+++ HTTP 5 Thread"
runCommand "wrk --latency -c 5 -t 5 -d 180s http://localhost:1080/simple"
echo "+++ HTTP 10 Thread"
runCommand "wrk --latency -c 10 -t 10 -d 180s http://localhost:1080/simple"
echo "+++ HTTP 100 Thread"
runCommand "wrk --latency -c 100 -t 100 -d 180s http://localhost:1080/simple"
echo "+++ HTTP 125 Thread"
runCommand "wrk --latency -c 125 -t 125 -d 180s http://localhost:1080/simple"

echo "+++ HTTPS 1 Thread"
runCommand "wrk --latency -c 1 -t 1 -d 180s https://localhost:1080/simple"
echo "+++ HTTPS 5 Thread"
runCommand "wrk --latency -c 5 -t 5 -d 180s https://localhost:1080/simple"
echo "+++ HTTPS 10 Thread"
runCommand "wrk --latency -c 10 -t 10 -d 180s https://localhost:1080/simple"
echo "+++ HTTPS 100 Thread"
runCommand "wrk --latency -c 100 -t 100 -d 180s https://localhost:1080/simple"
echo "+++ HTTPS 125 Thread"
runCommand "wrk --latency -c 125 -t 125 -d 180s https://localhost:1080/simple"
