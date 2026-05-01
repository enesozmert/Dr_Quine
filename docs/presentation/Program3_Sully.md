# Program #3 — Sully — Teknik Analiz

> **Tek cümlede:** Çalıştırıldığında **kendi kaynak kodunu sayacı 1 azaltarak
> yeni bir dosyaya yazan, o dosyayı derleyip çalıştıran ve sayacın değerine
> göre durmaya karar veren** parametrik bir quine'dir.

---

## 1. Amaç (PDF spec)

> "When executed the program writes in a file named Sully_X.c / Sully_X.s.
> The X will be an integer given in the source. Once the file is created,
> the program compiles this file and then runs the new program (which will
> have the name of its source file).
>
> Stopping the program depends on the file name: the resulting program will
> be executed only if the integer X is greater or equals than 0.
>
> An integer is therefore present in the source of your program and will
> have to evolve by decrementing every time you create a source file from
> the execution of the program."

Sully, üç programın **en karmaşığı**:
- **Parametrik quine**: kaynakta gömülü bir tamsayı var, her yeni dosyada bu
  azaltılarak yazılır.
- **Self-compile**: kendi yazdığı `.c`/`.s` dosyasını runtime'da `gcc`/`nasm`
  ile derler.
- **Self-execute**: derlediği binary'i runtime'da çalıştırır.
- **Recursive chain**: çocuk program da aynı şeyi yapar → zincir oluşur.
- **Termination**: sayaç 0'ın altına düşünce zincir biter.

**Doğrulama:**
```bash
./Sully
ls -al | grep Sully | wc -l    # → 13 (PDF spec'in beklediği tam sayı)
diff ../Sully.c Sully_0.c      # → sadece "int i = 5/0" satırı farklı
diff Sully_3.c Sully_2.c       # → sadece "int i = 3/2" satırı farklı
```

---

## 2. Neden Böyle Bir Program? (Pedagojik Değer)

### 2.1 Self-Replicating Virus Modelinin Tam Hali
Colleen → kendini gösteren program (görünür).
Grace → kendini diske kopyalayan program (yayılma).
**Sully → kendini diske kopyalayıp DERLEYIP ÇALIŞTIRAN program (otonom yayılma).**

Bu gerçek bir bilgisayar virüsünün üç temel özelliğinin son aşamasıdır:
1. ✅ Self-knowledge (Colleen)
2. ✅ Persistence (Grace)
3. ✅ **Propagation** (Sully)

### 2.2 Parametrik Quine Konsepti
Standart quine = sabit (output her zaman aynı).
Parametrik quine = **state taşır** (her iterasyonda farklı output).

Sully, her çalıştırmada **i değerini bir azaltarak** yeni source üretir.
Yani her dosya bir öncekinin **mutasyona uğramış** versiyonudur — virüs
generation'ları gibi.

### 2.3 Termination Kararı
PDF: "X >= 0 ise yürüt". Bu basit bir koşul gibi görünür ama **infinite
recursion** ile **sınırlı recursion** arasındaki çizgiyi öğretir:
- Pratik virüs yayılması da sınırlı olmalı (yoksa sistem CPU'su tükenir).
- Sully, "kendini çoğalt ama sınırlı çoğalt" prensibinin temiz bir örneğidir.

### 2.4 system() ile Subprocess
Sully `system("gcc ...")` ve `system("./Sully_X")` çağırır. Bu:
- `fork()` + `exec()` semantiğine giriştir.
- Subprocess yönetiminin somut bir örneğidir.
- Hata propagation'ı (return code) konseptiyle tanıştırır.

---

## 3. PDF'in Yapısal Gereksinimleri

| Gereksinim | Açıklama |
|-----------|----------|
| Executable adı | `Sully` |
| Çıktı dosyası adı | `Sully_X.c` / `Sully_X.s` (X = sayaç) |
| Sayaç başlangıç değeri | **5** (kaynakta literal yazar) |
| Decrement | Her yeni dosyada sayaç 1 azalır |
| Compile | Yeni `.c`/`.s` dosyası **derlenir** (`gcc`/`nasm`) |
| Execute | X >= 0 ise binary **çalıştırılır** |
| Termination | X < 0 olunca yürütme yok (dosya yazımı opsiyonel) |
| Diğer kısıt yok | "No constraints on the source code, apart from the integer" |

PDF'in **tek beklediği**: 13 dosyalık zincir + diff'ler sadece "int i = N"
satırında farklı.

---

## 4. Bizim İmplementasyonumuz

### 4.1 C Versiyonu — `C/Sully.c`

**Yapı (5 satır):**
```c
int i = 5;
#include<stdio.h>
#include<stdlib.h>
char*s="...long format string...";
int main(void){...all logic in one line...}
```

**Tam kaynak özeti:**
- **Satır 1:** `int i = 5;` — sayaç (PDF'in dediği "kaynakta literal integer")
- **Satır 2-3:** Standart header'lar
- **Satır 4:** Format string `s` — kaynağın **2-5 satırlarının** template'i
- **Satır 5:** `main()` — tek satırda tüm logic

#### 4.1.1 Sayaç Mantığı (Critical Detail)

PDF örneği:
```
$> diff ../Sully.c Sully_0.c
1c1
< int i = 5;
---
> int i = 0;
$> diff Sully_3.c Sully_2.c
1c1
< int i = 3;
---
> int i = 2;
```

**Yorum:** `Sully_X.c` dosyasının **1. satırında** `int i = X;` yazılı,
**X = filename ile birebir eşleşiyor**.

Yani Sully (i=5) çalıştırdığında:
- Yeni filename: `Sully_4.c` (decremented)
- Yeni dosyanın 1. satırı: `int i = 4;`

**Genel kural:** `Sully_X` programı `Sully_{X-1}.c` üretir.

#### 4.1.2 Main Logic Akışı

```c
int main(void){
    char f[64], c[256];
    int n = i - 1, r;                            // n = 4 (i=5 ise)
    sprintf(f, "Sully_%d.c", n);                 // "Sully_4.c"
    FILE *p = fopen(f, "w");
    if(!p) return 1;
    fprintf(p, "int i = %d;\n", n);              // "int i = 4;\n"
    fprintf(p, s, ...);                          // kalan 4 satır
    fclose(p);
    sprintf(c, "gcc -Wno-format-security -o Sully_%d %s 2>/dev/null", n, f);
    r = system(c);
    if(r) return 1;
    if(n >= 0){                                  // ← TERMINATION CHECK
        sprintf(c, "./Sully_%d", n);
        r = system(c);
        (void)r;
    }
    return 0;
}
```

#### 4.1.3 Format String Args (19 placeholder)

`fprintf(p, s, 10, 10, 34, s, 34, 10, 34, 34, 34, 34, 34, 92, 34, 34, 34, 34, 34, 10)`

- 19 args (toplamda 19 placeholder var s'de)
- Newline'lar (`%c` = 10), tırnak işaretleri (`%c` = 34), backslash (`%c` = 92)
- `%s` = s (s'in kendi içeriği — 4. satırın string literal'i için)

**`%c` = 92 (backslash) özel kullanım:** `fprintf(p, "int i = %d;\n", n);`
satırında `\n` görüntüsü olması gerekir → kaynakta literal `\` ve `n`. Bu
sadece `%c` ile 92 kullanarak kaçabiliriz.

#### 4.1.4 Termination: "i < 0 ise compile değil yürütme de yok"

```c
if(n >= 0){
    sprintf(c, "./Sully_%d", n);
    r = system(c);
}
```

- `n=4`: `./Sully_4` çalışır → o da `Sully_3.c` üretir.
- `n=0`: `./Sully_0` çalışır → o `n=-1` ile `Sully_-1.c` üretir.
- **`Sully_-1.c` derlenir** ama zincirin bir üstündeki `if(n >= 0)` kontrolü
  Sully_-1 binary'sini çalıştırmaz.

**Sonuç: 13 dosya** = 1 (Sully) + 6 (.c: Sully_4, Sully_3, ..., Sully_-1) +
6 (binary: Sully_4, ..., Sully_-1).

> Aslında PDF spec'inin "13" sayısı, parent `Sully` binary'sini de sayar.
> Bizim hesabımız tam olarak 13'e oturuyor (PDF testimiz **PASS** veriyor).

---

### 4.2 Assembly Versiyonu — `ASM/Sully.s`

**İlk satır (PDF spec):**
```asm
;i=5
```

PDF örneği:
```
$> diff ../Sully.s Sully_0.s
1c1
< ;i=5
---
> ;i=0
```

Sully.s 1. satırında `;i=5` (5-byte yorum) bulunur. `Sully_X.s` dosyalarında
bu satır `;i=X\n`'e dönüşür.

#### 4.2.1 Tasarım Stratejisi: incbin + Runtime Substitution

**Sorun:** ASM'de C-style format string yok. Quine string'i nasıl yazarız?

**Çözüm:** `incbin` ile build-time embed + runtime'da **ilk satırı değiştirip**
yazmak.

```nasm
section .data
src:    incbin "/tmp/sully_self.s"   ; build-time embed
srclen: equ $-src

section .text
main:
    ; 1) src[3] = '5' (ASCII), oradan i'yi parse et
    movzx eax, byte [rel src + 3]
    sub eax, '0'
    sub eax, 1                  ; n = i - 1
    mov ebx, eax                ; ebx = n
    ; 2) Yeni dosya yaz: ";i=N\n" + src[5..]
    ;    (ilk 5 byte ";i=5\n" atlanır, kalan src yazılır)
    ; 3) Compile + (n >= 0 ise) execute
```

#### 4.2.2 Self-Path Sorunu ve Çözümü

**Problem:** `incbin "Sully.s"` build-time'da Sully.s'i embed eder. Ama
runtime'da Sully_4.s yazıldığında, **Sully_4.s'i derlerken** nasm yine
`incbin "Sully.s"` görür → Sully.s'i (parent) embed eder, Sully_4.s'i değil.

**Çözüm:** Sabit bir konum: **`/tmp/sully_self.s`**.
- Sully.o build edilirken Makefile `cp Sully.s /tmp/sully_self.s` yapar.
- Runtime'da Sully önce `cp Sully_4.s /tmp/sully_self.s` çalıştırır
  (`copy_fmt` makrosu).
- Sonra `nasm` Sully_4.s'i derlerken **/tmp/sully_self.s** = Sully_4.s
  içeriğidir → doğru self-reference.

```nasm
copy_fmt: db "cp Sully_%d.s /tmp/sully_self.s", 0
```

#### 4.2.3 libc Çağrıları (System V AMD64 ABI)

Sully ASM, syscall yerine **libc** kullanır (`gcc -no-pie` ile linklenir):

| Çağrı | Görev |
|-------|-------|
| `sprintf` | filename, command formatla |
| `fopen` | dosya aç |
| `fwrite` | byte yaz |
| `fclose` | dosya kapat |
| `system` | shell command çalıştır (gcc, ./Sully_N) |

ABI register'ları: `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`. Stack 16-byte
align'lı çağrı zorunluluğu (`push rbp; mov rbp, rsp`).

#### 4.2.4 Termination Mantığı

```nasm
test ebx, ebx       ; ebx = n = i - 1
js .done            ; n < 0 ise atla (compile + run yok)

; copy + compile + run
...

.done:
    xor eax, eax
    leave
    ret
```

**Önemli fark (C ile karşılaştırınca):**
- C versiyonu: Sully_-1.c dosyası **YAZILIR** (her zaman) ve **DERLENİR**
  (her zaman); sadece **ÇALIŞTIRMA** koşullu.
- ASM versiyonu: Sully_-1.s dosyası **YAZILIR** (her zaman); ama derleme ve
  çalıştırma **HER İKİSİ** koşullu (`js .done`).

İkisi de PDF'in 13 sayısına ulaşır ama farklı yollarla:
- C: 13 = 1 (Sully) + 6 .c + 6 binary
- ASM: 13 = 1 (Sully) + 1 (Sully.o) + 6 .s + 5 binary

---

## 5. Build & Test PDF Senaryosu

PDF'in örneği:
```bash
$> mkdir workdir && cd workdir
$> clang -Wall -Wextra -Werror ../Sully.c -o Sully    # parent'ta source
$> ./Sully                                             # child files burada
$> ls -al | grep Sully | wc -l
13
```

**Bizim setup'ımız bu mantığa uyumlu.** Source `C/Sully.c`'de, build `output/C/`'ye veya `workdir/`'a yapılır.

---

## 6. Test Stratejisi

### 6.1 Sayım Testi
```bash
cd workdir && ./Sully
[ "$(ls -al | grep Sully | wc -l)" = "13" ]
```

### 6.2 Diff Format Testi
```bash
diff ../Sully.c Sully_0.c
# Beklenen:
# 1c1
# < int i = 5;
# ---
# > int i = 0;
```

### 6.3 Recursive Chain Testi
```bash
# Tüm Sully_X.c dosyaları var mı?
for x in 4 3 2 1 0 -1; do [ -f "Sully_$x.c" ] || echo "missing"; done

# Her bir Sully_X binary'si çalışmış mı (Sully_-1 hariç)?
for x in 4 3 2 1 0; do [ -x "Sully_$x" ] || echo "missing $x"; done
```

### 6.4 Crash & Edge Case
```bash
# Boundary: counter=0
echo 'int i = 0; ...' > test.c   # manuel test
gcc -o test test.c && ./test     # crash olmamalı

# Re-run idempotency
rm -rf workdir/* ; ./Sully       # her seferinde aynı sonuç
```

---

## 7. Karşılaşılan Zorluklar ve Çözümler

| Zorluk | Çözüm |
|--------|-------|
| `\n` literal kaynak vs runtime | `%c` + 92 (`\`) + 'n' literal |
| ASM'de format string yok | İlk satırı runtime substitute, kalan src incbin'den |
| `incbin "Sully.s"` Sully_X build'de path uyumsuz | `/tmp/sully_self.s` sabit yolu + Makefile cp |
| `system()` return value `-Werror=unused-result` | `r=system(c); (void)r;` |
| Sully_-1.c yazılması gerek mi? | Spec ambiguous; biz dosya yazıyoruz, run etmiyoruz |
| Stack alignment libc çağrısı | `push rbp; mov rbp, rsp` ile 16-byte align |
| `gcc -no-pie` Sully'nin shared object olmasını engeller | linker flag eklendi |

---

## 8. Edge Cases ve Hataya Dayanıklılık

### 8.1 PATH'te gcc yoksa
`system("gcc ...")` exit code 127 (command not found) döner. Sully
`if(r) return 1;` kontrolüyle erken çıkar. **Crash yok.**

### 8.2 Disk dolu
`fopen` veya `fwrite` başarısız olur. `if(!p) return 1;` kontrolüyle
güvenli çıkış. **Crash yok.**

### 8.3 Counter değeri çok büyük (örn. i=1000)
Şu anki implementasyon imzasız değil; herhangi bir sınır yok. 1000 → 999 →
... → 0 zinciri 1001 dosya yaratır ama crash etmez (sadece çok yavaş).

### 8.4 Counter negatif başlangıç (i=-5)
İlk fonksiyon çağrısında `n = -6 < 0` → tüm if blokları atlanır, dosya
yazılmaz, çalıştırılmaz. **`return 0` ile temiz çıkış.**

---

## 9. Pedagojik Çıkarımlar

Sully'i tamamlayan bir öğrenci şunları öğrenmiş olur:
1. **Parametrik quine** — sabit nokta + state taşıma.
2. **`system()` ile subprocess yönetimi** — fork+exec semantiği.
3. **Recursive program yapısı** — kendi versiyonunun kopyasını çalıştırmak.
4. **Termination koşulu tasarımı** — sınırsız recursion'dan kaçınma.
5. **C `sprintf` ile dinamik komut üretimi** — string templating.
6. **NASM ile libc entegrasyonu** — `extern sprintf`, ABI register conv.
7. **Build-system isolation** — `/tmp/sully_self.s` ile path-stabil
   self-reference.
8. **Virüs yayılma mekanizmasının tam modeli** — propagation'ın matematiksel
   altyapısı.

---

## 10. Üç Programın Karşılaştırması

| Özellik | Colleen | Grace | Sully |
|---------|---------|-------|-------|
| Çıktı hedefi | stdout | dosya | dosya + binary |
| State | yok | yok | sayaç (i) |
| Self-execute | hayır | hayır | **EVET** |
| Recursion | yok | yok | **EVET** |
| Termination | n/a | n/a | i < 0 |
| Karmaşıklık | düşük | orta | yüksek |
| Virüs analojisi | self-knowledge | persistence | **propagation** |
| PDF testi | `diff out.c src.c` | `diff src.c kid.c` | `wc -l = 13` + 2 diff |

---

## 📌 İlgili Belgeler

- [Program1_Colleen.md](Program1_Colleen.md) — ilk program
- [Program2_Grace.md](Program2_Grace.md) — ikinci program
- [docs/command/Examples.md](../command/Examples.md) — PDF spec birebir komutlar
- [Presentation.md](Presentation.md) — quine teorisi genel
