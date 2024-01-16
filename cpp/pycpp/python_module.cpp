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
		py::array_t<T, py::array::c_style> result({py::ssize_t(cycles), py::ssize_t(slices)});
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
		if(cycles > std::numeric_limits<py::ssize_t>::max())
			throw std::runtime_error("Invalid number of cycles");
		if(slices < 1 || slices > total_bits || slices > std::numeric_limits<py::ssize_t>::max())
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
		if(cycles > std::numeric_limits<py::ssize_t>::max())
			throw std::runtime_error("Invalid number of cycles");
		return generate_sub<limb_t>(cycles, L * get_streams(), N);
	}
	
	template<typename T>
	static py::array bitslice1_sub(py::array_t<limb_t, py::array::c_style> raw_data, size_t slices, size_t slice_bits, size_t start, size_t stride) {
		constexpr size_t T_BITS = std::numeric_limits<T>::digits + std::numeric_limits<T>::is_signed;
		typedef typename std::conditional<(T_BITS > xm::LIMB_BITS), T, limb_t>::type U;
		size_t cycles = raw_data.shape(0);
		py::array_t<T, py::array::c_style> result({py::ssize_t(cycles), py::ssize_t(slices)});
		auto raw_view = raw_data.template unchecked<2>();
		auto res_view = result.template mutable_unchecked<2>();
		if(slice_bits == N && start == 0 && stride == N && T_BITS >= N) {
			for(size_t i = 0; i < cycles; ++i) {
				for(size_t j = 0; j < slices; ++j) {
					if(std::numeric_limits<T>::is_signed && T_BITS > N) {
						res_view(i, j) = T(raw_view(i, j)) << (T_BITS - N) >> (T_BITS - N);
					} else {
						res_view(i, j) = raw_view(i, j);
					}
				}
			}
		} else {
			for(size_t i = 0; i < cycles; ++i) {
				for(size_t j = 0; j < slices; ++j) {
					size_t offset = start + stride * j;
					size_t kk = offset / N, k = offset % N;
					T result = T(raw_view(i, kk) >> k);
					for(size_t l = 1; l <= (slice_bits + k - 1) / N; ++l) {
						result |= U(raw_view(i, kk + l)) << (l * N - k - 1) << 1;
					}
					res_view(i, j) = T(result << (T_BITS - slice_bits)) >> (T_BITS - slice_bits);
				}
			}
		}
		return result;
	}
	
	template<typename T>
	static py::array bitslice2_sub(py::array_t<limb_t, py::array::c_style> raw_data, py::array_t<size_t> slice_bits, py::array_t<size_t> offsets) {
		constexpr size_t T_BITS = std::numeric_limits<T>::digits + std::numeric_limits<T>::is_signed;
		typedef typename std::conditional<(T_BITS > xm::LIMB_BITS), T, limb_t>::type U;
		size_t cycles = raw_data.shape(0);
		size_t slices = slice_bits.shape(0);
		py::array_t<T, py::array::c_style> result({py::ssize_t(cycles), py::ssize_t(slices)});
		auto raw_view = raw_data.template unchecked<2>();
		auto res_view = result.template mutable_unchecked<2>();
		auto slice_bits_view = slice_bits.template unchecked<1>();
		auto offsets_view = offsets.template unchecked<1>();
		for(size_t i = 0; i < cycles; ++i) {
			for(size_t j = 0; j < slices; ++j) {
				size_t current_slice_bits = slice_bits_view(j);
				size_t current_offset = offsets_view(j);
				size_t kk = current_offset / N, k = current_offset % N;
				T result = T(raw_view(i, kk) >> k);
				for(size_t l = 1; l <= (current_slice_bits + k - 1) / N; ++l) {
					result |= U(raw_view(i, kk + l)) << (l * N - k - 1) << 1;
				}
				res_view(i, j) = T(result << (T_BITS - current_slice_bits)) >> (T_BITS - current_slice_bits);
			}
		}
		return result;
	}
	
	static py::array bitslice1(py::array_t<limb_t> raw_data, size_t slices, size_t slice_bits, bool signed_, size_t start, size_t stride) {
		if(raw_data.ndim() != 2)
			throw std::runtime_error("Raw data array should be 2-dimensional");
		if(raw_data.shape(1) == 0)
			throw std::runtime_error("Raw data array should have at least one column");
		size_t total_bits = N * raw_data.shape(1);
		if(slices < 1 || slices > total_bits || slices > std::numeric_limits<py::ssize_t>::max())
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
				return bitslice1_sub<int8_t>(raw_data, slices, slice_bits, start, stride);
			else if(slice_bits <= 16)
				return bitslice1_sub<int16_t>(raw_data, slices, slice_bits, start, stride);
			else if(slice_bits <= 32)
				return bitslice1_sub<int32_t>(raw_data, slices, slice_bits, start, stride);
			else
				return bitslice1_sub<int64_t>(raw_data, slices, slice_bits, start, stride);
		} else {
			if(slice_bits <= 8)
				return bitslice1_sub<uint8_t>(raw_data, slices, slice_bits, start, stride);
			else if(slice_bits <= 16)
				return bitslice1_sub<uint16_t>(raw_data, slices, slice_bits, start, stride);
			else if(slice_bits <= 32)
				return bitslice1_sub<uint32_t>(raw_data, slices, slice_bits, start, stride);
			else
				return bitslice1_sub<uint64_t>(raw_data, slices, slice_bits, start, stride);
		}
	}
	
	static py::array bitslice2(py::array_t<limb_t> raw_data, py::array_t<size_t> slice_bits, py::array_t<size_t> offsets, bool signed_) {
		if(raw_data.ndim() != 2)
			throw std::runtime_error("Raw data array should be 2-dimensional");
		if(raw_data.shape(1) == 0)
			throw std::runtime_error("Raw data array should have at least one column");
		if(slice_bits.ndim() != 1)
			throw std::runtime_error("Slice bits array should be 1-dimensional");
		if(slice_bits.shape(0) == 0)
			throw std::runtime_error("Slice bits array should have at least one element");
		size_t slices = slice_bits.shape(0);
		if(offsets.ndim() != 1)
			throw std::runtime_error("Offsets array should be 1-dimensional");
		if(offsets.shape(0) != slices)
			throw std::runtime_error("Offsets array should have the same length as slice bits");
		auto slice_bits_view = slice_bits.template unchecked<1>();
		auto offsets_view = offsets.template unchecked<1>();
		size_t total_bits = N * raw_data.shape(1);
		if(slices < 1 || slices > total_bits || slices > std::numeric_limits<py::ssize_t>::max())
			throw std::runtime_error("Invalid number of slices");
		size_t max_slice_bits = 0;
		for(size_t i = 0; i < slices; ++i) {
			size_t current_slice_bits = slice_bits_view(i);
			size_t current_offset = offsets_view(i);
			if(current_slice_bits < 1 || current_slice_bits > 64)
				throw std::runtime_error("Invalid number of slice bits");
			if(current_offset >= total_bits || current_slice_bits > total_bits - current_offset)
				throw std::runtime_error("The number of raw data columns is too small to produce the requested slices");
			if(current_slice_bits > max_slice_bits)
				max_slice_bits = current_slice_bits;
		}
		if(signed_) {
			if(max_slice_bits <= 8)
				return bitslice2_sub<int8_t>(raw_data, slice_bits, offsets);
			else if(max_slice_bits <= 16)
				return bitslice2_sub<int16_t>(raw_data, slice_bits, offsets);
			else if(max_slice_bits <= 32)
				return bitslice2_sub<int32_t>(raw_data, slice_bits, offsets);
			else
				return bitslice2_sub<int64_t>(raw_data, slice_bits, offsets);
		} else {
			if(max_slice_bits <= 8)
				return bitslice2_sub<uint8_t>(raw_data, slice_bits, offsets);
			else if(max_slice_bits <= 16)
				return bitslice2_sub<uint16_t>(raw_data, slice_bits, offsets);
			else if(max_slice_bits <= 32)
				return bitslice2_sub<uint32_t>(raw_data, slice_bits, offsets);
			else
				return bitslice2_sub<uint64_t>(raw_data, slice_bits, offsets);
		}
	}
	
	static py::array bitslice3(py::array_t<limb_t> raw_data, py::array_t<size_t> slice_bits, bool signed_) {
		if(slice_bits.ndim() != 1)
			throw std::runtime_error("Slice bits array should be 1-dimensional");
		if(slice_bits.shape(0) == 0)
			throw std::runtime_error("Slice bits array should have at least one element");
		size_t slices = slice_bits.shape(0);
		py::array_t<size_t, py::array::c_style> offsets{py::ssize_t(slices)};
		auto slice_bits_view = slice_bits.template unchecked<1>();
		auto offsets_view = offsets.template mutable_unchecked<1>();
		size_t current_offset = 0;
		for(size_t i = 0; i < slices; ++i) {
			offsets_view(i) = current_offset;
			current_offset += slice_bits_view(i);
		}
		return bitslice2(raw_data, slice_bits, offsets, signed_);
	}
	
	// Python bindings generation
	
	static py::object python_bindings(py::module_ &m, const char *class_name) {
		py::object c = py::class_<xormix_pycpp>(m, class_name, "Xormix PRNG instance")
			.def(py::init<size_t>(), "Creates a new PRNG instance.",
				py::arg("streams"))
			.def(py::init<size_t, const py::int_&>(), "Creates a new PRNG instance with a given state.",
				py::arg("streams"), py::arg("state"))
			.def("copy",  [](const xormix_pycpp &self) { return xormix_pycpp(self); }, "Creates a copy of the PRNG instance.")
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
			.def("generate", &xormix_pycpp::generate, "Generates multiple cycles of bitsliced output as a numpy array.",
				py::arg("cycles"), py::arg("slices"), py::arg("slice_bits"), py::arg("signed") = false)
			.def("generate_raw", &xormix_pycpp::generate_raw, "Generates multiple cycles of raw output as a numpy array.",
				py::arg("cycles"))
			.def_static("bitslice", &xormix_pycpp::bitslice1, "Bitslices a numpy array using fixed bit widths.",
				py::arg("raw_data"), py::arg("slices"), py::arg("slice_bits"), py::arg("signed") = false, py::arg("start") = 0, py::arg("stride") = 0)
			.def_static("bitslice", &xormix_pycpp::bitslice2, "Bitslices a numpy array using arbitrary bit widths and offsets.",
				py::arg("raw_data"), py::arg("slice_bits"), py::arg("offsets"), py::arg("signed") = false)
			.def_static("bitslice", &xormix_pycpp::bitslice3, "Bitslices a numpy array using arbitrary bit widths, assuming dense packing.",
				py::arg("raw_data"), py::arg("slice_bits"), py::arg("signed") = false);
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
