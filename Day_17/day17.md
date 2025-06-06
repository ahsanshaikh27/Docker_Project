UTS (UNIX Timesharing System) namespace in Docker isolates hostname and domain 
name settings between containers and the host system. This allows containers to have their own 
hostname and domain name, making them appear as separate systems in the network. 

Here’s a step-by-step practical guide with examples: 

1. Understanding UTS Namespace in Docker: 
• By default, all containers share the same UTS namespace with the host unless explicitly 
isolated. 
• The --uts flag in Docker is used to configure UTS namespace behavior. 

2. Examples of UTS Namespace Usage: 

Example 1: Isolated UTS Namespace 

This creates a container with its own hostname. 

Run a container and set a custom hostname 

# docker run -it --hostname custom-container-hostname --name uts-example1 ubuntu bash 
Inside the container: 

# cat /etc/os-release 

# hostname 

Press Ctrl+p+q to exit the container shell. 

From the host: 

# docker ps 

# docker exec uts-example1 hostname 

Example 2: Sharing the Host's UTS Namespace 
By sharing the host's UTS namespace, the container and host use the same hostname. 
Run a container sharing the host's UTS namespace

# docker run --name uts-example2 -it --uts=host ubuntu bash 

Inside the container: 
# cat /etc/os-release 

# hostname 
From the host: 
# docker ps 
# hostname 
Change the host's hostname 
# sudo hostnamectl set-hostname shared-hostname 
# docker exec uts-example2 hostname 
# sudo hostnamectl set-hostname nehraclasses.local 
# docker exec uts-example2 hostname 
3. Key Use Cases: 
1. Testing Multi-Host Applications: Containers can mimic multiple systems in a 
network by assigning different hostnames. 
2. Legacy Applications: Applications dependent on specific hostname configurations can 
run in isolated UTS namespaces. 
3. Development and Testing: Simulate different environments without impacting the 
host or other containers. 
4. Notes: 
• Default Behavior: If --uts is not specified, Docker assigns a unique hostname to each 
container but isolates the UTS namespace. 
• Impact of Sharing: Changes to the hostname in a shared UTS namespace affect all 
systems using the namespace.
IPC (Inter-Process Communication) Namespace in Docker isolates communication 
mechanisms such as shared memory and semaphores between containers and the host. This 
allows containers to have their own IPC resources or share them with other containers or the 
host. 
Here’s a practical guide with examples: 
1. Understanding IPC Namespace in Docker: 
The IPC (Inter-Process Communication) namespace in Docker is a Linux namespace that 
isolates the mechanisms for inter-process communication, such as System V IPC objects 
(shared memory segments, message queues, semaphores) and POSIX shared memory. 
Each container by default operates in its own IPC namespace, ensuring that processes inside 
the container cannot access IPC resources of other containers or the host unless explicitly 
shared. 
Uses of IPC Objects (e.g., Shared Memory) in Linux 
Inter-Process Communication (IPC) objects like shared memory are used to enable processes 
to communicate and share data efficiently. Here's a detailed breakdown of the use cases and 
advantages of IPC objects, especially shared memory, in Linux: 
1. Shared Memory Overview 
Shared memory is a segment of memory that multiple processes can access simultaneously. It 
is the fastest IPC mechanism as processes can directly read/write to the memory without 
needing kernel intervention after setup. 
2. Use Cases of Shared Memory in Linux 
a. High-Performance Data Sharing 
• Applications: Databases, multimedia processing, scientific computing. 
• Example: A database server uses shared memory to allow multiple clients or worker 
processes to access a common data buffer. 
b. Communication Between Parent and Child Processes 
• Applications: Multi-threaded or multi-process programs.
• Example: A parent process creates a shared memory segment, and child processes use 
it to exchange data without context switching. 
c. Real-Time Applications 
• Applications: Gaming engines, robotics, and sensor-based systems. 
• Example: A robotics application might share sensor data in real time between a data 
acquisition process and a control process. 
d. Producer-Consumer Pattern 
• Applications: Queues, logging systems. 
• Example: A producer process writes data to shared memory, and a consumer process 
reads and processes it asynchronously. 
e. Inter-Process Coordination 
• Applications: Synchronization of processes. 
• Example: Semaphore or mutex locks are used alongside shared memory to coordinate 
access to the memory. 
f. Caching Mechanisms 
• Applications: Web servers, content delivery systems. 
• Example: A web server might use shared memory to store frequently accessed pages 
or data for quick retrieval. 
3. Advantages of Shared Memory 
1. Speed: 
o No need for data copying between processes as they can directly access the 
memory. 
o Faster than other IPC mechanisms like pipes or sockets. 
2. Low Overhead: 
o Minimal kernel involvement once the shared memory is set up. 
3. Efficient Resource Utilization: 
o Reduces the memory footprint as data is stored in one location and shared 
among processes. 
4. Scalability: 
o Ideal for high-throughput, low-latency systems with multiple processes. 
4. Examples of Shared Memory Usage
a. Creating and Using Shared Memory 
1. Create a Shared Memory Segment: 
2. int shmid = shmget(IPC_PRIVATE, 1024, IPC_CREAT | 0666); 
o Creates a shared memory segment of 1024 bytes. 
3. Attach the Shared Memory: 
4. char *data = shmat(shmid, NULL, 0); 
5. Write Data to Shared Memory: 
6. strcpy(data, "Hello, Shared Memory!"); 
7. Detach the Shared Memory: 
8. shmdt(data); 
9. Remove the Shared Memory Segment: 
10. shmctl(shmid, IPC_RMID, NULL); 
b. Using Shared Memory in Shell (via ipcmk and ipcs commands) 
1. Create Shared Memory: 
# ipcmk -M 1024 
Output: 
Shared memory id: 2 
2. View the Shared Memory Segments: 
# ipcs -m 
3. Remove & Verify the Shared Memory Segments: 
# ipcrm -m 2 
# ipcs -m 
5. Alternatives to Shared Memory 
1. Pipes/FIFOs: 
o Suitable for sequential data transfer but slower due to kernel involvement. 
2. Sockets: 
o Used for network-based IPC or when processes are on different machines. 
3. Message Queues: 
o Useful for structured communication, but less efficient for large data. 
4. Memory-Mapped Files (mmap): 
o Allows shared access to file-backed memory.


