# 5. Bonus (Python) Çalıştırma

Bonus, üç quine'in Python implementasyonunu içerir: `bonus/quine.py`. Python 3.7+ tüm OS'larda yerel olarak çalışır.

---

## 🐧 Linux

### Kurulum
```bash
sudo apt update && sudo apt install -y python3
python3 --version  # >= 3.7
```

### Çalıştırma
```bash
cd /path/to/Dr_Quine/bonus

# Colleen varyantı (varsayılan): stdout'a kaynağı yazar
python3 quine.py
python3 quine.py | diff - quine.py    # farksız olmalı

# Grace varyantı: grace_kid.py dosyası yazar
python3 quine.py grace
diff quine.py grace_kid.py

# Sully varyantı: sayaç ile zincir oluşturur
python3 quine.py sully 3              # sully_2.py oluşturur (counter=2)
ls sully_*.py
```

---

## 🍎 macOS

### Kurulum
```bash
# macOS'ta Python3 genellikle önyüklenmiş
brew install python3
python3 --version
```

### Çalıştırma
Linux ile aynı.

---

## 🪟 Windows

### Kurulum
```powershell
# Microsoft Store (önerilen) veya:
choco install python
python --version  # 3.x
```

### Çalıştırma (PowerShell veya Git Bash)
```powershell
cd C:\Users\<user>\Desktop\Ecole42\Dr_Quine\bonus

# Windows'ta `python3` yerine `python` kullan
python quine.py
python quine.py grace
python quine.py sully 3
```

---

## Beklenen Çıktı

```
$ python3 quine.py grace
$ diff quine.py grace_kid.py
$                            # ← çıktı yok = başarılı
```

---

## Üç Varyant Karşılaştırması

| Komut | Davranış | Çıktı |
|-------|----------|-------|
| `python3 quine.py` | Colleen — stdout'a yazar | stdout |
| `python3 quine.py grace` | Grace — dosyaya yazar | `grace_kid.py` |
| `python3 quine.py sully N` | Sully — N sayaçlı zincir | `sully_<N-1>.py` ... |

---

## Hızlı Doğrulama (3 OS)

```bash
# Linux/macOS
python3 quine.py | diff - quine.py && echo '✓ Colleen OK'
python3 quine.py grace && diff quine.py grace_kid.py && echo '✓ Grace OK'
python3 quine.py sully 3 && [ -f sully_2.py ] && echo '✓ Sully OK'

# Windows (PowerShell)
python quine.py | diff - quine.py
```

---

## İlgili Dokümantasyon
- [bonus/README.md](../../bonus/README.md) — Python implementasyon detayı
- [Command.md](Command.md) — Tüm komutların indeksi
