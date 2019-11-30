from locust import HttpLocust, TaskSet, task, between
import locust.stats
locust.stats.CONSOLE_STATS_INTERVAL_SEC = 60
import requests
from urllib3.exceptions import InsecureRequestWarning

# Suppress only the single warning from urllib3 needed.
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

class UserBehavior(TaskSet):
    @task
    def simple(self):
        self.client.get("/simple", verify=False)

    # @task
    # def forward(self):
    #     self.client.get("/forward")


class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    wait_time = between(1000, 1000)
