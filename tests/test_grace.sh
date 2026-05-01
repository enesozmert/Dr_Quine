#!/bin/bash
# ============================================================================
# test_grace.sh - Test Grace Quine (File Writing)
# ============================================================================
# Tests that Grace writes its own source code to a file

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
echo -e "${BLUE}║              Testing Grace Quine Programs              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

# Test 1: Grace C - File creation
echo -e "${YELLOW}[TEST 1] Grace (C) - File Creation${NC}"
if [ -f "$OUTDIR/Grace" ]; then
    cd "$TESTDIR"  # Run from project root
    rm -f "$OUTDIR/Grace_kid.c"
    "$OUTDIR/Grace" > /dev/null 2>&1
    if [ -f "$OUTDIR/Grace_kid.c" ]; then
        echo -e "${GREEN}✓ PASS: Grace created Grace_kid.c${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Grace did not create Grace_kid.c${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Grace C executable not found${NC}"
fi
echo ""

# Test 2: Grace C - File content matches source
echo -e "${YELLOW}[TEST 2] Grace (C) - Content Match${NC}"
if [ -f "$OUTDIR/Grace" ]; then
    cd "$TESTDIR"
    rm -f Grace_kid.c
    ./Grace > /dev/null 2>&1
    if [ -f Grace_kid.c ] && diff -q Grace_kid.c "$SRCDIR/grace.c" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS: Grace_kid.c matches grace.c${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Grace_kid.c does not match grace.c${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Grace C executable not found${NC}"
fi
echo ""

# Test 3: Grace C - File size check
echo -e "${YELLOW}[TEST 3] Grace (C) - File Size${NC}"
if [ -f "$OUTDIR/Grace" ]; then
    cd "$TESTDIR"
    rm -f Grace_kid.c
    ./Grace > /dev/null 2>&1
    if [ -f Grace_kid.c ]; then
        SOURCE_SIZE=$(wc -c < "$SRCDIR/grace.c")
        CREATED_SIZE=$(wc -c < Grace_kid.c)
        if [ "$SOURCE_SIZE" -eq "$CREATED_SIZE" ]; then
            echo -e "${GREEN}✓ PASS: File size ($CREATED_SIZE bytes) matches source${NC}"
            PASS_COUNT=$((PASS_COUNT + 1))
        else
            echo -e "${RED}✗ FAIL: Size mismatch (source: $SOURCE_SIZE, created: $CREATED_SIZE)${NC}"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Grace C executable not found${NC}"
fi
echo ""

# Test 4: Grace C - Reproducibility (run twice)
echo -e "${YELLOW}[TEST 4] Grace (C) - Reproducibility${NC}"
if [ -f "$OUTDIR/Grace" ]; then
    cd "$TESTDIR"
    rm -f Grace_kid.c Grace_kid2.c
    ./Grace > /dev/null 2>&1
    cp Grace_kid.c Grace_kid2.c
    ./Grace > /dev/null 2>&1
    if diff -q Grace_kid.c Grace_kid2.c > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS: Grace produces identical output on repeated runs${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Grace output differs on repeated runs${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    rm -f Grace_kid2.c
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Grace C executable not found${NC}"
fi
echo ""

# Test 5: Grace C - Exit code
echo -e "${YELLOW}[TEST 5] Grace (C) - Exit Code${NC}"
if [ -f "$OUTDIR/Grace" ]; then
    cd "$TESTDIR"
    ./Grace > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ PASS: Exit code is 0${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Exit code is not 0${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${RED}✗ SKIP: Grace C executable not found${NC}"
fi
echo ""

# Test 6: Grace Assembly (if available)
echo -e "${YELLOW}[TEST 6] Grace (Assembly) - File Creation${NC}"
if [ -f "$OUTDIR/grace" ]; then
    cd "$TESTDIR"
    rm -f Grace_kid.s
    ./grace > /dev/null 2>&1
    if [ -f Grace_kid.s ] && diff -q Grace_kid.s "$SRCDIR/grace.s" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS: Grace ASM created matching Grace_kid.s${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Grace ASM failed${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    cd - > /dev/null
else
    echo -e "${YELLOW}⊘ SKIP: Grace Assembly executable not found (Windows)${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS_COUNT${NC}"
echo -e "${RED}Failed: $FAIL_COUNT${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL_COUNT" -eq 0 ] && exit 0 || exit 1
