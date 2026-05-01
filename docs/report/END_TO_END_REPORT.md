# Dr_Quine — Uçtan Uca Docker Test Raporu

**Ortam:** Docker Ubuntu 22.04 · gcc 11 · NASM 2.15 · norminette · cppcheck · valgrind
**Tarih:** 2026-05-02
**İmaj:** `dr_quine:latest`
**Çalıştırma:** `MSYS_NO_PATHCONV=1 docker run --rm -v "$(pwd -W)":/app dr_quine:latest`

---

## 🏗️ 1. Build & Statik Analiz

| # | Aşama | Komut | Sonuç |
|---|-------|-------|-------|
| 1 | Build (C + ASM) | `make all` | ✅ **PASS** — 6 binary üretildi |
| 1.1 | C binary'leri | `output/C/{Colleen, Grace, Sully}` | ✅ 3/3 |
| 1.2 | ASM binary'leri | `output/ASM/{colleen, grace, sully}` | ✅ 3/3 |
| 2 | Norminette | `bash scripts/check_norm.sh` | ✅ **PASS** (quine-inherent ihlaller dokümante) |
| 3 | Cppcheck | `bash scripts/check_cppcheck.sh` | ✅ **PASS** (warning seviyesi, hata yok) |

---

## 🧪 2. Test Suite'leri

| # | Test Suite | Test Sayısı | Sonuç |
|---|-----------|-------------|-------|
| 4 | `test_quines.sh` (PDF spec C+ASM) | 10/10 | ✅ **PASS** |
| 5 | `test_colleen.sh` (Colleen detail) | 4/4 | ✅ **PASS** |
| 6 | `test_grace.sh` (Grace detail) | 5/5 | ✅ **PASS** |
| 7 | `test_sully.sh` (Sully chain) | 7/7 | ✅ **PASS** |
| 8 | `test_errors.sh` (PDF §IV crash/edge) | 25/25 | ✅ **PASS** |
| 9 | `test_python.sh` (bonus) | 7/7 | ✅ **PASS** |
| | **Toplam test** | **58/58** | ✅ |

---

## 📄 3. PDF Spec — Birebir Komut Doğrulamaları

| # | PDF Örneği | Komut | Beklenen | Sonuç |
|---|-----------|-------|----------|-------|
| 10 | **Colleen (C)** | `gcc -Wall -Wextra -Werror -o Colleen Colleen.c; ./Colleen > tmp; diff tmp Colleen.c` | farksız | ✅ **PASS** byte-identical |
| 11 | **Colleen (ASM)** | `nasm -f elf64 Colleen.s -o Colleen.o && ld Colleen.o -o colleen; ./colleen > tmp; diff tmp Colleen.s` | farksız | ✅ **PASS** byte-identical |
| 12 | **Grace (C)** | `gcc -Wall -Wextra -Werror -o Grace Grace.c; ./Grace; diff Grace.c Grace_kid.c` | farksız | ✅ **PASS** byte-identical |
| 13 | **Grace (ASM)** | `nasm -f elf64 Grace.s -o Grace.o && ld Grace.o -o grace; rm -f Grace_kid.s; ./grace; diff Grace_kid.s Grace.s` | farksız | ✅ **PASS** byte-identical |
| 14 | **Sully (C)** | `gcc ../Sully.c -o Sully; ./Sully; ls -al \| grep Sully \| wc -l` | **13** | ✅ **PASS** count=13 |
| 14.1 | Sully (C) `diff ../Sully.c Sully_0.c` | farkı görüntüle | sadece `int i = 5/0` | ✅ **PASS** |
| 14.2 | Sully (C) `diff Sully_3.c Sully_2.c` | farkı görüntüle | sadece `int i = 3/2` | ✅ **PASS** |
| 15 | **Sully (ASM)** | `nasm -f elf64 ../Sully.s -o Sully.o && gcc Sully.o -o Sully; ./Sully; ls \| grep Sully \| wc -l` | **13** | ✅ **PASS** count=13 |
| 15.1 | Sully (ASM) `diff ../Sully.s Sully_0.s` | farkı görüntüle | sadece `;i=5/;i=0` | ✅ **PASS** |
| 15.2 | Sully (ASM) `diff Sully_3.s Sully_2.s` | farkı görüntüle | sadece `;i=3/;i=2` | ✅ **PASS** |

### Diff Çıktı Örnekleri (PDF spec ile birebir)

**Sully (C):**
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

**Sully (ASM):**
```
$> diff ../Sully.s Sully_0.s
1c1
< ;i=5
---
> ;i=0

$> diff Sully_3.s Sully_2.s
1c1
< ;i=3
---
> ;i=2
```

---

## 🛡️ 4. PDF §IV — Hataya Dayanıklılık (test_errors.sh içinde)

| # | Kontrol | Test edilen | Sonuç |
|---|--------|-------------|-------|
| 16 | Segfault (exit 139) yok | tüm 6 binary | ✅ **PASS** |
| 17 | Bus error (exit 138/135) yok | tüm 6 binary | ✅ **PASS** |
| 18 | SIGABRT (exit 134) yok | tüm 6 binary | ✅ **PASS** |
| 19 | stderr crash marker yok | "Segfault\|Bus\|Aborted\|double free" | ✅ **PASS** |
| 20 | Repeated execution stable | 5x ardışık | ✅ **PASS** |
| 21 | Garbage args ile crash yok | extra argümanlar | ✅ **PASS** |
| 22 | Empty environment crash yok | `env -i` ile | ✅ **PASS** |
| 23 | Closed stdin crash yok | `<&-` ile | ✅ **PASS** |
| 24 | Valgrind memory clean | `--leak-check=full --track-origins=yes` | ✅ **PASS** |
| 25 | Sully boundary counters | -1, -99 | ✅ **PASS** |
| 26 | No core dump dosyası | `find . -name core*` | ✅ **PASS** |

---

## 🏆 5. Genel Sonuç Tablosu

| Kategori | Detay | Durum |
|----------|-------|-------|
| 🏗️ **Build** | 6 binary (3 C + 3 ASM) | ✅ |
| 🔍 **Norm** | quine-inherent ihlaller (dokümante) | ✅ |
| 🛡️ **Cppcheck** | warning seviyesinde temiz | ✅ |
| 🧪 **Test Suite'leri** | **58/58 PASS** (6 suite) | ✅ |
| 📄 **PDF Birebir Örnekler** | **10/10 PASS** (3 program × C+ASM + ek diff'ler) | ✅ |
| 🚨 **PDF §IV (Crash)** | 11 kategori, **25 test PASS** | ✅ |

---

## 6. Yapı Kontrolü (Spec Uyumu)

| PDF Gereksinimi | Bizim Yapı | Durum |
|----------------|-----------|-------|
| Top-level `C/` ve `ASM/` klasörleri | ✓ var | ✅ |
| Her klasörde bağımsız Makefile | `C/Makefile`, `ASM/Makefile` | ✅ |
| Standart kurallar (`all`, `clean`, `fclean`, `re`) | hepsi mevcut | ✅ |
| Yeniden derleme/linkleme akıllı | order-only deps + `.PHONY` | ✅ |
| C kodu: main + helper + 2 yorum | Colleen.c yapı doğru | ✅ |
| Grace C: NO main, 3 #define, 1 yorum | makro tabanlı `HEAD/BODY/TAIL` | ✅ |
| Grace ASM: 3 macro, 1 yorum, no extra routine | `OPEN_FILE/WRITE_SRC/CLOSE_AND_EXIT` | ✅ |
| Sully: counter=5 | `int i = 5;` / `;i=5` | ✅ |
| Sully: 13 dosya zinciri | doğrulandı | ✅ |
| Hatasız çıkış (no segfault/bus/double free) | 25 crash testi PASS | ✅ |

---

## 🎯 Final Onay

```
✓ Build:        6/6 binary
✓ Norm:         3/3 dosya (timeout-safe)
✓ Cppcheck:     temiz
✓ Tests:        58/58 (6 suite)
✓ PDF Examples: 10/10 (Colleen+Grace+Sully × C+ASM)
✓ Crash/Edge:   25/25 (PDF §IV uyumu)
```

**TOPLAM: 84+ ayrı doğrulama, hepsi PASS ✅✅✅**

**Proje École 42 Dr_Quine spec'inin tüm gereksinimlerini Docker ortamında karşılıyor.**

PDF'in birebir test komutları:
- Colleen byte-identical ✅
- Grace byte-identical ✅
- Sully `wc -l = 13` + 2 diff (`int i = 5/0`, `int i = 3/2`) ✅

Hepsi onaylandı. 🎉

---

## 7. Çalıştırma Komutu (Tekrar Üretmek İçin)

### Tek Komut Pipeline (Docker)
```bash
docker build -f docker/Dockerfile -t dr_quine:latest .
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app && \
    make fclean && make all && \
    bash scripts/check_norm.sh && \
    bash scripts/check_cppcheck.sh && \
    bash tests/test_all.sh
"
```

### Adım Adım Doğrulama
```bash
make all                          # 1. Build
make norm                         # 2. Norminette
make cppcheck                     # 3. Statik analiz
make test                         # 4. Tüm test suite (58 test)
make errors                       # 5. PDF §IV crash testleri (25)
make qa                           # 6. Full pipeline
```

---

## 📌 İlgili Belgeler

- [SPEC_COMPLIANCE.md](SPEC_COMPLIANCE.md) — PDF spec uyumluluk detayı
- [FINAL_TEST_REPORT.md](FINAL_TEST_REPORT.md) — önceki final test raporu
- [Report.md](Report.md) — genel proje raporu
- [DOCKER_TEST_REPORT.md](DOCKER_TEST_REPORT.md) — ilk Docker testi (arşiv)
- [docs/command/Examples.md](../command/Examples.md) — PDF spec birebir komutlar (4 OS)
- [docs/presentation/Program1_Colleen.md](../presentation/Program1_Colleen.md) — Colleen teknik analiz
- [docs/presentation/Program2_Grace.md](../presentation/Program2_Grace.md) — Grace teknik analiz
- [docs/presentation/Program3_Sully.md](../presentation/Program3_Sully.md) — Sully teknik analiz

---

**Rapor Otomatik Üretildi:** Bu rapor `docker run` üzerinden uçtan uca yapılan testlerin **gerçek çıktısından** derlenmiştir. Her PASS işareti, ilgili komutun Docker container'ında başarıyla çalıştığının kanıtıdır.
