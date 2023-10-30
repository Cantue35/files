#!/bin/bash
TIME_TO_SHUTDOWN=7200
mkdir -p /project
# In case fly volumes put something there
rm -rf '/project/lost+found'
if [ -z "$(ls -A /project)" ]; then
    echo "Preparing project"
    rm -rf /project
    # Clone your Python project repository
    git clone $GIT_REPO /project
    cd /project
    echo "Setting up Python environment"
    # Replace the following lines with Python environment setup steps (e.g., virtualenv, pip install, etc.)
    # Example:
    # python -m venv venv
    # source venv/bin/activate
    # pip install -r requirements.txt
fi
# Start code-server with the Python project
code-server --bind-addr 0.0.0.0:9090 /project &
# Start Tired Proxy to map port 8080 to 9090
/tired-proxy --port 8080 --host http://localhost:9090 --time $TIME_TO_SHUTDOWN