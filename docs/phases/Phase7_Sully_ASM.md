# Aşama 7: Sully (Assembly Versiyonu)

**Başlangıç:** -  
**Heqatar Tamamlanma:** -  
**Durum:** ⏳ Başlanmadı

---

## Aşama Özeti

Sully'nin Assembly (x86-64) versiyonu. C versiyonundan daha zor çünkü **string formatting ve file I/O Assembly'de yapılmalı.**

**Güçlük Seviyesi:** ⭐⭐⭐⭐⭐⭐ (İmkansız Zorluğunda - Assembly + Parametrik Quine)

---

## Temel Gereksinimler

### Tanım
- Dinamik dosya adı: `Sully_N.s`
- Sayaç: 8 → 0
- Self-replicating
- Exit code 0

### Doğrulama
```bash
./Sully              # Sully_8.s oluşturur
cd Sully_8 && ./Sully     # Sully_7.s oluşturur
```

---

## Zorluklar

1. **String Formatting:** Assembly'de sprintf benzeri fonksiyon gerekli
2. **Dinamik String:** Sayaç değerine göre dosya adı oluşturma
3. **File I/O:** Open, write, close syscall'ları
4. **Parametrik Quine:** En zor bölüm

---

## Temel Syscall'lar

- **open (2):** Dosya oluşturma
- **write (1):** Veri yazma
- **close (3):** Dosya kapatma
- **itoa (custom):** Integer → ASCII string

---

## Alternatif Yaklaşımlar

1. **C Fonksiyon Kullanma:** `sprintf()` libc'den çağrı
2. **Pure Assembly:** Tüm hesaplamalar Assembly'de
3. **Macro Kullanma:** NASM macro'ları ile helper'lar

---

## Test Checklist

- [ ] NASM derleme başarılı
- [ ] Linking başarılı (libc bağlantısı)
- [ ] `./Sully` çalışıyor
- [ ] `Sully_8.s` oluşturuldu
- [ ] Tam döngü test edildi
- [ ] `Sully_0` dosya oluşturmuyor
- [ ] Exit code 0

---

**Sonraki Aşama:** Aşama 8 - Testing & Makefile

---

**Son Güncelleme:** 2026-05-01
