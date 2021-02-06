ARG PYTHON_VERSION=3.8.7
FROM python:${PYTHON_VERSION}-alpine

ENV PYTHONFAULTHANDLER=1
ENV POETRY_HOME=/tmp/poetry
ENV PATH=$POETRY_HOME/bin:$PATH

ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION

RUN apk --update add --no-cache --virtual .build-deps unzip curl && \
    curl -sSL -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    curl -sSL -o /usr/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python - --no-modify-path && \
    unzip -o terraform.zip -d /usr/bin && rm terraform.zip && \
    chmod +x /usr/bin/terragrunt && \
    apk add make bash && \
    apk del .build-deps

RUN adduser -S codebuild-user
USER codebuild-user

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

