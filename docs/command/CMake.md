# 3. CMake ile Derleme

CMake çok platformlu build sistemi. Tek bir `CMakeLists.txt` ile her üç OS için Makefile/Ninja/Visual Studio projesi üretilebilir.

> ⚠️ **Önemli not:** Assembly kaynakları **x86-64 Linux** için yazılmıştır (NASM + ELF64 + libc/syscall). Windows ve macOS'ta ASM tarafı yalnız Docker veya WSL2 ile çalıştırılabilir.

---

## 🐧 Linux

### Kurulum
```bash
sudo apt update && sudo apt install -y cmake build-essential nasm
cmake --version  # >= 3.10
```

### Derleme
```bash
cd /path/to/Dr_Quine

# 1) Build dizini oluştur ve konfigure et
mkdir -p build && cd build
cmake ..

# 2) Derle (paralel)
cmake --build . --parallel $(nproc)

# 3) Çıktıları kontrol et
ls ../output/C/    # Colleen, Grace, Sully + .c kopyaları
ls ../output/ASM/  # colleen, grace, sully + .s kopyaları

# 4) Test (opsiyonel)
cd .. && bash tests/test_quines.sh
```

---

## 🍎 macOS

### Kurulum
```bash
brew install cmake nasm
xcode-select --install  # gcc/clang araçları
```

### Derleme
ASM target'ı yalnız Linux'ta çalışır. macOS'ta sadece C tarafı derlenir:

```bash
cd /path/to/Dr_Quine
mkdir -p build && cd build
cmake ..
cmake --build . --target c --parallel    # Sadece C: Colleen, Grace, Sully
```

ASM denemek için Docker:
```bash
docker run --rm -v "$(pwd)":/app dr_quine:latest bash -c \
    "cd /app && mkdir -p build && cd build && cmake .. && cmake --build ."
```

---

## 🪟 Windows

> **NASM Windows'ta gerekmez** — proje `CMakeLists.txt` Windows'ta ASM hedefini otomatik atlar (`BUILD_ASM=FALSE`). Yalnızca C kısmı yerel olarak derlenir.

### Kurulum
```powershell
# Chocolatey (önerilen)
choco install cmake mingw

# NASM'e gerek YOK Windows'ta
```

### C Derleme (PowerShell veya CMD)
```powershell
cd C:\Users\<user>\Desktop\Ecole42\Dr_Quine
mkdir build
cd build

# 1) Configure (NASM aranmaz - Windows'ta ASM atlanır)
cmake -G "MinGW Makefiles" ..

# 2) Build — `c` aggregate target veya tek tek hedefler
cmake --build . --target c
# veya tek tek:
cmake --build . --target Colleen
cmake --build . --target Grace
cmake --build . --target Sully

# 3) Çıktıları kontrol et
dir ..\output\C
```

### Beklenen Configure Çıktısı (Windows)
```
-- The C compiler identification is GNU 6.3.0
-- Non-Linux platform — ASM targets disabled (use Docker)
-- Configuring done
-- Generating done
```

### ASM Dahil Tam Derleme — Docker Gerekli
```bash
# Git Bash
docker build -f docker/Dockerfile -t dr_quine:latest .
docker run --rm -v "${PWD}:/app" dr_quine:latest bash -c \
    "cd /app && mkdir -p build && cd build && cmake .. && cmake --build ."
```

### Sık Karşılaşılan Hatalar

**`No CMAKE_ASM_NASM_COMPILER could be found`**
- Eski `CMakeLists.txt` (project'i `C ASM_NASM` olarak tanımlıyorsa) NASM'i her platformda zorunlu kılar.
- **Çözüm:** Bu projede zaten düzeltilmiş. Yine alıyorsan repo köküne `git pull` yap.

**`mingw32-make.exe: Makefile: No such file or directory`**
- Configure başarısız olduğu için Makefile üretilmedi. Önceki configure hatasını çöz, sonra `cmake --build` çalıştır.

**`No rule to make target 'C:/Users/Enes Ã-zmert/...'`** (Türkçe/Unicode karakter sorunu)
- Klasör yolunda non-ASCII karakter (Ö, Ü, Ç, Ğ, İ, Ş) varsa `mingw32-make` UTF-8 yolu çözemez.
- **Çözüm A — Ninja kullan (en kolay):**
  ```powershell
  choco install ninja
  rmdir /S /Q build && mkdir build && cd build
  cmake -G "Ninja" ..
  cmake --build . --target c
  ```
- **Çözüm B — Console UTF-8:**
  ```powershell
  chcp 65001
  cmake -G "MinGW Makefiles" ..
  cmake --build . --target c
  ```
- **Çözüm C — ASCII path:**
  Projeyi `C:\dev\Dr_Quine` gibi non-Türkçe bir yola taşı.

---

## Beklenen Çıktı

```
output/
├── C/
│   ├── Colleen, Grace, Sully       # binary'ler
│   └── Colleen.c, Grace.c, Sully.c # kaynak kopyalar (test için)
└── ASM/
    ├── colleen, grace, sully       # binary'ler (Linux only)
    └── Colleen.s, Grace.s, Sully.s
```

Build çıktısı:
```
[ 14%] Building C object CMakeFiles/Colleen.dir/C/Colleen.c.o
[ 28%] Linking C executable ../output/C/Colleen
[ 28%] Built target Colleen
...
[100%] Building Assembly quines via ASM/Makefile
[100%] Built target asm
```

---

## CMake Hedefleri

| Target | Açıklama |
|--------|----------|
| `Colleen`, `Grace`, `Sully` | C versiyonları (her biri ayrı) |
| `c` | Tüm C versiyonları |
| `asm` | Tüm ASM versiyonları (Linux only) |
| `all_quines` | C + ASM birleşik |
| `norm` | Norminette çağrısı |
| `cppcheck` | Statik analiz |
| `test_quines` | Test takımı |

---

## İlgili Dokümantasyon
- [Makefile.md](Makefile.md) — Alternatif: doğrudan Make ile derleme
- [Command.md](Command.md) — Tüm komutların indeksi
