#!/usr/bin/env bash

set -e

function runCommand {
    echo
    echo "$1"
    echo
    sleep 2
    eval $1
    echo
}

sleep 2
echo "+++ Create Expectation"
curl -v -s -X PUT http://$MOCKSERVER_HOST/expectation -d '{
    "httpRequest": {
        "path": "/simple"
    },
    "httpResponse": {
        "statusCode": 200,
        "body": "some response"
    },
    "times": {
        "unlimited": true
    }
}'

echo "+++ JVM warm up"
#runCommand "wrk --latency -t2 -c100 -d10s -R2000 https://$MOCKSERVER_HOST/simple"
runCommand "ab -n 100 -c 10 http://$MOCKSERVER_HOST/simple"
#runCommand "wrk --latency -t2 -c100 -d10s -R2000 https://$MOCKSERVER_HOST/simple"
runCommand "ab -n 100 -c 10 https://$MOCKSERVER_HOST/simple"

#echo "+++ HTTP 1 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R1 http://$MOCKSERVER_HOST/simple"
#echo "+++ HTTP 5 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R5 http://$MOCKSERVER_HOST/simple"
#echo "+++ HTTP 10 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R10 http://$MOCKSERVER_HOST/simple"
#echo "+++ HTTP 100 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R100 http://$MOCKSERVER_HOST/simple"
#echo "+++ HTTP 1000 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R1000 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 1 connections"
runCommand "ab -n 10000 -c 1 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 5 connections"
runCommand "ab -n 10000 -c 5 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 10 connections"
runCommand "ab -n 10000 -c 10 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 50 connections"
runCommand "ab -n 10000 -c 50 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 100 connections"
runCommand "ab -n 10000 -c 100 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 150 connections"
runCommand "ab -n 10000 -c 150 http://$MOCKSERVER_HOST/simple"
echo "+++ HTTP 250 connections"
runCommand "ab -n 10000 -c 250 http://$MOCKSERVER_HOST/simple"

#echo "+++ HTTPS 1 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R1 https://$MOCKSERVER_HOST/simple"
#echo "+++ HTTPS 5 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R5 https://$MOCKSERVER_HOST/simple"
#echo "+++ HTTPS 10 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R10 https://$MOCKSERVER_HOST/simple"
#echo "+++ HTTPS 100 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R100 https://$MOCKSERVER_HOST/simple"
#echo "+++ HTTPS 1000 request/sec"
#runCommand "wrk --latency -t2 -c100 -d18s -R1000 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 1 connections"
runCommand "ab -n 10000 -c 1 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 5 connections"
runCommand "ab -n 10000 -c 5 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 10 connections"
runCommand "ab -n 10000 -c 10 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 50 connections"
runCommand "ab -n 10000 -c 50 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 100 connections"
runCommand "ab -n 10000 -c 100 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 150 connections"
runCommand "ab -n 10000 -c 150 https://$MOCKSERVER_HOST/simple"
echo "+++ HTTPS 250 connections"
runCommand "ab -n 10000 -c 250 https://$MOCKSERVER_HOST/simple"
