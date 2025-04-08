# 1. Base image -  Ubuntu
FROM ubuntu:latest

# 2. Set environment variables to prevent interactive prompts during installation 
ENV DEBIAN_FRONTEND=noninteractive 

# 3. Update and install Apache  
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

# 4. Expose the default Apache port 
EXPOSE 80

# 5.# Set the working directory 
WORKDIR /var/www/html 

# 6.# Copy a sample HTML file into the container (optional) 
COPY index.html /var/www/html/index.html

# 7.# Start Apache in the foreground 
CMD ["apachectl", "-D", "FOREGROUND"]


