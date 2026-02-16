# Running Jenkins with Docker Agents

Instead of running Docker-in-Docker (DnD), this setup uses the **Docker-out-of-Docker** pattern by mounting the host's Docker socket and binary. This allows Jenkins to create sibling containers on the host rather than nested containers, which is more secure, performant, and reliable than DnD.

To improve security and isolation, builds run on a dedicated Docker agent container rather than on the Jenkins controller node.

## Architecture

- **Jenkins Controller**: Manages the Jenkins instance, schedules jobs, and serves the UI
- **Jenkins Agent**: Executes build jobs in an isolated container
- **Docker Socket**: Both controller and agent share the host's Docker daemon to build and run containers

## Prerequisites

- Docker and Docker Compose installed on the host
- Host Docker daemon running

## Setup

1. **Extract the host's Docker group ID:**
```bash
   getent group docker | cut -d: -f3
```

2. **Create a `.env` file with the following variables:**
```bash
   DOCKER_GID=984  # Replace with your Docker group ID from step 1
   JENKINS_SECRET=  # Leave empty for now, will be filled after first run
```

3. **Start Jenkins controller:**
```bash
   docker-compose up
```

4. **Get the initial admin password:**
```bash
   docker-compose exec jenkins-service cat /var/jenkins_home/secrets/initialAdminPassword
```

5. **Configure the agent in Jenkins UI:**
   - Go to: **Manage Jenkins → Nodes → New Node**
   - Name: `agentX` (must match the container name)
   - Type: **Permanent Agent**
   - Remote root directory: `/home/jenkins/agent`
   - Launch method: **Launch agent by connecting it to the controller**
   - Copy the **secret** that appears

6. **Update `.env` with the agent secret:**
```bash
   DOCKER_GID=984
   JENKINS_SECRET=your_secret_from_jenkins_ui
```

7. **Start the agent:**
```bash
   docker-compose up -d jenkins-agent
```

