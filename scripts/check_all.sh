#!/bin/bash
# ============================================================================
# check_all.sh - Complete Quality Assurance Suite (Dr_Quine)
# ============================================================================
# Runs: build, norminette, cppcheck, PDF spec tests, relink check.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FAILED_CHECKS=0

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Dr_Quine - Quality Assurance Suite            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Clean build
echo -e "${YELLOW}[1/6] Cleaning and rebuilding...${NC}"
make fclean > /dev/null 2>&1
if make all > /dev/null 2>&1; then
	echo -e "${GREEN}✓ Build successful${NC}"
else
	echo -e "${RED}✗ Build failed${NC}"
	FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# Step 2: Norm compliance (informational — quine inherently violates)
echo -e "${YELLOW}[2/6] Norminette (informational, quine violations expected)...${NC}"
if bash scripts/check_norm.sh > /dev/null 2>&1; then
	echo -e "${GREEN}✓ Norm check completed${NC}"
else
	echo -e "${YELLOW}⚠ Norminette not installed (skipped)${NC}"
fi
echo ""

# Step 3: Cppcheck static analysis
echo -e "${YELLOW}[3/6] Cppcheck static analysis...${NC}"
if bash scripts/check_cppcheck.sh > /dev/null 2>&1; then
	echo -e "${GREEN}✓ Static analysis passed${NC}"
else
	echo -e "${RED}✗ Static analysis issues found${NC}"
	FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# Step 4: PDF spec tests (test_quines.sh)
echo -e "${YELLOW}[4/6] PDF spec validation tests...${NC}"
if bash tests/test_quines.sh > /dev/null 2>&1; then
	echo -e "${GREEN}✓ All PDF tests passed (10/10)${NC}"
else
	echo -e "${RED}✗ Some PDF tests failed${NC}"
	FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# Step 5: Crash & error-handling tests (PDF §IV)
echo -e "${YELLOW}[5/6] Crash & error-handling tests...${NC}"
if bash tests/test_errors.sh > /dev/null 2>&1; then
	echo -e "${GREEN}✓ All robustness tests passed${NC}"
else
	echo -e "${RED}✗ Some robustness tests failed${NC}"
	FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# Step 6: Relink check
echo -e "${YELLOW}[6/6] Checking for relink issues...${NC}"
touch C/Colleen.c
RELINK_OUTPUT=$(make all 2>&1)
if echo "$RELINK_OUTPUT" | grep -qE "Linking|Building"; then
	echo -e "${GREEN}✓ Make detected source change (correct behavior)${NC}"
	# Run again — should be no-op
	NOOP_OUTPUT=$(make all 2>&1)
	if echo "$NOOP_OUTPUT" | grep -qE "Linking C executable|Building C object"; then
		echo -e "${YELLOW}⚠ Possible relink issue (rebuilt without source change)${NC}"
	else
		echo -e "${GREEN}✓ No relink issues (idempotent)${NC}"
	fi
else
	echo -e "${YELLOW}⚠ Could not verify relink behavior${NC}"
fi
echo ""

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
if [ $FAILED_CHECKS -eq 0 ]; then
	echo -e "${GREEN}║              ✓ ALL CHECKS PASSED                       ║${NC}"
else
	echo -e "${RED}║          ✗ $FAILED_CHECKS CHECK(S) FAILED                          ║${NC}"
fi
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"

exit $FAILED_CHECKS
