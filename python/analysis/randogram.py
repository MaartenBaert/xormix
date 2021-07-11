# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

from pylab import *

import random

import xormix16
import xormix24
import xormix32
import xormix48
import xormix64
import xormix96
import xormix128

test_bits = 8
test_streams = 1
test_outputs = 2**(2 * test_bits)

modules = {
	16: xormix16,
	24: xormix24,
	32: xormix32,
	48: xormix48,
	64: xormix64,
	96: xormix96,
	128: xormix128,
}

def make_randogram(n):
	state = [random.getrandbits(n) for i in range(test_streams + 1)]
	counters = zeros((2**test_bits, 2**test_bits), dtype=uint32)
	for i in range(test_outputs):
		px = state[1] & ((1 << test_bits) - 1)
		modules[n].next_state(state)
		py = state[1] & ((1 << test_bits) - 1)
		counters[px, py] += 1
	imshow((0.5**counters)[..., None].repeat(3, axis=2))

close('all')

figure('Randogram', figsize=(12, 12))

for (i, n) in enumerate([16, 24, 32, 48]):
	subplot(2, 2, i + 1)
	make_randogram(n)
	title(f'xormix{n}')

tight_layout()
show()
