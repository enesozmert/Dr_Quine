# **************************************************************************** #
#                                                                              #
#                            Dr_Quine - Root Makefile                          #
#                            Delegates to C/ and ASM/ Makefiles                #
#                            By: ozmerte <ozmerte@gmail.com>                   #
#                            Created: 2026/05/01                               #
#                            Updated: 2026/05/01                               #
#                                                                              #
# **************************************************************************** #

# ============================================================================
# COLORS FOR OUTPUT
# ============================================================================

RED			=	\033[0;31m
GREEN		=	\033[0;32m
YELLOW		=	\033[0;33m
BLUE		=	\033[0;34m
CYAN		=	\033[0;36m
NC			=	\033[0m

# ============================================================================
# DIRECTORY CONFIGURATION
# ============================================================================

CDIR		=	C
ASMDIR		=	ASM
TESTDIR		=	tests
BONUSDIR	=	bonus
OUTDIR		=	output

# ============================================================================
# PHONY TARGETS
# ============================================================================

.PHONY: all clean fclean re help test errors qa c asm bonus norm cppcheck show \
        docker-build docker-run docker-test docker-clean

# ============================================================================
# DEFAULT TARGET
# ============================================================================

all: c asm
	@echo "$(GREEN)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)[✓] All quine programs built successfully$(NC)"
	@echo "$(GREEN)═══════════════════════════════════════════════════════$(NC)"

# ============================================================================
# C SUBPROJECT BUILD
# ============================================================================

c:
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(BLUE)Building C Quine Programs...$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@$(MAKE) -C $(CDIR) all

# ============================================================================
# ASSEMBLY SUBPROJECT BUILD
# ============================================================================

asm:
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(BLUE)Building Assembly Quine Programs...$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@$(MAKE) -C $(ASMDIR) all

# ============================================================================
# CLEAN TARGETS
# ============================================================================

clean:
	@$(MAKE) -C $(CDIR) clean
	@$(MAKE) -C $(ASMDIR) clean
	@echo "$(YELLOW)[i] Object files cleaned$(NC)"

fclean:
	@$(MAKE) -C $(CDIR) fclean
	@$(MAKE) -C $(ASMDIR) fclean
	@rm -rf $(OUTDIR)
	@echo "$(YELLOW)[i] All artifacts cleaned (output/ removed)$(NC)"

re: fclean all

# ============================================================================
# TEST TARGET
# ============================================================================

test: all
	@echo "$(CYAN)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(CYAN)Running Test Suite (test_all.sh)...$(NC)"
	@echo "$(CYAN)═══════════════════════════════════════════════════════$(NC)"
	@bash $(TESTDIR)/test_all.sh

# ============================================================================
# CRASH/ERROR HANDLING TESTS (PDF §IV)
# ============================================================================

errors: all
	@echo "$(CYAN)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(CYAN)Running Crash/Error Handling Tests...$(NC)"
	@echo "$(CYAN)═══════════════════════════════════════════════════════$(NC)"
	@bash $(TESTDIR)/test_errors.sh

# ============================================================================
# FULL QA PIPELINE (norm + cppcheck + tests + relink check)
# ============================================================================

qa:
	@echo "$(CYAN)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(CYAN)Running Full QA Pipeline (scripts/check_all.sh)...$(NC)"
	@echo "$(CYAN)═══════════════════════════════════════════════════════$(NC)"
	@bash scripts/check_all.sh

# ============================================================================
# BONUS (Python) TARGET
# ============================================================================

bonus:
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(BLUE)Bonus: Python Quine Implementation$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@command -v python3 >/dev/null 2>&1 || { echo "$(RED)python3 not found$(NC)"; exit 1; }
	@bash $(TESTDIR)/test_python.sh

# ============================================================================
# NORM CHECK TARGET
# ============================================================================

norm:
	@echo "$(BLUE)Checking École 42 norm compliance...$(NC)"
	@bash scripts/check_norm.sh

# ============================================================================
# STATIC ANALYSIS TARGET
# ============================================================================

cppcheck:
	@echo "$(BLUE)Running cppcheck static analysis...$(NC)"
	@bash scripts/check_cppcheck.sh

# ============================================================================
# SHOW STATUS
# ============================================================================

show:
	@echo "$(CYAN)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(CYAN)Project Source Files Status:$(NC)"
	@echo "$(CYAN)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(BLUE)C Sources ($(CDIR)):$(NC)"
	@for file in $(CDIR)/*.c $(CDIR)/Makefile; do \
		if [ -f $$file ]; then \
			echo "  $(GREEN)✓$(NC) $$file"; \
		else \
			echo "  $(RED)✗$(NC) $$file (missing)"; \
		fi; \
	done
	@echo "$(BLUE)ASM Sources ($(ASMDIR)):$(NC)"
	@for file in $(ASMDIR)/*.s $(ASMDIR)/Makefile; do \
		if [ -f $$file ]; then \
			echo "  $(GREEN)✓$(NC) $$file"; \
		else \
			echo "  $(RED)✗$(NC) $$file (missing)"; \
		fi; \
	done

# ============================================================================
# DOCKER TARGETS
# ============================================================================

docker-build:
	@echo "$(BLUE)Building Docker image...$(NC)"
	docker build -f docker/Dockerfile -t dr_quine:latest .

docker-run: docker-build
	@echo "$(BLUE)Running Docker container...$(NC)"
	docker run -it --rm -v "$(PWD)":/app dr_quine:latest

docker-test: docker-build
	@echo "$(BLUE)Running tests inside Docker...$(NC)"
	docker run --rm -v "$(PWD)":/app dr_quine:latest \
		bash -c "make fclean && make all && bash scripts/check_all.sh"

docker-clean:
	@echo "$(YELLOW)Cleaning Docker images...$(NC)"
	-docker rmi dr_quine:latest dr_quine:dev 2>/dev/null || true

# ============================================================================
# HELP TARGET
# ============================================================================

help:
	@echo "$(CYAN)Dr_Quine - Self-Replicating Quine Programs$(NC)"
	@echo ""
	@echo "Build targets:"
	@echo "  $(GREEN)make all$(NC)      - Build all quine programs (C + ASM)"
	@echo "  $(GREEN)make c$(NC)        - Build only C versions"
	@echo "  $(GREEN)make asm$(NC)      - Build only Assembly versions"
	@echo "  $(GREEN)make clean$(NC)    - Remove object files"
	@echo "  $(GREEN)make fclean$(NC)   - Remove all generated files"
	@echo "  $(GREEN)make re$(NC)       - Rebuild everything"
	@echo ""
	@echo "Quality assurance targets:"
	@echo "  $(GREEN)make norm$(NC)     - Run norminette (école 42 norm check)"
	@echo "  $(GREEN)make cppcheck$(NC) - Run static analysis (cppcheck)"
	@echo "  $(GREEN)make test$(NC)     - Run all test suites (test_all.sh)"
	@echo "  $(GREEN)make errors$(NC)   - Run crash/error tests (PDF §IV)"
	@echo "  $(GREEN)make bonus$(NC)    - Test Python bonus implementation"
	@echo "  $(GREEN)make qa$(NC)       - Full QA pipeline (norm+cppcheck+tests+relink)"
	@echo "  $(GREEN)make cppcheck$(NC) - Run static analysis"
	@echo "  $(GREEN)make show$(NC)     - Show source files status"
	@echo "  $(GREEN)make help$(NC)     - Show this help"
	@echo ""
	@echo "Project structure:"
	@echo "  $(BLUE)C/$(NC)            - C quine implementations + Makefile"
	@echo "  $(BLUE)ASM/$(NC)          - x86-64 Assembly implementations + Makefile"
	@echo "  $(BLUE)tests/$(NC)        - Automated test suites"
	@echo "  $(BLUE)bonus/$(NC)        - Python bonus implementation"

# ============================================================================
# END OF MAKEFILE
# ============================================================================
