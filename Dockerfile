# Use Python 3.11 as base image
FROM python:3.11-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install uv for Python environment management
RUN pip install uv

# Create app directory
WORKDIR /app

# Copy SSH keys for Git access
COPY drw-code-deploy /root/.ssh/id_ed25519
COPY drw-code-deploy.pub /root/.ssh/id_ed25519.pub

# Set proper permissions for SSH keys
RUN chmod 600 /root/.ssh/id_ed25519 \
    && chmod 644 /root/.ssh/id_ed25519.pub

# Configure SSH to use the key
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n\tIdentityFile /root/.ssh/id_ed25519" > /root/.ssh/config \
    && chmod 600 /root/.ssh/config

# Clone the repositories
RUN git clone git@github.com:LevRoz630/drw-data.git /app/drw-data
RUN git clone git@github.com:LevRoz630/drwcomp2025.git /app/drwcomp2025

# Set up Python environment with uv
WORKDIR /app/drwcomp2025

# Create virtual environment and install requirements if they exist
RUN if [ -f "requirements.txt" ]; then \
        uv venv && \
        uv pip install -r requirements.txt; \
    elif [ -f "pyproject.toml" ]; then \
        uv venv && \
        uv pip install -e .; \
    else \
        uv venv; \
    fi

# Set up Git configuration for the drwcomp2025 repository
WORKDIR /app/drwcomp2025
RUN git config user.name "Docker Developer" \
    && git config user.email "developer@docker.local"

# Create a script to activate the environment
RUN echo '#!/bin/bash\n\
source /app/drwcomp2025/.venv/bin/activate\n\
cd /app/drwcomp2025\n\
exec "$@"' > /usr/local/bin/activate-env \
    && chmod +x /usr/local/bin/activate-env

# Set the default working directory to the drwcomp2025 repository
WORKDIR /app/drwcomp2025

# Expose port 8000 for potential web applications
EXPOSE 8000

# Default command to activate environment and start bash
CMD ["/usr/local/bin/activate-env", "/bin/bash"] 