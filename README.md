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
