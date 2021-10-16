# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix

matrix = [
	[ 2, 75, 41, 57, 14],
	[ 9, 13, 15, 10, 59, 88],
	[ 6, 78, 53,  3, 59],
	[92, 43, 20,  8, 38, 56],
	[38, 25, 47,  0,  7],
	[52, 18, 94, 66, 28, 13],
	[54, 14, 51, 52, 18],
	[16, 62, 64, 88, 43, 61],
	[ 0, 85, 62, 28, 23],
	[50, 25,  6, 41, 30, 95],
	[76, 95, 58, 16, 85],
	[43, 36, 45, 80, 78, 17],
	[ 1, 42, 75, 81, 59],
	[19, 56, 23, 55, 84, 79],
	[12, 46, 19,  5, 48],
	[71,  6, 59, 44, 10, 39],
	[11, 77,  4, 21, 58],
	[ 9, 44, 62, 15, 84, 40],
	[25, 93, 48, 87, 32],
	[48, 82, 45,  8, 29, 90],
	[10, 30, 59, 46, 69],
	[55, 88, 78, 53,  1, 63],
	[62, 80, 33, 37, 53],
	[ 3, 35, 34, 37,  1, 23],
	[52, 51, 86, 69, 17],
	[27, 50, 79, 83, 76, 95],
	[78, 42, 70, 57, 94],
	[87, 22, 26, 49, 84, 83],
	[94, 76, 28, 42, 14],
	[11, 22, 92, 58, 88, 16],
	[40, 77, 12, 65, 34],
	[31,  8, 21, 15, 68, 75],
	[39, 64, 90, 69, 79],
	[85, 35, 61, 90, 63, 92],
	[34, 12, 73, 57,  1],
	[79, 37, 32, 47, 66, 86],
	[43, 35, 25, 65, 72],
	[40, 24, 77, 59, 16, 50],
	[45, 20, 56, 46, 80],
	[25, 70, 64, 31, 46, 74],
	[72, 65,  2, 36, 69],
	[90,  3, 71, 86, 18, 63],
	[47,  4, 27, 24, 92],
	[48, 67, 68, 42, 89, 85],
	[10, 51, 13, 60, 89],
	[60,  7, 32, 68, 30, 71],
	[33, 19,  3, 65,  8],
	[34, 30, 86, 38, 31, 29],
	[55, 41, 26,  9,  7],
	[ 4, 53,  7, 44, 36, 24],
	[ 4,  7, 49, 93, 22],
	[ 6, 53, 66, 75, 35, 95],
	[30, 14, 24, 28, 87],
	[10, 52, 13, 11, 33, 40],
	[19,  4, 83, 32,  7],
	[85, 27, 93, 94,  7, 73],
	[68, 92, 32, 13, 10],
	[57, 90, 36, 87, 75, 54],
	[ 2, 24,  0, 38, 45],
	[21,  0, 28, 13, 53, 54],
	[40, 73, 80, 95, 46],
	[84, 43, 73, 22, 92, 38],
	[52,  1, 76, 39, 86],
	[48,  2, 86, 17, 49, 93],
	[74, 25, 69,  6, 37],
	[15, 23, 52, 77, 91, 51],
	[81, 20, 64,  5, 87],
	[51, 15, 20, 72, 39, 60],
	[43, 89, 35, 70, 37],
	[71, 40, 34, 66, 60, 14],
	[48, 32, 29, 76, 87],
	[44, 89, 19, 20,  9, 77],
	[81,  8, 75, 49, 47],
	[29, 41, 67, 12,  6, 56],
	[49, 82,  5, 17, 58],
	[78, 62, 19, 68, 63, 94],
	[18, 45, 57, 41,  1],
	[83, 58, 72, 31, 74, 63],
	[13, 79, 47, 67, 71],
	[31, 91, 69, 47, 74, 65],
	[16, 72, 81, 82, 26],
	[42, 57, 41, 88, 95, 12],
	[81, 91, 40, 11, 26],
	[50, 93, 27, 70, 77, 92],
	[80,  9, 64, 34, 70],
	[ 2, 74, 29, 83, 67, 18],
	[20, 47, 33, 60, 19],
	[17, 52, 39, 89, 67, 91],
	[54,  5, 39, 79, 77],
	[82, 21, 84, 42, 36, 66],
	[ 9, 32,  0, 11, 23],
	[ 5, 56, 61, 72, 18, 55],
	[58, 95, 86, 81, 22],
	[73, 26, 70,  3, 61, 82],
	[44,  8,  2, 50, 42],
	[55, 83,  5, 33, 16, 21],
]

salts = [
	0x6319a0b833efe6e1c2523bab, 0x6065db7e5e9528c24e41956c, 0x45405efdaa7a8343f957dbb2, 0x0e1f7d0fa053e5d590c79c4e,
	0xa5b1c14726c172f51066b415, 0xaead4a87a54e563e593aef70, 0xf85964c82d1057eacf751855, 0xc8d61c3bdd042220e6f59d5c,
	0xffdfe8c9ec04bbdf7bee652e, 0x0bb59f564d1d3cf833623b5c, 0x68ab49b831b7dc4a4b49c11d, 0xb657de372e382df2d4f33c4c,
	0x1b15b9b87e0bb24f224d200f, 0xe0592230e4f0f05e619655c0, 0x55568b9e8eb9df8518243c1e, 0x2097eb070e750e2fda153d84,
	0xa8eefca08e65f7411d8164ba, 0x89ada553c5679f8fd13e40e1, 0x2ee76cd6b4ec42c1ec2f26a4, 0x2c6c0454a632bf6b2c0f4a77,
	0x0b37c3a328d89981c733d157, 0x35dd3d4dfe6191ec2c80e292, 0x417e0444496792df5700a660, 0xca4e892f298a13178eb22a88,
	0x6b62bb76b84522e412ce68ac, 0x50401c5a2989c7eb98ab64fb, 0xafc0de3b891e7fd3e8882b5c, 0x2539fb51cfa4d3b5fd0b6e9a,
	0x67d1e7005a5054442f94ba0a, 0x5ab4670b4474e57d2914a95c, 0x0c94162c5cd979a2d0002c45, 0x62842083ccff93988a99d2a4,
	0xd9714416b2cae88fa0370fef, 0x71e565420304e2da8b9c4ea0, 0xf600635b03e92f2fb54339b7, 0x3b2b25e41fd40e07b212e026,
	0x1437b070792723e29f5da7d4, 0x14f049c34ce725aa2c490b12, 0x980a5232856ce525a0aec14c, 0x621ca5773ee005f36b66d06c,
	0x38fed51e65bc0562992c8488, 0xacb5372755de946dfd193631, 0xb2c1198a220c9f9668cc5101, 0xfb904152a0011280558611fb,
	0xced40885938f39870226cc5b, 0xdb2b3756627f87cf98d9ec8a, 0x4948ad10dbffb552f5e0efac, 0xebedd4ed7a029ae094807b62,
	0x85efd26b94b3cf95a9421cbc, 0x124a583ab57fab16980c1af0, 0x0162d2d5a8a530c7d02d3520, 0xd4bf39f96519f627fe72b19f,
	0x59b142a05f99b1fa91c8f332, 0x105feec6ab487d1fbd5a4fec, 0xe5532b05511358d1bc75473a, 0x8dfbf97fde56ad24ebcbc639,
	0xde40acfad1d7202f6ab8b81f, 0x2e921e597fb8abf6b6da65ab, 0xaa0f40d36ad7f3e4fde1f23e, 0x5d02c224218a45f4cff511f6,
	0x4b12bd11e2b967fe411d9e2d, 0xc6e89b6f342a8419d1c4e967, 0x8ce6c1f47c8cac99c26d675f, 0xa4436deb7759e3bab96783bc,
	0x9cd991a210523ae251322632, 0xef206554e9b3cc1466d55960, 0x756e211b269c1a5d49fd8319, 0xd09797bac005ff7fc38f9668,
	0x96ca13281ff64d69d6a9f493, 0x9a50ef154caa345ddd4b8448, 0x3c4c5f09a90e00465de9b33e, 0x526d1f91c85c680358a4e882,
	0x1c82cd96109c8d647b5b52c2, 0x316799a62a2b444c30435136, 0x08380ff335a17a11ab09ac47, 0xba77c19d9e6c52f50325a5fe,
	0x41c3c9dbbde1af343fd91134, 0xe0999d460fed097784e989e9, 0xa3dd3f1b7fd7e392762e4443, 0xeea1f4020b54b2e4df3ef598,
	0xbf2b253de7f82582bb31175f, 0x66b33be6f1649b539c55a908, 0x3c5cc9869dbc64772b58fd36, 0xcaaed07863593c4c06197a6c,
	0x1a90406dce189bc627cd9cba, 0x84812ab822175870f588b01e, 0x3e5e9bdd1d64b04f9d92d83b, 0x3bc6cf51e924f7c6ec628791,
	0x41cd883fb8ff53f739d3546a, 0x87477f4ae25467ff87f2efa6, 0xea009c451178d52621247482, 0xa84713d6f74b340bb2cc2fab,
	0xfa0fdf6dc5d11206f6e198a4, 0x64fd0ca64551dbecdcd28ff9, 0xc4d5c6cf20379c2bcf02bcf7, 0x1bff24a6febaa737fdefa863,
]

shuffle = [
	50, 20, 91, 59, 26,  4, 58, 25, 71, 77, 13,  2, 30, 72, 11, 15,
	45, 61, 80, 19, 33, 35, 62,  1, 74, 18, 90, 66, 67, 88, 28, 53,
	23, 94, 55, 37, 34, 24, 65, 46, 32, 84, 79, 48, 92, 57, 41, 27,
	64, 95, 70,  6, 93, 21, 76, 85, 40, 83, 56, 29, 12,  9, 68, 73,
	78, 69, 22, 47, 42, 82, 44, 54, 36,  5,  3, 63, 31, 16, 87, 38,
	10, 81, 60, 51, 43, 75,  8, 89, 39, 86, 14,  7, 52,  0, 49, 17,
]

shifts = [45, 46, 36, 43]

def next_state(state):
	return xormix.next_state(matrix, salts, shuffle, shifts, state)
