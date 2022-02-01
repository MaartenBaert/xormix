// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include <cassert>
#include <cstddef>
#include <cstdint>

#include <initializer_list>
#include <limits>
#include <type_traits>

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
	static constexpr size_t LIMB_BITS = std::numeric_limits<limb_t>::digits;
	static constexpr limb_t MASK = (N == LIMB_BITS)? -limb_t(1) : (limb_t(1) << N) - limb_t(1);
	
	static const std::initializer_list<word_t> TEST_PERIODS;
	static const matrix_t XORMIX_MATRIX;
	static const word_t XORMIX_SALTS[N * L];
	static const size_t XORMIX_SHUFFLE[N * L];
	static const size_t XORMIX_SHIFTS[4];
	
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
				bool overflow = rem >> (std::numeric_limits<size_t>::digits - 1);
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
	
	template<typename T>
	static T slice_words(const word_t *words, size_t num_words, size_t offset, size_t length) {
		constexpr size_t T_BITS = std::numeric_limits<T>::digits + std::numeric_limits<T>::is_signed;
		typedef typename std::conditional<(T_BITS > LIMB_BITS), T, limb_t>::type U;
		if(length == 0)
			return T(0);
		size_t ii = offset / N, i = offset % N;
		T result = T(words[ii / L].l[ii % L] >> i);
		for(size_t j = 1; j <= (length + N - 2) / N; ++j) {
			size_t jj = ii + j;
			result |= U(words[jj / L].[jj % L]) << (j * N - i - 1) << 1;
		}
		return result << (T_BITS - length) >> (T_BITS - length);
	}
	
};

typedef xormix<uint16_t, 16, 1> xormix16;
typedef xormix<uint32_t, 24, 1> xormix24;
typedef xormix<uint32_t, 32, 1> xormix32;
typedef xormix<uint64_t, 48, 1> xormix48;
typedef xormix<uint64_t, 64, 1> xormix64;
typedef xormix<uint64_t, 48, 2> xormix96;
typedef xormix<uint64_t, 64, 2> xormix128;
