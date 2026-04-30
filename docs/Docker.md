# Dr_Quine Docker Setup Guide

This guide explains how to build, run, and test Dr_Quine using Docker.

## Prerequisites

- **Docker** (20.10+): [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose** (1.29+): Usually included with Docker Desktop
- At least 2GB of free disk space

## Quick Start

### Build the Docker Image

```bash
# Build the image (first time only, ~2-3 minutes)
docker build -t dr_quine:latest .

# Or use docker-compose (recommended)
docker-compose build
```

### Run the Container

```bash
# Start interactive shell
docker-compose run dr-quine

# Or without docker-compose
docker run -it --rm -v $(pwd):/app dr_quine:latest bash
```

### Compile and Test

Inside the container:

```bash
# Build all programs (C and Assembly)
make all

# Run tests
make test

# Run quality checks
bash scripts/check_all.sh

# Clean
make fclean
```

## Docker Commands

### Build

```bash
# Build with specific tag
docker build -t dr_quine:v1.0 .

# Build without cache
docker build --no-cache -t dr_quine:latest .
```

### Run

```bash
# Interactive shell
docker run -it --rm dr_quine:latest bash

# Execute single command
docker run --rm dr_quine:latest make test

# Mount current directory
docker run -it --rm -v $(pwd):/app dr_quine:latest bash

# Custom working directory
docker run -it --rm -w /app -v $(pwd):/app dr_quine:latest bash
```

### Volume Management

```bash
# Mount source code
-v $(pwd):/app

# Mount specific directory
-v $(pwd)/src:/app/src

# Read-only mount
-v $(pwd):/app:ro

# Named volumes
docker volume create dr_quine_data
docker run -v dr_quine_data:/app/obj ...
```

### Environment Variables

```bash
# Set compiler flags
docker run -e CC=gcc -e CFLAGS="-Wall -Wextra" ...

# Pass multiple variables
docker run -e DEBUG=1 -e VERBOSE=1 ...
```

## Docker Compose

### Services

#### 1. Standard Development (dr-quine)

```yaml
services:
  dr-quine:        # Main service with optimization flags
```

Usage:
```bash
docker-compose run dr-quine
docker-compose run dr-quine make all
docker-compose run dr-quine make test
```

#### 2. Development with Debugging (dr-quine-dev)

```bash
# Use development profile
docker-compose --profile dev run dr-quine-dev

# Debug with GDB
docker-compose --profile dev run dr-quine-dev gdb ./Colleen
```

### Common Docker Compose Commands

```bash
# Start service
docker-compose run dr-quine bash

# Build and run
docker-compose up --build

# Execute command
docker-compose run dr-quine make test

# View logs
docker-compose logs -f

# Clean up
docker-compose down
docker-compose down -v  # Remove volumes too
```

## Testing Workflow

### Full Test Suite

```bash
# Start container
docker-compose run dr-quine

# Inside container:
cd /app
make clean
make all
make test
bash scripts/check_all.sh
```

### Individual Tests

```bash
# Test Colleen (C)
./Colleen > test_out.c
diff test_out.c src/colleen.c && echo "✓ PASS" || echo "✗ FAIL"

# Test Grace (C)
./Grace
diff Grace_kid.c src/grace.c && echo "✓ PASS" || echo "✗ FAIL"

# Test Sully (C)
./Sully
ls Sully_*.c | wc -l  # Should show 1 file

# Test Python Bonus
python3 bonus/quine.py
python3 bonus/quine.py grace
python3 bonus/quine.py sully 3
```

### Quality Checks

```bash
# Norminette (École 42 norm)
norminette src/*.c

# Static analysis
cppcheck --enable=all --std=c11 -Ihdr src/

# Valgrind (memory check)
valgrind --leak-check=full ./Colleen > /dev/null
```

## Troubleshooting

### Container won't start

```bash
# Check image exists
docker images | grep dr_quine

# Rebuild image
docker-compose build --no-cache

# Check Docker daemon
docker ps
```

### Permission denied

```bash
# Run with user flag (if needed)
docker run --user $(id -u):$(id -g) ...

# Or use sudo
sudo docker-compose run dr-quine
```

### Changes not reflected

```bash
# Mount volumes correctly
docker run -v $(pwd):/app:rw ...

# Rebuild if Dockerfile changed
docker-compose build --no-cache

# Clear build artifacts inside container
make fclean
```

### Out of disk space

```bash
# Clean up unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Check disk usage
docker system df
```

## Performance Tips

### Faster Builds

```bash
# Use BuildKit for faster builds
DOCKER_BUILDKIT=1 docker build -t dr_quine .

# Use build cache
docker build -t dr_quine . (cache is used automatically)

# Parallel compilation
make -j4  # Inside container
```

### Reduce Image Size

The current image is ~800MB. To reduce:

```dockerfile
# Use lighter base image
FROM ubuntu:22.04-slim

# Or Alpine (much smaller but different tools)
FROM alpine:latest
```

## Production Deployment

### Create production image

```bash
# Multi-stage build (future enhancement)
FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y build-essential gcc nasm
COPY . /app
RUN make all

FROM ubuntu:22.04-slim AS runtime
COPY --from=builder /app/Colleen /app/Grace /app/Sully /usr/local/bin/
CMD ["bash"]
```

### Push to registry

```bash
# Tag image
docker tag dr_quine:latest myregistry/dr_quine:latest

# Login to registry
docker login myregistry

# Push
docker push myregistry/dr_quine:latest
```

## Security

### Run as non-root (optional)

```dockerfile
RUN useradd -m builder
USER builder
```

### Network isolation

```bash
docker run --network none dr_quine:latest
```

### Read-only filesystem

```bash
docker run --read-only -v /tmp --tmpfs /tmp dr_quine:latest
```

## Useful Links

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Security Best Practices](https://docs.docker.com/engine/security/)

---

**Last Updated:** 2026-05-01  
**Docker Version:** Tested with 20.10+  
**Compose Version:** Tested with 1.29+
