# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import xormix16
import xormix24
import xormix32
import xormix48
import xormix64
import xormix96
import xormix128

# all xormix modules in a convenient dictionary
modules = {
	16: xormix16,
	24: xormix24,
	32: xormix32,
	48: xormix48,
	64: xormix64,
	96: xormix96,
	128: xormix128,
}

# the prime factors of 2^N - 1, which are hard to calculate in python
factors = {
	16: [3, 5, 17, 257],
	24: [3, 3, 5, 7, 13, 17, 241],
	32: [3, 5, 17, 257, 65537],
	48: [3, 3, 5, 7, 13, 17, 97, 241, 257, 673],
	64: [3, 5, 17, 257, 641, 65537, 6700417],
	96: [3, 3, 5, 7, 13, 17, 97, 193, 241, 257, 673, 65537, 22253377],
	128: [3, 5, 17, 257, 641, 65537, 274177, 6700417, 67280421310721],
}

# the same prime factors but without duplicates
unique_factors = {
	16: [3, 5, 17, 257],
	24: [3, 5, 7, 13, 17, 241],
	32: [3, 5, 17, 257, 65537],
	48: [3, 5, 7, 13, 17, 97, 241, 257, 673],
	64: [3, 5, 17, 257, 641, 65537, 6700417],
	96: [3, 5, 7, 13, 17, 97, 193, 241, 257, 673, 65537, 22253377],
	128: [3, 5, 17, 257, 641, 65537, 274177, 6700417, 67280421310721],
}
