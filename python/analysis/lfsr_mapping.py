# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import numpy
import random

import xormix16
import xormix24
import xormix32
import xormix48
import xormix64
import xormix96
import xormix128

modules = {
	16: xormix16,
	24: xormix24,
	32: xormix32,
	48: xormix48,
	64: xormix64,
	96: xormix96,
	128: xormix128,
}

def print_matrix(*args):
	chars = '·1'
	print('\n'.join(' | '.join(' '.join(chars[x & 1] for x in row) for row in rows) for rows in zip(*args)))

def make_matrix(n):
	a = numpy.zeros((n, n), dtype=numpy.uint8)
	for (i, cols) in enumerate(modules[n].matrix):
		a[i, cols] = 1
	return a

def make_mapping(n, show=False):
	
	a = make_matrix(n)
	u = numpy.identity(n, dtype=numpy.uint8)
	v = numpy.identity(n, dtype=numpy.uint8)
	
	def row_op(i, j):
		u[:, i] ^= u[:, j]
		a[j, :] ^= a[i, :]
		a[:, i] ^= a[:, j]
		v[j, :] ^= v[i, :]
	
	def row_swap(i, j):
		row_op(i, j)
		row_op(j, i)
		row_op(i, j)
	
	for i in range(n - 1):
		s = i + 1 + a[i + 1 :, i].argmax()
		assert a[s, i] != 0, 'Missing pivot'
		if s != i + 1:
			row_swap(s, i + 1)
		for j in range(n):
			if j == i + 1:
				continue
			if a[j, i] != 0:
				row_op(i + 1, j)
		if show:
			print(f'Matrix after iteration {i}')
			print_matrix(u, a, v)
	
	assert ((numpy.matmul(u, v) & 1) == numpy.identity(n, dtype=numpy.uint8)).all(), 'Invalid u/v matrices'
	assert (((numpy.matmul(numpy.matmul(u, a), v)) & 1) == make_matrix(n)).all(), 'Invalid decomposition'
	return (u, a, v)
