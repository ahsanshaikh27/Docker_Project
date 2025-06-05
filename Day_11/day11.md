Docker Image & Container Filesystem Guide

Overview

This guide provides a detailed understanding of how Docker manages disk space, images, containers, volumes, and the underlying filesystem structure. It includes practical commands and walkthroughs to explore and manage Docker resources efficiently.


---

Disk Space Monitoring and Cleanup

Identify Disk Space Usage

docker system df

Use this to monitor disk usage of images, containers, volumes, and build cache.

Verbose Disk Usage Details

docker system df --verbose

Displays detailed layer-level information.

Clean Up Unused Resources

docker system prune -a

Removes all unused images, containers, volumes, and networks. Use with caution.

Example Output

TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          10        5         2.5GB     1.2GB (48%)
Containers      6         3         1.5GB     800MB (53%)
Local Volumes   3         2         500MB     200MB (40%)
Build Cache     1         0         300MB     300MB (100%)


---

System Information

View Docker Configuration and Environment

docker info

Provides detailed information about the Docker daemon, storage driver, number of containers, etc.

Docker Root Directory

ls -lh /var/lib/docker

Contains all Docker-managed data.


---

Important Docker Directories

1. /var/lib/docker/containers/

Stores metadata, logs (log.json), and configuration (config.v2.json) for each container.

ls -lh /var/lib/docker/containers/

2. /var/lib/docker/image/

Stores image-related data like metadata, layer information.

ls -lh /var/lib/docker/image/
ls -lh /var/lib/docker/image/overlay2

3. /var/lib/docker/overlay2/

Used by the overlay2 storage driver for storing layers.

ls -lh /var/lib/docker/overlay2/

diff/: Filesystem changes

merged/: Merged view

work/: Temporary files


4. /var/lib/docker/volumes/

Persistent volumes data directory.

ls -lh /var/lib/docker/volumes/

5. /var/lib/docker/network/

Networking state and config.

ls -lh /var/lib/docker/network/

6. /var/lib/docker/plugins/

Stores data for Docker plugins.

ls -lh /var/lib/docker/plugins/

7. /var/lib/docker/runtimes/

Container runtimes like runc.

ls -lh /var/lib/docker/runtimes/

8. /var/lib/docker/swarm/

Swarm mode configuration and state.

ls -lh /var/lib/docker/swarm/

9. /var/lib/docker/tmp/

Temporary files.

ls -lh /var/lib/docker/tmp/

10. /var/lib/docker/trust/

Stores Docker Content Trust (DCT) data.

ls -lh /var/lib/docker/trust/

11. /var/lib/docker/buildkit/

Stores BuildKit build data.

ls -lh /var/lib/docker/buildkit/


---

Types of Docker Filesystems

Host Filesystem: Actual filesystem on host.

Container Filesystem: Combined layered view seen by containers.

Volume Filesystem: Persistent and independent of containers.

Bind Mount: Direct mapping from host to container.



---

How Docker Images Are Stored

Layered Filesystem

Each instruction in a Dockerfile creates a new immutable layer.

Storage Drivers

Common: overlay2 (default), aufs, btrfs, zfs, devicemapper


Image Metadata

Stored under:

/var/lib/docker/image/<storage-driver>/


---

Exploring Docker Image Layers

Step 1: Pull Image and Observe Layers

docker pull nginx
ls -lh /var/lib/docker/overlay2
ls -lh /var/lib/docker/image/overlay2/layerdb/sha256/

Step 2: Locate Docker Root Dir

docker info | grep "Docker Root Dir"

Step 3: Check Storage Driver

docker info | grep "Storage Driver"

Step 4: Inspect Overlay2

cd /var/lib/docker/overlay2
ls -lh

Step 5: Inspect Image Metadata

cd /var/lib/docker/image/overlay2/imagedb/content/sha256
ls -lh

Step 6: Inspect Docker Image

docker inspect nginx


---

File Changes Inside Container

Step-by-Step

1. Start Container:



docker run -it --name=webserver nginx bash

2. Create File:



echo "Hello, Docker!" > /usr/share/nginx/html/hello.html
exit

3. Commit Container:



docker commit webserver my-nginx

4. Check Layers:



docker inspect my-nginx | grep -A 10 "RootFS"
docker inspect my-nginx | grep Upper
cd /var/lib/docker/overlay2/<layer-id>/diff/usr/share/nginx/html
cat hello.html


---

Types of Layers in Docker Images

1. Base Layer

Minimal OS layer like Ubuntu, Alpine.

2. Intermediate Layers

Each instruction from Dockerfile (RUN, COPY, etc.).

3. Writable Layer (Top Layer)

Temporary changes at runtime. Lost on container removal unless committed.


---

Summary

Docker organizes image and container data in layers.

Files are stored in /var/lib/docker.

OverlayFS (overlay2) is commonly used for managing these layers.

Use Docker commands to monitor space, inspect images, and manage containers efficiently.




