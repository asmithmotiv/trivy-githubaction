# Intentionally vulnerable Dockerfile for Trivy scanning demo
# Uses an old base image with known CVEs
FROM python:3.8.0

# Run as root (bad practice, Trivy will flag this)
USER root

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py .

# Expose sensitive port
EXPOSE 8080

CMD ["python", "app.py"]
