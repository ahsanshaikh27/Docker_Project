

---

Docker Network Namespace – 

🎯 Goal

Understand how Docker uses network namespaces to isolate containers.

Create and connect Docker containers to observe network namespaces in action.



---

🔹 1. Verify Default Docker Networks

Docker creates default networks upon installation:

docker network ls

Example Output:

NETWORK ID     NAME      DRIVER    SCOPE
e5ef2b61a74a   bridge    bridge    local
62e10959bfc8   host      host      local
45ec96c8bc2c   none      null      local

> The bridge network is the default for container communication.




---

🔹 2. Run Containers and Inspect Network Namespace

Launch Containers:

docker run -dit --name container1 alpine sh
docker run -dit --name container2 alpine sh
docker ps

Inside a container:

docker exec -it container1 sh
ip a

> You'll see a eth0 interface assigned via the bridge network.




---

🔹 3. Inspect Bridge Network

On the host:

docker network inspect bridge

Observe:

Subnet (e.g., 172.17.0.0/16)

Connected containers (container1, container2)



---

🔹 4. Ping Between Containers

docker exec -it container1 ping -c 3 172.17.0.3

> ✅ Containers on the same bridge network can communicate by default.




---

🔹 5. Custom Bridge Network

Create Custom Network:

docker network create my_bridge
docker network ls

Run Containers in Custom Network:

docker run -dit --name custom1 --network my_bridge alpine sh
docker run -dit --name custom2 --network my_bridge alpine sh
docker ps

Inspect Network:

docker network inspect my_bridge
docker exec -it custom1 ping -c 3 172.18.0.3

> Confirm container-to-container connectivity on the custom bridge network.




---

🔹 6. Isolated Network Example

Create Isolated Network:

docker network create isolated_net --driver bridge --internal
docker network ls

Run Container in Isolated Network:

docker run -dit --name isolated1 --network isolated_net alpine sh
docker ps
docker network inspect isolated_net

Test Isolation:

Try pinging a container on another network:

docker exec -it custom1 ping -c 3 172.19.0.2

> ❌ No connectivity — isolated_net blocks external communication.




---

🔹 7. Host Network Example

Run Container on Host Network:

docker run -dit --name host_net --network host alpine sh
docker ps

Inspect Network Interface:

docker exec -it host_net ip a
ip a

> The container shares the host's network namespace (same IP and interfaces).




---

🔹 8. Cleanup

Remove Containers:

docker rm -f container1 container2 custom1 custom2 isolated1 host_net
docker ps

Remove Networks:

docker network rm my_bridge isolated_net
docker network ls


---

📘 Summary

Network Type	Description

Bridge	Containers communicate via virtual Ethernet bridge (default)
Custom Bridge	Similar to default, allows better control and isolation
Internal	No external communication, fully isolated
Host	Container uses host's network directly



---

✅ Result

You’ve explored how Docker network namespaces:

Isolate container networks using virtual Ethernet interfaces

Enable or block inter-container communication based on the network type

Allow advanced control using custom and internal bridge networks



---

