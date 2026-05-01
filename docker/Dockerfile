# ============================================================================
# Dr_Quine - Dockerfile
# Build context: project root
#   Build:  docker build -f docker/Dockerfile -t dr_quine .
#   Run:    docker run -it --rm dr_quine
# ============================================================================

FROM ubuntu:22.04

LABEL maintainer="ozmerte <ozmerte@gmail.com>"
LABEL description="Dr_Quine - Self-Replicating Quine Programs (Ecole 42)"
LABEL version="2.0"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Istanbul

# ============================================================================
# Toolchain: gcc, NASM, make, cmake, python3, norminette, cppcheck, valgrind
# ============================================================================

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    clang \
    make \
    nasm \
    git \
    cmake \
    python3 \
    python3-pip \
    cppcheck \
    valgrind \
    gdb \
    lldb \
    clang-format \
    diffutils \
    coreutils \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir norminette

# ============================================================================
# Project workdir
# ============================================================================

WORKDIR /app

# Copy entire project tree (Makefile, C/, ASM/, tests/, scripts/, docs/, bonus/)
COPY . /app

# Defensive cleanup: remove any host-built artifacts that may have leaked in
RUN find /app/C /app/ASM -type f \( -name "*.o" -o -name "*.exe" \) -delete 2>/dev/null || true && \
    find /app/C -maxdepth 1 -type f -executable ! -name "*.c" ! -name "Makefile" -delete 2>/dev/null || true && \
    find /app/ASM -maxdepth 1 -type f -executable ! -name "*.s" ! -name "Makefile" -delete 2>/dev/null || true

# ============================================================================
# Build env (Ecole 42)
# ============================================================================

ENV CC=gcc
ENV CFLAGS="-Wall -Wextra -Werror -O2"
ENV NASM_FLAGS="-f elf64"

# Sanity: confirm the project builds cleanly inside the image (then clean)
RUN make c && make asm && make fclean

# ============================================================================
# Default entrypoint
# ============================================================================

CMD ["bash", "-c", "echo '== Dr_Quine container ready =='; \
echo ''; \
echo 'Project layout:'; \
echo '  C/   - C quines (Colleen, Grace, Sully)'; \
echo '  ASM/ - x86-64 NASM quines'; \
echo '  tests/   - Automated test suite'; \
echo '  bonus/   - Python bonus implementation'; \
echo ''; \
echo 'Available commands:'; \
echo '  make all       - Build C + Assembly'; \
echo '  make c         - Build C only'; \
echo '  make asm       - Build Assembly only'; \
echo '  make test      - Run all tests'; \
echo '  make norm      - Norminette'; \
echo '  make cppcheck  - Static analysis'; \
echo '  bash scripts/check_all.sh - Full QA pipeline'; \
echo ''; \
exec bash"]
