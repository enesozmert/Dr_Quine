# Dr_Quine

**Özet:** Bu proje sizi Kleene'nin rekürsyon teoremine karşı karşıya getirecektir! **Sürüm:** 4.0

---

## İçindekiler

- [I. Önsöz](#i-önsöz)
- [II. Giriş](#ii-giriş)
- [III. Amaçlar](#iii-amaçlar)
- [IV. Genel Talimatlar](#iv-genel-talimatlar)
- [V. Zorunlu Kısım](#v-zorunlu-kısım)
- [VI. Bonus Kısım](#vi-bonus-kısım)
- [VII. Teslim ve Akran Değerlendirmesi](#vii-teslim-ve-akran-değerlendirmesi)

---

## I. Önsöz

---

## II. Giriş

Quine, çıktısı ve kaynak kodu özdeş olan bir bilgisayar programıdır (bir tür metaprogram). Bir challenge olarak veya eğlence için, bazı programcılar belirli bir programlama dilinde en kısa quine yazmaya çalışırlar. Kaynak dosyasını basitçe açıp görüntülemek işlemi hile olarak kabul edilir. Daha genel olarak, herhangi bir veri girişi kullanan bir program geçerli bir quine olarak kabul edilemez. Önemsiz bir çözüm, kaynak kodu boş olan bir programdır. Gerçekten, böyle bir programın yürütülmesi çoğu dil için hiçbir çıktı üretmez; yani programın kaynak kodudur.

---

## III. Amaçlar

Bu proje sizi öz-yineleme (self-reproduction) ilkesine ve ondan çıkan sorunlara karşı karşıya getirmeye davet ediyor. Bu, daha karmaşık projelere, özellikle de kötü amaçlı yazılım (malware) projelerine mükemmel bir giriştir. Meraklı olanlar için, sabit noktalarla ilgili her şeyi izlemenizi kesinlikle tavsiye ediyoruz!

---

## IV. Genel Talimatlar

- **Bu proje yalnızca insanlar tarafından düzeltilecektir.**

- **Tüm zorunlu programlar için hem C hem de Assembly uygulamaları gereklidir.** Deponunuz `C` ve `ASM` adında iki üst düzey klasör içermelidir. Her klasör kendi Makefile'ı içermelidir ve standart kuralları içermelidir.

- **Makefile'ınız projeyi derlemeli ve standart kuralları içermelidir.** Yalnızca gerekli olduğunda programı yeniden derlemeli ve yeniden bağlamalıdır.

- **Hataları dikkatli bir şekilde ele almalısınız.** Hiçbir şekilde programınız beklenmedik bir şekilde sonlanmamalıdır (Segmentation fault, bus error, double free, vb.).

- **Sorularınızı forumda, Slack'te sorabilirsiniz...**

### Assembly Kısmı

- **Beklenen Assembly mimarisi:** Linux'te çalışan x86-64.
- **Örneğin, NASM ile:**
```bash
nasm -f elf64 Colleen.s -o Colleen.o && gcc Colleen.o -o Colleen
```

---

## V. Zorunlu Kısım

Bu proje için, her biri farklı özelliklere sahip üç farklı program yeniden kodlamanız gerekecektir. Her program C'de ve Assembly'de kodlanmalı, sırasıyla `C` ve `ASM` adında klasörlere yerleştirilmelidir; her klasör standart kuralları içeren kendi Makefile'ını içermelidir.

Hem C hem de Assembly uygulamaları doğrulama için zorunludur. Herhangi bir zorunlu program için her iki uygulamadan biri eksikse, zorunlu kısım başarısız olur.

### Program #1 -- Colleen

- **Çalıştırılabilir `Colleen` olarak adlandırılmalıdır.**

- **Yürütüldüğünde, program standart çıktıda programı derlemek için kullanılan dosyanın kaynak koduna özdeş bir çıktı görüntülemelidir.**

- **C kaynak kodu en azından şunları içermelidir:**
  - Bir `main` fonksiyonu
  - İki farklı yorum
  - Yorumlardan biri `main` fonksiyonu içinde olmalı
  - Yorumlardan biri programın dışında olmalı
  - `main` fonksiyonunun yanında başka bir fonksiyon (elbette çağrılacak)

- **Assembly kaynak kodu en azından şunları içermelidir:**
  - Açık bir giriş noktası (örneğin, `_start` veya araç zincirininize bağlı bir sembol)
  - İki farklı yorum
  - Bir yorum giriş noktası veya onun doğrudan çağrılan rutini içinde bulunmalı
  - Bir yorum giriş noktası rutinin dışında bulunmalı
  - Giriş noktasından çağrılan ek bir rutine/fonksiyon

#### C Örneği:

```bash
$> ls -al
total 12
drwxr-xr-x 2 root root 4096 Feb 2 13:26 .
drwxr-xr-x 4 root root 4096 Feb 2 13:26 ..
-rw-r--r-- 1 root root 647 Feb 2 13:26 Colleen.c

$> clang -Wall -Wextra -Werror -o Colleen Colleen.c; ./Colleen > tmp_Colleen ; diff tmp_Colleen Colleen.c
$> _
```

#### Assembly Örneği:

```bash
$> ls -al
total 12
drwxr-xr-x 2 root root 4096 Feb 2 13:26 .
drwxr-xr-x 4 root root 4096 Feb 2 13:26 ..
-rw-r--r-- 1 root root 712 Feb 2 13:26 Colleen.s

$> nasm -f elf64 Colleen.s -o Colleen.o && gcc Colleen.o -o Colleen
$> ./Colleen > tmp_Colleen ; diff tmp_Colleen Colleen.s
$> _
```

---

### Program #2 -- Grace

- **Çalıştırılabilir `Grace` olarak adlandırılmalıdır.**

- **Yürütüldüğünde, program programı derlemek için kullanılan dosyanın kaynak kodunu `Grace_kid.c` / `Grace_kid.s` adlı bir dosyaya yazar.**

- **C kaynak kodu kesinlikle şunları içermelidir:**
  - Hiçbir `main` bildirilen (hiç bir fonksiyon bildirilen değil)
  - Tam üç `#define`
  - Bir yorum

- **Program, bir makro çağrısı ile çalışacaktır.**

- **Assembly kaynak kodu kesinlikle şunları içermelidir:**
  - Görevi gerçekleştirmek için gereken giriş noktasının ötesinde ekstra rutinler yok (ek prosedür yok)
  - Tam üç makro (veya assembler'ınız için en yakın eşdeğer)
  - Bir yorum

#### C Örneği:

```bash
$> ls -al
total 12
drwxr-xr-x 2 root root 4096 Feb 2 13:30 .
drwxr-xr-x 4 root root 4096 Feb 2 13:29 ..
-rw-r--r-- 1 root root 362 Feb 2 13:30 Grace.c

$> clang -Wall -Wextra -Werror -o Grace Grace.c; ./Grace ; diff Grace.c Grace_kid.c
$> ls -al
total 24
drwxr-xr-x 2 root root 4096 Feb 2 13:30 .
drwxr-xr-x 4 root root 4096 Feb 2 13:29 ..
-rwxr-xr-x 1 root root 7240 Feb 2 13:30 Grace
-rw-r--r-- 1 root root 362 Feb 2 13:30 Grace.c
-rw-r--r-- 1 root root 362 Feb 2 13:30 Grace_kid.c
$> _
```

#### Assembly Örneği:

```bash
$> ls -al
total 12
drwxr-xr-x 2 root root 4096 Feb 2 13:30 .
drwxr-xr-x 4 root root 4096 Feb 2 13:29 ..
-rw-r--r-- 1 root root 388 Feb 2 13:30 Grace.s

$> nasm -f elf64 Grace.s -o Grace.o && gcc Grace.o -o Grace
$> rm -f Grace_kid.s ; ./Grace ; diff Grace_kid.s Grace.s
$> ls -al
total 24
drwxr-xr-x 2 root root 4096 Feb 2 13:30 .
drwxr-xr-x 4 root root 4096 Feb 2 13:29 ..
-rwxr-xr-x 1 root root 7240 Feb 2 13:30 Grace
-rw-r--r-- 1 root root 388 Feb 2 13:30 Grace.s
-rw-r--r-- 1 root root 388 Feb 2 13:30 Grace_kid.s
$> _
```

---

### Program #3 -- Sully

- **Çalıştırılabilir `Sully` olarak adlandırılmalıdır.**

- **Yürütüldüğünde, program `Sully_X.c` / `Sully_X.s` adlı bir dosyaya yazar. X, kaynak kodunda verilen bir tamsayı olacaktır. Dosya oluşturulduktan sonra, program bu dosyayı derler ve ardından yeni programı çalıştırır (bu programın adı kaynak dosyasının adı olacaktır).**

- **Programın durdurulması dosya adına bağlıdır: elde edilen program yalnızca X tamsayısı 0'dan büyük veya eşitse yürütülür.**

- **Kaynak kodunuzda bir tamsayı vardır ve her bir kaynak dosyası oluşturduğunuzda azaltılarak gelişmelidir.**

- **Kaynak kodda tamsayı dışında kısıtlamaları yoktur. Tamsayı başlangıçta 5 olarak ayarlanacaktır.**

#### C Örneği:

```bash
$> clang -Wall -Wextra -Werror ../Sully.c -o Sully ; ./Sully
$> ls -al | grep Sully | wc -l
13
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
$> _
```

#### Assembly Örneği:

```bash
$> nasm -f elf64 ../Sully.s -o Sully.o && gcc Sully.o -o Sully
$> ./Sully
$> ls -al | grep Sully | wc -l
13
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
$> _
```

---

### Yorum Nasıl Görünmeli:

```bash
$> nl comment.c
1 /*
2
3 Bu program çalıştırıldığında kendi kaynak kodunu yazdıracaktır.
4 */
```

### `main` Bildirisi Olmayan Bir Program Nasıl Görünmeli:

```bash
$> nl macro.c
1 #include
2 #define FT(x)int main(){ /* kod */ }
[..]
5 FT(xxxxxxxx)
```

Akıllı insanlar için (veya değilse)... kaynak kodu yalnızca okuyup görüntülemek hile olarak kabul edilir. `argv/argc` kullanımı da hile olarak kabul edilir.

Bu proje için gelişmiş makrolar kullanılması kesinlikle tavsiye edilir.

---

## VI. Bonus Kısım

Değerlendirme sırasında kabul edilen tek Bonus, bu projeyi seçtiğiniz başka bir dilde tamamen yeniden yapmaktır.

Makro/define olmayan bir dil durumunda, programı doğal olarak uyarlamanız gerekecektir.

Akıllı insanlar için (veya değilse)... zorunlu C kodunu `.cpp` dosyalarına kopyalayıp farklı bir dil olarak adlandırmak bonus olarak sayılmaz.

Bonus kısım yalnızca zorunlu kısım MÜKEMMEL ise değerlendirilecektir. Mükemmel, zorunlu kısımın bütünüyle yapıldığı ve hiçbir arızasız çalıştığı anlamına gelir. Tüm zorunlu gereksinimleri geçmediyseniz, bonus kısımınız hiç değerlendirilmeyecektir.

---

## VII. Teslim ve Akran Değerlendirmesi

Asignmanınızı her zamanki gibi Git deponuzda teslim edin. Savunma sırasında yalnızca deponuzun içinde bulunan çalışma değerlendirilecektir. Klasörlerin ve dosyaların adlarının doğru olduğundan emin olmak için iki kez kontrol etmekten çekinmeyin.

---

**Son Güncelleme:** 2026-05-01  
**Belge:** Dr_Quine Proje Talimatlı (Türkçeye Çevirici: Claude Haiku 4.5)
