# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix_ref

revision = 1

matrix = [
	[11, 24, 22,  3, 19],
	[25,  7, 20,  2, 26, 28],
	[ 8,  5, 18, 24,  4],
	[ 8, 22, 26,  7, 21, 14],
	[30, 26, 25, 14, 24],
	[21, 10, 16, 13,  5, 17],
	[14, 29, 24, 11, 25],
	[ 5, 26, 31, 22, 27,  7],
	[ 0, 17,  1, 18,  8],
	[29,  0, 21, 26,  3, 13],
	[23, 29, 19, 21, 10],
	[19, 20,  4, 18, 15, 10],
	[28, 29, 24, 19,  4],
	[19,  6, 27, 12, 11,  7],
	[ 1,  5,  3, 30, 25],
	[22, 12, 11,  7, 28,  1],
	[16,  5, 29,  2, 14],
	[ 8, 24,  0, 23, 31, 26],
	[15, 17,  4,  9,  6],
	[30,  9, 18,  2, 11,  6],
	[ 2, 27, 15, 12, 20],
	[21, 20, 10,  6, 31,  1],
	[ 9, 29, 15, 27, 16],
	[29, 10, 31, 30, 13,  3],
	[31, 23,  6, 24, 17],
	[ 4,  8,  6, 19, 16,  9],
	[23, 22, 15, 28,  6],
	[30,  9, 10, 28, 18, 15],
	[25, 20, 19, 12, 28],
	[13, 10,  9,  8,  0, 14],
	[22, 27,  3, 13, 23],
	[12,  2, 16,  1, 17, 23],
]

salts = [
	0x198f8d32, 0x46d9b8ac, 0x57f90206, 0xcb246290,
	0x5fda94c2, 0xb9969e83, 0x990053fe, 0x0cef1f8b,
	0x9baafefa, 0x232b8463, 0x0fc77197, 0xd113a2d8,
	0xd6c99ef7, 0xf3fb7189, 0x9ceeb1dd, 0x352df180,
	0xfeed780c, 0xee211518, 0x3afaca18, 0x95f13c50,
	0xd8449f2a, 0x59752549, 0x854f0980, 0x234a07b4,
	0x51c0c69b, 0xa71d489e, 0x618cbc79, 0xab0e51e1,
	0x965c4507, 0xe90488a4, 0x73674eb7, 0x00af1456,
]

shuffle = [
	15, 29,  5,  0, 16,  9, 26, 14, 13, 10, 19, 11,  2,  6,  8, 17,
	20,  4, 22, 30, 31, 21, 24, 25, 18, 27, 28, 23, 12,  7,  1,  3,
]

shifts = [6, 16, 9, 15]

salts_fs = [
	0xd59417ae, 0x420dfde8, 0x3c59c2d2, 0xc7f786d9,
	0xab8280f2, 0x2f260a00, 0x76349dde, 0xe2cbb6c7,
	0x5561a254, 0x9810899d, 0x1b827534, 0xeb5a0db6,
	0xb7a15719, 0x392584e1, 0xc8d1f233, 0x645693a8,
	0x8597e66a, 0xc68d479c, 0x1bc74a56, 0xfb1fb0b0,
	0x46ca8508, 0x7bf99ff3, 0xb3f83554, 0x8d923b8b,
	0xca6710a8, 0xa203cfa6, 0xe96cd51d, 0xd3ecb2bc,
	0x5d6f872f, 0xae3dadf2, 0xd152dd55, 0x1529fd71,
]

shuffle_fs = [
	16, 12, 30, 31,  6, 19, 17, 11,  1, 20,  9, 24,  5, 23,  0,  4,
	 3, 10, 29, 27, 22, 25, 18,  2, 13, 28,  8,  7, 26, 14, 15, 21,
]

def next_state(state):
	return xormix_ref.next_state(matrix, salts, shuffle, shifts, state)

def seed_full(seed_x, seed_y, streams):
	return xormix_ref.seed_full(salts, seed_x, seed_y, streams)

def seed_simple(seed_x, seed_y, streams, discard = 4):
	return xormix_ref.seed_simple(matrix, salts, shuffle, shifts, seed_x, seed_y, streams, discard)

def seed_fast(seed_x, seed_y, streams, discard = 1):
	return xormix_ref.seed_fast(matrix, salts, shuffle, shifts, salts_fs, shuffle_fs, seed_x, seed_y, streams, discard)
