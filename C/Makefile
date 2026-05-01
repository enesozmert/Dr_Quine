# ============================================================================
# Makefile for C Quine Programs (École 42 Standard)
# Top-level layout: C/ and ASM/ folders contain sources + this Makefile
# Build artifacts -> ../output/C/
# ============================================================================

CC			=	gcc
CFLAGS		=	-Wall -Wextra -Werror -O2 -Wno-format-security

OUTDIR		=	../output/C

SRCS		=	Colleen.c Grace.c Sully.c
OBJS		=	$(SRCS:.c=.o)
BINS		=	$(OUTDIR)/Colleen $(OUTDIR)/Grace $(OUTDIR)/Sully

.PHONY: all clean fclean re

all: $(BINS)

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(OUTDIR)/Colleen: Colleen.o | $(OUTDIR)
	$(CC) $(CFLAGS) -o $@ $^
	@cp Colleen.c $(OUTDIR)/Colleen.c

$(OUTDIR)/Grace: Grace.o | $(OUTDIR)
	$(CC) $(CFLAGS) -o $@ $^
	@cp Grace.c $(OUTDIR)/Grace.c

$(OUTDIR)/Sully: Sully.o | $(OUTDIR)
	$(CC) $(CFLAGS) -o $@ $^
	@cp Sully.c $(OUTDIR)/Sully.c

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f $(OBJS)

fclean: clean
	rm -rf $(OUTDIR)

re: fclean all

# ============================================================================
