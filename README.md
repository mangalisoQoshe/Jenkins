# Running Jenkins with Side-by-Side Docker Agents

Instead of running Docker-in-Docker (DinD), this setup uses the **Docker-out-of-Docker** pattern by mounting the host's Docker socket and binary. This allows Jenkins to create sibling containers on the host rather than nested containers, which is more secure, performant, and reliable than DinD.


## Before Running Docker Compose

1. **Find your host's Docker group ID:**
```bash
   getent group docker | cut -d: -f3
```

2. **Update the `DOCKER_GID` variable:**
   - Set `DOCKER_GID` to the value from step 1
   

## Running Jenkins
```bash
# Build the custom Jenkins image
docker-compose build

# Start Jenkins
docker-compose up -d

# View logs
docker-compose logs -f jenkins
```

## Accessing Jenkins

- Jenkins UI: `http://localhost:8080`
- Get initial admin password:
```bash
  docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## How It Works

Jenkins runs in a container with:
- **Docker socket mounted** (`/var/run/docker.sock`) - allows Jenkins to communicate with the host's Docker daemon
- **Docker binary mounted** - provides the `docker` CLI command inside the container
- **Correct group permissions** - Jenkins user is added to the docker group with the host's GID

When Jenkins builds Docker images or runs containers, they appear as siblings on the host, not inside the Jenkins container.
