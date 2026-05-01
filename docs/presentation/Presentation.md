# Dr_Quine — Proje Sunumu ve Teorisi

> 📚 **Detaylı program analizleri için ayrı belgeler:**
> - [Program1_Colleen.md](Program1_Colleen.md) — stdout quine (klasik)
> - [Program2_Grace.md](Program2_Grace.md) — dosya yazma + makro tabanlı
> - [Program3_Sully.md](Program3_Sully.md) — parametrik + self-compile + recursive

---

## Proje Hakkında

**Dr_Quine**, École 42'deki küçük bir algoritma projesidir. Öz-çoğalma (self-replication) ve öz-referans (self-reference) kavramlarını anlamak amacıyla tasarlanmıştır.

Proje, katılımcıları **Kleene Öz-Referans Teoremi** ile karşılaştırır ve **virüs yayılması** gibi siber güvenlik kavramlarına giriş sağlar.

---

## Quine Nedir?

### Tanım
**Quine**, kendisinin kaynak kodunu çıktı olarak üreten bir bilgisayar programıdır.

- **Giriş:** Yok (veya kullanılmaz)
- **Çıktı:** Programın kendi kaynak kodu
- **Koşul:** Dosya sistemi veya başka kaynakları kullanamaz (veya kısıtlı şekilde)

### Örnek (Python)
```python
s = 's = {}; print(s.format(repr(s)))'; print(s.format(repr(s)))
```

Çalıştırıldığında, bu Python kodu kendi kaynak kodunu yazdırır.

### C'de Quine
C'de quine yazmak daha zorlayıcıdır çünkü:
- String literalleri escape sequence'ler gerektirir
- Öz-referans kod oldukça karmaşık hale gelir
- Format string'lerle oyun oynamak gerekir

---

## Tarihçesi ve Önemi

### Kökeni
- **Donald Knuth** tarafından tanıtılmıştır
- **Geoff Kuenning** tarafından isimlendirilmiştir (W.V.O. Quine, felsefeci)
- Bilgisayar bilimine yeni bir eğlence ve araştırma alanı kazandırmıştır

### Matematiksel Temel
- **Kleene'nin Öz-Referans Teoremi:** Her komputabl fonksiyon için, fonksiyonun kendine referans veren bir versiyonu vardır
- **Gödel'in Eksiklik Teoremi:** Kendine referans verme kapasitesi, formal sistemlerin kuvvetinin göstergesidir
- **Lambda Calculus:** Fonksiyonel programlamada öz-uygulanabilirlik (self-application)

---

## Dr_Quine Projesi Kapsamı

### Amaçlar
1. Quine mekanizmasını anlamak
2. C ve Assembly dillerinde kendine referans veren kod yazabilmek
3. Program yaşam döngüsü ve dosya yazma işlemleri konusunda pratikal bilgi kazanmak
4. Öz-çoğalma ve değişen parametrelerle dinamik kod üretimi kavramını öğrenmek

### Projenin Zorlukları
- **Syntactic Quining:** Kodun kendi yapısını temsil etmesi
- **Escaping:** Özel karakterlerin (çift tırnak, backslash vb.) düzgün şekilde işlenmesi
- **Self-Reference:** Kendisine referans verme mantığını kurmak
- **Dynamic Mutation:** Parametrelerle birlikte değişen quine'ler (Sully)

---

## Üç Varyant Arasındaki Farklar

### Colleen — Basit Quine
**Karmaşıklık:** ⭐⭐ (Orta)
- Temel quine konsepti
- Stdout'a çıktı verme
- Hiç dosya yazma
- Sayaç yok

### Grace — Dosya Yazan Quine
**Karmaşıklık:** ⭐⭐⭐ (Orta-Yüksek)
- Colleen'den biraz daha zor
- Dosya I/O operasyonları
- Bir kere çalışır ve biter
- Hiç sayaç/iterasyon yok

### Sully — Parametrik Quine
**Karmaşıklık:** ⭐⭐⭐⭐⭐ (Çok Yüksek)
- En zor varyant
- Dinamik parametreler (sayaç)
- Dosya oluşturma ve döngü
- Öz-çoğalma konsepti (recursive file generation)
- Sayaç azaltılması ile durdurma mekanizması

---

## Siber Güvenlik Bağlantısı

### Virüs ve Malware
Quine'ler, malware ve virüs geliştirmenin teorik temellerinden birini oluştururlar:

1. **Self-Replication:** Virüsler kendilerini çoğaltırlar (Sully analojisi)
2. **Mutation:** Bazı virüsler kendilerini değiştirir (polymorphic)
3. **Propagation:** Dosya sisteminde veya ağ üzerinden yayılırlar
4. **Dormancy:** Belirli koşullarda etkin hale gelir (sayaç 0'a ulaşması gibi)

**Not:** Bu proje **eğitim amaçlı** olup, malware yazma talimatı değildir.

---

## Teknik Öğrenme Noktaları

### C Programlama
- String işlemleri ve format spesifierler
- Dosya I/O (`open`, `write`, `close` veya `fopen`, `fprintf`, `fclose`)
- Bellek yönetimi (gerekirse)
- Escape sequence'leri (`\n`, `\"`, `\\` vb.)
- Printf format string tricks

### Assembly (x86/x86-64)
- Sistem çağrıları (syscall) — dosya yazma, dosya oluşturma
- Register yönetimi
- Stack manipulation
- Data section'da string defineleme
- Kod çıktısı üretme (`mov`, `xor`, `push` vb.)

### Genel Konseptler
- Recursion ve iteration
- Dosya sistemi etkileşimi
- Program yaşam döngüsü
- Metadata ve parola tabanı bilgisi
- Self-modifying code (teori)

---

## Proje Başarı Kriterleri

### Teknik Kriterler
- [ ] **Colleen (C):** stdout'ta kendi kodu
- [ ] **Colleen (ASM):** x86 assembly quine
- [ ] **Grace (C):** Grace_kid.c dosyası oluşturma
- [ ] **Grace (ASM):** Grace_kid.s dosyası oluşturma
- [ ] **Sully (C):** Sully_N.c dosyaları oluşturma (N sayaç)
- [ ] **Sully (ASM):** Sully_N.s dosyaları oluşturma
- [ ] **Norm uyumluluğu:** École 42 Norminette kuralları
- [ ] **Makefile:** Tüm klasörlerde gerekli hedefler

### Değerlendirme
- Kod kalitesi ve açıklık
- Yaratıcılık ve yaklaşım
- İçgörü ve öğrenme gösterimi
- Projeye ek bonuslar (başka dil, optimizasyonlar)

---

## Kaynaklar ve Referanslar

### Quine Hakkında
- **Wikipedia:** https://en.wikipedia.org/wiki/Quine_(computing)
- **Quine Türleri:** https://en.wikipedia.org/wiki/Quine_(computing)#Classification

### Teorik Zemin
- **Kleene Öz-Referans Teoremi:** Recursion Theory ders notları
- **Gödel'in Eksiklik Teoremi:** Mathematical Logic
- **Lambda Calculus:** Functional programming fundamentals

### École 42 Referansları
- **Norminette Kuralları:** [NORMCHECK.md](../normcheck/NORMCHECK.md)
- **MISRA C:2012 Kuralları:** [CPPCHECK-MISRA-C2012.md](../cppcheck/CPPCHECK-MISRA-C2012.md)

### Örnek Uygulamalar
- https://github.com/Lunairi/42-Dr-Quine
- https://github.com/Mel-louie/dr-quine
- https://github.com/maxisimo/42-Dr-Quine

---

## Ek: Bilinen Quine Örnekleri

### C Dilinde Minimal Quine
```c
#include <stdio.h>
int main() {
    char *s = "#include <stdio.h>%cint main() {%c    char *s = %c%s%c;%c    printf(s, 10, 10, 34, s, 34, 10, 10, 10);%c    return 0;%c}%c";
    printf(s, 10, 10, 34, s, 34, 10, 10, 10);
    return 0;
}
```

### Tarihçe
- 1980'ler: Quine'ler bilim toplumunca tanındı
- 1990'lar: Bilgisayar bilimine sanat yönünden katkı
- 2000'ler: Güvenlik araştırmaları ve malware analizi
- Günümüz: Eğitim ve yaratıcı programlama pratiği

---

## Sonuç

Dr_Quine, basit görünüşüne rağmen, programlama dilinin ve bilgisayar biliminin temel kavramlarını derinlemesine anlamayı gerektirir. Quine'ler, sadece akademik değil, aynı zamanda yaratıcılık ve problem çözüş becerisini de geliştirir.

Bu proje, katılımcılarını:
- **Teknik olarak** C ve Assembly'de ileri seviyeye getirmek
- **Teorik olarak** öz-referans ve recursion'u anlamlandırmak
- **Pratik olarak** dosya I/O ve sistem programlamasında uzmanlaşmak

amacıyla tasarlanmıştır.

---

**Son Güncelleme:** 2026-05-01
