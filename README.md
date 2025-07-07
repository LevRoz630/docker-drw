# DRW Development Environment

This Docker setup provides a complete development environment for the DRW project. **You must clone the repositories on your host before starting the container.**

## Repositories

- **drw-data**: `git@github.com:LevRoz630/drw-data.git` (read-only access)
- **drwcomp2025**: `git@github.com:LevRoz630/drwcomp2025.git` (read-write access with SSH key)

## Prerequisites

- Docker
- Docker Compose
- SSH key `drw-code-deploy` (already present in the repository)
- Both repositories cloned on your host:

```bash
# Clone the repositories on your host (outside Docker)
git clone git@github.com:LevRoz630/drw-data.git
git clone git@github.com:LevRoz630/drwcomp2025.git
```

## Quick Start

### 1. Build and Start the Development Environment

```bash
# Build the Docker image
docker-compose build

# Start the development container
docker-compose up -d

# Enter the container
docker-compose exec drw-dev bash
```

### 2. Mounting Your Local Repositories

Edit your `docker-compose.yml` to mount your local repositories for live development. Uncomment or add the following lines under `volumes:`:

```yaml
    volumes:
      - ./drw-code-deploy:/root/.ssh/id_ed25519:ro
      - ./drw-code-deploy.pub:/root/.ssh/id_ed25519.pub:ro
      - ./drw-data:/app/drw-data
      - ./drwcomp2025:/app/drwcomp2025
```

This ensures that any changes you make on your host are immediately available in the container, and vice versa. The `.git` directory is also shared, so you have full git integration in your IDE.

### 3. Run Specific Commands

```bash
# Run a specific command in the environment
docker-compose --profile run run --rm drw-run python your_script.py
```

## What's Included

### Environment Setup
- **Python 3.11** with uv for dependency management
- **Git** with SSH access configured
- **Virtual environment** automatically created and activated
- **Your repositories** mounted for live development

### Repository Structure
```
/app/
├── drw-data/          # Read-only data repository
└── drwcomp2025/       # Main development repository (write access)
    ├── .venv/         # Virtual environment
    └── ...            # Your project files
```

### SSH Configuration
- SSH key `drw-code-deploy` is configured for GitHub access
- Automatic key setup for both repositories
- Write access enabled for `drwcomp2025`

## Development Workflow

### 1. Starting Development
```bash
# Enter the container
docker-compose exec drw-dev bash

# You'll be in the drwcomp2025 directory with venv activated
cd /app/drwcomp2025
```

### 2. Working with Python
```bash
# The virtual environment is already activated
python --version
pip list

# Install additional packages
uv pip install package-name

# Run your application
python your_app.py
```

### 3. Git Operations
```bash
# Check status
git status

# Make changes and commit
git add .
git commit -m "Your commit message"

# Push changes (write access enabled)
git push origin main
```

### 4. Working with Data Repository
```bash
# Access the data repository
cd /app/drw-data

# Read data files
ls -la
```

## Port Mapping

- **Port 8000**: Web applications
- **Port 8888**: Jupyter notebooks

## Useful Commands

### Container Management
```bash
# Start the environment
docker-compose up -d

# Stop the environment
docker-compose down

# Rebuild after changes
docker-compose build --no-cache

# View logs
docker-compose logs drw-dev
```

### Development Commands
```bash
# Run tests
docker-compose exec drw-dev python -m pytest

# Install new requirements
docker-compose exec drw-dev uv pip install -r requirements.txt

# Update repositories (from your host, or inside the container)
git pull
```

## Troubleshooting

### SSH Key Issues
If you encounter SSH authentication issues:
```bash
# Check SSH key permissions
docker-compose exec drw-dev ls -la /root/.ssh/

# Test SSH connection
docker-compose exec drw-dev ssh -T git@github.com
```

### Repository Access Issues
If you have issues with the repositories, ensure they are cloned on your host and mounted correctly. You should not need to clone them inside the container.

### Virtual Environment Issues
```bash
# Recreate virtual environment
docker-compose exec drw-dev bash -c "cd /app/drwcomp2025 && rm -rf .venv && uv venv"
```

## File Structure

```
.
├── Dockerfile              # Main Docker configuration
├── docker-compose.yml      # Docker Compose configuration
├── .dockerignore           # Files to exclude from build
├── README.md               # This file
├── drw-code-deploy         # SSH private key
└── drw-code-deploy.pub     # SSH public key
```

## Security Notes

- SSH keys are mounted as read-only volumes
- The container runs with the SSH key for GitHub access
- Write access is enabled for the `drwcomp2025` repository
- The `drw-data` repository is read-only

## Customization

### Adding More Ports
Edit `docker-compose.yml` to add more port mappings:
```yaml
ports:
  - "8000:8000"
  - "8888:8888"
  - "5000:5000"  # Add your custom port
```

### Mounting Additional Volumes
Add more volume mounts in `docker-compose.yml` for additional repositories or data.

### Environment Variables
Add environment variables in `docker-compose.yml`:
```yaml
environment:
  - PYTHONPATH=/app/drwcomp2025
  - DEBUG=1
  - API_KEY=your_key
``` 