// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include "3rdparty/pcg.hpp"
#include "common/xormix.hpp"

#include <pybind11/numpy.h>
#include <pybind11/pybind11.h>

#include <cstdint>

#include <map>

template<typename uint_t>
uint_t pcg_random(pcg32_random_t &rng) {
	static_assert(sizeof(uint_t) <= sizeof(uint32_t), "Invalid type");
	return uint_t(pcg32_random_r(rng));
}

template<>
uint64_t pcg_random<uint64_t>(pcg32_random_t &rng) {
	uint32_t a = pcg32_random_r(rng);
	uint32_t b = pcg32_random_r(rng);
	return (uint64_t(a) << 32) | uint64_t(b);
}

template<typename uint_t>
size_t popcount(uint_t x) {
	size_t sum = 0;
	while(x != 0) {
		x &= x - 1;
		++sum;
	}
	return sum;
}

template<typename limb_t, size_t N, size_t L>
struct avalanche_wrapper {
	typedef xormix<limb_t, N, L> xm;
	typedef typename xm::word_t word_t;
	typedef typename xm::matrix_t matrix_t;
	
	static word_t random_word(pcg32_random_t &rng) {
		word_t res;
		for(size_t i = 0; i < L; ++i) {
			res.l[i] = pcg_random<limb_t>(rng) & xm::MASK;
		}
		return res;
	}
	
	static size_t hamming_distance(word_t a, word_t b) {
		size_t count = 0;
		for(size_t i = 0; i < L; ++i) {
			count += popcount(a.l[i] ^ b.l[i]);
		}
		return count;
	}
	
	static void test(uint64_t *counts, uint64_t trials, uint32_t bit, const size_t *shifts, size_t rounds, uint64_t seed) {
		pcg32_random_t rng;
		rng.state = seed;
		rng.inc = UINT64_C(1442695040888963407);
		for(size_t i = 0; i < N * L + 1; ++i) {
			counts[i] = 0;
		}
		for(uint64_t trial = 0; trial < trials; ++trial) {
			word_t state1 = random_word(rng);
			word_t state2 = state1;
			state2.l[bit / N] ^= limb_t(1) << (bit % N);
			for(size_t round = 0; round < rounds; round += 2) {
				word_t mixin1 = random_word(rng);
				word_t mixin2 = mixin1;
				xm::mix_halfword(state1, mixin1, state1, shifts);
				xm::mix_halfword(state2, mixin2, state2, shifts);
				if(round + 1 < rounds) {
					xm::mix_halfword(state1, mixin1, state1, shifts);
					xm::mix_halfword(state2, mixin2, state2, shifts);
				}
			}
			if(xm::word_equal(state1, state2))
				throw std::runtime_error("Collision in avalanche code!");
			++counts[hamming_distance(state1, state2)];
		}
	}
	
};

typedef void (*avalanche_func_t)(uint64_t*, uint64_t, uint32_t, const size_t*, size_t, uint64_t);
static const std::map<uint32_t, avalanche_func_t> word_size_mapper = {
	{ 16, avalanche_wrapper<uint16_t, 16, 1>::test},
	{ 24, avalanche_wrapper<uint32_t, 24, 1>::test},
	{ 32, avalanche_wrapper<uint32_t, 32, 1>::test},
	{ 48, avalanche_wrapper<uint64_t, 48, 1>::test},
	{ 64, avalanche_wrapper<uint64_t, 64, 1>::test},
	{ 96, avalanche_wrapper<uint64_t, 48, 2>::test},
	{128, avalanche_wrapper<uint64_t, 64, 2>::test},
};

pybind11::array_t<uint64_t, pybind11::array::c_style> xormix_avalanche_test(
		uint32_t word_size, uint64_t trials, uint32_t bit,
		pybind11::array_t<size_t, pybind11::array::c_style | pybind11::array::forcecast> shifts,
		size_t rounds, uint64_t seed) {
	auto avalanche_test = word_size_mapper.find(word_size);
	if(avalanche_test == word_size_mapper.end())
		throw std::runtime_error("Word size must be 16, 24, 32, 48, 64, 96 or 128");
	pybind11::array_t<uint64_t, pybind11::array::c_style> counts(std::array<size_t, 1>{word_size + 1});
	if(bit >= word_size)
		throw std::runtime_error("Invalid bit value");
	auto shifts_data = shifts.template unchecked<1>();
	if(shifts_data.shape(0) != 4)
		throw std::runtime_error("Incorrect shifts array shape");
	for(size_t i = 0; i < 4; ++i) {
		if(shifts_data[i] < 1 || shifts_data[i] > word_size / 2)
			throw std::runtime_error("Invalid shift value");
	}
	avalanche_test->second(counts.mutable_data(), trials, bit, shifts.data(), rounds, seed);
	return counts;
}

PYBIND11_MODULE(xormix_avalanche, m) {
	m.doc() = "xormix avalanche testing";
	m.def("test", &xormix_avalanche_test, "Run a xormix avalanche test",
		pybind11::arg("word_size"), pybind11::arg("trials"), pybind11::arg("bit"),
		pybind11::arg("shifts"), pybind11::arg("rounds"), pybind11::arg("seed")
	);
}
