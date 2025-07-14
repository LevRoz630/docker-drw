# syntax=docker/dockerfile:1.4
FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install
RUN pip install uv

WORKDIR /workspace-drw

# Use BuildKit secret for token
RUN --mount=type=secret,id=GITHUB_TOKEN \
    GITHUB_TOKEN=$(cat /run/secrets/GITHUB_TOKEN) && \
    git clone https://$GITHUB_TOKEN@github.com/LevRoz630/drw-data.git /workspace-drw/drw-data && \
    git clone https://$GITHUB_TOKEN@github.com/LevRoz630/drwcomp2025.git /workspace-drw/drwcomp2025

WORKDIR /workspace-drw/drwcomp2025

RUN if [ -f "requirements.txt" ]; then \
        uv venv && \
        uv pip install -r requirements.txt; \
    elif [ -f "pyproject.toml" ]; then \
        uv venv && \
        uv pip install -e .; \
    else \
        uv venv; \
    fi

RUN echo '#!/bin/bash\n\
if [ ! -d "/workspace-drw/drwcomp2025/.venv" ]; then\n\
  cd /workspace-drw/drwcomp2025\n\
  uv venv\n\
  if [ -f "requirements.txt" ]; then\n\
    uv pip install -r requirements.txt\n\
  elif [ -f "pyproject.toml" ]; then\n\
    uv pip install -e .\n\
  fi\n\
fi\n\
source /workspace-drw/drwcomp2025/.venv/bin/activate\n\
cd /workspace-drw/drwcomp2025\n\
exec "$@"' > /usr/local/bin/activate-env && \
    chmod +x /usr/local/bin/activate-env

EXPOSE 8000

CMD ["/usr/local/bin/activate-env", "/bin/bash"]
