// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include "3rdparty/catch.hpp"
#include "common/xormix.hpp"

static constexpr size_t TEST_STREAMS = 13;
static constexpr size_t TEST_OUTPUTS = 100;

#define XORMIX_REVERSE(n) \
TEST_CASE("xormix"#n" reverse", "[xormix"#n"][reverse]") { \
	typedef xormix##n xm; \
	xm::word_t state[TEST_STREAMS + 1]; \
	for(size_t j = 0; j < TEST_STREAMS + 1; ++j) { \
		for(size_t k = 0; k < xm::L_; ++k) { \
			state[j].l[k] = 12345; \
		} \
	} \
	std::vector<xm::word_t> data((TEST_OUTPUTS + 1) * (TEST_STREAMS + 1)); \
	for(size_t j = 0; j < TEST_STREAMS + 1; ++j) { \
		data[j] = state[j]; \
	} \
	for(size_t i = 0; i < TEST_OUTPUTS; ++i) { \
		xm::next(state, TEST_STREAMS); \
		for(size_t j = 0; j < TEST_STREAMS + 1; ++j) { \
			data[(i + 1) * (TEST_STREAMS + 1) + j] = state[j]; \
		} \
	} \
	for(size_t i = TEST_OUTPUTS; i-- > 0; ) { \
		INFO("output " << i) \
		xm::prev(state, TEST_STREAMS); \
		for(size_t j = 0; j < TEST_STREAMS + 1; ++j) { \
			INFO("word " << j) \
			for(size_t k = 0; k < xm::L_; ++k) { \
				INFO("limb " << k) \
				REQUIRE(state[j].l[k] == data[i * (TEST_STREAMS + 1) + j].l[k]); \
			} \
		} \
	} \
}

XORMIX_REVERSE(16)
XORMIX_REVERSE(24)
XORMIX_REVERSE(32)
XORMIX_REVERSE(48)
XORMIX_REVERSE(64)
XORMIX_REVERSE(96)
XORMIX_REVERSE(128)
