# ============================================================================
# Makefile for Assembly Quine Programs (x86-64 NASM)
# Top-level layout: C/ and ASM/ folders contain sources + this Makefile
# Build artifacts -> ../output/ASM/
# Sully needs /tmp/sully_self.s (incbin) - copied during build.
# ============================================================================

NASM		=	nasm
NASMFLAGS	=	-f elf64
LD			=	ld
CC			=	gcc

OUTDIR		=	../output/ASM

BINS		=	$(OUTDIR)/colleen $(OUTDIR)/grace $(OUTDIR)/sully

.PHONY: all clean fclean re

all: $(BINS)

$(OUTDIR):
	mkdir -p $(OUTDIR)

# Colleen, Grace: pure syscalls -> link with ld
$(OUTDIR)/colleen: Colleen.o | $(OUTDIR)
	$(LD) -o $@ $^
	@cp Colleen.s $(OUTDIR)/Colleen.s

$(OUTDIR)/grace: Grace.o | $(OUTDIR)
	$(LD) -o $@ $^
	@cp Grace.s $(OUTDIR)/Grace.s

# Sully: libc via main entry point
$(OUTDIR)/sully: Sully.o | $(OUTDIR)
	$(CC) -no-pie -o $@ $^
	@cp Sully.s $(OUTDIR)/Sully.s

# Per-file rules
Colleen.o: Colleen.s
	$(NASM) $(NASMFLAGS) -o $@ $<

Grace.o: Grace.s
	$(NASM) $(NASMFLAGS) -o $@ $<

Sully.o: Sully.s
	cp Sully.s /tmp/sully_self.s
	$(NASM) $(NASMFLAGS) -o $@ $<

clean:
	rm -f Colleen.o Grace.o Sully.o

fclean: clean
	rm -rf $(OUTDIR)

re: fclean all

# ============================================================================
