# Aşama 6: Sully (C Versiyonu)

**Başlangıç:** -  
**Hedef Tamamlanma:** -  
**Durum:** ⏳ Başlanmadı

---

## Aşama Özeti

Sully, **parametrik self-replicating quine** (öz-çoğalan quine). Her çalıştırmada bir sayaç azaltarak dosyalar oluşturur.

**Güçlük Seviyesi:** ⭐⭐⭐⭐⭐ (Çok Zor - Parametrik Quine)

---

## Temel Gereksinimler

### Tanım
- Dinamik dosya adlandırması: `Sully_N.c` (N = sayaç)
- Sayaç azaltma: 8 → 7 → 6 → ... → 0
- Sayaç = 0 olunca dosya oluşturulmaz
- Tüm dosyalar derlenebilir
- Exit code 0

### Doğrulama Komutu
```bash
./Sully              # Sully_8.c oluşturur
cd Sully_8 && ./Sully_8    # Sully_7.c oluşturur
# ...
cd Sully_0 && ./Sully_0    # DOSYA OLUŞTURMAZ
```

---

## Implementasyon Noktaları

### 1. Sayaç Tanımı

```c
int counter = 8;  /* Başlangıç değeri */
```

### 2. Dosya Adı Oluşturma

```c
char filename[256];
sprintf(filename, "Sully_%d.c", counter - 1);
```

### 3. Durma Koşulu

```c
if (counter == 0)
	return (0);  /* Dosya oluşturma */
```

### 4. Quine String'i Parametrik

Quine string'i sayacı içermelidir ve her çalıştırmada azaltılmalıdır.

---

## Zorluklar

1. **Parametrik Quine:** String'in sayacı dinamik olarak güncellemesi
2. **Self-Recursion:** Her dosya kendi hali ile aynı olmalı
3. **Döngü Yönetimi:** Sayaç 0'a kadar doğru çalışmalı

---

## Test Checklist

- [ ] Derleme başarılı
- [ ] `./Sully` çalışıyor
- [ ] `Sully_8.c` oluşturuldu
- [ ] `cd Sully_8 && make && ./Sully` → `Sully_7.c`
- [ ] Tam döngü test edildi (8 → 0)
- [ ] `Sully_0` dosya oluşturmuyor
- [ ] Norm uyumlu

---

**Sonraki Aşama:** Aşama 7 - Sully (Assembly Versiyonu)

---

**Son Güncelleme:** 2026-05-01
