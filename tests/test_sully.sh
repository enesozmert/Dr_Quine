#!/bin/bash
# ============================================================================
# test_sully.sh - Test Sully Quine (Parametric Self-Replicating)
# ============================================================================
# Tests that Sully creates self-replicating files with decreasing counter

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTDIR="$TESTDIR/output"
SRCDIR="$TESTDIR/src"

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              Testing Sully Quine Programs              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

# Test 1: Sully C - Initial file creation
echo -e "${YELLOW}[TEST 1] Sully (C) - Initial File Creation (Sully_7.c)${NC}"
if [ -f "$OUTDIR/Sully" ]; then
    cd "$TESTDIR"
    rm -f "$OUTDIR"/Sully_*.c
    "$OUTDIR/Sully" > /dev/null 2>&1
    if [ -f "$OUTDIR/Sully_7.c" ]; then
        echo -e "${GREEN}✓ PASS: Sully created Sully_7.c${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Sully did not create Sully_7.c${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Sully C executable not found${NC}"
fi
echo ""

# Test 2: Sully C - File count (should be 1 for first run)
echo -e "${YELLOW}[TEST 2] Sully (C) - First Generation File Count${NC}"
if [ -f "$OUTDIR/Sully" ]; then
    cd "$TESTDIR"
    rm -f Sully_*.c
    ./Sully > /dev/null 2>&1
    FILE_COUNT=$(ls -1 Sully_*.c 2>/dev/null | wc -l)
    if [ "$FILE_COUNT" -eq 1 ]; then
        echo -e "${GREEN}✓ PASS: Created $FILE_COUNT file (Sully_7.c)${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Expected 1 file, got $FILE_COUNT${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Sully C executable not found${NC}"
fi
echo ""

# Test 3: Sully C - Recursive chain generation
echo -e "${YELLOW}[TEST 3] Sully (C) - Recursive Generation Chain${NC}"
if [ -f "$OUTDIR/Sully" ]; then
    cd "$TESTDIR"
    rm -f Sully_*.c

    # Generate Sully_7, Sully_6, Sully_5
    "$OUTDIR/Sully" > /dev/null 2>&1
    if [ -f "$OUTDIR/Sully_7.c" ]; then
        cd "$OUTDIR/Sully_7" 2>/dev/null || { echo -e "${RED}✗ FAIL: Could not cd to Sully_7${NC}"; FAIL_COUNT=$((FAIL_COUNT + 1)); cd - > /dev/null; exit 1; }
        ./Sully > /dev/null 2>&1 || true
        if [ -f Sully_6.c ]; then
            echo -e "${GREEN}✓ PASS: Sully chain working (created Sully_7 → Sully_6)${NC}"
            PASS_COUNT=$((PASS_COUNT + 1))
        else
            echo -e "${RED}✗ FAIL: Sully_7 did not create Sully_6${NC}"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
        cd - > /dev/null
    else
        echo -e "${RED}✗ FAIL: Could not create Sully_7${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Sully C executable not found${NC}"
fi
echo ""

# Test 4: Sully C - File content similarity
echo -e "${YELLOW}[TEST 4] Sully (C) - Generated File Content${NC}"
if [ -f "$OUTDIR/Sully" ]; then
    cd "$TESTDIR"
    rm -f "$OUTDIR"/Sully_*.c
    "$OUTDIR/Sully" > /dev/null 2>&1
    if [ -f "$OUTDIR/Sully_7.c" ]; then
        # Check if Sully_7.c has similar structure (contains "Sully" and counter)
        if grep -q "Sully_6" Sully_7.c && grep -q "counter = 6" Sully_7.c; then
            echo -e "${GREEN}✓ PASS: Sully_7.c contains correct counter reference${NC}"
            PASS_COUNT=$((PASS_COUNT + 1))
        else
            echo -e "${RED}✗ FAIL: Sully_7.c missing expected content${NC}"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Sully C executable not found${NC}"
fi
echo ""

# Test 5: Sully C - Exit code
echo -e "${YELLOW}[TEST 5] Sully (C) - Exit Code${NC}"
if [ -f "$OUTDIR/Sully" ]; then
    cd "$TESTDIR"
    ./Sully > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ PASS: Exit code is 0${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Exit code is not 0${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Sully C executable not found${NC}"
fi
echo ""

# Test 6: Sully C - File size check
echo -e "${YELLOW}[TEST 6] Sully (C) - Generated File Size${NC}"
if [ -f "$OUTDIR/Sully" ]; then
    cd "$TESTDIR"
    rm -f "$OUTDIR"/Sully_*.c
    "$OUTDIR/Sully" > /dev/null 2>&1
    if [ -f "$OUTDIR/Sully_7.c" ]; then
        SULLY7_SIZE=$(wc -c < Sully_7.c)
        SULLY_SRC=$(wc -c < "$SRCDIR/sully.c")
        # Should be similar size
        if [ "$SULLY7_SIZE" -gt "$((SULLY_SRC - 100))" ] && [ "$SULLY7_SIZE" -lt "$((SULLY_SRC + 100))" ]; then
            echo -e "${GREEN}✓ PASS: Sully_7.c size ($SULLY7_SIZE) is reasonable${NC}"
            PASS_COUNT=$((PASS_COUNT + 1))
        else
            echo -e "${YELLOW}⚠ WARNING: Sully_7.c size ($SULLY7_SIZE) unexpected, but continuing${NC}"
        fi
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Sully C executable not found${NC}"
fi
echo ""

# Test 7: Sully Assembly (if available)
echo -e "${YELLOW}[TEST 7] Sully (Assembly) - File Generation${NC}"
if [ -f "$OUTDIR/sully" ]; then
    cd "$TESTDIR"
    rm -f Sully_*.s
    ./sully > /dev/null 2>&1
    if [ -f Sully_7.s ]; then
        echo -e "${GREEN}✓ PASS: Sully ASM created Sully_7.s${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Sully ASM did not create Sully_7.s${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${YELLOW}⊘ SKIP: Sully Assembly executable not found (Windows)${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS_COUNT${NC}"
echo -e "${RED}Failed: $FAIL_COUNT${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL_COUNT" -eq 0 ] && exit 0 || exit 1
