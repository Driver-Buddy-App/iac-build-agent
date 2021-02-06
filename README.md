# Infrastructure as Code (iac) Build Agent

![Codebuild](https://codebuild.eu-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiYzUzekNjZTIzU3dDVzR5bzBDRFpwSFhPRDlVdzBHNGk4SHJzeFFZRjdqQ0JWRFFERzdNQnBJVXUwdG9tS3FHOFdIMzhiOCtRb09lMHA0S0pxVkNLb1BzPSIsIml2UGFyYW1ldGVyU3BlYyI6IlBoT1dMNkJYSExZRTE0TFUiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)

Implements the Docker image to be used in the IaC pipeline

<!-- toc -->

- [Requirements](#requirements)
- [Setup](#setup)

<!-- tocstop -->

## Requirements

* [Terragrunt](https://github.com/gruntwork-io/terragrunt#install-terragrunt) is used to manage environments and
  prevent repetitive code.
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started) is used to
  manage the AWS resources.
* [Python v3](https://www.python.org/downloads/) will co-ordinate the deployment of resources via Terragrunt.
* [Poetry](https://python-poetry.org/docs/) will be used to manage the Python build environment.

## Setup

```shell
make build
```
