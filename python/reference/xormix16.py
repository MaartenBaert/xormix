# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix_ref

revision = 1

matrix = [
	[ 3, 11,  1,  4, 13],
	[11, 12, 10,  2,  8,  9],
	[ 0, 10, 11,  4, 15],
	[ 1, 11, 13,  0,  6, 10],
	[ 8,  3,  6,  1,  7],
	[ 3,  5,  4,  1, 14,  6],
	[ 8,  7, 12, 11, 13],
	[14,  7,  8,  5, 13, 10],
	[ 7,  0,  4, 12, 13],
	[15,  3,  9,  2, 11,  5],
	[ 0,  9,  6, 11,  4],
	[12, 15,  2,  3, 14,  0],
	[14,  3,  9, 13,  0],
	[ 6, 10, 12,  7,  2,  1],
	[ 5,  7,  1, 15,  6],
	[ 0,  7, 10, 14,  9,  1],
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
	return xormix_ref.next_state(matrix, salts, shuffle, shifts, state)
