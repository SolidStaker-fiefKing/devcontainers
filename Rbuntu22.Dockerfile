# Use Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

# Install dependencies and Rust toolchain
RUN apt-get update && \
    apt-get install -y curl build-essential libssl-dev pkg-config software-properties-common && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    rm -rf /var/lib/apt/lists/*

# Add Git PPA (if needed) and install git
RUN add-apt-repository ppa:git-core/ppa -y && \
    apt-get update && \
    apt-get install -y git

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Set a default working directory (can be overridden by individual projects)
WORKDIR /usr/src/

# Default to bash for development ease
CMD ["/bin/bash"]
