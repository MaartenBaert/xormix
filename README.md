Xormix Pseudorandom Number Generator
====================================

Xormix is a family of pseudorandom number generators designed to produce high-quality output while being efficiently implementable in hardware, especially when large amounts of random bits are required each cycle. Xormix generators have an incremental cost of 5 logic gates and one flip-flop per output bit, which is comparable to the cost of a relatively sparse [LFSR](https://en.wikipedia.org/wiki/Linear-feedback_shift_register), but produces much higher quality output.

*Important: xormix is still a work in progress and is subject to change.*

Xormix variants
---------------

Xormix generators with various word sizes and number of parallel output streams are available. The word size determines the minimum guaranteed period of the random number generator, while multiple parallel output streams enable efficient generation of larger amounts of random bits at a reduced cost per bit. The following xormix variants are available:

| Variant   | Minimum period | Streams  | Output bits  | Gates (ASIC)  | 6-LUTs (FPGA) | Flip-flops   |
| --------- | -------------- | -------- | ------------ | ------------- | ------------- | ------------ |
| xormix16  | 2^16 - 1       | 1 to 16  | 16 to 256    | 152 to 1352   | 32 to 272     | 32 to 272    |
| xormix24  | 2^24 - 1       | 1 to 24  | 24 to 576    | 228 to 2988   | 48 to 600     | 48 to 600    |
| xormix32  | 2^32 - 1       | 1 to 32  | 32 to 1024   | 304 to 5264   | 64 to 1056    | 64 to 1056   |
| xormix48  | 2^48 - 1       | 1 to 48  | 48 to 2304   | 456 to 11736  | 96 to 2352    | 96 to 2352   |
| xormix64  | 2^64 - 1       | 1 to 64  | 64 to 4096   | 608 to 20768  | 128 to 4160   | 128 to 4160  |
| xormix96  | 2^96 - 1       | 1 to 96  | 96 to 9216   | 912 to 46512  | 192 to 9312   | 192 to 9312  |
| xormix128 | 2^128 - 1      | 1 to 128 | 128 to 16384 | 1216 to 82496 | 256 to 16512  | 256 to 16512 |

Note: Gate/LUT counts are approximate, actual results may vary depending on how smart the synthesis tool is.

The properties of a xormix variant with word size `N` and number of streams `S` can be calculated using the following formulas:

	minimum guaranteed period = 2^N - 1
	number of streams (S) = 1 ... N
	number of output bits = S * N
	number of logic gates (for ASIC) = (5 * S + 4.5) * N
	number of 6-input LUTs (for FPGA) = (S + 1) * N
	number of flip-flops = (S + 1) * N

For applications where the randomness quality is not critical, I recommend the xormix32 variant. When operated at 100 MHz, the minimum period of `2^32 - 1` ensures good quality output for at least 43 seconds (in practice it is almost always much longer, but you should not rely on that). However for applications where the randomness quality is critical, I recommend the xormix64 variant instead. Even when operated at 1 GHz, the minimum period of `2^64 - 1` guarantees good quality output for at least 585 years, which should be enough for any application. The larger variants are provided primarily to simplify seed management. If you use many instances of the same random number generator, you need to take care that you don't accidentally use the same seed value twice. With xormix64 this probability is already very low, but with a large enough number of instances it may still happen due to the [birthday paradox](https://en.wikipedia.org/wiki/Birthday_problem). If you are using xormix in such an application and you don't want to carefully manage your seed values, you might want to use xormix128 such that you can just choose random seed values and still have a negligibly low risk of collisions.

Xormix has been extensively tested with three different randomness test suites (PractRand, TestU01 and Dieharder). As expected some weaknesses were detected in xormix16 and to a lesser extent xormix24, but xormix32 and above passed all randomness tests. The full results can be found [here](doc/randomness-test-results.md).

Documentation
-------------

- [Xormix Algorithm](doc/algorithm.md)
- [Xormix Design Criteria](doc/design-criteria.md)
- [Xormix Hardware Module (VHDL/Verilog) Interface](doc/hardware-interface.md)
- [Mathematical Properties of Xormix Variants](doc/mathematical-properties.md)
- [Randomness Test Results](doc/randomness-test-results.md)

Implementations
---------------

Portable hardware implementations and simple testbenches written in VHDL and Verilog are available in the `vhdl` and `verilog` directories. Additionally, a non-portable implementation optimized for Xilinx 7 Series FPGAs is available in the `vhdl_x7s` directory.

Two software implementations are also available for testing and verification purposes. The reference implementation is written in Python and can be found in the `python/reference` directory. This implementation is easy to understand and was used to generate the test vectors for all other implementations, but it is very slow. A much faster C++ implementation can be found in the `cpp` folder, along with a command-line tool (`xormix-tool`) which can be used to generate seeds and random output in various formats.

Note that even the optimized C++ implementation is still much slower than other pseudorandom number generators that were designed to be fast in software. Xormix is not meant to be used in software-only applications, the design only makes sense when implemented in hardware.

License
-------

The xormix implementations (software and hardware) and related tools are available under the MIT License (see `LICENSE.txt`). This includes all code in this repository except the following third-party C++ libraries:

- Catch: Available under the Boost Software License 1.0 (see `LICENSE-catch.txt`).
- Cxxopts: Available under the MIT License (see `LICENSE-cxxopts.txt`).
- PCG: Available under the Apache License 2.0 (see `LICENSE-pcg.txt`).

All of these are permissive licenses which permit commercial use.

Acknowledgments
---------------

Xormix uses ideas inspired by the [xorshift](https://en.wikipedia.org/wiki/Xorshift) pseudorandom number generator and the [Trivium](https://en.wikipedia.org/wiki/Trivium_%28cipher%29) stream cipher. The design and testing process was based on [M.E. O'Neill's blog](https://www.pcg-random.org/blog/) and [Bob Jenkins's avalanche testing method](http://burtleburtle.net/bob/rand/talksmall.html). Thanks to Bert Pieters for providing additional processing power for avalanche testing and final randomness testing.
