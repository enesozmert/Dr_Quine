# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#                            Makefile                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#                            By: ozmerte <ozmerte@gmail.com>          #
#                                                   +#+  +:+       +#+         #
#                            Created: 2026/05/01 01:52:00 by ozmerte        #
#                            Updated: 2026/05/01 02:00:00 by ozmerte       #
#                                                                              #
# **************************************************************************** #

# ============================================================================
# VARIABLES CONFIGURATION (École 42 Standard)
# ============================================================================

CC			=	gcc
CFLAGS		=	-Wall -Wextra -Werror -g -I$(HDRDIR)
LDFLAGS		=	-lm

SRCDIR		=	src
HDRDIR		=	hdr
OBJDIR		=	obj
OUTDIR		=	output
TESTDIR		=	tests

# Source Files - C Programs (Quine implementations)
COLLEEN_C	=	$(SRCDIR)/colleen.c
GRACE_C		=	$(SRCDIR)/grace.c
SULLY_C		=	$(SRCDIR)/sully.c

# All source files for compilation
SRCS		=	$(COLLEEN_C) \
				$(GRACE_C) \
				$(SULLY_C)

# Object Files
OBJS		=	$(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRCS))

# Executables (C versions with capital first letter per spec)
COLLEEN		=	Colleen
GRACE		=	Grace
SULLY		=	Sully

# All binaries
BINARIES	=	$(COLLEEN) $(GRACE) $(SULLY)

# ============================================================================
# PHONY TARGETS (École 42 Required)
# ============================================================================

.PHONY: all clean fclean re help test norm cppcheck show

# ============================================================================
# DEFAULT TARGET
# ============================================================================

all: $(BINARIES)

# ============================================================================
# EXECUTABLE COMPILATION RULES (No Relink)
# ============================================================================

$(COLLEEN): $(OBJDIR)/colleen.o | $(OUTDIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(GRACE): $(OBJDIR)/grace.o | $(OUTDIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(SULLY): $(OBJDIR)/sully.o | $(OUTDIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# ============================================================================
# OBJECT FILE COMPILATION RULE
# ============================================================================

$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# ============================================================================
# DIRECTORY CREATION RULES (Order-only dependencies)
# ============================================================================

$(OBJDIR):
	@mkdir -p $(OBJDIR)

$(OUTDIR):
	@mkdir -p $(OUTDIR)

# ============================================================================
# CLEAN TARGETS (École 42 Required)
# ============================================================================

clean:
	rm -rf $(OBJDIR)

fclean: clean
	rm -f $(BINARIES)
	rm -f *_kid.c *_kid.s
	rm -rf $(OUTDIR)

re: fclean all

# ============================================================================
# HELP TARGET
# ============================================================================

help:
	@echo "Dr_Quine - Self-Replicating Quine Programs"
	@echo ""
	@echo "Available targets:"
	@echo "  make all     - Build all quine programs (Colleen, Grace, Sully)"
	@echo "  make clean   - Remove object files"
	@echo "  make fclean  - Remove object files and executables"
	@echo "  make re      - Rebuild (fclean + all)"
	@echo "  make help    - Show this help"
	@echo "  make norm    - Check norm compliance"
	@echo "  make cppcheck - Run static analysis"
	@echo "  make test    - Run test suite"
	@echo "  make show    - Show source files status"

# ============================================================================
# TEST TARGET
# ============================================================================

test: $(BINARIES)
	@echo "Testing Colleen..."
	@./$(COLLEEN) > /tmp/colleen_out.c && diff /tmp/colleen_out.c $(COLLEEN_C) && echo "✓ Colleen OK" || echo "✗ Colleen FAIL"
	@echo "Testing Grace..."
	@./$(GRACE) && diff $(GRACE_C) Grace_kid.c && echo "✓ Grace OK" || echo "✗ Grace FAIL"
	@echo "Testing Sully (first iteration)..."
	@./$(SULLY) && test -f Sully_7.c && echo "✓ Sully OK" || echo "✗ Sully FAIL"

# ============================================================================
# NORM COMPLIANCE TARGET
# ============================================================================

norm:
	@echo "Checking École 42 norm compliance..."
	@command -v norminette >/dev/null 2>&1 || { echo "norminette not found"; exit 1; }
	@norminette -R CheckForbiddenSourceHeader $(SRCS) $(HDRDIR)/*.h 2>&1 || true
	@echo "Norm check complete"

# ============================================================================
# STATIC ANALYSIS TARGET
# ============================================================================

cppcheck:
	@echo "Running cppcheck static analysis..."
	@command -v cppcheck >/dev/null 2>&1 || { echo "cppcheck not found"; exit 1; }
	@cppcheck --enable=all --inconclusive --std=c11 --force \
		--suppress=missingIncludeSystem \
		--suppress=unusedFunction \
		-I $(HDRDIR) --quiet $(SRCS) 2>&1
	@echo "Cppcheck complete"

# ============================================================================
# SHOW SOURCE FILES STATUS
# ============================================================================

show:
	@echo "Source files status:"
	@for file in $(SRCS); do \
		if [ -f $$file ]; then \
			echo "  ✓ $$file"; \
		else \
			echo "  ✗ $$file (missing)"; \
		fi; \
	done

# ============================================================================
# END OF MAKEFILE
# ============================================================================
