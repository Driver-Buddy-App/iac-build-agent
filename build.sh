#!/bin/bash
set -euo pipefail

export DOCKER_BUILDKIT=1

# GIT_COMMIT=$(git rev-parse --short HEAD)
ECR_REPO=947967857684.dkr.ecr.eu-west-2.amazonaws.com
PYTHON_VERSION=$(cat .python-version)
TERRAFORM_VERSION=$(cat .terraform-version)
TERRAGRUNT_VERSION=$(cat .terragrunt-version)
IMAGE_NAME=$ECR_REPO/iac-build-agent
IMAGE_TAG="${PYTHON_VERSION}_${TERRAFORM_VERSION}_${TERRAGRUNT_VERSION}"

poetry update
poetry export -o requirements.txt

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $ECR_REPO

# Use branch+commit for tagging:
docker build --tag "$IMAGE_NAME:$IMAGE_TAG" \
             --build-arg PYTHON_VERSION="$PYTHON_VERSION" \
             --build-arg TERRAFORM_VERSION="$TERRAFORM_VERSION" \
             --build-arg TERRAGRUNT_VERSION="$TERRAGRUNT_VERSION" \
             --build-arg BUILDKIT_INLINE_CACHE=1 \
             --label python_version="$PYTHON_VERSION" \
             --label terraform_version="$TERRAFORM_VERSION" \
             --label terragrunt_version="$TERRAGRUNT_VERSION" .

# Security scanners:
docker run --entrypoint=sh "$IMAGE_NAME:$IMAGE_TAG" -c "safety check"
trivy --ignore-unfixed --exit-code 1 "$IMAGE_NAME:$IMAGE_TAG"

# Push to the registry:
docker push "$IMAGE_NAME:$IMAGE_TAG"
