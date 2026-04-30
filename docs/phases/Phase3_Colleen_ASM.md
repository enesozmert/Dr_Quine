# Aşama 3: Colleen (Assembly Versiyonu)

**Başlangıç:** 2026-05-01  
**Hedef Tamamlanma:** -  
**Durum:** ⏳ Başlanmadı

---

## Aşama Özeti

Colleen'in Assembly (x86-64) versiyonu yazılacak. C versiyonuyla aynı işlevselliği sağlamalı: **kendisini oluşturan kaynak kodunu stdout'a yazdırmalı.**

**Güçlük Seviyesi:** ⭐⭐⭐ (Zor - Assembly, syscall'lar)

**Ön Koşul:** Aşama 2 (Colleen C) tamamlanmış olmalı

---

## Temel Gereksinimler

### Tanım
- Quine programı (çıktısı kendi kaynak kodu)
- **Assembly (x86-64 NASM syntax)**
- Hiçbir C kütüphanesi yok (pure syscall'lar)
- Stdout'a kendi kaynak kodunu yazdırır
- Exit code 0

### Doğrulama Komutu
```bash
./colleen > output.s
diff output.s src/colleen.s
# Sonuç: 0 (aynı olmalı)
```

### Exit Code
- **0:** Başarılı
- **Non-zero:** Hata (stdout'a kısmi çıktı verilmiş olsa bile)

---

## Ön Bilgiler

### x86-64 Mimarisi
- **64-bit** işlemci
- **Register'lar:** rax, rbx, rcx, rdx, rsi, rdi, r8-r15
- **System V AMD64 ABI:** Linux x86-64 calling convention

### NASM Syntax
```nasm
; Comments are here
section .data
	msg:	db "Hello", 0   ; byte array, null-terminated

section .text
	global _start
	
_start:
	mov rax, 1          ; syscall number: write
	mov rdi, 1          ; fd: stdout
	mov rsi, msg        ; buffer pointer
	mov rdx, 5          ; count
	syscall
	
	mov rax, 60         ; syscall number: exit
	mov rdi, 0          ; exit code
	syscall
```

### Syscall Tablosu (x86-64 Linux)

| İşlem | rax | rdi | rsi | rdx | Açıklama |
|-------|-----|-----|-----|-----|----------|
| **write** | 1 | fd | *buf | count | stdout'a yaz |
| **exit** | 60 | code | - | - | Program çık |

**Syscall Çağırma:**
```nasm
syscall        ; rax içindeki numarayı çağır
```

---

## Implementasyon Adımları

### 1. Dosya Yapısını Oluştur

**Dosya:** `src/colleen.s`

```nasm
; ========================================================================
; colleen.s - Assembly Quine (x86-64)
; ========================================================================

section .data
	; Quine string tanımlanacak

section .text
	global _start
	
_start:
	; Quine mekanizması burada
	
	; Exit syscall
	mov rax, 60
	mov rdi, 0
	syscall
```

---

### 2. Data Section'u Hazırla

Quine string'i `.data` section'una yazılmalı:

```nasm
section .data
	quine:	db "... quine string ...", 0
	len:	equ $ - quine
```

**Not:** String'in kendisi tüm kaynak kodu içermelidir!

---

### 3. Quine Mekanizması (Assembly Versiyonu)

Assembly'de quine yazmanın temel fikri:
1. String'i stdout'a yaz (`write` syscall)
2. String'in kendi kodu tanımında görünür hale gelir

**Zorluk:** String'in kendisi hex değerleri, escape'ler içermelidir.

**Alternatif Yaklaşım:**
- Data section'daki string'i oku
- Her karakteri stdout'a yaz
- Karakterleri ASCII hex olarak yazma (self-reference için)

---

### 4. Write Syscall'ı Çağır

```nasm
mov rax, 1          ; write syscall
mov rdi, 1          ; stdout file descriptor
mov rsi, quine      ; buffer address
mov rdx, len        ; buffer length
syscall             ; execute
```

---

### 5. Exit Syscall'ı Çağır

```nasm
mov rax, 60         ; exit syscall
mov rdi, 0          ; exit code
syscall             ; execute
```

---

## Derleme Adımları

### Adım 1: NASM ile Derleme

```bash
nasm -f elf64 src/colleen.s -o obj/colleen.o
# -f elf64: 64-bit ELF format
# -o: output dosyası
```

**Kontrol:**
```bash
ls -l obj/colleen.o
```

### Adım 2: Linking (Bağlama)

```bash
ld obj/colleen.o -o colleen
# ld: GNU linker
# Pure syscall'lar için C kütüphanesi gerekli değil
```

**Alternatif (GCC ile linking):**
```bash
gcc -o colleen obj/colleen.o
```

---

## Test Adımları

### Test 1: Çalıştırma

```bash
./colleen
# Ekranda Assembly kaynak kodu görülmeli
```

**Beklenen Çıktı:**
```
; ========================================================================
; colleen.s - Assembly Quine (x86-64)
; ========================================================================
...
(tüm kaynak kodu)
```

### Test 2: Doğruluk Testi

```bash
./colleen > test_colleen.s
diff test_colleen.s src/colleen.s
echo $?
# Sonuç: 0 olmalı
```

### Test 3: Byte-for-Byte Karşılaştırma

```bash
./colleen | xxd > /tmp/out.hex
cat src/colleen.s | xxd > /tmp/src.hex
diff /tmp/out.hex /tmp/src.hex
```

---

## Olası Sorunlar ve Çözümleri

### Sorun 1: NASM Syntax Hatası
**Belirti:** `nasm: error at line X`  
**Çözüm:** 
- NASM syntax kurallarını kontrol et
- Sections (`.data`, `.text`) doğru mu?
- Labels ve operand'lar doğru mu?

### Sorun 2: Linking Hatası
**Belirti:** `ld: cannot find entry point`  
**Çözüm:**
- `global _start` tanımlanmış mı?
- Başlangıç adresi `_start` etiketine işaret mi?

### Sorun 3: Segmentation Fault (SIGSEGV)
**Belirti:** Program crash oluyor  
**Çözüm:**
- Register'ları kontrol et (rdi, rsi, rdx doğru mu?)
- Bellek adreslerini kontrol et (rsi = quine adresi)
- String uzunluğu doğru mu?

### Sorun 4: Çıktı Yanlış
**Belirti:** `diff` farklılıklar gösteriyor  
**Çözüm:**
- String'in tamamı stdout'a yazıldı mı?
- Trailing newline var mı?
- Hex escape sequence'ler doğru mu?

### Sorun 5: GDB ile Debug

```bash
gdb ./colleen
(gdb) disassemble _start
(gdb) stepi            # Step instruction
(gdb) registers         # Register değerleri göster
(gdb) x/s $rsi         # rsi'daki string'i göster
```

---

## Makefile Güncellemesi

Makefile'a Assembly hedefi eklenecek:

```makefile
# Assembly compilation rule
$(OBJDIR)/%.o: $(SRCDIR)/%.s | $(OBJDIR)
	nasm -f elf64 $< -o $@

# Assembly executable rule
colleen: $(OBJDIR)/colleen.o | $(OUTDIR)
	ld $^ -o $@
```

---

## Norm/Standards Kontrolleri

Assembly dosyaları `norminette` tarafından kontrol edilmez, ama yine de:

- [ ] **Yorum Bloğu:** Başında 42 style comment
- [ ] **Açık İsimlendirme:** Labels ve sections net
- [ ] **Okunabilirlik:** İyi düzenlenmiş, indented
- [ ] **Dokumentasyon:** Önemli bölümler comment'lenmiş

---

## Test Checklist

- [ ] **NASM Derleme:** `nasm -f elf64 src/colleen.s -o obj/colleen.o` başarılı
- [ ] **Linking:** `ld obj/colleen.o -o colleen` başarılı
- [ ] **Çalışma:** `./colleen` crash etmez
- [ ] **Çıktı Testi:** `./colleen > test.s && diff test.s src/colleen.s`
- [ ] **Exit Code:** `echo $?` = 0
- [ ] **Tekrar Çalıştırma:** Deterministic (aynı çıktı)

---

## Kaynaklar

| Kaynak | Link/Yer |
|--------|----------|
| **NASM Manual** | https://www.nasm.us/ |
| **x86-64 Syscalls** | https://www.man7.org/linux/man-pages/man2/syscalls.2.html |
| **System V AMD64 ABI** | https://gitlab.com/x86-psABI/x86-64-ABI |
| **Assembly Quine'ler** | Proje dokümantasyonu |
| **Proje Kuralları** | [Rules.md](../rules/Rules.md) § Assembly |

---

## C vs Assembly Karşılaştırması

| Özellik | C Versiyonu | Assembly Versiyonu |
|---------|-------------|-------------------|
| **Dosya** | src/colleen.c | src/colleen.s |
| **Derleme** | gcc | nasm |
| **Linking** | gcc | ld |
| **Syscall'lar** | printf (library) | write (direct syscall) |
| **Zorluk** | ⭐⭐ | ⭐⭐⭐ |
| **Performans** | Daha hızlı | Daha da hızlı |

---

## Aşama Bitince Kontrolü

Aşama 3 bittiğinde:
- [ ] `src/colleen.s` mevcut ve çalışıyor
- [ ] `./colleen > out.s && diff out.s src/colleen.s` = başarılı
- [ ] `nasm -f elf64 src/colleen.s -o obj/colleen.o` = başarılı
- [ ] `ld obj/colleen.o -o colleen` = başarılı
- [ ] Git commit yapıldı

**Sonraki Aşama:** Aşama 4 - Grace (C Versiyonu)

---

**Son Güncelleme:** 2026-05-01
