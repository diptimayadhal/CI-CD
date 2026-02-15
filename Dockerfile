# Use official Python image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose port
EXPOSE 5000

# Run app with gunicorn
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]
