# Backup current Dockerfile
cp Dockerfile Dockerfile.backup

# Create fixed Dockerfile
cat > Dockerfile << 'EOF'
# Ubuntu 20.04 with ROS 2 Foxy for Manifold 3
FROM ubuntu:20.04

LABEL maintainer="leticiarp2000"
LABEL version="1.0.0"
LABEL description="Ubuntu 20.04 with ROS 2 Foxy for DJI Manifold 3"

# Environment
ENV DEBIAN_FRONTEND=noninteractive \
    ROS_DISTRO=foxy

# Install ROS 2 Foxy
RUN apt-get update && apt-get install -y \
    curl gnupg2 lsb-release \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
        -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
        http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
        | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
    && apt-get update && apt-get install -y \
        ros-foxy-desktop \
        python3-colcon-common-extensions \
        python3-rosdep \
    && rosdep init \
    && rosdep update \
    && rm -rf /var/lib/apt/lists/*

# Install tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    vim \
    nano \
    wget \
    curl \
    libeigen3-dev \
    libx11-dev \
    libxaw7-dev \
    && ln -sf /usr/include/eigen3/Eigen /usr/include/Eigen \
    && rm -rf /var/lib/apt/lists/*

# Install Zsh
RUN apt-get update && apt-get install -y \
    zsh \
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && rm -rf /var/lib/apt/lists/*

# Configure
RUN echo 'source /opt/ros/foxy/setup.zsh' >> ~/.zshrc \
    && echo 'alias ll="ls -la"' >> ~/.zshrc \
    && echo 'alias ros2b="colcon build --symlink-install"' >> ~/.zshrc

RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws

SHELL ["zsh", "-c"]
CMD ["zsh"]
EOF
