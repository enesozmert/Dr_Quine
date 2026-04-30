#!/usr/bin/env python3
# ============================================================================
# quine.py - Dr_Quine Bonus: Self-Replicating Program in Python
# ============================================================================
# A quine program written in Python that outputs its own source code
# Run: python3 quine.py

def colleen():
	"""Self-replicating quine in Python"""
	code = '''#!/usr/bin/env python3
# ============================================================================
# quine.py - Dr_Quine Bonus: Self-Replicating Program in Python
# ============================================================================
# A quine program written in Python that outputs its own source code
# Run: python3 quine.py

def colleen():
	"""Self-replicating quine in Python"""
	code = %s
	print(code %% repr(code))

def grace():
	"""Quine that writes to grace_kid.py"""
	code = %s
	with open('grace_kid.py', 'w') as f:
		f.write(code %% repr(code))

def sully(counter=8):
	"""Self-replicating quine with counter"""
	if counter < 0:
		return
	code = %s
	if counter > 0:
		filename = f'sully_{counter-1}.py'
		with open(filename, 'w') as f:
			f.write(code %% (repr(code), counter-1))

if __name__ == '__main__':
	import sys
	if len(sys.argv) > 1 and sys.argv[1] == 'grace':
		grace()
	elif len(sys.argv) > 1 and sys.argv[1] == 'sully':
		counter = int(sys.argv[2]) if len(sys.argv) > 2 else 8
		sully(counter)
	else:
		colleen()
'''
	print(code % repr(code))

def grace():
	"""Quine that writes to grace_kid.py"""
	code = '''#!/usr/bin/env python3
# ============================================================================
# quine.py - Dr_Quine Bonus: Self-Replicating Program in Python
# ============================================================================
# A quine program written in Python that outputs its own source code
# Run: python3 quine.py

def colleen():
	"""Self-replicating quine in Python"""
	code = %s
	print(code %% repr(code))

def grace():
	"""Quine that writes to grace_kid.py"""
	code = %s
	with open('grace_kid.py', 'w') as f:
		f.write(code %% repr(code))

def sully(counter=8):
	"""Self-replicating quine with counter"""
	if counter < 0:
		return
	code = %s
	if counter > 0:
		filename = f'sully_{counter-1}.py'
		with open(filename, 'w') as f:
			f.write(code %% (repr(code), counter-1))

if __name__ == '__main__':
	import sys
	if len(sys.argv) > 1 and sys.argv[1] == 'grace':
		grace()
	elif len(sys.argv) > 1 and sys.argv[1] == 'sully':
		counter = int(sys.argv[2]) if len(sys.argv) > 2 else 8
		sully(counter)
	else:
		colleen()
'''
	with open('grace_kid.py', 'w') as f:
		f.write(code % repr(code))

def sully(counter=8):
	"""Self-replicating quine with counter"""
	if counter < 0:
		return
	code = '''#!/usr/bin/env python3
# ============================================================================
# quine.py - Dr_Quine Bonus: Self-Replicating Program in Python
# ============================================================================
# A quine program written in Python that outputs its own source code
# Run: python3 quine.py

def colleen():
	"""Self-replicating quine in Python"""
	code = %s
	print(code %% repr(code))

def grace():
	"""Quine that writes to grace_kid.py"""
	code = %s
	with open('grace_kid.py', 'w') as f:
		f.write(code %% repr(code))

def sully(counter=8):
	"""Self-replicating quine with counter"""
	if counter < 0:
		return
	code = %s
	if counter > 0:
		filename = f'sully_{counter-1}.py'
		with open(filename, 'w') as f:
			f.write(code %% (repr(code), counter-1))

if __name__ == '__main__':
	import sys
	if len(sys.argv) > 1 and sys.argv[1] == 'grace':
		grace()
	elif len(sys.argv) > 1 and sys.argv[1] == 'sully':
		counter = int(sys.argv[2]) if len(sys.argv) > 2 else 8
		sully(counter)
	else:
		colleen()
'''
	if counter > 0:
		filename = f'sully_{counter-1}.py'
		with open(filename, 'w') as f:
			f.write(code % (repr(code), counter-1))

if __name__ == '__main__':
	import sys
	if len(sys.argv) > 1 and sys.argv[1] == 'grace':
		grace()
	elif len(sys.argv) > 1 and sys.argv[1] == 'sully':
		counter = int(sys.argv[2]) if len(sys.argv) > 2 else 8
		sully(counter)
	else:
		colleen()
