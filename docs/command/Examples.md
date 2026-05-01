# Dr_Quine — PDF Spec Examples (4 Environments)

This document reproduces the **exact PDF specification examples** for each
mandatory program (Colleen, Grace, Sully) and shows how to run them on
**Linux 🐧 / macOS 🍎 / Windows 🪟 / Docker 🐳**.

> 🔖 Source: `docs/main/en.subject.pdf` Chapter V — Mandatory Part

---

## Program #1 — Colleen

> "When executed, the program must display on the standard output an output
> identical to the source code of the file used to compile the program."

### 📄 PDF Reference Commands (Linux)

**C example:**
```bash
$> ls -al
total 12
drwxr-xr-x 2 root root 4096 Feb 2 13:26 .
drwxr-xr-x 4 root root 4096 Feb 2 13:26 ..
-rw-r--r-- 1 root root 647 Feb 2 13:26 Colleen.c

$> clang -Wall -Wextra -Werror -o Colleen Colleen.c; ./Colleen > tmp_Colleen ; diff tmp_Colleen Colleen.c
$>             # ← no output = success (byte-identical)
```

**Assembly example:**
```bash
$> ls -al
total 12
-rw-r--r-- 1 root root 712 Feb 2 13:26 Colleen.s

$> nasm -f elf64 Colleen.s -o Colleen.o && gcc Colleen.o -o Colleen
$> ./Colleen > tmp_Colleen ; diff tmp_Colleen Colleen.s
$>             # ← no output = success
```

---

### 🐧 Linux

**C version:**
```bash
cd /path/to/Dr_Quine/C
clang -Wall -Wextra -Werror -Wno-format-security -o Colleen Colleen.c
./Colleen > tmp_Colleen
diff tmp_Colleen Colleen.c   # → empty output = PASS
rm tmp_Colleen
```

**Assembly version:**
```bash
cd /path/to/Dr_Quine/ASM
nasm -f elf64 Colleen.s -o Colleen.o && ld Colleen.o -o colleen
./colleen > tmp_Colleen
diff tmp_Colleen Colleen.s   # → empty output = PASS
rm tmp_Colleen
```

> 💡 Project's Makefile/CMake builds binaries into `output/C/` and `output/ASM/`. If you want to follow PDF's exact pattern, build manually inside `C/` or `ASM/` as above.

---

### 🍎 macOS

**C version:** (same as Linux, clang is the default)
```bash
cd /path/to/Dr_Quine/C
clang -Wall -Wextra -Werror -Wno-format-security -o Colleen Colleen.c
./Colleen > tmp_Colleen
diff tmp_Colleen Colleen.c   # → empty output = PASS
```

**Assembly version:** ⚠️ macOS uses Mach-O (not ELF) and a different ABI.
```bash
# NASM for macOS produces Mach-O, not ELF. Use Docker for ASM testing:
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c \
    "cd /app/ASM && nasm -f elf64 Colleen.s -o Colleen.o && ld Colleen.o -o colleen && ./colleen > /tmp/out && diff /tmp/out Colleen.s"
```

---

### 🪟 Windows (PowerShell + Git Bash)

**C version:** (use `gcc` from MinGW)
```powershell
cd "C:\Users\Enes Özmert\Desktop\Ecole42\Dr_Quine\C"

# Build (gcc instead of clang on Windows)
gcc -Wall -Wextra -Werror -Wno-format-security -o Colleen.exe Colleen.c

# Run + diff (use Git Bash for diff command)
.\Colleen.exe > tmp_Colleen
& "C:\Program Files\Git\bin\diff.exe" tmp_Colleen Colleen.c   # → empty = PASS
Remove-Item tmp_Colleen
```

**Or via the project's CMake build:**
```powershell
cd "C:\Users\Enes Özmert\Desktop\Ecole42\Dr_Quine\build"
cmake --build . --target c
cd ..\output\C
.\Colleen.exe > tmp_Colleen
& "C:\Program Files\Git\bin\diff.exe" tmp_Colleen Colleen.c
```

**Assembly version:** ❌ NASM ELF64 + Linux syscalls don't work on Windows natively. Use Docker (see below).

---

### 🐳 Docker (works for all 3 mandatory programs incl. ASM)

**Build the project image once:**
```bash
docker build -f docker/Dockerfile -t dr_quine:latest .
```

**Reproduce PDF Colleen examples:**
```bash
# C version
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app/C && \
    clang -Wall -Wextra -Werror -Wno-format-security -o Colleen Colleen.c && \
    ./Colleen > /tmp/tmp_Colleen && \
    diff /tmp/tmp_Colleen Colleen.c && \
    echo '✓ Colleen C identical'
"

# Assembly version
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app/ASM && \
    nasm -f elf64 Colleen.s -o Colleen.o && \
    ld Colleen.o -o colleen && \
    ./colleen > /tmp/tmp_Colleen && \
    diff /tmp/tmp_Colleen Colleen.s && \
    echo '✓ Colleen ASM identical'
"
```

---

## Program #2 — Grace

> "When executed, the program writes in a file named Grace_kid.c / Grace_kid.s
> the source code of the file used to compile the program."

### 📄 PDF Reference Commands (Linux)

**C example:**
```bash
$> ls -al
total 12
-rw-r--r-- 1 root root 362 Feb 2 13:30 Grace.c

$> clang -Wall -Wextra -Werror -o Grace Grace.c; ./Grace ; diff Grace.c Grace_kid.c
$> ls -al
total 24
-rwxr-xr-x 1 root root 7240 Feb 2 13:30 Grace
-rw-r--r-- 1 root root 362 Feb 2 13:30 Grace.c
-rw-r--r-- 1 root root 362 Feb 2 13:30 Grace_kid.c   # ← created, identical
```

**Assembly example:**
```bash
$> nasm -f elf64 Grace.s -o Grace.o && gcc Grace.o -o Grace
$> rm -f Grace_kid.s ; ./Grace ; diff Grace_kid.s Grace.s
$> ls -al
-rwxr-xr-x 1 root root 7240 Feb 2 13:30 Grace
-rw-r--r-- 1 root root 388 Feb 2 13:30 Grace.s
-rw-r--r-- 1 root root 388 Feb 2 13:30 Grace_kid.s
```

---

### 🐧 Linux

**C version:**
```bash
cd /path/to/Dr_Quine/C
clang -Wall -Wextra -Werror -Wno-format-security -o Grace Grace.c
rm -f Grace_kid.c
./Grace
diff Grace.c Grace_kid.c   # → empty = PASS
ls -al Grace*
```

**Assembly version:**
```bash
cd /path/to/Dr_Quine/ASM
nasm -f elf64 Grace.s -o Grace.o && ld Grace.o -o grace
rm -f Grace_kid.s
./grace
diff Grace_kid.s Grace.s   # → empty = PASS
ls -al Grace*
```

---

### 🍎 macOS

**C version:**
```bash
cd /path/to/Dr_Quine/C
clang -Wall -Wextra -Werror -Wno-format-security -o Grace Grace.c
rm -f Grace_kid.c
./Grace
diff Grace.c Grace_kid.c   # → empty = PASS
```

**Assembly version:** ⚠️ Same as Colleen — use Docker.

---

### 🪟 Windows (PowerShell + Git Bash)

**C version:**
```powershell
cd "C:\Users\Enes Özmert\Desktop\Ecole42\Dr_Quine\C"

# Build
gcc -Wall -Wextra -Werror -Wno-format-security -o Grace.exe Grace.c

# Cleanup + run + diff
Remove-Item -ErrorAction SilentlyContinue Grace_kid.c
.\Grace.exe
& "C:\Program Files\Git\bin\diff.exe" Grace.c Grace_kid.c   # → empty = PASS
Get-ChildItem Grace*
```

**Or via CMake:**
```powershell
cd "C:\Users\Enes Özmert\Desktop\Ecole42\Dr_Quine\build"
cmake --build . --target c
cd ..\output\C
Remove-Item -ErrorAction SilentlyContinue Grace_kid.c
.\Grace.exe
& "C:\Program Files\Git\bin\diff.exe" Grace.c Grace_kid.c
```

**Assembly version:** ❌ Use Docker.

---

### 🐳 Docker

```bash
# C version (PDF-style)
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app/C && \
    clang -Wall -Wextra -Werror -Wno-format-security -o Grace Grace.c && \
    rm -f Grace_kid.c && \
    ./Grace && \
    diff Grace.c Grace_kid.c && \
    echo '✓ Grace C identical' && \
    ls -al Grace*
"

# Assembly version (PDF-style)
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app/ASM && \
    nasm -f elf64 Grace.s -o Grace.o && \
    ld Grace.o -o grace && \
    rm -f Grace_kid.s && \
    ./grace && \
    diff Grace_kid.s Grace.s && \
    echo '✓ Grace ASM identical' && \
    ls -al Grace*
"
```

---

## Program #3 — Sully (Bonus: also in PDF spec)

> "When executed the program writes in a file named Sully_X.c / Sully_X.s.
> The X will be an integer given in the source. ... An integer is therefore
> present in the source of your program and will have to evolve by decrementing
> every time you create a source file from the execution of the program."

### 📄 PDF Reference Commands (Linux)

**C example:**
```bash
$> clang -Wall -Wextra -Werror ../Sully.c -o Sully ; ./Sully
$> ls -al | grep Sully | wc -l
13
$> diff ../Sully.c Sully_0.c
1c1
< int i = 5;
---
> int i = 0;
$> diff Sully_3.c Sully_2.c
1c1
< int i = 3;
---
> int i = 2;
```

**Assembly example:**
```bash
$> nasm -f elf64 ../Sully.s -o Sully.o && gcc Sully.o -o Sully
$> ./Sully
$> ls -al | grep Sully | wc -l
13
$> diff ../Sully.s Sully_0.s
1c1
< ;i=5
---
> ;i=0
$> diff Sully_3.s Sully_2.s
1c1
< ;i=3
---
> ;i=2
```

> 💡 PDF runs Sully from a **work directory** with the source in the parent (`../Sully.c`). All `Sully_X.c`/`Sully_X` files end up in the work dir.

---

### 🐧 Linux

**C version (PDF-style with workdir):**
```bash
cd /path/to/Dr_Quine
mkdir -p workdir && cd workdir
rm -rf *
clang -Wall -Wextra -Werror -Wno-format-security ../C/Sully.c -o Sully
./Sully
ls -al | grep Sully | wc -l         # → 13
diff ../C/Sully.c Sully_0.c          # → only 'int i = 5/0' line differs
diff Sully_3.c Sully_2.c             # → only 'int i' line differs
```

**Assembly version:**
```bash
cd /path/to/Dr_Quine
mkdir -p workdir && cd workdir
rm -rf *
cp ../ASM/Sully.s /tmp/sully_self.s
nasm -f elf64 ../ASM/Sully.s -o Sully.o && gcc -no-pie Sully.o -o Sully
./Sully
ls -al | grep Sully | wc -l         # → 13
diff ../ASM/Sully.s Sully_0.s
diff Sully_3.s Sully_2.s
```

---

### 🍎 macOS

**C version:** (same as Linux)

**Assembly version:** ⚠️ Use Docker.

---

### 🪟 Windows (PowerShell + Git Bash)

**C version:**
```powershell
cd "C:\Users\Enes Özmert\Desktop\Ecole42\Dr_Quine"
if (Test-Path workdir) { Remove-Item -Recurse -Force workdir }
mkdir workdir; cd workdir

gcc -Wall -Wextra -Werror -Wno-format-security ..\C\Sully.c -o Sully.exe
.\Sully.exe

# Count files (Git Bash needed for grep|wc)
& "C:\Program Files\Git\bin\bash.exe" -c "ls -al | grep Sully | wc -l"   # → ~13

# Diff
& "C:\Program Files\Git\bin\diff.exe" ..\C\Sully.c Sully_0.c
& "C:\Program Files\Git\bin\diff.exe" Sully_3.c Sully_2.c
```

> 💡 Sully on Windows uses `system("gcc ...")` — needs `gcc.exe` in PATH (MinGW).

**Assembly version:** ❌ Use Docker.

---

### 🐳 Docker (recommended for ASM Sully)

```bash
# C version (PDF-style)
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app && rm -rf /tmp/workdir && mkdir -p /tmp/workdir && cd /tmp/workdir && \
    clang -Wall -Wextra -Werror -Wno-format-security /app/C/Sully.c -o Sully && \
    ./Sully && \
    echo 'count:' && ls -al | grep Sully | wc -l && \
    diff /app/C/Sully.c Sully_0.c && \
    diff Sully_3.c Sully_2.c
"

# Assembly version (PDF-style)
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app && rm -rf /tmp/workdir && mkdir -p /tmp/workdir && cd /tmp/workdir && \
    cp /app/ASM/Sully.s /tmp/sully_self.s && \
    nasm -f elf64 /app/ASM/Sully.s -o Sully.o && \
    gcc -no-pie Sully.o -o Sully && \
    ./Sully && \
    echo 'count:' && ls -al | grep Sully | wc -l && \
    diff /app/ASM/Sully.s Sully_0.s && \
    diff Sully_3.s Sully_2.s
"
```

---

## 📊 Environment Compatibility Matrix

| Program / Env | 🐧 Linux | 🍎 macOS | 🪟 Windows | 🐳 Docker |
|---------------|----------|----------|------------|-----------|
| **Colleen (C)** | ✅ native | ✅ native | ✅ native (gcc) | ✅ |
| **Colleen (ASM)** | ✅ native | ⚠️ Docker | ⚠️ Docker | ✅ |
| **Grace (C)** | ✅ native | ✅ native | ✅ native (gcc) | ✅ |
| **Grace (ASM)** | ✅ native | ⚠️ Docker | ⚠️ Docker | ✅ |
| **Sully (C)** | ✅ native | ✅ native | ✅ native (gcc) | ✅ |
| **Sully (ASM)** | ✅ native | ⚠️ Docker | ⚠️ Docker | ✅ |

**Legend:** ✅ runs locally · ⚠️ requires Docker (NASM elf64 + Linux ABI)

---

## 🎯 PDF-Compliant Tek Komut Doğrulamaları

### Linux / macOS (native shell)
```bash
cd /path/to/Dr_Quine

# Colleen (C)
cd C && clang -Wall -Wextra -Werror -Wno-format-security -o Colleen Colleen.c && \
    ./Colleen > tmp && diff tmp Colleen.c && echo "✓ Colleen C OK" && rm tmp Colleen Colleen.o 2>/dev/null

# Grace (C)
cd ../C && clang -Wall -Wextra -Werror -Wno-format-security -o Grace Grace.c && \
    rm -f Grace_kid.c && ./Grace && diff Grace.c Grace_kid.c && echo "✓ Grace C OK"

# Sully (C) workdir
cd .. && rm -rf workdir && mkdir workdir && cd workdir && \
    clang -Wall -Wextra -Werror -Wno-format-security ../C/Sully.c -o Sully && ./Sully && \
    [ "$(ls -al | grep Sully | wc -l)" = "13" ] && echo "✓ Sully count=13"
```

### Windows (PowerShell + Git Bash)
```powershell
$bash = "C:\Program Files\Git\bin\bash.exe"
& $bash -c "
    cd /c/Users/Enes\ Özmert/Desktop/Ecole42/Dr_Quine && \
    cd C && gcc -Wall -Wextra -Werror -Wno-format-security -o Colleen.exe Colleen.c && \
    ./Colleen.exe > tmp && diff tmp Colleen.c && echo '✓ Colleen C OK'
"
```

### Docker (3 mandatory programs at once)
```bash
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app && \
    cd C && clang -Wno-format-security -Wall -Wextra -Werror -o Colleen Colleen.c && ./Colleen > /tmp/o && diff /tmp/o Colleen.c && echo '✓ Colleen C' && \
    rm -f Grace_kid.c && clang -Wno-format-security -Wall -Wextra -Werror -o Grace Grace.c && ./Grace && diff Grace.c Grace_kid.c && echo '✓ Grace C' && \
    cd /tmp && mkdir -p sw && cd sw && rm -rf * && \
    clang -Wno-format-security -Wall -Wextra -Werror /app/C/Sully.c -o Sully && ./Sully && \
    [ \"\$(ls -al | grep Sully | wc -l)\" = '13' ] && echo '✓ Sully count=13'
"
```

---

## 📌 İlgili Dokümantasyon

- [Command.md](Command.md) — komut indeksi
- [Makefile.md](Makefile.md) — Make ile derleme
- [CMake.md](CMake.md) — CMake ile derleme
- [Windows_Workflow.md](Windows_Workflow.md) — Windows için adım-adım Ninja akışı
- [docs/main/tr.subject.md](../main/tr.subject.md) — PDF spec'in Türkçe çevirisi
