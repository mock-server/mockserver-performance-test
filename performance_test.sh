#!/usr/bin/env bash

set -e

function runCommand {
    echo
    echo "$1"
    echo
    sleep 10
    eval $1
    echo
}

echo "+++ JVM warm up"
runCommand "wrk --latency -t2 -c100 -d10s -R2000 https://$MOCKSERVER_HOST/simple"
runCommand "wrk --latency -t2 -c100 -d10s -R2000 https://$MOCKSERVER_HOST/simple"

echo "+++ HTTP 1 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R1 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 5 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R5 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 10 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R10 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 100 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R100 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 1000 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R1000 http://$MOCKSERVER_HOST/simple"

echo "+++ HTTPS 1 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R1 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 5 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R5 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 10 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R10 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 100 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R100 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 1000 request/sec"
runCommand "wrk --latency -t2 -c100 -d18s -R1000 https://$MOCKSERVER_HOST/simple"
