// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include <cassert>
#include <cstddef>
#include <cstdint>

#include <algorithm>
#include <initializer_list>
#include <limits>
#include <type_traits>

// define loop unrolling depending on the compiler
// based on https://stackoverflow.com/questions/63404539/portable-loop-unrolling-with-template-parameter-in-c-with-gcc-icc
#define TO_STRING_HELPER(X) #X
#define TO_STRING(X) TO_STRING_HELPER(X)
#if defined(__ICC) || defined(__ICL)
#define PRAGMA_UNROLL(n) _Pragma(TO_STRING(unroll (n)))
#elif defined(__clang__)
#define PRAGMA_UNROLL(n) _Pragma(TO_STRING(unroll (n)))
#elif defined(__GNUC__) && !defined(__clang__)
#define PRAGMA_UNROLL(n) _Pragma(TO_STRING(GCC unroll (n)))
#else
#define PRAGMA_UNROLL(n)
#endif

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
	static constexpr limb_t MASK = (limb_t(2) << (N - 1)) - 1;
	
	static const size_t REVISION;
	static const std::initializer_list<word_t> TEST_PERIODS;
	static const matrix_t XORMIX_MATRIX, XORMIX_MATRIX_INV;
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
		PRAGMA_UNROLL(64)
		for(size_t j = 0; j < N; ++j) {
			PRAGMA_UNROLL(64)
			for(size_t jj = 0; jj < L; ++jj) {
				limb_t bit = -((vec.l[jj] >> j) & 1);
				PRAGMA_UNROLL(64)
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
	
	static word_t xor_word(word_t a, word_t b) {
		word_t res;
		PRAGMA_UNROLL(64)
		for(size_t ii = 0; ii < L; ++ii) {
			res.l[ii] = a.l[ii] ^ b.l[ii];
		}
		return res;
	}
	
	static word_t right_rotate_word(word_t a, size_t k) {
		word_t res;
		if(L == 1) {
			res.l[0] = (a.l[0] >> k) | (a.l[0] << (N - k - 1) << 1);
		} else {
			size_t ii = k / N, i = k % N;
			PRAGMA_UNROLL(64)
			for(size_t jj = 0; jj < L; ++jj) {
				res.l[jj] = (a.l[(ii + jj) % L] >> i) | (a.l[(ii + jj + 1) % L] << (N - i - 1) << 1);
			}
		}
		return res;
	}
	
	static limb_t right_shift_limb(word_t a, size_t k) {
		assert(k < N * L);
		if(L == 1) {
			return a.l[0] >> k;
		} else {
			size_t ii = k / N, i = k % N;
			return (a.l[ii] >> i) | (a.l[ii + 1] << (N - i - 1) << 1);
		}
	}
	
	static word_t shuffle_word(word_t a, const size_t shuffle[N * L]) {
		word_t res = {};
		PRAGMA_UNROLL(64)
		for(size_t ii = 0; ii < L; ++ii) {
			PRAGMA_UNROLL(64)
			for(size_t i = 0; i < N; ++i) {
				size_t k = shuffle[ii * N + i];
				size_t jj = (k / N) % L, j = k % N;
				limb_t bit = (a.l[jj] >> j) & 1;
				res.l[ii] |= bit << i;
			}
		}
		return res;
	}
	
	static void shuffle_word4(word_t res[4], word_t a, const size_t shuffle[N * L]) {
		PRAGMA_UNROLL(64)
		for(size_t ii = 0; ii < L; ++ii) {
			limb_t tmp[4] = {};
			PRAGMA_UNROLL(64)
			for(size_t i = 0; i < N; ++i) {
				size_t k = shuffle[ii * N + i];
				size_t jj = (k / N) % L, j = k % N;
				limb_t bits = ((a.l[jj] >> j) | (a.l[(jj + 1) % L] << (N - 1 - j) << 1)) & 0xf;
				tmp[i % 4] |= bits << (i / 4 * 4);
			}
			limb_t swp[4];
			swp[0] = (tmp[0] & limb_t(UINT64_C(0x3333333333333333))) | ((tmp[2] & limb_t(UINT64_C(0x3333333333333333))) << 2);
			swp[1] = (tmp[1] & limb_t(UINT64_C(0x3333333333333333))) | ((tmp[3] & limb_t(UINT64_C(0x3333333333333333))) << 2);
			swp[2] = (tmp[2] & limb_t(UINT64_C(0xcccccccccccccccc))) | ((tmp[0] & limb_t(UINT64_C(0xcccccccccccccccc))) >> 2);
			swp[3] = (tmp[3] & limb_t(UINT64_C(0xcccccccccccccccc))) | ((tmp[1] & limb_t(UINT64_C(0xcccccccccccccccc))) >> 2);
			res[0].l[ii] = (swp[0] & limb_t(UINT64_C(0x5555555555555555))) | ((swp[1] & limb_t(UINT64_C(0x5555555555555555))) << 1);
			res[1].l[ii] = (swp[1] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) | ((swp[0] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) >> 1);
			res[2].l[ii] = (swp[2] & limb_t(UINT64_C(0x5555555555555555))) | ((swp[3] & limb_t(UINT64_C(0x5555555555555555))) << 1);
			res[3].l[ii] = (swp[3] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) | ((swp[2] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) >> 1);
		}
	}
	
	static void shuffle_word8(word_t res[8], word_t a, const size_t shuffle[N * L]) {
		PRAGMA_UNROLL(64)
		for(size_t ii = 0; ii < L; ++ii) {
			limb_t tmp[8] = {};
			PRAGMA_UNROLL(64)
			for(size_t i = 0; i < N; ++i) {
				size_t k = shuffle[ii * N + i];
				size_t jj = (k / N) % L, j = k % N;
				limb_t bits = ((a.l[jj] >> j) | (a.l[(jj + 1) % L] << (N - 1 - j) << 1)) & 0xff;
				tmp[i % 8] |= bits << (i / 8 * 8);
			}
			limb_t swp[8];
			swp[0] = (tmp[0] & limb_t(UINT64_C(0x0f0f0f0f0f0f0f0f))) | ((tmp[4] & limb_t(UINT64_C(0x0f0f0f0f0f0f0f0f))) << 4);
			swp[1] = (tmp[1] & limb_t(UINT64_C(0x0f0f0f0f0f0f0f0f))) | ((tmp[5] & limb_t(UINT64_C(0x0f0f0f0f0f0f0f0f))) << 4);
			swp[2] = (tmp[2] & limb_t(UINT64_C(0x0f0f0f0f0f0f0f0f))) | ((tmp[6] & limb_t(UINT64_C(0x0f0f0f0f0f0f0f0f))) << 4);
			swp[3] = (tmp[3] & limb_t(UINT64_C(0x0f0f0f0f0f0f0f0f))) | ((tmp[7] & limb_t(UINT64_C(0x0f0f0f0f0f0f0f0f))) << 4);
			swp[4] = (tmp[4] & limb_t(UINT64_C(0xf0f0f0f0f0f0f0f0))) | ((tmp[0] & limb_t(UINT64_C(0xf0f0f0f0f0f0f0f0))) >> 4);
			swp[5] = (tmp[5] & limb_t(UINT64_C(0xf0f0f0f0f0f0f0f0))) | ((tmp[1] & limb_t(UINT64_C(0xf0f0f0f0f0f0f0f0))) >> 4);
			swp[6] = (tmp[6] & limb_t(UINT64_C(0xf0f0f0f0f0f0f0f0))) | ((tmp[2] & limb_t(UINT64_C(0xf0f0f0f0f0f0f0f0))) >> 4);
			swp[7] = (tmp[7] & limb_t(UINT64_C(0xf0f0f0f0f0f0f0f0))) | ((tmp[3] & limb_t(UINT64_C(0xf0f0f0f0f0f0f0f0))) >> 4);
			tmp[0] = (swp[0] & limb_t(UINT64_C(0x3333333333333333))) | ((swp[2] & limb_t(UINT64_C(0x3333333333333333))) << 2);
			tmp[1] = (swp[1] & limb_t(UINT64_C(0x3333333333333333))) | ((swp[3] & limb_t(UINT64_C(0x3333333333333333))) << 2);
			tmp[2] = (swp[2] & limb_t(UINT64_C(0xcccccccccccccccc))) | ((swp[0] & limb_t(UINT64_C(0xcccccccccccccccc))) >> 2);
			tmp[3] = (swp[3] & limb_t(UINT64_C(0xcccccccccccccccc))) | ((swp[1] & limb_t(UINT64_C(0xcccccccccccccccc))) >> 2);
			tmp[4] = (swp[4] & limb_t(UINT64_C(0x3333333333333333))) | ((swp[6] & limb_t(UINT64_C(0x3333333333333333))) << 2);
			tmp[5] = (swp[5] & limb_t(UINT64_C(0x3333333333333333))) | ((swp[7] & limb_t(UINT64_C(0x3333333333333333))) << 2);
			tmp[6] = (swp[6] & limb_t(UINT64_C(0xcccccccccccccccc))) | ((swp[4] & limb_t(UINT64_C(0xcccccccccccccccc))) >> 2);
			tmp[7] = (swp[7] & limb_t(UINT64_C(0xcccccccccccccccc))) | ((swp[5] & limb_t(UINT64_C(0xcccccccccccccccc))) >> 2);
			res[0].l[ii] = (tmp[0] & limb_t(UINT64_C(0x5555555555555555))) | ((tmp[1] & limb_t(UINT64_C(0x5555555555555555))) << 1);
			res[1].l[ii] = (tmp[1] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) | ((tmp[0] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) >> 1);
			res[2].l[ii] = (tmp[2] & limb_t(UINT64_C(0x5555555555555555))) | ((tmp[3] & limb_t(UINT64_C(0x5555555555555555))) << 1);
			res[3].l[ii] = (tmp[3] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) | ((tmp[2] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) >> 1);
			res[4].l[ii] = (tmp[4] & limb_t(UINT64_C(0x5555555555555555))) | ((tmp[5] & limb_t(UINT64_C(0x5555555555555555))) << 1);
			res[5].l[ii] = (tmp[5] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) | ((tmp[4] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) >> 1);
			res[6].l[ii] = (tmp[6] & limb_t(UINT64_C(0x5555555555555555))) | ((tmp[7] & limb_t(UINT64_C(0x5555555555555555))) << 1);
			res[7].l[ii] = (tmp[7] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) | ((tmp[6] & limb_t(UINT64_C(0xaaaaaaaaaaaaaaaa))) >> 1);
		}
	}
	
	static void mix_halfword(word_t &state, word_t &mixin, word_t mixup, const size_t *shifts) {
		if(L == 1) {
			limb_t s0 = mixup.l[0];
			limb_t s1 = right_shift_limb(mixup, shifts[0]);
			limb_t s2 = right_shift_limb(mixup, shifts[1]);
			limb_t s3 = right_shift_limb(mixup, shifts[2]);
			limb_t s4 = right_shift_limb(mixup, shifts[3]);
			limb_t s5 = mixin.l[0];
			limb_t temp = s0 ^ (s1 & ~s2) ^ s3 ^ s4 ^ s5;
			state.l[0] = ((temp << (N / 2)) | (state.l[0] >> (N / 2))) & MASK;
			mixin.l[0] >>= N / 2;
			mixup.l[0] >>= N / 2;
		} else {
			PRAGMA_UNROLL(64)
			for(size_t ii = 0; ii < L / 2; ++ii) {
				limb_t s0 = mixup.l[0];
				limb_t s1 = right_shift_limb(mixup, shifts[0]);
				limb_t s2 = right_shift_limb(mixup, shifts[1]);
				limb_t s3 = right_shift_limb(mixup, shifts[2]);
				limb_t s4 = right_shift_limb(mixup, shifts[3]);
				limb_t s5 = mixin.l[0];
				PRAGMA_UNROLL(64)
				for(size_t jj = 0; jj < L - 1; ++jj) {
					state.l[jj] = state.l[jj + 1];
					mixin.l[jj] = mixin.l[jj + 1];
					mixup.l[jj] = mixup.l[jj + 1];
				}
				state.l[L - 1] = (s0 ^ (s1 & ~s2) ^ s3 ^ s4 ^ s5) & MASK;
			}
		}
	}
	
	static void unmix_partword(word_t &state, word_t &mixin, word_t mixup, const size_t *shifts, size_t nbits) {
		limb_t s0 = mixup.l[L - 1] >> (N - nbits);
		limb_t s1 = right_shift_limb(state, shifts[0] - nbits);
		limb_t s2 = right_shift_limb(state, shifts[1] - nbits);
		limb_t s3 = right_shift_limb(state, shifts[2] - nbits);
		limb_t s4 = right_shift_limb(state, shifts[3] - nbits);
		limb_t s5 = mixin.l[L - 1] >> (N - nbits);
		limb_t temp = s0 ^ (s1 & ~s2) ^ s3 ^ s4 ^ s5;
		for(size_t jj = L; jj-- > 1; ) {
			state.l[jj] = ((state.l[jj] << nbits) | (state.l[jj - 1] >> (N - nbits))) & MASK;
			mixin.l[jj] = ((mixin.l[jj] << nbits) | (mixin.l[jj - 1] >> (N - nbits))) & MASK;
			mixup.l[jj] = ((mixup.l[jj] << nbits) | (mixup.l[jj - 1] >> (N - nbits))) & MASK;
		}
		state.l[0] = ((state.l[0] << nbits) & MASK) | (temp & ((limb_t(1) << nbits) - 1));
		mixin.l[0] = (mixin.l[0] << nbits) & MASK;
		mixup.l[0] = (mixup.l[0] << nbits) & MASK;
	}
	
	static void next(word_t *state, size_t streams) {
		word_t state0 = state[0];
		state[0] = matrix_vector_product(XORMIX_MATRIX, state0);
		word_t mixin[N * L];
		size_t s = 0;
		for( ; s < (streams + 2) / 8 * 8; s += 8) {
			word_t tmp[8];
			shuffle_word8(tmp, state0, XORMIX_SHUFFLE);
			mixin[s + 0] = xor_word(tmp[0], XORMIX_SALTS[s + 0]);
			mixin[s + 1] = xor_word(tmp[1], XORMIX_SALTS[s + 1]);
			mixin[s + 2] = xor_word(tmp[2], XORMIX_SALTS[s + 2]);
			mixin[s + 3] = xor_word(tmp[3], XORMIX_SALTS[s + 3]);
			mixin[s + 4] = xor_word(tmp[4], XORMIX_SALTS[s + 4]);
			mixin[s + 5] = xor_word(tmp[5], XORMIX_SALTS[s + 5]);
			mixin[s + 6] = xor_word(tmp[6], XORMIX_SALTS[s + 6]);
			mixin[s + 7] = xor_word(tmp[7], XORMIX_SALTS[s + 7]);
			state0 = right_rotate_word(state0, 8);
		}
		for( ; s < (streams + 1) / 4 * 4; s += 4) {
			word_t tmp[4];
			shuffle_word4(tmp, state0, XORMIX_SHUFFLE);
			mixin[s + 0] = xor_word(tmp[0], XORMIX_SALTS[s + 0]);
			mixin[s + 1] = xor_word(tmp[1], XORMIX_SALTS[s + 1]);
			mixin[s + 2] = xor_word(tmp[2], XORMIX_SALTS[s + 2]);
			mixin[s + 3] = xor_word(tmp[3], XORMIX_SALTS[s + 3]);
			state0 = right_rotate_word(state0, 4);
		}
		for( ; s < streams; ++s) {
			mixin[s] = xor_word(shuffle_word(state0, XORMIX_SHUFFLE), XORMIX_SALTS[s]);
			state0 = right_rotate_word(state0, 1);
		}
		for(size_t h = 0; h < 2; ++h) {
			word_t state1 = state[1];
			for(s = 0; s < streams; ++s) {
				word_t mixup = (s == streams - 1)? state1 : state[s + 2];
				mix_halfword(state[s + 1], mixin[s], mixup, XORMIX_SHIFTS);
			}
		}
	}
	
	static void prev(word_t *state, size_t streams) {
		state[0] = matrix_vector_product(XORMIX_MATRIX_INV, state[0]);
		word_t state0 = state[0];
		word_t mixin[N * L];
		size_t s = 0;
		for( ; s < (streams + 2) / 8 * 8; s += 8) {
			word_t tmp[8];
			shuffle_word8(tmp, state0, XORMIX_SHUFFLE);
			mixin[s + 0] = xor_word(tmp[0], XORMIX_SALTS[s + 0]);
			mixin[s + 1] = xor_word(tmp[1], XORMIX_SALTS[s + 1]);
			mixin[s + 2] = xor_word(tmp[2], XORMIX_SALTS[s + 2]);
			mixin[s + 3] = xor_word(tmp[3], XORMIX_SALTS[s + 3]);
			mixin[s + 4] = xor_word(tmp[4], XORMIX_SALTS[s + 4]);
			mixin[s + 5] = xor_word(tmp[5], XORMIX_SALTS[s + 5]);
			mixin[s + 6] = xor_word(tmp[6], XORMIX_SALTS[s + 6]);
			mixin[s + 7] = xor_word(tmp[7], XORMIX_SALTS[s + 7]);
			state0 = right_rotate_word(state0, 8);
		}
		for( ; s < (streams + 1) / 4 * 4; s += 4) {
			word_t tmp[4];
			shuffle_word4(tmp, state0, XORMIX_SHUFFLE);
			mixin[s + 0] = xor_word(tmp[0], XORMIX_SALTS[s + 0]);
			mixin[s + 1] = xor_word(tmp[1], XORMIX_SALTS[s + 1]);
			mixin[s + 2] = xor_word(tmp[2], XORMIX_SALTS[s + 2]);
			mixin[s + 3] = xor_word(tmp[3], XORMIX_SALTS[s + 3]);
			state0 = right_rotate_word(state0, 4);
		}
		for( ; s < streams; ++s) {
			mixin[s] = xor_word(shuffle_word(state0, XORMIX_SHUFFLE), XORMIX_SALTS[s]);
			state0 = right_rotate_word(state0, 1);
		}
		size_t minshift = std::min(
			std::min(XORMIX_SHIFTS[0], XORMIX_SHIFTS[1]),
			std::min(XORMIX_SHIFTS[2], XORMIX_SHIFTS[3]));
		size_t nparts = (N * L + minshift - 1) / minshift;
		for(size_t h = 0; h < nparts; ++h) {
			size_t nbits = (h == nparts - 1)? N * L - (nparts - 1) * minshift : minshift;
			word_t statelast = state[streams];
			for(s = streams; s-- > 0; ) {
				word_t mixup = (s == 0)? statelast : state[s];
				word_t &mixin2 = (s == 0)? mixin[streams - 1] : mixin[s - 1];
				unmix_partword(state[s + 1], mixin2, mixup, XORMIX_SHIFTS, nbits);
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
	static T slice_words(const word_t *words, size_t offset, size_t length) {
		constexpr size_t T_BITS = std::numeric_limits<T>::digits + std::numeric_limits<T>::is_signed;
		typedef typename std::conditional<(T_BITS > LIMB_BITS), T, limb_t>::type U;
		if(length == 0)
			return T(0);
		size_t ii = offset / N, i = offset % N;
		T result = T(words[ii / L].l[ii % L] >> i);
		for(size_t j = 1; j <= (length + N - 2) / N; ++j) {
			size_t jj = ii + j;
			result |= U(words[jj / L].l[jj % L]) << (j * N - i - 1) << 1;
		}
		return T(result << (T_BITS - length)) >> (T_BITS - length);
	}
	
};

extern template class xormix<uint16_t, 16, 1>;
extern template class xormix<uint32_t, 24, 1>;
extern template class xormix<uint32_t, 32, 1>;
extern template class xormix<uint64_t, 48, 1>;
extern template class xormix<uint64_t, 64, 1>;
extern template class xormix<uint64_t, 48, 2>;
extern template class xormix<uint64_t, 64, 2>;

typedef xormix<uint16_t, 16, 1> xormix16;
typedef xormix<uint32_t, 24, 1> xormix24;
typedef xormix<uint32_t, 32, 1> xormix32;
typedef xormix<uint64_t, 48, 1> xormix48;
typedef xormix<uint64_t, 64, 1> xormix64;
typedef xormix<uint64_t, 48, 2> xormix96;
typedef xormix<uint64_t, 64, 2> xormix128;
