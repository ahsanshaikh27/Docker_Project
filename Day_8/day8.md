 Build a Container Image Using Dockerfile

This guide explains how to build a Docker image for an Ubuntu-based Apache container using a Dockerfile.




🧱 Step 1: Create a Directory for the Project

Create a new directory to hold your Dockerfile and other related files:

$ mkdir ubuntu-apache
$ cd ubuntu-apache



✍️ Step 2: Write the Dockerfile

Create a Dockerfile using your preferred editor:

$ vim Dockerfile

Add the following content:

# Use an official Ubuntu base image
FROM ubuntu:latest

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install Apache
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

# Expose the default Apache port
EXPOSE 80

# Set the working directory
WORKDIR /var/www/html

# Copy a sample HTML file into the container (optional)
COPY index.html /var/www/html/index.html

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]




📄 Step 3: Create an index.html File (Optional)

Create a sample index.html file to test your Apache server:

<!DOCTYPE html>
<html>
<head>
  <title>Welcome to Apache</title>
</head>
<body>
  <h1>Hello from Ubuntu Apache Container!</h1>
</body>
</html>



🔨 Step 4: Build the Docker Image

Build the image using the following command:

$ docker build -t ubuntu-apache .




🚀 Step 5: Run the Container

Run a container from the new image:

$ docker run -d -p 8080:80 ubuntu-apache



🌐 Step 6: Access the Apache Server

Open your browser and go to:

http://localhost:8080

You should see the content of your index.html file.




📋 Step 7: Verify Running Containers

Check if the container is running:

$ docker ps

