# syntax=docker/dockerfile:1.4
FROM python:3.11-slim

WORKDIR /workspace-drw

RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install
RUN pip install uv


RUN git config --global user.name "LevRoz630" && \
    git config --global user.email "l.rozanov@outlook.com"

# Use BuildKit secret for token
RUN --mount=type=secret,id=GITHUB_TOKEN \
    GITHUB_TOKEN=$(cat /run/secrets/GITHUB_TOKEN) && \
    GIT_LFS_SKIP_SMUDGE=1 git clone https://$GITHUB_TOKEN@github.com/LevRoz630/drw-data.git /workspace-drw/drw-data && \
    git clone https://$GITHUB_TOKEN@github.com/LevRoz630/drwcomp2025.git /workspace-drw/drwcomp2025



RUN cd /workspace-drw/drw-data && git lfs pull --include="*.parquet,*.csv"

WORKDIR /workspace-drw/drwcomp2025

RUN uv venv && uv pip install -r requirements.txt

CMD ["/usr/local/bin/activate-env", "/bin/bash"]
