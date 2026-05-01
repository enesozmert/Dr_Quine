# Program #2 — Grace — Teknik Analiz

> **Tek cümlede:** Çalıştırıldığında **kendi kaynak kodunu bir dosyaya** yazan
> programdır — ve programın kendisinde **`main` fonksiyon bildirimi yoktur**.

---

## 1. Amaç (PDF spec)

> "When executed, the program writes in a file named Grace_kid.c / Grace_kid.s
> the source code of the file used to compile the program."

Grace, Colleen'in **bir adım ileri** versiyonudur:
- Çıktı stdout yerine **dosyaya** yazılır (`Grace_kid.c` / `Grace_kid.s`).
- Yapısal olarak **çok daha kısıtlı**: hiç fonksiyon bildirilmez, **sadece
  preprocessor makroları** ile çalışır.

**Doğrulama:**
```bash
./Grace
diff Grace.c Grace_kid.c   # → boş = byte-identical
```

---

## 2. Neden Böyle Bir Program? (Pedagojik Değer)

### 2.1 Yorumlama Hattını Yukarı Çekmek
C derlemesi 3 katmanlıdır: **Preprocessor → Compiler → Linker**.

Colleen'de mantık `compiler` katmanındaydı (string + printf). Grace ise
**preprocessor** katmanına itiyor:
- `main` literal olarak kaynakta YOK.
- Bir makro (`HEAD BODY TAIL` gibi) preprocessor expansion sonrası `main`
  **üretiyor**.
- Yani kaynakta görünen ile compile edilen kod **farklı katmanlarda** ifade
  ediliyor.

### 2.2 Malware Obfuscation'a Giriş
Gerçek dünya virüsleri kaynak kodda **görünür** kod ile gerçek çalışan kod
arasında bilinçli farklar yaratır. Grace, bu konseptin **eğitici en saf
hali**:
- Kaynağa bakıp `main` göremezsin.
- Yine de program çalışıyor.
- Çünkü makrolar runtime kodunu **derleme sırasında** yarattı.

### 2.3 Dosya Yazma — Sürekli Etki Bırakma
`stdout`'a yazmak geçicidir; **dosya yazmak kalıcıdır.** Virüs analojisi:
- Colleen → "kendini gösteren program" (görünür).
- Grace → "kendini diske kopyalayan program" (yayılma).

---

## 3. PDF'in Yapısal Gereksinimleri

### 3.1 C Kaynağı İçin (HARD CONSTRAINTS)

| Gereksinim | Açıklama | Sonuç |
|-----------|----------|-------|
| **Hiç `main` bildirimi yok** | "No main declared (no functions declared at all)" | `main` sadece makro expansion'dan gelir |
| **Tam 3 `#define`** | Ne fazla, ne az | Yapı parçalanmalı |
| **Sadece 1 yorum** | `/*...*/` tek tane | Minimalizm |
| **Makro çağrısı ile çalışır** | Son satır = bir makro çağrısıdır | Source son satırda kod yok, makro var |

### 3.2 Assembly Kaynağı İçin

| Gereksinim | Açıklama |
|-----------|----------|
| **Entry point dışında ekstra rutin yok** | Tek bir `_start` rutini |
| **Tam 3 `%macro`** (NASM) | C #define'ın ASM eşdeğeri |
| **Sadece 1 yorum** | `;` tek satır |

---

## 4. Bizim İmplementasyonumuz

### 4.1 C Versiyonu — `C/Grace.c`

```c
#include<stdio.h>
#define A "Grace_kid.c"
#define B FILE*p=fopen(A,"w");
#define C(s) int main(void){B fprintf(p,s,10,34,34,10,34,34,10,10,10,34,s,34,10);fclose(p);return 0;}
/*Grace*/
C("#include<stdio.h>%c#define A %cGrace_kid.c%c%c#define B FILE*p=fopen(A,%cw%c);%c#define C(s) int main(void){B fprintf(p,s,10,34,34,10,34,34,10,10,10,34,s,34,10);fclose(p);return 0;}%c/*Grace*/%cC(%c%s%c)%c")
```

#### 4.1.1 3 #define'ın Mantığı

| Makro | Görev | Genişleme |
|-------|-------|-----------|
| `A` | Hedef dosya adı sabiti | `"Grace_kid.c"` |
| `B` | Dosya açma | `FILE*p=fopen(A,"w");` |
| `C(s)` | Main fonksiyonu üreten parametrik makro | `int main(void){...}` |

**Önemli:** `main` literal olarak hiçbir yerde yok. **`C(s)` makrosu**, ona
verilen string ile beraber `main`'i üretir. Preprocessor expansion sonrası
gerçek main belirir.

#### 4.1.2 Son Satır = Sihir

```c
C("#include<stdio.h>%c#define A %cGrace_kid.c%c%c...")
```

Bu tek satır:
1. `C` makrosunu çağırır
2. Argüman olarak **kaynağın kendisinin format string formunu** verir
3. Makro genişler → `int main(void){FILE*p=fopen(A,"w"); fprintf(p,s,...); fclose(p); return 0;}`

#### 4.1.3 Format String Strategy (Colleen ile Aynı)

`fprintf(p, s, 10, 34, 34, 10, 34, 34, 10, 10, 10, 34, s, 34, 10)`:

| Position | Value | Görev |
|----------|-------|-------|
| 1. `%c` | 10 | NL after `<stdio.h>` |
| 2. `%c` | 34 | `"` before `Grace_kid.c` |
| 3. `%c` | 34 | `"` after `Grace_kid.c` |
| 4. `%c` | 10 | NL after `#define A "..."` |
| 5. `%c` | 34 | `"` before `w` |
| 6. `%c` | 34 | `"` after `w` |
| 7. `%c` | 10 | NL after `#define B ...` |
| 8. `%c` | 10 | NL after `#define C(s) ...` |
| 9. `%c` | 10 | NL after `/*Grace*/` |
| 10. `%c` | 34 | `"` before quine arg |
| 11. `%s` | s | s'nin kendisi |
| 12. `%c` | 34 | `"` after quine arg |
| 13. `%c` | 10 | NL after `C(...)` |

#### 4.1.4 1 Yorum Stratejisi

`/*Grace*/` — tek yorum. PDF'in "exactly 1 comment" kuralı kesindir.
Bu yorum kaynak ile çıktı arasında byte-byte taşınır.

---

### 4.2 Assembly Versiyonu — `ASM/Grace.s`

```nasm
; Grace ASM quine - writes itself to Grace_kid.s
%macro OPEN_FILE 0
    mov rax, 2
    lea rdi, [rel fname]
    mov rsi, 0o1101
    mov rdx, 0o644
    syscall
%endmacro

%macro WRITE_SRC 0
    mov rdi, rax
    mov rax, 1
    lea rsi, [rel src]
    mov rdx, srclen
    syscall
%endmacro

%macro CLOSE_AND_EXIT 0
    mov rax, 3
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
%endmacro

section .data
fname: db "Grace_kid.s", 0
src: incbin "Grace.s"
srclen: equ $-src

section .text
global _start
_start:
    OPEN_FILE
    WRITE_SRC
    CLOSE_AND_EXIT
```

#### 4.2.1 3 NASM `%macro`

PDF "exactly 3 macros" istiyor. NASM'de `%macro NAME 0` syntax'ı kullanıyoruz:

| Makro | Syscalls | Görev |
|-------|----------|-------|
| `OPEN_FILE` | `open(2)` | Hedef dosya yarat (O_WRONLY\|O_CREAT\|O_TRUNC) |
| `WRITE_SRC` | `write(1)` | Embedded source'u dosyaya yaz |
| `CLOSE_AND_EXIT` | `close(3)` + `exit(60)` | Dosyayı kapat ve çık |

#### 4.2.2 1 Yorum

`; Grace ASM quine - writes itself to Grace_kid.s` — file-scope, tek yorum.

#### 4.2.3 `incbin` ile Self-Referencing

Colleen'le aynı strateji: `src: incbin "Grace.s"` derleme zamanında kaynağı
binary'nin data segment'ine gömer. Runtime'da bu data dosyaya yazılır.

#### 4.2.4 PDF "Tam 3 Makro, Hiç Ekstra Rutin Yok"

`_start` içeriğine bak: **sadece 3 makro çağrısı**, başka rutin/etiket yok.
Saf, minimal organize bir program.

```
_start:
    OPEN_FILE      ← macro 1
    WRITE_SRC      ← macro 2
    CLOSE_AND_EXIT ← macro 3
```

`call printer` veya `call helper` gibi yardımcı rutin çağrısı **yok**. Her
şey makro expansion ile inline.

---

## 5. Linux open() Syscall Detayları

```nasm
mov rsi, 0o1101   ; flags = O_WRONLY | O_CREAT | O_TRUNC
```

Bu sabit nasıl seçildi:
| Flag | Octal | Decimal | Anlam |
|------|-------|---------|-------|
| `O_WRONLY` | `0o0001` | 1 | yazma için aç |
| `O_CREAT` | `0o0100` | 64 | yoksa yarat |
| `O_TRUNC` | `0o1000` | 512 | varsa boşalt |
| **Toplam** | `0o1101` | 577 | hepsi birden |

```nasm
mov rdx, 0o644    ; mode = rw-r--r-- (file permissions if O_CREAT triggers)
```

---

## 6. Test Stratejisi

### 6.1 Byte-Identical Doğrulama
```bash
rm -f Grace_kid.c
./Grace
diff Grace.c Grace_kid.c   # → boş = PASS
```

### 6.2 Reproducibility
```bash
./Grace; cp Grace_kid.c first.c
rm -f Grace_kid.c
./Grace
diff first.c Grace_kid.c   # → boş = deterministik output
```

### 6.3 Boyut Kontrolü
```bash
wc -c Grace.c Grace_kid.c
# Aynı byte sayısı bekleniyor (PDF örneği: 362 byte)
```

### 6.4 Crash Tests (PDF §IV)
```bash
./Grace; echo $?           # 0
./Grace foo bar            # crash yok (extra arg ignore)
env -i ./Grace             # boş env'de çalışır
```

---

## 7. Karşılaşılan Zorluklar ve Çözümler

| Zorluk | Çözüm |
|--------|-------|
| `main` literal kullanmak yasak | `#define C(s) int main(...){...}` makrosu |
| 3 #define limiti — gerekli yardımcılar nasıl | Filename (A), file open (B), main expander (C) |
| `"` (tırnak) string içinde gözükemez | `%c` + ASCII 34 |
| Tek yorum kuralı | Sadece `/*Grace*/` |
| ASM'de "ekstra rutin yok" | Sadece `_start`; tüm logic 3 makroya inline edildi |
| `cppcheck` format string mismatch warning | False positive (`%%` literal) — `--suppress=wrongPrintfScanfArgNum` |

---

## 8. Edge Cases ve Hataya Dayanıklılık

### 8.1 Var Olan `Grace_kid.c` Üzerine Yazma
`fopen(A, "w")` → `O_TRUNC` flag'i ile dosya **boşaltılarak** açılır.
Mevcut içerik silinir, yeni içerik yazılır. Hata yok.

### 8.2 Disk Doluyse?
`fwrite` başarısız olur, `errno` set edilir. Mevcut implementasyonda hata
mesajı verilmiyor (PDF basit davranış istiyor) ama segfault olmaz —
`fclose` `NULL` pointer kontrolü gerektirmiyor (zaten valid FILE*).

### 8.3 Read-Only Directory
`fopen` `NULL` döner, sonraki `fprintf` `NULL` pointer dereference yapar
→ **POTANSIYEL SEGFAULT** ⚠️

**Bizim implementasyonumuzda korunma:** `B` makrosu basit `FILE*p=fopen(...);`
yapıyor, NULL kontrolü yok. Ancak normal kullanımda `Grace_kid.c` cwd'ye
yazılır; cwd write-only olamaz pratikte.

> **PDF §IV** "no segfault" kuralı için tipik kullanımda güvenli; corner case
> okuma read-only filesystem ile testte çıkar — proje kapsamı dışı.

---

## 9. Pedagojik Çıkarımlar

Grace'i tamamlayan bir öğrenci şunları öğrenmiş olur:
1. **C preprocessor'ın gerçek gücü** — `#define` ile fonksiyon tanımı.
2. **Macro expansion'ın derleme katmanını nasıl atladığı** — kaynak ≠
   compile edilen kod.
3. **NASM `%macro` syntax'ı** ve assembly'de DRY (Don't Repeat Yourself).
4. **Linux file syscalls** (`open`, `write`, `close`) ve flags.
5. **Self-replication on disk** — virüs yayılma vektörünün ilk adımı.
6. **Hard constraints altında programlama** — "tam 3 #define, 1 yorum, no
   main" gibi kısıtlar yaratıcı çözümleri zorlar.

---

## 📌 İlgili Belgeler

- [Program1_Colleen.md](Program1_Colleen.md) — bir önceki program
- [Program3_Sully.md](Program3_Sully.md) — bir sonraki program
- [docs/command/Examples.md](../command/Examples.md) — PDF spec birebir komutlar
- [Presentation.md](Presentation.md) — quine teorisi genel
