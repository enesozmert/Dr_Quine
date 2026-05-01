# Aşama 2: Colleen (C Versiyonu)

**Başlangıç:** 2026-05-01  
**Hedef Tamamlanma:** -  
**Durum:** 🔨 Devam Ediyor

---

## Aşama Özeti

Colleen, Dr_Quine projesinin ilk ve en temel programıdır. C dilinde yazılacak ve kendisini oluşturan kaynak kodunu **stdout'a yazdırmalıdır**.

**Güçlük Seviyesi:** ⭐⭐ (Orta)

---

## Temel Gereksinimler

### Tanım
- Bir quine programı (çıktısı kendi kaynak kodu)
- C dilinde yazıldığında
- Hiçbir argument almaz
- Hiçbir dosya okumaz/yazmaz
- Stdout'a kendi kaynak kodunu yazdırır

### Doğrulama Komutu
```bash
./Colleen > output.c
diff output.c colleen.c
# Sonuç: 0 (aynı olmalı)
```

### Exit Code
- **0:** Başarılı

---

## Implementasyon Adımları

### 1. Temel Yapıyı Oluştur

**Dosya:** `C/Colleen.c`

```c
/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   colleen.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ozmerte <ozmerte@gmail.com>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/05/01 00:00:00 by ozmerte        #+#    #+#                 */
/*   Updated: 2026/05/01 00:00:00 by ozmerte       ###   ########.fr          */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int	main(void)
{
	/* Quine implementation here */
	return (0);
}
```

**Kontrolü:** Header yorum bloğu doğru formatlanmış mı?

---

### 2. Quine Mekanizmasını Anla

**Konsept:** Quine string'i kendi kodunu içerir

```
Temel fikir:
char *s = "... printf format string ...";
printf(s, s);
```

**Escape Sequences:**
- `\"` — tırnak işareti
- `\\` — backslash
- `\n` — yeni satır
- `\t` — tab

**Format Specifiers:**
- `%s` — string
- `%c` — karakter
- `%d` — integer

---

### 3. Quine String'ini Yazma

Colleen'in temel yapısı:
```c
char *s = "/* String buraya... */";
printf(s, s);
```

**Önemli:** String'in kendisi tam olarak program kaynağı olmalı, escape sequence'ler dahil!

---

### 4. Derleme ve Test

```bash
cd /path/to/Dr_Quine
make all
# Veya: gcc -Wall -Wextra -Werror -g -Ihdr -o Colleen C/Colleen.c
```

**Beklenen Sonuç:** `Colleen` executable'ı oluşturulmalı

---

### 5. İlk Test

```bash
./Colleen
# Ekranda kaynak kodu görülmeli
```

**Kontrol Noktaları:**
- [ ] Program çalışıyor
- [ ] stdout'a çıktı veriliyor
- [ ] Segmentation fault yok
- [ ] Program sonlanıyor (exit code 0)

---

### 6. Doğruluk Testi

```bash
./Colleen > test_colleen.c
diff test_colleen.c C/Colleen.c
echo $?
# Sonuç: 0 (dosyalar aynı)
```

**Başarı Kriteri:** `diff` çıktısı boş olmalı, exit code 0

---

## Norm Uyumluluğu Kontrolleri

### Gerekli Kontroller
```bash
norminette C/Colleen.c
# Sonuç: 0 hata
```

### Norm Kriterleri (Checklist)

- [ ] **Header Bloğu:** 42 standart format
- [ ] **İsimlendirme:** snake_case (değişken, fonksiyon, dosya)
- [ ] **Satır Uzunluğu:** max 80 sütun
- [ ] **Fonksiyon Uzunluğu:** max 25 satır (kendi {} hariç)
- [ ] **Tab:** 4 boşluk (gerçek tab, boşluk değil)
- [ ] **Return:** `return (value);` formatı
- [ ] **Fonksiyon Başında Değişkenler:** tek boş satırla ayrılmış
- [ ] **Trailing Whitespace:** yok
- [ ] **Boş Satırlar:** tamamen boş (hiç boşluk yok)
- [ ] **for/do...while/switch/goto:** yasak ❌
- [ ] **Nested Ternary:** yasak ❌

---

## Olası Sorunlar ve Çözümleri

### Sorun 1: Çıktı Yanlış
**Belirti:** `diff` hata gösteriyor  
**Çözüm:** 
```bash
xxd -l 50 test_colleen.c > /tmp/out1.hex
xxd -l 50 C/Colleen.c > /tmp/out2.hex
diff /tmp/out1.hex /tmp/out2.hex
```
Byte-by-byte karşılaştırma yapın.

### Sorun 2: Norm Hatası
**Belirti:** norminette hata veriyor  
**Çözüm:** [NORMCHECK.md](../normcheck/NORMCHECK.md) oku ve kuralları düzelt

### Sorun 3: Segmentation Fault
**Belirti:** Program crash oluyor  
**Çözüm:** 
- Pointer'lar NULL mı kontrol et
- String boyutu yeterli mi kontrol et
- GDB ile debug et: `gdb ./Colleen`

### Sorun 4: Derleme Hatası
**Belirti:** `gcc` hata veriyor  
**Çözüm:** 
- Header'ları dahil et: `-Ihdr`
- Syntax kontrol et
- Compiler flag'lerini kontrol et

---

## Test Checklist

- [ ] **Derleme:** `make all` başarılı
- [ ] **Çalışma:** `./Colleen` crash etmez
- [ ] **Çıktı Testi:** `./Colleen > test.c && diff test.c C/Colleen.c`
- [ ] **Norm:** `norminette C/Colleen.c` = 0 hata
- [ ] **Tekrar Çalıştırma:** Deterministic (aynı çıktı)
- [ ] **Cppcheck:** `cppcheck C/Colleen.c` - warning yok

---

## Kaynaklar

| Kaynak | Link/Yer |
|--------|----------|
| **Quine Tanımı** | [Wikipedia](https://en.wikipedia.org/wiki/Quine_(computing)) |
| **Norm Kuralları** | [NORMCHECK.md](../normcheck/NORMCHECK.md) |
| **Proje Kuralları** | [Rules.md](../rules/Rules.md) |
| **Command Detayları** | [Command.md](../command/Command.md) § Colleen |
| **Teorik Bilgi** | [Presentation.md](../presentation/Presentation.md) |

---

## Notlar

- Quine yazmanın hiçbir "resmi" yolu yok - yaratıcılık önemli
- Genel quine trick'leri: format string'ler, escape sequence'ler, string copy
- C'de quine yazmak zor ama öğretici
- Assembly'e geçmeden önce C versiyonu çalışmalı

---

## Aşama Bitince Kontrolü

Aşama 2 bittiğinde:
- [ ] `C/Colleen.c` mevcut ve çalışıyor
- [ ] `./Colleen > out.c && diff out.c C/Colleen.c` = başarılı
- [ ] `norminette C/Colleen.c` = 0 hata
- [ ] `make fclean && make all` = başarılı
- [ ] Git commit yapıldı

**Sonraki Aşama:** Aşama 3 - Colleen (Assembly Versiyonu)

---

**Son Güncelleme:** 2026-05-01
