i

---

🔹 Introduction to Linux Namespaces

Namespaces are a powerful feature of the Linux kernel used to isolate system resources for containers. Docker heavily relies on namespaces to isolate containers from the host system and from each other.


---

🔸 What Are Linux Namespaces?

Namespaces isolate specific system resources for a group of processes.
Each type of namespace provides a different kind of isolation:

Processes

Network

Filesystem

User IDs

Hostnames

IPC (Inter-Process Communication)



---

🔸 Types of Namespaces in Docker

Namespace	Purpose

PID	Isolates process IDs (PIDs)
Network	Isolates IP, ports, interfaces
Mount	Isolates filesystem (e.g., /)
UTS	Isolates hostname and domain
IPC	Isolates shared memory & semaphores
User	Isolates user/group IDs (UID/GID)



---

🔸 How Docker Uses Namespaces

When a container starts:

A new PID namespace is created (container sees its own PIDs starting from 1).

A new network namespace is created (separate IP stack).

A new mount namespace gives a separate filesystem.

A new UTS namespace gives the container its own hostname.

An IPC namespace isolates shared memory.

Optionally, a user namespace maps UID/GIDs inside the container to different ones outside.



---

🔹 Linux PID Namespace Practical (without Docker)

✅ Step-by-Step:

1. Check current shell PID

echo "Current PID is $$"
echo $SHLVL


2. Start a new PID namespace

unshare -f -p --mount-proc bash


3. Check PID inside new namespace

echo "PID inside namespace: $$"  # Usually shows 1


4. Run a process (like sleep)

sleep 60 &
ps


5. Check from the host in another terminal

ps aux | grep sleep


6. Exit the namespace

exit




---

🔸 Key Observations

Inside Namespace	Outside (Host)

PID starts from 1	Original host PID
Sees own /proc	Sees all processes
Isolated process tree	Full process tree visible



---

🔹 Docker PID Namespace Practical

✅ Steps:

1. Run a container (default isolated PID namespace):

docker run -d --name pid_test ubuntu sleep infinity


2. Check container processes:

docker exec pid_test ps aux

sleep process will have PID 1 inside the container.



3. Check same process on the host:

ps aux | grep sleep

PID will be different than inside the container.





---

🔸 Sharing Host PID Namespace

4. Run container with shared PID namespace:

docker run -d --name pid_host --pid=host ubuntu sleep infinity


5. Check PIDs inside container:

docker exec pid_host ps aux

PIDs will match host PIDs.





---

6. Clean up:

docker stop pid_test pid_host
docker rm pid_test pid_host




---

🔸 Final Observations

Mode	PID Behavior

Default	Container sees its own PIDs (starts from 1)
--pid=host	Container shares host’s PID namespace (same PIDs)



---

🔹 Security and Use Cases

Use Case	Namespace

Isolation for containers	Default (separate) PID namespace
Debugging host from container	--pid=host
Monitoring tools (htop/ps)	May use --pid=host for visibility
Better security	Use isolated namespace (default)



---

i
