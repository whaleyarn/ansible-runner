FROM python:3.13.7-slim-bookworm

ARG runner_version

RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    sshpass \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    ansible \
    ansible-runner==${runner_version}

WORKDIR /runner

ENV PYTHONUNBUFFERED=1

CMD ["ansible-runner"]

