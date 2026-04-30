#!/bin/bash
# ========================================================================
# check_norm.sh - École 42 Norminette Compliance Checker
# ========================================================================
# Checks all C source files for norm compliance

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SRCDIR="src"
HDRDIR="hdr"
TOTAL_ERRORS=0

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    École 42 Norminette Compliance Check${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Check if norminette is installed
if ! command -v norminette &> /dev/null; then
	echo -e "${RED}✗ norminette not found${NC}"
	echo "  Install: pip3 install norminette"
	exit 1
fi

# Check C source files
echo -e "${YELLOW}Checking C source files...${NC}"
for file in $(find $SRCDIR -name "*.c" -type f); do
	echo -n "  $file: "
	if norminette -R CheckForbiddenSourceHeader "$file" 2>&1 | grep -q "Error!"; then
		echo -e "${RED}FAIL${NC}"
		TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
	else
		echo -e "${GREEN}OK${NC}"
	fi
done

echo ""
echo -e "${YELLOW}Checking Header files...${NC}"
for file in $(find $HDRDIR -name "*.h" -type f 2>/dev/null); do
	echo -n "  $file: "
	if norminette -R CheckForbiddenSourceHeader "$file" 2>&1 | grep -q "Error!"; then
		echo -e "${RED}FAIL${NC}"
		TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
	else
		echo -e "${GREEN}OK${NC}"
	fi
done

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

if [ $TOTAL_ERRORS -eq 0 ]; then
	echo -e "${GREEN}[✓] All files passed norm compliance!${NC}"
	exit 0
else
	echo -e "${RED}[✗] $TOTAL_ERRORS file(s) failed norm compliance${NC}"
	exit 1
fi
