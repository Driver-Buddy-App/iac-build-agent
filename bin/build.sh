#!/bin/bash
set -euo pipefail

export DOCKER_BUILDKIT=1

ECR_REPO=100262399921.dkr.ecr.eu-west-2.amazonaws.com
POETRY_VERSION=$(cat .poetry-version)
PYTHON_VERSION=$(cat .python-version)
TERRAFORM_VERSION=$(cat .terraform-version)
TERRAGRUNT_VERSION=$(cat .terragrunt-version)
IMAGE_NAME=$ECR_REPO/iac-build-agent
IMAGE_TAG="${PYTHON_VERSION}_${POETRY_VERSION}_${TERRAFORM_VERSION}_${TERRAGRUNT_VERSION}"

poetry update
poetry export -o requirements.txt

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $ECR_REPO

# Use branch+commit for tagging:
docker build --tag "$IMAGE_NAME:$IMAGE_TAG" \
             --build-arg PYTHON_VERSION="$PYTHON_VERSION" \
             --build-arg BUILDKIT_INLINE_CACHE=1 .

# Security scanners:
docker run --entrypoint=sh "$IMAGE_NAME:$IMAGE_TAG" -c "safety check"
trivy image --exit-code 0 --ignorefile "$(pwd)/.trivyignore" --ignore-unfixed --severity MEDIUM,HIGH "$IMAGE_NAME:$IMAGE_TAG"
trivy image --exit-code 1 --ignorefile "$(pwd)/.trivyignore" --ignore-unfixed --severity CRITICAL "$IMAGE_NAME:$IMAGE_TAG"

# Push to the registry:
docker push "$IMAGE_NAME:$IMAGE_TAG"
