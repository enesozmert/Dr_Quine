# Dr_Quine — Komut Rehberi (İndeks)

Bu dizin, Dr_Quine projesinde her aracın **Windows / Linux / macOS** için nasıl çalıştırılacağını içerir.

> ⚠️ **Önemli:** Assembly kaynakları **x86-64 Linux** için yazılmıştır (NASM + ELF64 + libc/syscall). Windows/macOS'ta ASM tarafı yalnız **Docker** veya **WSL2** ile çalıştırılabilir. C ve bonus yerel olarak her üç OS'ta çalışır.

---

## 📚 Bölümler

| # | Belge | İçerik |
|---|-------|--------|
| 1 | [Norminette.md](Norminette.md) | École 42 norm denetimi (3 OS için kurulum + çalıştırma) |
| 2 | [Cppcheck.md](Cppcheck.md) | MISRA C:2012 statik analizi (3 OS) |
| 3 | [CMake.md](CMake.md) | CMake ile derleme (3 OS, ASM Linux-only) |
| 4 | [Makefile.md](Makefile.md) | Make ile derleme (kök + C/ + ASM/ bağımsız Makefile'lar) |
| 5 | [Bonus.md](Bonus.md) | Python bonus çalıştırma (3 OS, tamamen taşınabilir) |
| 6 | [Examples.md](Examples.md) | **PDF spec'in birebir örnekleri** (Colleen/Grace/Sully) — 4 ortam |
| 7 | [Windows_Workflow.md](Windows_Workflow.md) | Windows için adım-adım Ninja akışı |

---

## 🚀 Hızlı Başlangıç (Önerilen Sıra)

1. **Ortamı hazırla** — bkz. her belgenin "Kurulum" bölümü
2. **Norminette** çalıştır → norm uyumluluğunu kontrol et
3. **Cppcheck** çalıştır → statik analiz hata kontrolü
4. **Build et** (CMake veya Makefile)
5. **Test et** — `bash tests/test_quines.sh`
6. **Bonus** doğrula

---

## 📊 OS Uyumluluk Özeti

| Görev | Linux | macOS | Windows |
|-------|-------|-------|---------|
| **Norminette** | ✅ pip | ✅ pip | ⚠️ WSL/Docker |
| **Cppcheck** | ✅ apt | ✅ brew | ✅ choco |
| **CMake build (C)** | ✅ | ✅ | ✅ MinGW |
| **CMake build (ASM)** | ✅ | ⚠️ Docker | ⚠️ Docker |
| **Makefile (C)** | ✅ | ✅ | ✅ MSYS2 |
| **Makefile (ASM)** | ✅ | ⚠️ Docker | ⚠️ Docker |
| **Bonus (Python)** | ✅ | ✅ | ✅ |

**Legend:** ✅ yerel çalışır · ⚠️ Docker/WSL gerekir

---

## 🐳 Tüm Süreci Tek Komutta (Docker)

Üç OS için en güvenilir yol — Docker imajı tüm araçları içerir:

```bash
# 1) Build image (bir kez)
docker build -f docker/Dockerfile -t dr_quine:latest .

# 2) Tüm doğrulama akışını çalıştır
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app && \
    norminette C/*.c ; \
    cppcheck --enable=warning --std=c99 --quiet C/ ; \
    make fclean && make all && \
    bash tests/test_quines.sh ; \
    cd bonus && python3 quine.py | diff - quine.py && echo '✓ Bonus OK'
"
```

Bu komut tek seferde norm + cppcheck + build + PDF testleri + bonus doğrulaması yapar.

---

## 🧭 Detay Belgelere Yönlendirme

Her bir araç için **OS-spesifik kurulum komutları**, **örnek çağrılar** ve **beklenen çıktı** ilgili belgede mevcuttur:

- 🔍 Norm denetimi → [Norminette.md](Norminette.md)
- 🛡️ Statik analiz → [Cppcheck.md](Cppcheck.md)
- 🔨 CMake derleme → [CMake.md](CMake.md)
- 🛠️ Make derleme → [Makefile.md](Makefile.md)
- 🐍 Python bonus → [Bonus.md](Bonus.md)

---

**Son güncelleme:** 2026-05-01
**Hedef ortam:** x86-64 Linux (ASM); C ve bonus 3 OS taşınabilir
