# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix_ref

matrix = [
	[ 0, 17,  2,  9, 22],
	[18,  1, 14, 11,  4,  9],
	[19, 15, 17, 23,  7],
	[18, 13, 14,  0,  6,  7],
	[18, 20,  1, 19, 11],
	[23, 15,  5, 16,  4,  3],
	[ 2,  6,  3, 15, 20],
	[ 4,  5, 16,  8, 12, 21],
	[20,  5, 10, 15,  2],
	[ 3, 23, 14,  0,  9, 20],
	[ 1, 11,  0, 23, 13],
	[20,  8, 10, 14,  7,  2],
	[ 8,  6,  0,  3, 16],
	[ 5, 22, 16,  2, 18, 11],
	[ 2, 22,  3,  8,  1],
	[ 5, 21, 22,  7, 11, 10],
	[12,  6, 15, 14,  4],
	[ 9,  4,  1, 17,  6, 19],
	[12, 20, 22,  9, 21],
	[16, 19, 18, 12,  0,  3],
	[ 3, 10, 14, 17,  1],
	[23, 13, 21,  9, 12,  7],
	[22, 14,  8,  9, 10],
	[ 8, 19, 21, 23, 17, 13],
]

salts = [
	0xd96a94, 0x8c3c8d, 0xb8b710, 0x112b89,
	0x6aaf55, 0x295e05, 0xa64b72, 0x39b1db,
	0x5c5955, 0x915302, 0x040da6, 0xe79f3f,
	0xf52624, 0xce7aee, 0x74c90b, 0x00c73d,
	0x1cee53, 0xeb76b1, 0x271093, 0x73ac8e,
	0x57622b, 0xbf29d0, 0x02efea, 0xa1befc,
]

shuffle = [
	 0,  7, 17,  8,  9, 13, 11, 12,  2, 16, 14,  4, 21, 10,  3, 20,
	22, 19, 15,  1,  5, 23,  6, 18,
]

shifts = [8, 12, 9, 11]

def next_state(state):
	return xormix_ref.next_state(matrix, salts, shuffle, shifts, state)
