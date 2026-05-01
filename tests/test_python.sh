#!/bin/bash
# ============================================================================
# test_python.sh - Test Python Bonus Implementation
# ============================================================================
# Tests the Python quine implementations (all 3 variants)

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BONUSDIR="$TESTDIR/bonus"

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Testing Python Bonus Implementation          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python3 not found. Skipping Python tests.${NC}"
    exit 0
fi

echo -e "${YELLOW}Using: $(python3 --version)${NC}"
echo ""

# Test 1: Python Colleen (default)
echo -e "${YELLOW}[TEST 1] Python Colleen - Stdout Output${NC}"
if [ -f "$BONUSDIR/quine.py" ]; then
    cd "$BONUSDIR"
    # Run from bonus directory
    python3 quine.py > colleen_out.py 2>&1
    LINES=$(wc -l < colleen_out.py)
    if [ "$LINES" -gt 0 ]; then
        echo -e "${GREEN}✓ PASS: Colleen generated $LINES lines of output${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Colleen output is empty${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: quine.py not found${NC}"
fi
echo ""

# Test 2: Python Grace - File output
echo -e "${YELLOW}[TEST 2] Python Grace - File Creation${NC}"
if [ -f "$BONUSDIR/quine.py" ]; then
    cd "$BONUSDIR"
    rm -f grace_kid.py
    python3 quine.py grace > /dev/null 2>&1
    if [ -f grace_kid.py ]; then
        echo -e "${GREEN}✓ PASS: Grace created grace_kid.py${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Grace did not create grace_kid.py${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: quine.py not found${NC}"
fi
echo ""

# Test 3: Python Grace - File content
echo -e "${YELLOW}[TEST 3] Python Grace - Content Verification${NC}"
if [ -f "$BONUSDIR/quine.py" ]; then
    cd "$BONUSDIR"
    # Run from bonus directory
    rm -f grace_kid.py
    python3 quine.py grace > /dev/null 2>&1
    if [ -f grace_kid.py ]; then
        if diff -q grace_kid.py quine.py > /dev/null 2>&1; then
            echo -e "${GREEN}✓ PASS: grace_kid.py matches quine.py${NC}"
            PASS_COUNT=$((PASS_COUNT + 1))
        else
            echo -e "${RED}✗ FAIL: grace_kid.py does not match quine.py${NC}"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    else
        echo -e "${RED}✗ FAIL: grace_kid.py not created${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: quine.py not found${NC}"
fi
echo ""

# Test 4: Python Sully - First generation
echo -e "${YELLOW}[TEST 4] Python Sully - First Generation (counter=3)${NC}"
if [ -f "$BONUSDIR/quine.py" ]; then
    cd "$BONUSDIR"
    # Run from bonus directory
    rm -f sully_*.py
    python3 quine.py sully 3 > /dev/null 2>&1
    if [ -f sully_2.py ]; then
        echo -e "${GREEN}✓ PASS: Sully created sully_2.py (counter decremented)${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Sully did not create sully_2.py${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: quine.py not found${NC}"
fi
echo ""

# Test 5: Python Sully - Recursive chain
echo -e "${YELLOW}[TEST 5] Python Sully - Recursive Generation${NC}"
if [ -f "$BONUSDIR/quine.py" ]; then
    cd "$BONUSDIR"
    # Run from bonus directory
    rm -f sully_*.py
    python3 quine.py sully 2 > /dev/null 2>&1
    if [ -f sully_1.py ]; then
        python3 sully_1.py sully 1 > /dev/null 2>&1
        if [ -f sully_0.py ]; then
            echo -e "${GREEN}✓ PASS: Recursive chain works (2→1→0)${NC}"
            PASS_COUNT=$((PASS_COUNT + 1))
        else
            echo -e "${RED}✗ FAIL: sully_0.py not created${NC}"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    else
        echo -e "${RED}✗ FAIL: sully_1.py not created${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: quine.py not found${NC}"
fi
echo ""

# Test 6: Python Sully - Exit code 0 at counter=0
echo -e "${YELLOW}[TEST 6] Python Sully - Terminal Condition (counter=0)${NC}"
if [ -f "$BONUSDIR/quine.py" ]; then
    cd "$BONUSDIR"
    # Run from bonus directory
    python3 quine.py sully 0 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ PASS: Sully exits cleanly at counter=0${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Sully exit code non-zero at counter=0${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: quine.py not found${NC}"
fi
echo ""

# Test 7: Python - All variants exit code
echo -e "${YELLOW}[TEST 7] Python - Exit Codes${NC}"
if [ -f "$BONUSDIR/quine.py" ]; then
    cd "$BONUSDIR"
    # Run from bonus directory
    ALL_PASS=1

    python3 quine.py > /dev/null 2>&1
    [ $? -ne 0 ] && ALL_PASS=0

    rm -f grace_kid.py
    python3 quine.py grace > /dev/null 2>&1
    [ $? -ne 0 ] && ALL_PASS=0

    python3 quine.py sully 1 > /dev/null 2>&1
    [ $? -ne 0 ] && ALL_PASS=0

    if [ "$ALL_PASS" -eq 1 ]; then
        echo -e "${GREEN}✓ PASS: All variants exit with code 0${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Some variants have non-zero exit codes${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: quine.py not found${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS_COUNT${NC}"
echo -e "${RED}Failed: $FAIL_COUNT${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL_COUNT" -eq 0 ] && exit 0 || exit 1
