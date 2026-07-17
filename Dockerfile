FROM python:3.11-slim

WORKDIR /robot

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

ENV HEADLESS=true

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY testsuites/ ./testsuites/
COPY resources/ ./resources/
COPY execution/ ./execution/

ENTRYPOINT ["python3", "-m", "robot", "--outputdir", "results"]
CMD ["testsuites/"]