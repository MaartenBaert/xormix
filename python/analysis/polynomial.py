# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import numpy
import random

from xormix_all import modules

def output_generator(n):
	state = [random.getrandbits(n) for i in range(2)]
	state_matrix = numpy.zeros((n + 1, n), dtype=numpy.uint8)
	for i in range(n + 1):
		modules[n].next_state(state)
		state_matrix[i] = numpy.array([(state[0] >> i) & 1 for i in range(n)], dtype=numpy.uint8)
	while True:
		for i in range(n):
			yield state_matrix[:, i]
		modules[n].next_state(state)
		new_state = numpy.array([(state[0] >> i) & 1 for i in range(n)], dtype=numpy.uint8)
		state_matrix = numpy.vstack((state_matrix[1:], new_state))

def extract_polynomial(n, gen, verify=1000):

	# generate and factor matrix
	a = numpy.zeros((n - 1, n - 1), dtype=numpy.uint8)
	b = numpy.zeros(n - 1, dtype=numpy.uint8)
	for row in range(n - 1):
		while not a[row, row]:
			out = next(gen)
			a[row] = out[1:-1]
			b[row] = out[0] ^ out[-1]
			for col in range(row):
				if a[row][col]:
					a[row, col + 1:] ^= a[col, col + 1:]

	# solve matrix
	x = b.copy()
	for i in range(n - 1):
		x[i] ^= (a[i, :i] & x[:i]).sum() & numpy.uint8(1)
	for i in reversed(range(n - 1)):
		x[i] ^= (a[i, i + 1:] & x[i + 1:]).sum() & numpy.uint8(1)

	# construct polynomial
	one = numpy.ones(1, dtype=numpy.uint8)
	poly = numpy.concatenate((one, x, one))

	# verify polynomial on some new data
	for i in range(verify):
		out = next(gen)
		assert ((out & poly).sum() & numpy.uint8(1)) == 0, 'Invalid polynomial'

	return poly

for n in modules:
	poly = extract_polynomial(n, output_generator(n))
	poly_int = sum(int(poly[i]) << i for i in range(n + 1))
	print(f'xormix{n} polynomial: 0x{poly_int:x}')
