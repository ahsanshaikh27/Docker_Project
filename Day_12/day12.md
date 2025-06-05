


---

🐳 Docker Copy-on-Write (CoW) Strategy –

Docker uses a Copy-on-Write (CoW) strategy to efficiently manage storage in images and containers. This guide provides a detailed explanation of the CoW concept in Docker, including its benefits, implementation using storage drivers, and real-world examples.


---

📚 Table of Contents

1. What is Copy-on-Write (CoW)?


2. Why Docker Uses Copy-on-Write


3. How Docker Implements CoW


4. Docker Image Layers and CoW


5. Docker Storage Drivers


6. Example of CoW in Action


7. Performance and Limitations


8. Best Practices


9. Summary




---

1. What is Copy-on-Write (CoW)?

Copy-on-Write is a strategy where multiple entities can share the same data until one of them modifies it. Upon modification, only the changed part is duplicated, saving space and improving performance.

🧠 Key Idea:

> "Don't copy data until it is modified."




---

2. Why Docker Uses Copy-on-Write

Docker containers are created from images, which are made of layers. Instead of copying all layers when creating a container, Docker uses CoW to:

Save disk space.

Increase performance.

Speed up container start time.



---

3. How Docker Implements CoW

When a container is started from an image:

It shares the read-only layers from the image.

A new read-write layer is added on top.

Only changed files are copied to the new layer.


🗂️ Layer Stack (Bottom to Top):

Read-only base image layers (e.g., Ubuntu, App, Config)
↑
Read-write layer (unique to the container)


---

4. Docker Image Layers and CoW

Each Dockerfile instruction (like RUN, COPY, ADD) creates a new image layer.

Example Dockerfile:

FROM ubuntu:20.04
RUN apt update && apt install nginx -y
COPY index.html /var/www/html/index.html

Each line creates a new layer. Docker reuses these layers via CoW until you change a file, triggering a copy.


---

5. Docker Storage Drivers

Storage drivers implement CoW at the OS level. Common drivers:

Driver	OS Support	CoW Method

overlay2	Modern Linux distros	CoW via OverlayFS
aufs	Ubuntu (legacy)	CoW via aufs
btrfs	SUSE, Fedora	Native Btrfs CoW
zfs	Solaris, Ubuntu ZFS	Native ZFS CoW
devicemapper	RHEL, CentOS (legacy)	CoW at block level


📌 Note: Most systems today use overlay2.


---

6. Example of CoW in Action

# Step 1: Pull an image
docker pull ubuntu:20.04

# Step 2: Create and run a container
docker run -it ubuntu:20.04

# Step 3: Inside the container, install a package
apt update && apt install curl -y

# Step 4: Exit the container
exit

# Observation: Only modified files are written in the container's layer

🧠 Docker doesn’t copy the full image—it only stores changes like curl installation in a new container-specific layer.


---

7. Performance and Limitations

✅ Pros:

Efficient disk usage

Fast container startup

Reusability of image layers


⚠️ Cons:

Too many layers can slow performance

Storage drivers can have compatibility issues

Layered changes are harder to debug



---

8. Best Practices

Minimize layers in Dockerfile

Use multi-stage builds to reduce size

Prefer overlay2 driver for performance

Clean up unnecessary files during build (rm -rf /var/lib/apt/lists/*)



---

9. Summary

Concept	Description

Copy-on-Write	Only modified data is copied; original stays intact
Container Storage	Read-write layer on top of image layers
Storage Drivers	Implement CoW (overlay2, aufs, etc.)
Benefits	Speed, space efficiency, layer reusability
Use Cases	Every container operation in Docker uses CoW under the hood



