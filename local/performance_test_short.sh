#!/usr/bin/env sh

# set -e

ulimit -S -n 49152

runCommand() {
    echo
    echo "$1"
    echo
    sleep 5
    eval "$1"
    echo
}
finish() {
    runCommand "curl -v -s -X PUT http://127.0.0.1:1080/reset"
}
trap finish INT TERM QUIT EXIT

echo "+++ Create Expectation"
curl -v -s -X PUT http://127.0.0.1:1080/expectation -d '[
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

echo "+++ HTTP"
for count in 10 100 150 200 300 400 500 600 700 800
do
    runCommand "locust --loglevel=INFO --headless --only-summary --csv=$count -u $count -r 15 -t 10 --host=http://127.0.0.1:1080"
    runCommand "curl -v -k -X PUT http://localhost:1080/reset"
done
