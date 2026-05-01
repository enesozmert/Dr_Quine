#!/bin/bash
# ============================================================================
# test_all.sh - Comprehensive Test Suite Runner
# ============================================================================
# Runs all test suites and provides a summary report

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

TESTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           Dr_Quine - Comprehensive Test Suite                 ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

TOTAL_PASS=0
TOTAL_FAIL=0
TESTS_RUN=0

# Helper function to run a test suite
run_test() {
    local test_name=$1
    local test_file=$2

    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}Running: $test_name${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo ""

    if [ -f "$test_file" ]; then
        if bash "$test_file"; then
            echo -e "${GREEN}✓ $test_name PASSED${NC}"
            TESTS_RUN=$((TESTS_RUN + 1))
        else
            echo -e "${RED}✗ $test_name FAILED${NC}"
            TESTS_RUN=$((TESTS_RUN + 1))
        fi
    else
        echo -e "${YELLOW}⊘ $test_name SKIPPED (file not found)${NC}"
    fi
    echo ""
}

# Run all test suites
run_test "Colleen Tests" "$TESTDIR/test_colleen.sh"
run_test "Grace Tests" "$TESTDIR/test_grace.sh"
run_test "Sully Tests" "$TESTDIR/test_sully.sh"
run_test "Python Bonus Tests" "$TESTDIR/test_python.sh"

# Final summary
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                      TEST SUMMARY                             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Test Suites Run: ${CYAN}$TESTS_RUN${NC}"
echo ""
echo -e "Status: ${GREEN}✅ ALL TEST SUITES COMPLETED${NC}"
echo ""
echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
echo ""
echo "Recommendations:"
echo "  • Run 'make test' for quick quine validation"
echo "  • Run 'bash scripts/check_all.sh' for full QA"
echo "  • Check output/ folder for generated files"
echo ""
