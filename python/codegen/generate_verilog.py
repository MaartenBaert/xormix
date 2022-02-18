# Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
# Available under the MIT License - see LICENSE.txt for details.

import math
import random

from xormix_all import modules

random.seed(0x75cf32031077f039)

def generate_rtl(n, filename):
	l = math.ceil(math.log10(n))
	matrix = modules[n].matrix
	salts = modules[n].salts
	shuffle = modules[n].shuffle
	shifts = modules[n].shifts
	with open(filename, 'w') as f:
		f.write(f'// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>\n')
		f.write(f'// Available under the MIT License - see LICENSE.txt for details.\n')
		f.write(f'\n')
		f.write(f'// This file was generated by `generate_verilog.py`.\n')
		f.write(f'// Revision: {modules[n].revision}\n')
		f.write(f'\n')
		f.write(f'module xormix{n}\n')
		f.write(f'    #(\n')
		f.write(f'        parameter streams = 1\n')
		f.write(f'    )\n')
		f.write(f'    (\n')
		f.write(f'        \n')
		f.write(f'        // clock and synchronous reset\n')
		f.write(f'        input wire clk,\n')
		f.write(f'        input wire rst,\n')
		f.write(f'        \n')
		f.write(f'        // configuration\n')
		f.write(f'        input wire [{n - 1} : 0] seed_x,\n')
		f.write(f'        input wire [{n} * streams - 1 : 0] seed_y,\n')
		f.write(f'        \n')
		f.write(f'        // random number generator\n')
		f.write(f'        input wire enable,\n')
		f.write(f'        output wire [{n} * streams - 1 : 0] result\n')
		f.write(f'        \n')
		f.write(f'    );\n')
		f.write(f'    \n')
		f.write(f'    localparam [{n} * {n} - 1 : 0] salts = {{\n')
		salts_reverse = salts[::-1]
		for i in range(0, n, 4):
			row = ', '.join(f'{n}\'h{x:0{n // 4}x}' for x in salts_reverse[i : i + 4])
			f.write(f'        ' + row + ('\n' if i == n - 4 else ',\n'))
		f.write(f'    }};\n')
		f.write(f'    \n')
		f.write(f'    reg [{n - 1} : 0] r_state_x;\n')
		f.write(f'    reg [{n} * streams - 1 : 0] r_state_y;\n')
		f.write(f'    \n')
		f.write(f'    reg [{n} * streams - 1 : 0] v_state_y1;\n')
		f.write(f'    reg [{n} * streams - 1 : 0] v_state_y2;\n')
		f.write(f'    \n')
		f.write(f'    reg [{n - 1} : 0] v_mixin;\n')
		f.write(f'    reg [{n - 1} : 0] v_mixup;\n')
		f.write(f'    reg [{n - 1} : 0] v_res;\n')
		f.write(f'    \n')
		f.write(f'    integer i;\n')
		f.write(f'    \n')
		f.write(f'    assign result = r_state_y;\n')
		f.write(f'    \n')
		f.write(f'    always @(*) begin\n')
		f.write(f'        \n')
		f.write(f'        for (i = 0; i < streams; i = i + 1) begin\n')
		f.write(f'            v_mixin = r_state_x ^ salts[{n} * i +: {n}];\n')
		f.write(f'            v_mixup = r_state_y[{n} * ((i + 1) % streams) +: {n}];\n')
		for k in range(n // 2):
			f.write(f'            v_res[{k:{l}}] = v_mixup[{k:{l}}] ^ (v_mixup[{k + shifts[0]:{l}}] & ~v_mixup[{k + shifts[1]:{l}}]) ^ v_mixup[{k + shifts[2]:{l}}] ^ v_mixup[{k + shifts[3]:{l}}] ^ v_mixin[(i + {shuffle[k]:{l}}) % {n}];\n')
		f.write(f'            v_state_y1[{n} * i +: {n}] = {{v_res, r_state_y[{n} * i + {n // 2} +: {n // 2}]}};\n')
		f.write(f'        end\n')
		f.write(f'        \n')
		f.write(f'        for (i = 0; i < streams; i = i + 1) begin\n')
		f.write(f'            v_mixin = r_state_x ^ salts[{n} * i +: {n}];\n')
		f.write(f'            v_mixup = v_state_y1[{n} * ((i + 1) % streams) +: {n}];\n')
		for k in range(n // 2):
			f.write(f'            v_res[{k:{l}}] = v_mixup[{k:{l}}] ^ (v_mixup[{k + shifts[0]:{l}}] & ~v_mixup[{k + shifts[1]:{l}}]) ^ v_mixup[{k + shifts[2]:{l}}] ^ v_mixup[{k + shifts[3]:{l}}] ^ v_mixin[(i + {shuffle[k + n // 2]:{l}}) % {n}];\n')
		f.write(f'            v_state_y2[{n} * i +: {n}] = {{v_res, v_state_y1[{n} * i + {n // 2} +: {n // 2}]}};\n')
		f.write(f'        end\n')
		f.write(f'        \n')
		f.write(f'    end\n')
		f.write(f'    \n')
		f.write(f'    always @(posedge clk) begin\n')
		f.write(f'        if (rst == 1\'b1) begin\n')
		f.write(f'            \n')
		f.write(f'            r_state_x <= seed_x;\n')
		f.write(f'            r_state_y <= seed_y;\n')
		f.write(f'            \n')
		f.write(f'        end else if (enable == 1\'b1) begin\n')
		f.write(f'            \n')
		for i in range(n):
			row = ' ^ '.join(f'r_state_x[{j:{l}}]' for j in matrix[i])
			f.write(f'            r_state_x[{i:{l}}] <= {row};\n')
		f.write(f'            \n')
		f.write(f'            r_state_y <= v_state_y2;\n')
		f.write(f'            \n')
		f.write(f'        end\n')
		f.write(f'    end\n')
		f.write(f'    \n')
		f.write(f'endmodule\n')
		f.write(f'\n')

def generate_tb(n, filename):
	test_streams = 4
	test_outputs = 100
	seed = [random.getrandbits(n) for i in range(test_streams + 1)]
	state = seed.copy()
	output = []
	for i in range(test_outputs):
		output.append(state[1 :])
		modules[n].next_state(state)
	l = math.ceil(math.log10(n))
	with open(filename, 'w') as f:
		f.write(f'// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>\n')
		f.write(f'// Available under the MIT License - see LICENSE.txt for details.\n')
		f.write(f'\n')
		f.write(f'// This file was generated by `generate_verilog.py`.\n')
		f.write(f'\n')
		f.write(f'`timescale 1ns/1ps\n')
		f.write(f'\n')
		f.write(f'module xormix{n}_tb;\n')
		f.write(f'    \n')
		f.write(f'    // configuration\n')
		f.write(f'    localparam streams = {test_streams};\n')
		f.write(f'    localparam results = {test_outputs};\n')
		f.write(f'    localparam [{n - 1} : 0] seed_x =\n')
		f.write(f'        {n}\'h{seed[0]:0{n // 4}x};\n')
		f.write(f'    localparam [{n} * streams - 1 : 0] seed_y =\n')
		row = ''.join(f'{s:0{n // 4}x}' for s in reversed(seed[1 :]))
		f.write(f'        {n * test_streams}\'h{row};\n')
		f.write(f'    \n')
		f.write(f'    // reference result\n')
		f.write(f'    localparam [{n} * streams * results - 1 : 0] ref_result = {{\n')
		output_reverse = output[::-1]
		for i in range(test_outputs):
			row = ''.join(f'{s:0{n // 4}x}' for s in reversed(output_reverse[i]))
			f.write(f'        {n * test_streams}\'h{row}' + ('\n' if i == test_outputs - 1 else ',\n'))
		f.write(f'    }};\n')
		f.write(f'    \n')
		f.write(f'    // DUT signals\n')
		f.write(f'    reg clk = 0;\n')
		f.write(f'    reg rst;\n')
		f.write(f'    reg enable;\n')
		f.write(f'    wire [{n} * streams - 1 : 0] result;\n')
		f.write(f'    \n')
		f.write(f'    // flag to stop simulation\n')
		f.write(f'    integer run = 1;\n')
		f.write(f'    \n')
		f.write(f'    // error counter\n')
		f.write(f'    integer errors = 0;\n')
		f.write(f'    \n')
		f.write(f'    // DUT\n')
		f.write(f'    xormix{n} #(\n')
		f.write(f'        .streams(streams)\n')
		f.write(f'    ) inst_xormix (\n')
		f.write(f'        .clk(clk),\n')
		f.write(f'        .rst(rst),\n')
		f.write(f'        .seed_x(seed_x),\n')
		f.write(f'        .seed_y(seed_y),\n')
		f.write(f'        .enable(enable),\n')
		f.write(f'        .result(result)\n')
		f.write(f'    );\n')
		f.write(f'    \n')
		f.write(f'    // clock process\n')
		f.write(f'    initial begin\n')
		f.write(f'        while (run == 1) begin\n')
		f.write(f'            clk = 1\'b1;\n')
		f.write(f'            #5;\n')
		f.write(f'            clk = 1\'b0;\n')
		f.write(f'            #5;\n')
		f.write(f'        end\n')
		f.write(f'    end\n')
		f.write(f'    \n')
		f.write(f'    integer i;\n')
		f.write(f'    \n')
		f.write(f'    // input/output process\n')
		f.write(f'    initial begin\n')
		f.write(f'        @(posedge clk);\n')
		f.write(f'        rst <= 1\'b1;\n')
		f.write(f'        enable <= 1\'b0;\n')
		f.write(f'        @(posedge clk);\n')
		f.write(f'        rst <= 1\'b0;\n')
		f.write(f'        enable <= 1\'b1;\n')
		f.write(f'        for (i = 0; i < results; i = i + 1) begin\n')
		f.write(f'            @(posedge clk);\n')
		f.write(f'            if (result !== ref_result[{n} * streams * i +: {n} * streams]) begin\n')
		f.write(f'                $display("Incorrect result for i=%d", i);\n')
		f.write(f'                errors = errors + 1;\n')
		f.write(f'            end\n')
		f.write(f'        end\n')
		f.write(f'        $display("Test complete, number of errors: %d", errors);\n')
		f.write(f'        run <= 0;\n')
		f.write(f'    end\n')
		f.write(f'    \n')
		f.write(f'endmodule\n')
		f.write(f'\n')

if __name__ == "__main__":

	for n in modules:
		generate_rtl(n, f'../../verilog/rtl/xormix{n}.v')

	for n in modules:
		generate_tb(n, f'../../verilog/tb/xormix{n}_tb.v')
