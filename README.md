# Infrastructure as Code (iac) Build Agent

![Codebuild](https://codebuild.eu-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiYzUzekNjZTIzU3dDVzR5bzBDRFpwSFhPRDlVdzBHNGk4SHJzeFFZRjdqQ0JWRFFERzdNQnBJVXUwdG9tS3FHOFdIMzhiOCtRb09lMHA0S0pxVkNLb1BzPSIsIml2UGFyYW1ldGVyU3BlYyI6IlBoT1dMNkJYSExZRTE0TFUiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)

Implements the Docker image to be used in the IaC pipeline

<!-- toc -->

- [Requirements](#requirements)
- [Setup](#setup)

<!-- tocstop -->

## Requirements

For building locally, you will need:
* an active `AWS_PROFILE` for DriverBuddy AWS account
* [Docker](https://docs.docker.com/get-started/) installed and running
* [Python v3](https://www.python.org/downloads/) installed via [pyenv](https://github.com/pyenv/pyenv).
* [Poetry](https://python-poetry.org/docs/) [v1.1.4](https://github.com/python-poetry/poetry/releases/tag/1.1.4) installed outside this project.

## Setup

```shell
make build
```
