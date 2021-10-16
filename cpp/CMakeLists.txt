cmake_minimum_required(VERSION 3.9)
cmake_policy(VERSION 3.9)
set(CMAKE_CXX_STANDARD 11)

project(xormix VERSION 0.0.0)

option(BUILD_TOOL "Build xormix-tool executable" ON)
option(BUILD_TESTS "Build xormix-tests executable" ON)
option(BUILD_AVALANCHE "Build xormix_avalanche python module (requires pybind11)" OFF)

include(FeatureSummary)

if(BUILD_TOOL)
	add_executable(xormix-tool
		3rdparty/cxxopts.hpp
		common/random.cpp
		common/random.hpp
		common/xormix.cpp
		common/xormix.hpp
		tool/tool.cpp
	)
	target_include_directories(xormix-tool PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
endif()

if(BUILD_TESTS)
	add_executable(xormix-tests
		3rdparty/catch.hpp
		common/xormix.cpp
		common/xormix.hpp
		test/test_divide_period.cpp
		test/test_full_period.cpp
		test/test_matrix_power.cpp
		test/test_output.cpp
		test/tests.cpp
	)
	target_include_directories(xormix-tests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
endif()

if(BUILD_AVALANCHE)
	
	find_package(pybind11 REQUIRED)
	
	pybind11_add_module(xormix_avalanche
		3rdparty/pcg.hpp
		common/xormix.cpp
		common/xormix.hpp
		design/avalanche.cpp
	)
	target_include_directories(xormix_avalanche PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
	
	pybind11_add_module(xormix_discrete_log
		3rdparty/pcg.hpp
		common/xormix.cpp
		common/xormix.hpp
		design/discrete_log.cpp
	)
	target_include_directories(xormix_discrete_log PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
	
endif()

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
