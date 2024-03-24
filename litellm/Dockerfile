FROM ghcr.io/berriai/litellm:main-v1.33.7

# Install the required packages
RUN apt update && apt install -y git && rm -rf /var/lib/apt/lists/*

# Install the required Python packages
RUN python -m pip install git+https://github.com/bigscience-workshop/petals

COPY tokenizer-config.patch .
RUN git apply tokenizer-config.patch && rm tokenizer-config.patch
