// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include "3rdparty/catch.hpp"
#include "common/xormix.hpp"

#define XORMIX_MATRIX_INVERSE(n) \
TEST_CASE("xormix"#n" matrix inverse", "[xormix"#n"][matrixinverse]") { \
	typedef xormix##n xm; \
	xm::matrix_t identity = xm::matrix_identity(); \
	xm::word_t full_period_minus_one; \
	for(size_t k = 0; k < xm::L_; ++k) { \
		full_period_minus_one.l[k] = xm::MASK; \
	} \
	full_period_minus_one.l[0] -= 1; \
	REQUIRE(xm::matrix_equal(xm::matrix_power(xm::XORMIX_MATRIX, full_period_minus_one), xm::XORMIX_MATRIX_INV)); \
	REQUIRE(xm::matrix_equal(xm::matrix_power(xm::XORMIX_MATRIX_INV, full_period_minus_one), xm::XORMIX_MATRIX)); \
	REQUIRE(xm::matrix_equal(xm::matrix_product(xm::XORMIX_MATRIX, xm::XORMIX_MATRIX_INV), xm::matrix_identity())); \
}

XORMIX_MATRIX_INVERSE(16)
XORMIX_MATRIX_INVERSE(24)
XORMIX_MATRIX_INVERSE(32)
XORMIX_MATRIX_INVERSE(48)
XORMIX_MATRIX_INVERSE(64)
XORMIX_MATRIX_INVERSE(96)
XORMIX_MATRIX_INVERSE(128)
