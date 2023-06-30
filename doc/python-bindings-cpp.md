Python Bindings of Xormix C++ Implementation
============================================

The python module `xormix_pycpp` provides a convenient interface to the C++ xormix implementation, which is much faster than the reference implementation. These bindings are created with [pybind11](https://github.com/pybind/pybind11) and can be found in the `cpp/pycpp` directory. In order to build the python bindings, the option `-DBUILD_PYTHON=ON` must be passed to `cmake`:

```
cp <xormix_directory>/cpp
mkdir build-release
cd build-release
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_PYTHON=ON ..
make
```

After compilation, the build directory must be added to the python path so python can find the compiled `xormix_pycpp` module:

```
export PYTHONPATH=<xormix_directory>/cpp/build-release
```

Usage Example
-------------

### Basic usage

This example shows how to create a xormix64 PRNG instance, seed it, and generate random data as a Numpy array.

```python
import xormix_pycpp
 
# Create an instance of the PRNG
xm = xormix_pycpp.xormix64(streams=4)
 
# Seed the PRNG (this can be repeated as often as needed)
xm.seed_simple(seed_x=0x1122334455667788, seed_y=0xaaaabbbbccccdddd)
 
# Generate random numbers (this produces a 50x20 numpy array containing 10-bit numbers)
res = xm.generate(cycles=50, slices=20, slice_bits=10, signed=False)
```

### Custom bit slicing

If your hardware does more complicated bit slicing on the xormix output, the basic `generate` function may not do what you want. You can instead use `generate_raw` combined with `bitslice` to do custom bit slicing.

```python
# Generate raw random data (this produces a 50x4 numpy array containing 64-bit numbers)
raw = xm.generate_raw(cycles=50)
 
# Slice the raw data into several arrays
# (bitslice is a static function, so you can also use xormix_pycpp.xormix64.bitslice instead)
res1 = xm.bitslice(raw, slices=10, slice_bits=7, signed=False)
res2 = xm.bitslice(raw, slices=15, slice_bits=3, signed=False, start=70)
res3 = xm.bitslice(raw, slices=12, slice_bits=5, signed=True, start=115, stride=9)
res4 = xm.bitslice(raw, slices=12, slice_bits=4, signed=True, start=120, stride=9)
```

API Reference
-------------

The `xormix_pycpp` module contains 7 classes which implement different xormix variants:

- xormix16
- xormix24
- xormix32
- xormix48
- xormix64
- xormix96
- xormix128

All classes have the same API. For convenience the module also provides a `xormix` dict which contains the same classes, so for example `xormix_pycpp.xormix[32]` is equivalent to `xormix_pycpp.xormix32`.

### class xormix*N*(streams : int [, state : int])

Creates a new xormix*N* PRNG instance. `streams` specifies the number of streams, ranging from 1 to *N*. The optional argument `state` can be used to initialize the instance to a given state (the format matches the `state` property).

### xormix*N*.streams : int (read-only property)

This property holds the number of streams of the PRNG.

### xormix*N*.state : int (read/write property)

This property holds the state of the PRNG. The lowest *N* bits contain *state_x*, the *N* bits above those contain *state_y[0]*, the *N* bits above those contain *state_y[1]* and so on. This property is writable, so it is possible to save the state and restore it later.

### xormix*N*.output : int (read-only property)

This property holds the current output of the PRNG. The lowest *N* bits contain *state_y[0]*, the *N* bits above those contain *state_y[1]*, and so on.

### xormix*N*.copy()

Creates a copy of the PRNG instance.

### xormix*N*.seed_full(seed_x : int, seed_y : int)

Seeds the PRNG using the full seeding procedure. `seed_x` should contain *N* bits, `seed_y` should contain *N* * `streams` bits.

### xormix*N*.seed_simple(seed_x : int, seed_y : int)

Seeds the PRNG using the simplified seeding procedure. Both `seed_x` and `seed_y` should contain *N* bits.

### xormix*N*.forward(cycles : int)

Forwards the PRNG by the given number of cycles.

### xormix*N*.rewind(cycles : int)

Rewinds the PRNG by the given number of cycles.

### xormix*N*.generate(cycles : int, slices : int, slice_bits : int, signed : bool = False)

Generates multiple cycles of bitsliced output as a numpy array. `cycles` specifies the number of cycles of output that will be generated, and corresponds to the number of rows of the returned array. `slices` specifies the number of slices that will be extracted from the raw output, and corresponds to the number of columns of the returned array. `slice_bits` specifies the number of bits per slice, which can be up to 64 bits. `signed` specifies whether the sliced bits should be interpreted as signed numbers.

### xormix*N*.generate_raw(cycles : int)

Generates multiple cycles of raw output as a numpy array. `cycles` specifies the number of cycles of output that will be generated, and corresponds to the number of rows of the returned array. For *N* <= 64, the returned array contains one column per stream. For *N* > 64, the returned array contains two columns per stream, and the bits of each stream will be divided equally between these two columns. So for xormix96 each column will contain 48 bits of data.

### xormix*N*.bitslice(raw_data : numpy.ndarray, slices : int, slice_bits : int, signed : bool = False, start : int = 0, stride : int = 0)

Bitslices a raw output array in a more flexible way. The format of `raw_data` should match the format returned by `generate_raw`, however the number of columns may be different (this allows combining the output of multiple xormix instances). `slices`, `slice_bits` and `signed` behave the same as the corresponding arguments of the `generate` function. `start` specifies the index of the first bit that will be used (this can be used to extract multiple values with different bit widths). `stride` specifies by how much the bit index should be incremented to go to the next slice (this can be used to extract interleaved values). If `stride` is 0 (the default), it is set to `slice_bits`.

This is a static method, so it is not necessary to create a PRNG instance to use it.

### xormix*N*.REVISION : int (class attribute)

This class attribute holds the implemented revision of the xormix algorithm (to avoid confusion in case the xormix algorithm is changed in the future).
