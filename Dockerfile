FROM python:3.11-slim

# Install required system dependencies and numpy dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libffi-dev \
    libssl-dev \
    python3-dev \
    libblas-dev \
    liblapack-dev \
    gfortran \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 3004

# Run main.py when the container launches
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "3004"]

# run with this command
# docker build -t fastapi-moondream-service . && docker run -d -p 3004:3004 --restart always --name fastapi-moondream-service fastapi-moondream-service