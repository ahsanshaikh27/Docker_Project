Docker Volume Namespace 

Docker volumes are essential for managing data persistence in containers. They enable data to survive container restarts and facilitate data sharing between containers. This guide provides practical examples and explanations of Docker volumes and their namespace-like behavior.

---

1. Creating and Inspecting a Docker Volume

docker volume ls
docker volume create my_volume
docker volume ls
docker volume inspect my_volume

Description:

Creates a volume named my_volume.

Inspection reveals mount point and configuration details.



---

2. Using a Volume in a Container

docker run -d --name container1 -v my_volume:/data nginx

Inside container:

docker exec -it container1 bash
ls /data
echo Hello Friends > /data/practice.txt
exit

On host:

ls /var/lib/docker/volumes/my_volume/_data
cat /var/lib/docker/volumes/my_volume/_data/practice.txt


---

3. Sharing a Volume Between Containers

docker run -d --name container2 -v my_volume:/shared-data alpine sleep 1000

Test Data Sharing:

docker exec container1 bash -c "echo 'Hello from container1' > /data/test.txt"
docker exec container2 cat /shared-data/test.txt
docker exec container2 cat /shared-data/practice.txt


---

4. Cleaning Up Volumes

docker rm -f container1 container2
docker volume rm my_volume
docker volume ls


---

5. Anonymous Volumes

docker run -d --name container3 -v /data nginx
docker volume ls
docker inspect <volume_id>

Description:

Creates an unnamed (anonymous) volume.



---

6. Bind Mounts vs. Volumes

Bind Mount Example:

docker run -d --name container4 -v /tmp/:/tmp/data/ nginx
docker exec -it container4 bash
echo "Today Awesome Wheather" > /tmp/data/practice.txt
cat /tmp/data/practice.txt
exit
cat /tmp/practice.txt

Difference:

Volumes: Managed by Docker, stored in /var/lib/docker/volumes/.

Bind Mounts: Use existing host directories.



---

7. Backing Up and Restoring Volume Data

Backup Volume:

docker run --rm -v my_volume:/data -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /data

Explanation:

--rm: Remove container after execution.

-v my_volume:/data: Mounts volume.

-v $(pwd):/backup: Mounts current host directory.

tar cvf /backup/backup.tar /data: Creates backup archive.


Restore Volume:

docker volume rm my_volume
docker run --rm -v my_volume:/data -v $(pwd):/backup ubuntu tar xvf /backup/backup.tar -C /
docker volume ls

Result:

backup.tar contains volume data.



---

8. Namespace-Like Isolation Using Volumes

docker run -d --name container5 -v volume1:/data nginx
docker run -d --name container6 -v volume2:/data nginx

Description:

Each container has its own isolated storage.



---

Summary

Volumes: Best for persistent, managed storage.

Anonymous Volumes: Temporary, unnamed storage.

Bind Mounts: Direct host-directory mapping.

Isolation: Unique volumes act like isolated namespaces.


Use Docker volumes to create persistent, flexible, and isolated storage environments for containers.


