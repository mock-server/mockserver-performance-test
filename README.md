# mockserver-performance-test
Performance Test Suite for MockServer http://mock-server.com

Current MockServer results are (all figures are in **milliseconds**):

|   req/s  |   reqs | Avg | Min | Max | Median | 50% | 66% | 75% | 80% | 90% | 95% | 98% |99% | 100%
:----------|:-------|:----|:----|:----|:-------|:----|:----|:----|:----|:----|:----|:----|:---|:----
|   50     |   2476 |   2 |   1 |  12 |      2 |   2 |   3 |   3 |   3 |   3 |   4 |   5 |  5 |   12
|   99     |   4891 |   4 |   0 |  18 |      3 |   3 |   4 |   5 |   5 |   6 |   7 |   8 |  9 |   18
|  496     |  22271 |   7 |   0 |  65 |      6 |   6 |   7 |   9 |  10 |  12 |  15 |  19 | 22 |   65	
|  995     | 106830 |  20 |   0 | 236 |      6 |   6 |  13 |  19 |  25 |  57 |  97 | 140 |160 |  240
| 1243     | 135671 | 113 |   0 | 434 |    110 | 110 | 140 | 160 | 170 | 210 | 250 | 290 |300 |  430

These were recorded with 4 expectations in MockServer where the request matched the 3rd expectation.

In summary, MockServer can easily handle **50 TPS with a p99 of 5ms** and can scale up to **1250 TPS with a p99 of 300ms**.

# Notes:

Can run from the command line as follows:

locust --loglevel=DEBUG --headless --only-summary -u 600 -r 15 -t 180 --host=http://127.0.0.1:1080

# Apache Benchmark

Apache Benchmark doesn't open a separate connection for each user so produces much faster performances

# create expectations

ab -u expectations.json -T application/json -k -n 100 -c 10 http://127.0.0.1:1080/mockserver/expectation

```bash
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient).....done


Server Software:        
Server Hostname:        127.0.0.1
Server Port:            1080

Document Path:          /mockserver/expectation
Document Length:        1291 bytes

Concurrency Level:      10
Time taken for tests:   0.207 seconds
Complete requests:      100
Failed requests:        0
Keep-Alive requests:    100
Total transferred:      142500 bytes
Total body sent:        109100
HTML transferred:       129100 bytes
Requests per second:    483.21 [#/sec] (mean)
Time per request:       20.695 [ms] (mean)
Time per request:       2.069 [ms] (mean, across all concurrent requests)
Transfer rate:          672.44 [Kbytes/sec] received
                        514.83 kb/s sent
                        1187.26 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:    12   19   4.1     19      38
Waiting:       11   19   4.1     18      38
Total:         12   19   4.2     19      39

Percentage of the requests served within a certain time (ms)
  50%     19
  66%     20
  75%     21
  80%     22
  90%     24
  95%     27
  98%     30
  99%     39
 100%     39 (longest request)
```

# request matcher

ab -k -n 100000 -c 10 http://127.0.0.1:1080/simple

```bash
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient)
Completed 10000 requests
Completed 20000 requests
Completed 30000 requests
Completed 40000 requests
Completed 50000 requests
Completed 60000 requests
Completed 70000 requests
Completed 80000 requests
Completed 90000 requests
Completed 100000 requests
Finished 100000 requests


Server Software:        
Server Hostname:        127.0.0.1
Server Port:            1080

Document Path:          /simple
Document Length:        20 bytes

Concurrency Level:      10
Time taken for tests:   11.243 seconds
Complete requests:      100000
Failed requests:        0
Keep-Alive requests:    100000
Total transferred:      8300000 bytes
HTML transferred:       2000000 bytes
Requests per second:    8894.41 [#/sec] (mean)
Time per request:       1.124 [ms] (mean)
Time per request:       0.112 [ms] (mean, across all concurrent requests)
Transfer rate:          720.93 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:     0    1   0.5      1      22
Waiting:        0    1   0.5      1      22
Total:          0    1   0.5      1      22

Percentage of the requests served within a certain time (ms)
  50%      1
  66%      1
  75%      1
  80%      1
  90%      1
  95%      2
  98%      2
  99%      3
 100%     22 (longest request)
```