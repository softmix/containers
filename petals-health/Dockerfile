FROM python:3.10-slim-bullseye

RUN apt update && apt install -y libopenblas-dev ninja-build build-essential wget git && rm -rf /var/lib/apt/lists/*
RUN python -m pip install --upgrade pip pytest cmake scikit-build setuptools

WORKDIR /app

RUN wget https://raw.githubusercontent.com/petals-infra/health.petals.dev/main/requirements.txt

RUN pip install --no-cache-dir -r ./requirements.txt --upgrade pip && rm requirements.txt

RUN git clone https://github.com/petals-infra/health.petals.dev.git /app

COPY config.patch .
RUN git apply config.patch

CMD flask run --host=0.0.0.0 --port=31331
