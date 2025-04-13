# Node.js on Ubuntu 22.04 LTS + Rust & PowerShell
FROM ubuntu:22.04

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Set build-time arguments for Git configuration
ARG GIT_USERNAME
ARG GIT_EMAIL

# Install necessary tools and dependencies
RUN apt-get update && \
    apt-get install -y \
        sudo\
        curl \
        coreutils\
        vim \
        less \
        net-tools \
        iputils-ping \
        build-essential \
        python3-minimal \
        software-properties-common \
        wget \
        apt-transport-https \
        git \
        ca-certificates \
        gnupg \
        lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/* && \
    curl --proto '=https' --tlsv1.2 -sSfL https://solana-install.solana.workers.dev | bash && \
    # Verify Node.js and npm installation
    node -v && npm -v

# Create a non-privileged developer user account
RUN useradd -ms /bin/bash devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/devuser && \
    chmod 440 /etc/sudoers.d/devuser

# Switch to the non-privileged user and optionally configure Git
USER devuser
RUN git config --global user.name "${GIT_USERNAME}" && \
    git config --global user.email "${GIT_EMAIL}"

# Set the working directory & Port
WORKDIR /usr/src/projectSpace
EXPOSE 3000

# Set the container's default command
CMD ["/bin/bash"]
