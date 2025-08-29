FROM python:3.10-slim

WORKDIR /home/app

# Install basic dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git \
    build-essential \
    python3-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Clone the repository
RUN git clone https://github.com/oobabooga/text-generation-webui.git
WORKDIR /home/app/text-generation-webui

# Set up Python environment and install dependencies
RUN pip install --no-cache-dir -r requirements/requirements_cpu_only.txt
RUN pip install --no-cache-dir -r requirements/requirements.txt

# Create directories for volumes
RUN mkdir -p cache characters extensions loras logs models presets prompts softprompts training

# Expose the necessary ports
EXPOSE 7860 5000 5005

# Create a startup script
RUN echo '#!/bin/bash\n\
cd /home/app/text-generation-webui\n\
python server.py --listen --api $EXTRA_LAUNCH_ARGS\n\
' > /home/app/start.sh && chmod +x /home/app/start.sh

# Set the entrypoint
ENTRYPOINT ["/home/app/start.sh"]
