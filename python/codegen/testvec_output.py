# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import random

import xormix16
import xormix24
import xormix32
import xormix48
import xormix64
import xormix96
import xormix128

random.seed(0x3f10d933ecfc0a73)

test_streams = 4
test_outputs = 100

modules = {
	16: xormix16,
	24: xormix24,
	32: xormix32,
	48: xormix48,
	64: xormix64,
	96: xormix96,
	128: xormix128,
}

def print_array(name, n, words, cols):
	limbs = (n + 63) // 64
	nl = n // limbs
	nt = 1 << (nl - 1).bit_length()
	ml = (1 << nl) - 1
	values = []
	for word in words:
		for limb in range(limbs):
			value = (word >> (limb * nl)) & ml
			chars = nl // 4
			values.append(f'UINT{nt}_C(0x{value:0{chars}x})')
	print(name + ' = {')
	for i in range(0, len(values), cols):
		print('\t' + ', '.join(values[i : i + cols]) + ',')
	print('};')

def print_test(n):
	seed = [random.getrandbits(n) for i in range(test_streams + 1)]
	state = seed.copy()
	output = []
	for i in range(test_outputs):
		modules[n].next_state(state)
		output += state
	print_array(f'static const xormix{n}::word_t xormix{n}_seeds[TEST_STREAMS + 1]', n, seed, 5)
	print_array(f'static const xormix{n}::word_t xormix{n}_output[TEST_OUTPUTS][TEST_STREAMS + 1]', n, output, 5)
	print()

for n in [16, 24, 32, 48, 64, 96, 128]:
	print_test(n)
