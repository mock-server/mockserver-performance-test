#!/usr/bin/env bash

# export JAVA_HOME=`/usr/libexec/java_home -v 12`
# java -XX:+UnlockExperimentalVMOptions -XX:+AlwaysPreTouch -Xms8192m -Xmx8192m -XX:-UseBiasedLocking -XX:+DisableExplicitGC -Dmockserver.logLevel=ERROR -Dmockserver.disableSystemOut=true -Dmockserver.nioEventLoopThreadCount=500 -jar ~/.m2/repository/org/mock-server/mockserver-netty/5.8.2-SNAPSHOT/mockserver-netty-5.8.2-SNAPSHOT-jar-with-dependencies.jar -serverPort 1080

ulimit -S -n 49152

for count in 0 10 50 100 500 1000 2500 5000 7500 10000 20000
do
  java -Dmockserver.logLevel=INFO \
    -Dmockserver.disableSystemOut=true \
    -Dmockserver.maxExpectations=$count \
    -jar ~/.m2/repository/org/mock-server/mockserver-netty/5.10.1-SNAPSHOT/mockserver-netty-5.10.1-SNAPSHOT-jar-with-dependencies.jar \
    -serverPort 1080 &
  ./performance_test_short.sh
done
