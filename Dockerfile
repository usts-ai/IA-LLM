FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

WORKDIR /home/app

# Install basic dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git \
    build-essential \
    python3-dev \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set Python to use UTF-8 encoding
ENV PYTHONIOENCODING=utf-8

# Clone the repository
RUN git clone https://github.com/oobabooga/text-generation-webui.git
WORKDIR /home/app/text-generation-webui

# Set up Python environment and install dependencies
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN pip3 install --no-cache-dir -r requirements/full/requirements.txt
RUN pip3 install --no-cache-dir xformers

# Create directories for volumes
RUN mkdir -p cache characters extensions loras logs models presets prompts softprompts training

# Expose the necessary ports
EXPOSE 7860 5000 5005

# Create a startup script
RUN echo '#!/bin/bash\n\
cd /home/app/text-generation-webui\n\
python3 server.py --listen --api $EXTRA_LAUNCH_ARGS\n\
' > /home/app/start.sh && chmod +x /home/app/start.sh

# Set the entrypoint
ENTRYPOINT ["/home/app/start.sh"]
