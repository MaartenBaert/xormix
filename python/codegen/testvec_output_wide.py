# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import testvec_output

if __name__ == '__main__':
	for n in [16, 24, 32, 48, 64, 96, 128]:
		test_streams = n - 3
		test_outputs = 384 // n
		testvec_output.print_test(n, test_streams=test_streams, test_outputs=test_outputs)
