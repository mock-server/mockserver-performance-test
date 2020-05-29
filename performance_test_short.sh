#!/usr/bin/env sh

# set -e

runCommand() {
    echo
    echo "$1"
    echo
    sleep 3
    eval "$1"
    echo
}
finish() {
    runCommand "curl -v -s -X PUT http://$MOCKSERVER_HOST/status"
    runCommand "curl -v -s -X PUT http://$MOCKSERVER_HOST/reset"
    sleep 30
    runCommand "curl -v -s -X PUT http://$MOCKSERVER_HOST/status"
    runCommand "curl -v -s -X PUT http://$MOCKSERVER_HOST/stop"
}
trap finish INT TERM QUIT EXIT

echo "+++ Record Empty Memory"
runCommand "curl -v -s -X PUT http://$MOCKSERVER_HOST/status"

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
    }
]'

echo "+++ JVM warm up"
runCommand "locust --loglevel=ERROR --no-web --only-summary -c 6000 -r 10 -t 60 --host=http://$MOCKSERVER_HOST"

echo "+++ HTTP"
for count in 6000 6000 6000 6000
do
    runCommand "locust --loglevel=INFO --no-web --only-summary --csv=1c_noTLS -c $count -r 15 -t 45 --host=http://$MOCKSERVER_HOST"
done
