# Ubuntu 20.04 with ROS 2 Foxy Docker Image

![Docker Image CI](https://github.com/lactec-cfg-drones/ubuntu20.04-ubuntu20-docker-image/actions/workflows/docker-publish.yml/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/leticiarp2000/ubuntu20_dji_manifold3?label=Docker%20Hub%20pulls&logo=docker)
![GitHub Container Registry](https://img.shields.io/badge/GHCR-available-blue?logo=github)
![License](https://img.shields.io/badge/license-MIT-green)
![ROS 2](https://img.shields.io/badge/ROS%202-Foxy-blueviolet)

A production-ready Docker image with Ubuntu 20.04, ROS 2 Foxy, and Zsh shell for ROS 2 development and Manifold 3 applications. Features automated CI/CD, version management, and development utilities.


## Prerequisites Installation

#### Install Docker on Ubuntu 20.04/22.04
 Update system
```bash
sudo apt update
sudo apt upgrade -y
```

Install Docker dependencies
```bash
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

Add Docker's official GPG key
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Set up stable repository
``` bash
echo "deb [arch=$(dpkg --print-architecture) \
signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install Docker Engine
``` bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

Add user to docker group (to run without sudo)
``` bash
sudo usermod -aG docker $USER
newgrp docker  # Or log out and back in
```

Verify installation
```bash
docker --version
sudo systemctl status docker
```
Check out the docker documentation: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository


## Git and GPG Setup
Install Git
```bash
sudo apt install -y git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Generate GPG Key for Signed Commits
```bash
# Install GPG
sudo apt install -y gnupg

# Generate new GPG key
gpg --full-generate-key

# Follow prompts:
# 1. Key type: RSA and RSA (press 1)
# 2. Key size: 4096
# 3. Expiration: 2y (2 years recommended)
# 4. Real name: Your Name
# 5. Email: your.email@example.com
# 6. Comment: (optional)
# 7. Passphrase: (optional for CI/CD, recommended for security)

# List your keys
gpg --list-secret-keys --keyid-format=long

# Export public key (copy from -----BEGIN to -----END)
gpg --armor --export YOUR_KEY_ID
```

### Add GPG Key to GitHub
1. Go to GitHub → Settings → SSH and GPG keys → New GPG key
2. Paste your exported public key
3. Click "Add GPG key"

### Configure Git to Use GPG
Clone the Repository
```bash
# Clone using HTTPS (easier)
git clone https://github.com/lactec-cfg-drones/ubuntu20.04-ubuntu20-docker-image.git
cd ubuntu20.04-ubuntu20-docker-image

# Or clone using SSH (if you have SSH keys setup)
# git clone git@github.com:lactec-cfg-drones/ubuntu20.04-ubuntu20-docker-image.git
```

Verify Repository Structure
```bash 
# Check the files
ls -la

# Expected structure:
# Dockerfile          # Main Docker image definition
# .github/           # CI/CD workflows
# README.md          # This documentation
# sync-docker-to-git.sh # Development utility
# .dockerignore      # Docker ignore rules
```

##  First-Time Docker Setup
### Login to Docker Hub (Optional)
```bash 
# Create Docker Hub account at https://hub.docker.com
# Generate access token: Account Settings → Security → Access Tokens

# Login with token
docker login -u YOUR_DOCKERHUB_USERNAME
# When prompted for password, use your access token (not your account password)
```

### Test Docker Installation
```bash 
# Test with hello-world
docker run hello-world

# Test with our image
docker pull leticiarp2000/ubuntu20_dji_manifold3:latest
docker run --rm leticiarp2000/ubuntu20_dji_manifold3:latest echo "Docker is working!"
```

## Using the Image for Development

Basic Usage
```bash
# Pull the latest image
docker pull leticiarp2000/ubuntu20_dji_manifold3:latest

# Start interactive session
docker run -it --rm leticiarp2000/ubuntu20_dji_manifold3:latest

# Inside container, you'll see Zsh prompt
# Test ROS 2: ros2 --help
# Test Python: python3 --version
# Exit: type 'exit' or press Ctrl+D
```

### Pull the Image
```bash
# From Docker Hub (recommended)
docker pull leticiarp2000/ubuntu20_dji_manifold3:latest

# From GitHub Container Registry
docker pull ghcr.io/lactec-cfg-drones/ubuntu20.04-ubuntu20-docker-image:latest
```

### Run the Container
```bash
# Interactive shell (Zsh with Oh My Zsh)
docker run -it --rm leticiarp2000/ubuntu20_dji_manifold3:latest

# With mounted workspace
docker run -it --rm \
  -v $(pwd):/ros2_ws/src \
  leticiarp2000/ubuntu20_dji_manifold3:latest

# Run a single command
docker run --rm leticiarp2000/ubuntu20_dji_manifold3:latest ros2 --help
```

## 🚀 Features
### Core Components
- Ubuntu 20.04 LTS - Stable base system
- ROS 2 Foxy Fitzroy - Full desktop installation
- Zsh 5.8 with Oh My Zsh - Enhanced shell with plugins:
    - zsh-autosuggestions
    - zsh-syntax-highlighting
    - Pre-configured aliases and themes

### Development Tools
```yaml
Build Tools:
  - CMake 3.16+
  - GCC/G++ 9.3+
  - Make, Autotools
  
Editors:
  - Vim 8.1+
  - Nano 4.8+
  
Utilities:
  - Git 2.25+
  - Curl, Wget
  - Htop, Tmux
  - Net-tools, iputils-ping
  
Python:
  - Python 3.8
  - pip3, venv
  - ROS 2 Python packages
```

### ROS 2 Dependencies
```yaml
Libraries:
  - Eigen3 (with symlink fix)
  - Boost 1.71+
  - OpenSSL 1.1.1
  - ASIO 1.12+
  - TinyXML2
  
GUI Support:
  - X11 development libraries
  - OpenGL/Mesa
  - Xcursor, Xrandr, Xinerama
  
Math & Linear Algebra:
  - BLAS, LAPACK
  - OpenCV compatible
```

## 🔧 Available Tags

Tag |	Description	                           |Size |	Status
----|------------------------------------------|-----|-----------
latest       | Latest stable build	           | ~1.7GB	 | ✅ Active
1.0.1        | Current stable (ROS 2 PATH fix) | ~1.7GB	 | ✅ Stable
1.0.0        | 	Initial release	               | ~1.7GB	 | ⚠️ Deprecated
sha-<commit> |	Git commit builds	           | ~1.7GB	 | ✅ Automated
e7c4fcd...	 |  Specific commit SHA            | ~1.7GB	 | ✅ Automated



### View All Tags
```bash
curl -s "https://hub.docker.com/v2/repositories/leticiarp2000/ubuntu20_dji_manifold3/tags/" | \
  python3 -c "import sys,json; data=json.load(sys.stdin); [print(tag['name']) for tag in data['results']]"
```

## 🛠️ Development Workflow
Build Locally
```bash
# Clone repository
git clone https://github.com/lactec-cfg-drones/ubuntu20.04-ubuntu20-docker-image.git
cd ubuntu20.04-ubuntu20-docker-image

# Build Docker image
docker build -t ubuntu20_dji_manifold3:local .

# Test functionality
docker run --rm ubuntu20_dji_manifold3:local bash -c \
  "source /opt/ros/foxy/setup.bash && ros2 --help"
```

## Standard Development Process
1. Make Changes: Edit `Dockerfile` or related files
2. Test Locally: `docker build -t test-image . && docker run --rm test-image ros2 --help`
3. Commit with GPG: `git commit -S -m "feat: Description of changes"`
4. Push to GitHub: `git push origin main`
5. Automation: GitHub Actions builds and publishes new image

### 🔄 Sync Script Utility
The repository includes `sync-docker-to-git.sh` for syncing container changes back to source control:

### Script Usage
```bash
./sync-docker-to-git.sh <container_id> <new_tag> "<commit_message>"
```
### Example Workflow
```bash
# 1. Start and modify container
docker run -it --name my-test-container leticiarp2000/ubuntu20_dji_manifold3:latest
# Inside container: apt install new-package
# exit

# 2. Sync changes
./sync-docker-to-git.sh my-test-container 1.0.2 "Added new-package"

# Output:
# ✅ Committed to Docker Hub: leticiarp2000/ubuntu20_dji_manifold3:1.0.2
# ✅ Updated Dockerfile to version 1.0.2
# ✅ Committed to Git with GPG signing
# ✅ Pushed to GitHub
# ✅ Triggered automated rebuild of :latest
```

### Script Functions
1. Container Commit: docker commit with metadata
2. Docker Hub Push: Pushes to leticiarp2000/ubuntu20_dji_manifold3:<tag>
3. Version Update: Updates LABEL version in Dockerfile
4. Git Commit: Commits with GPG signing
5. GitHub Push: Triggers CI/CD pipeline

## 🤖 CI/CD Automation
### GitHub Actions Pipeline
File: `.github/workflows/docker-publish.yml`

Triggers:
 - Push to main branch
 - New releases
 - Manual workflow dispatch

Steps:
```yaml
1. Checkout Repository
2. Set up Docker Buildx
3. Login to Docker Hub
4. Login to GitHub Container Registry
5. Extract Metadata (tags, labels)
6. Build and Push (multi-platform support)
7. Generate SBOM (Software Bill of Materials)
8. Upload Artifacts
```

### Output Registries:
- Docker Hub: `leticiarp2000/ubuntu20_dji_manifold3`
- GitHub Container Registry: `ghcr.io/lactec-cfg-drones/ubuntu20.04-ubuntu20-docker-image`

### Monitoring
- Actions Dashboard: https://github.com/lactec-cfg-drones/ubuntu20.04-ubuntu20-docker-image/actions

- Docker Hub: https://hub.docker.com/r/leticiarp2000/ubuntu20_dji_manifold3

- GHCR: https://ghcr.io/lactec-cfg-drones/ubuntu20.04-ubuntu20-docker-image

### 📁 Project Structure

```text
ubuntu20.04-ubuntu20-docker-image/
├── Dockerfile              # Image definition (main configuration)
├── .github/
│   └── workflows/
│       └── docker-publish.yml  # CI/CD pipeline
├── .dockerignore          # Docker build exclusions
├── .gitignore            # Git exclusions
├── README.md             # This documentation
├── sync-docker-to-git.sh # Development utility
└── LICENSE               # MIT License
```

### Dockerfile Sections
``` dockerfile
# 1. Base Image & Metadata
FROM ubuntu:20.04
LABEL maintainer, version, description

# 2. Environment Setup
ENV DEBIAN_FRONTEND, ROS_DISTRO, etc.

# 3. ROS 2 Installation
RUN apt update, add repository, install ros-foxy-desktop

# 4. Development Tools
RUN install build-essential, cmake, git, vim, etc.

# 5. Dependency Fixes
RUN ln -sf /usr/include/eigen3/Eigen /usr/include/Eigen

# 6. Zsh Configuration
RUN install zsh, Oh My Zsh, plugins

# 7. Environment Configuration
RUN echo source commands to .zshrc, .bashrc

# 8. Workspace Setup
RUN mkdir /ros2_ws, WORKDIR, CMD
```

## 🐳 Docker Commands Cheatsheet
### Basic Operations
```bash
# List images
docker images | grep -E "(ubuntu20|manifold3)"

# List containers
docker ps -a
docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}"

# Cleanup
docker system prune -a  # Remove unused
docker container prune  # Remove stopped containers
docker image prune      # Remove dangling images
```

### Advanced Usage
```bash
# With GUI Support (RViz, rqt)
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  leticiarp2000/ubuntu20_dji_manifold3:latest

# With Host Networking
docker run -it --rm \
  --network=host \
  --privileged \
  leticiarp2000/ubuntu20_dji_manifold3:latest

# Inspect Image Details
docker inspect leticiarp2000/ubuntu20_dji_manifold3:latest
docker history leticiarp2000/ubuntu20_dji_manifold3:latest --no-trunc

# Export/Import
docker save leticiarp2000/ubuntu20_dji_manifold3:latest > image.tar
docker load < image.tar
```

### Development & Debugging
```bash
# Run with specific command
docker run --rm leticiarp2000/ubuntu20_dji_manifold3:latest bash -c \
  "source /opt/ros/foxy/setup.bash && ros2 topic list"

# Check installed packages
docker run --rm leticiarp2000/ubuntu20_dji_manifold3:latest dpkg -l | grep ros

# Check environment
docker run --rm leticiarp2000/ubuntu20_dji_manifold3:latest env | grep ROS
```


## 🐛 Troubleshooting

### Common Issues & Solutions
ROS 2 Command Not Found
```bash
# Source ROS 2 in container
source /opt/ros/foxy/setup.zsh  # For Zsh
source /opt/ros/foxy/setup.bash # For Bash

# In Docker commands
docker run --rm leticiarp2000/ubuntu20_dji_manifold3:latest \
  bash -c "source /opt/ros/foxy/setup.bash && ros2 --help"
```

### Permission Issues
``` bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Fix Docker socket permissions
sudo chmod 666 /var/run/docker.sock
```

### Authentication Errors
``` bash
# Docker Hub login
docker login -u leticiarp2000
# Use Docker Hub token (not password)

# GHCR login
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

### GPG Signing Issues
``` bash
# Fix GPG TTY
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye

# Disable temporarily
git config --global commit.gpgsign false
```

### Debugging Commands
``` bash
# Check container logs
docker logs <container_id>

# Inspect running container
docker exec -it <container_id> /bin/bash

# Check image layers
docker history --no-trunc leticiarp2000/ubuntu20_dji_manifold3:latest

# Test network connectivity
docker run --rm alpine ping -c 4 google.com
