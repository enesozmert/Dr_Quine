# Aşama 8: Testing & Makefile İyileştirmesi

**Başlangıç:** -  
**Hedef Tamamlanma:** -  
**Durum:** ⏳ Başlanmadı

---

## Aşama Özeti

Tüm programlar yazıldıktan sonra, testleri yapılandırmalı ve Makefile'ı optimize etmeliyiz.

**Güçlük Seviyesi:** ⭐⭐ (Orta)

---

## Makefile Hedefleri

### Gerekli Targets
```makefile
all      - Tüm programları derle
clean    - .o dosyalarını sil
fclean   - Tüm çıktıları sil
re       - Yeniden derle
test     - Quine'leri doğrula
```

### Assembly Hedefleri Ekleme

```makefile
$(OBJDIR)/%.o: $(SRCDIR)/%.s | $(OBJDIR)
	nasm -f elf64 $< -o $@
```

---

## Test Prosedürleri

### Colleen Test
```bash
./Colleen > /tmp/colleen_out.c
diff /tmp/colleen_out.c src/colleen.c
echo $?  # 0 olmalı
```

### Grace Test
```bash
./Grace
diff grace.c Grace_kid.c
echo $?  # 0 olmalı
```

### Sully Test
```bash
./Sully && cd Sully_8 && ./Sully && cd Sully_7 && ...
# Tüm döngü test edilmeli
```

---

## Relink Kontrolü

```bash
make fclean
make all
touch src/colleen.c
make all
# Yeniden derlemez (relink yok)
```

---

## Test Checklist

- [ ] `make all` başarılı
- [ ] `make clean` .o siliyor
- [ ] `make fclean` executable siliyor
- [ ] `make re` yeniden derliyor
- [ ] Relink sorunu yok
- [ ] Tüm quine'ler test edildi
- [ ] CMake build da çalışıyor

---

**Sonraki Aşama:** Aşama 9 - Norm & Cppcheck

---

**Son Güncelleme:** 2026-05-01
