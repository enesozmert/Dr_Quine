#!/usr/bin/env python3
# Sully bonus - Python chain. Mirror Sully_i.py, decrement, run kid.
import os, subprocess, sys
i = 5
s = '#!/usr/bin/env python3\n# Sully bonus - Python chain. Mirror Sully_i.py, decrement, run kid.\nimport os, subprocess, sys\ni = %d\ns = %r\nif i >= 0:\n    f = "Sully_%%d.py" %% i\n    if os.path.exists(f):\n        i -= 1\n    if i >= 0:\n        f = "Sully_%%d.py" %% i\n        open(f, "wb").write((s %% (i, s)).encode())\n        subprocess.run([sys.executable, f])\n'
if i >= 0:
    f = "Sully_%d.py" % i
    if os.path.exists(f):
        i -= 1
    if i >= 0:
        f = "Sully_%d.py" % i
        open(f, "wb").write((s % (i, s)).encode())
        subprocess.run([sys.executable, f])
