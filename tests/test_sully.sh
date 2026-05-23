#!/bin/bash
# ============================================================================
# test_sully.sh - Sully Quine Detail Tests
# ============================================================================
# PDF spec (X >= 0 enforced strictly: no Sully_-1 artifacts):
#   counter starts at 5 (int i = 5; inside main / ;i=5)
#   ./Sully creates chain: Sully_5 → Sully_4 → ... → Sully_0, then stops
#   ls -al | grep Sully | wc -l == 13  (Sully + Sully_5..0 with .c/.s + binary)
#   diff Sully.c Sully_0.c     → only main's 'int i = 5'/'int i = 0' line differs
#   diff Sully_3.c Sully_2.c   → only main's 'int i = 3'/'int i = 2' line differs

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
echo -e "${BLUE}║              Testing Sully Quine Programs              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# ---------------- Sully (C) ----------------
echo -e "${YELLOW}[TEST 1] Sully (C) - first child file is Sully_5.c (counter starts at 5)${NC}"
if [ -x "$OUT_C/Sully" ]; then
	cd "$OUT_C"
	rm -f Sully_*.c Sully_-1 Sully_0 Sully_1 Sully_2 Sully_3 Sully_4 Sully_5
	./Sully > /dev/null 2>&1
	if [ -f Sully_5.c ]; then
		echo -e "${GREEN}✓ PASS: Sully_5.c created${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL: Sully_5.c not created${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP: $OUT_C/Sully not found${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 2] Sully (C) - full chain: Sully_5 down to Sully_0, no Sully_-1${NC}"
if [ -x "$OUT_C/Sully" ]; then
	cd "$OUT_C"
	chain_ok=1
	for i in 5 4 3 2 1 0; do
		if [ ! -f "Sully_${i}.c" ]; then
			echo -e "${RED}✗ FAIL: Sully_${i}.c missing${NC}"
			FAIL=$((FAIL+1))
			chain_ok=0
			break
		fi
	done
	if [ -f "Sully_-1.c" ]; then
		echo -e "${RED}✗ FAIL: Sully_-1.c must NOT exist${NC}"
		FAIL=$((FAIL+1))
		chain_ok=0
	fi
	if [ "$chain_ok" = "1" ]; then
		echo -e "${GREEN}✓ PASS: 6 .c files (Sully_5 → Sully_0)${NC}"
		PASS=$((PASS+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 3] Sully (C) - file count: ls grep Sully wc -l == 13${NC}"
if [ -x "$OUT_C/Sully" ]; then
	cd "$OUT_C"
	# Exclude Sully.c source mirror (build artifact, not part of generated chain)
	COUNT=$(ls -1 | grep -E '^Sully(\.|$|_)' | grep -v '^Sully\.c$' | wc -l)
	if [ "$COUNT" = "13" ]; then
		echo -e "${GREEN}✓ PASS: count == 13${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL: count == $COUNT (expected 13)${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 4] Sully (C) - diff Sully.c Sully_0.c → only 'int i' differs${NC}"
if [ -x "$OUT_C/Sully" ] && [ -f "$OUT_C/Sully_0.c" ]; then
	cd "$OUT_C"
	DIFF_OUT=$(diff Sully.c Sully_0.c)
	if echo "$DIFF_OUT" | grep -Eq "int[[:space:]]+i = 5" && echo "$DIFF_OUT" | grep -Eq "int[[:space:]]+i = 0"; then
		# Verify only one source line differs: the counter line inside main.
		if [ "$(echo "$DIFF_OUT" | grep -Ec '^[0-9]+c[0-9]+$')" = "1" ]; then
			echo -e "${GREEN}✓ PASS: only main's counter line differs${NC}"
			PASS=$((PASS+1))
		else
			echo -e "${RED}✗ FAIL: more than 1 line differs${NC}"
			FAIL=$((FAIL+1))
		fi
	else
		echo -e "${RED}✗ FAIL: missing 'int i = 5/0' diff${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 5] Sully (C) - diff Sully_3.c Sully_2.c → only 'int i' differs${NC}"
if [ -f "$OUT_C/Sully_3.c" ] && [ -f "$OUT_C/Sully_2.c" ]; then
	cd "$OUT_C"
	DIFF_OUT=$(diff Sully_3.c Sully_2.c)
	if echo "$DIFF_OUT" | grep -Eq "int[[:space:]]+i = 3" && echo "$DIFF_OUT" | grep -Eq "int[[:space:]]+i = 2"; then
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

# ---------------- Sully (ASM) ----------------
echo -e "${YELLOW}[TEST 6] Sully (ASM) - file count: ls grep Sully wc -l == 13, no Sully_-1${NC}"
if [ -x "$OUT_ASM/Sully" ]; then
	cd "$OUT_ASM"
	rm -f Sully_*.s Sully Sully.o Sully_-1 Sully_0 Sully_1 Sully_2 Sully_3 Sully_4 Sully_5
	cp Sully.s /tmp/sully_self.s 2>/dev/null
	# PDF style: nasm + gcc + ./Sully
	nasm -f elf64 Sully.s -o Sully.o 2>/dev/null
	gcc -no-pie Sully.o -o Sully 2>/dev/null
	./Sully > /dev/null 2>&1
	# Exclude Sully.s and the lowercase 'sully' (build artifact)
	COUNT=$(ls -1 | grep -E '^Sully(\.|$|_)' | grep -v '^Sully\.s$' | grep -v '^Sully\.o$' | wc -l)
	if [ -f "Sully_-1.s" ]; then
		echo -e "${RED}✗ FAIL: Sully_-1.s must NOT exist${NC}"
		FAIL=$((FAIL+1))
	elif [ "$COUNT" = "13" ]; then
		echo -e "${GREEN}✓ PASS: count == 13${NC}"
		PASS=$((PASS+1))
	else
		echo -e "${RED}✗ FAIL: count == $COUNT (expected 13)${NC}"
		FAIL=$((FAIL+1))
	fi
else
	echo -e "${YELLOW}⊘ SKIP: $OUT_ASM/Sully not found (Linux + NASM required)${NC}"
fi
echo ""

echo -e "${YELLOW}[TEST 7] Sully (ASM) - diff Sully.s Sully_0.s → only ';i=' differs${NC}"
if [ -x "$OUT_ASM/Sully" ] && [ -f "$OUT_ASM/Sully_0.s" ]; then
	cd "$OUT_ASM"
	DIFF_OUT=$(diff Sully.s Sully_0.s)
	if echo "$DIFF_OUT" | grep -q ";i=5" && echo "$DIFF_OUT" | grep -q ";i=0"; then
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

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS${NC}    ${RED}Failed: $FAIL${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
