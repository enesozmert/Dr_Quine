# 4. Makefile ile Derleme

Proje, École 42 standartlarına uygun **bağımsız** Makefile'lara sahiptir: kök Makefile + `C/Makefile` + `ASM/Makefile`.

> ⚠️ **Önemli not:** ASM hedefi yalnız Linux'ta yerel çalışır. Windows/macOS için Docker önerilir.

---

## 🐧 Linux

### Kurulum
```bash
sudo apt update && sudo apt install -y build-essential nasm gcc
make --version
```

### Hedefler
```bash
cd /path/to/Dr_Quine

make all          # C + ASM tüm hedefleri build eder -> output/C, output/ASM
make c            # Yalnız C: output/C/{Colleen,Grace,Sully}
make asm          # Yalnız ASM: output/ASM/{colleen,grace,sully}
make test         # Test takımı (test_quines.sh)
make clean        # .o dosyaları
make fclean       # output/ dahil tüm üretilen dosyalar
make re           # fclean + all
make help         # Tüm hedeflerin listesi
```

### Tek Başına Klasörde Derleme
```bash
cd C && make             # output/C/'ye build eder
cd ../ASM && make        # output/ASM/'ye build eder
```

---

## 🍎 macOS

### Kurulum
```bash
xcode-select --install   # make + clang
brew install nasm        # ASM için (yalnız C kullanılacaksa gerekmez)
```

### Çalıştırma
```bash
make c           # ✓ macOS'ta çalışır
make asm         # ✗ NASM elf64 Linux'a özel — Docker kullan
```

---

## 🪟 Windows

> Windows'ta `make` ve POSIX shell gerekir. **Git Bash** veya **MSYS2** kullan.

### Kurulum (MSYS2)
```powershell
# Chocolatey
choco install msys2
```

MSYS2 terminalinde:
```bash
pacman -S make mingw-w64-x86_64-gcc nasm
```

### C-only Build
```bash
cd /c/Users/<user>/Desktop/Ecole42/Dr_Quine
make c           # ✓ MinGW gcc ile derlenir
```

### ASM Build — Docker
```bash
# Git Bash
docker run --rm -v "${PWD}:/app" dr_quine:latest make all
```

---

## Beklenen Çıktı

```
$ make all
═══════════════════════════════════════════════════════
Building C Quine Programs...
═══════════════════════════════════════════════════════
gcc -Wall -Wextra -Werror -O2 -Wno-format-security -c Colleen.c
gcc -Wall -Wextra -Werror -O2 -Wno-format-security -o ../output/C/Colleen Colleen.o
...
═══════════════════════════════════════════════════════
[✓] All quine programs built successfully
═══════════════════════════════════════════════════════
```

---

## École 42 Standart Hedefleri

Her Makefile şu standart hedefleri içerir:

| Target | Davranış |
|--------|----------|
| `all` | Default; binary'leri üretir |
| `clean` | `.o` ve geçici dosyaları siler |
| `fclean` | `clean` + binary'ler ve runtime dosyaları |
| `re` | `fclean` + `all` |

`Makefile`'lar:
- Kök: `Makefile` — `C/` ve `ASM/`'a delegate
- `C/Makefile` — bağımsız C derleyici
- `ASM/Makefile` — bağımsız NASM + linker

---

## İlgili Dokümantasyon
- [CMake.md](CMake.md) — Alternatif: CMake ile derleme
- [Command.md](Command.md) — Tüm komutların indeksi
