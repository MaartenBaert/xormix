# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import math
import numpy
import random
import scipy.stats
import sys

# xormix_avalanche is a C++ module that must be compiled first
import xormix_avalanche

def avalanche_test(n, rounds):
	
	rng = random.Random(0x13c97d5ce203d7c0)
	
	initial_trials = 10000
	subtests = 8
	min_observ = 100
	min_pvalue = 1e-6
	
	n2 = n // 2
	mask = (1 << n2) - 1
	distribution = scipy.stats.binom.pmf(numpy.arange(n + 1), n, 0.5)
	distribution[0] = 0
	distribution /= distribution.sum()
	
	reorder = [
		[0, 1, 2, 3],
		[0, 2, 1, 3],
		[0, 3, 1, 2],
		[1, 2, 0, 3],
		[1, 3, 0, 2],
		[2, 3, 0, 1],
	]
	
	print(f'Starting avalanche test for xormix{n} with {rounds} rounds ...')
	
	candidates = []
	for sh0 in range(1, n2 - 2):
		for sh1 in range(sh0 + 1, n2 - 1):
			for sh2 in range(sh1 + 1, n2):
				for sh3 in range(sh2 + 1, n2 + 1):
					for rr in reorder:
						candidates.append({
							'shifts': numpy.array([sh0, sh1, sh2, sh3])[rr],
							'counts': None,
							'pmin': 0.0,
							'pmean': 0.0,
						})
	
	trials = initial_trials
	total_trials = 0
	while True:
		total_trials += trials
		if total_trials < 2**16:
			count_type = numpy.uint16
		elif total_trials < 2**32:
			count_type = numpy.uint32
		else:
			count_type = numpy.uint64
		sl1 = max(1, numpy.searchsorted(distribution, min_observ / total_trials)) + 1
		sl2 = n - sl1 + 1
		print(f'Keeping {sl2 - sl1} out of {len(distribution)} bins')
		grouped_distribution = numpy.concatenate((
			distribution[: sl1, None].sum(axis=0),
			distribution[sl1 : sl2],
			distribution[sl2 :, None].sum(axis=0),
		))
		candidates_new = []
		for (i, candidate) in enumerate(candidates):
			print(f'Evaluating {i} / {len(candidates)} -> {len(candidates_new)}', end='\r', flush=True)
			counts = candidate['counts']
			if counts is None:
				counts = numpy.zeros((subtests, n + 1), dtype=count_type)
			else:
				counts = counts.astype(count_type)
			for j in range(subtests):
				bit = n * j // subtests
				counts[j] += xormix_avalanche.test(n, trials, bit, candidate['shifts'], rounds, rng.getrandbits(64))
			grouped_counts = numpy.concatenate((
				counts[:, : sl1, None].sum(axis=1),
				counts[:, sl1 : sl2],
				counts[:, sl2 :, None].sum(axis=1),
			), axis=1)
			(r, p) = scipy.stats.chisquare(grouped_counts, grouped_distribution * total_trials, axis=1)
			pmean = 10**numpy.log10(numpy.maximum(1e-100, p)).mean()
			if pmean > min_pvalue:
				candidate['counts'] = counts
				candidate['pmin'] = p.min()
				candidate['pmean'] = pmean
				candidates_new.append(candidate)
			else:
				candidate['counts'] = None # to release memory
		print(f'Evaluating {len(candidates)} / {len(candidates)} -> {len(candidates_new)}')
		if len(candidates_new) == 0:
			break
		candidates = candidates_new
		candidates.sort(key=lambda candidate: candidate['pmean'], reverse=True)
		top = min(10, len(candidates))
		print(f'Top {top} out of {len(candidates)} (with {total_trials} trials):')
		for i in range(top):
			candidate = candidates[i]
			shifts = candidate['shifts']
			pmin = candidate['pmin']
			pmean = candidate['pmean']
			bar = '#' * round(-5 * math.log10(max(min_pvalue, candidate['pmean'])))
			print(f'  {i + 1:2}.  [{shifts[0]:2} {shifts[1]:2} {shifts[2]:2} {shifts[3]:2}]  pmin={pmin:6e} pmean={pmean:6e}  {bar}')
		trials = trials * 5 // 4
	
	shifts = candidates[0]['shifts']
	print(f'Completed avalanche test for xormix{n}')
	print(f'Best result: [{shifts[0]:2} {shifts[1]:2} {shifts[2]:2} {shifts[3]:2}] ({rounds} rounds, {total_trials} trials)')
	print()
	with open('avalanche-results.txt', 'a') as f:
		f.write(f'avalanche_test({n}, {rounds}): [{shifts[0]:2} {shifts[1]:2} {shifts[2]:2} {shifts[3]:2}] ({rounds} rounds, {total_trials} trials)\n')

if len(sys.argv) != 3:
	print('Usage: avalanche.py <wordsize> <rounds>')
	sys.exit(1)

avalanche_test(int(sys.argv[1]), int(sys.argv[2]))

#for rounds in [6, 7, 8]:
	#avalanche_test(16, rounds)
#for rounds in [6, 7, 8]:
	#avalanche_test(24, rounds)
#for rounds in [7, 8, 9]:
	#avalanche_test(32, rounds)
#for rounds in [7, 8, 9]:
	#avalanche_test(48, rounds)
#for rounds in [8, 9, 10]:
	#avalanche_test(64, rounds)
#for rounds in [8, 9, 10]:
	#avalanche_test(96, rounds)
#for rounds in [9, 10, 11]:
	#avalanche_test(128, rounds)

#avalanche_test(16, 8)
# Best result: [ 1  8  5  6] (7 rounds, 20637817 trials)
# Best result: [ 4  8  5  7] (8 rounds, 918237815 trials)

#avalanche_test(24, 8)
# Best result: [ 7 12  9 10] (7 rounds, 10547057 trials)
# Best result: [ 8 12  9 11] (8 rounds, 734582264 trials)

#avalanche_test(32, 9)
# Best result: [ 7 16 10 14] (8 rounds, 154021496 trials)
# Best result: [ 6 16  9 15] (9 rounds, 243066055326 trials)

#avalanche_test(48, 9)
# Best result: [14 22 21 23] (8 rounds, 10547057 trials)
# Best result: [19 21 15 22] (9 rounds, 16703334963 trials)

#avalanche_test(64, 10)
# Best result: [27 30 23 29] (9 rounds, 154021496 trials)
# Best result: [28 31 24 30] (10 rounds, 155562261043 trials)

#avalanche_test(96, 10)
# Best result: [39 46 29 47] (9 rounds, 542046 trials)
# Best result: [42 46 35 43] (10 rounds, 470118270 trials)

#avalanche_test(128, 11)
# Best result: [56 61 47 59] (10 rounds, 8429651 trials)
# Best result: [47 61 56 62] (11 rounds, 3502911683 trials)
