FROM python:3.10-slim-bullseye

RUN apt update && apt install -y libopenblas-dev ninja-build build-essential wget git && rm -rf /var/lib/apt/lists/*
RUN python -m pip install --upgrade pip pytest cmake scikit-build setuptools

WORKDIR /app

RUN wget https://raw.githubusercontent.com/petals-infra/chat.petals.dev/main/requirements.txt

RUN apt-get update \
    && apt-get install -y git \
    && pip install -r /app/requirements.txt \
    && rm requirements.txt

RUN git clone https://github.com/petals-infra/chat.petals.dev.git /app && git fetch origin pull/50/head:pr50 && git checkout pr50

RUN python -m pip install fschat

COPY *.patch /app/
RUN git apply config.patch && rm config.patch
RUN git apply utils.patch && rm utils.patch

CMD ["sh", "-c", "python3 openai_api.py --host=0.0.0.0 --port=5000"]
