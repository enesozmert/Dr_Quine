#!/bin/bash
# ========================================================================
# check_all.sh - Complete Quality Assurance Suite
# ========================================================================
# Runs all checks: Makefile, norm, cppcheck, tests

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

FAILED_CHECKS=0

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Dr_Quine - Quality Assurance Suite            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Clean build
echo -e "${YELLOW}[1/5] Cleaning and rebuilding...${NC}"
make fclean > /dev/null 2>&1
if ! make all > /dev/null 2>&1; then
	echo -e "${RED}✗ Build failed${NC}"
	FAILED_CHECKS=$((FAILED_CHECKS + 1))
else
	echo -e "${GREEN}✓ Build successful${NC}"
fi
echo ""

# Step 2: Norm compliance
echo -e "${YELLOW}[2/5] Checking norm compliance...${NC}"
if bash scripts/check_norm.sh > /dev/null 2>&1; then
	echo -e "${GREEN}✓ Norm compliant${NC}"
else
	echo -e "${RED}✗ Norm issues found${NC}"
	FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# Step 3: Cppcheck analysis
echo -e "${YELLOW}[3/5] Running static analysis...${NC}"
if bash scripts/check_cppcheck.sh > /dev/null 2>&1; then
	echo -e "${GREEN}✓ Static analysis passed${NC}"
else
	echo -e "${RED}✗ Static analysis issues found${NC}"
	FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# Step 4: Run tests
echo -e "${YELLOW}[4/5] Running quine verification tests...${NC}"
if make test > /dev/null 2>&1; then
	echo -e "${GREEN}✓ All tests passed${NC}"
else
	echo -e "${RED}✗ Some tests failed${NC}"
	FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# Step 5: Relink check
echo -e "${YELLOW}[5/5] Checking for relink issues...${NC}"
touch src/colleen.c
if make all > /dev/null 2>&1 && ! make all 2>&1 | grep -q "colleen"; then
	echo -e "${GREEN}✓ No relink issues${NC}"
else
	echo -e "${YELLOW}⚠ Possible relink issue (check manually)${NC}"
fi
echo ""

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
if [ $FAILED_CHECKS -eq 0 ]; then
	echo -e "${GREEN}║              ✓ ALL CHECKS PASSED                      ║${NC}"
else
	echo -e "${RED}║           ✗ $FAILED_CHECKS CHECKS FAILED                    ║${NC}"
fi
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"

exit $FAILED_CHECKS
