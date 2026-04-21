FROM python:3.14.4-slim-bookworm

ARG runner_version

# renovate: datasource=github-releases depName=getsops/sops
ARG SOPS_VERSION="3.9.0"

RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    sshpass \
    curl \
    age \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    ARCH=$(dpkg --print-architecture); \
    SOPS_BIN="sops-v${SOPS_VERSION}.linux.${ARCH}"; \
    curl -fSL "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/${SOPS_BIN}" -o ${SOPS_BIN}; \
    curl -fSL "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.checksums.txt" -o sops.checksums.txt; \
    grep "${SOPS_BIN}" sops.checksums.txt | sha256sum -c -; \
    mv ${SOPS_BIN} /usr/local/bin/sops; \
    chmod +x /usr/local/bin/sops; \
    rm -f sops.checksums.txt

RUN pip install --no-cache-dir \
    ansible \
    ansible-runner==${runner_version}

WORKDIR /runner

ENV PYTHONUNBUFFERED=1

CMD ["ansible-runner"]

