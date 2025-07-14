**Author: Lev Rozanov**

# DRW Docker Environment

This Docker image sets up a shared dev environment for the DRW 2025 project, cloning repos via HTTPS with a GitHub token.

## What is this?

- Automatically clones `drw-data` and `drwcomp2025` during build using a GitHub token  
- Python 3.11 with required dependencies pre-installed  
- Consistent environment for all contributors  
- Git LFS support for large data files  

## What's inside

- Python 3.11 and core libraries  
- Git, Git LFS configured  
- Pre-installed: pandas, numpy, scikit-learn, pyarrow, psutil, jupyter  
- Tools: vim, nano, curl, wget, tree, htop  
- Both repos cloned into `/workspace-drw/`  

## Quick Start

**Build the image (with buildkit and token):**  
```bash
DOCKER_BUILDKIT=1 docker build --secret id=GITHUB_TOKEN,src=./token.txt -t drw-docker-env .

docker run -it --rm drw-docker-env