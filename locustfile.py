from locust import HttpLocust, TaskSet, task
import locust.stats
locust.stats.CONSOLE_STATS_INTERVAL_SEC = 60

class UserBehavior(TaskSet):
    @task(1)
    def simple(self):
        self.client.get("/simple")


class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 1000
    max_wait = 1000
