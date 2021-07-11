# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix

matrix = [
	[10, 12,  2,  8, 15],
	[15, 10,  7, 14, 13,  5],
	[10,  9,  4,  7,  0],
	[14,  0,  3,  8,  9,  1],
	[ 1,  3,  9, 12, 13],
	[ 7,  2, 12,  9, 11, 15],
	[ 1,  2,  4,  3,  0],
	[10,  6,  3,  0,  4, 11],
	[ 2,  7, 13,  6,  8],
	[ 5,  0, 12,  3, 15,  9],
	[13,  0,  9,  4,  8],
	[ 1,  5, 12,  6, 13,  4],
	[12,  1,  6, 10, 14],
	[11, 15,  8,  7,  5,  1],
	[10, 11,  2,  0,  5],
	[ 6, 14, 12, 11,  5,  9],
]

salts = [
	0xd2ba, 0xbc36, 0x16a6, 0xe3eb,
	0xb749, 0x5bc4, 0x09f7, 0xf491,
	0x5e28, 0x2d5a, 0xda5d, 0x2cab,
	0x4058, 0x7547, 0xe94c, 0x0a05,
]

shuffle = [
	 4,  5, 14,  2,  9,  7,  3,  0, 10,  6, 13,  8, 11, 15,  1, 12,
]

shifts = [4, 8, 5, 7]

def next_state(state):
	return xormix.next_state(matrix, salts, shuffle, shifts, state)
