#!/bin/bash
# ============================================================================
# test_grace.sh - Grace Quine Detail Tests
# ============================================================================
# PDF spec: ./Grace; diff Grace.c Grace_kid.c  → no output (byte-identical)

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
echo -e "${BLUE}║              Testing Grace Quine Programs              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# ---------------- Grace (C) ----------------
echo -e "${YELLOW}[TEST 1] Grace (C) - creates Grace_kid.c${NC}"
if [ -x "$OUT_C/Grace" ]; then
	cd "$OUT_C" && rm -f Grace_kid.c
	./Grace
	if [ -f Grace_kid.c ]; then
		echo -e "${GREEN}✓ PASS${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL: Grace_kid.c not created${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP: $OUT_C/Grace not found${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 2] Grace (C) - Grace_kid.c byte-identical to Grace.c${NC}"
if [ -x "$OUT_C/Grace" ] && [ -f "$OUT_C/Grace_kid.c" ]; then
	cd "$OUT_C"
	if diff -q Grace.c Grace_kid.c > /dev/null 2>&1; then
		echo -e "${GREEN}✓ PASS${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL${NC}"
		diff Grace.c Grace_kid.c | head -5
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 3] Grace (C) - reproducibility (run twice → identical)${NC}"
if [ -x "$OUT_C/Grace" ]; then
	cd "$OUT_C"
	rm -f Grace_kid.c
	./Grace && cp Grace_kid.c /tmp/grace_kid_first.c
	rm -f Grace_kid.c
	./Grace
	if diff -q Grace_kid.c /tmp/grace_kid_first.c > /dev/null 2>&1; then
		echo -e "${GREEN}✓ PASS: deterministic output${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL: output differs between runs${NC}"
		FAIL=$((FAIL+1))
	fi
	rm -f /tmp/grace_kid_first.c
else
	echo -e "${YELLOW}⊘ SKIP${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 4] Grace (C) - exit code 0${NC}"
if [ -x "$OUT_C/Grace" ]; then
	cd "$OUT_C"
	./Grace > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}✓ PASS${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP${NC}"
fi
echo ""

# ---------------- Grace (ASM) ----------------
echo -e "${YELLOW}[TEST 5] Grace (ASM) - creates Grace_kid.s byte-identical to Grace.s${NC}"
if [ -x "$OUT_ASM/grace" ]; then
	cd "$OUT_ASM" && rm -f Grace_kid.s
	./grace
	if [ -f Grace_kid.s ] && diff -q Grace.s Grace_kid.s > /dev/null 2>&1; then
		echo -e "${GREEN}✓ PASS${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP: $OUT_ASM/grace not found (Linux + NASM required)${NC}"
fi
echo ""

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS${NC}    ${RED}Failed: $FAIL${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
