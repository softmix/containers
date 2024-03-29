FROM python:3.10-slim-bullseye

RUN apt update && apt install -y libopenblas-dev ninja-build build-essential wget git && rm -rf /var/lib/apt/lists/*
RUN python -m pip install --upgrade pip pytest cmake scikit-build setuptools

WORKDIR /app

RUN wget https://raw.githubusercontent.com/petals-infra/chat.petals.dev/main/requirements.txt

RUN apt-get update \
    && apt-get install -y git \
    && pip install -r /app/requirements.txt \
    && rm requirements.txt

# This is in a PR that hasn't been accepted yet
RUN python -m pip install fschat

RUN git clone https://github.com/petals-infra/chat.petals.dev.git /app && \
    git config --global user.email "<>" && \
    git config --global user.name "deadhead" && \
    for PR in 50 51 54 56; do git fetch origin pull/$PR/head:pr$PR && git merge --no-ff pr$PR -m "Merge PR #$PR"; done

RUN wget https://github.com/petals-infra/chat.petals.dev/compare/main...softmix:chat.petals.dev:custom-model.diff -O custom-model.diff && \
    git apply custom-model.diff && \
    rm custom-model.diff

CMD ["sh", "-c", "python3 openai_api.py --host=0.0.0.0 --port=5000"]
