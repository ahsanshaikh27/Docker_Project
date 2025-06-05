Docker: Managing Registries and Repositories

Docker registries are repositories where Docker images are stored, managed, and distributed. They enable teams and organizations to manage their containerized applications effectively.


---

📦 Types of Docker Registries

1. Public Docker Registries

Public registries are accessible to anyone, allowing users to pull and push container images without restriction.

Examples:

Docker Hub (default)

GitHub Container Registry

Quay.io


Use Cases:

Sharing open-source projects

Accessing pre-built images for common software


Advantages:

Free access to many pre-built images

Supports collaboration and open-source contributions


Drawbacks:

Limited privacy unless private repositories are used

May have pull rate limits



---

2. Private Docker Registries

Private registries restrict access to container images, requiring authentication for operations like pulling or pushing images.

Examples:

Docker Hub (private repositories)

AWS ECR (Elastic Container Registry)

Google Container Registry (GCR)

Azure Container Registry (ACR)

Self-hosted: Harbor, JFrog Artifactory


Use Cases:

Storing proprietary or sensitive container images

Enforcing security and compliance standards

Hosting internal images for private projects


Advantages:

Greater control over access and security

Custom configurations tailored to specific needs


Drawbacks:

May require additional management and cost



---

🆚 Comparison Table

Feature	Public Registry	Private Registry

Access	Open to the public	Restricted to authenticated users
Cost	Mostly free	May incur setup/hosting costs
Privacy	Limited without private repos	Full control
Scalability	Limited to public infra	Highly scalable
Use Case	Open-source, community projects	Enterprise, sensitive/internal projects
Customization	Standardized	Custom features possible
Maintenance	Managed by provider	Requires manual setup/maintenance
Data Storage	External servers	On-premise or dedicated infra



---

📚 Understanding Docker Repositories

A repository is a collection of related images tagged with unique identifiers.

Example tags: nginx:1.20, nginx:1.21

🔹 Repository Types:

1. Local - Stored on your local machine


2. Remote - Stored in Docker Hub or a private registry




---

🔍 Working with Local Images

View all local images:

docker images

Filter by repository name:

docker images nginx


---

🏷️ Tagging and Retagging Images

Tag an image:

docker tag 7e4d58f0e5f3 myrepo/myapp:stable

Retag an existing image:

docker tag myrepo/myapp:stable myrepo/myapp:v2.0


---

🔍 Searching Docker Images

Search public Docker Hub:

docker search nginx

> ❗ Note: Private registries typically do not support CLI search. Use the registry's API instead.




---

🌐 Interacting with Docker Registry API (Using curl)

List all repositories:

curl -X GET https://my-registry.com/v2/_catalog

List all tags for a repository:

curl -X GET https://my-registry.com/v2/my-image/tags/list


---

📥 Pulling Images from a Registry

Pull from Docker Hub or any remote registry:

docker pull nginx:latest


---

🔓 Logout from a Registry

Clear registry authentication:

docker logout <registry-url>

Example:

docker logout


---

✅ Best Practices:

Use private registries for sensitive or proprietary applications.

Use tags effectively to manage different versions.

Automate image build and push with CI/CD.

Secure private registries with TLS and proper access control.

Regularly clean up unused images to save space.



---

