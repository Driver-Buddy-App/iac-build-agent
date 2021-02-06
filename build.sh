#!/bin/bash
set -euo pipefail

export DOCKER_BUILDKIT=1

ECR_REPO=947967857684.dkr.ecr.eu-west-2.amazonaws.com
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(git rev-parse --short HEAD)
IMAGE_NAME=$ECR_REPO/iac-build-agent
PYTHON_VERSION=$(cat .python-version)
TERRAFORM_VERSION=$(cat .terraform-version)
TERRAGRUNT_VERSION=$(cat .terragrunt-version)

poetry export -o requirements.txt

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $ECR_REPO

# Pull previous version, and use with --cache-now for build caching:
docker pull "$IMAGE_NAME:$GIT_BRANCH" || true

# Use branch+commit for tagging:
docker build --tag "$IMAGE_NAME:$GIT_COMMIT" \
             --build-arg PYTHON_VERSION="$PYTHON_VERSION" \
             --build-arg TERRAFORM_VERSION="$TERRAFORM_VERSION" \
             --build-arg TERRAGRUNT_VERSION="$TERRAGRUNT_VERSION" \
             --build-arg BUILDKIT_INLINE_CACHE=1 \
             --label git_branch="$GIT_BRANCH" \
             --label python_version="$PYTHON_VERSION" \
             --label terraform_version="$TERRAFORM_VERSION" \
             --label terragrunt_version="$TERRAGRUNT_VERSION" \
             --cache-from="$IMAGE_NAME:$GIT_COMMIT" .

# Security scanners:
docker run --entrypoint=sh "$IMAGE_NAME:$GIT_BRANCH" -c "pip install --user safety && ~/.local/bin/safety check"
trivy --ignore-unfixed --exit-code 1 "$IMAGE_NAME:$GIT_BRANCH"

# Push to the registry:
docker push "$IMAGE_NAME:$GIT_BRANCH"
docker push "$IMAGE_NAME:$GIT_COMMIT"