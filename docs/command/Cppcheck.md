# 2. Cppcheck — MISRA C:2012 Statik Analiz

Cppcheck, MISRA C:2012 kurallarına göre derinlemesine statik analiz yapan bir araçtır.

---

## 🐧 Linux

### Kurulum
```bash
sudo apt update && sudo apt install -y cppcheck
cppcheck --version  # >= 2.7 önerilir
```

### Çalıştırma
```bash
cd /path/to/Dr_Quine

# Hızlı denetim (warning seviyesi)
cppcheck --enable=warning --std=c99 --quiet C/

# Tüm kurallar (style + unused dahil)
cppcheck --enable=all --inconclusive --std=c99 --quiet \
    --suppress=missingIncludeSystem --suppress=unusedFunction C/

# MISRA C:2012 modu (cppcheck'in misra add-on'u ile)
cppcheck --addon=misra --std=c99 C/
```

---

## 🍎 macOS

### Kurulum
```bash
brew install cppcheck
cppcheck --version
```

### Çalıştırma
Linux ile aynı (yukarıdaki komutlar).

---

## 🪟 Windows

### Kurulum
```powershell
# Chocolatey (önerilen)
choco install cppcheck

# veya direkt indir:
# https://cppcheck.sourceforge.io/  -> Windows installer

cppcheck --version
```

### Çalıştırma (PowerShell veya Git Bash)
```bash
cd C:\Users\<user>\Desktop\Ecole42\Dr_Quine
cppcheck --enable=warning --std=c99 --quiet C\
```

---

## Beklenen Çıktı

Quine kodunda `%%` (escaped %) ve `%c` placeholder kullanıldığı için cppcheck `format string parameter mismatch` **false positive**'leri verir. Bunlar dokümante edilmiştir, gerçek hata değildir.

```
C/Grace.c:6:1: error: fprintf format string requires 13 parameters but only 9 are given. [wrongPrintfScanfArgNum]
                                                ↑ false positive (quine %% literal text)
```

`--enable=warning` modunda temiz bir çıktı beklenir.

---

## MISRA C:2012 Add-on Detayları

Cppcheck'in MISRA add-on'u standart kurallar yerine MISRA gereksinimlerine göre denetim yapar. Çoğu MISRA-uyumsuzluğu quine yapısının doğal sonucudur (uzun fonksiyonlar, format string trick'leri).

```bash
cppcheck --addon=misra --std=c99 --quiet C/
```

---

## İlgili Dokümantasyon
- [CPPCHECK-MISRA-C2012.md](../cppcheck/CPPCHECK-MISRA-C2012.md) — MISRA kuralları detayı
- [Command.md](Command.md) — Tüm komutların indeksi
