from pylab import *
import hashlib
import math
import numpy
import scipy.stats

numpy_type = {
	8  : numpy.uint8,
	12 : numpy.uint16,
	16 : numpy.uint16,
	24 : numpy.uint32,
	32 : numpy.uint32,
	48 : numpy.uint64,
	64 : numpy.uint64,
}

def make_rng(seed_string):
	seed_hash = hashlib.sha512(seed_string).digest()
	seed_arr = numpy.frombuffer(seed_hash, dtype=numpy.uint32)
	seed_seq = numpy.random.SeedSequence(seed_arr, pool_size=16)
	return numpy.random.Generator(numpy.random.MT19937(seed_seq))

def popcount(data):
	bits = numpy.unpackbits(data.view(numpy.uint8))
	return bits.reshape(data.shape + (-1,)).sum(axis=-1, dtype=numpy.uint64)

def make_xormix_salt(n, suffix):
	rng = make_rng(b"xormix%d-salt" % (n) + suffix.encode())
	streams = n
	min_distance = {
		16: 6,
		24: 9,
		32: 11,
		48: 18,
		64: 24,
		96: 37,
		128: 51,
	}[n]
	if n > 64:
		n2 = n // 2
		salts = rng.integers(0, 2**n2, (1, 2), dtype=numpy_type[n2])
		attempts = 1
		while len(salts) < streams:
			newsalt = rng.integers(0, 2**n2, (1, 2), dtype=numpy_type[n2])
			dist = popcount(salts ^ newsalt).sum(axis=1)
			salts = concatenate((salts[dist >= min_distance], newsalt), axis=0)
			attempts += 1
		form = "0x%%0%dx" % (n // 4)
		salts = (salts.astype(object) << (n2 * arange(2, dtype=object))[None, :]).sum(axis=1)
	else:
		salts = rng.integers(0, 2**n, 1, dtype=numpy_type[n])
		attempts = 1
		while len(salts) < streams:
			newsalt = rng.integers(0, 2**n, 1, dtype=numpy_type[n])
			dist = popcount(salts ^ newsalt)
			salts = concatenate((salts[dist >= min_distance], newsalt))
			attempts += 1
		form = "0x%%0%dx" % (n // 4)
		salts = salts.astype(object)
	return salts

def make_xormix_shuffle(n, suffix):
	rng = make_rng(b"xormix%d-shuffle" % (n) + suffix.encode())
	max_match = {
		16: 2,
		24: 3,
		32: 3,
		48: 4,
		64: 4,
		96: 5,
		128: 5,
	}[n]
	ii = numpy.arange(n)
	while True:
		perm = rng.permutation(n)
		circ = scipy.linalg.circulant(perm)
		shift = (perm[:, None] + ii[None, :]) % n
		match = (circ[:, :, None] == shift[:, None, :]).sum(axis=0)[1:, 1:]
		if match.max() <= max_match:
			break
	return perm

def print_salts(name, n, salts):
	form = "0x%%0%dx" % (n // 4)
	print(name + ' = [')
	for i in range(0, len(salts), 4):
		print('\t' + ', '.join(form % x for x in salts[i : i + 4]) + ',')
	print(']')

def print_shuffle(name, n, shuffle):
	print(name + ' = [')
	for i in range(0, len(shuffle), 16):
		print('\t' + ', '.join(f'{x:{len(str(n-1))}d}' for x in shuffle[i : i + 16]) + ',')
	print(']')

if __name__ == "__main__":

	if len(sys.argv) != 2:
		print('Usage: generate_matrix.py <wordsize>')
		sys.exit(1)

	n = int(sys.argv[1])
	salts = make_xormix_salt(n, '')
	shuffle = make_xormix_shuffle(n, '')
	salts_fs = make_xormix_salt(n, 'fs')
	shuffle_fs = make_xormix_shuffle(n, 'fs')

	print(f'xormix{n}:')
	print()
	print_salts('salts', n, salts)
	print()
	print_shuffle('shuffle', n, shuffle)
	print()
	print_salts('salts_fs', n, salts_fs)
	print()
	print_shuffle('shuffle_fs', n, shuffle_fs)
	print()
