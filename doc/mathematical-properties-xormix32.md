Mathematical Properties of Xormix32
===================================

Revision: 1

State-transition matrix (sparse form):

	[11 24 22  3 19]
	[25  7 20  2 26 28]
	[ 8  5 18 24  4]
	[ 8 22 26  7 21 14]
	[30 26 25 14 24]
	[21 10 16 13  5 17]
	[14 29 24 11 25]
	[ 5 26 31 22 27  7]
	[ 0 17  1 18  8]
	[29  0 21 26  3 13]
	[23 29 19 21 10]
	[19 20  4 18 15 10]
	[28 29 24 19  4]
	[19  6 27 12 11  7]
	[ 1  5  3 30 25]
	[22 12 11  7 28  1]
	[16  5 29  2 14]
	[ 8 24  0 23 31 26]
	[15 17  4  9  6]
	[30  9 18  2 11  6]
	[ 2 27 15 12 20]
	[21 20 10  6 31  1]
	[ 9 29 15 27 16]
	[29 10 31 30 13  3]
	[31 23  6 24 17]
	[ 4  8  6 19 16  9]
	[23 22 15 28  6]
	[30  9 10 28 18 15]
	[25 20 19 12 28]
	[13 10  9  8  0 14]
	[22 27  3 13 23]
	[12  2 16  1 17 23]

Salts:

	0x198f8d32 0x46d9b8ac 0x57f90206 0xcb246290
	0x5fda94c2 0xb9969e83 0x990053fe 0x0cef1f8b
	0x9baafefa 0x232b8463 0x0fc77197 0xd113a2d8
	0xd6c99ef7 0xf3fb7189 0x9ceeb1dd 0x352df180
	0xfeed780c 0xee211518 0x3afaca18 0x95f13c50
	0xd8449f2a 0x59752549 0x854f0980 0x234a07b4
	0x51c0c69b 0xa71d489e 0x618cbc79 0xab0e51e1
	0x965c4507 0xe90488a4 0x73674eb7 0x00af1456

Shuffle:

	15 29  5  0 16  9 26 14 13 10 19 11  2  6  8 17
	20  4 22 30 31 21 24 25 18 27 28 23 12  7  1  3

Shifts: `6 16 9 15`

Full state-transition matrix:

	[0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 0 0 0 0 0]
	[0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 1 0 1 0 0 0]
	[0 0 0 0 1 1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0]
	[0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 0 0 0 0 0 1 1 0 0 0 1 0 0 0 0 0]
	[0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 1 0]
	[0 0 0 0 0 1 0 0 0 0 1 0 0 1 0 0 1 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0]
	[0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 0]
	[0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 0 0 1]
	[1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0]
	[1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1 0 0]
	[0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 0 0 0 1 0 0]
	[0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0]
	[0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 1 0 0]
	[0 0 0 0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0]
	[0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0]
	[0 1 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0]
	[0 0 1 0 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0]
	[1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 0 0 0 0 1]
	[0 0 0 0 1 0 1 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
	[0 0 1 0 0 0 1 0 0 1 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0]
	[0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0]
	[0 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 1]
	[0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0]
	[0 0 0 1 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1]
	[0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 1 0 0 0 0 0 0 1]
	[0 0 0 0 1 0 1 0 1 1 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0]
	[0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 0 0 0 0 1 0 0 0]
	[0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 1 0]
	[0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 0]
	[1 0 0 0 0 0 0 0 1 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
	[0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 0 0 0]
	[0 1 1 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0]

`U` matrix:

	[1 0 0 1 1 0 0 0 1 1 0 1 0 1 1 1 0 1 1 1 1 1 1 0 1 1 0 1 1 0 1 0]
	[0 0 0 1 0 1 1 0 0 0 1 1 1 1 0 0 0 0 1 0 1 1 1 0 1 0 0 1 1 0 1 0]
	[0 0 1 0 0 1 1 0 0 0 0 1 0 0 0 1 0 1 0 0 1 0 1 1 1 1 1 1 0 0 1 0]
	[0 0 1 0 0 1 1 0 0 1 0 1 1 0 0 1 1 1 0 1 0 1 0 1 1 0 1 1 0 1 1 1]
	[0 0 0 1 0 1 1 1 1 1 0 0 1 1 1 1 0 0 0 1 1 1 1 1 1 1 0 0 1 1 1 0]
	[0 0 1 0 0 1 0 1 1 1 0 1 1 0 1 1 1 0 0 1 1 1 0 0 0 0 0 1 0 1 1 0]
	[0 0 1 1 1 1 0 1 0 0 0 1 0 0 0 1 1 1 1 1 1 1 1 0 0 0 1 1 1 0 1 0]
	[0 0 0 1 1 1 1 0 0 0 0 1 0 1 1 0 0 1 1 0 1 1 1 1 1 1 1 0 1 1 1 0]
	[0 1 0 1 1 0 0 1 0 1 0 0 0 0 1 0 1 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0]
	[0 1 1 1 0 0 1 1 0 1 0 0 0 1 0 0 0 1 1 1 1 1 0 1 1 0 0 1 0 1 0 1]
	[0 0 1 1 0 1 0 0 1 0 0 0 1 0 0 1 0 1 0 0 1 1 0 1 0 1 0 0 1 0 1 0]
	[0 0 0 0 0 0 1 0 0 1 1 1 1 0 1 1 1 0 0 1 0 1 0 1 0 1 1 1 1 0 0 1]
	[0 0 1 0 1 1 1 1 0 1 0 1 0 1 1 0 0 1 0 0 0 0 0 1 0 1 0 0 1 1 1 0]
	[0 0 0 0 1 0 1 0 1 1 1 0 1 0 1 1 1 0 1 0 1 0 0 1 1 1 1 1 0 0 1 0]
	[0 0 0 0 0 0 0 0 0 0 1 1 1 0 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 1 1 0]
	[0 0 0 1 1 1 1 1 1 1 0 1 0 1 1 0 0 1 1 0 1 1 1 1 1 0 0 1 0 1 1 1]
	[0 0 1 1 1 1 0 0 1 0 0 1 0 0 1 1 0 0 0 0 1 0 1 0 0 1 1 1 1 0 1 0]
	[0 1 1 1 1 0 1 1 1 1 1 1 0 0 1 1 0 0 0 1 0 0 0 1 1 0 0 0 1 1 0 0]
	[0 0 0 1 1 1 1 0 1 1 0 1 1 1 1 1 1 1 1 1 0 0 0 1 0 0 1 1 1 1 0 1]
	[0 0 1 1 0 0 1 1 0 1 0 1 0 0 1 0 1 0 1 0 1 1 0 0 0 0 1 0 0 1 0 0]
	[0 0 0 1 0 1 0 1 1 1 1 0 1 0 1 0 0 1 0 0 1 0 1 0 1 1 1 1 1 0 0 0]
	[0 0 0 1 0 1 1 1 0 1 1 0 1 1 1 0 0 1 0 1 1 0 1 1 0 1 1 1 0 1 0 1]
	[0 0 0 1 1 1 1 1 0 1 1 1 0 1 0 1 0 1 1 0 0 1 0 0 0 0 0 0 1 1 1 1]
	[0 0 1 1 1 1 1 1 1 1 1 0 0 0 1 1 0 1 0 0 1 0 1 0 1 1 0 0 1 0 1 1]
	[0 0 1 1 1 0 0 1 1 0 1 0 1 0 1 1 0 1 1 1 0 1 0 1 0 1 0 1 0 0 0 0]
	[0 0 0 0 0 1 1 1 1 0 0 0 1 1 0 0 1 1 0 1 0 1 0 1 0 0 1 1 0 1 1 1]
	[0 0 0 0 0 0 1 1 1 1 0 0 0 1 1 1 1 1 0 0 1 0 0 0 1 0 0 0 0 1 0 1]
	[0 0 1 0 1 0 0 0 1 0 1 0 1 1 1 1 1 0 1 1 1 0 1 0 0 0 1 0 0 0 1 1]
	[0 0 0 0 0 1 0 1 1 1 0 1 1 1 1 0 0 0 1 0 1 1 1 0 0 1 1 0 0 0 1 1]
	[0 1 0 0 0 1 1 0 0 1 0 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0 0 0 1 0 0]
	[0 0 0 1 0 0 1 0 0 1 0 0 0 1 0 1 1 1 1 1 0 1 0 0 0 1 0 1 0 0 0 1]
	[0 0 1 1 0 0 1 1 1 1 1 1 1 1 0 0 0 0 1 1 1 0 1 0 1 0 0 0 1 1 0 1]

`V` matrix:

	[1 1 1 0 0 0 1 1 1 0 1 1 1 0 0 1 1 0 1 1 1 1 0 0 1 1 0 1 1 1 1 0]
	[0 1 0 0 1 1 1 0 0 0 1 1 0 1 0 1 1 0 1 0 0 1 0 0 1 0 1 0 0 1 0 1]
	[0 0 0 1 1 0 1 1 1 0 0 1 1 1 0 1 0 0 0 0 1 0 1 0 0 1 1 1 0 1 0 1]
	[0 1 0 1 1 1 1 1 1 0 1 1 1 0 1 0 1 1 1 0 1 1 1 0 0 0 1 0 1 0 0 1]
	[0 1 0 1 1 0 0 1 1 1 1 1 1 0 1 1 0 0 1 0 0 0 1 0 1 1 1 0 0 0 1 1]
	[0 0 1 1 1 0 0 1 0 1 0 0 0 1 1 0 1 1 0 0 1 0 1 1 0 0 1 0 1 0 0 0]
	[0 0 0 1 0 1 1 1 1 1 0 1 1 1 1 1 0 0 0 1 1 1 1 0 1 0 1 0 1 0 1 1]
	[0 0 1 1 0 1 1 1 1 1 1 0 0 0 1 1 1 0 1 1 0 1 0 0 1 0 1 1 0 0 1 0]
	[0 0 0 1 1 1 1 0 0 1 1 1 1 0 1 0 1 0 1 1 1 1 0 1 0 1 1 1 1 1 0 0]
	[0 0 0 1 1 1 1 0 1 1 0 0 1 1 0 0 0 0 0 1 0 0 1 1 1 0 0 1 1 0 1 1]
	[0 1 0 0 0 1 1 0 0 0 0 0 0 1 0 1 1 1 1 1 0 1 0 0 0 1 1 0 1 1 1 1]
	[0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 0 1]
	[0 0 0 1 0 0 1 1 1 1 0 1 1 1 1 0 1 0 0 0 1 0 1 0 0 1 1 1 0 0 1 0]
	[0 1 0 0 1 1 1 1 0 1 0 1 1 1 1 0 1 1 0 1 0 0 0 0 0 0 1 0 1 0 1 1]
	[0 0 1 1 1 0 0 0 1 0 1 1 0 0 1 1 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1]
	[0 0 0 1 1 0 1 1 1 0 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 0 0 1 1 0 1 0]
	[0 0 0 1 1 0 0 1 1 1 1 0 1 0 0 1 1 0 1 1 0 0 0 0 1 1 1 1 1 0 0 0]
	[0 0 1 1 1 1 0 0 0 0 1 1 0 0 1 1 0 1 1 1 1 1 1 0 1 1 0 1 0 1 0 0]
	[0 0 1 1 1 1 1 1 0 1 0 1 0 1 1 1 1 0 0 0 0 0 1 1 0 1 0 1 0 1 0 0]
	[0 1 0 0 1 1 1 0 1 1 0 1 1 1 0 1 0 1 0 0 0 0 1 1 0 1 1 0 0 1 1 0]
	[0 0 1 1 1 1 0 1 1 0 1 0 1 0 1 0 1 0 0 1 0 1 1 1 1 1 1 1 1 1 0 0]
	[0 0 0 1 0 1 1 1 0 0 0 1 0 1 1 0 0 1 0 0 1 1 0 0 1 0 1 1 1 1 0 0]
	[0 0 1 1 0 0 1 1 1 0 1 1 0 1 0 0 1 1 0 1 0 1 1 1 0 0 0 0 1 0 0 0]
	[0 0 0 1 0 1 1 0 0 1 0 1 1 0 0 1 0 0 0 1 0 0 1 0 1 1 1 1 0 1 0 0]
	[0 1 1 1 0 1 1 1 1 1 0 1 0 0 1 0 0 1 0 0 1 1 0 1 1 1 1 0 1 1 0 0]
	[0 1 0 1 0 0 0 0 0 1 1 0 1 1 0 0 1 0 0 0 0 0 1 0 0 1 1 0 0 1 0 1]
	[0 0 1 1 1 1 0 1 1 0 0 0 1 1 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 1 0 1]
	[0 1 0 1 1 1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 0 1 1 1 1 0 1 1 0 1 0 0]
	[0 1 0 0 1 0 1 0 1 1 1 0 1 1 1 1 1 0 0 0 0 1 1 1 1 1 0 1 1 0 0 0]
	[0 1 1 0 1 1 0 0 0 0 1 0 1 0 0 0 1 0 0 0 1 1 0 1 1 0 0 0 0 0 1 1]
	[0 1 1 1 0 0 0 1 0 0 1 1 0 1 1 1 1 1 0 0 0 1 1 1 0 0 1 1 1 1 0 1]
	[0 1 0 0 1 1 1 1 0 1 1 0 1 0 1 0 0 1 1 0 1 0 0 1 1 1 0 1 1 0 0 1]

Polynomial: `0x1f9824c51`

Bit phases:

	Bit  0: output=0x5b7eeb19 lfsr=0xec0d9011 phase=0x94c3b448
	Bit  1: output=0x59743c68 lfsr=0x1ba59f1c phase=0x38e3c503
	Bit  2: output=0x4fd28864 lfsr=0x3b3b5682 phase=0xe2ad1318
	Bit  3: output=0xedab9a64 lfsr=0x3b4a12fb phase=0xdb744292
	Bit  4: output=0x73f8f3e8 lfsr=0x1afc3f39 phase=0xfbc5d527
	Bit  5: output=0x6839dba4 lfsr=0x39bfd69a phase=0x88b0e0b2
	Bit  6: output=0x5c7f88bc lfsr=0x29653c0a phase=0x4557128b
	Bit  7: output=0x77f66878 lfsr=0x145afde1 phase=0x6a8ba0bc
	Bit  8: output=0x0a09429a lfsr=0x6fb05750 phase=0x968b4436
	Bit  9: output=0xa9be22ce lfsr=0x5cbba9eb phase=0x1e00299f
	Bit 10: output=0x52b2912c lfsr=0x27bce709 phase=0xb7e8b06c
	Bit 11: output=0x9ea9de40 lfsr=0x03a0efe4 phase=0x3a2d9498
	Bit 12: output=0x72826af4 lfsr=0x3575465b phase=0xc51d1f49
	Bit 13: output=0x4f95d750 lfsr=0x0c8f8cf7 phase=0xd981832e
	Bit 14: output=0x74c5dc00 lfsr=0x002daf36 phase=0x867d0e84
	Bit 15: output=0xe9f66bf8 lfsr=0x1521de48 phase=0xa11b6a66
	Bit 16: output=0x5e50c93c lfsr=0x286329f5 phase=0xca70e015
	Bit 17: output=0x3188cfde lfsr=0x53ae7726 phase=0x4af0d276
	Bit 18: output=0xbc8ffb78 lfsr=0x14d681db phase=0xc6befd00
	Bit 19: output=0x24354acc lfsr=0x22c02bcb phase=0xcd335754
	Bit 20: output=0x1f5257a8 lfsr=0x193673a0 phase=0x33860b90
	Bit 21: output=0xaeda76e8 lfsr=0x1a3e4e83 phase=0x117ce4b1
	Bit 22: output=0xf026aef8 lfsr=0x15e0288b phase=0xdfb1701e
	Bit 23: output=0xd352c7fc lfsr=0x2a371962 phase=0x82068f97
	Bit 24: output=0x0aaed59c lfsr=0x2e53922c phase=0xacb8ced4
	Bit 25: output=0xecab31e0 lfsr=0x0518ffdb phase=0x15f1f054
	Bit 26: output=0xa113e3c0 lfsr=0x028d4679 phase=0x30b10acf
	Bit 27: output=0xc45df514 lfsr=0x30355a71 phase=0x9d2aed1f
	Bit 28: output=0xc6747ba0 lfsr=0x06895f59 phase=0xfe1e5621
	Bit 29: output=0x22562262 lfsr=0x7a0c5531 phase=0x92475060
	Bit 30: output=0x8a2fa248 lfsr=0x1c13faca phase=0x4d6de05c
	Bit 31: output=0xb15c3fcc lfsr=0x2208e43a phase=0x2125cb9f
	Minimum distance: 21614485
	Relative minimum distance: 5.153