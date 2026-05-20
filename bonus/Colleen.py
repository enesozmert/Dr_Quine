#!/usr/bin/env python3
# Colleen bonus - Python quine, prints own source to stdout.


def emit(t):
    # helper function called from entry point
    import sys
    sys.stdout.buffer.write((t % t).encode())


s = '#!/usr/bin/env python3\n# Colleen bonus - Python quine, prints own source to stdout.\n\n\ndef emit(t):\n    # helper function called from entry point\n    import sys\n    sys.stdout.buffer.write((t %% t).encode())\n\n\ns = %r\nemit(s)\n'
emit(s)
