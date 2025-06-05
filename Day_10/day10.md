Access Docker Server Remotely on RHEL 9

To access Docker installed on RHEL 9 from a remote machine, you need to configure Docker to listen on a network-accessible port.


---

1. Enable Docker Remote API on RHEL 9

By default, the Docker daemon listens on unix:///var/run/docker.sock. To allow remote access, configure it to listen on a TCP socket.

Edit Docker Service File

# vim /lib/systemd/system/docker.service

Find the ExecStart line and modify it:

ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375

Note:

0.0.0.0 allows access from any IP. Replace it with a specific IP (e.g., 192.168.1.100) to restrict access.

-H flags specify the sockets Docker daemon listens on.


Explanation:

-H unix:///var/run/docker.sock: Enables local Docker CLI communication.

-H tcp://0.0.0.0:2375: Enables remote access via TCP on port 2375.


⚠️ Security Risk: This configuration is insecure as it does not use TLS. Anyone with access to this port can control your Docker daemon.


---

2. Reload and Restart Docker

# systemctl daemon-reload
# systemctl restart docker


---

3. Configure Firewall

Allow access to the Docker API port (default: 2375):

# firewall-cmd --permanent --add-port=2375/tcp
# firewall-cmd --reload


---

4. Test Docker Remote API

From Remote Machine:

Using curl:

# curl http://<RHEL9-IP>:2375/containers/json

Should return a list of running containers in JSON.

Using Docker client:

# docker -H tcp://<RHEL9-IP>:2375 ps


---

5. Secure the Docker Remote API (Recommended)

Enable TLS for Secure Communication

Generate TLS certificates for client and server.

Update ExecStart with TLS flags:

ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2376 \
  --tlsverify \
  --tlscacert=/path/to/ca.pem \
  --tlscert=/path/to/server-cert.pem \
  --tlskey=/path/to/server-key.pem

Restart Docker:

# systemctl daemon-reload
# systemctl restart docker

Restrict access using:

Firewalls

Specific IPs in the -H flag



---

6. Troubleshooting

If Docker fails to start:

# journalctl -u docker.service

Ensure:

No port conflicts (e.g., 2375 already in use)

Proper formatting of docker.service

Valid TLS certificate paths (if used)



---

Summary

This guide enables Docker Remote API access on RHEL 9 securely. Avoid exposing Docker API over unsecured networks. Always prefer TLS and firewall rules for production environments.


