Docker User Namespace

The Docker User Namespace feature allows you to map container user IDs (UIDs) and group IDs (GIDs) to different IDs on the host system, adding an extra layer of security. This helps prevent privilege escalation attacks, ensuring that a root user inside the container does not map to the root user on the host.

Host File Creation

[root@localhost ~]# cd /tmp
[root@localhost tmp]# echo I am from host > file.txt
[root@localhost tmp]# ls -lh file.txt
-rw-r--r--. 1 root root 15 Dec 30 18:47 file.txt
[root@localhost tmp]# cat file.txt
I am from host
[root@localhost tmp]# exit
logout

Normal User Cannot Modify Host File

$ cat /tmp/file.txt
I am from host
[shaikhlocalhost ~]$ echo I am making changes. > /tmp/file.txt
-bash: /tmp/file.txt: Permission denied

Run Docker Container with Volume Mount

[shaikhlocalhost ~]$ docker run -itd -v /tmp:/tmp/shared alpine

If the image is not locally available, it gets pulled:

Unable to find image 'alpine:latest' locally
...
Status: Downloaded newer image for alpine:latest

Verify Container

[shaikhlocalhost ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND     CREATED         STATUS         PORTS   NAMES
dd7ffe4dedc3   alpine    "/bin/sh"  4 seconds ago   Up 4 seconds           gracious_chebyshev

Access the Container

[shaikhlocalhost ~]$ docker exec -it dd7ffe4dedc3 sh
/ # cd /tmp/shared
/tmp/shared # ls -lh file.txt
-rw-r--r-- 1 root root 15 Dec 30 13:17 file.txt
/tmp/shared # cat file.txt
I am from host
/tmp/shared # echo I am from container > file.txt
/tmp/shared # cat file.txt
I am from container
/tmp/shared # exit

Stop and Remove All Containers

[shaikhlocalhost ~]$ docker stop $(docker ps -aq)
dd7ffe4dedc3
[shaikhlocalhost ~]$ docker rm $(docker ps -aq)
dd7ffe4dedc3
[shaikhlocalhost ~]$ docker ps
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES

Stop Docker Engine and Enable User Namespace Remapping

[shaikhlocalhost ~]$ sudo systemctl stop docker
Warning: Stopping docker.service, but it can still be activated by: docker.socket

[shaikhlocalhost ~]$ sudo dockerd --userns-remap=default &
[1] 39757

Switch to shaikhlocalhost User

[root@localhost ~]# su - shaikhlocalhost

Check Sub UID and GID Mapping

[shaikhlocalhost ~]$ cat /etc/subuid
shaikhlocalhost:100000:65536
dockremap:165536:65536

[shaikhlocalhost ~]$ cat /etc/subgid
shaikhlocalhost:100000:65536
dockremap:165536:65536

Test Access with Namespaces Enabled

[root@localhost ~]# echo "I am from host" > /tmp/usernamespace-test.txt
[root@localhost ~]# cat /tmp/usernamespace-test.txt
I am from host
[root@localhost ~]# su - shaikhlocalhost

Start Container and Map Volume

[shaikhlocalhost ~]$ docker run -itd -v /tmp:/tmp/shared alpine
...
Status: Downloaded newer image for alpine:latest
8b09c883b0ce...

[shaikhlocalhost ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND     CREATED         STATUS         PORTS   NAMES
8b09c883b0ce   alpine    "/bin/sh"  26 seconds ago  Up 25 seconds          awesome_jackson

Now the container runs with UID and GID mappings, enhancing security via User Namespace remapping.


---
Summary

Host file system is protected using user namespaces.

Even if the container runs as root, it does not get root privileges on the host.

This increases security for Docker deployments.


