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
        lsb-release \
        apt-transport-https && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
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
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Add Rust to the PATH environment variable
ENV PATH="/root/.cargo/bin:${PATH}"

# Add the Windows target for Rust cross-compilation
RUN rustup target add x86_64-pc-windows-gnu

# Install PowerShell
RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    rm -rf /var/lib/apt/lists/*

# Pre-configure and install PowerShell modules
RUN pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; \
    Register-PackageSource -Name nuget.org -ProviderName NuGet -Location 'https://api.nuget.org/v3/index.json' -Trusted; \
    Get-PackageProvider | where name -eq 'nuget' | Install-PackageProvider -Force; \
    Install-Module -Name Microsoft.Graph -Force -AllowClobber -Scope AllUsers; \
    Install-Module -Name PnP.PowerShell -Force -AllowClobber -Scope AllUsers; \
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber -Scope AllUsers; \
    Install-Module -Name AzureAD -Force -AllowClobber -Scope AllUsers; \
    Install-Module -Name Az.Security -Force -AllowClobber -Scope AllUsers; \
    Install-Module -Name MicrosoftTeams -Force -AllowClobber -Scope AllUsers; \
    Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers; \
    Install-Module -Name Az -Force -AllowClobber -Scope AllUsers;"

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    apt-get install -y azure-cli && \
    rm -rf /var/lib/apt/lists/*

# Create non-privileged user account
RUN useradd -ms /bin/bash vsuser

# Add vsuser to sudoers
RUN echo "vsuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vscode && chmod 440 /etc/sudoers.d/vscode

# Configure Git with provided arguments
USER vsuser
RUN git config --global user.name "${GIT_USERNAME}" && \
    git config --global user.email "${GIT_EMAIL}"

# Set the working directory
WORKDIR /usr/src/projectSpace

# Expose the application port (if applicable)
EXPOSE 3000

# Set the default command to bash
CMD ["/bin/bash"]
