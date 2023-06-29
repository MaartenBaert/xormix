// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

#include "common/xormix.hpp"

#include <cstddef>
#include <cstdint>

#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>

namespace py = pybind11;

template<typename limb_t, size_t N, size_t L>
class xormix_pycpp  {
	
public:
	typedef xormix<limb_t, N, L> xm;
	typedef typename xm::word_t word_t;
	typedef typename xm::matrix_t matrix_t;
	
private:
	std::vector<word_t> m_state;
	
private: // Helper functions
	
	static word_t pyint_to_word(uint64_t val) {
		word_t res;
		for(size_t ii = 0; ii < L; ++ii) {
			res.l[ii] = (ii * N < 64)? (val >> (ii * N)) & xm::MASK : 0;
		}
		return res;
	}
	
	static word_t pyint_to_word(const py::int_ &val) {
		word_t result;
		uint8_t bytes[xm::WORD_BYTES];
		if(_PyLong_AsByteArray((PyLongObject*) val.ptr(), bytes, xm::WORD_BYTES, 1, 0) != 0)
			throw std::runtime_error("Could not convert python int to xormix word");
		xm::unpack_words(bytes, &result, 1);
		return result;
	}
	
	static void pyint_to_words(const py::int_ &val, word_t *words, size_t num_words) {
		std::vector<uint8_t> bytes(xm::WORD_BYTES * num_words);
		if(_PyLong_AsByteArray((PyLongObject*) val.ptr(), bytes.data(), bytes.size(), 1, 0) != 0)
			throw std::runtime_error("Could not convert python int to xormix words");
		xm::unpack_words(bytes.data(), words, num_words);
	}
	
	static py::int_ pyint_from_words(const word_t *words, size_t num_words) {
		std::vector<uint8_t> bytes(xm::WORD_BYTES * num_words);
		xm::pack_words(bytes.data(), words, num_words);
		PyObject *ptr = _PyLong_FromByteArray(bytes.data(), bytes.size(), 1, 0);
		if(ptr == nullptr)
			throw std::runtime_error("Could not convert xormix words to python int");
		return py::reinterpret_steal<py::int_>(ptr);
	}
	
	static void py_warning(const std::string &message) {
		if(PyErr_WarnEx(nullptr, message.c_str(), 1) != 0)
			throw py::error_already_set();
	}
	
	void check_initialized() {
		word_t zero = {};
		if(xm::word_equal(m_state[0], zero))
			py_warning("Xormix is used with state_x equal to zero");
	}
	
public: // Python API
	
	xormix_pycpp(size_t streams) {
		if(streams < 1 || streams > N * L)
			throw std::runtime_error("Invalid number of streams");
		m_state.resize(streams + 1, word_t{});
	}
	
	xormix_pycpp(size_t streams, const py::int_ &state) {
		if(streams < 1 || streams > N * L)
			throw std::runtime_error("Invalid number of streams");
		m_state.resize(streams + 1);
		pyint_to_words(state, m_state.data(), m_state.size());
	}
	
	xormix_pycpp(const xormix_pycpp&) = default;
	xormix_pycpp(xormix_pycpp&&) = default;
	
	xormix_pycpp& operator=(const xormix_pycpp&) = default;
	xormix_pycpp& operator=(xormix_pycpp&&) = default;
	
	size_t get_streams() {
		return m_state.size() - 1;
	}
	
	py::int_ get_state() {
		return pyint_from_words(m_state.data(), m_state.size());
	}
	
	void set_state(const py::int_ &state) {
		pyint_to_words(state, m_state.data(), m_state.size());
	}
	
	py::int_ get_output() {
		check_initialized();
		return pyint_from_words(m_state.data() + 1, m_state.size() - 1);
	}
	
	void seed_full(const py::int_ &seed_x, const py::int_ &seed_y) {
		if(seed_x.equal(pybind11::int_(0)))
			py_warning("Xormix seed_x is zero");
		m_state[0] = pyint_to_word(seed_x);
		pyint_to_words(seed_y, m_state.data() + 1, m_state.size() - 1);
	}
	
	void seed_simple(const py::int_ &seed_x, const py::int_ &seed_y) {
		if(seed_x.equal(pybind11::int_(0)))
			py_warning("Xormix seed_x is zero");
		m_state[0] = pyint_to_word(seed_x);
		m_state[1] = pyint_to_word(seed_y);
		for(size_t s = 1; s < get_streams(); ++s) {
			m_state[s + 1] = m_state[1];
		}
		for(size_t i = 0; i < 4; ++i) {
			xm::next(m_state.data(), get_streams());
		}
	}
	
	void forward(size_t cycles) {
		check_initialized();
		for(size_t i = 0; i < cycles; ++i) {
			xm::next(m_state.data(), get_streams());
		}
	}
	
	void rewind(size_t cycles) {
		check_initialized();
		for(size_t i = 0; i < cycles; ++i) {
			xm::prev(m_state.data(), get_streams());
		}
	}
	
	template<typename T>
	py::array generate_sub(size_t cycles, size_t slices, size_t slice_bits) {
		constexpr size_t T_BITS = std::numeric_limits<T>::digits + std::numeric_limits<T>::is_signed;
		py::array_t<T, py::array::c_style> result({cycles, slices});
		auto res = result.template mutable_unchecked<2>();
		if(slice_bits == N && T_BITS >= N) {
			for(size_t i = 0; i < cycles; ++i) {
				for(size_t j = 0; j < slices; ++j) {
					if(std::numeric_limits<T>::is_signed && T_BITS > N) {
						res(i, j) = T(m_state[j / L + 1].l[j % L]) << (T_BITS - N) >> (T_BITS - N);
					} else {
						res(i, j) = m_state[j / L + 1].l[j % L];
					}
				}
				xm::next(m_state.data(), get_streams());
			}
		} else {
			for(size_t i = 0; i < cycles; ++i) {
				for(size_t j = 0; j < slices; ++j) {
					res(i, j) = xm::template slice_words<T>(m_state.data() + 1, slice_bits * j, slice_bits);
				}
				xm::next(m_state.data(), get_streams());
			}
		}
		return result;
	}
	
	py::array generate(size_t cycles, size_t slices, size_t slice_bits, bool signed_) {
		check_initialized();
		size_t total_bits = N * L * get_streams();
		if(slices < 1 || slices > total_bits)
			throw std::runtime_error("Invalid number of slices");
		if(slice_bits < 1 || slice_bits > 64 || slice_bits > total_bits)
			throw std::runtime_error("Invalid number of slice bits");
		if(slices * slice_bits > total_bits)
			throw std::runtime_error("The number of streams is too small to produce the requested number of slices");
		if(signed_) {
			if(slice_bits <= 8)
				return generate_sub<int8_t>(cycles, slices, slice_bits);
			else if(slice_bits <= 16)
				return generate_sub<int16_t>(cycles, slices, slice_bits);
			else if(slice_bits <= 32)
				return generate_sub<int32_t>(cycles, slices, slice_bits);
			else
				return generate_sub<int64_t>(cycles, slices, slice_bits);
		} else {
			if(slice_bits <= 8)
				return generate_sub<uint8_t>(cycles, slices, slice_bits);
			else if(slice_bits <= 16)
				return generate_sub<uint16_t>(cycles, slices, slice_bits);
			else if(slice_bits <= 32)
				return generate_sub<uint32_t>(cycles, slices, slice_bits);
			else
				return generate_sub<uint64_t>(cycles, slices, slice_bits);
		}
	}
	
	py::array generate_raw(size_t cycles) {
		check_initialized();
		return generate_sub<limb_t>(cycles, L * get_streams(), N);
	}
	
	template<typename T>
	static py::array bitslice_sub(py::array_t<limb_t, py::array::c_style> raw_data, size_t slices, size_t slice_bits, size_t start, size_t stride) {
		constexpr size_t T_BITS = std::numeric_limits<T>::digits + std::numeric_limits<T>::is_signed;
		typedef typename std::conditional<(T_BITS > xm::LIMB_BITS), T, limb_t>::type U;
		size_t cycles = raw_data.shape(0);
		py::array_t<T, py::array::c_style> result({cycles, slices});
		auto raw = raw_data.template unchecked<2>();
		auto res = result.template mutable_unchecked<2>();
		if(slice_bits == N && start == 0 && stride == N && T_BITS >= N) {
			for(size_t i = 0; i < cycles; ++i) {
				for(size_t j = 0; j < slices; ++j) {
					if(std::numeric_limits<T>::is_signed && T_BITS > N) {
						res(i, j) = T(raw(i, j)) << (T_BITS - N) >> (T_BITS - N);
					} else {
						res(i, j) = raw(i, j);
					}
				}
			}
		} else {
			for(size_t i = 0; i < cycles; ++i) {
				for(size_t j = 0; j < slices; ++j) {
					size_t offset = start + stride * j;
					size_t kk = offset / N, k = offset % N;
					T result = T(raw(i, kk) >> k);
					for(size_t l = 1; l <= (slice_bits + N - 2) / N; ++l) {
						result |= U(raw(i, kk + l)) << (l * N - k - 1) << 1;
					}
					res(i, j) = T(result << (T_BITS - slice_bits)) >> (T_BITS - slice_bits);
				}
			}
		}
		return result;
	}
	
	static py::array bitslice(py::array_t<limb_t> raw_data, size_t slices, size_t slice_bits, bool signed_, size_t start, size_t stride) {
		if(raw_data.ndim() != 2)
			throw std::runtime_error("Raw data array should be 2-dimensional");
		if(raw_data.shape(1) == 0)
			throw std::runtime_error("Raw data array should have at least one column");
		size_t total_bits = N * raw_data.shape(1);
		if(slices < 1 || slices > total_bits)
			throw std::runtime_error("Invalid number of slices");
		if(slice_bits < 1 || slice_bits > 64 || slice_bits > total_bits)
			throw std::runtime_error("Invalid number of slice bits");
		if(start > total_bits - slice_bits)
			throw std::runtime_error("Invalid start value");
		if(stride == 0)
			stride = slice_bits;
		if(slices > (total_bits - slice_bits - start) / stride + 1)
			throw std::runtime_error("The number of raw data columns is too small to produce the requested number of slices");
		if(signed_) {
			if(slice_bits <= 8)
				return bitslice_sub<int8_t>(raw_data, slices, slice_bits, start, stride);
			else if(slice_bits <= 16)
				return bitslice_sub<int16_t>(raw_data, slices, slice_bits, start, stride);
			else if(slice_bits <= 32)
				return bitslice_sub<int32_t>(raw_data, slices, slice_bits, start, stride);
			else
				return bitslice_sub<int64_t>(raw_data, slices, slice_bits, start, stride);
		} else {
			if(slice_bits <= 8)
				return bitslice_sub<uint8_t>(raw_data, slices, slice_bits, start, stride);
			else if(slice_bits <= 16)
				return bitslice_sub<uint16_t>(raw_data, slices, slice_bits, start, stride);
			else if(slice_bits <= 32)
				return bitslice_sub<uint32_t>(raw_data, slices, slice_bits, start, stride);
			else
				return bitslice_sub<uint64_t>(raw_data, slices, slice_bits, start, stride);
		}
	}
	
	// Python bindings generation
	
	static py::object python_bindings(py::module_ &m, const char *class_name) {
		py::object c = py::class_<xormix_pycpp>(m, class_name, "Xormix PRNG instance")
			.def(py::init<size_t>(), "Create a new PRNG instance.",
				py::arg("streams"))
			.def(py::init<size_t, const py::int_&>(), "Create a new PRNG instance with a given state.",
				py::arg("streams"), py::arg("state"))
			.def("copy",  [](const xormix_pycpp &self) { return xormix_pycpp(self); })
			.def("__copy__",  [](const xormix_pycpp &self) { return xormix_pycpp(self); })
			.def("__deepcopy__", [](const xormix_pycpp &self, py::dict) { return xormix_pycpp(self); }, py::arg("memo"))
			.def_property_readonly("streams", &xormix_pycpp::get_streams, "The number of output streams.")
			.def_property("state", &xormix_pycpp::get_state, &xormix_pycpp::set_state, "The state of the PRNG.")
			.def_property_readonly("output", &xormix_pycpp::get_output, "The current output of the PRNG.")
			.def("seed_full", &xormix_pycpp::seed_full, "Seeds the PRNG using the full seeding procedure.",
				py::arg("seed_x"), py::arg("seed_y"))
			.def("seed_simple", &xormix_pycpp::seed_simple, "Seeds the PRNG using the simplified seeding procedure.",
				py::arg("seed_x"), py::arg("seed_y"))
			.def("forward", &xormix_pycpp::forward, "Forwards the PRNG by the given number of cycles.",
				py::arg("cycles"))
			.def("rewind", &xormix_pycpp::rewind, "Rewinds the PRNG by the given number of cycles.",
				py::arg("cycles"))
			.def("generate", &xormix_pycpp::generate, "Generates multiple cycles of output as a bitsliced array.",
				py::arg("cycles"), py::arg("slices"), py::arg("slice_bits"), py::arg("signed") = false)
			.def("generate_raw", &xormix_pycpp::generate_raw, "Generates multiple cycles of output as a raw array.",
				py::arg("cycles"))
			.def_static("bitslice", &xormix_pycpp::bitslice, "Bitslices a raw array in a more flexible way.",
				py::arg("raw_data"), py::arg("slices"), py::arg("slice_bits"), py::arg("signed") = false, py::arg("start") = 0, py::arg("stride") = 0);
		c.attr("REVISION") = xm::REVISION;
		return c;
	}
	
};

PYBIND11_MODULE(xormix_pycpp, m) {
	m.doc() = "C++ implementation of xormix with python bindings";
	py::dict classes;
	classes[py::int_(16)] = xormix_pycpp<uint16_t, 16, 1>::python_bindings(m, "xormix16");
	classes[py::int_(24)] = xormix_pycpp<uint32_t, 24, 1>::python_bindings(m, "xormix24");
	classes[py::int_(32)] = xormix_pycpp<uint32_t, 32, 1>::python_bindings(m, "xormix32");
	classes[py::int_(48)] = xormix_pycpp<uint64_t, 48, 1>::python_bindings(m, "xormix48");
	classes[py::int_(64)] = xormix_pycpp<uint64_t, 64, 1>::python_bindings(m, "xormix64");
	classes[py::int_(96)] = xormix_pycpp<uint64_t, 48, 2>::python_bindings(m, "xormix96");
	classes[py::int_(128)] = xormix_pycpp<uint64_t, 64, 2>::python_bindings(m, "xormix128");
	m.attr("xormix") = classes;
}
