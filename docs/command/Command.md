# Dr_Quine — Program Komutları

Bu dosya, Dr_Quine projesinde yazılması gereken üç ana quine programının detaylı açıklamalarını içerir.

---

## Giriş

Quine, çıktısı kendi kaynak koduna eşit olan bir programdır. Dr_Quine projesi, bu kavramı üç farklı varyasyonda uygulamayı gerektirir.

Her program **C dilinde** ve **Assembly (x86-32 / x86-64)** dilinde yazılmalıdır.

Proje yapısı:
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
    │   └── grace.s (veya grace.asm)
    └── Sully/
        ├── Makefile
        └── sully.s (veya sully.asm)
```

---

## 1. Colleen — Basit Quine

### Tanım
Colleen, en temel quine programıdır. Çalıştırıldığında, kendini oluşturan kaynak kodunu **standart çıktıya (stdout)** yazmalıdır.

### Kullanım
```bash
cd Dr_Quine/C/Colleen
make
./Colleen
# Çıktı: Colleen programının kaynak kodu
```

### Gereksinimler
- **Çalıştırılabilir adı:** `Colleen`
- **Çıktı:** stdout'a yazılan kaynak kod
- **Kontrol:** `./Colleen > output.c && diff output.c colleen.c` (output ve kaynak aynı olmalı)
- **Kısıtlamalar:**
  - Program dosyasının içeriğine erişemez (dosyaya bakamaz)
  - Stdin okuyamaz
  - Başka programları çalıştıramaz
  - Kaynak kodu hardcode etmek için yaratıcı teknikler gerekir

### İpuçları
- String operasyonları (printf format strings) ve escape sequence'leri anlamanız gerekir
- C'de self-replicating kod yazmak için karakter ve string manipülasyonu önemlidir
- Assembly'de ise syscall'lar ve register manipülasyonu kullanılır

### Örnek Kontrol Edişi
```bash
# C versiyonu
cd C/Colleen
make re
./Colleen > test_output.c
diff -q test_output.c colleen.c
echo "Aynıysa: OK"

# Assembly versiyonu
cd ../../ASM/Colleen
make re
./Colleen > test_output.s
diff -q test_output.s colleen.s
echo "Aynıysa: OK"
```

---

## 2. Grace — Dosyaya Yazma Quine

### Tanım
Grace, Colleen'e benzese de bir farkı vardır: kaynak kodunu **standart çıktı yerine bir dosyaya yazar.**

Grace çalıştırıldığında, `Grace_kid.c` (C versiyonunda) veya `Grace_kid.s` (Assembly versiyonunda) adında bir dosya oluşturmalı ve bu dosya Grace'in kendi kaynak kodunun bir kopyası olmalıdır.

### Kullanım
```bash
cd Dr_Quine/C/Grace
make
./Grace
ls -la Grace_kid.c
cat Grace_kid.c
```

### Gereksinimler
- **Çalıştırılabilir adı:** `Grace`
- **Çıktı dosyası:**
  - C: `Grace_kid.c`
  - Assembly: `Grace_kid.s`
- **Kontrol:** `diff grace.c Grace_kid.c` (dosyalar aynı olmalı)
- **Davranış:**
  - Program çalıştırıldığında, belirtilen dosyayı oluşturur
  - Dosya Grace'in kaynak kodunun bir kopyasıdır
  - Stdout'a hiçbir şey yazılmaz

### Kısıtlamalar
- Kaynak dosyaya doğrudan erişemez
- Dosya yazma işlemlerini manuel olarak yönetmek gerekir

### İpuçları
- **C:** `open()`, `write()`, `close()` syscall'ları veya `fopen()`, `fprintf()`, `fclose()` kullanılabilir
- **Assembly:** Dosya yazma için syscall'lar (write, open)

### Örnek Kontrol Edişi
```bash
cd C/Grace
make re
./Grace
diff grace.c Grace_kid.c
echo "Aynıysa: OK"

# Dosya silinir ve tekrar çalıştırılabilir
rm Grace_kid.c
./Grace
diff grace.c Grace_kid.c
```

---

## 3. Sully — Öz-Çoğalma ve Azalma

### Tanım
Sully, Dr_Quine'in en karmaşık programıdır. Sully kendini **değiştirilmiş bir şekilde** kopyalar:
- Kaynak kodunda bir **sayaç (counter)** bulunur
- Her çalıştırmada, sayaç **bir azalır**
- Belirtilen dosyada (`Sully_N.c` veya `Sully_N.s`, N = sayaç) yeni bir program oluşturulur
- Sayaç 0'a ulaştığında, program durdurulur

### Kullanım
```bash
cd Dr_Quine/C/Sully
make
./Sully
# Sully_4.c oluşturulur (sayaç = 4, Sully.c'de sayaç = 5 ise)

cd Sully_4
./Sully_4
# Sully_3.c oluşturulur

# ... devam eder ...

cd Sully_0
./Sully_0
# Hiçbir şey yazılmaz (sayaç = 0 oldukça)
```

### Gereksinimler
- **Çalıştırılabilir adı:** `Sully`
- **Dosya isimlendirmesi:**
  - C: `Sully_N.c` (N = mevcut sayaç)
  - Assembly: `Sully_N.s`
- **Sayaç değeri:** Başlangıçta 8 olmalı (projeye göre değişebilir)
- **Durdurma Koşulu:** Sayaç 0 olunca, daha fazla dosya oluşturulmaz

### Kısıtlamalar
- Her seferinde sayaç azaltılmalı ve yeni dosya oluşturulmalı
- Oluşturulan dosya çalıştırılabilir olmalı

### İpuçları
- Kaynak kodun içinde sayacı dinamik olarak değiştirmen gerekir
- String formatting ve dosya yazma işlemleri gerekir
- Öz-referansiyal kod yazmanın ötesinde, **parametrik quine** yazmalısın

### Örnek Kontrol Edişi
```bash
cd C/Sully
make re
./Sully
# Sully_8.c oluşturulur (veya konfigüre edilen değer)

cd Sully_8
make
./Sully
# Sully_7.c oluşturulur

# ... devam ederken ...
cd Sully_1
make
./Sully
# Sully_0.c oluşturulur

cd Sully_0
make
./Sully
# Dosya oluşturulmaz
```

---

## Özet Tablo

| Program | Çıktı Hedefi | Sayaç | Dosya Adı | Durdurma |
|---------|-------------|--------|-----------|----------|
| **Colleen** | stdout | Yok | - | N/A |
| **Grace** | Dosya | Yok | Grace_kid.{c\|s} | N/A |
| **Sully** | Dosya | Var (8'den başlayan) | Sully_N.{c\|s} | Sayaç = 0 |

---

## Notlar

1. **Norm Uyumluluğu:** Tüm C dosyaları École 42 Norminette kurallarına uymalıdır (bkz. [NORMCHECK.md](../normcheck/NORMCHECK.md))
2. **MISRA C:2012:** Cppcheck ve MISRA kurallarına dikkat (bkz. [CPPCHECK-MISRA-C2012.md](../cppcheck/CPPCHECK-MISRA-C2012.md))
3. **İşletim Sistemi:** Assembly kodunda hedef platform (x86-32 veya x86-64) belirtilmelidir
4. **Makefile:** Her klasörde zorunlu hedefler bulunmalıdır: `all`, `clean`, `fclean`, `re`

---

## Referanslar

- Quine tanımı: https://en.wikipedia.org/wiki/Quine_(computing)
- Kleene'nin Öz-Referans Teoremi: Recursion theory ve self-replication kavramları
- École 42 Dr_Quine Projesi: https://github.com/Lunairi/42-Dr-Quine (örnek referans)
