# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import numpy
import numpy.linalg
import random

random.seed(0x2eea002f78f5a75e)

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
	limbs = (n + 63) // 64
	nl = n // limbs
	#matrix = matrices[n]
	power = random.getrandbits(n)
	matrix_input = numpy.array([[random.getrandbits(1) for j in range(n)] for i in range(n)], dtype=numpy.uint8)
	matrix_output = numpy.linalg.matrix_power(matrix_input, power) & 1
	matrix_input2 = [sum(int(matrix_input[i, jj * nl + j]) << i for i in range(n)) for j in range(nl) for jj in range(limbs)]
	matrix_output2 = [sum(int(matrix_output[i, jj * nl + j]) << i for i in range(n)) for j in range(nl) for jj in range(limbs)]
	print_array(f'static const xormix{n}::word_t matrix_power{n}', n, [power], 4)
	print_array(f'static const xormix{n}::matrix_t matrix_power_input{n}', n, matrix_input2, 4)
	print_array(f'static const xormix{n}::matrix_t matrix_power_output{n}', n, matrix_output2, 4)
	print()

if __name__ == '__main__':
	for n in [16, 24, 32, 48, 64, 96, 128]:
		print_test(n)
