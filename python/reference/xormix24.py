# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix

matrix = [
	[ 0, 19, 21, 13, 18],
	[13, 20,  1, 21,  6, 22],
	[ 7, 16, 11, 12, 19],
	[ 9,  4,  8, 12, 13, 21],
	[ 7, 12, 20, 15,  3],
	[ 9, 19,  2, 16,  7, 18],
	[ 8, 14,  4, 19,  2],
	[22, 14, 17,  4, 16,  3],
	[21,  8, 10, 14, 15],
	[ 4,  9, 21,  2, 11,  1],
	[ 8,  5, 10, 20, 14],
	[ 0,  7, 20,  6,  8, 17],
	[17,  6,  5,  2, 16],
	[16,  4, 13, 15,  1, 22],
	[ 5, 18,  0, 23, 17],
	[19, 18, 11,  3,  1, 23],
	[12, 22,  9,  1,  0],
	[ 6, 15,  3, 16, 11,  2],
	[22,  9, 18,  7, 14],
	[ 4,  1, 10, 20,  3,  8],
	[ 0,  8, 17, 16,  5],
	[ 7, 11, 15,  2, 14, 23],
	[23, 10,  0, 11,  5],
	[11,  2, 10, 12, 15, 13],
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
	return xormix.next_state(matrix, salts, shuffle, shifts, state)
