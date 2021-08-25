import sys
import gitlab
import simplejson as json


if len(sys.argv) <= 1:
    print("Uso:",sys.argv[0],"[project id] [L|D]" )
    sys.exit(1)

project_id = sys.argv[1]
token = "Put here your api token"
host = 'Put here your gitlab host'
from_page = 20
to_page = 1

gl = gitlab.Gitlab(host, private_token=token)
project = gl.projects.get( project_id )


def get_job_list(project_conn):
    return project_conn.jobs.list(page=i, per_page=20)


def has_artifact(job):
        try:
                a = job.artifacts_file
                return True
        except:
                return False

for i in range(from_page, to_page , -1):
    for job in reversed(get_job_list(project)):
        if has_artifact(job) and job.tag == False:
            if sys.argv[2] == 'D':
                print(str(job.id) + " Artifact Deleted")
                job.erase()
            else:
                print(str(job.id))
