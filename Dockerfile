# Required for auto-shutdown
FROM lubien/tired-proxy:2 as proxy
# Use a base image with Python 3.9
FROM python:3.9-slim

# Install build dependencies & Code Server
RUN apt-get update -y && \
    apt-get install -y build-essential git unzip curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*_* && \
    curl -fsSL https://code-server.dev/install.sh | sh

# Prepare the build directory
WORKDIR /app

# Use bash shell
ENV SHELL=/bin/bash

# Install code-server extensions for Python development
RUN curl -L https://fly.io/install.sh | sh \
    && echo 'export FLYCTL_INSTALL="/root/.fly"' >> ~/.bashrc \
    && echo 'export PATH="$FLYCTL_INSTALL/bin:$PATH"' >> ~/.bashrc \
    && code-server --install-extension ms-python.python

# Apply VS Code settings for Python development (you can customize this)
COPY settings.json /root/.local/share/code-server/User/settings.json

# Download the entrypoint.sh from a specific URL
RUN curl -L -o /entrypoint.sh https://raw.githubusercontent.com/Cantue35/files/main/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Copy Tired Proxy from the first stage (if required)
COPY --from=proxy /tired-proxy /tired-proxy

# Set the entrypoint to run the custom script
ENTRYPOINT ["/entrypoint.sh"]
