# Aşama 4: Grace (C Versiyonu)

**Başlangıç:** -  
**Hedef Tamamlanma:** -  
**Durum:** ⏳ Başlanmadı

---

## Aşama Özeti

Grace, Colleen'e benzer ancak **önemli bir farkı vardır:** çıktısı stdout yerine **bir dosyaya yazılır.**

Grace çalıştırıldığında, `Grace_kid.c` adında bir dosya oluşturmalı ve bu dosyaya kendi kaynak kodunun bir kopyasını yazmalıdır.

**Güçlük Seviyesi:** ⭐⭐⭐ (Orta-Yüksek - Dosya I/O + Quine)

---

## Temel Gereksinimler

### Tanım
- Quine programı (çıktısı kendi kaynak kodu)
- C dilinde yazılmış
- **Dosyaya yazma** (`Grace_kid.c` adında)
- Hiçbir argument almaz
- Stdout'a hiçbir şey yazmaz
- Exit code 0

### Doğrulama Komutu
```bash
./Grace
diff grace.c Grace_kid.c
# Sonuç: 0 (aynı olmalı)
```

---

## Implementasyon Adımları

### 1. Dosya I/O Seçenekleri

**Seçenek A: POSIX Syscall'ları**
```c
#include <fcntl.h>
#include <unistd.h>

int fd = open("Grace_kid.c", O_CREAT | O_WRONLY | O_TRUNC, 0644);
write(fd, content, length);
close(fd);
```

**Seçenek B: C Standard Library**
```c
#include <stdio.h>

FILE *fp = fopen("Grace_kid.c", "w");
fprintf(fp, "%s", content);
fclose(fp);
```

### 2. Hata Kontrolü

```c
FILE *fp = fopen("Grace_kid.c", "w");
if (fp == NULL)
	return (1);
if (fclose(fp) != 0)
	return (1);
```

### 3. Stdout'a Çıktı Yok

- [ ] `printf()` kullanılmıyor
- [ ] `puts()` kullanılmıyor
- [ ] Sadece dosya yazma

---

## Test Checklist

- [ ] Derleme başarılı
- [ ] `./Grace` çalışıyor
- [ ] `Grace_kid.c` dosyası oluşturuldu
- [ ] `diff grace.c Grace_kid.c` = 0
- [ ] Norm uyumlu
- [ ] Stdout'a hiçbir çıktı yok

---

**Sonraki Aşama:** Aşama 5 - Grace (Assembly Versiyonu)

---

**Son Güncelleme:** 2026-05-01
