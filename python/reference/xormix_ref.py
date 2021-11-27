# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

def next_state(matrix, salts, shuffle, shifts, state):
	n = len(matrix)
	assert len(salts) == n
	assert len(shuffle) == n
	assert len(shifts) == 4
	assert 2 <= len(state) <= n + 1
	
	# linear stage
	state_x = state[0]
	state_x_next = 0
	for i in range(n):
		for j in matrix[i]:
			state_x_next ^= ((state_x >> j) & 1) << i
	state[0] = state_x_next
	
	# shuffling
	mixin = []
	for s in range(len(state) - 1):
		salted = state_x ^ salts[s]
		shuffled = 0
		for i in range(n):
			j = (s + shuffle[i]) % n
			shuffled |= ((salted >> j) & 1) << i
		mixin.append(shuffled)
	
	# nonlinear stage
	for i in range(n):
		state1 = state[1]
		for s in range(len(state) - 1):
			mixup = state1 if s == len(state) - 2 else state[s + 2]
			s0 = mixup >> 0
			s1 = mixup >> shifts[0]
			s2 = mixup >> shifts[1]
			s3 = mixup >> shifts[2]
			s4 = mixup >> shifts[3]
			temp = (s0 ^ (s1 & ~s2) ^ s3 ^ s4 ^ (mixin[s] >> i)) & 1
			state[s + 1] = (temp << (n - 1)) | (state[s + 1] >> 1)
