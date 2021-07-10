ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim-buster as compile-image

ENV PYTHONFAULTHANDLER=1

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY .poetry-version .terraform-version .terragrunt-version bin/install.sh ./
RUN ./install.sh

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

FROM python:${PYTHON_VERSION}-slim-buster AS build-image
COPY --from=compile-image /opt/venv /opt/venv
COPY --from=compile-image /usr/bin/terraform /usr/bin/terraform
COPY --from=compile-image /usr/bin/terragrunt /usr/bin/terragrunt
COPY --from=compile-image /etc/poetry /etc/poetry

ENV PATH="/etc/poetry/bin:/opt/venv/bin:$PATH"

RUN adduser --system codebuild-user
USER codebuild-user

RUN mkdir -p $HOME/.terraform.d/plugin-cache && \
    echo "plugin_cache_dir = \"$HOME/.terraform.d/plugin-cache\"" >> ~/.terraformrc
