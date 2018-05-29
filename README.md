# Minimalistic docker image to cancel CircleCI 2.0 redundant builds

Unfortunately, CircleCI 2.0 workflow builds don't support cancellation redundant builds. When you push your code too often, the whole CI workflow can be stuck unless all your previous jobs are performed.

Ready docker image is available from [Docker Hub](https://hub.docker.com/r/sponomarev/circleci-cancel-builds/).

## How it works

- The script inside docker container understands repository, current branch and build number from build-in [ENV variables](https://circleci.com/docs/2.0/env-vars/#circleci-built-in-environment-variables)
- Fetches the list of the running or enqueued builds within current branch
- Excludes current build from the list
- Cancels redundant builds one by one

## Installation

- Generate CircleCI API using your [account dashboard](https://circleci.com/account/api)
- Add it as `CIRCLEC_TOKEN` environment variable to your [project settings](https://circleci.com/docs/2.0/env-vars/#setting-an-environment-variable-in-a-project)
- Add a separate job using `sponomarev/circleci-cancel-builds` docker image as a required first step in your build workflow
- Invoke `run` command 

```yml
version: 2

workflows:
  version: 2
  build_and_test:
    jobs:
      - cancel_redundant_builds
      - checkout:
          requires:
            - cancel_redundant_builds

jobs:
  cancel_redundant_builds:
    docker:
      - image: sponomarev/circleci-cancel-builds
    steps:
      - run:
          name: Cancelling redundant builds
          command: run
``` 

## Limitations

Honestly, this solution is not ideal – it requires your workflow to start and the job to be invoked. It can take some time before you get a released container, but still, it's better than nothing. It's a pity that CircleCI API doesn't provide any way to control workflows directly.

## Acknowledgments

A big thanks to [Luberj](https://discuss.circleci.com/u/lumberj) from CircleCI forum who provided an idea to cancel builds with API methods.

## License

The code is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).