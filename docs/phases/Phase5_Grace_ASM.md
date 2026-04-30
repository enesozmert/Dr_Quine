# Aşama 5: Grace (Assembly Versiyonu)

**Başlangıç:** -  
**Hedef Tamamlanma:** -  
**Durum:** ⏳ Başlanmadı

---

## Aşama Özeti

Grace'in Assembly (x86-64) versiyonu. Colleen Assembly'den farklı olarak **dosya yazma işlemini syscall'larla yapmalı.**

**Güçlük Seviyesi:** ⭐⭐⭐⭐ (Çok Zor - Assembly + File I/O + Quine)

---

## Temel Gereksinimler

### Tanız
- Quine programı
- **Assembly (x86-64 NASM)**
- Dosya yazma (`Grace_kid.s`)
- Stdout'a hiçbir şey yazmaz
- Exit code 0

### Doğrulama Komutu
```bash
./grace
diff grace.s Grace_kid.s
# Sonuç: 0 (aynı olmalı)
```

---

## Syscall'lar Gerekli

### Open Syscall
```nasm
mov rax, 2              ; open
mov rdi, rsi            ; filename
mov rsi, 0o1100         ; flags (O_CREAT | O_WRONLY | O_TRUNC)
mov rdx, 0o644          ; mode
syscall                 ; fd döner rax'ta
```

### Write Syscall
```nasm
mov rax, 1              ; write
mov rdi, [fd]           ; file descriptor
mov rsi, buffer         ; data
mov rdx, length         ; count
syscall
```

### Close Syscall
```nasm
mov rax, 3              ; close
mov rdi, [fd]           ; file descriptor
syscall
```

---

## Implementasyon Noktaları

1. **Dosya Adı:** "Grace_kid.s" (null-terminated string)
2. **Quine String:** Data section'da tanımlanmalı
3. **Hata Kontrolü:** Open başarısız ise (rax < 0)
4. **File Descriptor:** Döngüde saklı tutmalı

---

## Test Checklist

- [ ] NASM derleme başarılı
- [ ] Linking başarılı
- [ ] `./grace` çalışıyor
- [ ] `Grace_kid.s` oluşturuldu
- [ ] `diff grace.s Grace_kid.s` = 0
- [ ] Exit code 0

---

**Sonraki Aşama:** Aşama 6 - Sully (C Versiyonu)

---

**Son Güncelleme:** 2026-05-01
