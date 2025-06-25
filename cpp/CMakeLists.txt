cmake_minimum_required(VERSION 3.9)
cmake_policy(VERSION 3.9)
set(CMAKE_CXX_STANDARD 11)

project(xormix VERSION 0.0.0)

option(BUILD_TOOL "Build xormix-tool executable" ON)
option(BUILD_TESTS "Build xormix-tests executable" ON)
option(BUILD_PYTHON "Build xormix python modules (requires pybind11)" OFF)

option(WITH_GETRANDOM "Use the getrandom() system call instead of /dev/urandom (requires Linux 3.17 or newer)" ON)

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
	target_compile_definitions(xormix-tool PRIVATE
		-DXORMIX_WITH_GETRANDOM=$<BOOL:${WITH_GETRANDOM}>
	)
endif()

if(BUILD_TESTS)
	add_executable(xormix-tests
		3rdparty/catch.hpp
		common/xormix.cpp
		common/xormix.hpp
		test/test_divide_period.cpp
		test/test_full_period.cpp
		test/test_matrix_inverse.cpp
		test/test_matrix_power.cpp
		test/test_output.cpp
		test/test_output_wide.cpp
		test/test_reverse.cpp
		test/tests.cpp
	)
	target_include_directories(xormix-tests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
endif()

if(BUILD_PYTHON)
	
	find_package(pybind11 REQUIRED)
	
	pybind11_add_module(xormix_avalanche
		3rdparty/pcg.hpp
		common/xormix.cpp
		common/xormix.hpp
		pycpp/xormix_avalanche.cpp
	)
	target_include_directories(xormix_avalanche PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
	
	pybind11_add_module(xormix_discrete_log
		common/xormix.cpp
		common/xormix.hpp
		pycpp/xormix_discrete_log.cpp
	)
	target_include_directories(xormix_discrete_log PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
	
	pybind11_add_module(xormix_pycpp
		common/xormix.cpp
		common/xormix.hpp
		pycpp/xormix_pycpp.cpp
	)
	target_include_directories(xormix_pycpp PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
	
endif()

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
