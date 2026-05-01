#!/bin/bash
# ============================================================================
# test_all.sh - Master Test Runner (Dr_Quine)
# ============================================================================
# Delegates to:
#   - test_quines.sh: PDF spec validation for C + ASM (10 tests)
#   - test_python.sh: Python bonus validation
#   - test_colleen.sh / test_grace.sh / test_sully.sh: per-program details

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

TESTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$TESTDIR/.." && pwd)"

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           Dr_Quine - Comprehensive Test Suite                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Ensure binaries exist (auto-build if missing)
if [ ! -x "$ROOT/output/C/Colleen" ]; then
	echo -e "${YELLOW}[Auto-build] make all (binaries not found)...${NC}"
	(cd "$ROOT" && make all >/dev/null 2>&1)
	echo ""
fi

TOTAL_FAIL=0

run_test() {
	local name=$1
	local script=$2
	echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
	echo -e "${CYAN}Running: $name${NC}"
	echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"

	if [ -f "$script" ]; then
		if bash "$script"; then
			echo -e "${GREEN}✓ $name PASSED${NC}"
		else
			echo -e "${RED}✗ $name FAILED${NC}"
			TOTAL_FAIL=$((TOTAL_FAIL + 1))
		fi
	else
		echo -e "${YELLOW}⊘ $name SKIPPED (file missing)${NC}"
	fi
	echo ""
}

# Primary suite — covers all PDF spec tests
run_test "PDF Spec Tests (test_quines.sh)" "$TESTDIR/test_quines.sh"

# Per-program detail tests
run_test "Colleen Tests" "$TESTDIR/test_colleen.sh"
run_test "Grace Tests"   "$TESTDIR/test_grace.sh"
run_test "Sully Tests"   "$TESTDIR/test_sully.sh"

# Crash & error-handling robustness (PDF §IV)
run_test "Error Handling Tests" "$TESTDIR/test_errors.sh"

# Python bonus
run_test "Python Bonus Tests" "$TESTDIR/test_python.sh"

# Summary
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
if [ $TOTAL_FAIL -eq 0 ]; then
	echo -e "${BLUE}║                  ${GREEN}✓ ALL TEST SUITES PASSED${BLUE}                    ║${NC}"
else
	echo -e "${BLUE}║              ${RED}✗ $TOTAL_FAIL TEST SUITE(S) FAILED${BLUE}                       ║${NC}"
fi
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"

exit $TOTAL_FAIL
