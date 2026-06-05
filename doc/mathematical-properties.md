Mathematical Properties of Xormix Variants
==========================================

This page lists the 'magic constants' and the resulting mathematical properties of each of the xormix variants:

- [Xormix16](mathematical-properties-xormix16.md)
- [Xormix24](mathematical-properties-xormix24.md)
- [Xormix32](mathematical-properties-xormix32.md)
- [Xormix48](mathematical-properties-xormix48.md)
- [Xormix64](mathematical-properties-xormix64.md)
- [Xormix96](mathematical-properties-xormix96.md)
- [Xormix128](mathematical-properties-xormix128.md)

These pages are just raw data dumps. The [Xormix Algorithm](algorithm.md) page explains the usage of these values.

LFSR decomposition
------------------

The LFSR decomposition works as follows. The state-transition matrix A can be decomposed into:

    A = U * P * V

Where `V` is the inverse of `U`, and `P` is the state-transition matrix of an LFSR in Galois form:

    [0 0 0 ... 0 poly[  0]]
    [1 0 0 ... 0 poly[  1]]
    [0 1 0 ... 0 poly[  2]]
    [0 0 1 ... 0 poly[  3]]
    [ ...          ...    ]
    [0 0 0 ... 1 poly[N-1]]

And `poly` is the characteristic polynomial of the LFSR. Since `U * V = I`, we know that:

    A^k * seed = U * P^k * V * seed

We can efficiently calculate `P^k * seed` since it corresponds to calculating `2^k * seed mod poly`. The matrices `U` and `V` provide a mapping between the xormix state and the state of an equivalent LFSR, which allows us to analyze the properties of the first stage of the xormix PRNG using (polynomial-based) Galois fields, which is much more efficient than using binary matrices, especially for calculating discrete logarithms.
