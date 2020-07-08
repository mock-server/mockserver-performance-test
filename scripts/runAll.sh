#!/usr/bin/env bash

$(dirname $0)/runMockServer.sh

sleep 10

$(dirname $0)/runLocust.sh
