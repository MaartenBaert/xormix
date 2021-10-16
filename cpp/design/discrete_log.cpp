// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include "common/xormix.hpp"

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <cstdint>
#include <iostream>

#include <map>
#include <vector>

template<typename limb_t, size_t N, size_t L>
struct discrete_log_wrapper {
	typedef xormix<limb_t, N, L> xm;
	typedef typename xm::word_t word_t;
	typedef typename xm::matrix_t matrix_t;
	
	struct bsgs_entry_t {
		uint64_t value, index;
		inline bsgs_entry_t() {}
		inline bsgs_entry_t(uint64_t value, uint64_t index) : value(value), index(index) {}
		inline bool operator<(const bsgs_entry_t& other) {
			return value < other.value;
		}
	};
	
	static word_t int_to_word(uint64_t val) {
		word_t res;
		for(size_t ii = 0; ii < L; ++ii) {
			res.l[ii] = (ii * N < 64)? (val >> (ii * N)) & xm::MASK : 0;
		}
		return res;
	}
	
	static word_t int_to_word(const pybind11::int_ &val) {
		word_t res;
		for(size_t ii = 0; ii < L; ++ii) {
			res.l[ii] = ((val >> pybind11::int_(ii * N)) & pybind11::int_(xm::MASK)).cast<limb_t>();
		}
		return res;
	}
	
	static matrix_t int_to_matrix(word_t val, word_t poly) {
		matrix_t res;
		for(size_t ii = 0; ii < L; ++ii) {
			for(size_t i = 0; i < N; ++i) {
				res.w[i][ii] = val;
				limb_t carry = val.l[L - 1];
				for(size_t jj = L - 1; jj-- > 0; ) {
					val.l[jj + 1] = ((val.l[jj + 1] << 1) | (val.l[jj] >> (N - 1))) & xm::MASK;
				}
				val.l[0] = (val.l[0] << 1) & xm::MASK;
				if(carry >> (N - 1)) {
					for(size_t jj = 0; jj < L; ++jj) {
						val.l[jj] = val.l[jj] ^ poly.l[jj];
					}
				}
			}
		}
		return res;
	}
	
	static matrix_t int_to_matrix(const pybind11::int_ &val, const pybind11::int_ &poly) {
		matrix_t res;
		pybind11::int_ temp = val;
		for(size_t ii = 0; ii < L; ++ii) {
			for(size_t i = 0; i < N; ++i) {
				res.w[i][ii] = int_to_word(temp);
				temp = temp << pybind11::int_(1);
				if((temp >> pybind11::int_(N * L)).cast<bool>())
					temp = temp ^ poly;
			}
		}
		return res;
	}
	
	static uint64_t isqrt(uint64_t x) {
		uint64_t r = 0;
		uint64_t b = uint64_t(1) << 62;
		while(b != 0) {
			uint64_t rb = r | b;
			r >>= 1;
			if(x >= rb) {
				x -= rb;
				r |= b;
			}
			b >>= 2;
		}
		return r;
	}
	
	static word_t gf_mul(word_t a, word_t b, word_t poly) {
		limb_t r[2 * L] = {};
		for(size_t ii = 0; ii < L; ++ii) {
			for(size_t i = 0; i < N; ++i) {
				if((b.l[ii] >> i) & 1) {
					for(size_t jj = 0; jj < L; ++jj) {
						r[ii + jj] ^= (a.l[jj] << i) & xm::MASK;
						r[ii + jj + 1] ^= a.l[jj] >> (N - 1 - i) >> 1;
					}
				}
			}
		}
		for(size_t ii = L; ii-- > 0; ) {
			for(size_t i = N; i-- > 0; ) {
				if((r[ii + L] >> i) & 1) {
					for(size_t jj = 0; jj < L; ++jj) {
						r[ii + jj] ^= (poly.l[jj] << i) & xm::MASK;
						r[ii + jj + 1] ^= poly.l[jj] >> (N - 1 - i) >> 1;
					}
				}
			}
		}
		word_t res;
		for(size_t jj = 0; jj < L; ++jj) {
			res.l[jj] = r[jj];
		}
		return res;
	}
	
	static pybind11::int_ gf_mul(const pybind11::int_ &a, const pybind11::int_ &b, const pybind11::int_ &poly) {
		pybind11::int_ r = 0;
		for(size_t i = 0; i < N * L; ++i) {
			if(((b >> pybind11::int_(i)) & pybind11::int_(1)).cast<bool>())
				r = r ^ (a << pybind11::int_(i));
		}
		for(size_t i = N * L; i-- > 0; ) {
			if((r >> pybind11::int_(N * L + i)).cast<bool>())
				r = r ^ (poly << pybind11::int_(i));
		}
		return r;
	}
	
	static word_t gf_pow(word_t a, word_t k, word_t poly) {
		word_t r = {};
		r.l[0] = 1;
		for(size_t ii = 0; ii < L; ++ii) {
			for(size_t i = 0; i < N; ++i) {
				if((k.l[ii] >> i) & 1) {
					r = gf_mul(r, a, poly);
				}
				a = gf_mul(a, a, poly);
			}
		}
		return r;
	}
	
	static pybind11::int_ gf_pow(const pybind11::int_ &a, const pybind11::int_ &k, const pybind11::int_ &poly) {
		pybind11::int_ r = 1, b = a;
		for(size_t i = 0; i < N * L; ++i) {
			if(((k >> pybind11::int_(i)) & pybind11::int_(1)).cast<bool>())
				r = gf_mul(r, b, poly);
			b = gf_mul(b, b, poly);
		}
		return r;
	}
	
	static uint64_t bsgs(const pybind11::int_ &val, const pybind11::int_ &gen, uint64_t order, const pybind11::int_ &poly) {
		uint64_t steps = isqrt(order - 1) + 1;
		pybind11::int_ gs = (pybind11::int_(1) << pybind11::int_(N * L)) - pybind11::int_(1) - pybind11::int_(steps);
		word_t gsw = int_to_word(gs);
		word_t valw = int_to_word(val);
		word_t genw = int_to_word(gen);
		word_t polyw = int_to_word(poly);
		word_t aw = int_to_word(1);
		word_t bw = int_to_word(val);
		matrix_t am = int_to_matrix(genw, polyw);
		matrix_t bm = int_to_matrix(gf_pow(genw, gsw, polyw), polyw);
		std::vector<bsgs_entry_t> atable(steps), btable(steps);
		for(uint64_t i = 0; i < steps; ++i) {
			atable[i] = {uint64_t(aw.l[0]), i};
			btable[i] = {uint64_t(bw.l[0]), i};
			aw = xm::matrix_vector_product(am, aw);
			bw = xm::matrix_vector_product(bm, bw);
		}
		std::sort(atable.begin(), atable.end());
		std::sort(btable.begin(), btable.end());
		uint64_t ai = 0, bi = 0;
		while(ai < steps && bi < steps) {
			uint64_t av = atable[ai].value;
			uint64_t bv = btable[bi].value;
			if(av < bv) {
				++ai;
			} else if(av > bv) {
				++bi;
			} else {
				uint64_t k = atable[ai].index + steps * btable[bi].index;
				if(xm::word_equal(gf_pow(genw, int_to_word(k), polyw), valw))
					return k % order;
				for(uint64_t bi2 = bi + 1; bi2 < steps && av == btable[bi2].value; ++bi2) {
					k = atable[ai].index + steps * btable[bi2].index;
					if(xm::word_equal(gf_pow(genw, int_to_word(k), polyw), valw))
						return k % order;
				}
				++ai;
			}
		}
		throw std::runtime_error("BSGS failed");
	}
	
};

typedef pybind11::int_ (*gf_mul_func_t)(const pybind11::int_&, const pybind11::int_&, const pybind11::int_&);
static const std::map<uint32_t, gf_mul_func_t> map_gf_mul = {
	{ 16, discrete_log_wrapper<uint16_t, 16, 1>::gf_mul},
	{ 24, discrete_log_wrapper<uint32_t, 24, 1>::gf_mul},
	{ 32, discrete_log_wrapper<uint32_t, 32, 1>::gf_mul},
	{ 48, discrete_log_wrapper<uint64_t, 48, 1>::gf_mul},
	{ 64, discrete_log_wrapper<uint64_t, 64, 1>::gf_mul},
	{ 96, discrete_log_wrapper<uint64_t, 48, 2>::gf_mul},
	{128, discrete_log_wrapper<uint64_t, 64, 2>::gf_mul},
};

typedef pybind11::int_ (*gf_pow_func_t)(const pybind11::int_&, const pybind11::int_&, const pybind11::int_&);
static const std::map<uint32_t, gf_pow_func_t> map_gf_pow = {
	{ 16, discrete_log_wrapper<uint16_t, 16, 1>::gf_pow},
	{ 24, discrete_log_wrapper<uint32_t, 24, 1>::gf_pow},
	{ 32, discrete_log_wrapper<uint32_t, 32, 1>::gf_pow},
	{ 48, discrete_log_wrapper<uint64_t, 48, 1>::gf_pow},
	{ 64, discrete_log_wrapper<uint64_t, 64, 1>::gf_pow},
	{ 96, discrete_log_wrapper<uint64_t, 48, 2>::gf_pow},
	{128, discrete_log_wrapper<uint64_t, 64, 2>::gf_pow},
};

typedef uint64_t (*bsgs_func_t)(const pybind11::int_&, const pybind11::int_&, uint64_t, const pybind11::int_&);
static const std::map<uint32_t, bsgs_func_t> map_bsgs = {
	{ 16, discrete_log_wrapper<uint16_t, 16, 1>::bsgs},
	{ 24, discrete_log_wrapper<uint32_t, 24, 1>::bsgs},
	{ 32, discrete_log_wrapper<uint32_t, 32, 1>::bsgs},
	{ 48, discrete_log_wrapper<uint64_t, 48, 1>::bsgs},
	{ 64, discrete_log_wrapper<uint64_t, 64, 1>::bsgs},
	{ 96, discrete_log_wrapper<uint64_t, 48, 2>::bsgs},
	{128, discrete_log_wrapper<uint64_t, 64, 2>::bsgs},
};

pybind11::int_ py_gf_mul(uint32_t word_size, const pybind11::int_ &a, const pybind11::int_ &b, const pybind11::int_ &poly) {
	auto func = map_gf_mul.find(word_size);
	if(func == map_gf_mul.end())
		throw std::runtime_error("Word size must be 16, 24, 32, 48, 64, 96 or 128");
	return func->second(a, b, poly);
}

pybind11::int_ py_gf_pow(uint32_t word_size, const pybind11::int_ &a, const pybind11::int_ &k, const pybind11::int_ &poly) {
	auto func = map_gf_pow.find(word_size);
	if(func == map_gf_pow.end())
		throw std::runtime_error("Word size must be 16, 24, 32, 48, 64, 96 or 128");
	return func->second(a, k, poly);
}

uint64_t py_bsgs(uint32_t word_size, const pybind11::int_ &val, const pybind11::int_ &gen, uint64_t order, const pybind11::int_ &poly) {
	auto func = map_bsgs.find(word_size);
	if(func == map_bsgs.end())
		throw std::runtime_error("Word size must be 16, 24, 32, 48, 64, 96 or 128");
	return func->second(val, gen, order, poly);
}

PYBIND11_MODULE(xormix_discrete_log, m) {
	m.doc() = "xormix discrete logarithm";
	m.def("gf_mul", &py_gf_mul, "Calculate Galois field multiplication",
		pybind11::arg("word_size"), pybind11::arg("a"), pybind11::arg("b"), pybind11::arg("poly")
	);
	m.def("gf_pow", &py_gf_pow, "Calculate Galois field power",
		pybind11::arg("word_size"), pybind11::arg("a"), pybind11::arg("k"), pybind11::arg("poly")
	);
	m.def("bsgs", &py_bsgs, "Run the BSGS kernel",
		pybind11::arg("word_size"), pybind11::arg("val"), pybind11::arg("gen"), pybind11::arg("order"), pybind11::arg("poly")
	);
}
