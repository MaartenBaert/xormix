// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include "3rdparty/catch.hpp"
#include "common/xormix.hpp"

#define XORMIX_FULL_PERIOD(n) \
TEST_CASE("xormix"#n" full period", "[xormix"#n"][fullperiod]") { \
	typedef xormix##n xm; \
	xm::matrix_t identity = xm::matrix_identity(); \
	xm::word_t full_period; \
	for(size_t k = 0; k < xm::L_; ++k) { \
		full_period.l[k] = xm::MASK; \
	} \
	REQUIRE(xm::matrix_equal(xm::matrix_power(xm::XORMIX_MATRIX, full_period), identity)); \
	for(size_t i = 0; i < xm::TEST_PERIODS.size(); ++i) { \
		INFO("test period " << i) \
		xm::word_t test_period = xm::TEST_PERIODS.begin()[i]; \
		REQUIRE_FALSE(xm::matrix_equal(xm::matrix_power(xm::XORMIX_MATRIX, test_period), identity)); \
	} \
}

XORMIX_FULL_PERIOD(16)
XORMIX_FULL_PERIOD(24)
XORMIX_FULL_PERIOD(32)
XORMIX_FULL_PERIOD(48)
XORMIX_FULL_PERIOD(64)
XORMIX_FULL_PERIOD(96)
XORMIX_FULL_PERIOD(128)
