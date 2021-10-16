# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import math
import random
import subprocess

import time

import xormix_discrete_log

#poly = 1 + 2**28 + 2**31

#poly = 1 + 2**4 + 2**13 + 2**15 + 2**16
#poly = 1 + 2**4 + 2**13 + 2**19 + 2**24
#poly = 1 + 2**1 + 2**2 + 2**22 + 2**32
#poly = 1 + 2**20 + 2**21 + 2**47 + 2**48
#poly = 1 + 2**60 + 2**61 + 2**63 + 2**64
#poly = 1 + 2**47 + 2**49 + 2**94 + 2**96
poly = 1 + 2**99 + 2**101 + 2**126 + 2**128

n = poly.bit_length() - 1

factors = [int(x) for x in subprocess.check_output(['factor', str(2**n - 1)]).split()[1:]]
print('factors:', factors)

def gf_mul(a, b):
	assert 0 <= a < 2**n
	assert 0 <= b < 2**n
	r = 0
	for i in range(n):
		if (b >> i) & 1:
			r ^= a << i
	for i in reversed(range(n)):
		if r >> (n + i):
			r ^= poly << i
	return r

def gf_pow(a, k):
	assert 0 <= a < 2**n
	assert 0 <= k < 2**n
	r = 1
	for i in range(n):
		if (k >> i) & 1:
			r = gf_mul(r, a)
		a = gf_mul(a, a)
	return r

def is_primitive(gen):
	if gf_pow(gen, 2**n - 1) != 1:
		return False
	for f in factors:
		assert (2**n - 1) % f == 0
		if gf_pow(gen, (2**n - 1) // f) == 1:
			return False
	return True

def bsgs(val, gen, order):
	steps = math.isqrt(order - 1) + 1
	table = dict()
	a = 1
	for i in range(steps):
		table[a] = i
		a = gf_mul(a, gen)
	gen = gf_pow(gen, 2**n - 1 - steps)
	for i in range(steps):
		if val in table:
			return table[val] + steps * i
		val = gf_mul(val, gen)
	raise Exception('BSGS failed')

def bsgs_fast(val, gen, order):
	steps = math.isqrt(order - 1) + 1
	#print(f'Calling BSGS kernel ({steps}, {n}) ...')
	candidates = xormix_discrete_log.bsgs_kernel(1, val, gen, gf_pow(gen, 2**n - 1 - steps), poly, steps, n)
	#print('candidates:', len(candidates))
	for res in candidates:
		if gf_pow(gen, res) == val:
			return res % order
	raise Exception('Fast BSGS failed')

def pollard_rho(val, gen, order):
	def step(x, a, b, seed):
		sw = (x ^ seed) % 3
		if sw == 0:
			return (gf_mul(x, x), (2 * a) % order, (2 * b) % order)
		elif sw == 1:
			return (gf_mul(x, gen), (a + 1) % order, b)
		else:
			return (gf_mul(x, val), a, (b + 1) % order)
	def search():
		seed = random.randint(0, 2**n - 1)
		(x1, a1, b1) = (gf_mul(gen, val), 1, 1)
		(x2, a2, b2) = (gf_mul(gen, val), 1, 1)
		for i in range(order):
			(x1, a1, b1) = step(x1, a1, b1, seed)
			(x2, a2, b2) = step(x2, a2, b2, seed)
			(x2, a2, b2) = step(x2, a2, b2, seed)
			if x1 == x2:
				aa = (a1 - a2) % order
				bb = (b2 - b1) % order
				try:
					return (aa * pow(bb, -1, order)) % order
				except ValueError as e:
					print(e)
					print('**', val, gen, order, i)
					print('**', x1, a1, b1, '-', x2, a2, b2, '-', aa, bb)
					return None
		raise Exception('Pollard-Rho failed')
	res = search()
	while res is None:
		res = search()
	return res

def discrete_log(val, gen):
	m = 1
	res = 0
	for f in factors:
		subval = gf_pow(val, (2**n - 1) // (m * f))
		subgen = gf_pow(gen, (2**n - 1) // f)
		k = bsgs_fast(subval, subgen, f)
		#if f < 10000000:
			##k = bsgs(subval, subgen, f)
			#k = bsgs_fast(subval, subgen, f)
		#else:
			#k = pollard_rho(subval, subgen, f)
		res += k * m
		val = gf_mul(val, gf_pow(gen, 2**n - 1 - k * m))
		m *= f
	assert val == 1
	return res

if not is_primitive(2):
	raise Exception('Invalid polynomial')

x = 1
for f in factors:
	x *= f
if x != 2**n - 1:
	raise Exception('Invalid factors')

t1 = time.time()

for i in range(10):
	k = random.randint(0, 2**n - 2)
	gen = random.randint(1, 2**n - 1)
	while not is_primitive(gen):
		gen = random.randint(1, 2**n - 1)
	val = gf_pow(gen, k)
	res = discrete_log(val, gen)
	#res = bsgs(val, gen, 2**n - 1)
	#res = bsgs_fast(val, gen, 2**n - 1)
	#assert res == res2
	#res = pollard_rho(val, gen, 2**n - 1)
	print(k, gen, val, res, res == k)
	if res != k:
		print('SOFT FAIL')
	if gf_pow(gen, res) != val:
		raise Exception('ERROR')

t2 = time.time()

print('time:', t2 - t1)
