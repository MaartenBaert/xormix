// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include "3rdparty/catch.hpp"
#include "common/xormix.hpp"

#define XORMIX_FULL_PERIOD(n) \
TEST_CASE("xormix"#n" full period", "[xormix"#n"][fullperiod]") { \
	xormix##n::matrix_t identity = xormix##n::matrix_identity(); \
	xormix##n::word_t full_period; \
	for(size_t k = 0; k < xormix##n::L_; ++k) { \
		full_period.l[k] = xormix##n::MASK; \
	} \
	REQUIRE(xormix##n::matrix_equal(xormix##n::matrix_power(xormix##n::XORMIX_MATRIX, full_period), identity)); \
	for(size_t i = 0; i < xormix##n::TEST_PERIODS.size(); ++i) { \
		INFO("test period " << i) \
		xormix##n::word_t test_period = xormix##n::TEST_PERIODS.begin()[i]; \
		REQUIRE_FALSE(xormix##n::matrix_equal(xormix##n::matrix_power(xormix##n::XORMIX_MATRIX, test_period), identity)); \
	} \
}

XORMIX_FULL_PERIOD(16)
XORMIX_FULL_PERIOD(24)
XORMIX_FULL_PERIOD(32)
XORMIX_FULL_PERIOD(48)
XORMIX_FULL_PERIOD(64)
XORMIX_FULL_PERIOD(96)
XORMIX_FULL_PERIOD(128)
