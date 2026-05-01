# Cppcheck & MISRA C:2012 Analiz Rehberi (Dr_Quine)

Bu doküman, Dr_Quine projesinde **C kaynak dosyaları** üzerinde Cppcheck ve MISRA C:2012 statik analizinin nasıl yapılacağını ve sonuçların nasıl yorumlanacağını açıklar.

---

## 1. Cppcheck Komutları

### 1.1 Hızlı Denetim (warning seviyesi — önerilen)
```bash
cppcheck --enable=warning --std=c99 --quiet C/
```
- Hızlı, sadece somut hatalara odaklanır.
- Quine yapısının doğal `style` uyarılarını gizler.

### 1.2 Tam Analiz (style + unused dahil)
```bash
cppcheck --enable=all --inconclusive --std=c99 --force --quiet \
    --suppress=missingIncludeSystem \
    --suppress=unusedFunction \
    C/ 2> cppcheck.txt
```

### 1.3 MISRA C:2012 Add-on
```bash
# Tüm dosyaları dump et
cppcheck --dump --std=c99 C/*.c

# MISRA add-on ile rapor üret
python3 /usr/share/cppcheck/addons/misra.py C/*.dump > misra.txt

# Rule texts dosyasıyla (varsa)
python3 /usr/share/cppcheck/addons/misra.py --rule-texts=misra_rules.txt C/*.dump > misra.txt
```

---

## 2. Dr_Quine Kaynak Dosyaları

| Dosya | İçerik | Satır Sayısı |
|-------|--------|--------------|
| `C/Colleen.c` | stdout quine | ~5 satır |
| `C/Grace.c` | dosya yazma quine (no-main, 3 #define) | ~6 satır |
| `C/Sully.c` | parametrik quine (counter=5, recursive) | ~5 satır |

---

## 3. Beklenen Cppcheck Bulguları (False Positives)

Quine programları cppcheck'in statik olarak çözemediği bir yapıya sahiptir:
format string içindeki `%%` (escaped `%`) ve `%c` placeholder'ları runtime
sırasında genişler. Cppcheck bunları yanlış sayar.

### 3.1 `wrongPrintfScanfArgNum`
```
C/Grace.c:6:1: error: fprintf format string requires 13 parameters
                       but only 9 are given. [wrongPrintfScanfArgNum]
```
**Yorum:** Format string'de `%%` (literal `%`) cppcheck tarafından placeholder
olarak sayılır → false positive. Runtime'da fprintf doğru çalışır.

### 3.2 `knownConditionTrueFalse`
```
C/Sully.c:80: style: Condition 'counter==0' is always false
                     [knownConditionTrueFalse]
```
**Yorum:** Cppcheck `counter = 5` initial atamasından sonra hiç değişmediğini
sanıyor; aslında `counter--` yapılıyor. False positive.

---

## 4. Beklenen MISRA C:2012 İhlalleri (Quine Yapısı)

| Kural | Açıklama | Durum | Gerekçe |
|-------|----------|-------|---------|
| **Rule 21.6** | `printf/sprintf` kullanımı (`<stdio.h>`) | İhlal | Quine için zorunlu |
| **Rule 17.7** | `system()` dönüş değeri kullanımı | Düzeltildi | `r=system(c)` ile yakalandı |
| **Rule 5.4** | Identifier uniqueness | OK | — |
| **Rule 8.4** | External linkage uyumlu | OK | `int i = 5;` global |
| **Rule 15.5** | Single point of exit | İhlal | Hata path'lerinde early return |
| **Rule 21.21** | `system()` kullanımı | İhlal | Sully için zorunlu (compile + run) |

---

## 5. Norm İçi Cppcheck Akışı

```bash
# 1) Hızlı kontrol
cppcheck --enable=warning --std=c99 --quiet C/

# 2) Beklenen false positive'leri suppress et
cppcheck --enable=all --inconclusive --std=c99 --quiet \
    --suppress=wrongPrintfScanfArgNum \
    --suppress=knownConditionTrueFalse \
    --suppress=missingIncludeSystem \
    --suppress=unusedFunction \
    C/

# 3) MISRA raporu (opsiyonel, eğitim amaçlı)
cppcheck --addon=misra --std=c99 C/ 2> misra.txt
```

---

## 6. Docker İçinde Çalıştırma

```bash
docker run --rm -v "$(pwd):/app" dr_quine:latest bash -c "
    cd /app && \
    cppcheck --enable=warning --std=c99 --quiet C/
"
```

---

## 7. Özet ve Kabul Edilen İstisnalar

Dr_Quine'de quine yapısının doğal sonucu olarak kabul edilen MISRA/cppcheck
istisnaları:

1. **`printf`/`fprintf` kullanımı** (Rule 21.6) — Quine output mekanizması.
2. **`system()` çağrısı** (Rule 21.21) — Sully'nin recursive compile + run.
3. **Format string false positives** (`wrongPrintfScanfArgNum`) — `%%` ve `%c`
   placeholder'ları runtime'da çözülür, cppcheck bunu statik olarak göremez.
4. **Tek `main` fonksiyonunun uzun olması** — Quine self-reference için
   parçalama imkansız.

Cppcheck `--enable=warning` modunda bu kod tabanı **temiz** bir çıktı verir.

---

## İlgili Dokümantasyon
- [Command/Cppcheck.md](../command/Cppcheck.md) — Komutların 3 OS için kurulum/çalıştırma rehberi
- [NORMCHECK.md](../normcheck/NORMCHECK.md) — École 42 norm uyumluluğu
