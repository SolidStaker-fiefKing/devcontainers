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
ENV CI=1
RUN curl https://release.solana.com/v1.18.26/install | sh -s && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s && \
    source $HOME/.cargo/env && \
    cargo install --git https://github.com/project-serum/anchor --tag v0.26.0 anchor-cli --locked && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*


# Install Node.js (20.x)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js and npm installation
RUN node -v && npm -v

# Install Rust using rustup
RUN curl https://sh.rustup.rs -sSf | sh -s

# Ensure cargo and rust are added to PATH
ENV PATH="/root/.cargo/bin:/root/.local/share/solana/install/active_release/bin:${PATH}"

# Add required Rust components and the BPF target for Solana/Anchor development
RUN rustup update && \
    rustup component add llvm-tools-preview && \
    rustup target add bpfel-unknown-unknown

# Install the Anchor CLI from its GitHub repository (this may take some time)
RUN cargo install --git https://github.com/project-serum/anchor anchor-cli --locked

# Install the Solana CLI using the official installer script
RUN sh -c "$(curl -sSfL https://release.solana.com/v1.18.26/install)" && \
    rm -rf /var/lib/apt/lists/*
# Ensure the Solana CLI is available in PATH
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"

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
