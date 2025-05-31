Create Container Image from Another Container
The docker commit command is used to create a new Docker image from a container's 
changes. This is useful when you've made changes to a running container and want to save 
those changes as a new image. Here's how you can do it step by step:
Steps to Create a Docker Image Using docker commit:
1. Run a container: Start a container from an existing image. For example:
$ docker run -it ubuntu bash
2. Make changes inside the container: Inside the running container, you can install 
software, modify configurations, or add files. For example:
$ apt update
$ apt install -y nginx
$ exit
3. List running containers: Find the container ID or name using:
$ docker ps -a
4. Commit the changes: Use the docker commit command to create a new image from 
the container. Replace container_id with the actual container ID or name:
$ docker commit container_id new_image_name:tag
Example:
$ docker commit 123abc45 ubuntu-nginx:latest
5. Verify the new image: List all Docker images to confirm your new image is created:
$ docker images
6. Run a container from the new image: Start a new container from the custom image:
$ docker run -it ubuntu-nginx bash
Example:
Step 1: Start a container
$ docker run -it ubuntu bash
Step 2: Make changes: Inside the container:
$ apt update
$ apt install -y curl
$ exit
Step 3: Commit the container: Find the container ID:
$ docker ps -a
Commit the container:
$ docker commit abc123 my-custom-ubuntu:1.0
Create Container Image from Another Container

Step 4: Verify the image

$ docker images.

Step 5: Run a container from the new image $ docker run -it my-custom-ubuntu:1.0 bash

Notes:

Use docker commit sparingly, as it's not a best practice for creating Docker images. For repeatable and version-controlled images, it's better to use a Dockerfile.

You can add metadata using the author and message flags:

docker commit -author-"Shaikh Ahsan custom_image:tag message="Added curl" container_idi
