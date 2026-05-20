#!/usr/bin/env python3
# Grace bonus - writes Grace_kid.py identical to source. No functions declared.
f = 'Grace_kid.py'
m = 'wb'
s = '#!/usr/bin/env python3\n# Grace bonus - writes Grace_kid.py identical to source. No functions declared.\nf = %r\nm = %r\ns = %r\nopen(f, m).write((s %% (f, m, s)).encode())\n'
open(f, m).write((s % (f, m, s)).encode())
