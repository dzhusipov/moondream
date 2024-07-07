# Use an official Python runtime as a parent image
FROM python:3.9-alpine

# Install required system dependencies
RUN apk add --no-cache gcc g++ make libffi-dev musl-dev linux-headers

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 3004

# Run main.py when the container launches
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3004"]