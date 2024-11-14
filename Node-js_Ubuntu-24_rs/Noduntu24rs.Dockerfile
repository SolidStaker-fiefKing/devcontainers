# Node.js on Ubuntu 24.04 LTS + Rust & PowerShell
FROM ubuntu:24.04

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools and dependencies, including git and gh
RUN apt-get update && \
    apt-get install -y \
        curl \
        build-essential \
        python3-minimal \
        software-properties-common \
        wget \
        apt-transport-https \
        git \
        ca-certificates \
        gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh) using GPG method
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js and npm installation
RUN node -v && npm -v

# Install Rust using rustup
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Add Rust to the PATH environment variable
ENV PATH="/root/.cargo/bin:${PATH}"

# Set Git global config with placeholder values
RUN git config --global user.name "Your Name Here" && \
    git config --global user.email "you@example.com"

# Set the working directory
WORKDIR /usr/src/projectSpace

# Expose the application port (if applicable)
EXPOSE 3000

# Set the default command to bash
CMD ["/bin/bash"]
