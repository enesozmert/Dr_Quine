#!/bin/bash
# ============================================================================
# test_python.sh - Test Python Bonus Implementation
# ============================================================================
# Tests three independent Python quines: Colleen.py, Grace.py, Sully.py
# No argv, no source file reads. Sully chain: Sully + Sully_5..0 (count=7),
# no Sully_-1.py, initial i=-1 must be noop.
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BONUSDIR="$ROOT/bonus"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Testing Python Bonus Implementation          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}⊘ Python3 not found. Skipping Python tests.${NC}"
    exit 0
fi

echo -e "${YELLOW}Using: $(python3 --version)${NC}"
echo ""

pass() { echo -e "${GREEN}✓ PASS: $1${NC}"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail() { echo -e "${RED}✗ FAIL: $1${NC}"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

# ---------------- Colleen ----------------
echo -e "${YELLOW}[TEST 1] Colleen.py - stdout byte-identical to source${NC}"
if [ -f "$BONUSDIR/Colleen.py" ]; then
    cp "$BONUSDIR/Colleen.py" "$WORK/Colleen.py"
    ( cd "$WORK" && python3 Colleen.py > out_colleen )
    if diff -q "$WORK/Colleen.py" "$WORK/out_colleen" > /dev/null; then
        pass "Colleen.py self-print matches source"
    else
        fail "Colleen.py output differs from source"
    fi
else
    fail "Colleen.py not found"
fi
echo ""

# ---------------- Grace ----------------
echo -e "${YELLOW}[TEST 2] Grace.py - creates Grace_kid.py byte-identical to source${NC}"
if [ -f "$BONUSDIR/Grace.py" ]; then
    cp "$BONUSDIR/Grace.py" "$WORK/Grace.py"
    ( cd "$WORK" && rm -f Grace_kid.py && python3 Grace.py )
    if [ -f "$WORK/Grace_kid.py" ] && diff -q "$WORK/Grace.py" "$WORK/Grace_kid.py" > /dev/null; then
        pass "Grace_kid.py == Grace.py"
    else
        fail "Grace.py did not produce matching Grace_kid.py"
    fi
else
    fail "Grace.py not found"
fi
echo ""

# ---------------- Sully ----------------
echo -e "${YELLOW}[TEST 3] Sully.py - full chain Sully_5..0, count=7, no Sully_-1.py${NC}"
if [ -f "$BONUSDIR/Sully.py" ]; then
    mkdir -p "$WORK/sully_t"
    cp "$BONUSDIR/Sully.py" "$WORK/sully_t/Sully.py"
    ( cd "$WORK/sully_t" && python3 Sully.py )
    chain_ok=1
    for i in 5 4 3 2 1 0; do
        [ -f "$WORK/sully_t/Sully_${i}.py" ] || { fail "Sully_${i}.py missing"; chain_ok=0; break; }
    done
    if [ -f "$WORK/sully_t/Sully_-1.py" ]; then
        fail "Sully_-1.py must NOT exist"
        chain_ok=0
    fi
    if [ "$chain_ok" = "1" ]; then
        pass "Chain Sully_5..0 complete, no Sully_-1.py"
    fi
    COUNT=$(ls -1 "$WORK/sully_t" | grep -E '^Sully(\.|_)' | wc -l)
    if [ "$COUNT" = "7" ]; then
        pass "Sully count == 7 (Sully + Sully_5..0)"
    else
        fail "Sully count = $COUNT (expected 7)"
    fi
else
    fail "Sully.py not found"
fi
echo ""

echo -e "${YELLOW}[TEST 4] Sully.py - Sully_5.py byte-identical to Sully.py${NC}"
if [ -f "$WORK/sully_t/Sully_5.py" ]; then
    if diff -q "$WORK/sully_t/Sully.py" "$WORK/sully_t/Sully_5.py" > /dev/null; then
        pass "Sully_5.py == Sully.py"
    else
        fail "Sully_5.py differs from Sully.py"
    fi
else
    fail "Sully_5.py missing"
fi
echo ""

echo -e "${YELLOW}[TEST 5] Sully.py - Sully_4.py only counter differs${NC}"
if [ -f "$WORK/sully_t/Sully_4.py" ]; then
    DIFF_OUT=$(diff "$WORK/sully_t/Sully.py" "$WORK/sully_t/Sully_4.py")
    if echo "$DIFF_OUT" | grep -q 'i = 5' && echo "$DIFF_OUT" | grep -q 'i = 4'; then
        pass "Sully_4.py only counter differs"
    else
        fail "Sully_4.py unexpected diff"
    fi
else
    fail "Sully_4.py missing"
fi
echo ""

echo -e "${YELLOW}[TEST 6] Sully.py - initial i=-1 must be noop${NC}"
if [ -f "$BONUSDIR/Sully.py" ]; then
    mkdir -p "$WORK/sully_neg"
    sed 's/^i = 5/i = -1/' "$BONUSDIR/Sully.py" > "$WORK/sully_neg/S_neg.py"
    ( cd "$WORK/sully_neg" && python3 S_neg.py )
    if [ -f "$WORK/sully_neg/Sully_-1.py" ]; then
        fail "Sully with i=-1 created Sully_-1.py"
    else
        ARTIFACTS=$(ls -1 "$WORK/sully_neg" | grep -v '^S_neg.py$' | wc -l)
        if [ "$ARTIFACTS" = "0" ]; then
            pass "Sully with i=-1 produced no files (noop)"
        else
            fail "Sully with i=-1 produced $ARTIFACTS files"
        fi
    fi
fi
echo ""

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS_COUNT${NC}   ${RED}Failed: $FAIL_COUNT${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL_COUNT" -eq 0 ] && exit 0 || exit 1
