# Cognitive Parliament - Production Dockerfile
# Multi-stage build for optimized image size

# Stage 1: Builder
FROM python:3.11-slim AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    make \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /build

# Copy dependency files
COPY pyproject.toml setup.py ./
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim

# Security: Create non-root user
RUN useradd -m -u 1000 -s /bin/bash cpuser

# Set working directory
WORKDIR /app

# Copy Python dependencies from builder
COPY --from=builder /root/.local /home/cpuser/.local

# Copy application code
COPY --chown=cpuser:cpuser src/ ./src/
COPY --chown=cpuser:cpuser config/ ./config/

# Set environment variables
ENV PATH=/home/cpuser/.local/bin:$PATH
ENV PYTHONPATH=/app/src
ENV PYTHONUNBUFFERED=1

# Switch to non-root user
USER cpuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import cognitive_parliament; print('OK')"

# Default command
CMD ["python", "-m", "cognitive_parliament.cli"]
