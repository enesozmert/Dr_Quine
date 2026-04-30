# Dr_Quine Bonus Programs

Bonus implementations of the quine programs in alternative languages.

## Python Quine (quine.py)

A complete implementation of all three quine variations in Python:

### Colleen (stdout quine)
```bash
python3 quine.py
# Outputs its own source code to stdout
```

### Grace (file-writing quine)
```bash
python3 quine.py grace
# Creates grace_kid.py with identical source
diff quine.py grace_kid.py
# Should be identical
```

### Sully (self-replicating quine with counter)
```bash
python3 quine.py sully 8
# Creates sully_7.py (counter decrements)

python3 quine.py sully 7
# Creates sully_6.py

# ... continues until counter = 0
```

## Features

### Python Implementation Advantages
- **Simpler quine mechanism:** Python's string formatting makes quines more readable
- **Dynamic counter handling:** No Assembly complexity
- **File I/O:** Simple and portable with `open()` and `write()`
- **Multi-function support:** Single file implements all three variants

### Code Structure
- `colleen()`: Prints own source code
- `grace()`: Writes to grace_kid.py
- `sully(counter)`: Creates sully_N.py with decreasing counter
- `__main__` block: CLI interface with argument parsing

### Benefits Over C/Assembly
- No compilation required
- Portable across platforms (Windows, macOS, Linux)
- No memory management complexity
- Cleaner string handling
- Easy to understand logic

## Verification

### Test Colleen
```bash
python3 quine.py > colleen_out.py
diff colleen_out.py quine.py
echo $?  # Should be 0
```

### Test Grace
```bash
python3 quine.py grace
diff quine.py grace_kid.py
echo $?  # Should be 0
```

### Test Sully Cycle
```bash
python3 quine.py sully 3
python3 sully_2.py sully 2
python3 sully_1.py sully 1
python3 sully_0.py sully 0
# Should create sully_2.py, sully_1.py, sully_0.py
```

## Requirements
- Python 3.6+ (uses f-strings)
- No external dependencies

## Notes
- The Python quine demonstrates fundamental quine concepts without C/Assembly complexity
- Shows how language choice affects quine implementation difficulty
- Serves as a reference implementation for understanding quine mechanics
- All three quine variants (stdout, file, parametric) implemented in single file

## Related
- C implementations: `src/colleen.c`, `src/grace.c`, `src/sully.c`
- Assembly implementations: `src/colleen.s`, `src/grace.s`, `src/sully.s`
- Main documentation: `docs/`
