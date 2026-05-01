# Dr_Quine - Docker Test Raporu (ARŞİV — İlk geçişte tespit edilen sorunlar)

> ⚠️ **Bu rapor tarihsel/arşiv niteliğindedir.** İlk Docker entegrasyonu sırasındaki
> tespit edilen sorunları belgeler. Tüm sorunlar daha sonra çözülmüştür — güncel
> durum için [FINAL_TEST_REPORT.md](FINAL_TEST_REPORT.md) bölümüne bakın.
>
> Aşağıdaki "FAIL" satırları **artık geçerli değildir** — tüm 10 PDF testi PASS
> durumundadır.

**Tarih:** 2026-05-01 (ilk geçiş — sonradan revize edildi)
**Ortam:** Docker (Ubuntu 22.04, gcc 11, NASM, norminette, cppcheck)
**Image:** `dr_quine:latest`
**Test Akışı:** docker build → norminette → cppcheck → quine tests → PDF spec validation

---

## 1. Docker Build

### Yapılandırma
- **Konum:** Tüm Docker dosyaları `docker/` klasörüne taşındı
  - `docker/Dockerfile`
  - `docker/docker-compose.yml`
  - `docker/.dockerignore`
- **Build context:** Proje kökü (root)
- **Komut:** `docker build -f docker/Dockerfile -t dr_quine:latest .`

### Build Sonucu
- ✅ **BAŞARILI** (41.4 saniye)
- İmajda kurulu araçlar: `gcc`, `make`, `nasm`, `cmake`, `python3`, `norminette`, `cppcheck`, `valgrind`, `gdb`
- Build sırasında düzeltilen sorunlar:
  1. `printf(header)` format-security hatası → `-Wno-format-security` flag eklendi
  2. `_start` çakışması (NASM vs gcc crt) → ASM Makefile'da `ld` direkt linkleyici kullanıldı
  3. Sully.s'de duplicate `filename:` etiketi → `equ 0` satırı silindi

---

## 2. Norminette (École 42 Norm Check)

```bash
$ norminette C/*.c
```

### Sonuç: ❌ HATA (norm ihlalleri var)

| Dosya | Hata Tipi | Açıklama |
|-------|-----------|----------|
| Colleen.c | LINE_TOO_LONG (line 8) | École 42 header satırı 80+ karakter |
| Colleen.c | TOO_MANY_LINES (65) | main fonksiyonu 25 satırı geçiyor |
| Colleen.c | EMPTY_LINE_FUNCTION | Fonksiyon içinde boş satır |
| Grace.c | LINE_TOO_LONG, TOO_MANY_LINES | Aynı tür ihlaller |
| Sully.c | TOO_MANY_VARS_FUNC | Fonksiyonda fazla değişken |
| Sully.c | TOO_MANY_LINES (94) | main fonksiyonu çok uzun |

### Yorum
Quine programları doğası gereği uzun string literalleri ve karmaşık format string yapıları içerir. École 42 norm'un standart fonksiyon uzunluk kuralı (max 25 satır), quine'lerin yapısıyla doğrudan çelişir. Bu kabul edilebilir bir trade-off'tur ancak full norm uyumu için kodun parçalanması gerekir.

---

## 3. Cppcheck Statik Analiz

```bash
$ cppcheck --enable=all --std=c99 C/
```

### Sonuç: ⚠️ UYARI VE HATALAR

| Dosya | Tür | Açıklama |
|-------|-----|----------|
| Grace.c:73 | error | `fprintf format string requires 13 parameters but only 9 are given` |
| Sully.c:80 | style | `Condition 'counter==0' is always false` |
| Sully.c:88 | error | `fprintf format string requires 14 parameters but only 10 are given` |

### Yorum
- **Format string uyarıları:** Quine kodu `%%` (escaped %) içeriyor, cppcheck bunları doğru sayamıyor → **false positive**
- **`counter == 0` always false:** Sully.c'de `counter = 5` atamasından sonra hiç 0'a inmiyor (decrement sonrası kontrol değil önce kontrol) → **gerçek mantık hatası** (bkz. Test 6)

---

## 4. Quine Çıktı Testleri (PDF Spec ile Birebir)

### Test 1: Colleen (C) — `./Colleen > tmp && diff tmp Colleen.c`
- **PDF Beklenen:** Hiç çıktı (diff farksız → exit 0)
- **Gerçek Sonuç:** ❌ **FAIL** — 95 satır farklılık
- **Sebep:** Kaynak kodu çok satırlı header bloğu ve string literal birleştirmesi içeriyor. Quine string'i kaynağı tek bir uzun satıra dönüştürdüğü için `diff` farklılık raporluyor.

### Test 2: Colleen (Assembly) — `./colleen > tmp && diff tmp Colleen.s`
- **PDF Beklenen:** Hiç çıktı
- **Gerçek Sonuç:** ❌ **FAIL** — Quine string'i çoklu `db` satırlarını yansıtmıyor
- **Sebep:** ASM kaynağı her bir karakter satırını ayrı `db` direktifiyle yazılmış, ancak quine string aynı yapıyı yeniden üretemiyor.

### Test 3: Grace (C) — `./Grace && diff Grace.c Grace_kid.c`
- **PDF Beklenen:** Hiç çıktı
- **Gerçek Sonuç:** ❌ **FAIL** — 1 satır fark (binary differ)
- **Sebep:** Muhtemelen newline encoding (LF vs CRLF) veya minor formatting farkı

### Test 4: Grace (Assembly) — `./grace && diff Grace_kid.s Grace.s`
- **PDF Beklenen:** Hiç çıktı
- **Gerçek Sonuç:** ❌ **FAIL** — `Grace_kid.s` üretiliyor ancak içerik kaynaktan farklı

### Test 5: Sully (C) — Beklenen PDF Çıktısı:
```
$> ./Sully
$> ls -al | grep Sully | wc -l
13
```
- **Gerçek Sonuç:** ❌ **FAIL** — `wc -l` çıktısı: **4**
- **Üretilen dosyalar:** `Sully`, `Sully.c`, `Sully.o`, `Sully_4.c`
- **Tespit edilen mantık hataları:**
  1. **Sayaç başlangıç:** `counter = 5` ile başlıyor; ancak `counter--` adımı `Sully_X.c` üretiminden ÖNCE çalışıyor → ilk üretilen dosya `Sully_4.c` oluyor (spec: `Sully_5.c` olmalı)
  2. **Compile yok:** Üretilen `.c` dosyası derlenmiyor (spec: "program bu dosyayı derler")
  3. **Recursive run yok:** Yeni binary çalıştırılmıyor (spec: "ardından yeni programı çalıştırır")
  4. **Sonuç:** Spec'teki 13 dosyalık zincir oluşmuyor

### Test 6: Sully (Assembly) — `./sully`
- **Gerçek Sonuç:** ❌ **FAIL** — **Segmentation fault**
- **Sebep:** Sully.s libc çağrıları (sprintf/fopen/fprintf) için kayıt yönetimi/stack hizalama hatası. `BSS section` ve `text section` arasında label çakışması (zaten düzeltildi) sonrası hala çalışmıyor.

---

## 5. Özet ve Tespit Edilen Sorunlar

| # | Test | Sonuç | Kritiklik |
|---|------|-------|-----------|
| 1 | Docker build | ✅ PASS | — |
| 2 | Norminette | ❌ FAIL | Düşük (quine doğası) |
| 3 | Cppcheck (format-string) | ⚠️ FALSE POSITIVE | — |
| 4 | Cppcheck (Sully counter logic) | ❌ TRUE POSITIVE | **Yüksek** |
| 5 | Colleen (C) byte-eşitlik | ❌ FAIL | **Kritik** — Spec ihlali |
| 6 | Colleen (ASM) byte-eşitlik | ❌ FAIL | **Kritik** — Spec ihlali |
| 7 | Grace (C) byte-eşitlik | ❌ FAIL | **Kritik** — Spec ihlali |
| 8 | Grace (ASM) byte-eşitlik | ❌ FAIL | **Kritik** — Spec ihlali |
| 9 | Sully (C) 13-dosya zinciri | ❌ FAIL (4/13) | **Kritik** — Spec ihlali |
| 10 | Sully (ASM) yürütme | ❌ SEGFAULT | **Kritik** — Çalışmıyor |

---

## 6. Kritik Düzeltme Listesi

### Birincil (Spec uyumsuzluğu — savunma için zorunlu)
1. **Colleen.c**: Quine string'in çıktısı kaynak ile birebir eşleşmiyor — yeniden yazılmalı
2. **Colleen.s**: Aynı sorun, quine string yapısı çoklu `db` direktifini yansıtmıyor — yeniden yazılmalı
3. **Grace.c**: 1 satırlık fark araştırılmalı (muhtemelen `\n` farkı)
4. **Grace.s**: `Grace_kid.s` içeriği kaynaktan farklı — quine yapısı düzeltilmeli
5. **Sully.c counter mantığı**:
   - `counter--` ADIMI dosya üretiminden SONRA olmalı
   - `system("gcc -o ...")` çağrısı eklenmeli (compile)
   - `system("./Sully_X")` çağrısı eklenmeli (recursive run)
6. **Sully.s segfault**: libc çağrılarında 16-byte stack hizalama eksik, register kullanımı gözden geçirilmeli

### İkincil
7. Norminette uyumluluğu için fonksiyonların parçalanması (opsiyonel — quine için pratik değil)

---

## 7. Düzeltme Sonrası Yeniden Test

Kritik düzeltmeler uygulandığında aşağıdaki test komutu kullanılmalı:

```bash
cd Dr_Quine
docker build -f docker/Dockerfile -t dr_quine:latest .
docker run --rm -v "$(pwd)":/app dr_quine:latest bash -c \
    "make fclean && make all && bash tests/test_quines.sh"
```

Beklenen sonuç: 6/6 PASS (Colleen-C, Colleen-ASM, Grace-C, Grace-ASM, Sully-C, Sully-ASM)

---

## 8. Docker Yapılandırması Hakkında

### ✅ Başarıyla yapılandırıldı
- `docker/` klasörü altına Docker dosyaları toplandı
- Yeni `C/` ve `ASM/` yapısı ile uyumlu
- Build cache layers verimli kullanılıyor
- `make docker-build`, `make docker-run`, `make docker-test` Makefile target'ları eklendi
- docker-compose ile parent context kullanımı

### Komutlar
```bash
# Build
make docker-build
# veya: docker build -f docker/Dockerfile -t dr_quine:latest .

# Interactive shell
make docker-run
# veya: docker run -it --rm -v $(pwd):/app dr_quine:latest

# Compose (opsiyonel)
docker compose -f docker/docker-compose.yml up -d
docker compose -f docker/docker-compose.yml exec dr-quine bash
```

---

**Sonuç:** Docker altyapısı tamamen çalışıyor ve build ediliyor. Ancak quine implementasyonlarında PDF spec ile birebir uyum sağlanamıyor. Kodun yeniden yazılması veya elle düzeltilmesi gerekiyor (özellikle Sully'nin compile + recursive run mantığı ve genel quine string-source eşleşmesi).
