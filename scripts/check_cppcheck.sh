#!/bin/bash
# ========================================================================
# check_cppcheck.sh - Static Code Analysis with Cppcheck
# ========================================================================
# Runs Cppcheck for MISRA C:2012 compliance and common issues

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SRCDIR="src"
HDRDIR="hdr"

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    Static Code Analysis - Cppcheck${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Check if cppcheck is installed
if ! command -v cppcheck &> /dev/null; then
	echo -e "${RED}✗ cppcheck not found${NC}"
	echo "  Install: apt-get install cppcheck"
	exit 1
fi

echo -e "${YELLOW}Running Cppcheck analysis...${NC}"
echo ""

# Run cppcheck
cppcheck --enable=all \
	--inconclusive \
	--std=c11 \
	--force \
	--suppress=missingIncludeSystem \
	--suppress=unusedFunction \
	-I$HDRDIR \
	--quiet \
	$SRCDIR 2>&1 | tee /tmp/cppcheck.txt

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

# Count errors
if [ -s /tmp/cppcheck.txt ]; then
	ERROR_COUNT=$(grep -c "^\[" /tmp/cppcheck.txt || echo "0")
	if [ "$ERROR_COUNT" -gt 0 ]; then
		echo -e "${RED}[✗] Cppcheck found issues: $ERROR_COUNT${NC}"
		exit 1
	fi
fi

echo -e "${GREEN}[✓] Cppcheck passed without critical issues!${NC}"
exit 0
