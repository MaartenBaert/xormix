// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include <cassert>
#include <cstddef>
#include <cstdint>

#include <initializer_list>

// T = limb type
// N = bits per limb
// L = number of limbs
template<typename limb_t, size_t N, size_t L>
struct xormix {
	
	struct word_t {
		limb_t l[L];
	};
	struct matrix_t {
		word_t w[N][L];
	};
	
	static constexpr size_t N_ = N;
	static constexpr size_t L_ = L;
	static constexpr size_t WORD_BYTES = N * L / 8;
	static constexpr size_t LIMB_BITS = 8 * sizeof(limb_t);
	static constexpr limb_t MASK = (N == LIMB_BITS)? -limb_t(1) : (limb_t(1) << N) - limb_t(1);
	
	static const std::initializer_list<word_t> TEST_PERIODS;
	static const matrix_t XORMIX_MATRIX, XORMIX_MATRIX_RA;
	static const word_t XORMIX_SALTS[N * L];
	static const size_t XORMIX_SHUFFLE[N * L], XORMIX_SHUFFLE_RA[N * L];
	static const size_t XORMIX_SHIFTS[4], XORMIX_SHIFTS_RA[4];
	
	static const size_t XORMIX_SHUFFLE_EXTRA[6][N * L];
	
	static const uint8_t XORMIX_XORTAPS[1024][8];
	
	static bool word_equal(word_t a, word_t b) {
		for(size_t ii = 0; ii < L; ++ii) {
			if(a.l[ii] != b.l[ii])
				return false;
		}
		return true;
	}
	
	// returns (2**(N * L) - 1) / div
	static word_t divide_period(size_t div) {
		word_t res = {};
		size_t rem = 0;
		for(size_t ii = L; ii-- > 0; ) {
			for(size_t i = N; i-- > 0; ) {
				bool overflow = rem >> (8 * sizeof(size_t) - 1);
				rem = (rem << 1) | 1;
				if(overflow || rem >= div) {
					rem -= div;
					res.l[ii] |= limb_t(1) << i;
				}
			}
		}
		return res;
	}
	
	static bool matrix_equal(const matrix_t &a, const matrix_t &b) {
		for(size_t j = 0; j < N; ++j) {
			for(size_t jj = 0; jj < L; ++jj) {
				if(!word_equal(a.w[j][jj], b.w[j][jj]))
					return false;
			}
		}
		return true;
	}
	
	static matrix_t matrix_identity() {
		matrix_t res;
		for(size_t j = 0; j < N; ++j) {
			for(size_t jj = 0; jj < L; ++jj) {
				for(size_t ii = 0; ii < L; ++ii) {
					res.w[j][jj].l[ii] = limb_t(ii == jj) << j;
				}
			}
		}
		return res;
	}
	
	static word_t matrix_vector_product(const matrix_t &mat, word_t vec) {
		word_t res = {};
		for(size_t j = 0; j < N; ++j) {
			for(size_t jj = 0; jj < L; ++jj) {
				limb_t bit = -((vec.l[jj] >> j) & 1);
				for(size_t ii = 0; ii < L; ++ii) {
					res.l[ii] ^= mat.w[j][jj].l[ii] & bit;
				}
			}
		}
		return res;
	}
	
	static matrix_t matrix_product(const matrix_t &a, const matrix_t &b) {
		matrix_t res;
		for(size_t j = 0; j < N; ++j) {
			for(size_t jj = 0; jj < L; ++jj) {
				res.w[j][jj] = matrix_vector_product(a, b.w[j][jj]);
			}
		}
		return res;
	}
	
	static matrix_t matrix_power(const matrix_t &mat, word_t pow) {
		matrix_t res = matrix_identity();
		matrix_t sqr = mat;
		for(size_t ii = 0; ii < L; ++ii) {
			for(size_t i = 0; i < N; ++i) {
				if((pow.l[ii] >> i) & 1) {
					res = matrix_product(res, sqr);
				}
				sqr = matrix_product(sqr, sqr);
			}
		}
		return res;
	}
	
	static word_t shuffle_word(word_t a, size_t shift, const size_t shuffle[N * L]) {
		word_t res = {};
		for(size_t ii = 0; ii < L; ++ii) {
			for(size_t i = 0; i < N; ++i) {
				size_t k = shift + shuffle[ii * N + i];
				size_t jj = (k / N) % L, j = k % N;
				limb_t bit = (a.l[jj] >> j) & 1;
				res.l[ii] |= bit << i;
			}
		}
		return res;
	}
	
	static limb_t right_shift(word_t a, size_t k) {
		if(L == 1) {
			return a.l[0] >> k;
		} else {
			size_t ii = k / N, i = k % N;
			return (a.l[ii] >> i) | (a.l[ii + 1] << (N - i - 1) << 1);
		}
	}
	
	static void mix_halfword(word_t &state, word_t &mixin, word_t mixup, const size_t *shifts) {
		if(L == 1) {
			limb_t s0 = mixup.l[0];
			limb_t s1 = right_shift(mixup, shifts[0]);
			limb_t s2 = right_shift(mixup, shifts[1]);
			limb_t s3 = right_shift(mixup, shifts[2]);
			limb_t s4 = right_shift(mixup, shifts[3]);
			limb_t s5 = mixin.l[0];
			limb_t temp = s0 ^ (s1 & ~s2) ^ s3 ^ s4 ^ s5;
			state.l[0] = ((temp << (N / 2)) | (state.l[0] >> (N / 2))) & MASK;
			mixin.l[0] >>= N / 2;
			mixup.l[0] >>= N / 2;
		} else {
			for(size_t ii = 0; ii < L / 2; ++ii) {
				limb_t s0 = mixup.l[0];
				limb_t s1 = right_shift(mixup, shifts[0]);
				limb_t s2 = right_shift(mixup, shifts[1]);
				limb_t s3 = right_shift(mixup, shifts[2]);
				limb_t s4 = right_shift(mixup, shifts[3]);
				limb_t s5 = mixin.l[0];
				for(size_t jj = 0; jj < L - 1; ++jj) {
					state.l[jj] = state.l[jj + 1];
					mixin.l[jj] = mixin.l[jj + 1];
					mixup.l[jj] = mixup.l[jj + 1];
				}
				state.l[L - 1] = (s0 ^ (s1 & ~s2) ^ s3 ^ s4 ^ s5) & MASK;
			}
		}
	}
	
	static void mix_halfword_ra(word_t &state, word_t &mixin, word_t mixup, const size_t *shifts) {
		if(L == 1) {
			limb_t s0 = mixup.l[0];
			limb_t s1 = right_shift(mixup, shifts[0]);
			limb_t s2 = right_shift(mixup, shifts[1]);
			limb_t s3 = right_shift(mixup, shifts[2]);
			limb_t s4 = right_shift(mixup, shifts[3]);
			limb_t s5 = mixin.l[0];
			limb_t temp = s0 ^ (s1 & ~s2) ^ (s3 & ~s4) ^ s5;
			state.l[0] = ((temp << (N / 2)) | (state.l[0] >> (N / 2))) & MASK;
			mixin.l[0] >>= N / 2;
			mixup.l[0] >>= N / 2;
		} else {
			for(size_t ii = 0; ii < L / 2; ++ii) {
				limb_t s0 = mixup.l[0];
				limb_t s1 = right_shift(mixup, shifts[0]);
				limb_t s2 = right_shift(mixup, shifts[1]);
				limb_t s3 = right_shift(mixup, shifts[2]);
				limb_t s4 = right_shift(mixup, shifts[3]);
				limb_t s5 = mixin.l[0];
				for(size_t jj = 0; jj < L - 1; ++jj) {
					state.l[jj] = state.l[jj + 1];
					mixin.l[jj] = mixin.l[jj + 1];
					mixup.l[jj] = mixup.l[jj + 1];
				}
				state.l[L - 1] = (s0 ^ (s1 & ~s2) ^ (s3 & ~s4) ^ s5) & MASK;
			}
		}
	}
	
	static void next(word_t *state, size_t streams) {
		word_t state0 = state[0];
		state[0] = matrix_vector_product(XORMIX_MATRIX, state0);
		word_t mixin[N * L];
		for(size_t s = 0; s < streams; ++s) {
			word_t salted;
			for(size_t ii = 0; ii < L; ++ii) {
				salted.l[ii] = state0.l[ii] ^ XORMIX_SALTS[s].l[ii];
			}
			mixin[s] = shuffle_word(salted, s, XORMIX_SHUFFLE);
		}
		for(size_t h = 0; h < 2; ++h) {
			word_t state1 = state[1];
			for(size_t s = 0; s < streams; ++s) {
				word_t mixup = (s == streams - 1)? state1 : state[s + 2];
				mix_halfword(state[s + 1], mixin[s], mixup, XORMIX_SHIFTS);
			}
		}
		/*word_t state1 = state[1];
		for(size_t s = 0; s < streams; ++s) {
			word_t mixup = (s == streams - 1)? state1 : state[s + 2];
			state[s + 1] = matrix_vector_product(XORMIX_MATRIX2, mixup);
			for(size_t ii = 0; ii < L; ++ii) {
				state[s + 1].l[ii] ^= mixin[s].l[ii];
			}
		}*/
		/*word_t zero = {};
		for(size_t s = 0; s < streams; ++s) {
			state[s + 1] = mixin[s];
		}
		for(size_t h = 0; h < 3; ++h) {
			word_t state1 = state[1];
			for(size_t s = 0; s < streams; ++s) {
				word_t mixup = (s == streams - 1)? state1 : state[s + 2];
				mix_halfword(state[s + 1], zero, mixup, XORMIX_SHIFTS);
			}
		}*/
	}
	
	static limb_t right_rotate(word_t a, size_t k) {
		size_t ii = k / N, i = k % N;
		return (a.l[ii] >> i) | (a.l[(ii + 1) % L] << (N - i - 1) << 1);
	}
	
	static void next_ra(word_t *state, word_t *output, size_t streams) {
		// attempt 1
		/*for(size_t s = 0; s < streams; ++s) {
			word_t salted;
			for(size_t ii = 0; ii < L; ++ii) {
				salted.l[ii] = state0.l[ii] ^ XORMIX_SALTS[s].l[ii];
			}
			mixin[s] = shuffle_word(salted, s, XORMIX_SHUFFLE);
		}
		for(size_t s = 0; s < streams; ++s) {
			for(size_t ii = 0; ii < L; ++ii) {
				output[s].l[ii] = state1.l[ii] ^ mixin[s].l[ii];
			}
		}
		word_t zero = {};
		for(size_t h = 0; h < 2; ++h) {
			word_t output0 = output[0];
			for(size_t s = 0; s < streams; ++s) {
				word_t mixup = (s == streams - 1)? output0 : output[s + 1];
				mix_halfword(output[s], zero, mixup, XORMIX_SHIFTS);
			}
		}*/
		// attempt 2
		/*word_t state0 = state[0], state1 = state[1];
		state[0] = matrix_vector_product(XORMIX_MATRIX, state0);
		state[1] = matrix_vector_product(XORMIX_MATRIX_RA, state1);
		word_t mixin[N * L];
		for(size_t s = 0; s < streams; ++s) {
			word_t salted;
			for(size_t ii = 0; ii < L; ++ii) {
				salted.l[ii] = state0.l[ii] ^ XORMIX_SALTS[s].l[ii];
			}
			output[s] = shuffle_word(salted, s, XORMIX_SHUFFLE);
			mixin[s] = state1;
		}
		for(size_t h = 0; h < 2; ++h) {
			word_t output0 = output[0];
			for(size_t s = 0; s < streams; ++s) {
				word_t mixup = (s == streams - 1)? output0 : output[s + 1];
				mix_halfword(output[s], mixin[s], mixup, XORMIX_SHIFTS);
			}
		}*/
		// attempt 3
		/*word_t state0 = state[0], state1 = state[1];
		state[0] = matrix_vector_product(XORMIX_MATRIX, state0);
		state[1] = matrix_vector_product(XORMIX_MATRIX_RA, state1);
		word_t mixin[N * L];
		for(size_t s = 0; s < streams; ++s) {
			word_t salted;
			for(size_t ii = 0; ii < L; ++ii) {
				salted.l[ii] = state0.l[ii] ^ XORMIX_SALTS[s].l[ii];
			}
			mixin[s] = shuffle_word(salted, s, XORMIX_SHUFFLE_RA);
		}
		uint64_t sbox = 0xbc9c8c0277f91175;
		for(size_t s = 0; s < streams; ++s) {
			for(size_t ii = 0; ii < L; ++ii) {
				limb_t s0 = right_rotate(mixin[s], XORMIX_SHIFTS_RA[0]);
				limb_t s1 = right_rotate(mixin[s], XORMIX_SHIFTS_RA[1]);
				limb_t s2 = mixin[s].l[0];
				limb_t s3 = right_rotate(state1, XORMIX_SHIFTS_RA[2]);
				limb_t s4 = right_rotate(state1, XORMIX_SHIFTS_RA[3]);
				limb_t s5 = state1.l[0];
				//output[s].l[ii] = ((s0 & s2) ^ (s1 | s2) ^ (s3 & s5) ^ (s4 | s5)) & MASK;
				//output[s].l[ii] = ((s0 & s3) ^ (s1 | s4) ^ (s2 ^ s5)) & MASK;
				output[s].l[ii] = 0;
				for(size_t i = 0; i < N; ++i) {
					uint64_t p = (
						(((s0 >> i) & 1) << 0) |
						(((s1 >> i) & 1) << 1) |
						(((s2 >> i) & 1) << 2) |
						(((s3 >> i) & 1) << 3) |
						(((s4 >> i) & 1) << 4) |
						(((s5 >> i) & 1) << 5));
					output[s].l[ii] |= ((sbox >> p) & 1) << i;
				}
			}
		}*/
		// attempt 4
		/*word_t state0 = state[0], state1 = state[1];
		state[0] = matrix_vector_product(XORMIX_MATRIX, state0);
		state[1] = matrix_vector_product(XORMIX_MATRIX_RA, state1);
		word_t mixin0[N * L], mixin1[N * L];
		for(size_t s = 0; s < streams; ++s) {
			word_t salted0, salted1;
			for(size_t ii = 0; ii < L; ++ii) {
				salted0.l[ii] = state0.l[ii] ^ XORMIX_SALTS[s].l[ii];
				salted1.l[ii] = state1.l[ii] ^ XORMIX_SALTS[s].l[ii];
			}
			mixin0[s] = shuffle_word(salted0, s, XORMIX_SHUFFLE);
			mixin1[s] = shuffle_word(salted1, 2 * s + s / (N * L / 2), XORMIX_SHUFFLE_RA);
		}
		for(size_t s = 0; s < streams; ++s) {
			for(size_t ii = 0; ii < L; ++ii) {
				limb_t s0 = right_rotate(mixin0[s], XORMIX_SHIFTS_RA[0]);
				limb_t s1 = right_rotate(mixin0[s], XORMIX_SHIFTS_RA[1]);
				limb_t s2 = right_rotate(mixin0[s], 0);
				limb_t s3 = right_rotate(mixin1[s], XORMIX_SHIFTS_RA[2]);
				limb_t s4 = right_rotate(mixin1[s], XORMIX_SHIFTS_RA[3]);
				limb_t s5 = right_rotate(mixin1[s], 0);
				//output[s].l[ii] = ((s0 & s5) ^ (s1 | s5) ^ (s3 & s2) ^ (s4 | s2)) & MASK;
				//output[s].l[ii] = ((s0 & s5) ^ (s1 & ~s5) ^ (s3 & s2) ^ (s4 & ~s2)) & MASK;
				//output[s].l[ii] = ((s0 & s5) ^ (s1) ^ (s3 | s2) ^ (s4)) & MASK;
				output[s].l[ii] = ((s0 & s3) ^ (s1 | s4) ^ (s2 ^ s5)) & MASK;
				//output[s].l[ii] = ((s0 ^ s3) ^ (s1 ^ s4) ^ (s2 ^ s5)) & MASK;
				output[s] = matrix_vector_product(XORMIX_MATRIX, output[s]);
			}
		}*/
		// attempt 5
		/*word_t state0 = state[0], state1 = state[1], state2 = state[2];
		state[0] = matrix_vector_product(XORMIX_MATRIX, state0);
		state[1] = matrix_vector_product(XORMIX_MATRIX_RA, state1);
		state[2] = matrix_vector_product(XORMIX_MATRIX_RA, state2);
		word_t mixin0[N * L], mixin1[N * L], mixin2[N * L];
		for(size_t s = 0; s < streams; ++s) {
			word_t salted0, salted1, salted2;
			for(size_t ii = 0; ii < L; ++ii) {
				salted0.l[ii] = state0.l[ii] ^ XORMIX_SALTS[s].l[ii];
				salted1.l[ii] = state1.l[ii] ^ XORMIX_SALTS[s].l[ii];
				salted2.l[ii] = state2.l[ii] ^ XORMIX_SALTS[s].l[ii];
			}
			mixin0[s] = shuffle_word(salted0, s, XORMIX_SHUFFLE);
			mixin1[s] = shuffle_word(salted1, s, XORMIX_SHUFFLE_RA); // 2 * s + s / (N * L / 2)
			mixin2[s] = shuffle_word(salted2, s, XORMIX_SHUFFLE_RA); // 2 * s + s / (N * L / 2)
		}
		for(size_t s = 0; s < streams; ++s) {
			output[s] = mixin0[s];
		}
		for(size_t h = 0; h < 3; ++h) {
			word_t output0 = output[0];
			for(size_t s = 0; s < streams; ++s) {
				word_t mixup = (s == streams - 1)? output0 : output[s + 1];
				mix_halfword(output[s], (h < 2)? mixin1[s] : mixin2[s], mixup, XORMIX_SHIFTS);
			}
		}*/
		// attempt 6
		/*word_t state0 = state[0], state1 = state[1];
		state[0] = matrix_vector_product(XORMIX_MATRIX, state0);
		state[1] = matrix_vector_product(XORMIX_MATRIX_RA, state1);
		word_t mixin[6][N * L];
		for(size_t s = 0; s < streams; ++s) {
			word_t salted[6];
			for(size_t ii = 0; ii < L; ++ii) {
				for(size_t k = 0; k < 3; ++k) {
					salted[k].l[ii] = state0.l[ii] ^ XORMIX_SALTS[s].l[ii];
				}
				for(size_t k = 3; k < 6; ++k) {
					salted[k].l[ii] = state1.l[ii] ^ XORMIX_SALTS[s].l[ii];
				}
			}
			for(size_t k = 0; k < 6; ++k) {
				mixin[k][s] = shuffle_word(salted[k], s, XORMIX_SHUFFLE_EXTRA[k]);
			}
		}
		for(size_t s = 0; s < streams; ++s) {
			for(size_t ii = 0; ii < L; ++ii) {
				limb_t s0 = mixin[0][s].l[ii];
				limb_t s1 = mixin[1][s].l[ii];
				limb_t s2 = mixin[2][s].l[ii];
				limb_t s3 = mixin[3][s].l[ii];
				limb_t s4 = mixin[4][s].l[ii];
				limb_t s5 = mixin[5][s].l[ii];
				output[s].l[ii] = ((s0 & s3) ^ (s1 | s4) ^ (s2 ^ s5)) & MASK;
			}
			output[s] = matrix_vector_product(XORMIX_MATRIX, output[s]);
		}*/
		// attempt 7
		word_t state0 = state[0];
		state[0] = matrix_vector_product(XORMIX_MATRIX, state0);
		for(size_t s = 0; s < streams; ++s) {
			for(size_t ii = 0; ii < L; ++ii) {
				output[s].l[ii] = 0;
				for(size_t i = 0; i < N; ++i) {
					size_t r = (s * L * N + ii * N + i) % 1024;
					limb_t res = 0;
					for(size_t k = 0; k < 6; ++k) {
						size_t t = XORMIX_XORTAPS[r][k] % (L * N);
						res ^= (state0.l[t / N] >> (t % N)) & 1;
					}
					output[s].l[ii] |= res << i;
				}
			}
		}
	}
	
	static uint8_t* pack_words(uint8_t *bytes, const word_t *words, size_t num_words) {
		for(size_t w = 0; w < num_words; ++w) {
			word_t word = words[w];
			for(size_t ii = 0; ii < L; ++ii) {
				limb_t limb = word.l[ii];
				for(size_t i = 0; i < N; i += 8) {
					*(bytes++) = uint8_t(limb >> i);
				}
			}
		}
		return bytes;
	}
	
	static const uint8_t* unpack_words(const uint8_t *bytes, word_t *words, size_t num_words) {
		for(size_t w = 0; w < num_words; ++w) {
			word_t word = {};
			for(size_t ii = 0; ii < L; ++ii) {
				limb_t limb = 0;
				for(size_t i = 0; i < N; i += 8) {
					limb |= limb_t(*(bytes++)) << i;
				}
				word.l[ii] = limb;
			}
			words[w] = word;
		}
		return bytes;
	}
	
};

typedef xormix<uint16_t, 16, 1> xormix16;
typedef xormix<uint32_t, 24, 1> xormix24;
typedef xormix<uint32_t, 32, 1> xormix32;
typedef xormix<uint64_t, 48, 1> xormix48;
typedef xormix<uint64_t, 64, 1> xormix64;
typedef xormix<uint64_t, 48, 2> xormix96;
typedef xormix<uint64_t, 64, 2> xormix128;
