# Dr_Quine - Multi-stage Docker Build
# Lightweight production image with all build tools and development environment

FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Install build essentials and tools
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    nasm \
    git \
    cmake \
    python3 \
    python3-pip \
    cppcheck \
    valgrind \
    gdb \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install norminette for École 42 compliance checking
RUN pip3 install norminette

# Copy project files
COPY . /app

# Create necessary directories
RUN mkdir -p obj output tests

# Set build environment
ENV CC=gcc
ENV CFLAGS="-Wall -Wextra -Werror -std=c11 -O2"
ENV NASM_FLAGS="-f elf64"

# Default target is to show help
CMD ["bash", "-c", "echo 'Dr_Quine Docker Container'; echo ''; echo 'Available commands:'; echo '  make all      - Build all C and Assembly programs'; echo '  make test     - Run all tests'; echo '  make clean    - Clean build artifacts'; echo '  bash          - Interactive shell'; echo ''; bash"]
