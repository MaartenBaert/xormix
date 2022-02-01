Xormix Design Criteria
======================

The design goals of the xormix pseudorandom number generator were as follows:

- The PRNG output should be of sufficiently high quality to pass randomness tests such as [PractRand](http://pracrand.sourceforge.net/).
- The PRNG should be cheap to implement in hardware, in both FPGAs an ASICs.
- The period of the PRNG should be adjustable such that designers can make a tradeoff between the quality of randomness required and the hardware cost.
- The PRNG should be able to efficiently generate large numbers of bits in parallel each clock cycle.
- It should be possible to run multiple instances of the PRNG in parallel without risk of correlation between them.

Background
----------

Before diving into the specific design decisions behind the xormix PRNG, I need to present some background information necessary to understand these decisions.

### Software vs hardware cost

There are many good open-source PRNGs available, however nearly all of these are optimized for software use rather than hardware use. This matters because the cost of some operations is dramatically different in software than in hardware, and unfortunately most good open-source PRNG designs rely on operations which are inefficient in hardware. For example, in software the cost of addition and multiplication is effectively the same on most modern processors, whereas in hardware the cost of an `N`-bit multiplication is approximately `N` times greater than the cost of an `N`-bit addition. That is unfortunate, because many good PRNGs rely heavily on multiplication.

In contrast, some operations which are very expensive in software are extremely cheap in hardware. For example, reordering the bits of an `N`-bit number in some arbitrary way is a very slow operation in software, because it can only be done using lots of bitshift and masking operations. However in hardware, bits are just wires, so reordering bits just means connecting the wires in a different order, which is practically free. We can take advantage of these types of operations to design PRNGs that are much more efficient in hardware.

There aren't that many publicly known hardware-optimized PRNGs. I'm sure that many designs exist, but the companies that develop them tend not to publish their designs. I am aware of only one popular publicly known PRNG that is efficient in hardware, and that is the classic [LFSR](https://en.wikipedia.org/wiki/Linear-feedback_shift_register). Although LFSRs have useful properties, they also have a number of issues that make them a poor choice for a general-purpose PRNG, which I will discuss later.

It is worth noting that there are several publicly known cryptographically secure PRNGs that are optimized for hardware, such as the ones used in various wireless communication standards, or the [Trivium](https://en.wikipedia.org/wiki/Trivium_%28cipher%29) stream cipher. These are excellent quality PRNGs, however they are also quite expensive in terms of hardware cost. Xormix is not designed to be cryptographically secure, and should not be used for applications where the random output is being used for security purposes.

### State size vs logic complexity

The state size of a PRNG is the number of bits of state that it needs to store. We typically want to keep the state size reasonably small, since storing more state is costly. However if we make the state too small, it will affect the quality of the PRNG output. If a PRNG has a state size of `N` bits, it has at most `2^N` unique states, which means that after at most `2^N` cycles, the PRNG will end up in a state it has been in before, and it will start repeating itself. At that point the output is clearly no longer random. The number of cycles it takes for the PRNG to start repeating itself is known as the period of the PRNG. We want this period to be as close as possible to the `2^N` upper bound. If the period of a PRNG is much smaller than this upper bound, it suggests that the underlying design is flawed, or at least suboptimal.

The minimum allowable period is application-dependent: for some very simple applications, a period as short as `2^16` may be sufficient. For typical applications, `2^32` is more reasonable. A period of `2^64` is almost certainly more than any application will ever need, since even at a clock speed of 10GHz it would take 58 years to exceed this period. Xormix is designed to have a configurable minimum period, giving the designer the freedom to choose the implementation that best fits the requirements of the application.

Although we generally want to minimize the state size, there is a tradeoff involved here: in order to achieve high quality random output with a small state size, we need to use relatively complex operations to mix up the state bits sufficiently to make the output of the PRNG look random. If we instead choose a state size which is somewhat larger than necessary, we can reduce the complexity of the mixing operations. In software, it often makes sense to minimize the state size, since accessing memory is typically much slower than doing a few extra operations such as multiplication. However in hardware this is different, because the flip-flops that are used as storage elements are relatively cheap, whereas operations such as multiplication are quite expensive. So in hardware it makes a lot of sense to increase the state size a bit in order to reduce the complexity of the logic.

There is another aspect to consider here. For practical reasons that I won't get into, it is very common in hardware implementations to store the output of the PRNG in a series of flip-flops before sending it to the next hardware block. Since these output flip-flops are present anyway, we can use the previous output of the PRNG as state bits without actually increasing the total number of flip-flops.

### State-transition function vs output function

Most PRNGs can be split into two parts:
- A state-transition function which takes the current state of the PRNG as its input, and calculates the next state.
- An output function which takes either the current or next state of the PRNG as its input, and calculates the output bits.

Most PRNGs use a very simple output function, or no output function at all (meaning they just output their state directly), and a more complicated state-transition function to provide sufficient randomness. Other PRNGs use a very simple state-transition function (such as a counter), and a complicated output function that mixes the state bits very thoroughly so the output still looks random. And yet other PRNGs use some combination of these two strategies.

From a hardware perspective, it is appealing to drop the output function entirely, since this makes it possible to re-use the output flip-flops as state flip-flops, as discussed earlier. Xormix uses this approach. However xormix uses a two-stage design, and only outputs the state of the second stage - it does not output then entire state. Since the second stage uses the state of the first stage as its input and mixes it up further, it fulfills largely the same purpose as the output function does in a conventional single-stage design.

### Linear vs nonlinear PRNGs

Some PRNGs are said to be 'linear', which essentially means that their state-transition function and output functions satisfy certain mathematical properties that make them easy to analyze. This is often convenient, because it makes it possible to calculate some properties of the PRNG mathematically, most notably the period. Some examples of linear PRNGs are [LFSRs](https://en.wikipedia.org/wiki/Linear-feedback_shift_register), [LCGs](https://en.wikipedia.org/wiki/Linear_congruential_generator) and [xorshift](https://en.wikipedia.org/wiki/Xorshift).

Linear PRNGs are well understood mathematically, and they can be designed to have a period very close to the theoretical maximum, such as `2^N` (for LCGs) or `2^N-1` (for LFSRs and xorshift), without having to actually simulate the PRNG for `2^N` cycles to prove this. To some extent it is also possible to predict mathematically which parameters will produce high-quality random output.

In contrast, nonlinear PRNGs do not have such nice mathematical properties, and their behavior is much more chaotic. This makes it much harder to predict how they will behave, and which nonlinear designs will produce the highest quality random output. It is still possible to make some statistical predictions about nonlinear PRNGs, but there is usually no easy way to predict which parameters will produce high-quality output and which ones will not. Instead we have to rely on lots of brute-force simulations, which makes the design of nonlinear PRNGs a lot more difficult.

Linear PRNGs clearly have a lot of design advantages, however they have one major weakness: since their structure is completely linear, their output exhibits linear properties that can be very easily detected by randomness tests, particularly the binary matrix rank test. This test uses the PRNG to fill a matrix with binary data, and then calculates the rank of the matrix. Linear PRNGs fail this test dramatically, because the rows of the matrix are all linear combinations of a small fixed set of basis vectors. To be fair, for most real-world applications this is probably not an issue. Still, it seems like a good idea to incorporate some nonlinearity into the PRNG design to avoid this issue.

### Invertible vs non-invertible state-transition functions

Since nonlinear state-transition functions can not be easily analyzed mathematically, we need to rely on statistical methods instead. As it turns out, the statistical properties of a nonlinear PRNG depend strongly on whether the state-transition function is invertible or not.

An invertible function is a function that maps each input to exactly one unique output, i.e. there are no two inputs that will produce the same output, and each output will appear exactly once. In contrast, a non-invertible function may produce the same output for multiple inputs, and some outputs may never appear at all. This has a big impact on the statistical properties of the PRNG. If a non-invertible state-transition function is used, the number of possible states that the PRNG can be in decreases with each iteration, because some states can be reached in more than one way while other state can not be reached at all. After a while, the PRNG will usually get stuck in a relatively short loop that repeats forever, and at that point the PRNG is clearly no longer random. In contrast, PRNGs that use an invertible state-transition function do not suffer from this issue, since all possible states remain reachable regardless of the number of iterations.

The expected period of an N-bit PRNG based on a good invertible state-transition function is `2^(N-1)`, which is fairly good. However for a non-invertible state-transition function, the expected period is only roughly `2^(N/2)`, as a consequence of the [birthday paradox](https://en.wikipedia.org/wiki/Birthday_problem). Note that these are just the average expected periods - the actual period may occasionally be much lower or much higher. Still, it is clear that invertible state-transition functions are a much better choice than non-invertible ones.

More information on this subject can be found in [this article](https://www.pcg-random.org/posts/random-invertible-mapping-statistics.html).

### Avalanche testing

Since nonlinear PRNGs can't be easily evaluated using straightforward mathematics, it is hard to find optimal parameter values for nonlinear PRNG designs. We can try to pick parameters randomly and then run a suite of randomness tests like [PractRand](http://pracrand.sourceforge.net/) on the resulting output to get a sense of how random it is, however this method is extremely slow, especially for PRNGs with a large state size. If we want to find parameter values that are not just acceptable but actually close to optimal, we need a better method to evaluate such nonlinear PRNGs.

One such method is avalanche testing. This technique is apparently not very well known, but I found quite some useful information in [this article](http://burtleburtle.net/bob/rand/talksmall.html). The idea behind avalanche testing is basically to test how long it takes for a single flipped bit in the PRNG state to propagate and affect all the other state bits. We do this by creating two instances of the PRNG which are initialized to the same random state, except one randomly selected bit is flipped. Then we run both instances for a very small number of cycles, and compare the end states. Ideally these should look completely different, with each state bit having a 50/50 chance of being flipped. If there are obvious similarities between the two states, it means that the state-transition function did not do a very good job mixing the state bits up. The better the state-transition function is at mixing bits, the less cycles it will need to produce random-looking end states from a single bit flip.

The method described in the article above simply counts the number of flipped bits in the end states and tries to maximize this. I found that this method does not always work well, especially for testing over a larger number of cycles. It seemed that simply maximizing the number of flipped bits is not a good way to maximize randomness, because in some cases the algorithm optimized too far and ended up producing parameters that created bit flips with probabilities much greater than 50%. This is actually worse, because two truly random states would on average result in only 50% differing bits. So instead of simply maximizing the number of flipped bits, I instead analyzed the distribution of the number of flipped bits and tried to make it match the expected binomial distribution (as evaluated by a chi-squared test). This essentially turns the avalanche test into a tiny randomness test similar to the DC6 test in PractRand. In my experience this worked a lot better and produced avalanche results that agreed better with actual PractRand results (that is, parameters with good avalance results also achieved good PractRand results).

This method is still relatively slow, especially if we want to find very weak biases over a larger number of cycles, which may require millions or even billions of trials. But it is still much faster than regular randomness testing. With this method it is feasible to exhaustively test all possible parameter value combinations, which is what I did for xormix.

The avalanche testing code I used can be found in `cpp/design/avalanche.cpp` and `python/design/avalanche_test.py`.

### Uniformly distributed seeds

It is often useful or even necessary to run multiple instances of the same PRNG in parallel, either because the amount of bits required per cycle is too high for a single PRNG, or because the random data is needed in more than one place on the FPGA or ASIC, and it is impractical to route the output of a single PRNG to all locations due to excessive congestion or routing delays. In such situations it is important to ensure that the PRNGs are initialized in such a way that there is no unintended correlation between them.

If the seeds of multiple PRNGs are chosen randomly, there is a small chance that the seeds correspond to states that are close together within the period of the PRNG, such that after a while one of the PRNGs starts producing output that has already been produced earlier by another PRNG, long before the PRNG reaches its full period. I call this a collision.

The probability that this will happen with just two instances of the PRNG is fairly low. For example, for two instances of an `N`-bit PRNG there is a probability of about `2^(1-N/2)` that the two instances will collide within less than `2^(N/2)` cycles, assuming that the PRNG has a period of about `2^N` cycles. However this probability increases quadratically with the number of instances of the PRNG due to the [birthday paradox](https://en.wikipedia.org/wiki/Birthday_problem), so if the number of PRNG instances is large, it can become a serious concern.

A possible solution is to pick a PRNG with an exceptionally large period, such that the probability of collisions remains low even with a large number of instances. However this increases the hardware cost. A better solution is to pick the seeds of the PRNG instances in a specific way such that they are guaranteed to be uniformly distributed across the whole period of the PRNG. That way it is guaranteed that there won't be any collisions until `2^N/K` cycles, where `K` is the number of instances. Xormix supports generation of such uniformly distributed seeds using the xormix command-line tool.

Two-stage PRNG structure
------------------------

As discussed earlier, linear and nonlinear PRNGs both have some benefits and some drawbacks. In order to combine the best properties of linear and nonlinear PRNGs, xormix uses a two-stage structure where the first stage is linear, and the second stage is nonlinear. The output of the first stage is mixed into the state of the second stage, and the state of the second stage also serves as the output of the PRNG. In a sense, the second stage can be viewed as an output function for the first stage. The two stages were designed independently, but with different goals in mind. The first stage is responsible for giving the PRNG a minimum guaranteed period of `2^N-1` and is designed to be as random as possible on its own. The second stage is designed to mix up the output of the first stage as much as possible in a nonlinear way, and destroys any patterns that may still be present in the output from the first stage. It also extends the output from `N` bits to `N * S` bits with a very low hardware cost. The second stage also increases the average period of the PRNG dramatically, however this isn't the primary goal.

The following sections will focus on how the 'magic constants' for xormix were chosen. For a detailed description of the xormix algorithm, refer to the [Xormix Algorithm](doc/algorithm.md) page.

### First stage

The first stage is essentially a generalization of the [xorshift](https://en.wikipedia.org/wiki/Xorshift) random number generator. In a xorshift PRNG, the state is transformed by repeated shifting and XOR-ing with itself, such that each new state bit is the XOR combination of several previous state bits. For specific shift combinations, it can be shown that this PRNG has a period of `2^N-1`, going through every possible state except zero. In fact, it has been proven that [for each xorshift PRNG there exists an equivalent LFSR which produces the exact same output](https://www.jstatsoft.org/article/view/v011i05). The equivalent LFSR polynomial is usually dense, which is good, because dense LFSR are known to have better randomness properties than LFSRs based on sparse polynomials. Since xorshift PRNGs require significantly fewer XOR operations than the equivalent dense LFSR does, it can be seen as a more efficient way to implement a high-quality LFSR.

Xormix generalizes the xorshift idea by replacing the bitwise XOR and shift operations with XOR combinations of arbitrary bits. The implementation cost of this generalized PRNG is about the same as a xorshift PRNG, but it is a lot more flexible and allows for better randomness. The state-transition function of the first stage is essentially a binary matrix multiplication with a sparse matrix. To illustrate this, consider the following state-transfer function:

	X'[0] = X[1] xor X[3] xor X[5]
	X'[1] = X[0] xor X[2] xor X[4] xor X[5]
	X'[2] = X[2] xor X[4] xor X[7]
	X'[3] = X[3] xor X[4] xor X[6] xor X[7]
	X'[4] = X[0] xor X[2] xor X[5]
	X'[5] = X[2] xor X[3] xor X[5] xor X[6]
	X'[6] = X[1] xor X[3] xor X[7]
	X'[7] = X[0] xor X[1] xor X[2] xor X[4]

The equivalent state-transition matrix `T` is:

	[0 1 0 1 0 1 0 0]
	[1 0 1 0 1 1 0 0]
	[0 0 1 0 1 0 0 1]
	[0 0 0 1 1 0 1 1]
	[1 0 1 0 0 1 0 0]
	[0 0 1 1 0 1 1 0]
	[0 1 0 1 0 0 0 1]
	[1 1 1 0 1 0 0 0]

The design process boils down to picking a matrix `T` with good randomness properties. I selected the matrices based on the following requirements:

1. The number of ones in each row of `T` should be between 5 and 6 (such that it can be efficiently implemented using 6-input LUTs on FPGA).
2. The number of ones in each column of `T` should be between 4 and 7 (to avoid excessively high fanout and to ensure that all bits are used several times).
3. Two different rows of `T` should never have more than 3 ones in common, and the number of rows with 3 ones in common should be minimized.
4. The inverse of `T` should be dense and should not exhibit any obvious patterns.
5. The PRNG created by `T` should have a period of `2^N - 1`.
6. The minimum phase difference between the PRNG sequences created by the individual output bits should be relatively high. The average minimum phase difference is `2^N / N^2` and seems to follow a roughly exponential distribution, so we can require that the PRNG has a minimum phase difference of at least `4 * 2^N / N^2`.

Requirements 1 and 2 can be satisfied by construction. I used an algorithm to generate suitable matrices as follows:

- For each row, place a one in 5 or 6 randomly chosen columns.
- Count the number of ones in each column.
- Iterate over all ones in the matrix, and randomly move them to a different column (while staying in the same row). The probability that a one is moved increases with the number of ones that are already in that column.
- Repeat this until the number of ones in each column is between 4 and 7

This algorithm is repeated until a matrix is found which also satisfies the remaining requirements. Requirements 3 and 4 are easy to check. Requirement 5 can be checked as follows:

- Calculate `P = 2^N - 1`.
- Calculate the prime factors `F1, F2, F3, ...` of `P`.
- Check that `T^P` is equal to the identity matrix.
- Check that for each prime factor `Fi`, `T^(P/Fi)` is *not* equal to the identity matrix.

Requirement 6 is a lot more difficult to check because it requires solving a discrete logarithm problem over `GF(2^N)`. I used a variant of the Pohlig-Hellman algorithm to do this, which is still fast enough to be practical even for the 128-bit version of xormix.

### Second stage

The purpose of the second stage is to take the already quite random output of the first stage, and further mix it up in a nonlinear way to eliminate the linearity and increase the number of output bits. The structure of the second stage is inspired by the [Trivium](https://en.wikipedia.org/wiki/Trivium_%28cipher%29) stream cipher, but simplified to reduce the hardware cost. The second stage consists of multiple [nonlinear-feedback shift register](https://en.wikipedia.org/wiki/Nonlinear-feedback_shift_register) (one for each stream) which together form a loop. This results in a nonlinear invertible state-transition function. As discussed earlier, the fact that the state-transition function is invertible results in a much larger average period, which increases the randomness quality of the output.

Since this structure doesn't have a nice mathematical representation, the choice of logic gates and feedback taps was based on randomness testing and especially avalance testing, as discussed earlier. The taps are optimized to provide the strongest avalance effect for the case with only a single output stream, since this is the 'weakest' case. When more output streams are added, the randomness quality increases automatically due to the higher number of state bits. The taps that were finally chosen for each of the xormix variants are the results of several days of avalance testing.

The one remaining design aspect is how the output of the first stage (X) is mixed into the second stage (Y). If there was only one output stream, the it would have been sufficient to just XOR the X state into the Y state. However Y can be much larger than X if there are multiple output streams, so we need to extend X to make it the same length as Y before mixing the states together. Simply repeating X is suboptimal, since that would result in the same bits of X getting mixed together many times in different streams. Instead we do the following:

- First the X state is XOR-ed with a set of predefined 'salt' values, to provide a different value for each stream. This does not actually add any randomness, but it does make each value unique, which is important because all streams use the same state-transition function. The salts were chosen to have a reasonably large [Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance), but other than that they are entirely random.

- After applying the salts, the bits of the resulting values are rotated by an amount equal to the number of the stream. So the value for the first stream is not rotated, the value for the second stream is rotated by 1 bit, the value for the third stream is rotated by 2 bits, and so on. This ensures that the same bit won't appear twice in the same position.

- Finally the bits for each stream are shuffled according to a predefined scheme. This shuffling scheme is optimized to minimize the number of times that two bits from the first stage will appear at the same distance away from each other in the shift register of the second stage. This ensures that the second stage will not repeatedly mix the same two input bits together, but will instead mix together different combinations of bits for each output stream.
