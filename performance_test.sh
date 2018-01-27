#!/usr/bin/env bash

set -e

function runCommand {
    echo
    echo "$1"
    echo
    sleep 5
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
    }
]'

echo "+++ JVM warm up"
runCommand "locust --loglevel=ERROR --no-web --only-summary -c 10 -r 10 -n 100 --host=http://$MOCKSERVER_HOST"

echo "+++ HTTP"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=1c_noTLS -c 1 -r 1 -n 10 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=10c_noTLS -c 10 -r 10 -n 100 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=100c_noTLS -c 100 -r 100 -n 1000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 200 -r 200 -n 20000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 250 -r 250 -n 25000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 300 -r 300 -n 30000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 350 -r 350 -n 35000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 400 -r 400 -n 40000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 450 -r 450 -n 45000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 500 -r 500 -n 50000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 550 -r 550 -n 55000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 600 -r 600 -n 60000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 650 -r 650 -n 65000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 700 -r 700 -n 70000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 750 -r 750 -n 75000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 800 -r 800 -n 80000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 850 -r 850 -n 85000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 900 -r 900 -n 90000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 950 -r 950 -n 95000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 1000 -r 1000 -n 100000 --host=http://$MOCKSERVER_HOST"
runCommand "locust --loglevel=INFO --no-web --only-summary --csv=200c_noTLS -c 1050 -r 1050 -n 105000 --host=http://$MOCKSERVER_HOST"