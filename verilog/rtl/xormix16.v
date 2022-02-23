// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

// This file was generated by `generate_verilog.py`.
// Revision: 1

module xormix16
    #(
        parameter streams = 1
    )
    (
        
        // clock and synchronous reset
        input wire clk,
        input wire rst,
        
        // configuration
        input wire [15 : 0] seed_x,
        input wire [16 * streams - 1 : 0] seed_y,
        
        // random number generator
        input wire enable,
        output wire [16 * streams - 1 : 0] result
        
    );
    
    localparam [16 * 16 - 1 : 0] salts = {
        16'h0a05, 16'he94c, 16'h7547, 16'h4058,
        16'h2cab, 16'hda5d, 16'h2d5a, 16'h5e28,
        16'hf491, 16'h09f7, 16'h5bc4, 16'hb749,
        16'he3eb, 16'h16a6, 16'hbc36, 16'hd2ba
    };
    
    reg [15 : 0] r_state_x;
    reg [16 * streams - 1 : 0] r_state_y;
    
    reg [16 * streams - 1 : 0] v_state_y1;
    reg [16 * streams - 1 : 0] v_state_y2;
    
    reg [15 : 0] v_mixin;
    reg [15 : 0] v_mixup;
    reg [15 : 0] v_res;
    
    integer i;
    
    assign result = r_state_y;
    
    always @(*) begin
        
        for (i = 0; i < streams; i = i + 1) begin
            v_mixin = r_state_x ^ salts[16 * i +: 16];
            v_mixup = r_state_y[16 * ((i + 1) % streams) +: 16];
            v_res[ 0] = v_mixup[ 0] ^ (v_mixup[ 4] & ~v_mixup[ 8]) ^ v_mixup[ 5] ^ v_mixup[ 7] ^ v_mixin[(i +  4) % 16];
            v_res[ 1] = v_mixup[ 1] ^ (v_mixup[ 5] & ~v_mixup[ 9]) ^ v_mixup[ 6] ^ v_mixup[ 8] ^ v_mixin[(i +  5) % 16];
            v_res[ 2] = v_mixup[ 2] ^ (v_mixup[ 6] & ~v_mixup[10]) ^ v_mixup[ 7] ^ v_mixup[ 9] ^ v_mixin[(i + 14) % 16];
            v_res[ 3] = v_mixup[ 3] ^ (v_mixup[ 7] & ~v_mixup[11]) ^ v_mixup[ 8] ^ v_mixup[10] ^ v_mixin[(i +  2) % 16];
            v_res[ 4] = v_mixup[ 4] ^ (v_mixup[ 8] & ~v_mixup[12]) ^ v_mixup[ 9] ^ v_mixup[11] ^ v_mixin[(i +  9) % 16];
            v_res[ 5] = v_mixup[ 5] ^ (v_mixup[ 9] & ~v_mixup[13]) ^ v_mixup[10] ^ v_mixup[12] ^ v_mixin[(i +  7) % 16];
            v_res[ 6] = v_mixup[ 6] ^ (v_mixup[10] & ~v_mixup[14]) ^ v_mixup[11] ^ v_mixup[13] ^ v_mixin[(i +  3) % 16];
            v_res[ 7] = v_mixup[ 7] ^ (v_mixup[11] & ~v_mixup[15]) ^ v_mixup[12] ^ v_mixup[14] ^ v_mixin[(i +  0) % 16];
            v_state_y1[16 * i +: 16] = {v_res, r_state_y[16 * i + 8 +: 8]};
        end
        
        for (i = 0; i < streams; i = i + 1) begin
            v_mixin = r_state_x ^ salts[16 * i +: 16];
            v_mixup = v_state_y1[16 * ((i + 1) % streams) +: 16];
            v_res[ 0] = v_mixup[ 0] ^ (v_mixup[ 4] & ~v_mixup[ 8]) ^ v_mixup[ 5] ^ v_mixup[ 7] ^ v_mixin[(i + 10) % 16];
            v_res[ 1] = v_mixup[ 1] ^ (v_mixup[ 5] & ~v_mixup[ 9]) ^ v_mixup[ 6] ^ v_mixup[ 8] ^ v_mixin[(i +  6) % 16];
            v_res[ 2] = v_mixup[ 2] ^ (v_mixup[ 6] & ~v_mixup[10]) ^ v_mixup[ 7] ^ v_mixup[ 9] ^ v_mixin[(i + 13) % 16];
            v_res[ 3] = v_mixup[ 3] ^ (v_mixup[ 7] & ~v_mixup[11]) ^ v_mixup[ 8] ^ v_mixup[10] ^ v_mixin[(i +  8) % 16];
            v_res[ 4] = v_mixup[ 4] ^ (v_mixup[ 8] & ~v_mixup[12]) ^ v_mixup[ 9] ^ v_mixup[11] ^ v_mixin[(i + 11) % 16];
            v_res[ 5] = v_mixup[ 5] ^ (v_mixup[ 9] & ~v_mixup[13]) ^ v_mixup[10] ^ v_mixup[12] ^ v_mixin[(i + 15) % 16];
            v_res[ 6] = v_mixup[ 6] ^ (v_mixup[10] & ~v_mixup[14]) ^ v_mixup[11] ^ v_mixup[13] ^ v_mixin[(i +  1) % 16];
            v_res[ 7] = v_mixup[ 7] ^ (v_mixup[11] & ~v_mixup[15]) ^ v_mixup[12] ^ v_mixup[14] ^ v_mixin[(i + 12) % 16];
            v_state_y2[16 * i +: 16] = {v_res, v_state_y1[16 * i + 8 +: 8]};
        end
        
    end
    
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            
            r_state_x <= seed_x;
            r_state_y <= seed_y;
            
        end else if (enable == 1'b1) begin
            
            r_state_x[ 0] <= r_state_x[ 3] ^ r_state_x[11] ^ r_state_x[ 1] ^ r_state_x[ 4] ^ r_state_x[13];
            r_state_x[ 1] <= r_state_x[11] ^ r_state_x[12] ^ r_state_x[10] ^ r_state_x[ 2] ^ r_state_x[ 8] ^ r_state_x[ 9];
            r_state_x[ 2] <= r_state_x[ 0] ^ r_state_x[10] ^ r_state_x[11] ^ r_state_x[ 4] ^ r_state_x[15];
            r_state_x[ 3] <= r_state_x[ 1] ^ r_state_x[11] ^ r_state_x[13] ^ r_state_x[ 0] ^ r_state_x[ 6] ^ r_state_x[10];
            r_state_x[ 4] <= r_state_x[ 8] ^ r_state_x[ 3] ^ r_state_x[ 6] ^ r_state_x[ 1] ^ r_state_x[ 7];
            r_state_x[ 5] <= r_state_x[ 3] ^ r_state_x[ 5] ^ r_state_x[ 4] ^ r_state_x[ 1] ^ r_state_x[14] ^ r_state_x[ 6];
            r_state_x[ 6] <= r_state_x[ 8] ^ r_state_x[ 7] ^ r_state_x[12] ^ r_state_x[11] ^ r_state_x[13];
            r_state_x[ 7] <= r_state_x[14] ^ r_state_x[ 7] ^ r_state_x[ 8] ^ r_state_x[ 5] ^ r_state_x[13] ^ r_state_x[10];
            r_state_x[ 8] <= r_state_x[ 7] ^ r_state_x[ 0] ^ r_state_x[ 4] ^ r_state_x[12] ^ r_state_x[13];
            r_state_x[ 9] <= r_state_x[15] ^ r_state_x[ 3] ^ r_state_x[ 9] ^ r_state_x[ 2] ^ r_state_x[11] ^ r_state_x[ 5];
            r_state_x[10] <= r_state_x[ 0] ^ r_state_x[ 9] ^ r_state_x[ 6] ^ r_state_x[11] ^ r_state_x[ 4];
            r_state_x[11] <= r_state_x[12] ^ r_state_x[15] ^ r_state_x[ 2] ^ r_state_x[ 3] ^ r_state_x[14] ^ r_state_x[ 0];
            r_state_x[12] <= r_state_x[14] ^ r_state_x[ 3] ^ r_state_x[ 9] ^ r_state_x[13] ^ r_state_x[ 0];
            r_state_x[13] <= r_state_x[ 6] ^ r_state_x[10] ^ r_state_x[12] ^ r_state_x[ 7] ^ r_state_x[ 2] ^ r_state_x[ 1];
            r_state_x[14] <= r_state_x[ 5] ^ r_state_x[ 7] ^ r_state_x[ 1] ^ r_state_x[15] ^ r_state_x[ 6];
            r_state_x[15] <= r_state_x[ 0] ^ r_state_x[ 7] ^ r_state_x[10] ^ r_state_x[14] ^ r_state_x[ 9] ^ r_state_x[ 1];
            
            r_state_y <= v_state_y2;
            
        end
    end
    
endmodule
