# Ubuntu 20.04 with ROS 2 Foxy for Manifold 3
FROM ubuntu:20.04

LABEL maintainer="leticiarp2000"
LABEL version="1.0.0"
LABEL description="Ubuntu 20.04 with ROS 2 Foxy for DJI Manifold 3"
LABEL org.opencontainers.image.source="https://github.com/leticiarp2000/ubuntu20_dji_manifold3"

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ROS_DISTRO=foxy \
    ROS_PYTHON_VERSION=3

# Install ROS 2 Foxy from APT repository
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
        -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
        http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
        | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
    && apt-get update && apt-get install -y --no-install-recommends \
        ros-foxy-desktop \
        python3-argcomplete \
        python3-colcon-common-extensions \
        python3-rosdep \
        python3-pip \
    && rosdep init \
    && rosdep update \
    && rm -rf /var/lib/apt/lists/*

# Install development tools and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    vim \
    nano \
    htop \
    tmux \
    net-tools \
    iputils-ping \
    # Build dependencies for ROS packages
    libeigen3-dev \
    libboost-all-dev \
    libssl-dev \
    libasio-dev \
    libtinyxml2-dev \
    libcunit1-dev \
    # GUI dependencies
    libx11-dev \
    libxaw7-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    # Python
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure environment
RUN echo '# ROS 2 Setup' >> ~/.zshrc \
    && echo 'source /opt/ros/${ROS_DISTRO}/setup.zsh' >> ~/.zshrc \
    && echo 'export ROS_DOMAIN_ID=0' >> ~/.zshrc \
    && echo '' >> ~/.zshrc \
    && echo '# Zsh Configuration' >> ~/.zshrc \
    && echo 'export ZSH_THEME="robbyrussell"' >> ~/.zshrc \
    && echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker)' >> ~/.zshrc \
    && echo '' >> ~/.zshrc \
    && echo '# Aliases' >> ~/.zshrc \
    && echo 'alias ll="ls -la"' >> ~/.zshrc \
    && echo 'alias ..="cd .."' >> ~/.zshrc \
    && echo 'alias ...="cd ../.."' >> ~/.zshrc \
    && echo 'alias ros2b="colcon build --symlink-install"' >> ~/.zshrc \
    && echo 'alias ros2br="colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release"' >> ~/.zshrc \
    && echo 'alias ros2bd="colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Debug"' >> ~/.zshrc \
    && echo 'alias ros2s="source /opt/ros/foxy/setup.zsh"' >> ~/.zshrc \
    && chsh -s $(which zsh)

# Create workspace
RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ros2 --help > /dev/null 2>&1 || exit 1
