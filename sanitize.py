#!/usr/bin/env python3
"""Removes build-machine paths from release binaries (in place, same file size).
 - compile-time __FILE__ strings like /home/<user>/.../src/src/foo.cpp  -> src/foo.cpp
 - ELF RUNPATH like $ORIGIN:/home/<user>/...                            -> $ORIGIN
Usage: sanitize.py FILE..."""
import re, sys
def fix(data):
    n = 0
    def f1(m):
        nonlocal n; n += 1
        new = m.group(1)
        return new + b"\0" * (len(m.group(0)) - len(new))
    data = re.sub(rb"/home/[^/\0]+/Projects/[^/\0]+/src/(src/[^\0]*)", f1, data)
    def f2(m):
        nonlocal n; n += 1
        return b"$ORIGIN" + b"\0" * (len(m.group(0)) - 7)
    data = re.sub(rb"\$ORIGIN:/home/[^\0]*", f2, data)
    return data, n
for p in sys.argv[1:]:
    d = open(p, "rb").read()
    out, n = fix(d)
    assert len(out) == len(d)
    open(p, "wb").write(out)
    left = re.findall(rb"/home/[^\0]{0,60}", out)
    print(f"{p}: patched {n}, remaining /home/ strings: {len(left)}")
    for l in left[:5]: print("   ", l.decode("latin-1"))
