Randomness Test Results
=======================

*Randomness testing is still in progress, I will update this page as more results come in.*

This page lists randomness test results of xormix produced by two state-of-the-art randomness test suites, [PractRand](http://pracrand.sourceforge.net/) and [TestU01](http://simul.iro.umontreal.ca/testu01/tu01.html).

Here's a short summary of the results:

- Some flaws were detected in xormix16 and xormix24 (especially when used with a small number of streams). This is expected due to their small state size, which is why they should not be used in applications that require high quality randomness.
- No statistically significant flaws were detected in xormix32 and above.

PractRand (pre0.95) results
---------------------------

PractRand uses an incremental testing strategy: rather than analyzing a fixed amount of data and reporting whether it has detected a flaw, it analyzes increasingly larger amounts of data until it eventually detects a problem. The amount of data it needed to analyze to detect this problem can be seen as a kind of quality metric. It is expected that a PRNG will fail once the amount of analyzed data approaches the period of the PRNG, so even a perfect PRNG with a 16-bit state would fail after about 2^16 bits (i.e. 2^13 bytes), whereas a PRNG with a 32-bit state would fail after about 2^32 bits (i.e. 2^29 bytes). This does not signify a flaw in the PRNG, it's just an inherent limitation of PRNGs with a small state.

Since these tests can potentially run forever if the PRNG doesn't produce any failures, I had to cut them off at some point. I limited the tests most configurations to 2^36 bytes (which takes about 20 minutes per test), with a few exceptions (such as xormix32 with 1 stream, for which I analyzed 2^46 bytes, which took about two weeks).

| Variant   | Streams | First failure at | Failed test       | P-value | Verdict |
| --------- | ------- | ---------------- | ----------------- | ------- | ------- |
| xormix16  | 1       | 2^29 bytes       | FPF-14+6/16:all   | 8.9e-21 | FAIL    |
|           | 2       | 2^37 bytes       | DC6-9x1Bytes-1    | 7.9e-16 | FAIL    |
|           | 4       | 2^39 bytes       | DC6-9x1Bytes-1    | 7.2e-17 | FAIL    |
|           | 8       | > 2^36 bytes     | none              |         | PASS    |
|           | 16      | > 2^36 bytes     | none              |         | PASS    |
| xormix24  | 1       | 2^46 bytes       | FPF-14+6/16:all   | 1.4e-23 | FAIL    |
|           | 2       | > 2^36 bytes     | none              |         | PASS    |
|           | 4       | > 2^36 bytes     | none              |         | PASS    |
|           | 8       | > 2^36 bytes     | none              |         | PASS    |
|           | 16      | > 2^36 bytes     | none              |         | PASS    |
| xormix32  | 1       | > 2^46 bytes     | none              |         | PASS    |
|           | 2       | > 2^36 bytes     | none              |         | PASS    |
|           | 4       | > 2^36 bytes     | none              |         | PASS    |
|           | 8       | > 2^36 bytes     | none              |         | PASS    |
|           | 16      | > 2^36 bytes     | none              |         | PASS    |
| xormix48  | 1       | > 2^36 bytes     | none              |         | PASS    |
|           | 2       | > 2^36 bytes     | none              |         | PASS    |
|           | 4       | > 2^36 bytes     | none              |         | PASS    |
|           | 8       | > 2^36 bytes     | none              |         | PASS    |
|           | 16      | > 2^36 bytes     | none              |         | PASS    |
| xormix64  | 1       | > 2^43 bytes     | none              |         | PASS    |
|           | 2       | > 2^36 bytes     | none              |         | PASS    |
|           | 4       | > 2^36 bytes     | none              |         | PASS    |
|           | 8       | > 2^36 bytes     | none              |         | PASS    |
|           | 16      | > 2^36 bytes     | none              |         | PASS    |
| xormix96  | 1       | > 2^36 bytes     | none              |         | PASS    |
|           | 2       | > 2^36 bytes     | none              |         | PASS    |
|           | 4       | > 2^36 bytes     | none              |         | PASS    |
|           | 8       | > 2^36 bytes     | none              |         | PASS    |
|           | 16      | > 2^36 bytes     | none              |         | PASS    |
| xormix128 | 1       | > 2^36 bytes     | none              |         | PASS    |
|           | 2       | > 2^36 bytes     | none              |         | PASS    |
|           | 4       | > 2^36 bytes     | none              |         | PASS    |
|           | 8       | > 2^36 bytes     | none              |         | PASS    |
|           | 16      | > 2^36 bytes     | none              |         | PASS    |

TestU01 (1.2.3) results
-----------------------

TestU01 is probably the most widely used randomness test suite. Unfortunately it only supports 32-bit PRNGs, so for xormix variants other than xormix32 I concatenated the outputs to produce a continuous bit stream, which I then split into 32-bit values for TestU01.

TestU01 has a much higher false-positive rate than PractRand: TestU01 will mark a test as failed if it has a p-value below 0.001 or above 0.999, which results in a false positive rate of 0.2% per test. However since each test battery contains many tests, the overall false positive rate is much higher:

- The 'SmallCrush' test battery contains 15 tests, resulting in a false positive rate of 2.96%.
- The 'Crush' test battery contains 144 tests, resulting in a false positive rate of 25.0%.
- The 'BigCrush' test battery contains 160 tests, resulting in a false positive rate of 27.4%.

This means that some post-processing is required to filter out the false positives and get reliable results. I do this by running each test battery 4 times for each configuration, and comparing the results. If a specific test fails in one or two of the runs but not in the others, and it has a reasonably high p-value, it is likely a false positive. In contrast, if the same test fails consistently in all 4 runs, or if it fails with a very low p-value (let's say below 1e-9), then it is probably a real failure. Usually the results are fairly unambiguous, since actual failures tend to produce extremely low p-values. The results below include the p-value for each failed test, so you can judge for yourself whether my verdict is reasonable.

As an extra sanity check, I also ran the same test batteries against `/dev/urandom` using the same procedure (which also resulted in several false positives).

Note: A p-value of zero means that the actual p-value was below the machine precision (either 1e-300 or 1e-15 depending on the type of test).

### 'SmallCrush' test battery

| Variant      | Streams | Fails          | Actual failed tests                                                            | Likely false positives                                                                  | Verdict |
| ------------ | ------- | -------------- | ------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- | ------- |
| xormix16     | 1       | 1, 1, 1, 1     | BirthdaySpacings (4x, p=0)                                                     |                                                                                         | FAIL    |
|              | 2       | 1, 0, 0, 0     |                                                                                | Gap (p=4e-4)                                                                            | PASS    |
|              | 4       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 8       | 1, 0, 0, 0     |                                                                                | CouponCollector (p=2e-4)                                                                | PASS    |
|              | 16      | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
| xormix24     | 1       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 2       | 0, 0, 1, 0     |                                                                                | RandomWalk1 R (p=1e-3)                                                                  | PASS    |
|              | 4       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 8       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 16      | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
| xormix32     | 1       | 1, 0, 0, 0     |                                                                                | RandomWalk1 R (p=4e-4)                                                                  | PASS    |
|              | 2       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 4       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 8       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 16      | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
| xormix48     | 1       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 2       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 4       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 8       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 16      | 0, 1, 0, 0     |                                                                                | BirthdaySpacings (p=4e-4)                                                               | PASS    |
| xormix64     | 1       | 1, 0, 0, 0     |                                                                                | RandomWalk1 C (p=5e-4)                                                                  | PASS    |
|              | 2       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 4       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 8       | 0, 1, 0, 0     |                                                                                | WeightDistrib (p=3e-4)                                                                  | PASS    |
|              | 16      | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
| xormix96     | 1       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 2       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 4       | 0, 0, 1, 0     |                                                                                | Gap (p=2e-4)                                                                            | PASS    |
|              | 8       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 16      | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
| xormix128    | 1       | 1, 0, 0, 0     |                                                                                | CouponCollector (p=8e-4)                                                                | PASS    |
|              | 2       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 4       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 8       | 0, 0, 0, 1     |                                                                                | CouponCollector (p=6e-4)                                                                | PASS    |
|              | 16      | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
| /dev/urandom | n/a     | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |

### 'Crush' test battery

| Variant      | Streams | Fails          | Actual failed tests                                                            | Likely false positives                                                                  | Verdict |
| ------------ | ------- | -------------- | ------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- | ------- |
| xormix16     | 1       | 11, 11, 10, 11 | SerialOver (4x, p=0), CollisionOver (8x, p=0), BirthdaySpacings (4x, p=0), ... |                                                                                         | FAIL    |
|              | 2       | 1, 1, 3, 1     | BirthdaySpacings (4x, p=3e-53...2e-47)                                         | RandomWalk1 M (p=4e-4), MatrixRank (p=5e-4)                                             | FAIL    |
|              | 4       | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
|              | 8       | 0, 1, 0, 0     |                                                                                | ClosePairs NJumps (p=9e-4)                                                              | PASS    |
|              | 16      | 0, 0, 0, 1     |                                                                                | SampleProd (p=6e-4)                                                                     | PASS    |
| xormix24     | 1       | 1, 1, 0, 1     |                                                                                | BirthdaySpacings (p=1e-3), ClosePairs mNP2 (p=6e-4), RandomWalk1 H (p=2e-4)             | PASS    |
|              | 2       | 1, 0, 0, 1     |                                                                                | Run of U01 (p=5e-4), RandomWalk1 H (p=1e-4)                                             | PASS    |
|              | 4       | 0, 1, 0, 0     |                                                                                | RandomWalk1 R (p=6e-4)                                                                  | PASS    |
|              | 8       | 0, 1, 0, 0     |                                                                                | CollisionOver (p=8e-4)                                                                  | PASS    |
|              | 16      | 0, 1, 0, 0     |                                                                                | LongestHeadRun (p=1e-4)                                                                 | PASS    |
| xormix32     | 1       | 0, 0, 0, 2     |                                                                                | CollisionOver (p=4e-4), CouponCollector (p=7e-4)                                        | PASS    |
|              | 2       | 3, 0, 0, 0     |                                                                                | Run of bits (p=1e-4), HammingWeight2 (p=3e-4), CollisionOver (p=7e-4)                   | PASS    |
|              | 4       | 1, 0, 0, 1     |                                                                                | AutoCor (p=6e-4), RandomWalk1 M (p=6e-6)                                                | PASS    |
|              | 8       | 3, 0, 0, 1     |                                                                                | Permutation (p=6e-5), BirthdaySpacings (p=1e-4), Savir2 (p=1e-4), HammingIndep (p=3e-4) | PASS    |
|              | 16      | 0, 0, 1, 0     |                                                                                | AppearanceSpacings (p=8e-4)                                                             | PASS    |
| xormix48     | 1       | 1, 0, 1, 0     |                                                                                | ClosePairs NJumps (p=2e-5), RandomWalk1 R (p=9e-4)                                      | PASS    |
|              | 2       | 1, 0, 0, 0     |                                                                                | MatrixRank (p=9e-4)                                                                     | PASS    |
|              | 4       | 2, 0, 0, 0     |                                                                                | CollisionOver (p=6e-5), RandomWalk1 C (p=6e-4)                                          | PASS    |
|              | 8       | 1, 0, 0, 0     |                                                                                | LongestHeadRun (p=7e-4)                                                                 | PASS    |
|              | 16      | 1, 0, 0, 0     |                                                                                | SimpPoker (p=7e-4)                                                                      | PASS    |
| xormix64     | 1       | 0, 1, 0, 1     |                                                                                | BirthdaySpacings (p=3e-5), CollisionOver (p=1e-4)                                       | PASS    |
|              | 2       | 1, 0, 0, 0     |                                                                                | BirthdaySpacings (p=2e-4)                                                               | PASS    |
|              | 4       | 0, 0, 0, 1     |                                                                                | GCD (p=4e-4)                                                                            | PASS    |
|              | 8       | 0, 0, 0, 1     |                                                                                | MaxOft AD (p=7e-4)                                                                      | PASS    |
|              | 16      | 0, 0, 0, 0     |                                                                                |                                                                                         | PASS    |
| xormix96     | 1       |                |                                                                                |                                                                                         |         |
|              | 2       |                |                                                                                |                                                                                         |         |
|              | 4       |                |                                                                                |                                                                                         |         |
|              | 8       |                |                                                                                |                                                                                         |         |
|              | 16      |                |                                                                                |                                                                                         |         |
| xormix128    | 1       |                |                                                                                |                                                                                         |         |
|              | 2       |                |                                                                                |                                                                                         |         |
|              | 4       |                |                                                                                |                                                                                         |         |
|              | 8       |                |                                                                                |                                                                                         |         |
|              | 16      |                |                                                                                |                                                                                         |         |
| /dev/urandom | n/a     | 1, 2, 0, 0     |                                                                                | BirthdaySpacings (p=4e-4), SerialOver (p=5e-4), Gap (p=1e-3)                            | PASS    |

### 'BigCrush' test battery

Since these tests are very slow (about 9 hours each), I have limited the list to the most interesting configurations.

| Variant      | Streams | Fails          | Actual failed tests                                                            | Likely false positives                                                                  | Verdict |
| ------------ | ------- | -------------- | ------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- | ------- |
| xormix24     | 1       |                |                                                                                |                                                                                         |         |
|              | 2       |                |                                                                                |                                                                                         |         |
| xormix32     | 1       | 1, 0, 0, 0     |                                                                                | RandomWalk1 H (p=8e-4)                                                                  | PASS    |
|              | 2       | 1, 1, 0, 1     |                                                                                | BirthdaySpacings (p=3e-4), CollisionOver (p=6e-4), ClosePairs NP (p=8e-4)               | PASS    |
| xormix48     | 1       |                |                                                                                |                                                                                         |         |
|              | 2       |                |                                                                                |                                                                                         |         |
| xormix64     | 1       | 1, 1, 0, 0     |                                                                                | LinearComp (p=3e-4), RandomWalk1 R (p=7e-4)                                             | PASS    |
|              | 2       |                |                                                                                |                                                                                         |         |
| xormix96     | 1       |                |                                                                                |                                                                                         |         |
|              | 2       |                |                                                                                |                                                                                         |         |
| xormix128    | 1       |                |                                                                                |                                                                                         |         |
|              | 2       |                |                                                                                |                                                                                         |         |
| /dev/urandom | n/a     | 0, 0, 2, 1     |                                                                                | RandomWalk1 R (p=4e-4), PeriodsInStrings (p=8e-4), ClosePairs (p=6e-4)                  | PASS    |
