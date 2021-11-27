// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

// This file was generated by `generate_verilog.py`.

module xormix24
    #(
        parameter streams = 1
    )
    (
        
        // clock and synchronous reset
        input wire clk,
        input wire rst,
        
        // configuration
        input wire [23 : 0] seed_x,
        input wire [24 * streams - 1 : 0] seed_y,
        
        // random number generator
        input wire enable,
        output wire [24 * streams - 1 : 0] result
        
    );
    
    localparam [24 * 24 - 1 : 0] salts = {
        24'ha1befc, 24'h02efea, 24'hbf29d0, 24'h57622b,
        24'h73ac8e, 24'h271093, 24'heb76b1, 24'h1cee53,
        24'h00c73d, 24'h74c90b, 24'hce7aee, 24'hf52624,
        24'he79f3f, 24'h040da6, 24'h915302, 24'h5c5955,
        24'h39b1db, 24'ha64b72, 24'h295e05, 24'h6aaf55,
        24'h112b89, 24'hb8b710, 24'h8c3c8d, 24'hd96a94
    };
    
    reg [23 : 0] r_state_x;
    reg [24 * streams - 1 : 0] r_state_y;
    
    reg [24 * streams - 1 : 0] v_state_y1;
    reg [24 * streams - 1 : 0] v_state_y2;
    
    reg [23 : 0] v_mixin;
    reg [23 : 0] v_mixup;
    reg [23 : 0] v_res;
    
    integer i;
    
    assign result = r_state_y;
    
    always @(*) begin
        
        for (i = 0; i < streams; i = i + 1) begin
            v_mixin = r_state_x ^ salts[24 * i +: 24];
            v_mixup = r_state_y[24 * ((i + 1) % streams) +: 24];
            v_res[ 0] = v_mixup[ 0] ^ (v_mixup[ 8] & ~v_mixup[12]) ^ v_mixup[ 9] ^ v_mixup[11] ^ v_mixin[(i +  0) % 24];
            v_res[ 1] = v_mixup[ 1] ^ (v_mixup[ 9] & ~v_mixup[13]) ^ v_mixup[10] ^ v_mixup[12] ^ v_mixin[(i +  7) % 24];
            v_res[ 2] = v_mixup[ 2] ^ (v_mixup[10] & ~v_mixup[14]) ^ v_mixup[11] ^ v_mixup[13] ^ v_mixin[(i + 17) % 24];
            v_res[ 3] = v_mixup[ 3] ^ (v_mixup[11] & ~v_mixup[15]) ^ v_mixup[12] ^ v_mixup[14] ^ v_mixin[(i +  8) % 24];
            v_res[ 4] = v_mixup[ 4] ^ (v_mixup[12] & ~v_mixup[16]) ^ v_mixup[13] ^ v_mixup[15] ^ v_mixin[(i +  9) % 24];
            v_res[ 5] = v_mixup[ 5] ^ (v_mixup[13] & ~v_mixup[17]) ^ v_mixup[14] ^ v_mixup[16] ^ v_mixin[(i + 13) % 24];
            v_res[ 6] = v_mixup[ 6] ^ (v_mixup[14] & ~v_mixup[18]) ^ v_mixup[15] ^ v_mixup[17] ^ v_mixin[(i + 11) % 24];
            v_res[ 7] = v_mixup[ 7] ^ (v_mixup[15] & ~v_mixup[19]) ^ v_mixup[16] ^ v_mixup[18] ^ v_mixin[(i + 12) % 24];
            v_res[ 8] = v_mixup[ 8] ^ (v_mixup[16] & ~v_mixup[20]) ^ v_mixup[17] ^ v_mixup[19] ^ v_mixin[(i +  2) % 24];
            v_res[ 9] = v_mixup[ 9] ^ (v_mixup[17] & ~v_mixup[21]) ^ v_mixup[18] ^ v_mixup[20] ^ v_mixin[(i + 16) % 24];
            v_res[10] = v_mixup[10] ^ (v_mixup[18] & ~v_mixup[22]) ^ v_mixup[19] ^ v_mixup[21] ^ v_mixin[(i + 14) % 24];
            v_res[11] = v_mixup[11] ^ (v_mixup[19] & ~v_mixup[23]) ^ v_mixup[20] ^ v_mixup[22] ^ v_mixin[(i +  4) % 24];
            v_state_y1[24 * i +: 24] = {v_res, r_state_y[24 * i + 12 +: 12]};
        end
        
        for (i = 0; i < streams; i = i + 1) begin
            v_mixin = r_state_x ^ salts[24 * i +: 24];
            v_mixup = v_state_y1[24 * ((i + 1) % streams) +: 24];
            v_res[ 0] = v_mixup[ 0] ^ (v_mixup[ 8] & ~v_mixup[12]) ^ v_mixup[ 9] ^ v_mixup[11] ^ v_mixin[(i + 21) % 24];
            v_res[ 1] = v_mixup[ 1] ^ (v_mixup[ 9] & ~v_mixup[13]) ^ v_mixup[10] ^ v_mixup[12] ^ v_mixin[(i + 10) % 24];
            v_res[ 2] = v_mixup[ 2] ^ (v_mixup[10] & ~v_mixup[14]) ^ v_mixup[11] ^ v_mixup[13] ^ v_mixin[(i +  3) % 24];
            v_res[ 3] = v_mixup[ 3] ^ (v_mixup[11] & ~v_mixup[15]) ^ v_mixup[12] ^ v_mixup[14] ^ v_mixin[(i + 20) % 24];
            v_res[ 4] = v_mixup[ 4] ^ (v_mixup[12] & ~v_mixup[16]) ^ v_mixup[13] ^ v_mixup[15] ^ v_mixin[(i + 22) % 24];
            v_res[ 5] = v_mixup[ 5] ^ (v_mixup[13] & ~v_mixup[17]) ^ v_mixup[14] ^ v_mixup[16] ^ v_mixin[(i + 19) % 24];
            v_res[ 6] = v_mixup[ 6] ^ (v_mixup[14] & ~v_mixup[18]) ^ v_mixup[15] ^ v_mixup[17] ^ v_mixin[(i + 15) % 24];
            v_res[ 7] = v_mixup[ 7] ^ (v_mixup[15] & ~v_mixup[19]) ^ v_mixup[16] ^ v_mixup[18] ^ v_mixin[(i +  1) % 24];
            v_res[ 8] = v_mixup[ 8] ^ (v_mixup[16] & ~v_mixup[20]) ^ v_mixup[17] ^ v_mixup[19] ^ v_mixin[(i +  5) % 24];
            v_res[ 9] = v_mixup[ 9] ^ (v_mixup[17] & ~v_mixup[21]) ^ v_mixup[18] ^ v_mixup[20] ^ v_mixin[(i + 23) % 24];
            v_res[10] = v_mixup[10] ^ (v_mixup[18] & ~v_mixup[22]) ^ v_mixup[19] ^ v_mixup[21] ^ v_mixin[(i +  6) % 24];
            v_res[11] = v_mixup[11] ^ (v_mixup[19] & ~v_mixup[23]) ^ v_mixup[20] ^ v_mixup[22] ^ v_mixin[(i + 18) % 24];
            v_state_y2[24 * i +: 24] = {v_res, v_state_y1[24 * i + 12 +: 12]};
        end
        
    end
    
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            
            r_state_x <= seed_x;
            r_state_y <= seed_y;
            
        end else if (enable == 1'b1) begin
            
            r_state_x[ 0] <= r_state_x[ 0] ^ r_state_x[17] ^ r_state_x[ 2] ^ r_state_x[ 9] ^ r_state_x[22];
            r_state_x[ 1] <= r_state_x[18] ^ r_state_x[ 1] ^ r_state_x[14] ^ r_state_x[11] ^ r_state_x[ 4] ^ r_state_x[ 9];
            r_state_x[ 2] <= r_state_x[19] ^ r_state_x[15] ^ r_state_x[17] ^ r_state_x[23] ^ r_state_x[ 7];
            r_state_x[ 3] <= r_state_x[18] ^ r_state_x[13] ^ r_state_x[14] ^ r_state_x[ 0] ^ r_state_x[ 6] ^ r_state_x[ 7];
            r_state_x[ 4] <= r_state_x[18] ^ r_state_x[20] ^ r_state_x[ 1] ^ r_state_x[19] ^ r_state_x[11];
            r_state_x[ 5] <= r_state_x[23] ^ r_state_x[15] ^ r_state_x[ 5] ^ r_state_x[16] ^ r_state_x[ 4] ^ r_state_x[ 3];
            r_state_x[ 6] <= r_state_x[ 2] ^ r_state_x[ 6] ^ r_state_x[ 3] ^ r_state_x[15] ^ r_state_x[20];
            r_state_x[ 7] <= r_state_x[ 4] ^ r_state_x[ 5] ^ r_state_x[16] ^ r_state_x[ 8] ^ r_state_x[12] ^ r_state_x[21];
            r_state_x[ 8] <= r_state_x[20] ^ r_state_x[ 5] ^ r_state_x[10] ^ r_state_x[15] ^ r_state_x[ 2];
            r_state_x[ 9] <= r_state_x[ 3] ^ r_state_x[23] ^ r_state_x[14] ^ r_state_x[ 0] ^ r_state_x[ 9] ^ r_state_x[20];
            r_state_x[10] <= r_state_x[ 1] ^ r_state_x[11] ^ r_state_x[ 0] ^ r_state_x[23] ^ r_state_x[13];
            r_state_x[11] <= r_state_x[20] ^ r_state_x[ 8] ^ r_state_x[10] ^ r_state_x[14] ^ r_state_x[ 7] ^ r_state_x[ 2];
            r_state_x[12] <= r_state_x[ 8] ^ r_state_x[ 6] ^ r_state_x[ 0] ^ r_state_x[ 3] ^ r_state_x[16];
            r_state_x[13] <= r_state_x[ 5] ^ r_state_x[22] ^ r_state_x[16] ^ r_state_x[ 2] ^ r_state_x[18] ^ r_state_x[11];
            r_state_x[14] <= r_state_x[ 2] ^ r_state_x[22] ^ r_state_x[ 3] ^ r_state_x[ 8] ^ r_state_x[ 1];
            r_state_x[15] <= r_state_x[ 5] ^ r_state_x[21] ^ r_state_x[22] ^ r_state_x[ 7] ^ r_state_x[11] ^ r_state_x[10];
            r_state_x[16] <= r_state_x[12] ^ r_state_x[ 6] ^ r_state_x[15] ^ r_state_x[14] ^ r_state_x[ 4];
            r_state_x[17] <= r_state_x[ 9] ^ r_state_x[ 4] ^ r_state_x[ 1] ^ r_state_x[17] ^ r_state_x[ 6] ^ r_state_x[19];
            r_state_x[18] <= r_state_x[12] ^ r_state_x[20] ^ r_state_x[22] ^ r_state_x[ 9] ^ r_state_x[21];
            r_state_x[19] <= r_state_x[16] ^ r_state_x[19] ^ r_state_x[18] ^ r_state_x[12] ^ r_state_x[ 0] ^ r_state_x[ 3];
            r_state_x[20] <= r_state_x[ 3] ^ r_state_x[10] ^ r_state_x[14] ^ r_state_x[17] ^ r_state_x[ 1];
            r_state_x[21] <= r_state_x[23] ^ r_state_x[13] ^ r_state_x[21] ^ r_state_x[ 9] ^ r_state_x[12] ^ r_state_x[ 7];
            r_state_x[22] <= r_state_x[22] ^ r_state_x[14] ^ r_state_x[ 8] ^ r_state_x[ 9] ^ r_state_x[10];
            r_state_x[23] <= r_state_x[ 8] ^ r_state_x[19] ^ r_state_x[21] ^ r_state_x[23] ^ r_state_x[17] ^ r_state_x[13];
            
            r_state_y <= v_state_y2;
            
        end
    end
    
endmodule

