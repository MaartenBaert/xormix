import hashlib
import numpy
import sys

import xormix_all
import extract_phases

def make_rng(seed_string):
	seed_hash = hashlib.sha512(seed_string).digest()
	seed_arr = numpy.frombuffer(seed_hash, dtype=numpy.uint32)
	seed_seq = numpy.random.SeedSequence(seed_arr, pool_size=16)
	return numpy.random.Generator(numpy.random.MT19937(seed_seq))

def test_period(n, m, k):
	ident = numpy.identity(n, dtype=numpy.uint8)
	return ((numpy.linalg.matrix_power(m, k) & 1) == ident).all()

def test_primitive(n, m):
	order = 2**n - 1
	if not test_period(n, m, order):
		return False
	for f in xormix_all.unique_factors[n]:
		if test_period(n, m, order // f):
			return False
	return True

def test_common_terms(n, m, maxcommon, maxcount):
	common = (m[:, None, :] & m[None, :, :]).sum(axis=2)
	mask = ~numpy.identity(n, dtype=bool)
	return (common[mask].max() <= maxcommon and (common[mask] == maxcommon).sum() <= maxcount)

def test_inverse_weight(n, m, minweight, maxweight):
	minv = numpy.linalg.matrix_power(m, 2**n - 2) & 1
	rowweight = minv.sum(axis=1)
	colweight = minv.sum(axis=0)
	return (rowweight.min() >= minweight and rowweight.max() <= maxweight
		and colweight.min() >= minweight and colweight.max() <= maxweight)

def make_selection(cols, sizes, fanout_min, fanout_max, rng):
	rows = len(sizes)
	min_size = sizes.min()
	table = numpy.tile(numpy.arange(cols, dtype=int), (rows, 1))
	for i in range(rows):
		for j in range(sizes[i]):
			k = rng.integers(j, cols)
			(table[i, j], table[i, k]) = (table[i, k], table[i, j])
	fanout = numpy.zeros(cols, dtype=int)
	for i in range(rows):
		fanout[table[i, :sizes[i]]] += 1
	while fanout.min() < fanout_min or fanout.max() > fanout_max:
		threshold = sizes.sum() // cols if fanout.min() < fanout_min else fanout_max
		for i in range(rows):
			for j in range(sizes[i]):
				if rng.integers(8) < fanout[table[i, j]] - threshold:
					k = rng.integers(sizes[i], cols)
					fanout[table[i, j]] -= 1
					(table[i, j], table[i, k]) = (table[i, k], table[i, j])
					fanout[table[i, j]] += 1
	return [table[i][:sizes[i]] for i in range(rows)]

def generate_matrix(n, suffix):
	rng = make_rng(b'xormix%d-xortable' % (n) + suffix.encode())
	maxcommon = 3
	maxcount = {
		16 : 48,
		24 : 32,
		32 : 24,
		48 : 16,
		64 : 10,
		96 :  4,
		128:  2,
	}[n]
	minweight = {
		16 :  4,
		24 :  6,
		32 : 10,
		48 : 16,
		64 : 24,
		96 : 32,
		128: 48,
	}[n]
	while True:
		m = numpy.zeros((n, n), dtype=numpy.uint8)
		sizes = 5 + numpy.arange(n) % 2
		selection = make_selection(n, sizes, 4, 7, rng)
		for i in range(n):
			m[i, selection[i]] = 1
		if not test_common_terms(n, m, maxcommon, maxcount):
			# print("Failed common terms test")
			continue
		if not test_primitive(n, m):
			# print("Failed primitivity test")
			continue
		if not test_inverse_weight(n, m, minweight, n - minweight):
			# print("Failed inverse weight test")
			continue
		return selection

def print_matrix(n, matrix):
	print('matrix = [')
	for row in matrix:
		print('\t[' + ', '.join(f'{x:{len(str(n-1))}d}' for x in row) + '],')
	print(']')

if __name__ == "__main__":

	if len(sys.argv) != 2:
		print('Usage: generate_matrix.py <wordsize>')
		sys.exit(1)

	n = int(sys.argv[1])
	attempt = 33
	while True:
		suffix = '' if attempt == 0 else f'-{attempt+1}'
		matrix = generate_matrix(n, suffix)
		(phases, rel_dist) = extract_phases.extract_phases(n, matrix)
		if rel_dist >= 4.0:
			print()
			print(f'xormix{n}:')
			print_matrix(n, matrix)
			print()
			break
		attempt += 1
