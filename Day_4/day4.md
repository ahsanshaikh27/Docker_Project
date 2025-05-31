Docker Installation & Configuration on RHEL 9
Docker Installation on RHEL 9:
Prerequisites:
1. Minimal Installed RHEL 9
2. Minimum 2 CPUs or vCPUs
3. Minimum 2 GB RAM or more
4. Sudo user with admin privileges
5. Internet Connectivity


Without any further delay, lets jump into the docker installation steps.

1) Remove Podman & Buildah packages:
This step is optional in case you have not installed podman on your system. If it is installed, then 

remove it using following dnf command.
$ sudo dnf remove -y podman buidah

2) Add Docker Repository on RHEL 9:
Docker package is not available in the default repositories of RHEL 9, so for its installation add its 
repository using beneath dnf command.
$ sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
Next, verify docker repository, run
$ sudo dnf repolist
3) Install Docker on RHEL 9:
After adding docker repository, we are good to proceed with docker installation. Run following dnf 
command.
$ sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
Above command will install latest version of Docker community edition. If you are looking for specific 
docker version, then run below command to list the versions.
$ sudo dnf list docker-ce --showduplicates | sort -r
In above output, second column is version-string. So, choose the version that you want to install and 
run below command.
$ sudo dnf install docker-ce-<version-string> docker-ce-cli-<version-string> containerd.io docker-buildx-plugin docker-compose-plugin-y



Docker Installation & Configuration on RHEL 9

4) Start and Enable Docker Service:

Once docker and its dependencies are installed then start and enable its service using systemctl

command as shown below:

$ sudo systemctl enable-now docker

To verify the docker service status, run

$ sudo systemcti status docker

Next, add your local user to the docker group so that your user can run docker commands without sudo.

$ sudo usermod -aG docker $USER

$ newgrp docker

$ id

N

Now, try to run docker version command without sudo.

$ docker version

5) Test Docker Installation:

To test whether docker installation is successful or not, run a conta



$ docker run hello-world

Great, output confirms that our docker instalation is succesful as we can see the informational message.
