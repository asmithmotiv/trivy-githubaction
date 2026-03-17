# Intentionally vulnerable Dockerfile for Trivy scanning demo
# Uses an old base image with known CVEs
FROM python:3.8.0

# Run as root (bad practice, Trivy will flag this)
USER root

# Install packages with known vulnerabilities
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    openssl=1.1.1d-0+deb10u3 \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py .

# Expose sensitive port
EXPOSE 8080

CMD ["python", "app.py"]
