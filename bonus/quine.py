#!/usr/bin/env python3
import sys
_ = '#!/usr/bin/env python3\nimport sys\n_ = %r\na = sys.argv\nif len(a) > 1 and a[1] == "grace":\n    open("grace_kid.py", "w").write(_ %% _)\nelif len(a) > 1 and a[1] == "sully":\n    c = int(a[2]) if len(a) > 2 else 5\n    if c >= 0:\n        open("sully_%%d.py" %% (c - 1), "w").write(_ %% _)\nelse:\n    sys.stdout.write(_ %% _)\n'
a = sys.argv
if len(a) > 1 and a[1] == "grace":
    open("grace_kid.py", "w").write(_ % _)
elif len(a) > 1 and a[1] == "sully":
    c = int(a[2]) if len(a) > 2 else 5
    if c >= 0:
        open("sully_%d.py" % (c - 1), "w").write(_ % _)
else:
    sys.stdout.write(_ % _)
