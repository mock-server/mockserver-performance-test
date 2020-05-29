import uuid

import locust.stats
from locust import TaskSet, task, between

locust.stats.CONSOLE_STATS_INTERVAL_SEC = 60
# https://docs.locust.io/en/stable/increase-performance.html
from locust.contrib.fasthttp import FastHttpLocust

class UserBehavior(TaskSet):
    @task
    def expectation_and_request(self):
        self.client.put("/mockserver/expectation",
                        "{\n" +
                        "    \"httpRequest\": {\n" +
                        "        \"method\": \"POST\",\n" +
                        "        \"path\": \"/" + str(uuid.uuid4()) + "\"\n" +
                        "    },\n" +
                        "    \"httpResponse\": {\n" +
                        "        \"statusCode\": 200,\n" +
                        "        \"body\": \"some simple body\"\n" +
                        "    },\n" +
                        "    \"times\": {\n" +
                        "        \"unlimited\": true\n" +
                        "    }\n" +
                        "}",
                        verify=False)
        self.client.get("/simple", verify=False)

    # @task
    # def forward(self):
    #     self.client.get("/forward")

class WebsiteUser(FastHttpLocust):
    task_set = UserBehavior
    wait_time = between(1, 1)
