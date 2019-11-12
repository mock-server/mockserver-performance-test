#!/usr/bin/env bash

# set -e

function runCommand {
    echo
    echo "$1"
    echo
    sleep 3
    eval $1
    echo
}
function finish {
    runCommand "curl -v -s -X PUT http://$MOCKSERVER_HOST/stop"
}
trap finish SIGINT SIGTERM SIGKILL SIGQUIT EXIT

sleep 5
echo "+++ Create Expectation"
curl -v -s -X PUT http://$MOCKSERVER_HOST/expectation -d '[
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

echo "+++ JVM warm up"
runCommand "locust --loglevel=ERROR --no-web --only-summary -c 10 -r 10 -t 10 --host=http://$MOCKSERVER_HOST"

echo "+++ HTTP"
for count in 10 100 200 300 400 500 600 700 800 900 1000
do
    runCommand "locust --loglevel=INFO --no-web --only-summary --csv=1c_noTLS -c $count -r $count -t $count --host=http://$MOCKSERVER_HOST"
done