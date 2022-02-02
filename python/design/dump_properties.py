# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import math
import numpy
import sys

import xormix_all
import extract_lfsr
import extract_phases

def print_matrix(matrix):
	chars = '01'
	print('\n'.join('\t[' + ' '.join(chars[x & 1] for x in row) + ']' for row in matrix))

def write_array(f, name, n, words, cols, braces=False, dec=False):
	limbs = (n + 63) // 64
	nl = n // limbs
	nt = 1 << (nl - 1).bit_length()
	ml = (1 << nl) - 1
	chars = nl // 4
	values = []
	for word in words:
		values2 = []
		for limb in range(limbs):
			value = (word >> (limb * nl)) & ml
			values2.append(f'UINT{nt}_C(0x{value:0{chars}x})')
		values.append(('{' if braces else '') + ', '.join(values2) + ('}' if braces else ''))
	f.write(name + ' = {\n')
	for i in range(0, len(values), cols // limbs):
		f.write('\t' + ', '.join(values[i : i + cols // limbs]) + ',\n')
	f.write('};\n')

def write_array_dec(f, name, n, words, cols):
	chars = int(math.log10(n)) + 1
	values = []
	for word in words:
		values.append(f'{word:{chars}d}')
	f.write(name + ' = {\n')
	for i in range(0, len(values), cols):
		f.write('\t' + ', '.join(values[i : i + cols]) + ',\n')
	f.write('};\n')

for n in xormix_all.modules:

	module = xormix_all.modules[n]
	chars = int(math.log10(n)) + 1

	title = f'Xormix{n}'
	print(title)
	print('-' * len(title))
	print()

	print(f'Revision: {module.revision}')
	print()

	a = extract_lfsr.extract_matrix(n, module.matrix)
	(poly, u, v) = extract_lfsr.extract_lfsr(n, a)

	print('State-transition matrix (sparse form):')
	print()
	print('\n'.join('\t[' + ' '.join(f'{x:{chars}d}' for x in row) + ']' for row in module.matrix))
	print()

	print('Salts:')
	print()
	print('\n'.join('\t' + ' '.join(f'0x{x:0{n//4}x}' for x in module.salts[i : i + 4]) for i in range(0, len(module.salts), 4)))
	print()

	print('Shuffle:')
	print()
	print('\n'.join('\t' + ' '.join(f'{x:{chars}d}' for x in module.shuffle[i : i + 16]) for i in range(0, len(module.shuffle), 16)))
	print()

	shifts = ' '.join(str(x) for x in module.shifts)
	print(f'Shifts: `{shifts}`')
	print()

	print('Full state-transition matrix:')
	print()
	print_matrix(a)
	print()

	print('`U` matrix:')
	print()
	print_matrix(u)
	print()

	print('`V` matrix:')
	print()
	print_matrix(v)
	print()

	print(f'Polynomial: `0x{poly:0{n//4+1}x}`')
	print()

	print('Bit phases:')
	print()
	extract_phases.extract_phases(n, module.matrix, show_result=True)
	print()
