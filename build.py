import github
import os
import re
import requests
import subprocess
import sys


def main():

    subprocess.check_call(
        'docker build --build-arg VERSION={0} -t mrsipan/python:{0} .'.format(
            os.environ['PYTHON_VERSION']
            ),
        shell=True
        )

    if (mo := re.search(r'v(\d\.){3}', os.environ['TRAVIS_BRANCH'])):

        rsp = requests.get(
            f'https://hub.docker.com/v2/repositories/mrsipan/python/tags/{os.environ["TRAVIS_BRANCH"][1:]}'
            )

        if rsp.status_code == 200:
            print(f'Version {os.environ["PYTHON_VERSION"]} exists')

        else:

            subprocess.check_call(
                'docker login -u mrsipan -p {}'.format(os.environ['DOCKER_HUB_TOKEN']),
                shell=True
                )

            subprocess.check_call(
                'docker push mrsipan/python:{}'.format(
                    os.environ['PYTHON_VERSION']
                    ),
                shell=True
                )

            subprocess.check_call(
                'docker tag mrsipan/python:{} mrsipan/python:latest'.format(
                    os.environ['PYTHON_VERSION']
                    ),
                shell=True
                )

            subprocess.check_call(
                'docker push mrsipan/python:latest',
                shell=True
                )


if __name__ == '__main__':
    sys.exit(main())
