Control Groups (cgroups) in Docker

Control Groups (cgroups) are a Linux kernel feature used by Docker to limit and isolate resource usage of containers. They help ensure that a container does not consume more than its allocated resources (CPUs, memory, disk I/O, PIDs, etc.). Docker uses cgroups to enforce these resource constraints.


---

Key Concepts of cgroups in Docker

1. CPU Limits: Restrict how much CPU time a container can use.


2. Memory Limits: Constrain the amount of RAM a container can consume.


3. Block I/O Limits: Control the disk I/O for a container.


4. PIDs Limits: Restrict the number of processes a container can spawn.




---

Practical Example: Using cgroups with Docker

Step 1: Run Container with CPU and Memory Limits

docker run -d --name my_container --cpus="1.5" --memory="500m" --memory-swap="1g" busybox sleep 1000

--cpus="1.5": Allows the container to use 1.5 CPU cores.

--memory="500m": Limits memory usage to 500 MB.

--memory-swap="1g": Total memory (RAM + swap) capped at 1 GB.


Step 2: Verify the cgroup Limits

docker inspect my_container | grep -i "memory"
docker inspect my_container | grep -i "cpu"

Step 3: Monitor Resource Usage

docker stats
docker exec -it my_container sh -c "while :; do :; done"
docker stats

Step 4: Experiment with Disk I/O Limits

docker run -d --name io_test --device-write-bps /dev/nvme0n1:1mb busybox sleep 1000
docker inspect io_test | grep -i "rate"
docker stats


---

Example: Limiting PIDs

docker run -it --name pid_test --pids-limit 6 alpine sh
sleep 10

In another terminal:

docker inspect pid_test | grep -i "pid"
docker stats

Back in the container:

sleep 100 & sleep 200 & sleep 50
sleep 60 & sleep 60 & sleep 60 & sleep 60 & sleep 60 & sleep 60

The output will show "resource temporarily unavailable" after the PID limit is reached.



---

How cgroups Work Under the Hood

Docker creates cgroup entries under /sys/fs/cgroup. You can inspect these directories for resource control and usage.

Use Cases

Prevent Resource Exhaustion: Ensure non-critical containers don't exhaust system resources.

Quality of Service: Prioritize critical containers.

Performance Testing: Simulate resource-constrained scenarios.



---

Updating cgroup Limits for a Running Container

Step 1: Identify cgroup Path

docker inspect --format '{{.Id}}' <container_name>
docker inspect --format '{{.State.Pid}}' <container_name>
cat /proc/<PID>/cgroup
cd /sys/fs/cgroup/<subsystem>/docker/<container_id>

Step 2: Update Resource Limits

Example 1: Update CPU Limits

echo 512 > cpu.shares
echo 50000 > cpu.cfs_quota_us
echo 100000 > cpu.cfs_period_us

Example 2: Update Memory Limits

echo 536870912 > memory.limit_in_bytes
echo 268435456 > memory.soft_limit_in_bytes

Example 3: Update Block I/O Limits

lsblk -o NAME,MAJ:MIN
echo "8:0 10485760" > blkio.throttle.read_bps_device
echo "8:0 10485760" > blkio.throttle.write_bps_device

Step 3: Verify Changes

cat cpu.cfs_quota_us
docker stats <container_name>

Use tools like htop, iotop, or iftop for detailed monitoring.


---

Persistent Changes

Direct cgroup file changes are temporary.

To persist limits, use Docker CLI or daemon configurations.


Using Docker CLI

docker update --cpu-shares 512 --memory 512m <container_name>
docker update --cpus 2 --memory 1g my_container
docker stats

Note: Always test cgroup changes in non-production environments first.


---

End of README


