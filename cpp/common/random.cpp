// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include "random.hpp"

#include <stdexcept>

#if defined(__linux__)

#include <errno.h>
#include <sys/random.h>

void get_true_randomness(void *data, size_t size) {
	size_t pos = 0;
	while(pos < size) {
		ssize_t res = getrandom((char*) data + pos, size - pos, 0);
		if(res < 0) {
			if(errno == EAGAIN)
				continue;
			throw std::runtime_error("Failed to get true randomness");
		}
		pos += res;
	}
}

#elif defined(_WIN32)

#include <windows.h>

// RtlGenRandom is a non-public function, so this trick is needed to get access to it.
#define RtlGenRandom SystemFunction036
extern "C" BOOLEAN NTAPI RtlGenRandom(PVOID RandomBuffer, ULONG RandomBufferLength);
#pragma comment(lib, "advapi32.lib")

void get_true_randomness(void *data, size_t size) {
	if(!RtlGenRandom(data, size))
		throw std::runtime_error("Failed to get true randomness");
}

#else
#error "This operating system is currently not supported"
#endif
