#!/bin/bash
# Runs the EXACT command sequences shown in the PDF examples
# and prints expected vs actual side by side.
# To run: docker run --rm -v "$(pwd)":/app -w /app dr_quine_test bash scripts/pdf_compliance_test.sh

set -u
mkdir -p /tmp/quine_run
cd /tmp/quine_run

FAIL=0

C_SRC=/app/C
A_SRC=/app/ASM

hr() { printf '%.0s=' {1..72}; echo; }
section() { echo; hr; echo "▶ $1"; hr; }
mark_diff_result() {
	if [ "$1" -eq 0 ]; then
		echo "[PASS] $2"
	else
		echo "[FAIL] $2"
		FAIL=$((FAIL + 1))
	fi
}

# ============================================================================
section "1) Colleen (C) — PDF: clang ... -o Colleen Colleen.c; ./Colleen > tmp ; diff tmp Colleen.c"
# ============================================================================
rm -rf cln_c && mkdir cln_c && cd cln_c
cp "$C_SRC/Colleen.c" .
echo "$ ls -al"
ls -al
echo
echo '$ clang -Wall -Wextra -Werror -o Colleen Colleen.c; ./Colleen > tmp_Colleen ; diff tmp_Colleen Colleen.c'
clang -Wall -Wextra -Werror -o Colleen Colleen.c
./Colleen > tmp_Colleen
diff tmp_Colleen Colleen.c
RC=$?
echo "[diff exit=$RC]  PDF expected: empty diff (rc=0)"
mark_diff_result "$RC" "Colleen (C) source == output"
cd ..

# ============================================================================
section "2) Colleen (ASM) — PDF: nasm... && gcc... ; ./Colleen > tmp ; diff tmp Colleen.s"
# ============================================================================
rm -rf cln_a && mkdir cln_a && cd cln_a
cp "$A_SRC/Colleen.s" .
echo "$ ls -al"
ls -al
echo
echo '$ nasm -f elf64 Colleen.s -o Colleen.o && gcc Colleen.o -o Colleen'
nasm -f elf64 Colleen.s -o Colleen.o && gcc Colleen.o -o Colleen
echo '$ ./Colleen > tmp_Colleen ; diff tmp_Colleen Colleen.s'
./Colleen > tmp_Colleen
diff tmp_Colleen Colleen.s
RC=$?
echo "[diff exit=$RC]  PDF expected: empty diff (rc=0)"
mark_diff_result "$RC" "Colleen (ASM) source == output"
cd ..

# ============================================================================
section "3) Grace (C) — PDF: clang ... -o Grace Grace.c; ./Grace ; diff Grace.c Grace_kid.c"
# ============================================================================
rm -rf grc_c && mkdir grc_c && cd grc_c
cp "$C_SRC/Grace.c" .
echo "$ ls -al"
ls -al
echo
echo '$ clang -Wall -Wextra -Werror -o Grace Grace.c; ./Grace ; diff Grace.c Grace_kid.c'
clang -Wall -Wextra -Werror -o Grace Grace.c
./Grace
diff Grace.c Grace_kid.c
RC=$?
echo "[diff exit=$RC]  PDF expected: empty diff (rc=0)"
mark_diff_result "$RC" "Grace (C) source == kid"
echo "$ ls -al   (PDF expects: Grace, Grace.c, Grace_kid.c)"
ls -al
cd ..

# ============================================================================
section "4) Grace (ASM) — PDF: nasm... && gcc... ; rm -f Grace_kid.s ; ./Grace ; diff Grace_kid.s Grace.s"
# ============================================================================
rm -rf grc_a && mkdir grc_a && cd grc_a
cp "$A_SRC/Grace.s" .
echo "$ ls -al"
ls -al
echo
echo '$ nasm -f elf64 Grace.s -o Grace.o && gcc Grace.o -o Grace'
nasm -f elf64 Grace.s -o Grace.o && gcc Grace.o -o Grace
echo '$ rm -f Grace_kid.s ; ./Grace ; diff Grace_kid.s Grace.s'
rm -f Grace_kid.s
./Grace
diff Grace_kid.s Grace.s
RC=$?
echo "[diff exit=$RC]  PDF expected: empty diff (rc=0)"
mark_diff_result "$RC" "Grace (ASM) source == kid"
echo "$ ls -al   (PDF expects: Grace, Grace.s, Grace_kid.s, +Grace.o)"
ls -al
cd ..

# ============================================================================
section "5) Sully (C) — ng PDF: mkdir tmp; cp Sully tmp/; cd tmp/; ./Sully ; ls -al | grep Sully | wc -l"
# ============================================================================
rm -rf sly_c && mkdir sly_c && cp "$C_SRC/Sully.c" sly_c/Sully.c
cd sly_c
echo '$ clang -Wall -Wextra -Werror Sully.c -o Sully'
clang -Wall -Wextra -Werror Sully.c -o Sully
echo '$ mkdir -p tmp; cp Sully tmp/; cd tmp/; ./Sully'
mkdir -p tmp && cp Sully tmp/ && cd tmp && ./Sully
echo
echo '$ ls -al | grep Sully | wc -l    (PDF expects: 13)'
COUNT=$(ls -al | grep Sully | wc -l)
echo "$COUNT"
if [ "$COUNT" != "13" ]; then
	echo "[FAIL] Sully (C) count=$COUNT (expected 13)"
	FAIL=$((FAIL + 1))
else
	echo "[PASS] Sully (C) count=13"
fi
echo
echo '$ ls Sully*'
ls Sully*
if [ -f "Sully_-1.c" ]; then
	echo "[FAIL] Sully (C) produced Sully_-1.c (must not exist)"
	FAIL=$((FAIL + 1))
else
	echo "[PASS] Sully (C) did not produce Sully_-1.c"
fi
echo
echo '$ diff ../Sully.c Sully_5.c    (PDF expects: empty diff)'
diff ../Sully.c Sully_5.c
RC=$?
mark_diff_result "$RC" "Sully (C) Sully_5.c matches source"
echo
echo '$ diff ../Sully.c Sully_4.c    (PDF expects: NcN / int i = 5 / int i = 4)'
DIFF_OUT=$(diff ../Sully.c Sully_4.c)
if echo "$DIFF_OUT" | grep -qE '^[0-9]+c[0-9]+$' && echo "$DIFF_OUT" | grep -q 'i = 5' && echo "$DIFF_OUT" | grep -q 'i = 4'; then
	echo "[PASS] Sully (C) source vs Sully_4.c only counter line differs"
else
	echo "[FAIL] Sully (C) source vs Sully_4.c unexpected diff"
	echo "$DIFF_OUT"
	FAIL=$((FAIL + 1))
fi
echo
echo '$ diff Sully_5.c Sully_0.c     (PDF expects: NcN / int i = 5 / int i = 0)'
DIFF_OUT=$(diff Sully_5.c Sully_0.c)
if echo "$DIFF_OUT" | grep -qE '^[0-9]+c[0-9]+$' && echo "$DIFF_OUT" | grep -q 'i = 5' && echo "$DIFF_OUT" | grep -q 'i = 0'; then
	echo "[PASS] Sully (C) Sully_5.c vs Sully_0.c only counter line differs"
else
	echo "[FAIL] Sully (C) Sully_5.c vs Sully_0.c unexpected diff"
	echo "$DIFF_OUT"
	FAIL=$((FAIL + 1))
fi
cd ../..

# ============================================================================
section "6) Sully (ASM) — ng PDF: mkdir tmp; cp Sully tmp/; cd tmp/; ./Sully ; ls grep wc-l == 13"
# ============================================================================
rm -rf sly_a && mkdir sly_a && cp "$A_SRC/Sully.s" sly_a/Sully.s
cd sly_a
# Sully.s uses incbin "/tmp/sully_self.s" — populate it before nasm
cp Sully.s /tmp/sully_self.s
echo '$ nasm -f elf64 Sully.s -o Sully.o && gcc -no-pie Sully.o -o Sully'
nasm -f elf64 Sully.s -o Sully.o && gcc -no-pie Sully.o -o Sully
echo '$ mkdir -p tmp; cp Sully tmp/; cd tmp/; ./Sully'
mkdir -p tmp && cp Sully tmp/ && cd tmp && ./Sully
echo
echo '$ ls -al | grep Sully | wc -l   (PDF expects: 13)'
COUNT=$(ls -al | grep Sully | wc -l)
echo "$COUNT"
if [ "$COUNT" != "13" ]; then
	echo "[FAIL] Sully (ASM) count=$COUNT (expected 13)"
	FAIL=$((FAIL + 1))
else
	echo "[PASS] Sully (ASM) count=13"
fi
echo
echo '$ ls Sully*'
ls Sully*
if [ -f "Sully_-1.s" ]; then
	echo "[FAIL] Sully (ASM) produced Sully_-1.s (must not exist)"
	FAIL=$((FAIL + 1))
else
	echo "[PASS] Sully (ASM) did not produce Sully_-1.s"
fi
echo
echo '$ diff ../Sully.s Sully_5.s    (PDF expects: empty diff)'
diff ../Sully.s Sully_5.s
RC=$?
mark_diff_result "$RC" "Sully (ASM) Sully_5.s matches source"
echo
echo '$ diff ../Sully.s Sully_4.s    (PDF expects: NcN / ;i=5 / ;i=4)'
DIFF_OUT=$(diff ../Sully.s Sully_4.s)
if echo "$DIFF_OUT" | grep -qE '^[0-9]+c[0-9]+$' && echo "$DIFF_OUT" | grep -q 'i=5' && echo "$DIFF_OUT" | grep -q 'i=4'; then
	echo "[PASS] Sully (ASM) source vs Sully_4.s only counter line differs"
else
	echo "[FAIL] Sully (ASM) source vs Sully_4.s unexpected diff"
	echo "$DIFF_OUT"
	FAIL=$((FAIL + 1))
fi
echo
echo '$ diff Sully_5.s Sully_0.s     (PDF expects: NcN / ;i=5 / ;i=0)'
DIFF_OUT=$(diff Sully_5.s Sully_0.s)
if echo "$DIFF_OUT" | grep -qE '^[0-9]+c[0-9]+$' && echo "$DIFF_OUT" | grep -q 'i=5' && echo "$DIFF_OUT" | grep -q 'i=0'; then
	echo "[PASS] Sully (ASM) Sully_5.s vs Sully_0.s only counter line differs"
else
	echo "[FAIL] Sully (ASM) Sully_5.s vs Sully_0.s unexpected diff"
	echo "$DIFF_OUT"
	FAIL=$((FAIL + 1))
fi
cd ../..

# ============================================================================
section "7) Bonus (Python) — Colleen.py + Grace.py + Sully.py"
# ============================================================================
B_SRC=/app/bonus
rm -rf bonus_t && mkdir bonus_t && cp "$B_SRC/Colleen.py" "$B_SRC/Grace.py" "$B_SRC/Sully.py" bonus_t/
cd bonus_t

echo '$ python3 Colleen.py > out ; diff out Colleen.py'
python3 Colleen.py > out_colleen
diff out_colleen Colleen.py
RC=$?
mark_diff_result "$RC" "Bonus Colleen.py self-print"

echo '$ python3 Grace.py ; diff Grace.py Grace_kid.py'
python3 Grace.py
diff Grace.py Grace_kid.py
RC=$?
mark_diff_result "$RC" "Bonus Grace.py == Grace_kid.py"

echo '$ mkdir tmp; cp Sully.py tmp/; cd tmp/; python3 Sully.py'
mkdir -p tmp && cp Sully.py tmp/ && cd tmp && python3 Sully.py
echo
echo '$ ls Sully*'
ls Sully*
echo '$ ls -1 Sully*.py | wc -l   (bonus expects: 7 = Sully + Sully_5..0)'
COUNT=$(ls -1 Sully*.py | wc -l)
echo "$COUNT"
if [ "$COUNT" = "7" ]; then
	echo "[PASS] Bonus Sully count=7"
else
	echo "[FAIL] Bonus Sully count=$COUNT (expected 7)"
	FAIL=$((FAIL + 1))
fi
if [ -f "Sully_-1.py" ]; then
	echo "[FAIL] Bonus Sully_-1.py must NOT exist"
	FAIL=$((FAIL + 1))
else
	echo "[PASS] Bonus no Sully_-1.py"
fi
echo '$ diff Sully.py Sully_5.py  (empty)'
diff Sully.py Sully_5.py
RC=$?
mark_diff_result "$RC" "Bonus Sully_5.py == Sully.py"
echo '$ diff Sully.py Sully_4.py  (only counter)'
DIFF_OUT=$(diff Sully.py Sully_4.py)
if echo "$DIFF_OUT" | grep -q 'i = 5' && echo "$DIFF_OUT" | grep -q 'i = 4'; then
	echo "[PASS] Bonus Sully vs Sully_4 only counter differs"
else
	echo "[FAIL] Bonus Sully vs Sully_4 unexpected"
	echo "$DIFF_OUT"
	FAIL=$((FAIL + 1))
fi
echo '$ sed s/i = 5/i = -1/ Sully.py > S_neg.py ; python3 S_neg.py  (must do nothing)'
sed 's/^i = 5/i = -1/' Sully.py > S_neg.py
python3 S_neg.py
if [ -f "Sully_-1.py" ]; then
	echo "[FAIL] Bonus Sully with i=-1 created Sully_-1.py"
	FAIL=$((FAIL + 1))
else
	echo "[PASS] Bonus Sully initial -1 = noop"
fi
cd ../..

hr
echo "DONE"
hr

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
