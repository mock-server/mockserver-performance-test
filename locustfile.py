from locust import TaskSet, task, between
import locust.stats
locust.stats.CONSOLE_STATS_INTERVAL_SEC = 60
from locust.contrib.fasthttp import FastHttpLocust

class UserBehavior(TaskSet):
    @task
    def simple(self):
        self.client.get("/simple", verify=False)

    # @task
    # def forward(self):
    #     self.client.get("/forward")

class WebsiteUser(FastHttpLocust):
    task_set = UserBehavior
    wait_time = between(1, 1)
