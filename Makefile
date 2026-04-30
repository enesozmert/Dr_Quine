# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#                            Makefile                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#                            By: ozmerte <ozmerte@gmail.com>          #
#                                                   +#+  +:+       +#+         #
#                            Created: 2026/05/01 01:52:00 by ozmerte        #
#                            Updated: 2026/05/01 01:52:00 by ozmerte       #
#                                                                              #
# **************************************************************************** #

# ============================================================================
# PROJECT CONFIGURATION
# ============================================================================

# Project Name
NAME			=	Dr_Quine

# Compiler and Flags
CC				=	gcc
CFLAGS			=	-Wall -Wextra -Werror -g
CPPFLAGS		=	-Ihdr

# Directories
SRC_DIR			=	src
HDR_DIR			=	hdr
OBJ_DIR			=	obj
OUTPUT_DIR		=	output
TEST_DIR		=	tests

# Source Files (will be populated as project grows)
COLLEEN_C		=	$(SRC_DIR)/colleen.c
GRACE_C			=	$(SRC_DIR)/grace.c
SULLY_C			=	$(SRC_DIR)/sully.c

# Object Files
COLLEEN_O		=	$(OBJ_DIR)/colleen.o
GRACE_O			=	$(OBJ_DIR)/grace.o
SULLY_O			=	$(OBJ_DIR)/sully.o

# Executables (C versions)
COLLEEN_BIN		=	Colleen
GRACE_BIN		=	Grace
SULLY_BIN		=	Sully

# ============================================================================
# COLORS FOR OUTPUT
# ============================================================================

RED				=	\033[0;31m
GREEN			=	\033[0;32m
YELLOW			=	\033[0;33m
BLUE			=	\033[0;34m
NC				=	\033[0m

# ============================================================================
# PHONY TARGETS
# ============================================================================

.PHONY: all clean fclean re help info

# ============================================================================
# DEFAULT TARGET
# ============================================================================

all: info $(COLLEEN_BIN) $(GRACE_BIN) $(SULLY_BIN)
	@echo "$(GREEN)[✓] $(NAME) - All targets built successfully$(NC)"

# ============================================================================
# COLLEEN TARGET
# ============================================================================

$(COLLEEN_BIN): $(COLLEEN_O)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ $^
	@echo "$(GREEN)[✓] Built: $(COLLEEN_BIN)$(NC)"

# ============================================================================
# GRACE TARGET
# ============================================================================

$(GRACE_BIN): $(GRACE_O)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ $^
	@echo "$(GREEN)[✓] Built: $(GRACE_BIN)$(NC)"

# ============================================================================
# SULLY TARGET
# ============================================================================

$(SULLY_BIN): $(SULLY_O)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ $^
	@echo "$(GREEN)[✓] Built: $(SULLY_BIN)$(NC)"

# ============================================================================
# OBJECT FILE COMPILATION RULE
# ============================================================================

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@
	@echo "$(BLUE)[•] Compiled: $<$(NC)"

# ============================================================================
# CLEAN TARGETS
# ============================================================================

clean:
	@rm -rf $(OBJ_DIR)
	@echo "$(YELLOW)[✓] Cleaned: Object files removed$(NC)"

fclean: clean
	@rm -f $(COLLEEN_BIN) $(GRACE_BIN) $(SULLY_BIN)
	@rm -f *_kid.c *_kid.s
	@rm -f $(OUTPUT_DIR)/*
	@echo "$(YELLOW)[✓] FCleaned: Executables and output removed$(NC)"

re: fclean all

# ============================================================================
# HELP TARGET
# ============================================================================

help:
	@echo "$(BLUE)=== Dr_Quine Makefile Help ===$(NC)"
	@echo ""
	@echo "$(GREEN)Available Targets:$(NC)"
	@echo "  $(YELLOW)make all$(NC)      - Build all Quine programs (Colleen, Grace, Sully)"
	@echo "  $(YELLOW)make clean$(NC)    - Remove object files"
	@echo "  $(YELLOW)make fclean$(NC)   - Remove object files and executables"
	@echo "  $(YELLOW)make re$(NC)       - Rebuild everything (fclean + all)"
	@echo "  $(YELLOW)make help$(NC)     - Show this help message"
	@echo "  $(YELLOW)make info$(NC)     - Show project information"
	@echo "  $(YELLOW)make test$(NC)     - Run tests (placeholder)"
	@echo ""
	@echo "$(GREEN)Example Usage:$(NC)"
	@echo "  $$ make              # Build all programs"
	@echo "  $$ ./Colleen         # Run Colleen program"
	@echo "  ./Colleen > out.c && diff out.c <source.c>"
	@echo "  $$ make clean        # Remove build artifacts"
	@echo ""

# ============================================================================
# INFO TARGET
# ============================================================================

info:
	@echo "$(BLUE)"
	@echo " ╔════════════════════════════════════════════════════════╗"
	@echo " ║           Dr_Quine - Self-Replicating Programs         ║"
	@echo " ║                  Makefile v1.0                         ║"
	@echo " ╚════════════════════════════════════════════════════════╝"
	@echo "$(NC)"
	@echo "$(GREEN)Project Structure:$(NC)"
	@echo "  Source Dir:       $(SRC_DIR)/"
	@echo "  Header Dir:       $(HDR_DIR)/"
	@echo "  Object Dir:       $(OBJ_DIR)/"
	@echo "  Output Dir:       $(OUTPUT_DIR)/"
	@echo "  Test Dir:         $(TEST_DIR)/"
	@echo ""
	@echo "$(GREEN)Compiler Settings:$(NC)"
	@echo "  Compiler:         $(CC)"
	@echo "  Flags:            $(CFLAGS)"
	@echo "  Includes:         $(CPPFLAGS)"
	@echo ""
	@echo "$(GREEN)Programs:$(NC)"
	@echo "  1. Colleen (stdout quine)"
	@echo "  2. Grace   (file writing quine)"
	@echo "  3. Sully   (parametric self-replicating quine)"
	@echo ""
	@echo "$(YELLOW)Run 'make help' for usage information$(NC)"
	@echo ""

# ============================================================================
# TEST TARGET (Placeholder - expand as needed)
# ============================================================================

test:
	@echo "$(BLUE)[•] Running tests...$(NC)"
	@echo "$(YELLOW)[!] Test suite not yet implemented$(NC)"
	@echo "$(YELLOW)[!] See $(TEST_DIR)/ for test structure$(NC)"

# ============================================================================
# ADDITIONAL TARGETS
# ============================================================================

# Show what will be compiled
show:
	@echo "$(GREEN)Files to compile:$(NC)"
	@test -f $(COLLEEN_C) && echo "  ✓ $(COLLEEN_C)" || echo "  ✗ $(COLLEEN_C) (missing)"
	@test -f $(GRACE_C) && echo "  ✓ $(GRACE_C)" || echo "  ✗ $(GRACE_C) (missing)"
	@test -f $(SULLY_C) && echo "  ✓ $(SULLY_C)" || echo "  ✗ $(SULLY_C) (missing)"

# Verify norm compliance (requires norminette installed)
norm:
	@echo "$(BLUE)[•] Checking norm compliance...$(NC)"
	@command -v norminette >/dev/null 2>&1 || { echo "$(RED)✗ norminette not found$(NC)"; exit 1; }
	@norminette $(SRC_DIR)/*.c $(HDR_DIR)/*.h 2>/dev/null || true
	@echo "$(GREEN)[✓] Norm check complete$(NC)"

# Static analysis with cppcheck (requires cppcheck installed)
check:
	@echo "$(BLUE)[•] Running static analysis...$(NC)"
	@command -v cppcheck >/dev/null 2>&1 || { echo "$(RED)✗ cppcheck not found$(NC)"; exit 1; }
	@cppcheck --enable=all --inconclusive $(SRC_DIR)/ $(HDR_DIR)/
	@echo "$(GREEN)[✓] Analysis complete$(NC)"

# ============================================================================
# END OF MAKEFILE
# ============================================================================
