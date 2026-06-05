# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix_ref

revision = 1

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

salts_fs = [
	0x3757cf, 0x9c4f58, 0xb40be6, 0xbba6b8,
	0xfd00cb, 0x0dbe63, 0x540523, 0x3df166,
	0xd0f85f, 0xb9db91, 0x52f4e9, 0xa085dd,
	0xc29c32, 0x2c703d, 0xdba985, 0xf67e7c,
	0x4c4ab1, 0x4e38c8, 0x3e8070, 0x2464c3,
	0x6bf8b0, 0x51a20c, 0x8fc2a7, 0x22ea09,
]

shuffle_fs = [
	15,  3, 17,  9, 21,  1, 20,  8,  5, 18, 10, 14,  0,  7,  6, 12,
	16, 11, 13,  4, 23, 19,  2, 22,
]

def next_state(state):
	return xormix_ref.next_state(matrix, salts, shuffle, shifts, state)

def seed_full(seed_x, seed_y, streams):
	return xormix_ref.seed_full(salts, seed_x, seed_y, streams)

def seed_simple(seed_x, seed_y, streams, discard = 4):
	return xormix_ref.seed_simple(matrix, salts, shuffle, shifts, seed_x, seed_y, streams, discard)

def seed_fast(seed_x, seed_y, streams, discard = 1):
	return xormix_ref.seed_fast(matrix, salts, shuffle, shifts, salts_fs, shuffle_fs, seed_x, seed_y, streams, discard)
