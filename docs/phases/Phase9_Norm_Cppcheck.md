# Aşama 9: Norm & Cppcheck Uyumluluğu

**Başlangıç:** -  
**Hedef Tamamlanma:** -  
**Durum:** ⏳ Başlanmadı

---

## Aşama Özeti

Tüm C dosyalarının École 42 Norminette kurallarına ve MISRA C:2012 standartlarına uygun olduğunu doğrulama.

**Güçlük Seviyesi:** ⭐⭐ (Orta)

---

## Norminette Kontrolleri

```bash
norminette src/*.c hdr/*.h
# Sonuç: 0 hata
```

### Norm Kriterleri
- [ ] 42 header bloğu
- [ ] snake_case isimlendirme
- [ ] max 80 sütun
- [ ] max 25 satır/fonksiyon
- [ ] for/do...while/switch/goto yasak
- [ ] return (value) formatı
- [ ] Trailing whitespace yok

---

## Cppcheck Static Analysis

```bash
cppcheck --enable=all src/ hdr/
```

### Kontrol Alanları
- Null pointer dereference
- Buffer overflow
- Memory leak
- Uninitialized variables
- MISRA C:2012 ihlalleri

---

## Düzeltme Süreci

1. **Hatalar Listele:**
   ```bash
   norminette src/*.c 2>&1 | grep "Error"
   ```

2. **Sorunları Düzelt:**
   - Her hatayı oku ve anlıştır
   - Kod değiştir
   - Tekrar kontrol et

3. **Doğrulama:**
   ```bash
   norminette src/*.c
   # 0 hata
   ```

---

## Checklist

- [ ] Norminette: 0 hata
- [ ] Cppcheck: Warning yok (veya accept edilmiş)
- [ ] Header blokları doğru
- [ ] İsimlendirme uyumlu
- [ ] Satır uzunluğu < 80
- [ ] for/switch/goto yok

---

**Sonraki Aşama:** Aşama 10 - Bonus

---

**Son Güncelleme:** 2026-05-01
