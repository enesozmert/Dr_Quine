# Dr_Quine — Proje Görevleri ve Kontrol Listesi

---

## Proje Aşamaları

Dr_Quine projesi aşağıdaki ana aşamalardan oluşur. Her aşama, belirli görevleri ve kontrol noktalarını içerir.

---

## Aşama 1: Hazırlık ve Dizin Yapısı

### Görevler
- [ ] **Dizin Yapısını Oluştur**
  - [ ] `C/` klasörü oluştur
  - [ ] `ASM/` klasörü oluştur
  - [ ] Her klasörde `Colleen/`, `Grace/`, `Sully/` alt klasörleri oluştur
  - [ ] Yapı kontrolü: `tree Dr_Quine` komutu sonucu kontrol et

- [ ] **Başlangıç Dosyalarını Hazırla**
  - [ ] `C/Colleen/colleen.c` boş dosya oluştur
  - [ ] `C/Grace/grace.c` boş dosya oluştur
  - [ ] `C/Sully/sully.c` boş dosya oluştur
  - [ ] `ASM/Colleen/colleen.s` boş dosya oluştur
  - [ ] `ASM/Grace/grace.s` boş dosya oluştur
  - [ ] `ASM/Sully/sully.s` boş dosya oluştur

- [ ] **Makefile'ları Oluştur**
  - [ ] Tüm 6 klasöre `Makefile` ekle
  - [ ] Zorunlu hedefler: `all`, `clean`, `fclean`, `re`
  - [ ] `gcc` veya `nasm` + `ld` kullanımı

- [ ] **Norminette Uyumluluğu Kontrol Et**
  - [ ] `norminette` aracı kurulu mu?
  - [ ] `.c` dosyalarının 42 header yorum bloğu var mı?

---

## Aşama 2: Colleen (C Versiyonu)

### Görevler

- [ ] **Temel Quine Mantığını Anla**
  - [ ] Quine'lerin nasıl çalıştığını öğren
  - [ ] Format string tricks'i araştır
  - [ ] Escape sequence'leri (`, \`, `"`) anla

- [ ] **Colleen.c Kodunun Yazılması**
  - [ ] Header yorum bloğu ekle (42 format)
  - [ ] `#include` direktifleri ekle (`stdio.h`)
  - [ ] `main()` fonksiyonu yaz
  - [ ] Quine mekanizmasını uygula
  - [ ] `printf()` kullanarak stdout'a kod yaz

- [ ] **Derlenebilirlik ve Çalıştırma**
  - [ ] `make` komutu çalış ve derleme başarılı olsun
  - [ ] `./Colleen` çalıştırması başarılı olsun
  - [ ] Yanlış çıktı veya crash olmamsın

- [ ] **Doğrulama Testleri**
  - [ ] `./Colleen > output.c` ve `diff output.c colleen.c` — kimlik kontrol
  - [ ] Çıktı boyutu = Kaynak kodu boyutu?
  - [ ] `xxd` ile binary karşılaştırma (kesin eşleşme)
  - [ ] Birden fazla çalıştırma (deterministic olmalı)

- [ ] **Norm Kontrolü**
  - [ ] `norminette colleen.c` — 0 hata
  - [ ] Bkz. [NORMCHECK.md](../normcheck/NORMCHECK.md)

---

## Aşama 3: Colleen (Assembly Versiyonu)

### Görevler

- [ ] **x86 Assembly Temelleri**
  - [ ] x86-32 veya x86-64 mimarisini seç
  - [ ] Syscall'ları (`write`, `exit`) araştır
  - [ ] Register'lar (`rax`, `rdi`, `rsi` vb.) öğren
  - [ ] NASM syntax'ı öğren

- [ ] **Colleen.s Kodunun Yazılması**
  - [ ] `.section` direktifleri (`text`, `data`)
  - [ ] String literallerini data section'a ekle
  - [ ] Quine stringini tanımla
  - [ ] `write()` syscall'ını kullan
  - [ ] Çıkış (`exit()`) syscall'ını kullan

- [ ] **Derlenebilirlik ve Çalıştırma**
  - [ ] `nasm -f elf64 colleen.s -o colleen.o` — derleme başarılı
  - [ ] `ld colleen.o -o colleen` — linking başarılı
  - [ ] `./colleen` çalıştırması başarılı olsun

- [ ] **Doğrulama Testleri**
  - [ ] `./colleen > output.s` ve `diff output.s colleen.s` — kimlik kontrol
  - [ ] Sistem hataları olmamsın
  - [ ] Deterministic çıktı

- [ ] **Makefile Gözden Geçirme**
  - [ ] Relink sorunu yok mu?
  - [ ] `clean` hedefi `.o` dosyalarını siliyor mu?
  - [ ] `fclean` hedefi çalıştırılabilir dosyayı siliyor mu?

---

## Aşama 4: Grace (C Versiyonu)

### Görevler

- [ ] **Dosya I/O Mekanizmasını Anla**
  - [ ] `open()`, `write()`, `close()` syscall'larını öğren
  - [ ] Veya `fopen()`, `fprintf()`, `fclose()` kullan
  - [ ] Dosya oluşturma modu (O_CREAT, O_WRONLY)

- [ ] **Grace.c Kodunun Yazılması**
  - [ ] Header yorum bloğu ekle
  - [ ] Colleen mantığını dosyaya yazmaya adapte et
  - [ ] `open()` veya `fopen()` ile `Grace_kid.c` aç
  - [ ] Quine string'i dosyaya yaz
  - [ ] Dosyayı kapat

- [ ] **Derlenebilirlik ve Çalıştırma**
  - [ ] `make` derlemesi başarılı
  - [ ] `./Grace` çalıştırması başarılı
  - [ ] `Grace_kid.c` dosyası oluşturuldu

- [ ] **Doğrulama Testleri**
  - [ ] `diff grace.c Grace_kid.c` — tamamen aynı olmalı
  - [ ] Dosya yapısı kontrol: bytes, characters
  - [ ] `Grace_kid.c` dosyasının kaynak kodu olarak geçerliliğini kontrol et
  - [ ] Tekrar çalıştırma: eski dosyayı sil, tekrar üret, kontrol et

- [ ] **Norm Kontrolü**
  - [ ] `norminette grace.c` — 0 hata

---

## Aşama 5: Grace (Assembly Versiyonu)

### Görevler

- [ ] **Grace.s Kodunun Yazılması**
  - [ ] Colleen.s'den başla
  - [ ] Dosya açma (`open` syscall, O_CREAT | O_WRONLY)
  - [ ] File descriptor'ı kaydet
  - [ ] String'i dosyaya yaz (`write` syscall)
  - [ ] Dosyayı kapat (`close` syscall)

- [ ] **Syscall Detayları (x86-64)**
  - [ ] `open`: rax=2, rdi=filename, rsi=flags, rdx=mode
  - [ ] `write`: rax=1, rdi=fd, rsi=buffer, rdx=count
  - [ ] `close`: rax=3, rdi=fd
  - [ ] Syscall: `syscall` instruction

- [ ] **Derlenebilirlik ve Çalıştırma**
  - [ ] `nasm -f elf64 grace.s -o grace.o`
  - [ ] `ld grace.o -o grace`
  - [ ] `./grace` — `Grace_kid.s` oluşturulmalı

- [ ] **Doğrulama Testleri**
  - [ ] `diff grace.s Grace_kid.s` — tamamen aynı
  - [ ] Hata codes kontrol (exit codes)
  - [ ] Makefile relink sorunu yok mu?

---

## Aşama 6: Sully (C Versiyonu)

### Görevler

- [ ] **Dinamik Parametreli Quine Tasarımını Anla**
  - [ ] Sayaç (counter) mekanizmasını tasarla
  - [ ] String içinde sayacı temsil et
  - [ ] Sayaç azaltma mantığını planla
  - [ ] Durdurma koşulu (sayaç = 0)

- [ ] **Sully.c Kodunun Yazılması**
  - [ ] Header yorum bloğu
  - [ ] Başlangıç sayacı tanımla (örn. 8)
  - [ ] Quine string'inde sayacı göster
  - [ ] Dosya adını sayaca göre oluştur (`sprintf`)
  - [ ] Dosya açma ve yazma işlemleri
  - [ ] Sayacı 0 yapana kadar döngü

- [ ] **Derlenebilirlik ve Çalıştırma**
  - [ ] `make` derlemesi başarılı
  - [ ] `./Sully` çalıştırması başarılı
  - [ ] `Sully_8.c` oluşturuldu (örn. başlangıç sayaç = 8)

- [ ] **Doğrulama Testleri**
  - [ ] `diff Sully sully.c` — C de iki dosya aynı olmalı
  - [ ] `cd Sully_8 && make && ./Sully` — Sully_7.c oluşturulmalı
  - [ ] `cd Sully_7 && make && ./Sully` — Sully_6.c oluşturulmalı
  - [ ] ... devam ...
  - [ ] `cd Sully_1 && make && ./Sully` — Sully_0.c oluşturulmalı
  - [ ] `cd Sully_0 && make && ./Sully` — **HİÇBİR DOSYA OLUŞTURULMAZ**

- [ ] **Norm Kontrolü**
  - [ ] `norminette sully.c` — 0 hata
  - [ ] Tüm `Sully_N.c` dosyaları norm uyumlu olmalı

- [ ] **Durdurma ve Temizlik**
  - [ ] Sully_0 döngüde takılmıyor mu?
  - [ ] Recursive yapı sağlamlı mı?

---

## Aşama 7: Sully (Assembly Versiyonu)

### Görevler

- [ ] **Sully.s Kodunun Yazılması**
  - [ ] Dinamik sayaç yönetimi
  - [ ] Dosya adı oluşturma (sprintf benzeri)
  - [ ] Dosya oluşturma ve yazma
  - [ ] Sayaç azaltma mantığı

- [ ] **Derlenebilirlik ve Çalıştırma**
  - [ ] `nasm -f elf64 sully.s -o sully.o`
  - [ ] `ld -lc sully.o -o sully` (C kütüphanesi bağlanması gerekebilir)
  - [ ] `./sully` — Sully_8.s oluşturulmalı

- [ ] **Doğrulama Testleri**
  - [ ] Recursive döngü test et
  - [ ] Son dosya (Sully_0.s) doğru şekilde oluşturulmalı
  - [ ] Sully_0 çalıştırılıp hiçbir dosya oluşturmamalı

---

## Aşama 8: Makefile İyileştirmesi ve Testleri

### Görevler

- [ ] **Tüm Makefile'ları Kontrol Et**
  - [ ] `all`: Her klasörde derlenmiş executable var
  - [ ] `clean`: `.o` dosyalarını siler
  - [ ] `fclean`: `.o` ve executable'ı siler
  - [ ] `re`: `fclean` + `all`
  - [ ] Relink sorunu yok: dosya değişmezse yeniden derleme yapılmaz

- [ ] **Bağımlılıklar ve Kurallar**
  - [ ] `.c` → `.o` → executable (C için)
  - [ ] `.s` → `.o` → executable (ASM için)
  - [ ] PHONY targets tanımla

- [ ] **Testleri Otomatikleştir**
  - [ ] Test script'i oluştur (test.sh)
  - [ ] Her program için diff kontrolleri
  - [ ] Norm kontrolleri (norminette)
  - [ ] Makefile test (relink, clean vb.)

---

## Aşama 9: Norm ve Cppcheck Uyumluluğu

### Görevler

- [ ] **Norminette Kontrolleri**
  - [ ] Tüm `.c` dosyaları: `norminette -R CheckForbiddenSourceHeader C/*.c`
  - [ ] Header yorum blokları doğru (dosya adı, login, zaman)
  - [ ] 80 sütun genişlik limiti
  - [ ] İsimlendirme kuralları (snake_case)
  - [ ] Bkz. [NORMCHECK.md](../normcheck/NORMCHECK.md)

- [ ] **Cppcheck Analizi (Opsiyonel ama Önerilen)**
  - [ ] Null dereference riskleri
  - [ ] Bounds checking
  - [ ] Memory leaks
  - [ ] MISRA C:2012 uyumluluğu
  - [ ] Bkz. [CPPCHECK-MISRA-C2012.md](../cppcheck/CPPCHECK-MISRA-C2012.md)

- [ ] **Hata Düzeltmesi**
  - [ ] Norm hatalarını düzelt
  - [ ] Cppcheck uyarılarını ele al
  - [ ] Tekrar test et

---

## Aşama 10: Bonus (Opsiyonel)

### Görevler

- [ ] **Farklı Dilde Uygulama**
  - [ ] Python, Rust, Go vb. seç
  - [ ] Colleen, Grace, Sully'yi uygula
  - [ ] Test ve doğrula

- [ ] **İyileştirmeler**
  - [ ] Performans optimizasyonları
  - [ ] Daha kısa veya daha yaratıcı kod
  - [ ] Belge yazma (README)
  - [ ] Ek özel Quine varyasyonları

---

## Genel Kontrol Listesi

### Kod Kalitesi
- [ ] Kod okunabilir ve iyi açıklanmış
- [ ] Değişken adları anlamlı
- [ ] Hiç magic number yok (veya define'da tanımlı)
- [ ] Comment'ler açıklayıcı (ama aşırı değil)

### Fonksiyonellik
- [ ] Colleen (C): `./Colleen > out.c && diff out.c colleen.c`
- [ ] Colleen (ASM): `./colleen > out.s && diff out.s colleen.s`
- [ ] Grace (C): `./Grace && diff Grace_kid.c grace.c`
- [ ] Grace (ASM): `./grace && diff Grace_kid.s grace.s`
- [ ] Sully (C): Sayaç döngüsü tamamlanmış
- [ ] Sully (ASM): Sayaç döngüsü tamamlanmış

### Compliance
- [ ] Norminette: Tüm `.c` dosyaları 0 hata
- [ ] Makefile: Relink yok, hedefler doğru
- [ ] Header: Tüm dosyalar 42 header'a sahip

### Dokumentasyon
- [ ] [Command.md](../command/Command.md) okundu ve anlaşıldı
- [ ] [Presentation.md](../presentation/Presentation.md) okundu
- [ ] [NORMCHECK.md](../normcheck/NORMCHECK.md) uyumlu
- [ ] [CPPCHECK-MISRA-C2012.md](../cppcheck/CPPCHECK-MISRA-C2012.md) kontrol edildi

---

## Test Komutları Özeti

```bash
# Colleen (C)
cd C/Colleen
make re
./Colleen > test_out.c
diff test_out.c colleen.c && echo "OK" || echo "FAIL"

# Colleen (ASM)
cd ../../ASM/Colleen
make re
./Colleen > test_out.s
diff test_out.s colleen.s && echo "OK" || echo "FAIL"

# Grace (C)
cd ../../C/Grace
make re
./Grace
diff Grace_kid.c grace.c && echo "OK" || echo "FAIL"

# Grace (ASM)
cd ../../ASM/Grace
make re
./Grace
diff Grace_kid.s grace.s && echo "OK" || echo "FAIL"

# Sully (C) — Tam Cycle
cd ../../C/Sully
make re
./Sully && cd Sully_8 && make && ./Sully && cd Sully_7 && make && ./Sully
# ... vb., Sully_0'a kadar

# Sully (ASM) — Tam Cycle
cd ../../../ASM/Sully
# Benzer döngü

# Norminette
norminette C/**/*.c

# Cppcheck (opsiyonel)
cppcheck --enable=all C/ ASM/
```

---

## Zaman Tahmini

| Aşama | Görev | Tahmini Süre |
|-------|-------|-------------|
| 1 | Hazırlık | 1-2 saat |
| 2 | Colleen (C) | 2-4 saat |
| 3 | Colleen (ASM) | 3-5 saat |
| 4 | Grace (C) | 1-2 saat |
| 5 | Grace (ASM) | 2-3 saat |
| 6 | Sully (C) | 3-4 saat |
| 7 | Sully (ASM) | 4-6 saat |
| 8 | Testing & Makefile | 2-3 saat |
| 9 | Norm & Cppcheck | 1-2 saat |
| **Toplam** | **Minimum** | **19-32 saat** |

---

## Yaygın Hatalar ve Çözümleri

### Hata 1: Quine Çıktısı Yanlış
**Sebep:** Escape sequence'leri veya format string'i yanlış
**Çözüm:** Karakterleri hex dump'la (`xxd`), bire bir karşılaştır

### Hata 2: Norm Hatası — İsimlendirme
**Sebep:** camelCase, başlangıç boşluğu vb.
**Çözüm:** [NORMCHECK.md](../normcheck/NORMCHECK.md) N-01 bölümünü oku

### Hata 3: Makefile Relink Sorunu
**Sebep:** Bağımlılıklar yanlış veya her zaman derleme yapılıyor
**Çözüm:** Makefile'da object dosyalarına bağımlılık tanımla

### Hata 4: Sully Döngüsü Sonsuz
**Sebep:** Sayaç azaltılmıyor veya dosya oluşturulmuyor
**Çözüm:** Sayaç mantığını ve dosya yazma işlemini kontrol et

### Hata 5: Assembly Linking Hatası
**Sebep:** Libc'ye bağlantı yok veya syscall'lar yanlış
**Çözüm:** `ld -lc` kullan veya `libc`'siz saf syscall'lar yaz

---

## Kaynaklar

1. **Command Detayları:** [Command.md](../command/Command.md)
2. **Teorik Bilgi:** [Presentation.md](../presentation/Presentation.md)
3. **Norm Kuralları:** [NORMCHECK.md](../normcheck/NORMCHECK.md)
4. **MISRA Kuralları:** [CPPCHECK-MISRA-C2012.md](../cppcheck/CPPCHECK-MISRA-C2012.md)
5. **Online Quine Kaynakları:** https://en.wikipedia.org/wiki/Quine_(computing)

---

**Son Güncelleme:** 2026-05-01
