# Windows — Tam Geliştirme Akışı (CMake + Ninja)

Sırasıyla: **Configure → Norminette → Cppcheck → Build → Test → Onay**

> ⚠️ Path'inde Türkçe karakter (Ö, Ü, Ç...) varsa **mutlaka Ninja kullan**. mingw32-make UTF-8 yollarını çürütür.

---

## 🔧 Tek Seferlik Kurulum (yalnız ilk defa)

```powershell
# Yönetici PowerShell'inde
choco install ninja cmake mingw cppcheck python git -y

# Norminette (Python paketi)
pip install norminette

# Doğrulama
ninja --version
cmake --version
gcc --version
cppcheck --version
norminette --version
python --version
```

---

## 🚀 Her Build Akışı

### 1️⃣ Configure
```powershell
cd "C:\Users\Enes Özmert\Desktop\Ecole42\Dr_Quine"

# Eski build varsa temizle
if (Test-Path build) { Remove-Item -Recurse -Force build }
mkdir build
cd build

# CMake configure (Ninja generator)
cmake -G "Ninja" ..
```

Beklenen çıktı:
```
-- The C compiler identification is GNU x.x.x
-- Non-Linux platform — ASM targets disabled (use Docker)
-- bash: <bulunduysa yol>
-- Configuring done
-- Generating done
```

### 2️⃣ Norminette (norm uyumluluk)
```powershell
cmake --build . --target norm
```

Quine programları yapısal olarak `LINE_TOO_LONG` ve `TOO_MANY_LINES` uyarıları verir — kabul edilen trade-off.

### 3️⃣ Cppcheck (statik analiz)
```powershell
cmake --build . --target cppcheck
```

Beklenen: `[✓] Cppcheck passed (warning level, no critical issues)`

### 4️⃣ Build (derleme)
```powershell
cmake --build . --target c
```

> Windows'ta **yalnız C derlenir** (ASM Linux x86-64'e özgü). Çıktılar: `..\output\C\Colleen.exe`, `Grace.exe`, `Sully.exe`.

### 5️⃣ Test (PDF spec doğrulama)
```powershell
# PDF testleri
cmake --build . --target test_quines

# Crash/error testleri (PDF §IV)
cmake --build . --target test_errors

# Veya tümü tek seferde
cmake --build . --target test_all
```

### 6️⃣ Onay (Final QA)
```powershell
cmake --build . --target qa
```

Bu komut: build + norm + cppcheck + PDF tests + crash tests + relink check'in tamamını yapar.

---

## 🎯 Tek Komutla Tüm Akış (PowerShell)

```powershell
cd "C:\Users\Enes Özmert\Desktop\Ecole42\Dr_Quine"
if (Test-Path build) { Remove-Item -Recurse -Force build }
mkdir build; cd build
cmake -G "Ninja" .. ; `
cmake --build . --target norm ; `
cmake --build . --target cppcheck ; `
cmake --build . --target c ; `
cmake --build . --target test_quines ; `
cmake --build . --target test_errors ; `
Write-Host "✓ Pipeline complete" -ForegroundColor Green
```

---

## 🐳 ASM Tarafını da Test Etmek İçin (opsiyonel — Docker)

Windows'ta NASM yok; ASM tarafını test etmek için Docker:

```powershell
docker build -f docker/Dockerfile -t dr_quine:latest .
docker run --rm -v "${PWD}:/app" dr_quine:latest make qa
```

---

## 🔥 Sık Karşılaşılan Hatalar

### `Enes Ã-zmert` (mojibake / UTF-8 çürümesi)
- **Sebep:** mingw32-make UTF-8 yolları cp1254 sanıyor.
- **Çözüm:** Ninja kullan: `cmake -G "Ninja" ..` (yukarıdaki akışın yaptığı budur).

### `bash not found`
- **Sebep:** PATH'te bash yok.
- **Çözüm:** Git for Windows kur (`choco install git`) — Git Bash'i PATH'e ekler.

### `norminette not found`
- **Sebep:** pip ile kuruldu ama PATH'te değil.
- **Çözüm:** `python -m pip install --user norminette` ardından PowerShell yeniden aç.

### `cmake --build . --target xyz` hata: target tanımlı değil
- **Sebep:** Configure adımı (`cmake -G "Ninja" ..`) yapılmadı.
- **Çözüm:** `build/` klasörünü sil, baştan başla.

---

## 📋 Hızlı Referans

| Adım | Komut | Sonuç |
|------|-------|-------|
| Configure | `cmake -G "Ninja" ..` | `build/` hazırlanır |
| Norm | `cmake --build . --target norm` | norm raporu |
| Cppcheck | `cmake --build . --target cppcheck` | static analiz |
| Build | `cmake --build . --target c` | `output/C/*.exe` |
| Test | `cmake --build . --target test_quines` | PDF testleri |
| Errors | `cmake --build . --target test_errors` | crash testleri |
| QA Full | `cmake --build . --target qa` | hepsi birden |
