# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import numpy
import sys

from xormix_all import modules

def print_matrix(*args):
	chars = '·1'
	print('\n'.join(' | '.join(' '.join(chars[x & 1] for x in row) for row in rows) for rows in zip(*args)))

def extract_matrix(n):
	a = numpy.zeros((n, n), dtype=numpy.uint8)
	for (i, cols) in enumerate(modules[n].matrix):
		a[i, cols] = 1
	return a

def extract_lfsr(n, aa, show_progress=False):
	
	p = aa.copy()
	u = numpy.identity(n, dtype=numpy.uint8)
	v = numpy.identity(n, dtype=numpy.uint8)
	
	def row_op(i, j):
		u[:, i] ^= u[:, j]
		p[j, :] ^= p[i, :]
		p[:, i] ^= p[:, j]
		v[j, :] ^= v[i, :]
	
	def row_swap(i, j):
		row_op(i, j)
		row_op(j, i)
		row_op(i, j)
	
	if show_progress:
		print(f'Initial matrices:')
		print_matrix(u, p, v)
	
	for i in range(n - 1):
		s = i + 1 + p[i + 1 :, i].argmax()
		assert p[s, i] != 0, 'Missing pivot'
		if s != i + 1:
			row_swap(s, i + 1)
		for j in range(n):
			if j == i + 1:
				continue
			if p[j, i] != 0:
				row_op(i + 1, j)
		if show_progress:
			print(f'Matrices after iteration {i + 1}:')
			print_matrix(u, p, v)
	
	assert ((numpy.matmul(u, v) & 1) == numpy.identity(n, dtype=numpy.uint8)).all(), 'Invalid u/v matrices'
	assert (((numpy.matmul(numpy.matmul(u, p), v)) & 1) == extract_matrix(n)).all(), 'Invalid decomposition'

	poly = (1 << n) + sum(p[:, -1].astype(object) << numpy.arange(n, dtype=object))
	if show_progress:
		print(f'Polynomial: 0x{poly:0{n//4+1}x}')

	return (poly, u, v)

if __name__ == "__main__":

	if len(sys.argv) != 2:
		print('Usage: extract_lfsr.py <wordsize>')
		sys.exit(1)

	n = int(sys.argv[1])
	a = extract_matrix(n)
	extract_lfsr(n, a, show_progress=True)
