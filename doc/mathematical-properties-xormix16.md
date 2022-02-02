Mathematical Properties of Xormix16
===================================

Revision: 1

State-transition matrix (sparse form):

	[ 3 11  1  4 13]
	[11 12 10  2  8  9]
	[ 0 10 11  4 15]
	[ 1 11 13  0  6 10]
	[ 8  3  6  1  7]
	[ 3  5  4  1 14  6]
	[ 8  7 12 11 13]
	[14  7  8  5 13 10]
	[ 7  0  4 12 13]
	[15  3  9  2 11  5]
	[ 0  9  6 11  4]
	[12 15  2  3 14  0]
	[14  3  9 13  0]
	[ 6 10 12  7  2  1]
	[ 5  7  1 15  6]
	[ 0  7 10 14  9  1]

Salts:

	0xd2ba 0xbc36 0x16a6 0xe3eb
	0xb749 0x5bc4 0x09f7 0xf491
	0x5e28 0x2d5a 0xda5d 0x2cab
	0x4058 0x7547 0xe94c 0x0a05

Shuffle:

	 4  5 14  2  9  7  3  0 10  6 13  8 11 15  1 12

Shifts: `4 8 5 7`

Full state-transition matrix:

	[0 1 0 1 1 0 0 0 0 0 0 1 0 1 0 0]
	[0 0 1 0 0 0 0 0 1 1 1 1 1 0 0 0]
	[1 0 0 0 1 0 0 0 0 0 1 1 0 0 0 1]
	[1 1 0 0 0 0 1 0 0 0 1 1 0 1 0 0]
	[0 1 0 1 0 0 1 1 1 0 0 0 0 0 0 0]
	[0 1 0 1 1 1 1 0 0 0 0 0 0 0 1 0]
	[0 0 0 0 0 0 0 1 1 0 0 1 1 1 0 0]
	[0 0 0 0 0 1 0 1 1 0 1 0 0 1 1 0]
	[1 0 0 0 1 0 0 1 0 0 0 0 1 1 0 0]
	[0 0 1 1 0 1 0 0 0 1 0 1 0 0 0 1]
	[1 0 0 0 1 0 1 0 0 1 0 1 0 0 0 0]
	[1 0 1 1 0 0 0 0 0 0 0 0 1 0 1 1]
	[1 0 0 1 0 0 0 0 0 1 0 0 0 1 1 0]
	[0 1 1 0 0 0 1 1 0 0 1 0 1 0 0 0]
	[0 1 0 0 0 1 1 1 0 0 0 0 0 0 0 1]
	[1 1 0 0 0 0 0 1 0 1 1 0 0 0 1 0]

`U` matrix:

	[1 0 0 0 0 1 1 1 1 0 0 0 0 0 1 1]
	[0 0 1 0 0 0 1 0 1 1 1 1 1 0 1 0]
	[0 1 1 0 1 1 0 1 0 0 0 0 0 1 1 0]
	[0 1 0 0 1 1 1 0 1 1 0 1 0 1 1 0]
	[0 0 0 1 0 1 0 1 1 1 0 0 0 0 1 0]
	[0 0 1 0 0 0 0 1 0 0 0 1 1 0 1 0]
	[0 0 1 1 0 0 1 0 0 1 1 1 0 0 0 1]
	[0 0 0 1 1 1 1 0 0 0 0 1 1 1 0 0]
	[0 1 1 0 1 0 1 1 1 1 0 0 0 1 0 0]
	[0 0 0 1 0 0 1 0 0 1 0 0 0 1 1 0]
	[0 1 1 1 1 1 0 0 0 1 0 0 1 1 0 0]
	[0 1 0 0 1 0 1 0 1 1 1 0 1 1 1 1]
	[0 1 1 0 0 1 1 1 1 1 0 1 0 0 1 0]
	[0 0 1 1 1 1 0 0 0 0 0 0 0 1 1 1]
	[0 0 1 0 1 0 0 0 1 0 1 1 0 0 0 1]
	[0 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1]

`V` matrix:

	[1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0]
	[0 1 1 1 0 1 1 1 1 0 1 0 1 1 0 0]
	[0 1 0 0 1 1 1 0 0 1 1 0 0 1 1 1]
	[0 0 0 1 0 0 1 1 0 1 1 1 0 0 1 1]
	[0 1 1 1 0 1 1 0 0 1 0 1 0 1 0 1]
	[0 1 0 1 1 1 0 1 0 0 0 0 0 1 0 1]
	[0 1 0 0 0 0 0 1 1 1 0 1 1 1 1 1]
	[0 1 1 1 1 0 1 0 0 0 1 0 1 1 0 0]
	[0 0 1 1 1 1 0 0 1 0 1 0 0 0 0 0]
	[0 0 0 1 1 0 1 0 0 1 0 1 1 0 1 1]
	[0 1 0 1 1 0 0 1 0 0 0 0 1 0 0 0]
	[0 1 1 0 0 0 1 1 0 1 1 0 1 1 1 1]
	[0 1 0 0 1 0 0 1 1 0 0 0 0 1 0 1]
	[0 1 0 1 0 0 1 0 0 0 0 1 0 1 1 0]
	[0 0 0 1 1 0 1 0 1 0 1 0 0 0 0 1]
	[0 0 1 1 1 1 1 0 1 1 1 1 0 1 1 1]

Polynomial: `0x1bf23`

Bit phases:

	Bit  0: output=0xc1e1 lfsr=0xdb71 phase=0xcb2a
	Bit  1: output=0x5f44 lfsr=0x3408 phase=0xf5ab
	Bit  2: output=0x60b6 lfsr=0x5293 phase=0xd96f
	Bit  3: output=0x6b72 lfsr=0x671d phase=0x2e47
	Bit  4: output=0x43a8 lfsr=0x1c02 phase=0x7bca
	Bit  5: output=0x5884 lfsr=0x364e phase=0xa176
	Bit  6: output=0x8e4c lfsr=0x2f2a phase=0x3f43
	Bit  7: output=0x3878 lfsr=0x1399 phase=0x0e05
	Bit  8: output=0x23d6 lfsr=0x57a2 phase=0x1eaf
	Bit  9: output=0x6248 lfsr=0x18e6 phase=0x655d
	Bit 10: output=0x323e lfsr=0x48bf phase=0x26fc
	Bit 11: output=0xf752 lfsr=0x61c1 phase=0x031c
	Bit 12: output=0x4be6 lfsr=0x5cb9 phase=0x5b2b
	Bit 13: output=0xe03c lfsr=0x2717 phase=0xe1fd
	Bit 14: output=0x8d14 lfsr=0x3aef phase=0x75ce
	Bit 15: output=0xf77e lfsr=0x4b2b phase=0x533d
	Minimum distance: 1532
	Relative minimum distance: 5.984
