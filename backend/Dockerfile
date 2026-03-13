# Use Python 3.11 slim as the base image for a small footprint
FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /app

# Set environment variables to prevent Python from writing .pyc files 
# and ensure output is sent directly to the logs
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install any essential system-level dependencies
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     gcc \
#     && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Ensure the 'data' directory exists for JSON persistence
RUN mkdir -p data/simulations data/news_images

# Expose the API port
EXPOSE 8000

# Command to run the application using uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
