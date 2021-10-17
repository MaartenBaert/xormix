# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix

matrix = [
	[39, 15, 25,  8, 47],
	[11, 13,  9, 37, 15, 22],
	[ 6, 26, 47,  0, 31],
	[ 2, 14, 31, 24, 19, 32],
	[18, 40, 27, 26,  4],
	[ 3, 24, 18, 38, 44, 32],
	[14, 11, 35,  2, 38],
	[14, 18, 44, 41,  7, 33],
	[40, 46, 27,  4, 43],
	[22,  6, 45, 47, 29, 44],
	[36, 28, 42, 13, 25],
	[20, 15, 40, 28, 19, 29],
	[10, 36, 42, 24,  3],
	[ 5,  2,  4, 25, 37, 46],
	[38, 36,  4, 32,  6],
	[38, 33, 17, 43, 45, 25],
	[15, 45, 19, 11, 31],
	[ 3, 40, 23, 30, 37, 47],
	[ 3,  1, 45, 29, 18],
	[42, 35, 21, 13,  1, 29],
	[37, 41, 32, 42, 33],
	[12,  0, 29, 28,  4, 22],
	[39, 37, 12, 44, 19],
	[43,  7, 16, 23, 21, 27],
	[17, 32,  8, 20, 43],
	[25, 44, 19, 31, 41, 16],
	[26, 17,  3, 44, 34],
	[22, 42, 28,  6,  8, 36],
	[23, 16, 20,  9,  2],
	[ 1, 30, 18,  8,  7, 26],
	[22, 32, 35, 47, 20],
	[11, 39, 13, 34,  0, 24],
	[17, 39, 36, 12,  9],
	[15, 14,  2, 39, 21,  5],
	[33, 17,  2, 26, 34],
	[34,  8, 30,  7, 10, 19],
	[43, 31, 18,  4, 35],
	[ 7, 33, 40, 41, 42, 21],
	[ 7, 22, 10, 16, 15],
	[45,  0, 28, 27, 13,  9],
	[35,  0, 30, 41, 46],
	[41, 46, 29, 32, 26, 12],
	[45, 11,  6,  1, 10],
	[41, 34, 25, 12, 37,  1],
	[13, 46, 37, 36,  7],
	[27, 23,  9,  8, 30,  5],
	[16,  5, 20, 38, 23],
	[14, 24, 43, 44, 21,  5],
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

def next_state(state):
	return xormix.next_state(matrix, salts, shuffle, shifts, state)
