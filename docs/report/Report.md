# Dr_Quine — Proje Raporu ve Bulgular

Bu dosya, Dr_Quine projesinin ilerleme durumunu, yapılan testleri, bulguları ve değerlendirmeleri dokümante etmek için kullanılır.

---

## Rapor Özeti

| Başlık | Durum | Tarih | Yorum |
|--------|-------|-------|-------|
| **Colleen (C)** | ⏳ Başlanmadı | - | Temel quine |
| **Colleen (ASM)** | ⏳ Başlanmadı | - | Assembly quine |
| **Grace (C)** | ⏳ Başlanmadı | - | Dosya yazma quine |
| **Grace (ASM)** | ⏳ Başlanmadı | - | Assembly dosya yazma |
| **Sully (C)** | ⏳ Başlanmadı | - | Parametrik quine |
| **Sully (ASM)** | ⏳ Başlanmadı | - | Assembly parametrik quine |
| **Makefile** | ⏳ Başlanmadı | - | Tüm hedefler |
| **Norminette** | ⏳ Kontrol Edilmedi | - | Code style |
| **Cppcheck** | ⏳ Kontrol Edilmedi | - | Static analysis |
| **Bonus** | ⏳ Başlanmadı | - | Opsiyonel |

---

## Durum Kodları

- ⏳ **Başlanmadı** — Henüz yapılmadı
- 🔨 **Devam Ediyor** — Aktif olarak çalışılıyor
- 🧪 **Test Aşamasında** — İlk draft tamamlandı, test edilmeli
- ✅ **Tamamlandı** — Bitmiş ve test edilmiş
- ❌ **Başarısız** — Hata veya gözden geçirme gerekli
- ⚠️ **Uyarı** — Sorun veya dikkat gereken nokta

---

## Colleen (C Versiyonu) — Test Raporu

### Geliştirme Aşaması
- **Başlangıç Tarihi:** -
- **Tahmini Tamamlanma:** -
- **Gerçek Tamamlanma:** -
- **Durum:** ⏳ Başlanmadı

### Test Sonuçları

#### Derleme Testi
```
[ ] Makefile mevcutmu?
[ ] make komutu başarılı?
[ ] Executable oluşturuldu mu (./Colleen)?
```

#### Fonksiyonellik Testi
```
[ ] ./Colleen çalışıyor mu?
[ ] stdout'a çıktı veriliyor mu?
[ ] Çıktı ekranda görünüyor mu?
```

#### Doğruluk Testi
```
[ ] ./Colleen > test_out.c
[ ] diff test_out.c colleen.c
    Sonuç: [ ] Aynı [ ] Farklı [ ] Hata
[ ] Byte-for-byte karşılaştırma (xxd)
```

#### Norm Testi
```
[ ] norminette colleen.c
    Hata Sayısı: ___
[ ] Header yorum bloğu mevcut?
[ ] 80 sütun limiti?
[ ] Snake_case isimlendirme?
```

### Bulgular

**Özet:** 
```
Tarih: ___________
Değerlendiren: ___________
Sonuç: ✅ Geçti / ❌ Başarısız / ⚠️ Gözden Geçirilmeli
```

**Detaylar:**
```
- 

-

-
```

**Sorunlar:**
```
1. 
2. 
3. 
```

**Öneriler:**
```
- 
- 
```

---

## Colleen (ASM Versiyonu) — Test Raporu

### Geliştirme Aşaması
- **Başlangıç Tarihi:** -
- **Durum:** ⏳ Başlanmadı

### Test Sonuçları

#### Derleme Testi
```
[ ] nasm derlemesi başarılı?
[ ] ld linking başarılı?
[ ] ./colleen çalıştırılabilir?
```

#### Fonksiyonellik Testi
```
[ ] ./colleen çalışıyor mu?
[ ] Segmentation fault yok mu?
[ ] Exit code: ___
```

#### Doğruluk Testi
```
[ ] ./colleen > test_out.s
[ ] diff test_out.s colleen.s
    Sonuç: [ ] Aynı [ ] Farklı
```

### Bulgular

**Özet:** 
```
Tarih: ___________
Sonuç: ✅ / ❌ / ⚠️
```

**Detaylar:**
- 

**Sorunlar:**
- 

---

## Grace (C Versiyonu) — Test Raporu

### Geliştirme Aşaması
- **Başlangıç Tarihi:** -
- **Durum:** ⏳ Başlanmadı

### Test Sonuçları

#### Derleme Testi
```
[ ] make başarılı?
[ ] ./Grace çalışıyor?
```

#### Dosya Oluşturma Testi
```
[ ] Grace_kid.c dosyası oluşturuldu mu?
[ ] Dosya içeriği var mı?
[ ] Dosya boyutu > 0 bayt?
```

#### İçerik Doğruluk Testi
```
[ ] diff grace.c Grace_kid.c
    Sonuç: [ ] Aynı [ ] Farklı
[ ] Dosya tamamen kopya edildi mi?
```

### Bulgular

**Özet:** 
```
Tarih: ___________
Sonuç: ✅ / ❌ / ⚠️
```

---

## Grace (ASM Versiyonu) — Test Raporu

### Geliştirme Aşaması
- **Başlangıç Tarihi:** -
- **Durum:** ⏳ Başlanmadı

### Test Sonuçları

#### Derleme Testi
```
[ ] nasm + ld başarılı?
[ ] ./grace çalışıyor?
```

#### Dosya Oluşturma Testi
```
[ ] Grace_kid.s dosyası oluşturuldu mu?
[ ] diff grace.s Grace_kid.s
```

### Bulgular

**Özet:** 
```
Tarih: ___________
Sonuç: ✅ / ❌ / ⚠️
```

---

## Sully (C Versiyonu) — Test Raporu

### Geliştirme Aşaması
- **Başlangıç Tarihi:** -
- **Durum:** ⏳ Başlanmadı

### Test Sonuçları

#### Derleme Testi
```
[ ] make başarılı?
[ ] ./Sully çalışıyor?
```

#### Dosya Oluşturma Testi (Sayaç = 8)
```
[ ] Sully_8.c oluşturuldu mu?
[ ] Sully_8.c derlenebiliyor mu?
[ ] diff Sully.c Sully_8.c (aynı olmalı)
```

#### Döngü Testi
```
[ ] cd Sully_8 && make && ./Sully → Sully_7.c
[ ] cd Sully_7 && make && ./Sully → Sully_6.c
[ ] ... (devam)
[ ] cd Sully_1 && make && ./Sully → Sully_0.c
[ ] cd Sully_0 && make && ./Sully → DOSYA YOK
```

### Bulgular

**Özet:** 
```
Tarih: ___________
Toplam döngü sayısı: ___
Sonuç: ✅ / ❌ / ⚠️
```

---

## Sully (ASM Versiyonu) — Test Raporu

### Geliştirme Aşaması
- **Başlangıç Tarihi:** -
- **Durum:** ⏳ Başlanmadı

### Test Sonuçları

#### Derleme Testi
```
[ ] nasm + ld başarılı?
[ ] ./Sully çalışıyor?
```

#### Dosya Oluşturma ve Döngü Testi
```
[ ] Sully_8.s oluşturuldu mu?
[ ] Döngü tamamı çalışıyor mu?
[ ] Sully_0.s oluşturulduğunda durmuyor mu?
```

### Bulgular

**Özet:** 
```
Tarih: ___________
Sonuç: ✅ / ❌ / ⚠️
```

---

## Makefile Denetimi

### C/Colleen/Makefile
```
[ ] all hedefi: $(NAME) oluşturuyor
[ ] clean hedefi: .o dosyaları siliyor
[ ] fclean hedefi: tüm oluşturulan dosyalar siliniyor
[ ] re hedefi: fclean + all
[ ] Relink sorunu: [ ] Yok [ ] Var
```

### C/Grace/Makefile
```
[ ] all hedefi çalışıyor
[ ] clean hedefi çalışıyor
[ ] fclean hedefi çalışıyor
[ ] re hedefi çalışıyor
[ ] Relink sorunu: [ ] Yok [ ] Var
```

### C/Sully/Makefile
```
[ ] all hedefi çalışıyor
[ ] clean hedefi çalışıyor
[ ] fclean hedefi çalışıyor
[ ] re hedefi çalışıyor
[ ] Relink sorunu: [ ] Yok [ ] Var
```

### ASM Makefile'ları
```
ASM/Colleen/Makefile:
[ ] nasm kuralı: .s → .o
[ ] ld kuralı: .o → executable
[ ] Hedefler doğru

ASM/Grace/Makefile:
[ ] Benzer kontroller

ASM/Sully/Makefile:
[ ] Benzer kontroller
```

---

## Norm Kontrol Raporu

### Tarih: ___________

```
C/Colleen/colleen.c:
  [ ] Hata yok
  [ ] Hata sayısı: ___
  [ ] Sorunlar: ________________

C/Grace/grace.c:
  [ ] Hata yok
  [ ] Hata sayısı: ___
  [ ] Sorunlar: ________________

C/Sully/sully.c:
  [ ] Hata yok
  [ ] Hata sayısı: ___
  [ ] Sorunlar: ________________
```

### Yaygın Hata Türleri
```
[ ] Header yorum bloğu: ___
[ ] İsimlendirme (snake_case): ___
[ ] Satır uzunluğu (80 sütun): ___
[ ] Escape sequence'leri: ___
[ ] Boşluk ve tab kullanımı: ___
```

### Düzeltme Notları
```
- 
- 
```

---

## Cppcheck / MISRA Analiz Raporu

### Tarih: ___________

```
Çalıştırılan Komut:
  cppcheck --enable=all C/ ASM/

Hata Sayısı: ___
Uyarı Sayısı: ___
Stil Sorunu: ___
```

### Tespit Edilen Sorunlar

| Dosya | Tür | Açıklama | Düzeltme |
|-------|-----|----------|----------|
| colleen.c | warning | ... | ... |
| ... | ... | ... | ... |

### MISRA C:2012 Uyumluluğu
```
[ ] Mandatory kurallar uyumlu
[ ] Required kurallar uyumlu
[ ] Advisory kurallar uyumlu
```

---

## Genel Değerlendirme

### Tamamlanma Yüzdesi
```
Colleen (C):    ___% [████░░░░░░]
Colleen (ASM):  ___% [████░░░░░░]
Grace (C):      ___% [████░░░░░░]
Grace (ASM):    ___% [████░░░░░░]
Sully (C):      ___% [████░░░░░░]
Sully (ASM):    ___% [████░░░░░░]
Makefile:       ___% [████░░░░░░]
Norm:           ___% [████░░░░░░]
Bonus:          ___% [████░░░░░░]
─────────────────────────────────
TOPLAM:         ___% [████░░░░░░]
```

### Başarılı Alanlar
```
✅ 
✅ 
✅ 
```

### Geliştirilmesi Gereken Alanlar
```
⚠️ 
⚠️ 
⚠️ 
```

### Genel Yorum
```
Tarih: ___________
Değerlendiren: ___________

_________________________________________________________________

_________________________________________________________________

_________________________________________________________________
```

### Öneriler
```
1. 
2. 
3. 
```

---

## Bonus Projeler

### Bonus 1: Farklı Dilde Uygulama

**Dil:** ___________
**Durum:** ⏳ / 🔨 / 🧪 / ✅ / ❌

**İçerik:**
```
[ ] Colleen uygulandı
[ ] Grace uygulandı
[ ] Sully uygulandı
[ ] Test edildi
[ ] Norm uyumlu (varsa)
```

**Bulgular:**
```
- 
- 
```

### Bonus 2: İyileştirmeler

**Açıklama:** ___________

**İçerik:**
```
- 
- 
```

**Durumu:** ⏳ / 🔨 / 🧪 / ✅

---

## Zaman Kullanım Raporu

| Aşama | Planlanan (saat) | Gerçek (saat) | Fark | Açıklama |
|-------|------------------|---------------|------|----------|
| Hazırlık | 2 | _ | _ | |
| Colleen (C) | 3 | _ | _ | |
| Colleen (ASM) | 4 | _ | _ | |
| Grace (C) | 1.5 | _ | _ | |
| Grace (ASM) | 2.5 | _ | _ | |
| Sully (C) | 3.5 | _ | _ | |
| Sully (ASM) | 5 | _ | _ | |
| Testing | 3 | _ | _ | |
| Norm/Cppcheck | 1.5 | _ | _ | |
| **TOPLAM** | **26** | **_** | **_** | |

---

## Sonuç ve Öğrenilen Dersler

### Başlıca Zorluklar
```
1. 
2. 
3. 
```

### Çözülen Problemler
```
1. 
2. 
3. 
```

### Kazanılan Bilgiler
```
- 
- 
- 
```

### İleride Uygulanabilir Bilgiler
```
- 
- 
- 
```

---

**Rapor Güncelleme Tarihi:** 2026-05-01
**Hazırlayan:** 
**Gözden Geçiren:** 
