#!/bin/bash
# ============================================================================
# check_cppcheck.sh - Static Analysis with Cppcheck (Dr_Quine)
# ============================================================================
# Suppresses known false positives from quine format strings (%% / %c).

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CDIR="$ROOT/C"

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    Static Code Analysis - Cppcheck${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

if ! command -v cppcheck &> /dev/null; then
	echo -e "${RED}✗ cppcheck not found${NC}"
	echo "  Install: apt-get install cppcheck (Linux), brew install cppcheck (macOS)"
	exit 1
fi

echo -e "${YELLOW}Running cppcheck on C/...${NC}"
echo ""

# Project uses C99; suppress known quine-related false positives
cppcheck \
	--enable=warning \
	--inconclusive \
	--std=c99 \
	--force \
	--suppress=missingIncludeSystem \
	--suppress=unusedFunction \
	--suppress=wrongPrintfScanfArgNum \
	--suppress=knownConditionTrueFalse \
	--quiet \
	"$CDIR" 2>&1 | tee /tmp/cppcheck.txt

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

# Count actual issues (after suppressions)
ERROR_COUNT=$(grep -cE "^\[|: (error|warning):" /tmp/cppcheck.txt 2>/dev/null || true)
ERROR_COUNT=${ERROR_COUNT:-0}

if [ "$ERROR_COUNT" -gt 0 ]; then
	echo -e "${RED}[✗] Cppcheck found $ERROR_COUNT issue(s)${NC}"
	exit 1
fi

echo -e "${GREEN}[✓] Cppcheck passed (warning level, no critical issues)${NC}"
exit 0
