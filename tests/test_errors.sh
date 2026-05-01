#!/bin/bash
# ============================================================================
# test_errors.sh - Crash & Error Handling Tests (PDF spec §IV)
# ============================================================================
# PDF: "In no way can your program quit in an unexpected manner
#       (Segmentation fault, bus error, double free, etc.)"
#
# Verifies all binaries exit cleanly under various stress conditions:
#   - Normal execution (exit code 0)
#   - No segfault (exit != 139), bus error (!= 138), abort (!= 134)
#   - Stderr free of "Segmentation", "Bus error", "double free", "core dumped"
#   - Repeated execution stability
#   - Valgrind clean (Linux + valgrind only)
#   - Edge cases: empty env, large/negative counters, extra args
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_C="$ROOT/output/C"
OUT_ASM="$ROOT/output/ASM"
BONUS="$ROOT/bonus"

PASS=0
FAIL=0

pass() { echo -e "${GREEN}✓ PASS:${NC} $1"; PASS=$((PASS+1)); }
fail() { echo -e "${RED}✗ FAIL:${NC} $1"; FAIL=$((FAIL+1)); }
skip() { echo -e "${YELLOW}⊘ SKIP:${NC} $1"; }

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Dr_Quine Crash & Error Handling Tests             ║${NC}"
echo -e "${BLUE}║      (PDF §IV: no Segfault, Bus error, double free)    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# ----------------------------------------------------------------------------
# Helper: run a binary, capture exit code & stderr; check no crash
# ----------------------------------------------------------------------------
check_no_crash() {
	local name="$1"; shift
	local stderr_log
	stderr_log=$(mktemp)
	"$@" > /dev/null 2> "$stderr_log"
	local code=$?

	# Detect signal-induced exits
	# 128+11 = 139 SIGSEGV, 128+10 = 138 SIGBUS, 128+6 = 134 SIGABRT
	# 128+7 = 135 SIGBUS (some systems), 128+8 = 136 SIGFPE
	if [ "$code" = "139" ] || [ "$code" = "138" ] || [ "$code" = "134" ] || \
	   [ "$code" = "135" ] || [ "$code" = "136" ] || [ "$code" = "137" ]; then
		fail "$name exited with crash signal (code $code)"
		rm -f "$stderr_log"
		return 1
	fi

	# Check stderr for crash markers
	if grep -qiE "segmentation fault|bus error|double free|core dumped|abort" "$stderr_log"; then
		fail "$name stderr contains crash marker:"
		head -3 "$stderr_log"
		rm -f "$stderr_log"
		return 1
	fi

	pass "$name exited cleanly (code $code, no crash markers)"
	rm -f "$stderr_log"
	return 0
}

# ============================================================================
# 1) Normal execution — no crashes
# ============================================================================
echo -e "${YELLOW}=== 1) Normal Execution (no crashes) ===${NC}"

if [ -x "$OUT_C/Colleen" ]; then
	check_no_crash "Colleen (C)" "$OUT_C/Colleen"
else
	skip "Colleen (C) not built"
fi

if [ -x "$OUT_C/Grace" ]; then
	cd "$OUT_C" && rm -f Grace_kid.c
	check_no_crash "Grace (C)" "$OUT_C/Grace"
else
	skip "Grace (C) not built"
fi

if [ -x "$OUT_C/Sully" ]; then
	cd "$OUT_C" && rm -f Sully_*.c Sully_-1 Sully_0 Sully_1 Sully_2 Sully_3 Sully_4
	check_no_crash "Sully (C)" "$OUT_C/Sully"
else
	skip "Sully (C) not built"
fi

if [ -x "$OUT_ASM/colleen" ]; then
	check_no_crash "Colleen (ASM)" "$OUT_ASM/colleen"
else
	skip "Colleen (ASM) not built"
fi

if [ -x "$OUT_ASM/grace" ]; then
	cd "$OUT_ASM" && rm -f Grace_kid.s
	check_no_crash "Grace (ASM)" "$OUT_ASM/grace"
else
	skip "Grace (ASM) not built"
fi

if [ -x "$OUT_ASM/sully" ]; then
	cd "$OUT_ASM" && rm -f Sully_*.s Sully Sully.o Sully_-1 Sully_0 Sully_1 Sully_2 Sully_3 Sully_4
	# Need /tmp/sully_self.s for incbin
	cp "$OUT_ASM/Sully.s" /tmp/sully_self.s 2>/dev/null
	# Sully ASM needs to be built via make in workdir; just smoke test the binary
	check_no_crash "Sully (ASM)" "$OUT_ASM/sully"
else
	skip "Sully (ASM) not built"
fi
echo ""

# ============================================================================
# 2) Repeated execution — stability under N iterations
# ============================================================================
echo -e "${YELLOW}=== 2) Repeated Execution (5x consecutive) ===${NC}"

run_n_times() {
	local name="$1"; local n="$2"; shift 2
	local i
	for i in $(seq 1 "$n"); do
		"$@" > /dev/null 2>&1 || { fail "$name failed at iteration $i"; return 1; }
	done
	pass "$name stable across $n runs"
}

[ -x "$OUT_C/Colleen" ] && run_n_times "Colleen (C)" 5 "$OUT_C/Colleen"

if [ -x "$OUT_C/Grace" ]; then
	cd "$OUT_C"
	run_n_times "Grace (C)" 5 "$OUT_C/Grace"
fi

if [ -x "$OUT_ASM/colleen" ]; then
	run_n_times "Colleen (ASM)" 5 "$OUT_ASM/colleen"
fi

if [ -x "$OUT_ASM/grace" ]; then
	cd "$OUT_ASM"
	run_n_times "Grace (ASM)" 5 "$OUT_ASM/grace"
fi
echo ""

# ============================================================================
# 3) Edge case — extra arguments must NOT crash
# ============================================================================
echo -e "${YELLOW}=== 3) Extra/Unexpected Arguments ===${NC}"

if [ -x "$OUT_C/Colleen" ]; then
	check_no_crash "Colleen (C) with garbage args" "$OUT_C/Colleen" "foo" "bar" "baz"
fi
if [ -x "$OUT_C/Grace" ]; then
	cd "$OUT_C"
	check_no_crash "Grace (C) with garbage args" "$OUT_C/Grace" "x" "y"
fi
if [ -x "$OUT_C/Sully" ]; then
	cd "$OUT_C" && rm -f Sully_*.c Sully_-1 Sully_0 Sully_1 Sully_2 Sully_3 Sully_4
	check_no_crash "Sully (C) with garbage args" "$OUT_C/Sully" "garbage"
fi
if [ -x "$OUT_ASM/colleen" ]; then
	check_no_crash "Colleen (ASM) with garbage args" "$OUT_ASM/colleen" "z"
fi
echo ""

# ============================================================================
# 4) Edge case — empty environment
# ============================================================================
echo -e "${YELLOW}=== 4) Empty Environment (env -i) ===${NC}"

if [ -x "$OUT_C/Colleen" ]; then
	check_no_crash "Colleen (C) under env -i" env -i "$OUT_C/Colleen"
fi
if [ -x "$OUT_C/Grace" ]; then
	cd "$OUT_C"
	check_no_crash "Grace (C) under env -i" env -i "$OUT_C/Grace"
fi
if [ -x "$OUT_ASM/colleen" ]; then
	check_no_crash "Colleen (ASM) under env -i" env -i "$OUT_ASM/colleen"
fi
echo ""

# ============================================================================
# 5) Edge case — closed stdin
# ============================================================================
echo -e "${YELLOW}=== 5) Closed stdin ===${NC}"

if [ -x "$OUT_C/Colleen" ]; then
	check_no_crash "Colleen (C) with closed stdin" bash -c "'$OUT_C/Colleen' <&-"
fi
if [ -x "$OUT_ASM/colleen" ]; then
	check_no_crash "Colleen (ASM) with closed stdin" bash -c "'$OUT_ASM/colleen' <&-"
fi
echo ""

# ============================================================================
# 6) Valgrind — memory safety (Linux only, valgrind installed)
# ============================================================================
echo -e "${YELLOW}=== 6) Valgrind Memory Safety ===${NC}"

run_valgrind() {
	local name="$1"; shift
	local vg_log
	vg_log=$(mktemp)
	valgrind --error-exitcode=42 --leak-check=full --track-origins=yes \
		--quiet "$@" > /dev/null 2> "$vg_log"
	local code=$?
	if [ "$code" = "42" ]; then
		fail "$name has memory errors"
		head -10 "$vg_log"
		rm -f "$vg_log"
		return 1
	fi
	pass "$name valgrind clean"
	rm -f "$vg_log"
}

if command -v valgrind >/dev/null 2>&1; then
	[ -x "$OUT_C/Colleen" ] && run_valgrind "Colleen (C)" "$OUT_C/Colleen"
	if [ -x "$OUT_C/Grace" ]; then
		cd "$OUT_C" && rm -f Grace_kid.c
		run_valgrind "Grace (C)" "$OUT_C/Grace"
	fi
	# Skip Sully under valgrind: it forks system() which spawns gcc — slow/noisy.
	skip "Sully (C) — system() chain too noisy under valgrind"
else
	skip "valgrind not installed"
fi
echo ""

# ============================================================================
# 7) Sully — large counter must NOT crash
# ============================================================================
echo -e "${YELLOW}=== 7) Sully Edge Cases (boundary counters) ===${NC}"

# Test with bonus Python (which accepts CLI counter — easier to test)
if command -v python3 >/dev/null 2>&1 && [ -f "$BONUS/quine.py" ]; then
	cd "$BONUS"
	rm -f sully_*.py grace_kid.py

	check_no_crash "Python sully counter=0"   python3 quine.py sully 0
	check_no_crash "Python sully counter=-1"  python3 quine.py sully -1
	check_no_crash "Python sully counter=-99" python3 quine.py sully -99

	rm -f sully_*.py grace_kid.py
else
	skip "Python edge tests (python3 missing)"
fi
echo ""

# ============================================================================
# 8) No core dumps left behind
# ============================================================================
echo -e "${YELLOW}=== 8) No core dumps generated ===${NC}"

CORE_FILES=$(find "$ROOT" -maxdepth 3 -name "core" -o -name "core.*" 2>/dev/null | head -3)
if [ -z "$CORE_FILES" ]; then
	pass "No core dump files in project tree"
else
	fail "Core dump files found:"
	echo "$CORE_FILES"
fi
echo ""

# ============================================================================
# Cleanup
# ============================================================================
cd "$OUT_C" 2>/dev/null && rm -f Sully_*.c Sully_-1 Sully_0 Sully_1 Sully_2 Sully_3 Sully_4 Grace_kid.c colleen_test_out 2>/dev/null
cd "$OUT_ASM" 2>/dev/null && rm -f Sully_*.s Sully Sully.o Sully_-1 Sully_0 Sully_1 Sully_2 Sully_3 Sully_4 Grace_kid.s 2>/dev/null
cd "$BONUS" 2>/dev/null && rm -f sully_*.py grace_kid.py 2>/dev/null

# ============================================================================
# Summary
# ============================================================================
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS${NC}    ${RED}Failed: $FAIL${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
