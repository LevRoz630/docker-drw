# syntax=docker/dockerfile:1.4
FROM python:3.11-slim

WORKDIR /workspace-drw

RUN pip install uv

RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install --skip-smudge


RUN git config --global user.name "LevRoz630" && \
    git config --global user.email "l.rozanov@outlook.com"

# Use BuildKit secret for token
RUN --mount=type=secret,id=GITHUB_TOKEN \
    GITHUB_TOKEN=$(cat /run/secrets/GITHUB_TOKEN) && \
    git clone https://x-access-token:${GITHUB_TOKEN}@github.com/LevRoz630/drw-data.git /workspace-drw/drw-data && \
    git clone --branch develop https://x-access-token:${GITHUB_TOKEN}@github.com/LevRoz630/drwcomp2025.git /workspace-drw/drwcomp2025

RUN --mount=type=secret,id=GITHUB_TOKEN \
    GITHUB_TOKEN=$(cat /run/secrets/GITHUB_TOKEN) && \
    cd /workspace-drw/drw-data && \
    git lfs pull --include="*.parquet,*.csv" && \
    cd /workspace-drw/drwcomp2025 && \
    uv venv && uv pip install -r requirements.txt



RUN git lfs install --force

CMD ["/bin/bash"]
