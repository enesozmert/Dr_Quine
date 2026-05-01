#!/bin/bash
# ============================================================================
# test_colleen.sh - Colleen Quine Detail Tests
# ============================================================================
# PDF spec: ./Colleen > tmp; diff tmp Colleen.c  → no output (byte-identical)

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

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              Testing Colleen Quine Programs            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# ---------------- Colleen (C) ----------------
echo -e "${YELLOW}[TEST 1] Colleen (C) - byte-identical stdout output${NC}"
if [ -x "$OUT_C/Colleen" ]; then
	cd "$OUT_C"
	./Colleen > /tmp/colleen_c_out
	if diff -q Colleen.c /tmp/colleen_c_out > /dev/null 2>&1; then
		echo -e "${GREEN}✓ PASS: output == Colleen.c${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL: diff differs${NC}"
		diff Colleen.c /tmp/colleen_c_out | head -5
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP: $OUT_C/Colleen not found (run 'make c')${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 2] Colleen (C) - exit code 0${NC}"
if [ -x "$OUT_C/Colleen" ]; then
	"$OUT_C/Colleen" > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}✓ PASS${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL: non-zero exit${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 3] Colleen (C) - non-empty output${NC}"
if [ -x "$OUT_C/Colleen" ]; then
	BYTES=$("$OUT_C/Colleen" | wc -c)
	if [ "$BYTES" -gt 0 ]; then
		echo -e "${GREEN}✓ PASS: $BYTES bytes${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL: empty output${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP${NC}"
fi
echo ""

# ---------------- Colleen (ASM) ----------------
echo -e "${YELLOW}[TEST 4] Colleen (ASM) - byte-identical stdout output${NC}"
if [ -x "$OUT_ASM/colleen" ]; then
	cd "$OUT_ASM"
	./colleen > /tmp/colleen_asm_out
	if diff -q Colleen.s /tmp/colleen_asm_out > /dev/null 2>&1; then
		echo -e "${GREEN}✓ PASS: output == Colleen.s${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL: diff differs${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP: $OUT_ASM/colleen not found (Linux + NASM required)${NC}"
fi
echo ""

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS${NC}    ${RED}Failed: $FAIL${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
