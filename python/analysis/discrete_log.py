# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import math
import numpy
import random
import subprocess
import time

import lfsr_mapping
from xormix_discrete_log import *

def is_primitive(n, gen, poly, factors):
	if gf_pow(n, gen, 2**n - 1, poly) != 1:
		return False
	for f in factors:
		assert (2**n - 1) % f == 0
		if gf_pow(n, gen, (2**n - 1) // f, poly) == 1:
			return False
	return True

def discrete_log(n, val, gen, poly, factors):
	m = 1
	res = 0
	for f in factors:
		subval = gf_pow(n, val, (2**n - 1) // (m * f), poly)
		subgen = gf_pow(n, gen, (2**n - 1) // f, poly)
		k = bsgs(n, subval, subgen, f, poly)
		assert subval == gf_pow(n, subgen, k, poly)
		res += k * m
		val = gf_mul(n, val, gf_pow(n, gen, 2**n - 1 - k * m, poly), poly)
		m *= f
		#print('f', f, 'k', k, 'val', val)
	assert val == 1
	return res

def calculate_discrete_logs(n):

	print(f'Discrete logs for xormix{n}')

	(u, p, v) = lfsr_mapping.make_mapping(n)
	poly = (1 << n) + sum(p[:, -1].astype(object) << numpy.arange(n, dtype=object))

	factors = [int(x) for x in subprocess.check_output(['factor', str(2**n - 1)]).split()[1:]]
	print('factors:', factors)

	if not is_primitive(n, 2, poly, factors):
		raise Exception('Invalid polynomial')

	x = 1
	for f in factors:
		x *= f
	if x != 2**n - 1:
		raise Exception('Invalid factors')

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
		k = discrete_log(n, x, 2, poly, factors)
		res1[i] = k
		print(f'discretelog {i} 0x{x:0{n//4}x} 0x{k:0{n//4}x}') #, bin(z), bin(sum(u[i, :].astype(object) << numpy.arange(n, dtype=object))))



	# a = lfsr_mapping.make_matrix(n)
	# x = 1
	# z = 0
	# res2 = [0] * n
	# for i in range(2**n - 1):
	# 	x <<= 1
	# 	if x >> n:
	# 		x ^= poly
	# 	z = (z >> 1) ^ ((x & 1) << (n - 1))
	# 	for j in range(n):
	# 		if sum(u[j, :].astype(object) << numpy.arange(n, dtype=object)) == z:
	# 			res2[j] = i
	# 			print('bruteforce', j, i)

	# res1 = numpy.array(res1, dtype=object)
	# res2 = numpy.array(res2, dtype=object)

	# print((res1 - res1[0]) % (2**n - 1))
	# print((res2 - res2[0]) % (2**n - 1))



	res1.sort()
	d = (res1 - numpy.roll(res1, 1)) % (2**n - 1)
	#print('all distances', d)
	print('min distance', min(d))
	print('expected min distance', 2**n // n**2)
	print('relative min distance', min(d) / (2**n // n**2))

	t2 = time.time()

	print('time:', t2 - t1)
	print()

for n in [16, 24, 32, 48, 64, 96, 128]:
	calculate_discrete_logs(n)
