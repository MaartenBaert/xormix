# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import math
import numpy
import random
import subprocess
import time

import lfsr_mapping
import xormix_discrete_log

n = 24
(u, p, v) = lfsr_mapping.make_mapping(n)
poly = (1 << n) + sum(p[:, -1].astype(object) << numpy.arange(n, dtype=object))

factors = [int(x) for x in subprocess.check_output(['factor', str(2**n - 1)]).split()[1:]]
print('factors:', factors)

def gf_mul(a, b, poly):
	return xormix_discrete_log.gf_mul(n, a, b, poly)

def gf_pow(a, k, poly):
	return xormix_discrete_log.gf_pow(n, a, k, poly)

def bsgs(val, gen, order, poly):
	return xormix_discrete_log.bsgs(n, val, gen, order, poly)

def is_primitive(gen, poly):
	if gf_pow(gen, 2**n - 1, poly) != 1:
		return False
	for f in factors:
		assert (2**n - 1) % f == 0
		if gf_pow(gen, (2**n - 1) // f, poly) == 1:
			return False
	return True

def discrete_log(val, gen, poly):
	m = 1
	res = 0
	for f in factors:
		subval = gf_pow(val, (2**n - 1) // (m * f), poly)
		subgen = gf_pow(gen, (2**n - 1) // f, poly)
		k = bsgs(subval, subgen, f, poly)
		assert subval == gf_pow(subgen, k, poly)
		res += k * m
		val = gf_mul(val, gf_pow(gen, 2**n - 1 - k * m, poly), poly)
		m *= f
		#print('f', f, 'k', k, 'val', val)
	assert val == 1
	return res

if not is_primitive(2, poly):
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
	k = discrete_log(x, 2, poly)
	res1[i] = k
	print('discretelog', i, x, k) #, bin(z), bin(sum(u[i, :].astype(object) << numpy.arange(n, dtype=object))))



a = lfsr_mapping.make_matrix(n)
x = 1
z = 0
res2 = [0] * n
for i in range(2**n - 1):
	x <<= 1
	if x >> n:
		x ^= poly
	z = (z >> 1) ^ ((x & 1) << (n - 1))
	for j in range(n):
		if sum(u[j, :].astype(object) << numpy.arange(n, dtype=object)) == z:
			res2[j] = i
			print('bruteforce', j, i)

res1 = numpy.array(res1, dtype=object)
res2 = numpy.array(res2, dtype=object)

print((res1 - res1[0]) % (2**n - 1))
print((res2 - res2[0]) % (2**n - 1))



res1.sort()
d = (res1 - numpy.roll(res1, 1)) % (2**n - 1)
print(min(d), 2**n // n**2, d)
print(min(d) / (2**n // n**2))

#for i in range(10):
	#k = random.randint(0, 2**n - 2)
	#gen = random.randint(1, 2**n - 1)
	#while not is_primitive(gen, poly):
		#gen = random.randint(1, 2**n - 1)
	#val = gf_pow(gen, k, poly)
	#res = discrete_log(val, gen, poly)
	##res = bsgs(val, gen, 2**n - 1, poly)
	##res = bsgs_fast(val, gen, 2**n - 1, poly)
	##res = pollard_rho(val, gen, 2**n - 1, poly)
	#print(k, gen, val, res, res == k)
	#if res != k:
		#print('SOFT FAIL')
	#if gf_pow(gen, res, poly) != val:
		#raise Exception('ERROR')

t2 = time.time()

print('time:', t2 - t1)
