#!/bin/bash

# Build script for DRW dev environment

set -e

echo "Building DRW dev environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Start Docker and try again."
    exit 1
fi

# Check for SSH keys
if [ ! -f "drw-code-deploy" ] || [ ! -f "drw-code-deploy.pub" ]; then
    echo "Missing SSH keys: drw-code-deploy and/or drw-code-deploy.pub."
    exit 1
fi

# Set permissions on SSH keys
echo "Setting permissions on SSH keys..."
chmod 600 drw-code-deploy
chmod 644 drw-code-deploy.pub

# Build the Docker image
echo "Running docker-compose build..."
docker-compose build

echo "Build complete."
echo
echo "Next steps:"
echo "1. Start: docker-compose up -d"
echo "2. Shell: docker-compose exec drw-dev bash"
echo "3. Or:    docker-compose run --rm drw-dev bash"
echo
echo "See README.md for more info."