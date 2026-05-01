# 1. Norminette — École 42 Norm Kontrolü

Norminette, École 42'nin C kodu için resmi norm denetleyicisidir. Python ile yazılmış ve `pip` üzerinden kurulur.

---

## 🐧 Linux

### Kurulum
```bash
# Python3 ve pip
sudo apt update && sudo apt install -y python3 python3-pip

# Norminette
pip3 install --user norminette

# PATH'e ekle (gerekirse)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Sürüm kontrolü
norminette --version
```

### Çalıştırma
```bash
cd /path/to/Dr_Quine
norminette C/Colleen.c C/Grace.c C/Sully.c
# veya tümü:
norminette C/*.c
```

---

## 🍎 macOS

### Kurulum
```bash
# Homebrew ile Python (zaten kurulu olabilir)
brew install python3

# Norminette
pip3 install norminette

# Sürüm kontrolü
norminette --version
```

### Çalıştırma
```bash
cd /path/to/Dr_Quine
norminette C/*.c
```

---

## 🪟 Windows

> **Norminette Windows'ta resmi olarak desteklenmez.** İki seçenek var:

### Seçenek A — WSL2 (önerilen)
```powershell
# PowerShell (Yönetici)
wsl --install -d Ubuntu
```
Sonra Ubuntu içinde [Linux talimatlarını](#-linux) izle.

### Seçenek B — Docker (proje hazır image içerir)
```bash
# Git Bash veya PowerShell
docker build -f docker/Dockerfile -t dr_quine:latest .
docker run --rm -v "${PWD}:/app" dr_quine:latest norminette C/*.c
```

---

## Beklenen Çıktı

Quine programları yapısal olarak `LINE_TOO_LONG` ve `TOO_MANY_LINES` uyarıları üretir (uzun format string + tek main mantığı). Bu uyarılar **kabul edilen trade-off**'tur.

```
Colleen.c: Error!
Error: LINE_TOO_LONG     (line: 4, col: 80):  line too long
Error: TOO_MANY_LINES    (line: 5, col: 1):   Function has more than 25 lines
```

---

## İlgili Dokümantasyon
- [NORMCHECK.md](../normcheck/NORMCHECK.md) — Norm uyumluluk detayları
- [Command.md](Command.md) — Tüm komutların indeksi
