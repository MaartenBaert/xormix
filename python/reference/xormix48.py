# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix_ref

revision = 1

matrix = [
	[22, 15, 43,  7, 11],
	[42, 14, 12, 35, 11, 17],
	[15, 31, 24, 44, 47],
	[26, 32, 47, 21, 35, 11],
	[ 6, 46, 36,  4, 33],
	[33, 19, 24, 32,  3, 38],
	[ 1, 38, 47, 16, 21],
	[25, 28, 29, 24, 35, 43],
	[34,  5, 41,  3,  0],
	[37, 34, 22,  2, 13, 14],
	[45,  1, 40,  8, 17],
	[20, 41,  9, 23, 32, 24],
	[ 4, 23, 25,  5, 35],
	[ 8, 19, 14, 28, 44, 26],
	[ 3, 10, 35, 46, 12],
	[15,  2, 35, 31, 43, 29],
	[ 6,  5, 11,  8, 20],
	[28, 10, 37, 24, 35,  5],
	[31, 42, 17, 45, 21],
	[42, 45, 36,  9, 31, 28],
	[27, 39, 19,  0, 38],
	[14, 40, 16,  9, 25, 18],
	[20, 27,  2, 45, 42],
	[44, 40, 20,  3, 25,  7],
	[16, 22, 39,  8, 13],
	[ 4, 46, 38, 33, 40, 26],
	[13,  6, 47,  2,  7],
	[27, 28, 10, 32,  0, 12],
	[36,  3, 26, 39, 30],
	[39, 12, 21, 38, 46, 30],
	[ 9, 41, 27, 12, 18],
	[45, 12, 47,  1,  3, 23],
	[24, 25, 29, 20, 18],
	[31,  2, 45, 11, 25, 30],
	[17,  7, 10, 34, 44],
	[ 4, 27,  0, 41, 43, 17],
	[ 5, 17, 46, 44, 39],
	[ 4, 42,  0,  6, 23, 22],
	[40, 43,  7,  6, 29],
	[23, 29, 43, 32, 36, 14],
	[ 0, 13, 15, 16, 25],
	[19, 30, 16,  6, 36, 44],
	[37,  4, 23, 41, 13],
	[33, 22, 19, 41, 28, 37],
	[24, 34,  5,  1,  9],
	[27, 37, 33, 32,  7, 47],
	[41, 10, 15,  8, 42],
	[ 8, 18, 19,  3, 10, 37],
]

salts = [
	0xdc2a970723c9, 0xe3e9a7b5f00f, 0x368fddfe10b2, 0x75cf3224f670,
	0xadc3319ee962, 0xc9fdd5da7238, 0x838aa6d68e51, 0x34504e889c4e,
	0x16f61844dd41, 0x316767a3bcb6, 0x4f2b4ee6a079, 0x8a9ef2995097,
	0x8f8919a04ad3, 0x54d0862260f6, 0x59bf4852d6de, 0xe182ee2c64dc,
	0x117087d44a4c, 0x2de1ba749c87, 0x4db37369078b, 0xc4d0b2be2d19,
	0xfe1e25f4f213, 0x11f41b1ba06e, 0x0f2cf602d40a, 0x1a4f0b78edd2,
	0x0635bdf9a9a1, 0xe6066341f129, 0xd63a2e6c6b6e, 0x3f0b1417a83e,
	0xaa5f9fc3447b, 0xfd4ca29740b2, 0xd307b0424a1f, 0x377cf18c8a09,
	0x4ae1ee2f8ff1, 0x6470f197fbcc, 0x93fb56272e46, 0xb8ff040d894b,
	0x7de7947afb4b, 0x8c2c614e379f, 0x981e3a7298fb, 0x1d16c2d1672f,
	0x3e8785982f5c, 0xe92ab1204c26, 0xf7c8549141c1, 0x109c81c9df19,
	0x9379f90a2ff8, 0x583491406df0, 0x00302447d0cf, 0x34c3236725e9,
]

shuffle = [
	 8, 23,  2, 15, 46, 31, 22, 12, 27, 17,  9, 39, 42, 19, 28, 45,
	 1,  0, 41, 30,  3, 38, 25, 29, 24,  5, 32, 44, 26, 21, 37, 34,
	13, 18, 35,  6, 11, 36, 43,  7, 40, 33, 20, 10, 47,  4, 14, 16,
]

shifts = [19, 21, 15, 22]

salts_fs = [
	0xbd5f41916e4e, 0x17956c1300c6, 0xff99149e0a17, 0xa3d5c94d8e39,
	0x2e5cd2e56651, 0xe854fcc7ff85, 0xe0e54cccc1d6, 0xe346b6217663,
	0x5a72cbe0e903, 0x7c932680be08, 0x163155db9aa9, 0xcd43c56b121d,
	0x41d4181fb93c, 0xf8907f491feb, 0x5626a7bd1429, 0x6477c1c2df3b,
	0xec53989ee861, 0x01f66ea4216f, 0xef97855cf3e6, 0x0bc367472330,
	0x2e0e7c6ad7fe, 0x5d3180cbba56, 0xe64fa0c47104, 0xc47fab21b056,
	0x1e444d0c452a, 0x02eec7cb72c5, 0x7759f4f85e4a, 0xd2712c9aaf59,
	0xe8727e545230, 0x576bd40f2d78, 0xecd831fd3727, 0xfe8515f37445,
	0x290e78199401, 0xfb2ebb922fca, 0xf6d46b75ad90, 0x62e3f228d04d,
	0x96aa073e2f34, 0x09a63ff71ff8, 0xf5033d71cbfe, 0x52fddf0a8680,
	0xa126a8ff60e0, 0xabba26ac8ca7, 0x62988912410f, 0x6f57c0fe0d8d,
	0x5c890211cfcf, 0x6c0ccb41bacc, 0x8a79fa679c43, 0x54385044a17f,
]

shuffle_fs = [
	 8, 25, 15,  9, 26, 41, 22, 21, 37, 20, 43, 32, 42, 13, 16, 47,
	18,  2, 38,  1, 33, 36, 17, 31, 39, 46, 45, 14,  7, 29, 10, 30,
	23,  0,  6, 11, 24,  3, 28,  5, 35, 40, 34, 12, 19,  4, 27, 44,
]

def next_state(state):
	return xormix_ref.next_state(matrix, salts, shuffle, shifts, state)

def seed_full(seed_x, seed_y, streams):
	return xormix_ref.seed_full(salts, seed_x, seed_y, streams)

def seed_simple(seed_x, seed_y, streams, discard = 4):
	return xormix_ref.seed_simple(matrix, salts, shuffle, shifts, seed_x, seed_y, streams, discard)

def seed_fast(seed_x, seed_y, streams, discard = 1):
	return xormix_ref.seed_fast(matrix, salts, shuffle, shifts, salts_fs, shuffle_fs, seed_x, seed_y, streams, discard)
