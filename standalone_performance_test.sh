#!/usr/bin/env bash

export JAVA_HOME=`/usr/libexec/java_home -v 13`

ulimit -S -n 49152

for maxExpectations in 100 500 1000 # 2500 5000 7500 10000 15000 20000 25000 30000 35000 40000 45000 50000
do
  curl -v -k -X PUT http://localhost:1080/mockserver/stop || true
  sleep 2
  java -Xmx8g -Dmockserver.logLevel=WARN \
    -Dmockserver.disableSystemOut=true \
    -Dmockserver.maxExpectations=$maxExpectations \
    -Dmockserver.outputMemoryUsageCsv=false \
    -jar ~/.m2/repository/org/mock-server/mockserver-netty/5.11.1-SNAPSHOT/mockserver-netty-5.11.1-SNAPSHOT-jar-with-dependencies.jar \
    -serverPort 1080 &
  sleep 5
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
  for count in 10 100 150 200 # 300 400 500 600 700 800
  do
      locust --loglevel=DEBUG --headless --only-summary --csv="${maxExpectations}_${count}" -u $count -r 15 -t 10 --host=http://127.0.0.1:1080
      curl -v -k -X PUT http://localhost:1080/mockserver/reset
  done
  curl -v -k -X PUT http://localhost:1080/mockserver/stop || true
  sleep 2
done
