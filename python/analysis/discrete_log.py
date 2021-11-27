# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import math
import numpy
import random
import time

import lfsr_mapping
import generate_matrix

from xormix_all import factors
from xormix_discrete_log import *

def is_primitive(n, gen, poly):
	if gf_pow(n, gen, 2**n - 1, poly) != 1:
		return False
	for f in factors[n]:
		assert (2**n - 1) % f == 0
		if gf_pow(n, gen, (2**n - 1) // f, poly) == 1:
			return False
	return True

def discrete_log(n, val, gen, poly):
	m = 1
	res = 0
	for f in factors[n]:
		subval = gf_pow(n, val, (2**n - 1) // (m * f), poly)
		subgen = gf_pow(n, gen, (2**n - 1) // f, poly)
		k = bsgs(n, subval, subgen, f, poly)
		assert subval == gf_pow(n, subgen, k, poly)
		res += k * m
		val = gf_mul(n, val, gf_pow(n, gen, 2**n - 1 - k * m, poly), poly)
		m *= f
	assert val == 1
	return res

def calculate_discrete_logs(n):

	print(f'Discrete logs for xormix{n}')

	a = lfsr_mapping.make_matrix(n)
	(u, p, v) = lfsr_mapping.make_mapping(n)
	poly = (1 << n) + sum(p[:, -1].astype(object) << numpy.arange(n, dtype=object))

	# print('Matrix:')
	# lfsr_mapping.print_matrix(a)

	# print('Decomposed matrix:')
	# lfsr_mapping.print_matrix(u, p, v)

	# ones = sum((poly >> i) & 1 for i in range(n + 1))
	# print(f'poly 0x{poly:0{n//4+1}x} (ones={ones}, avg={n//2+2})')
	print(f'poly 0x{poly:0{n//4+1}x}')

	assert is_primitive(n, 2, poly), 'Invalid polynomial'

	t1 = time.time()

	res1 = [0] * n
	for i in range(n):
		x = 0
		for j in range(n):
			if u[i, j]:
				x ^= poly >> (j + 1)
		y = x
		z = 0
		for j in range(n):
			y <<= 1
			if y >> n:
				y ^= poly
			z = (z >> 1) ^ ((y & 1) << (n - 1))
		k = discrete_log(n, x, 2, poly)
		res1[i] = k
		print(f'discretelog {i} 0x{x:0{n//4}x} 0x{k:0{n//4}x}')

	res1.sort()
	res1 = numpy.array(res1, dtype=object)
	d = (res1 - numpy.roll(res1, 1)) % (2**n - 1)
	rel_dist = min(d) / (2**n // n**2)

	#print('all distances', d)
	print('min distance', min(d))
	print('expected min distance', 2**n // n**2)
	print('relative min distance', rel_dist)

	t2 = time.time()

	print('time:', t2 - t1)
	print()

	return rel_dist

for n in [16, 24, 32, 48, 64, 96, 128]:
	calculate_discrete_logs(n)

# for n in [64]:
# 	for i in range(6, 1000):
# 		suffix = '' if i == 0 else f'-{i+1}'
# 		selection = generate_matrix.make_xormix_matrix(n, suffix.encode())
# 		lfsr_mapping.modules[n].matrix = selection
# 		rel_dist = calculate_discrete_logs(n)
# 		if rel_dist >= 4.0:
# 			print()
# 			print(f'xormix{n}:')
# 			generate_matrix.print_xormix_matrix(n, selection)
# 			print()
# 			break
