// *Really* minimal PCG32 code / (c) 2014 M.E. O'Neill / pcg-random.org
// Licensed under Apache License 2.0 (NO WARRANTY, etc. see website)

#include <cstdint>

struct pcg32_random_t {
	uint64_t state;
	uint64_t inc;
};

uint32_t pcg32_random_r(pcg32_random_t &rng) {
	uint64_t oldstate = rng.state;
	// Advance internal state
	rng.state = oldstate * UINT64_C(6364136223846793005) + (rng.inc | 1);
	// Calculate output function (XSH RR), uses old state for max ILP
	uint32_t xorshifted = ((oldstate >> 18) ^ oldstate) >> 27;
	uint32_t rot = oldstate >> 59;
	return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
}
