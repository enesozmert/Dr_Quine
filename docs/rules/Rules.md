# Dr_Quine — Proje Kuralları ve Kısıtlamalar

Bu dokümanda, Dr_Quine projesinin tüm resmi ve teknik kuralları, kısıtlamalar ve beklentiler yer almaktadır.

---

## 1. Proje Genel Kuralları

### 1.1 Zorunlu Gereksinimler

#### Dilsel Gereksinimler
- **C dilinde uygulanması:** Tüm üç program (Colleen, Grace, Sully) **C dilinde** yazılmalıdır
- **Assembly dilinde uygulanması:** Tüm üç program **Assembly (x86-32 veya x86-64)** dilinde de yazılmalıdır
- **Dil Seçimi:** Her klasör kendi dilini içerir:
  - `C/` — C uygulamaları
  - `ASM/` — Assembly uygulamaları

#### Klasör Yapısı
```
Dr_Quine/
├── C/
│   ├── Colleen/
│   │   ├── Makefile
│   │   └── colleen.c
│   ├── Grace/
│   │   ├── Makefile
│   │   └── grace.c
│   └── Sully/
│       ├── Makefile
│       └── sully.c
└── ASM/
    ├── Colleen/
    │   ├── Makefile
    │   └── colleen.s (veya colleen.asm)
    ├── Grace/
    │   ├── Makefile
    │   └── grace.s
    └── Sully/
        ├── Makefile
        └── sully.s
```

#### Executable Adları
| Program | Geçerli Adlar | Açıklama |
|---------|--------------|----------|
| **Colleen (C)** | `Colleen` | Büyük harf ile başlamalı |
| **Colleen (ASM)** | `colleen` | Küçük harf (convention) |
| **Grace (C)** | `Grace` | Büyük harf ile başlamalı |
| **Grace (ASM)** | `grace` | Küçük harf (convention) |
| **Sully (C)** | `Sully` | Büyük harf ile başlamalı |
| **Sully (ASM)** | `sully` | Küçük harf (convention) |

### 1.2 Derleme Kuralları

#### C Derleme
```bash
gcc -Wall -Wextra -Werror -o colleen colleen.c
```

**Zorunlu Flag'ler:**
- `-Wall` — Tüm uyarıları etkinleştir
- `-Wextra` — Ek uyarıları etkinleştir
- `-Werror` — Uyarıları hata olarak işle
- `-o output_name` — Executable adı belirt

**Opsiyonel Flag'ler:**
- `-g` — Debug sembollerini dahil et
- `-O0` — Optimizasyon yapma (debug için)
- `-pedantic` — POSIX compliance

#### Assembly Derleme (x86-64)
```bash
nasm -f elf64 colleen.s -o colleen.o
ld colleen.o -o colleen
```

**veya C kütüphanesi ile:**
```bash
nasm -f elf64 colleen.s -o colleen.o
gcc -o colleen colleen.o
```

#### Assembly Derleme (x86-32 — varsa)
```bash
nasm -f elf32 colleen.s -o colleen.o
ld colleen.o -o colleen
# veya: gcc -m32 -o colleen colleen.o
```

### 1.3 Makefile Kuralları

#### Zorunlu Hedefler

| Hedef | Açıklama | Gereksinimler |
|-------|----------|--------------|
| `all` | Varsayılan hedef, executable'ı derle | Çalıştırılabilir dosya oluşturulmalı |
| `clean` | Derleme ürünlerini sil | `.o` dosyaları silinmeli |
| `fclean` | Tamamen temizle | `clean` + executable silinmeli |
| `re` | Yeniden derle | `fclean` + `all` |

#### Relink Yasağı
**Çok Önemli:** Makefile **relink yapmamalıdır**!

**Yanlış (Relink yapıyor):**
```makefile
all: colleen.c
	gcc -o colleen colleen.c
```

**Doğru (Relink yapmıyor):**
```makefile
NAME = colleen
SRCS = colleen.c
OBJS = $(SRCS:.c=.o)

all: $(NAME)

$(NAME): $(OBJS)
	gcc -o $(NAME) $(OBJS)

%.o: %.c
	gcc -Wall -Wextra -Werror -c $< -o $@

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
```

#### Assembly Makefile
```makefile
NAME = colleen
SRCS = colleen.s
OBJS = $(SRCS:.s=.o)

all: $(NAME)

$(NAME): $(OBJS)
	ld $(OBJS) -o $(NAME)

%.o: %.s
	nasm -f elf64 $< -o $@

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
```

---

## 2. Colleen Kuralları

### 2.1 Tanım
Colleen, temel quine programıdır. **Kendini oluşturan kaynak kodunu stdout'a yazdırmalıdır.**

### 2.2 Giriş/Çıkış

| Özellik | Gereksinim | Açıklama |
|---------|-----------|----------|
| **Giriş** | Yok | stdin okumaz, argüman almaz |
| **Çıktı** | stdout | Kaynak kodun kendisi |
| **Dosya Yazma** | Yasak | Hiçbir dosya yazalamaz |
| **İşaret Düzeyi** | 0 | Başarılı çıkış |

### 2.3 Doğrulama Testi

```bash
cd C/Colleen
make re
./Colleen > output.c
diff output.c colleen.c
echo $?  # 0 olmalı (aynı dosya)
```

**Başarı Koşulu:**
```
- output.c ile colleen.c aynı olmalı
- Byte-for-byte karşılaştırma (xxd veya cmp -l)
- Hiçbir extra karakter yok
```

### 2.4 Kısıtlamalar

#### Yasak İşlemler
- [ ] Dosya sistemi erişimi (açma, okuma, yazma)
- [ ] stdin okuma
- [ ] Sistem çağrıları (system() vb.)
- [ ] Başka program çalıştırma
- [ ] Komut satırı argümanları kullanma
- [ ] Ortam değişkenleri okuma
- [ ] Dinamik bellek (malloc) **opsiyonel olarak kullanılabilir**

#### İzin Verilen İşlemler
- [ ] printf/puts ile stdout yazma
- [ ] Sabit string'ler (literal strings)
- [ ] Format specifier'lar (`%s`, `%d`, `%c` vb.)
- [ ] Escape sequence'leri (`\n`, `\"`, `\\` vb.)
- [ ] Temel aritmetik ve logic
- [ ] Statik bellek

### 2.5 C Örnek Yapı

```c
#include <stdio.h>

int main(void)
{
	char *s = "...";
	printf(s, s);
	return (0);
}
```

### 2.6 Assembly Örnek Yapı (x86-64)

```nasm
section .data
	msg: db "...", 0

section .text
	global _start

_start:
	mov rax, 1          ; write syscall
	mov rdi, 1          ; stdout
	mov rsi, msg        ; message
	mov rdx, ...        ; length
	syscall

	mov rax, 60         ; exit syscall
	mov rdi, 0          ; exit code
	syscall
```

---

## 3. Grace Kuralları

### 3.1 Tanım
Grace, Colleen benzeridir ancak **çıktısı bir dosyaya yazılır.**

### 3.2 Giriş/Çıkış

| Özellik | Gereksinim | Açıklama |
|---------|-----------|----------|
| **Dosya Adı (C)** | `Grace_kid.c` | Sabit isim, değiştirilmez |
| **Dosya Adı (ASM)** | `Grace_kid.s` | Sabit isim, değiştirilmez |
| **İçerik** | Grace'in kaynak kodu | Tamamen aynı olmalı |
| **stdout** | Boş | Hiçbir çıktı yazılmaz |
| **Exit Code** | 0 | Başarılı çıkış |

### 3.3 Doğrulama Testi

```bash
cd C/Grace
make re
./Grace
diff grace.c Grace_kid.c
echo $?  # 0 olmalı

# Tekrar çalıştırma
rm Grace_kid.c
./Grace
diff grace.c Grace_kid.c
echo $?  # 0 olmalı
```

### 3.4 Dosya I/O Kuralları

#### C'de Dosya Yazma
```c
#include <fcntl.h>      /* open, O_CREAT, O_WRONLY, O_TRUNC */
#include <unistd.h>     /* write, close */
#include <sys/stat.h>   /* S_IRUSR, S_IWUSR, S_IRGRP, S_IROTH */

int fd = open("Grace_kid.c", O_CREAT | O_WRONLY | O_TRUNC, 0644);
if (fd < 0) { perror("open"); exit(1); }
write(fd, content, length);
close(fd);
```

**veya:**
```c
#include <stdio.h>

FILE *fp = fopen("Grace_kid.c", "w");
if (fp == NULL) { perror("fopen"); exit(1); }
fprintf(fp, "%s", content);
fclose(fp);
```

#### Assembly'de Dosya Yazma (x86-64)
```nasm
; open syscall: rax=2, rdi=filename, rsi=flags (O_CREAT|O_WRONLY|O_TRUNC), rdx=mode (0644)
; write syscall: rax=1, rdi=fd, rsi=buffer, rdx=count
; close syscall: rax=3, rdi=fd
```

### 3.5 Kısıtlamalar

- [ ] Dosya adı değiştirilmez (`Grace_kid.c` / `Grace_kid.s`)
- [ ] Dosya yazma başarısız olursa program hataya girmeli (exit(1))
- [ ] stdout'a hiçbir çıktı yazılmaz
- [ ] Dosya her çalıştırmada öncekini üzerine yazmalı (truncate)

---

## 4. Sully Kuralları

### 4.1 Tanım
Sully, **öz-çoğalma yapan parametrik quine**'dir. Her çalıştırmada sayaç azalarak dosya oluşturur.

### 4.2 Giriş/Çıkış

| Özellik | Gereksinim | Açıklama |
|---------|-----------|----------|
| **Başlangıç Sayacı** | Minimum 1, Tavsiye 8 | İlk dosya adına 1 eklenerek yazılır |
| **Dosya Adı (C)** | `Sully_N.c` | N = mevcut sayaç |
| **Dosya Adı (ASM)** | `Sully_N.s` | N = mevcut sayaç |
| **Durdurma** | Sayaç = 0 | Dosya oluşturulmaz, program biter |
| **stdout** | Boş veya az | Hiçbir veya minimal çıktı |

### 4.3 Örnek Döngü (Başlangıç = 8)

```
Sully.c çalıştırıldığında:
  → Sully_8.c oluşturulur (sayaç = 8)
  
cd Sully_8 && ./Sully_8 çalıştırıldığında:
  → Sully_7.c oluşturulur (sayaç = 7)
  
... devam eder ...

cd Sully_1 && ./Sully_1 çalıştırıldığında:
  → Sully_0.c oluşturulur (sayaç = 0)

cd Sully_0 && ./Sully_0 çalıştırıldığında:
  → HİÇBİR DOSYA OLUŞTURULMAZ (döngü sona erdi)
```

### 4.4 Doğrulama Testi

```bash
cd C/Sully
make re
./Sully
# Sully_8.c oluşturulmalı (veya başlangıç sayacı)

cd Sully_8
make
./Sully
# Sully_7.c oluşturulmalı

# ... devam ...

cd Sully_1
make
./Sully
# Sully_0.c oluşturulmalı

cd Sully_0
make
./Sully
# DOSYA OLUŞTURULMAZ (success)
ls *.c | wc -l  # 1 (sadece sully_0.c)
```

### 4.5 Sayaç Mekanizması

#### C'de Sayaç Yönetimi
```c
#include <stdio.h>

int main(void)
{
	int counter = 8;  /* Başlangıç değeri */
	char *s = "... %d ...";  /* Sayacı format string'e ekle */
	char filename[256];
	
	if (counter == 0)
		return (0);  /* Durdur */
	
	counter--;  /* Azalt */
	
	sprintf(filename, "Sully_%d.c", counter);
	/* Dosya oluştur ve yaz */
	/* printf(s, counter) vb. */
	
	return (0);
}
```

#### Assembly'de Sayaç Yönetimi
```nasm
counter equ 8

section .data
	format: db "... counter=%d ...", 0

section .text
	global _start
	
_start:
	mov rax, counter
	cmp rax, 0
	je .stop        ; Sayaç 0 ise durdur
	
	dec rax          ; Sayacı azalt
	
	; Dosya adı oluştur: sprintf("Sully_%d.s", sayac)
	; Dosyayı aç, yaz, kapat
	
.stop:
	mov rax, 60     ; exit
	mov rdi, 0
	syscall
```

### 4.6 Kısıtlamalar

- [ ] Her oluşturulan dosya (Sully_N.c/s) **derlenebilir olmalı**
- [ ] Sayaç **tekrar artırılamaz**, sadece azalır
- [ ] Sayaç = 0 olunca **dosya oluşturulmaz**
- [ ] Önceki dosyaları silme yasağı (her dosya kalıcı)
- [ ] Format string'i uygun şekilde güncellenmeli

### 4.7 Dosya Kaydı

```
C/Sully/
├── Makefile
├── Sully.c
├── Sully_8.c (oluşturulur)
├── Sully_7.c (oluşturulur)
├── Sully_6.c (oluşturulur)
├── Sully_5.c (oluşturulur)
├── Sully_4.c (oluşturulur)
├── Sully_3.c (oluşturulur)
├── Sully_2.c (oluşturulur)
├── Sully_1.c (oluşturulur)
└── Sully_0.c (oluşturulur)

Toplam: 11 dosya (Sully.c + Sully_0.c ... Sully_8.c)
```

---

## 5. Norminette Kuralları (C Dosyaları)

### 5.1 Zorunlu Başlık Yorum Bloğu

Tüm `.c` dosyaları aşağıdaki format'ta başlamalıdır:

```c
/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   dosya_adi.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: login <login@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: YYYY/MM/DD HH:MM:SS by login        #+#    #+#                 */
/*   Updated: YYYY/MM/DD HH:MM:SS by login       ###   ########.fr          */
/*                                                                            */
/* ************************************************************************** */
```

### 5.2 İsimlendirme Kuralları

| Tür | Format | Örnek |
|-----|--------|-------|
| Değişken | `snake_case` | `string_buffer`, `input_char` |
| Fonksiyon | `snake_case` | `write_to_file`, `get_counter` |
| Dosya | `snake_case` | `colleen.c`, `grace.c` |
| Makro | `UPPER_SNAKE_CASE` | `MAX_SIZE`, `BUFFER_SIZE` |

### 5.3 Satır Uzunluğu
- **Maximum:** 80 sütun (tab = 4 boşluk olarak sayılır)
- **Kontrol:** `wc -L filename`

### 5.4 Fonksiyon Uzunluğu
- **Maximum:** 25 satır (kendi `{}` süslü parantezleri hariç)
- **Kontrol:** Her fonksiyonun fiziksel satırlarını say

### 5.5 Dosya Başına Fonksiyon Sayısı
- **Maximum:** 5 fonksiyon/dosya
- **Eğer 5'i aşarsa:** Dosyayı bölmeli

### 5.6 Diğer Temel Kurallar
- [ ] 4 boşluk genişliğinde **gerçek tab** karakteri (boşluk değil)
- [ ] Fonksiyon başına maximum 4 isimli parametre
- [ ] Blok başına maximum 5 değişken tanımı
- [ ] Trailing whitespace yok (satır sonunda boşluk)
- [ ] Boş satırlar gerçekten boş (boşluk/tab yok)
- [ ] `for`, `do...while`, `switch/case`, `goto` yasak
- [ ] Nested ternary operator yasak
- [ ] VLA (Variable Length Arrays) yasak
- [ ] `return (value)` formatı (parantez zorunlu)

### 5.7 Norm Kontrol Aracı

```bash
# Dosya kontrol
norminette colleen.c

# Dizin kontrol
norminette C/

# Detaylı hata raporları
norminette -R CheckForbiddenSourceHeader C/
```

**Başarı Kriteri:** 0 hata

---

## 6. MISRA C:2012 Kuralları (Opsiyonel ama Önerilen)

Bkz. [CPPCHECK-MISRA-C2012.md](../cppcheck/CPPCHECK-MISRA-C2012.md)

### 6.1 Yaygın Sorunlar

- [ ] NULL pointer dereference (malloc/calloc'dan sonra kontrol)
- [ ] Buffer overflow (bounds checking)
- [ ] Uninitialized variables
- [ ] Resource leak (dosya handles, malloc'lar)
- [ ] Return value unused (fprintf, write vb.)

### 6.2 Cppcheck Analizi

```bash
# Temel analiz
cppcheck --enable=all C/

# MISRA analizi (dump + addon)
cppcheck --dump C/*.c
python addons/misra.py C/*.dump
```

---

## 7. Assembly Kuralları (x86-64)

### 7.1 Mimarisinin Seçimi
- **x86-64 (64-bit):** Tercih edilen, modern
- **x86-32 (32-bit):** Alternatif (legacy)

### 7.2 NASM Syntax

```nasm
section .data
	db "byte string", 0    ; null-terminated string
	dq 0x1234567890abcdef  ; 64-bit value

section .text
	global _start
	
_start:
	mov rax, 60      ; exit syscall
	mov rdi, 0       ; exit code
	syscall
```

### 7.3 Syscall Tablosu (x86-64)

| İşlem | rax | rdi | rsi | rdx | Açıklama |
|-------|-----|-----|-----|-----|----------|
| **read** | 0 | fd | *buf | count | Dosya oku |
| **write** | 1 | fd | *buf | count | Dosya yaz |
| **open** | 2 | *path | flags | mode | Dosya aç |
| **close** | 3 | fd | - | - | Dosya kapat |
| **exit** | 60 | code | - | - | Program çık |

### 7.4 Dosya Flags (open syscall)

```c
#define O_RDONLY   0
#define O_WRONLY   1
#define O_RDWR     2
#define O_CREAT    0o100      /* 64 */
#define O_WRONLY   0o1        /* 1 */
#define O_TRUNC    0o1000     /* 512 */
```

### 7.5 Bağlanma (Linking)

```bash
# Sadece syscall'lar (C kütüphanesi yok)
ld colleen.o -o colleen

# C kütüphanesi ile (sprintf vb.)
ld colleen.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o colleen
# veya
gcc -o colleen colleen.o
```

---

## 8. Bonus Kuralları

### 8.1 Kabul Edilen Bonus
- [ ] Aynı projeyi **başka dilde** (Python, Rust, Go, vb.) uygulamak
- [ ] **Belge/README** yazma
- [ ] **Test script'leri** oluşturma
- [ ] **Optimizasyonlar** (daha kısa, daha hızlı kod)

### 8.2 Reddedilen Bonus
- [ ] Syntax highlighting editors
- [ ] Proje dışı araçlar (external generators)
- [ ] Kodun işlevselliğini değiştiren değişiklikler

---

## 9. Yaygın Hatalar ve Çözümleri

### Hata 1: Quine Çıktısı Yanlış
**Sebep:** Escape sequence'leri veya format string'i hatalı
**Çözüm:** 
```bash
./Colleen | xxd > out1.hex
cat colleen.c | xxd > out2.hex
diff out1.hex out2.hex
```

### Hata 2: Makefile Relink Yapıyor
**Sebep:** Makefile bağımlılıkları yanlış
**Çözüm:**
```makefile
# Yanlış
all: executable
	gcc -o executable *.c

# Doğru
all: $(OBJS)
	gcc -o executable $^

%.o: %.c
	gcc -c $< -o $@
```

### Hata 3: Norm Hatası — Satır Uzunluğu
**Sebep:** Satır 80 sütunu aşıyor
**Çözüm:** Satırları böl veya format string'i kısa yap

### Hata 4: Sully Sonsuz Döngü
**Sebep:** Sayaç kontrol edilmiyor veya azaltılmıyor
**Çözüm:** Sayaç == 0 şartını açıkça kontrol et

### Hata 5: Assembly Segmentation Fault
**Sebep:** Syscall kuralları yanlış veya register overflow
**Çözüm:** Syscall tablosunu ve register adlarını kontrol et

---

## 10. Değerlendirme Kriterleri

### Teknik Kriterler (60%)
- [ ] Colleen (C): ✅
- [ ] Colleen (ASM): ✅
- [ ] Grace (C): ✅
- [ ] Grace (ASM): ✅
- [ ] Sully (C): ✅
- [ ] Sully (ASM): ✅

### Kod Kalitesi (20%)
- [ ] Norm uyumluluğu
- [ ] Okunabilirlik
- [ ] Belgelendirme

### Tamamlık (20%)
- [ ] Makefile
- [ ] Test coverage
- [ ] Bonus

---

## 11. Kaynaklar ve Referanslar

### Resmi Dokümantasyon
- Quine tanımı: https://en.wikipedia.org/wiki/Quine_(computing)
- Norminette: École 42 intranet
- POSIX syscall'ları: `man 2 syscalls`

### Örnek Projeler
- https://github.com/Lunairi/42-Dr-Quine
- https://github.com/Mel-louie/dr-quine

### Teknik Kaynaklar
- x86-64 Architecture: Intel® 64 and IA-32 Architectures Manual
- NASM Manual: https://www.nasm.us/
- Linux syscall ABI: https://www.man7.org/linux/man-pages/

---

**Son Güncelleme:** 2026-05-01
**Versiyon:** 1.0
