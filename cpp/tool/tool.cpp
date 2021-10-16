// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include "3rdparty/cxxopts.hpp"
#include "common/random.hpp"
#include "common/xormix.hpp"

#include <cstddef>
#include <cstdint>
#include <cstdlib>

#include <iostream>
#include <map>
#include <new>

enum format_t {
	FORMAT_BIN,
	FORMAT_HEX,
	FORMAT_VHDL,
	FORMAT_VERILOG,
};

bool g_option_help;
bool g_option_read_seed;
bool g_option_write_seed;
bool g_option_write_output;

uint32_t g_option_word_size;
uint32_t g_option_streams;
uint32_t g_option_uniform_seeds;
uint64_t g_option_output_cycles;

bool g_option_short_seed;
uint64_t g_option_discard_cycles;
uint64_t g_option_repeats;

format_t g_option_input_format;
format_t g_option_output_format;

std::istream& operator>>(std::istream &stream, format_t &value) {
	std::string str;
	stream >> str;
	if(str == "bin") value = FORMAT_BIN;
	else if(str == "hex") value = FORMAT_HEX;
	else if(str == "vhdl") value = FORMAT_VHDL;
	else if(str == "verilog") value = FORMAT_VERILOG;
	else throw std::runtime_error("Format must be bin, hex, vhdl or verilog");
	return stream;
}

std::ostream& operator<<(std::ostream &stream, format_t value) {
	switch(value) {
		case FORMAT_BIN: { stream << "bin"; break; }
		case FORMAT_HEX: { stream << "hex"; break; }
		case FORMAT_VHDL: { stream << "vhdl"; break; }
		case FORMAT_VERILOG: { stream << "verilog"; break; }
	}
	return stream;
}

template<typename limb_t, size_t N, size_t L>
struct xormix_tool {
	typedef xormix<limb_t, N, L> xm;
	typedef typename xm::word_t word_t;
	typedef typename xm::matrix_t matrix_t;
	
	static char to_hex(uint8_t val) {
		return (val < 10)? '0' + val : 'a' + (val - 10);
	}
	
	static uint8_t from_hex(int c) {
		if(c >= '0' && c <= '9')
			return c - '0';
		if(c >= 'a' && c <= 'f')
			return c - 'a' + 10;
		if(c >= 'A' && c <= 'F')
			return c - 'A' + 10;
		throw std::runtime_error("Invalid hex input value");
	}
	
	static void read_skip_whitespace() {
		for( ; ; ) {
			int c = std::cin.peek();
			if(c != ' ' && c != '\t' && c != '\n' && c != '\r')
				break;
			std::cin.get();
		}
	}
	
	static bool read_check(const char *str, size_t n) {
		for(size_t i = 0; i < n; ++i) {
			if(std::cin.get() != int(str[i]))
				return false;
		}
		return true;
	}
	
	static void read_formatted(uint8_t *bytes, size_t num_words) {
		switch(g_option_input_format) {
			case FORMAT_BIN: {
				std::cin.read((char*) bytes, xm::WORD_BYTES * num_words);
				break;
			}
			case FORMAT_HEX: {
				for(size_t i = 0; i < num_words; ++i) {
					read_skip_whitespace();
					if(!read_check("0x", 2))
						throw std::runtime_error("Invalid hex input value");
					for(size_t j = 0; j < xm::WORD_BYTES; ++j) {
						uint8_t val1 = from_hex(std::cin.get());
						uint8_t val2 = from_hex(std::cin.get());
						bytes[i * xm::WORD_BYTES + (xm::WORD_BYTES - 1 - j)] = (val1 << 4) | val2;
					}
				}
				break;
			}
			case FORMAT_VHDL: {
				size_t num_bytes = num_words * xm::WORD_BYTES;
				read_skip_whitespace();
				if(!read_check("X\"", 2))
					throw std::runtime_error("Invalid vhdl input value");
				for(size_t i = 0; i < num_bytes; ++i) {
					uint8_t val1 = from_hex(std::cin.get());
					uint8_t val2 = from_hex(std::cin.get());
					bytes[num_bytes - 1 - i] = (val1 << 4) | val2;
				}
				if(std::cin.get() != '"')
					throw std::runtime_error("Invalid vhdl input value");
				break;
			}
			case FORMAT_VERILOG: {
				size_t num_bytes = num_words * xm::WORD_BYTES;
				read_skip_whitespace();
				std::stringstream ss;
				ss << (8 * num_bytes) << "'h";
				std::string prefix = ss.str();
				if(!read_check(prefix.data(), prefix.size()))
					throw std::runtime_error("Invalid verilog input value");
				for(size_t i = 0; i < num_bytes; ++i) {
					uint8_t val1 = from_hex(std::cin.get());
					uint8_t val2 = from_hex(std::cin.get());
					bytes[num_bytes - 1 - i] = (val1 << 4) | val2;
				}
				break;
			}
		}
		if(std::cin.fail())
			throw std::runtime_error("Reading input failed");
	}
	
	static void write_formatted(uint8_t *bytes, size_t num_words) {
		switch(g_option_output_format) {
			case FORMAT_BIN: {
				std::cout.write((char*) bytes, xm::WORD_BYTES * num_words);
				break;
			}
			case FORMAT_HEX: {
				for(size_t i = 0; i < num_words; ++i) {
					std::cout.write("0x", 2);
					for(size_t j = 0; j < xm::WORD_BYTES; ++j) {
						uint8_t byte = bytes[i * xm::WORD_BYTES + (xm::WORD_BYTES - 1 - j)];
						std::cout.put(to_hex(byte >> 4));
						std::cout.put(to_hex(byte & 15));
					}
					std::cout.put((i == num_words - 1)? '\n' : ' ');
				}
				break;
			}
			case FORMAT_VHDL: {
				size_t num_bytes = num_words * xm::WORD_BYTES;
				std::cout.write("X\"", 2);
				for(size_t i = 0; i < num_bytes; ++i) {
					uint8_t byte = bytes[num_bytes - 1 - i];
					std::cout.put(to_hex(byte >> 4));
					std::cout.put(to_hex(byte & 15));
				}
				std::cout.write("\"\n", 2);
				break;
			}
			case FORMAT_VERILOG: {
				size_t num_bytes = num_words * xm::WORD_BYTES;
				std::cout << (8 * num_bytes) << "'h";
				for(size_t i = 0; i < num_bytes; ++i) {
					uint8_t byte = bytes[num_bytes - 1 - i];
					std::cout.put(to_hex(byte >> 4));
					std::cout.put(to_hex(byte & 15));
				}
				std::cout.put('\n');
				break;
			}
		}
		if(std::cout.fail())
			throw std::runtime_error("Writing output failed");
	}
	
	static void generate_seed_x(word_t *seed_x) {
		word_t zero = {};
		uint8_t random_bytes[xm::WORD_BYTES];
		do {
			get_true_randomness(random_bytes, xm::WORD_BYTES);
			xm::unpack_words(random_bytes, seed_x, 1);
		} while(xm::word_equal(*seed_x, zero));
	}
	
	static void generate_seed_y(word_t *seed_y, size_t streams) {
		std::vector<uint8_t> random_bytes(xm::WORD_BYTES * streams);
		get_true_randomness(random_bytes.data(), random_bytes.size());
		xm::unpack_words(random_bytes.data(), seed_y, streams);
	}
	
	static int run() {
		
		// allocate memory (and avoid integer overflow)
		if(g_option_uniform_seeds > UINT32_MAX / (g_option_streams + 1))
			throw std::bad_alloc();
		std::vector<word_t> state((g_option_streams + 1) * g_option_uniform_seeds);
		std::vector<uint8_t> bytes(xm::WORD_BYTES * (g_option_streams + 1));
		
		std::vector<word_t> output(g_option_streams);
		
		for(uint64_t repeat = 0; repeat < g_option_repeats || g_option_repeats == 0; ++repeat) {
			
			// generate initial state
			if(g_option_read_seed) {
				
				// read seeds from stdin (including all uniform seeds)
				for(uint64_t uniform = 0; uniform < g_option_uniform_seeds; ++uniform) {
					word_t *substate = state.data() + uniform * (g_option_streams + 1);
					read_formatted(bytes.data(), 1);
					xm::unpack_words(bytes.data(), substate, 1);
					if(g_option_short_seed) {
						read_formatted(bytes.data() + xm::WORD_BYTES, 1);
						xm::unpack_words(bytes.data() + xm::WORD_BYTES, substate + 1, 1);
						for(size_t s = 1; s < g_option_streams; ++s) {
							substate[s + 1] = substate[1];
						}
					} else {
						read_formatted(bytes.data() + xm::WORD_BYTES, g_option_streams);
						xm::unpack_words(bytes.data() + xm::WORD_BYTES, substate + 1, g_option_streams);
					}
					word_t zero = {};
					if(xm::word_equal(state[0], zero)) {
						std::cerr << "Warning: seed_x is zero" << std::endl;
					}
				}
				
			} else {
				
				// get original seed
				generate_seed_x(state.data());
				if(g_option_short_seed) {
					generate_seed_y(state.data() + 1, 1);
					for(size_t s = 1; s < g_option_streams; ++s) {
						state[s + 1] = state[1];
					}
				} else {
					generate_seed_y(state.data() + 1, g_option_streams);
				}
				
			}
			
			// generate or check uniform seeds
			if(g_option_uniform_seeds != 1) {
				word_t advance = xm::divide_period(g_option_uniform_seeds);
				matrix_t advance_matrix = xm::matrix_power(xm::XORMIX_MATRIX, advance);
				word_t seed_x = state[0];
				for(uint64_t uniform = 1; uniform < g_option_uniform_seeds; ++uniform) {
					seed_x = xm::matrix_vector_product(advance_matrix, seed_x);
					word_t *substate = state.data() + uniform * (g_option_streams + 1);
					if(g_option_read_seed) {
						if(!xm::word_equal(seed_x, substate[0])) {
							std::cerr << "Warning: seeds are not uniformly spaced" << std::endl;
						}
					} else {
						substate[0] = seed_x;
						if(g_option_short_seed) {
							for(size_t s = 0; s < g_option_streams; ++s) {
								substate[s + 1] = substate[0];
							}
						} else {
							generate_seed_y(substate + 1, g_option_streams);
						}
					}
				}
			}
			
			// write seed to stdout
			if(g_option_write_seed) {
				for(uint64_t uniform = 0; uniform < g_option_uniform_seeds; ++uniform) {
					word_t *substate = state.data() + uniform * (g_option_streams + 1);
					xm::pack_words(bytes.data(), substate, g_option_streams + 1);
					if(g_option_output_format != FORMAT_BIN)
						std::cout << "seed_x:" << std::endl;
					write_formatted(bytes.data(), 1);
					if(g_option_output_format != FORMAT_BIN)
						std::cout << "seed_y:" << std::endl;
					write_formatted(bytes.data() + xm::WORD_BYTES, (g_option_short_seed)? 1 : g_option_streams);
					if(g_option_output_format != FORMAT_BIN)
						std::cout << std::endl;
				}
			}
			
			// write output to stdout
			if(g_option_write_output) {
				if(g_option_output_format != FORMAT_BIN)
					std::cout << "output:" << std::endl;
				for(uint64_t cycle = 0; cycle < g_option_discard_cycles; ++cycle) {
					for(uint64_t uniform = 0; uniform < g_option_uniform_seeds; ++uniform) {
						word_t *substate = state.data() + uniform * (g_option_streams + 1);
						xm::next(substate, g_option_streams);
					}
				}
				for(uint64_t cycle = 0; cycle < g_option_output_cycles || g_option_output_cycles == 0; ++cycle) {
					for(uint64_t uniform = 0; uniform < g_option_uniform_seeds; ++uniform) {
						word_t *substate = state.data() + uniform * (g_option_streams + 1);
						xm::pack_words(bytes.data(), substate + 1, g_option_streams);
						write_formatted(bytes.data(), g_option_streams);
						xm::next(substate, g_option_streams);
					}
				}
				if(g_option_output_format != FORMAT_BIN)
					std::cout << std::endl;
			}
			
		}
		
		return EXIT_SUCCESS;
	}
	
};

int main(int argc, char **argv) {
	try {
		
		std::ios_base::sync_with_stdio(false);
		
		cxxopts::Options options("xormix-tool", "Command-line utility for the xormix random number generator");
		options.add_options()
			("h,help"          , "Show this help message"                    , cxxopts::value(g_option_help          )                      )
			("r,read-seed"     , "Read seed from stdin"                      , cxxopts::value(g_option_read_seed     )                      )
			("e,write-seed"    , "Write seed to stdout"                      , cxxopts::value(g_option_write_seed    )                      )
			("o,write-output"  , "Write output to stdout"                    , cxxopts::value(g_option_write_output  )                      )
			("w,word-size"     , "Word size in bits"                         , cxxopts::value(g_option_word_size     )->default_value("64" ))
			("s,streams"       , "Number of streams"                         , cxxopts::value(g_option_streams       )->default_value("1"  ))
			("u,uniform-seeds" , "Number of uniformly distributed seeds"     , cxxopts::value(g_option_uniform_seeds )->default_value("1"  ))
			("c,output-cycles" , "Number of output cycles [0 means infinite]", cxxopts::value(g_option_output_cycles )->default_value("0"  ))
			("t,short-seed"    , "Use simplified seeding with short seeds"   , cxxopts::value(g_option_short_seed    )                      )
			("d,discard-cycles", "Number of cycles to discard after seeding" , cxxopts::value(g_option_discard_cycles)->default_value("0"  ))
			("p,repeats"       , "Number of repeats [0 means infinite]"      , cxxopts::value(g_option_repeats       )->default_value("1"  ))
			("i,input-format"  , "Input format [bin, hex, vhdl or verilog]"  , cxxopts::value(g_option_input_format  )->default_value("hex"))
			("f,output-format" , "Output format [bin, hex, vhdl or verilog]" , cxxopts::value(g_option_output_format )->default_value("hex"))
		;
		options.parse(argc, argv);
		
		if(!g_option_help && !g_option_write_seed && !g_option_write_output) {
			std::cerr << "Error: No action specified (-e or -o is required)" << std::endl;
			std::cerr << options.help() << std::endl;
			return EXIT_FAILURE;
		}
		if(g_option_help) {
			std::cout << options.help() << std::endl;
			return EXIT_SUCCESS;
		}
		
		std::map<uint32_t, int(*)()> word_size_mapper = {
			{ 16, xormix_tool<uint16_t, 16, 1>::run},
			{ 24, xormix_tool<uint32_t, 24, 1>::run},
			{ 32, xormix_tool<uint32_t, 32, 1>::run},
			{ 48, xormix_tool<uint64_t, 48, 1>::run},
			{ 64, xormix_tool<uint64_t, 64, 1>::run},
			{ 96, xormix_tool<uint64_t, 48, 2>::run},
			{128, xormix_tool<uint64_t, 64, 2>::run},
		};
		
		auto tool_run = word_size_mapper.find(g_option_word_size);
		if(tool_run == word_size_mapper.end()) {
			std::cerr << "Error: Word size must be 16, 24, 32, 48, 64, 96 or 128" << std::endl;
			return EXIT_FAILURE;
		}
		if(g_option_streams < 1 || g_option_streams > g_option_word_size) {
			std::cerr << "Error: Number of streams must be between 1 and the word size" << std::endl;
			return EXIT_FAILURE;
		}
		uint64_t max_uniform_seeds = (g_option_word_size < 64)? (uint64_t(1) << g_option_word_size) - 1 : UINT64_MAX;
		if(g_option_uniform_seeds < 1 || g_option_uniform_seeds > max_uniform_seeds) {
			std::cerr << "Error: Number of uniformly distributed seeds must be between 1 and 2^wordsize - 1" << std::endl;
			return EXIT_FAILURE;
		}
		return tool_run->second();
		
	} catch(const std::exception &e) {
		std::cerr << "Error: " << e.what() << std::endl;
		return EXIT_FAILURE;
	} catch(...) {
		std::cerr << "Error: Unknown exception" << std::endl;
		return EXIT_FAILURE;
	}
}
