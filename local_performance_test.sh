#!/usr/bin/env bash

# export JAVA_HOME=`/usr/libexec/java_home -v 12`
# java -XX:+UnlockExperimentalVMOptions -XX:+AlwaysPreTouch -Xms8192m -Xmx8192m -XX:-UseBiasedLocking -XX:+DisableExplicitGC -Dmockserver.logLevel=ERROR -Dmockserver.disableSystemOut=true -Dmockserver.nioEventLoopThreadCount=500 -jar ~/.m2/repository/org/mock-server/mockserver-netty/5.8.2-SNAPSHOT/mockserver-netty-5.8.2-SNAPSHOT-jar-with-dependencies.jar -serverPort 1080

ulimit -S -n 49152

curl -v -s -X PUT http://localhost:1080/reset
curl -v -s -X PUT http://localhost:1080/expectation -d '[
    {
        "httpRequest": {
            "path": "/not_simple"
        },
        "httpResponse": {
            "statusCode": 200,
            "body": "some not simple response"
        },
        "times": {
            "unlimited": true
        }
    },
    {
        "httpRequest": {
            "method": "POST",
            "path": "/simple"
        },
        "httpResponse": {
            "statusCode": 200,
            "body": "some simple POST response"
        },
        "times": {
            "unlimited": true
        }
    },
    {
        "httpRequest": {
            "path": "/simple"
        },
        "httpResponse": {
            "statusCode": 200,
            "body": "some simple response"
        },
        "times": {
            "unlimited": true
        }
    },
    {
        "httpRequest": {
            "path": "/forward"
        },
        "httpOverrideForwardedRequest": {
            "httpRequest": {
                "headers": {
                    "host": [ "127.0.0.1:1080" ]
                },
                "path": "/simple"
            }
        },
        "times": {
            "unlimited": true
        }
    }
]'

echo "WARMUP"

sleep 2
locust --loglevel=INFO --no-web --only-summary -c 50 -r 50 -t 30 --host=http://127.0.0.1:1080 
sleep 10

echo "REAL RUNS...."

locust --loglevel=INFO --no-web --only-summary -c 50 -r 50 -t 30 --host=http://127.0.0.1:1080 
sleep 10
locust --loglevel=INFO --no-web --only-summary -c 100 -r 100 -t 30 --host=http://127.0.0.1:1080 
sleep 10
locust --loglevel=INFO --no-web --only-summary -c 250 -r 250 -t 30 --host=http://127.0.0.1:1080 
sleep 10
locust --loglevel=INFO --no-web --only-summary -c 500 -r 500 -t 30 --host=http://127.0.0.1:1080 
sleep 10
locust --loglevel=INFO --no-web --only-summary -c 750 -r 750 -t 30 --host=http://127.0.0.1:1080 
sleep 10
locust --loglevel=INFO --no-web --only-summary -c 1000 -r 1000 -t 30 --host=http://127.0.0.1:1080 
sleep 10
locust --loglevel=INFO --no-web --only-summary -c 2500 -r 2500 -t 30 --host=http://127.0.0.1:1080 
sleep 10
locust --loglevel=INFO --no-web --only-summary -c 5000 -r 5000 -t 30 --host=http://127.0.0.1:1080 
sleep 10
