#!/bin/bash
# ============================================================================
# test_colleen.sh - Test Colleen Quine (Stdout Output)
# ============================================================================
# Tests that Colleen outputs its own source code to stdout

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
echo -e "${BLUE}║              Testing Colleen Quine Programs            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Test 1: Colleen C - Output to stdout
echo -e "${YELLOW}[TEST 1] Colleen (C) - Stdout Output${NC}"
if [ -f "$OUTDIR/Colleen" ]; then
    "$OUTDIR/Colleen" > "$OUTDIR/colleen_c_test.txt" 2>&1
    if diff -q "$OUTDIR/colleen_c_test.txt" "$SRCDIR/colleen.c" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS: Colleen C output matches source${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Colleen C output does not match source${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        echo "  Diff:"
        diff "$OUTDIR/colleen_c_test.txt" "$SRCDIR/colleen.c" | head -5
    fi
else
    echo -e "${RED}✗ SKIP: Colleen C executable not found${NC}"
fi
echo ""

# Test 2: Colleen C - Output size check
echo -e "${YELLOW}[TEST 2] Colleen (C) - Output Size${NC}"
if [ -f "$OUTDIR/Colleen" ]; then
    SOURCE_SIZE=$(wc -c < "$SRCDIR/colleen.c")
    OUTPUT_SIZE=$("$OUTDIR/Colleen" 2>/dev/null | wc -c)
    if [ "$SOURCE_SIZE" -eq "$OUTPUT_SIZE" ]; then
        echo -e "${GREEN}✓ PASS: Output size ($OUTPUT_SIZE bytes) matches source${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Size mismatch (source: $SOURCE_SIZE, output: $OUTPUT_SIZE)${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
else
    echo -e "${RED}✗ SKIP: Colleen C executable not found${NC}"
fi
echo ""

# Test 3: Colleen C - No empty output
echo -e "${YELLOW}[TEST 3] Colleen (C) - Non-empty Output${NC}"
if [ -f "$OUTDIR/Colleen" ]; then
    OUTPUT_LINES=$("$OUTDIR/Colleen" 2>/dev/null | wc -l)
    if [ "$OUTPUT_LINES" -gt 0 ]; then
        echo -e "${GREEN}✓ PASS: Output has $OUTPUT_LINES lines${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Output is empty${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
else
    echo -e "${RED}✗ SKIP: Colleen C executable not found${NC}"
fi
echo ""

# Test 4: Colleen C - Exit code
echo -e "${YELLOW}[TEST 4] Colleen (C) - Exit Code${NC}"
if [ -f "$OUTDIR/Colleen" ]; then
    "$OUTDIR/Colleen" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ PASS: Exit code is 0${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Exit code is not 0${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
else
    echo -e "${RED}✗ SKIP: Colleen C executable not found${NC}"
fi
echo ""

# Test 5: Colleen Assembly - Output to stdout (if available)
echo -e "${YELLOW}[TEST 5] Colleen (Assembly) - Stdout Output${NC}"
if [ -f "$OUTDIR/colleen" ]; then
    "$OUTDIR/colleen" > "$OUTDIR/colleen_asm_test.s" 2>&1
    if diff -q "$OUTDIR/colleen_asm_test.s" "$SRCDIR/colleen.s" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS: Colleen ASM output matches source${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL: Colleen ASM output does not match source${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
else
    echo -e "${YELLOW}⊘ SKIP: Colleen Assembly executable not found (Windows)${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $((PASS_COUNT))${NC}"
echo -e "${RED}Failed: $((FAIL_COUNT))${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL_COUNT" -eq 0 ] && exit 0 || exit 1
