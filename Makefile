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
# COLORS FOR OUTPUT
# ============================================================================

RED			=	\033[0;31m
GREEN		=	\033[0;32m
YELLOW		=	\033[0;33m
BLUE		=	\033[0;34m
NC			=	\033[0m

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

# Assembly executables (lowercase per convention)
COLLEEN_ASM	=	colleen
GRACE_ASM	=	grace
SULLY_ASM	=	sully

# All binaries
BINARIES	=	$(COLLEEN) $(GRACE) $(SULLY) $(COLLEEN_ASM) $(GRACE_ASM) $(SULLY_ASM)

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
# ASSEMBLY EXECUTABLE COMPILATION RULES
# ============================================================================

$(COLLEEN_ASM): $(OBJDIR)/colleen.o | $(OUTDIR)
	ld -o $@ $^

$(GRACE_ASM): $(OBJDIR)/grace.o | $(OUTDIR)
	ld -o $@ $^

$(SULLY_ASM): $(OBJDIR)/sully.o | $(OUTDIR)
	ld -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ $^

# ============================================================================
# OBJECT FILE COMPILATION RULES
# ============================================================================

$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/colleen.o: $(SRCDIR)/colleen.s | $(OBJDIR)
	nasm -f elf64 $< -o $@

$(OBJDIR)/grace.o: $(SRCDIR)/grace.s | $(OBJDIR)
	nasm -f elf64 $< -o $@

$(OBJDIR)/sully.o: $(SRCDIR)/sully.s | $(OBJDIR)
	nasm -f elf64 $< -o $@

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
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(BLUE)Testing Colleen (C version)...$(NC)"
	@./$(COLLEEN) > /tmp/colleen_c_out.c && \
		diff -q /tmp/colleen_c_out.c $(SRCDIR)/colleen.c > /dev/null && \
		echo "$(GREEN)✓ Colleen C PASSED$(NC)" || echo "$(RED)✗ Colleen C FAILED$(NC)"
	@echo ""
	@echo "$(BLUE)Testing Colleen (Assembly version)...$(NC)"
	@./$(COLLEEN_ASM) > /tmp/colleen_asm_out.s && \
		diff -q /tmp/colleen_asm_out.s $(SRCDIR)/colleen.s > /dev/null && \
		echo "$(GREEN)✓ Colleen ASM PASSED$(NC)" || echo "$(RED)✗ Colleen ASM FAILED$(NC)"
	@echo ""
	@echo "$(BLUE)Testing Grace (C version)...$(NC)"
	@./$(GRACE) && \
		diff -q Grace_kid.c $(SRCDIR)/grace.c > /dev/null && \
		echo "$(GREEN)✓ Grace C PASSED$(NC)" || echo "$(RED)✗ Grace C FAILED$(NC)"
	@rm -f Grace_kid.c
	@echo ""
	@echo "$(BLUE)Testing Grace (Assembly version)...$(NC)"
	@./$(GRACE_ASM) && \
		diff -q Grace_kid.s $(SRCDIR)/grace.s > /dev/null && \
		echo "$(GREEN)✓ Grace ASM PASSED$(NC)" || echo "$(RED)✗ Grace ASM FAILED$(NC)"
	@rm -f Grace_kid.s
	@echo ""
	@echo "$(BLUE)Testing Sully (C version)...$(NC)"
	@./$(SULLY) && test -f Sully_7.c && \
		echo "$(GREEN)✓ Sully C PASSED$(NC)" || echo "$(RED)✗ Sully C FAILED$(NC)"
	@rm -f Sully_*.c
	@echo ""
	@echo "$(BLUE)Testing Sully (Assembly version)...$(NC)"
	@./$(SULLY_ASM) && test -f Sully_7.s && \
		echo "$(GREEN)✓ Sully ASM PASSED$(NC)" || echo "$(RED)✗ Sully ASM FAILED$(NC)"
	@rm -f Sully_*.s
	@echo ""
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)[✓] All tests completed!$(NC)"

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
