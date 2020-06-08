#!/usr/bin/env bash

# export JAVA_HOME=`/usr/libexec/java_home -v 12`

ulimit -S -n 49152

#for count in 0 10 50 100 500 1000 2500 5000 7500 10000 15000 20000 25000 30000 35000 40000 45000 50000
#for count in 0
#do
  curl -v -k -X PUT http://localhost:1080/stop || true
  sleep 1
  java -Xmx8g -Dmockserver.logLevel=WARN \
    -Dmockserver.disableSystemOut=true \
    -Dmockserver.outputMemoryUsageCsv=false \
    -jar ~/.m2/repository/org/mock-server/mockserver-netty/5.10.1-SNAPSHOT/mockserver-netty-5.10.1-SNAPSHOT-jar-with-dependencies.jar \
    -serverPort 1080 &
  sleep 2
  MOCKSERVER_HOST=localhost:1080 ./performance_test_short.sh
#done

#    -Dmockserver.maxExpectations=$count \
