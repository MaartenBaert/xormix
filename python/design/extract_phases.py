# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import math
import numpy
import random
import sys

import xormix_ref
import xormix_all
import extract_lfsr

from xormix_discrete_log import *

def is_primitive(n, gen, poly):
	if gf_pow(n, gen, 2**n - 1, poly) != 1:
		return False
	for f in xormix_all.factors[n]:
		assert (2**n - 1) % f == 0
		if gf_pow(n, gen, (2**n - 1) // f, poly) == 1:
			return False
	return True

def discrete_log(n, val, gen, poly):
	m = 1
	res = 0
	for f in xormix_all.factors[n]:
		subval = gf_pow(n, val, (2**n - 1) // (m * f), poly)
		subgen = gf_pow(n, gen, (2**n - 1) // f, poly)
		k = bsgs(n, subval, subgen, f, poly)
		assert subval == gf_pow(n, subgen, k, poly)
		res += k * m
		val = gf_mul(n, val, gf_pow(n, gen, 2**n - 1 - k * m, poly), poly)
		m *= f
	assert val == 1
	return res

def extract_lfsr_state(n, output, poly):
	state = 0
	for i in range(n):
		if output[i]:
			state ^= poly >> (i + 1)
	return state

def generate_lfsr_output(n, state, poly, count):
	output = numpy.zeros(count, dtype=numpy.uint8)
	for j in range(count):
		output[j] = state >> (n - 1)
		state <<= 1
		if state >> n:
			state ^= poly
	return output

def extract_phases(n, matrix, show_result=False, check_brute_force=False):

	digits = math.floor(math.log10(n)) + 1

	# extract matrices and polynomial
	a = extract_lfsr.extract_matrix(n, matrix)
	(poly, u, v) = extract_lfsr.extract_lfsr(n, a)
	assert is_primitive(n, 2, poly), 'Invalid polynomial'

	# sanity check
	state = [1, 0]
	for i in range(n):
		for j in range(n):
			assert ((state[0] >> j) & 1) == u[j, i], 'Xormix output does not match U matrix!'
		m = xormix_all.modules[n]
		xormix_ref.next_state(matrix, m.salts, m.shuffle, m.shifts, state)

	phases = [0] * n
	for i in range(n):

		# extract LFSR state
		state = extract_lfsr_state(n, u[i], poly)
		output = generate_lfsr_output(n, state, poly, n)
		output_int = sum(output.astype(object) << numpy.arange(n, dtype=object))
		assert (output == u[i]).all(), 'LFSR output does not match U matrix!'

		# calculate phase
		phases[i] = discrete_log(n, state, 2, poly)
		assert gf_pow(n, 2, phases[i], poly) == state, 'Discrete log does not match!'

		if show_result:
			print(f'\tBit {i:{digits}d}: output=0x{output_int:0{n//4}x} lfsr=0x{state:0{n//4}x} phase=0x{phases[i]:0{n//4}x}')

	if check_brute_force:
		print(f'Brute force search:')
		state = 1
		output = 0
		phases2 = [0] * n
		for i in range(2**n - 1):
			output = (output >> 1) ^ (state & (1 << (n - 1)))
			for j in range(n):
				if sum(u[j, :].astype(object) << numpy.arange(n, dtype=object)) == output:
					phases2[j] = (i - n + 1) % (2**n - 1)
					state2 = state
					for i in range(n - 1):
						if state2 & 1:
							state2 ^= poly
						state2 >>= 1
					if show_result:
						print(f'\tBit {j:{digits}d}: output=0x{output:0{n//4}x} lfsr=0x{state2:0{n//4}x} phase=0x{phases2[j]:0{n//4}x}')
			state <<= 1
			if state >> n:
				state ^= poly
		delta = [phases[i] - phases2[i] for i in range(n)]
		assert all(phases[i] == phases2[i] for i in range(n)), 'Brute force results do not match!'

	sorted_phases = sorted(phases)
	distances = [(sorted_phases[i] - sorted_phases[i - 1]) % (2**n - 1) for i in range(n)]
	rel_dist = min(distances) / (2**n / n**2)

	if show_result:
		print(f'\tMinimum distance: {min(distances)}')
		print(f'\tRelative minimum distance: {rel_dist:.3f}')

	return (phases, rel_dist)

if __name__ == "__main__":

	if len(sys.argv) != 2:
		print('Usage: extract_phases.py <wordsize>')
		sys.exit(1)

	n = int(sys.argv[1])
	extract_phases(n, xormix_all.modules[n].matrix, show_result=True)
