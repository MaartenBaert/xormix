# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import random

from xormix_all import modules

random.seed(0x3f10d933ecfc0a73)

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

def print_test(n, test_streams=4, test_outputs=100):
	seed = [random.getrandbits(n) for i in range(test_streams + 1)]
	state = seed.copy()
	output = []
	for i in range(test_outputs):
		modules[n].next_state(state)
		output += state
	print(f'static constexpr size_t XORMIX{n}_TEST_STREAMS = {test_streams};')
	print(f'static constexpr size_t XORMIX{n}_TEST_OUTPUTS = {test_outputs};')
	print_array(f'static const xormix{n}::word_t xormix{n}_seeds[XORMIX{n}_TEST_STREAMS + 1]', n, seed, 5)
	print_array(f'static const xormix{n}::word_t xormix{n}_output[XORMIX{n}_TEST_OUTPUTS][XORMIX{n}_TEST_STREAMS + 1]', n, output, 5)
	print()

if __name__ == '__main__':
	for n in [16, 24, 32, 48, 64, 96, 128]:
		print_test(n)
