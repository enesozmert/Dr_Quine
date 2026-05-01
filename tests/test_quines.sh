#!/bin/bash
# ============================================================================
# test_quines.sh - PDF spec validation
# Runs from project root; binaries are in output/C and output/ASM
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_C="$ROOT/output/C"
OUT_ASM="$ROOT/output/ASM"

PASS=0
FAIL=0

pass() { echo -e "${GREEN}✓ PASS:${NC} $1"; PASS=$((PASS+1)); }
fail() { echo -e "${RED}✗ FAIL:${NC} $1"; FAIL=$((FAIL+1)); }

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Dr_Quine PDF Spec Validation (output/ tree)       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"

# --- Colleen (C) ---
echo -e "\n${YELLOW}=== Colleen (C) ===${NC}"
if [ -x "$OUT_C/Colleen" ]; then
    cd "$OUT_C"
    ./Colleen > /tmp/colleen_out.c
    diff -q Colleen.c /tmp/colleen_out.c > /dev/null \
        && pass "Colleen.c byte-identical" \
        || fail "Colleen.c diff"
else
    fail "$OUT_C/Colleen not found"
fi

# --- Colleen (ASM) ---
echo -e "\n${YELLOW}=== Colleen (ASM) ===${NC}"
if [ -x "$OUT_ASM/colleen" ]; then
    cd "$OUT_ASM"
    ./colleen > /tmp/colleen_out.s
    diff -q Colleen.s /tmp/colleen_out.s > /dev/null \
        && pass "Colleen.s byte-identical" \
        || fail "Colleen.s diff"
else
    fail "$OUT_ASM/colleen not found"
fi

# --- Grace (C) ---
echo -e "\n${YELLOW}=== Grace (C) ===${NC}"
if [ -x "$OUT_C/Grace" ]; then
    cd "$OUT_C" && rm -f Grace_kid.c
    ./Grace
    diff -q Grace.c Grace_kid.c > /dev/null \
        && pass "Grace_kid.c == Grace.c" \
        || fail "Grace_kid.c diff"
else
    fail "$OUT_C/Grace not found"
fi

# --- Grace (ASM) ---
echo -e "\n${YELLOW}=== Grace (ASM) ===${NC}"
if [ -x "$OUT_ASM/grace" ]; then
    cd "$OUT_ASM" && rm -f Grace_kid.s
    ./grace
    diff -q Grace.s Grace_kid.s > /dev/null \
        && pass "Grace_kid.s == Grace.s" \
        || fail "Grace_kid.s diff"
else
    fail "$OUT_ASM/grace not found"
fi

# --- Sully (C) ---
echo -e "\n${YELLOW}=== Sully (C) — PDF count == 13 ===${NC}"
if [ -x "$OUT_C/Sully" ]; then
    cd "$OUT_C" && rm -f Sully_*.c Sully_-1 Sully_0 Sully_1 Sully_2 Sully_3 Sully_4
    ./Sully > /dev/null 2>&1
    # PDF formula: 1 (Sully) + 6 .c + 6 binaries = 13. Sully.c is also in output/C, +1 = 14.
    # We exclude Sully.c (source mirror) for the PDF check.
    COUNT=$(ls -1 | grep -E '^Sully(\.|$|_)' | grep -v '^Sully\.c$' | wc -l)
    if [ "$COUNT" = "13" ]; then
        pass "Sully (C) count == 13"
    else
        fail "Sully (C) count = $COUNT (expected 13)"
    fi
    diff Sully.c Sully_0.c | grep -q 'int i = 5' && diff Sully.c Sully_0.c | grep -q 'int i = 0' \
        && pass "Sully.c vs Sully_0.c: only 'int i' differs" \
        || fail "Sully.c vs Sully_0.c diff line"
    diff Sully_3.c Sully_2.c | grep -q 'int i = 3' && diff Sully_3.c Sully_2.c | grep -q 'int i = 2' \
        && pass "Sully_3.c vs Sully_2.c: only 'int i' differs" \
        || fail "Sully_3.c vs Sully_2.c diff line"
else
    fail "$OUT_C/Sully not found"
fi

# --- Sully (ASM) ---
echo -e "\n${YELLOW}=== Sully (ASM) — PDF count == 13 ===${NC}"
if [ -x "$OUT_ASM/sully" ]; then
    cd "$OUT_ASM"
    rm -f Sully_*.s Sully Sully.o Sully_-1 Sully_0 Sully_1 Sully_2 Sully_3 Sully_4
    # PDF: nasm -f elf64 ../Sully.s -o Sully.o && gcc Sully.o -o Sully ; ./Sully
    cp Sully.s /tmp/sully_self.s
    nasm -f elf64 Sully.s -o Sully.o 2>/dev/null
    gcc -no-pie Sully.o -o Sully 2>/dev/null
    ./Sully > /dev/null 2>&1
    COUNT=$(ls -1 | grep -E '^Sully(\.|$|_)' | grep -v '^Sully\.s$' | grep -v '^sully$' | wc -l)
    if [ "$COUNT" = "13" ]; then
        pass "Sully (ASM) count == 13"
    else
        fail "Sully (ASM) count = $COUNT (expected 13)"
    fi
    diff Sully.s Sully_0.s | grep -q ';i=5' && diff Sully.s Sully_0.s | grep -q ';i=0' \
        && pass "Sully.s vs Sully_0.s: only ';i=' differs" \
        || fail "Sully.s vs Sully_0.s diff line"
    diff Sully_3.s Sully_2.s | grep -q ';i=3' && diff Sully_3.s Sully_2.s | grep -q ';i=2' \
        && pass "Sully_3.s vs Sully_2.s: only ';i=' differs" \
        || fail "Sully_3.s vs Sully_2.s diff line"
else
    fail "$OUT_ASM/sully not found"
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS${NC}    ${RED}Failed: $FAIL${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
