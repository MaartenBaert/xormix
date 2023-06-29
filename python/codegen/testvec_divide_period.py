# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import random

random.seed(0xd033d34c10ffceb8)

test_divisions = 20

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
	divide_period_input = [random.randint(1, 2**(min(n, 32) * i // test_divisions + 1) - 1) for i in range(test_divisions)]
	divide_period_output = [(2**n - 1) // div for div in divide_period_input]
	print_array(f'static const size_t divide_period_input{n}[TEST_DIVISIONS]', min(n, 32), divide_period_input, 4)
	print_array(f'static const xormix{n}::word_t divide_period_output{n}[TEST_DIVISIONS]', n, divide_period_output, 4)
	print()

if __name__ == '__main__':
	for n in [16, 24, 32, 48, 64, 96, 128]:
		print_test(n)
