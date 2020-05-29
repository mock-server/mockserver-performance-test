#!/usr/bin/env bash

# export JAVA_HOME=`/usr/libexec/java_home -v 12`

ulimit -S -n 49152

for count in 0 10 50 100 500 1000 2500 5000 7500 10000 20000
do
  java -Dmockserver.logLevel=INFO \
    -Dmockserver.disableSystemOut=true \
    -Dmockserver.maxExpectations=$count \
    -Dmockserver.outputMemoryUsageCsv=true \
    -jar ~/.m2/repository/org/mock-server/mockserver-netty/5.10.1-SNAPSHOT/mockserver-netty-5.10.1-SNAPSHOT-jar-with-dependencies.jar \
    -serverPort 1080 &
  MOCKSERVER_HOST=localhost:1080 ./performance_test_short.sh
done
