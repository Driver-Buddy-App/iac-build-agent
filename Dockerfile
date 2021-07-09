ARG PYTHON_VERSION=3.9.5
FROM python:${PYTHON_VERSION}-alpine

ENV PYTHONFAULTHANDLER=1
ARG POETRY_VERSION
ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN apk --update add --no-cache --virtual .build-deps unzip curl && \
    curl -sSL -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    curl -sSL -o /usr/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    curl -sSL -o /usr/bin/get-poetry.py https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py && \
    unzip -o terraform.zip -d /usr/bin && rm terraform.zip && \
    chmod +x /usr/bin/terragrunt && \
    python /usr/bin/get-poetry.py --version ${POETRY_VERSION} && \
    apk add make bash && \
    apk del .build-deps && \
    pip install --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN adduser -S codebuild-user
USER codebuild-user

RUN mkdir -p $HOME/.terraform.d/plugin-cache && \
    echo "plugin_cache_dir = \"$HOME/.terraform.d/plugin-cache\"" >> ~/.terraformrc
