#!/bin/bash

set -euo pipefail

# Setup package versions
POETRY_VERSION=$(cat .poetry-version)
TERRAFORM_VERSION=$(cat .terraform-version)
TERRAGRUNT_VERSION=$(cat .terragrunt-version)

# Tell apt-get we're never going to be able to give manual feedback:
export DEBIAN_FRONTEND=noninteractive

# Set non-user location for specific version of Poetry install:
export POETRY_HOME=/etc/poetry
export POETRY_VERSION=${POETRY_VERSION}

# Update the package listing, so we know what package exist:
apt-get update

# Install security updates:
apt-get -y upgrade

# Install a new package, without unnecessary recommended packages:
apt-get -y install --no-install-recommends unzip curl make bash

# Download Terraform, Terragrunt and Poetry packages:
curl -sSL -o terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
curl -sSL -o /usr/bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
curl -sSL -o /usr/bin/get-poetry.py "https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py"

# Setup Terraform, Terragrunt and Poetry executables:
python /usr/bin/get-poetry.py
unzip -o terraform.zip -d /usr/bin
chmod +x /usr/bin/terragrunt

# Delete cached files we don't need anymore:
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -f terraform.zip
rm -f /usr/bin/get-poetry.py
