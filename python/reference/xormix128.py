# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix_ref

matrix = [
	[ 93,  67,  22, 113,  35],
	[ 38,  84,  91,  47,  95, 124],
	[114,  68,  23,   3,  17],
	[ 50,  29, 127,  54,  20,  39],
	[ 69,  19,   1,   7, 108],
	[ 77,  69,  43,  87,  28, 121],
	[103,  62,  50,  96, 118],
	[  6,  49, 125,  63,  46,  87],
	[ 92,   5,  45,   3,  95],
	[ 55,  37,  10, 101, 107,  84],
	[ 21,  32,  46,  19, 113],
	[116,  34,   8,  41,  47,  93],
	[ 37, 125,  38, 102,  40],
	[ 72,  89, 127,  31, 113,  51],
	[ 87,   6,  59,   3,   9],
	[ 66,   5,  52,  18,  56,  75],
	[ 28,  33,  14,  27,  98],
	[  7,  72,   9,   2,  30,  29],
	[106, 110,  40,  98,  42],
	[100,  60,  30, 105,  28,  50],
	[ 63,   5,  51,  41,  57],
	[108,  12,  14,  35,  36,  96],
	[ 56,  73,  62,  86,  26],
	[ 58,  91, 119,  44,  65,  89],
	[ 34, 123, 100, 111,  59],
	[124, 119,  72,  61,  19,  63],
	[  5,  78, 114,  27,  55],
	[ 41,  32,  54,  52,  67,  11],
	[ 33,  89,   7,  14,  71],
	[109,  17,  80,  94,  54,  11],
	[117,  29,  30,  33,   0],
	[ 31,  85, 127, 102,  96,  95],
	[ 80,  42,  82, 101,  68],
	[ 55,  85,  80,  95, 105,  70],
	[122, 116,  88,  41,  22],
	[ 97, 116,  36,  83,  82, 123],
	[ 21,  82,  54, 111, 101],
	[ 99,  76,   8,  10,  48, 126],
	[  8,  90,  48,  56, 117],
	[111, 120,  77,  53, 123,  79],
	[104,  38, 108, 106, 102],
	[ 13,  26, 118, 120,  14,  73],
	[ 24, 122,  12,   1,  65],
	[ 18,  33,  94,  76,  64,   4],
	[  9, 102,  31,  24,  86],
	[ 16,  45,  39,  31,  67, 108],
	[ 33,  58,   0,  81,  93],
	[ 63, 110,  74,  56,  47,  23],
	[ 96,  37,  32,  56,  97],
	[ 35,  18,  93,  12, 105, 121],
	[  2, 112, 117,  76,  51],
	[  6, 106, 110,  68,  13,  15],
	[ 12,  76, 107,  16, 121],
	[124,  95,  85,  28,  13,   6],
	[123,  28,   5,  61,  59],
	[ 26,  76,  30,  99,  25,  16],
	[ 66,  89, 122,  79, 103],
	[107,  15,  29,  34,  83, 116],
	[ 16,  53, 107,  98,  37],
	[ 49, 104,  94, 109, 112,  79],
	[ 12,  57,  61,  70,  20],
	[ 29,  97,  71,  78,  53,  74],
	[ 16, 108, 111,  90,   1],
	[ 59,  91, 114, 122,  50,  99],
	[113, 125,  26,  57,  51],
	[100,  85, 114,  86, 106, 121],
	[ 81,  21,  42,   9,  15],
	[ 63, 127,  45,  18,  13,  74],
	[ 53,  55,   2,  46,  84],
	[ 29,  67,  62, 125, 127,  84],
	[  8,  55,  78,  53,  41],
	[ 11,  81,  37, 125,  32,  61],
	[ 94,  82,  91,  58,  46],
	[ 43,  15, 119,  47,  87,  62],
	[126,  85,  82,  93,  90],
	[ 15,  99,  59,   4,  65,   0],
	[ 64,  17,  12,  10, 120],
	[  1,  31, 115,  45,  43,  64],
	[123,  24,   7,  66,  73],
	[103,  39,  54,  59,  74,  78],
	[ 53,  12,  57, 100, 115],
	[107,  39,  80,  75,  94,  49],
	[ 25,   1,  88, 124,  58],
	[ 75, 103,  86,  79,  88,  28],
	[ 19,  40,  88,  24, 118],
	[ 83,  77,  97,  50,  10, 118],
	[126, 112,  64, 107,  88],
	[ 83,  25,  40,  20,   2,  75],
	[ 32,  37, 111,  51,  99],
	[ 11, 120,  18,  84,  26,  52],
	[123, 101,  66,  68,   1],
	[  8,  68, 123, 116,  23, 122],
	[ 56,  31,  78,  36,  42],
	[ 38,  40,  89,   4, 111,  73],
	[ 63, 118, 109,  46,  44],
	[ 92,  53, 110,  52, 119,  40],
	[ 69,   2,  72,   3, 120],
	[ 43,  17,  14, 106, 122,  69],
	[ 70,  41,  60,  51,  13],
	[ 18,  74,  75, 100,  61,  60],
	[115,  38,  92,  65,   4],
	[ 75,  34,  44,  72,  79,  63],
	[ 57,   2,  20,  79,  27],
	[ 45,  35, 109,  49,  39,  96],
	[ 20,  90, 103,  60, 117],
	[  6,   3,  79, 115,   8,  81],
	[102,  36,  83, 112,  71],
	[ 42, 126,  62, 113,  43,  30],
	[ 50,  69,  35,  47, 113],
	[104,  23,  65,  77,  67, 117],
	[ 44,  68,   0,  80,  19],
	[ 20,  27, 114, 105, 101,  66],
	[ 43, 119, 116, 109,  21],
	[116,  70,   0, 105,  71,   4],
	[ 72,  22, 115,  43,  34],
	[ 91,  21,  45, 104,  74, 105],
	[ 58, 103,  30,  13, 108],
	[  5,  97,  71,   0,  47,   9],
	[ 22,  35, 124, 126, 120],
	[ 52,  66, 106,  11, 104,  17],
	[ 38,  64,   7, 102,  24],
	[ 10,  90,  25,  81,  92,  77],
	[ 19,  60,  87,  92,  48],
	[ 11,  95,  27,  36,  22,  98],
	[  9,  23,  81,  44,  93],
	[ 49,  73,  88,  98, 112, 121],
	[ 48,  70,  86,  23,  59],
	[ 97,  29,  48, 110,  34, 107],
]

salts = [
	0x13262f1ed94d35de5037b5ab9dbc3488, 0x7ff3ef25ad7380b8adf9a9bdbff1223e, 0x381bbba7d431439e3a7e57b7273176a3, 0x103dca29fc314d3f05e11fe401cf6fbb,
	0x9575b7768be3b6f63b37be5e9323f719, 0xb310cd417e865701852c0f137baa77c1, 0xf91ab0c9d06a6fab8f59b935b3e19ad0, 0xbb051ea62ebdb876a498e6edd1a7fff8,
	0xd4d69acbbb4ef412be6edd8b7b1da9c4, 0x58c7d8956ee996cb3201f2fcb2913077, 0x44c0eaa7acea07dc067157b612a796d0, 0x0bfadd9ea78537202f0dc6387e490584,
	0xe84ed06e8ef90d826a4794d71bfde238, 0x8333c010a7a2c1de068d13b2573889f5, 0x131b25f5290a2d7c300c62a1f3f988a7, 0x51690ae0ba825d13e93a50422bf7c93e,
	0x5401edc6eacf9376c9b1740ae1682c7c, 0x0102213a944f7a3b11412a294eaec4e3, 0xa30c5a4fca8b3b774f1f20a17431ea84, 0xb87010456ab8d88b8dd4c95dc5d17fc8,
	0x0e751da1db416c312ebdc43faa118a3d, 0xe8ebde2abd705c86d8f9fd86993a5e7b, 0x0c2437807aaa24ff76d338b2696cbd46, 0xe0cda84666200d77794f864e524e3d05,
	0x7331f65d083f981679bdb371e10deab6, 0x14e1dbdb706146c87ccd29aa9617940c, 0x3129867e0d1cae8743365f3838f1a6f2, 0x20a9e692001abc41d2675a5ef558c9ca,
	0x992ecb2546eba50e3c3a38d31856c3be, 0xf5474098a6f8e72c88a90385e1bb7ec4, 0xf4ca5329109c00d36cefa419fabae38e, 0x0e0a135ebd4ade22fa6502f6572ce3b5,
	0xb499352d4c2c6d328f36503aa9322a10, 0x658f170a3d5eb1382859bd534c03eddc, 0x301d9ba87df8d36c59a70c4f5c903b9d, 0x89d5524900fe6b6701072fd7e66b3aa3,
	0xbf53a13583b45c0c767602e169da1734, 0xc8e4c9c9ff5231667370d2ffaaf50692, 0x360f32162410c113d593ba723fc7d8c6, 0x5e6024e9ee3f909d7ea8be62f7d37e6f,
	0xb7ab9b30669a5a6070e8ebe1e1b3a93e, 0x22b34c2e328f75bdc413ba90f1784dec, 0x4c09a5bcf925c18d83718e4b5e59cb10, 0x85c76e9db31ad05530bb301a56b5218e,
	0xf37135381111fd49faa63ff210faa19e, 0xd1d1ea95a0e8c0bf3d5e8a1f3bdac15b, 0x5933613e9f3214ebd8f5cd3857a43a64, 0xd9bf1cdf18b5d798beff10e60b0f9ac6,
	0x51981d2ac6601c9d7618b748f434fe31, 0x9a69338b783383a3f77adc87e60bcd0f, 0xe0bd8f5a2afeb40288b78f95c2b1984f, 0x7e1e701939f16165359190cf59a54f04,
	0x02b67174dc3c1d518733c6cd6eb481e5, 0xe3264b5d279d0575b9ec55cb7c363c39, 0xc7feacc68d29d6fac50981d3c4088e92, 0xae5910192d2aa1f4812c455df6cf92d0,
	0x80d258457c5bc95074c8d42a5a86f753, 0x6c65832f23f43eae6ef671a872141a82, 0xb50a5ea77901f55f0434eb9ae66b5b33, 0x5e684ded016cb40d387f22aea9be95c6,
	0xafd9af4b5cf7191f1ea35cb9fd2e62f9, 0x97d615c53cd4923c614d38a4b90171b2, 0x0db87bc5c1e6728379b2d3a9b29b5521, 0xe20c664651c3d42328707a583af04239,
	0xc5fbf5c3a47655d67e027925e7675b94, 0x730e3687735b1889b88a8e07cf291032, 0xa0e7875e6c8cad2ef005cbf2adbb271c, 0xb1af2c9c8c29a4e474d2338b5bad0afb,
	0xaee9cf0e3d634e786dbe13197f40cc43, 0x17542b21cbec8d1495d843f20f9358b1, 0xbfd591a612ab72bf2e682e54723518c7, 0x923c62e69bde4f75b7b11297d6d46d4e,
	0x2a58c173ee11d4cafbc52f5cd9fc10bb, 0xc8d9279162d7730eca5dde8c906754f6, 0xecd0cfe2ef3a2b6297a49e801f6214fe, 0xc3c09bd89e26a8d21639de509e92ea9e,
	0x57960c3e5964c51b258678211c569f01, 0xf3c2b154f0073720e761fae8b3d9d4cd, 0x3696ca65addca66ffe04506afccfd23f, 0xc8282c0619a4ab4ab3bb0c8667adf5ec,
	0xe996c824b1a3b36d7bf40c8bf34821d5, 0x20c9d2c922f18772e15b109bc8816f21, 0x857e76882355a43174069f24aaef94f3, 0x65bc59d13c9f1c020606c022e177884c,
	0x6950dd6b52bccfa99b73077b4199b59c, 0x304931f308d9a27c11fb3a34ebedbe58, 0xdf182f5cab14cd39cf622a6d3bff6107, 0x65a35232d8d0dbe4790a2a7edd383fe0,
	0x47128844e1e9270bf8df480e46fb4bc6, 0xdbeaae962a0a698f5088ffd970256144, 0x8aed916e4d36e7d3441a670f9380f30d, 0xbcbfbb13f986a39653cfbf7152d255d2,
	0x16e10d8df52cc48442a5d5256969aa9a, 0x43cb709d85da0e5015a892a614986841, 0x397e57c92f9861547b24ca77b1cea27c, 0xa355f9fd7fbf38fbcc8af45404fcc6be,
	0xaa5cd73b8a0940b4fc5b3ac93926cd6a, 0x5ded207cd2e59c3da8fab36f9a21157f, 0x3a6f475c1ecb7c13d996cd4441425a97, 0x77b676851c7abda850afc4b495085f2c,
	0xf7ad24f6275633672634c1d79f45892d, 0xda03176c01e50cdfe333b2d35fa015b6, 0x2863d4577783878fd8a58035655c3deb, 0xb334f15329dccb8cd1fd224b16e58d79,
	0xfdf7d79bc286586dc82f31311f9e6fca, 0xd5ae4ce8a7ce08fcffafc51ae8a5fb93, 0x026439f83ae85ad94a127c8b01990c54, 0x7aa46106c2c9f687828e598d46c3b205,
	0x957b133698028d825c50a7eddc43a709, 0x11b01d55dd67c0c6e42ebea0b91fe54f, 0x0deea11cc253bddcc56da2d3f7a67ebc, 0xb333a13878ed6467afc644cc4a7fba8a,
	0x6fe1bd7b2bd57f1d247318da9d130d0a, 0xbabeb4db43e98bfa20a036758e06ead4, 0x9b99ae3537b38828c33f629c27654c29, 0xd6fe5e4c9f390bb6a5523bdaa7d672ce,
	0x46d6eb2ac8cf719a2f12eb3b24e43b6b, 0x2136944a515be3f2c586e97599de219a, 0x7a6982ded6aa1dfa91281fd5ec28196d, 0xea225519f1f55c7c16e4e2042546cf60,
	0x8264b4091f7515269929e1ae0304ba9e, 0x2c009fa5c7f106bbb3c1825b2df6a2f6, 0x03c6b7bc51586c46c24dabc28e5104c1, 0x96a7aabc97aeaf611bdb8ecfba049814,
	0x6e6705040215fb0cc52b1723b77d8ca7, 0x20afd57548c2a8194cae459746ef3ae2, 0xc660367182530702a8940562e769aa34, 0x426d334d0210953d4fbc5eb23baa5b89,
]

shuffle = [
	 68,  77,  52, 101, 107, 124, 117, 113,  96,  92,   7,  25,  21,  28,  60,   1,
	 17,  26,  44,  27,  59, 127,  46, 110,  83,  98,  54, 126,  29,  95,   0,  20,
	 66,  89,   9,  19,  91,  10,  58, 120,  11, 100,  49,  82,  75,  16,  36, 103,
	 62,  50,  65, 112,  24,  33,  51,  86,  40, 102,  48,  81, 125,  34,  56,  73,
	 32, 118,  78,  69,  45,   6,  93,  53, 116,  84,   3,  97,  99,  39,  70, 119,
	 72,  14,  64, 121,  76,  22, 104,  63, 106,  15,   2,  42,  41,  18, 123, 114,
	  8, 115, 108,  85,  80,  37,  35,  13,  30,  87,  79,  61,   4, 109, 111,  43,
	 67,  55,  23,  12,  74,  47, 105,  90,  94,  71, 122,  57,  31,  88,   5,  38,
]

shifts = [47, 61, 56, 62]

def next_state(state):
	return xormix_ref.next_state(matrix, salts, shuffle, shifts, state)
