import github
import os
import requests
import subprocess
import sys

def main():

    github_client = github.Github(os.environ['GITHUB_TOKEN'])

    for tag in github_client.get_user().get_repo('alpine-python').get_tags():

        rsp = requests.get(
            'https://hub.docker.com/v2/repositories/mrsipan/python/tags/{tag.name}'
            )

        if rsp.status_code != 200:

            subprocess.check_call(
                'docker build --build-arg VERSION={0} -t mrsipan/python:{0} .'.format(
                    os.environ['PYTHON_VERSION']
                    ),
                shell=True
                )

            subprocess.check_call(
                'docker login -u mrsipan -p {}'.format(os.environ['DOCKER_HUB_TOKEN']),
                shell=True
                )
            subprocess.check_call(
                'docker push mrsipan/python:{tag.name}'),
                shell=True
                )
            subprocess.check_call(
                'docker tag mrsipan/python:{tag.name} mrsipan/python:latest'),
                shell=True
                )
            subprocess.check_call(
                'docker push mrsipan/python:latest'),
                shell=True
                )


if __name__ == '__main__':
    sys.exit(main())
