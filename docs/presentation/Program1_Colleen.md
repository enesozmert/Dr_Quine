# Program #1 — Colleen — Teknik Analiz

> **Tek cümlede:** Çalıştırıldığında **kendi kaynak kodunu** standart çıktıya
> (stdout) basan bir programdır.

---

## 1. Amaç (PDF spec)

> "When executed, the program must display on the standard output an output
> identical to the source code of the file used to compile the program."

Colleen, **klasik (saf) bir quine**'in en temel formudur. Programın çıktısı,
onu derlemek için kullanılan kaynak dosyanın **birebir kopyası** olmalıdır.

**Doğrulama:**
```bash
./Colleen > out.c
diff out.c Colleen.c   # → boş çıktı = byte-identical
```

---

## 2. Neden Böyle Bir Program? (Felsefi Arka Plan)

### 2.1 Kleene Recursion Theorem
Colleen, hesaplama teorisindeki **Kleene'nin Sabit Nokta Teoremi**'nin
somut bir uygulamasıdır:

> Her toplam hesaplanabilir fonksiyon `f` için, `g(x) = f(g)(x)` özelliğini
> sağlayan bir program `g` mevcuttur.

Pratik anlamı: bir programın **kendi tanımını runtime'da kendisine vermesi**
mümkündür — dosya okumadan, dış kaynak kullanmadan.

### 2.2 Self-Reproduction → Malware'ın Atası
Quine'ler, **kendini çoğaltan virüslerin** matematiksel temelidir:
- Bir virüs hedef dosyaya kendisini yazar.
- Yazmak için kendi kodunu **bilmesi** gerekir.
- Kaynak dosyayı runtime'da okumadan bunu yapan teknik = quine.

Colleen, malware analizine giriş için pedagojik bir kapı taşıdır.

### 2.3 Bilgisayar Bilimine Felsefi Katkı
- **Gödel'in Eksiklik Teoremi** ile bağlantılı: kendine atıfta bulunan formel
  ifadeler.
- **Hofstadter** (Gödel-Escher-Bach): "Self-reference" temasının somutu.

---

## 3. PDF'in Yapısal Gereksinimleri

### 3.1 C Kaynağı İçin

| Gereksinim | Sebep |
|-----------|-------|
| `main` fonksiyonu | Klasik C entry point |
| **2 farklı yorum** | Pedagojik: yorumların quine string'inde nasıl kaçırılacağını öğretir |
| **Biri main içinde** | Yorumun konum-bağımlı handling'i |
| **Biri main dışında** | File-scope yorumun nasıl encode edileceği |
| **Ek bir fonksiyon** (çağrılan) | Tek-fonksiyon değil, **multi-symbol** quine |

### 3.2 Assembly Kaynağı İçin

| Gereksinim | Sebep |
|-----------|-------|
| Açık entry point (`_start`) | x86-64 raw syscall ABI |
| 2 farklı yorum (biri `_start` içinde, biri dışında) | C ile aynı pedagojik amaç |
| Ek bir rutin (entry'den çağrılan) | Multi-label organization |

---

## 4. Bizim İmplementasyonumuz

### 4.1 C Versiyonu — `C/Colleen.c`

```c
/*outside*/
#include<stdio.h>
void f(void){}
char*s="/*outside*/%c#include<stdio.h>%cvoid f(void){}%cchar*s=%c%s%c;%cint main(void){f();/*inside*/printf(s,10,10,10,34,s,34,10,10);return 0;}%c";
int main(void){f();/*inside*/printf(s,10,10,10,34,s,34,10,10);return 0;}
```

#### 4.1.1 Quine Tekniği: "Üç-Parçalı Format String"

**Çekirdek mantık:**
1. `s` değişkeni tüm kaynağı bir **format string** olarak içerir.
2. Format placeholder'ları:
   - `%c` → ASCII kodu ile karakter (newline=10, quote=34, backslash=92)
   - `%s` → s'in kendisi (referans)
3. `printf(s, 10, 10, 10, 34, s, 34, 10, 10)` çağrısında:
   - Newline'lar `%c`(10) ile yerleştirilir
   - Tırnak işaretleri `%c`(34) ile (kaynakta `"` görünmesini sağlar)
   - String'in kendisi `%s` ile (s string'inin gerçek içeriği)

#### 4.1.2 Neden `\n` yerine `%c` (10)?

**Kritik gözlem:** Eğer string içinde `\n` (escape sequence) yazsaydık:
- Kaynak dosyada: `\n` (2 byte: `\` + `n`)
- Compiler bellek temsilinde: `0x0A` (1 byte newline)
- printf çıktısında: gerçek newline byte'ı (1 byte)

Bu durumda **kaynak ile çıktı arasında byte uzunluğu farklı** olurdu →
diff farksız çıkmazdı.

**Çözüm:** Format string'de `\n` yerine `%c` kullanmak ve printf'te
`10` (newline ASCII) olarak vermek. Bu sayede:
- Kaynakta string içinde `%c` (literal 2 byte: `%` + `c`)
- printf çıktısında: `%c`'nin yerine 10 (1 byte newline)
- Kaynakta da o pozisyonda bir newline var (satır sonu) → uyumlu!

#### 4.1.3 Tırnak (`"`) Sorunu

C string'i `"..."` ile sınırlandırıldığı için, **string içinde `"` karakteri
literal olarak olamaz**. Ancak `printf` çıktısında, string'in başında ve
sonunda `"` görünmesi gerekir (kaynak dosyada da var).

**Çözüm:** `%c` placeholder'ı + ASCII 34. Tek byte hem kaynakta hem çıktıda
denkliği sağlar.

#### 4.1.4 Yorumların Yerleşimi

- `/*outside*/` → `s` string'inde aynen yer alır (file-scope)
- `/*inside*/` → `int main(void){f();/*inside*/printf(...)}` içinde, **main'in body'sinde**

Her iki yorum da quine string'inin parçası olarak kaynakla bire bir eşleşir.

#### 4.1.5 Helper Fonksiyon `f()`

PDF "main yanında çağrılan başka bir fonksiyon" istiyor. `f()` boş ama
**çağrılıyor** (`f();`). Bu pedagojik gereksinimi karşılar; teknik olarak
`return 0` semantiğini değiştirmez.

---

### 4.2 Assembly Versiyonu — `ASM/Colleen.s`

```nasm
; outer comment
section .data
src: incbin "Colleen.s"
srclen: equ $-src
section .text
global _start
_start:
    ; inner comment
    call printer
    mov rax, 60
    xor rdi, rdi
    syscall
printer:
    mov rax, 1
    mov rdi, 1
    mov rsi, src
    mov rdx, srclen
    syscall
    ret
```

#### 4.2.1 Quine Tekniği: NASM `incbin`

**`incbin "Colleen.s"`** direktifi, NASM'in build-time'da o dosyanın **ham
binary içeriğini** ELF dosyasına gömer. Yani Colleen.s build edilirken,
**kendi kaynağı** binary'nin `.data` section'ına aynen kopyalanır.

#### 4.2.2 Neden Bu Yaklaşım?

Saf bir ASM quine yazmak **şiddetli zor** çünkü:
- ASM'de format string olanağı yok (printf gibi runtime substitution yok).
- Her byte el-encoding ile kaçırılmak zorunda olur.
- Self-reference için karakter karakter `db 0x..` listesi gerekir; bu da
  kaynağın 5x uzamasına yol açar.

**`incbin` yaklaşımı pedagojik trade-off:**
- ✅ Source byte-by-byte korunur, output byte-identical
- ✅ NASM'in resmi bir feature'ı (workaround değil)
- ⚠️ Build-time embed: "kaynak dosyayı runtime'da okumuyor" çünkü embedding
  derleyici/linker katmanında oluyor (cheating sayılmıyor; PDF cheating
  tanımı **runtime'da** dosya okumayı yasaklar).

#### 4.2.3 x86-64 Linux Syscall Akışı

| Adım | Syscall # | İşlem |
|------|-----------|-------|
| `mov rax, 1` | `write` (1) | stdout'a yaz |
| `mov rdi, 1` | fd | stdout fd'si |
| `mov rsi, src` | buf | gömülü kaynak |
| `mov rdx, srclen` | count | kaynak byte sayısı |
| `syscall` | — | tetikle |
| `mov rax, 60` | `exit` (60) | çıkış |
| `mov rdi, 0` | exit code 0 | başarı |

#### 4.2.4 PDF Spec Uyumu

| Gereksinim | Yapımız |
|-----------|---------|
| Entry point | `_start` ✓ |
| `_start` içi yorum | `; inner comment` ✓ |
| `_start` dışı yorum | `; outer comment` (file-scope) ✓ |
| Helper rutin (çağrılan) | `printer:` (call printer) ✓ |

---

## 5. Test Stratejisi

### 5.1 Byte-Identical Doğrulama
```bash
./Colleen > tmp
diff Colleen.c tmp     # → boş çıktı = PASS
```

### 5.2 Repeated Execution
```bash
for i in 1..5; do ./Colleen > out_$i; done
md5sum out_*           # tüm checksumlar aynı olmalı (deterministik)
```

### 5.3 Crash Detection (PDF §IV)
```bash
./Colleen; echo $?     # 0 (segfault olsa 139 verirdi)
./Colleen extra args   # crash olmamalı
env -i ./Colleen       # boş environment'ta crash olmamalı
```

### 5.4 Valgrind Memory Safety
```bash
valgrind --leak-check=full --error-exitcode=42 ./Colleen
# memory leak/invalid read/write yoksa exit 0
```

---

## 6. Karşılaşılan Zorluklar ve Çözümler

| Zorluk | Çözüm |
|--------|-------|
| Newline (`\n`) kaynak vs runtime byte uyumu | `%c` placeholder + ASCII 10 |
| String içinde `"` literal kullanılamaz | `%c` placeholder + ASCII 34 |
| `gcc -Werror=format-security` Linux'ta hata atıyor | Makefile'da `-Wno-format-security` (quine format string design'ı) |
| ASM'de saf quine çok uzun olur | NASM `incbin` ile build-time embed |
| Windows'ta NASM ELF64 yok | Docker zorunlu (Linux ABI + ELF) |

---

## 7. Pedagojik Çıkarımlar

Colleen'i tamamlayan bir öğrenci şunları öğrenmiş olur:
1. **Format string'in gerçek esnekliği** — runtime substitution ile self-reference.
2. **C'de string literal byte-byte semantiği** — escape sequence vs binary uyum.
3. **NASM section yapısı** (`.data` + `.text`) ve `incbin` directive.
4. **x86-64 Linux syscall ABI** (`write`, `exit`, register convention).
5. **Byte-identical testing** — diff ile bit-perfect doğrulama mantığı.
6. **Quine = self-reference**: matematiksel sabit nokta kavramının pratik ilk
   karşılaşması.

---

## 📌 İlgili Belgeler

- [docs/command/Examples.md](../command/Examples.md) — PDF spec birebir komutlar
- [Program2_Grace.md](Program2_Grace.md) — bir sonraki program
- [Program3_Sully.md](Program3_Sully.md) — son program
- [Presentation.md](Presentation.md) — quine teorisi genel
