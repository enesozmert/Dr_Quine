# ============================================================================
# Makefile for Assembly Quine Programs (x86-64 NASM)
# Top-level layout: C/ and ASM/ folders contain sources + this Makefile
# Build artifacts -> ../output/ASM/
# Sully needs /tmp/sully_self.s (incbin) - copied during build.
# All ASM sources use `global main` + libc start -> link via gcc (PDF spec).
# ============================================================================

NASM		=	nasm
NASMFLAGS	=	-f elf64
CC			=	gcc

OUTDIR		=	../output/ASM

BINS		=	$(OUTDIR)/Colleen $(OUTDIR)/Grace $(OUTDIR)/Sully

.PHONY: all clean fclean re

all: $(BINS)

$(OUTDIR):
	mkdir -p $(OUTDIR)

# PDF spec command:  nasm -f elf64 X.s -o X.o && gcc X.o -o X
$(OUTDIR)/Colleen: Colleen.o | $(OUTDIR)
	$(CC) -no-pie -o $@ $^
	@cp Colleen.s $(OUTDIR)/Colleen.s

$(OUTDIR)/Grace: Grace.o | $(OUTDIR)
	$(CC) -no-pie -o $@ $^
	@cp Grace.s $(OUTDIR)/Grace.s

$(OUTDIR)/Sully: Sully.o | $(OUTDIR)
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
