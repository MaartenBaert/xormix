// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

// This file was generated by `generate_verilog.py`.
// Revision: 1

module xormix96
    #(
        parameter streams = 1
    )
    (
        
        // clock and synchronous reset
        input wire clk,
        input wire rst,
        
        // configuration
        input wire [95 : 0] seed_x,
        input wire [96 * streams - 1 : 0] seed_y,
        
        // random number generator
        input wire enable,
        output wire [96 * streams - 1 : 0] result
        
    );
    
    localparam [96 * 96 - 1 : 0] salts = {
        96'h1bff24a6febaa737fdefa863, 96'hc4d5c6cf20379c2bcf02bcf7, 96'h64fd0ca64551dbecdcd28ff9, 96'hfa0fdf6dc5d11206f6e198a4,
        96'ha84713d6f74b340bb2cc2fab, 96'hea009c451178d52621247482, 96'h87477f4ae25467ff87f2efa6, 96'h41cd883fb8ff53f739d3546a,
        96'h3bc6cf51e924f7c6ec628791, 96'h3e5e9bdd1d64b04f9d92d83b, 96'h84812ab822175870f588b01e, 96'h1a90406dce189bc627cd9cba,
        96'hcaaed07863593c4c06197a6c, 96'h3c5cc9869dbc64772b58fd36, 96'h66b33be6f1649b539c55a908, 96'hbf2b253de7f82582bb31175f,
        96'heea1f4020b54b2e4df3ef598, 96'ha3dd3f1b7fd7e392762e4443, 96'he0999d460fed097784e989e9, 96'h41c3c9dbbde1af343fd91134,
        96'hba77c19d9e6c52f50325a5fe, 96'h08380ff335a17a11ab09ac47, 96'h316799a62a2b444c30435136, 96'h1c82cd96109c8d647b5b52c2,
        96'h526d1f91c85c680358a4e882, 96'h3c4c5f09a90e00465de9b33e, 96'h9a50ef154caa345ddd4b8448, 96'h96ca13281ff64d69d6a9f493,
        96'hd09797bac005ff7fc38f9668, 96'h756e211b269c1a5d49fd8319, 96'hef206554e9b3cc1466d55960, 96'h9cd991a210523ae251322632,
        96'ha4436deb7759e3bab96783bc, 96'h8ce6c1f47c8cac99c26d675f, 96'hc6e89b6f342a8419d1c4e967, 96'h4b12bd11e2b967fe411d9e2d,
        96'h5d02c224218a45f4cff511f6, 96'haa0f40d36ad7f3e4fde1f23e, 96'h2e921e597fb8abf6b6da65ab, 96'hde40acfad1d7202f6ab8b81f,
        96'h8dfbf97fde56ad24ebcbc639, 96'he5532b05511358d1bc75473a, 96'h105feec6ab487d1fbd5a4fec, 96'h59b142a05f99b1fa91c8f332,
        96'hd4bf39f96519f627fe72b19f, 96'h0162d2d5a8a530c7d02d3520, 96'h124a583ab57fab16980c1af0, 96'h85efd26b94b3cf95a9421cbc,
        96'hebedd4ed7a029ae094807b62, 96'h4948ad10dbffb552f5e0efac, 96'hdb2b3756627f87cf98d9ec8a, 96'hced40885938f39870226cc5b,
        96'hfb904152a0011280558611fb, 96'hb2c1198a220c9f9668cc5101, 96'hacb5372755de946dfd193631, 96'h38fed51e65bc0562992c8488,
        96'h621ca5773ee005f36b66d06c, 96'h980a5232856ce525a0aec14c, 96'h14f049c34ce725aa2c490b12, 96'h1437b070792723e29f5da7d4,
        96'h3b2b25e41fd40e07b212e026, 96'hf600635b03e92f2fb54339b7, 96'h71e565420304e2da8b9c4ea0, 96'hd9714416b2cae88fa0370fef,
        96'h62842083ccff93988a99d2a4, 96'h0c94162c5cd979a2d0002c45, 96'h5ab4670b4474e57d2914a95c, 96'h67d1e7005a5054442f94ba0a,
        96'h2539fb51cfa4d3b5fd0b6e9a, 96'hafc0de3b891e7fd3e8882b5c, 96'h50401c5a2989c7eb98ab64fb, 96'h6b62bb76b84522e412ce68ac,
        96'hca4e892f298a13178eb22a88, 96'h417e0444496792df5700a660, 96'h35dd3d4dfe6191ec2c80e292, 96'h0b37c3a328d89981c733d157,
        96'h2c6c0454a632bf6b2c0f4a77, 96'h2ee76cd6b4ec42c1ec2f26a4, 96'h89ada553c5679f8fd13e40e1, 96'ha8eefca08e65f7411d8164ba,
        96'h2097eb070e750e2fda153d84, 96'h55568b9e8eb9df8518243c1e, 96'he0592230e4f0f05e619655c0, 96'h1b15b9b87e0bb24f224d200f,
        96'hb657de372e382df2d4f33c4c, 96'h68ab49b831b7dc4a4b49c11d, 96'h0bb59f564d1d3cf833623b5c, 96'hffdfe8c9ec04bbdf7bee652e,
        96'hc8d61c3bdd042220e6f59d5c, 96'hf85964c82d1057eacf751855, 96'haead4a87a54e563e593aef70, 96'ha5b1c14726c172f51066b415,
        96'h0e1f7d0fa053e5d590c79c4e, 96'h45405efdaa7a8343f957dbb2, 96'h6065db7e5e9528c24e41956c, 96'h6319a0b833efe6e1c2523bab
    };
    
    reg [95 : 0] r_state_x;
    reg [96 * streams - 1 : 0] r_state_y;
    
    reg [96 * streams - 1 : 0] v_state_y1;
    reg [96 * streams - 1 : 0] v_state_y2;
    
    reg [95 : 0] v_mixin;
    reg [95 : 0] v_mixup;
    reg [95 : 0] v_res;
    
    integer i;
    
    assign result = r_state_y;
    
    always @(*) begin
        
        for (i = 0; i < streams; i = i + 1) begin
            v_mixin = r_state_x ^ salts[96 * i +: 96];
            v_mixup = r_state_y[96 * ((i + 1) % streams) +: 96];
            v_res[ 0] = v_mixup[ 0] ^ (v_mixup[45] & ~v_mixup[46]) ^ v_mixup[36] ^ v_mixup[43] ^ v_mixin[(i + 50) % 96];
            v_res[ 1] = v_mixup[ 1] ^ (v_mixup[46] & ~v_mixup[47]) ^ v_mixup[37] ^ v_mixup[44] ^ v_mixin[(i + 20) % 96];
            v_res[ 2] = v_mixup[ 2] ^ (v_mixup[47] & ~v_mixup[48]) ^ v_mixup[38] ^ v_mixup[45] ^ v_mixin[(i + 91) % 96];
            v_res[ 3] = v_mixup[ 3] ^ (v_mixup[48] & ~v_mixup[49]) ^ v_mixup[39] ^ v_mixup[46] ^ v_mixin[(i + 59) % 96];
            v_res[ 4] = v_mixup[ 4] ^ (v_mixup[49] & ~v_mixup[50]) ^ v_mixup[40] ^ v_mixup[47] ^ v_mixin[(i + 26) % 96];
            v_res[ 5] = v_mixup[ 5] ^ (v_mixup[50] & ~v_mixup[51]) ^ v_mixup[41] ^ v_mixup[48] ^ v_mixin[(i +  4) % 96];
            v_res[ 6] = v_mixup[ 6] ^ (v_mixup[51] & ~v_mixup[52]) ^ v_mixup[42] ^ v_mixup[49] ^ v_mixin[(i + 58) % 96];
            v_res[ 7] = v_mixup[ 7] ^ (v_mixup[52] & ~v_mixup[53]) ^ v_mixup[43] ^ v_mixup[50] ^ v_mixin[(i + 25) % 96];
            v_res[ 8] = v_mixup[ 8] ^ (v_mixup[53] & ~v_mixup[54]) ^ v_mixup[44] ^ v_mixup[51] ^ v_mixin[(i + 71) % 96];
            v_res[ 9] = v_mixup[ 9] ^ (v_mixup[54] & ~v_mixup[55]) ^ v_mixup[45] ^ v_mixup[52] ^ v_mixin[(i + 77) % 96];
            v_res[10] = v_mixup[10] ^ (v_mixup[55] & ~v_mixup[56]) ^ v_mixup[46] ^ v_mixup[53] ^ v_mixin[(i + 13) % 96];
            v_res[11] = v_mixup[11] ^ (v_mixup[56] & ~v_mixup[57]) ^ v_mixup[47] ^ v_mixup[54] ^ v_mixin[(i +  2) % 96];
            v_res[12] = v_mixup[12] ^ (v_mixup[57] & ~v_mixup[58]) ^ v_mixup[48] ^ v_mixup[55] ^ v_mixin[(i + 30) % 96];
            v_res[13] = v_mixup[13] ^ (v_mixup[58] & ~v_mixup[59]) ^ v_mixup[49] ^ v_mixup[56] ^ v_mixin[(i + 72) % 96];
            v_res[14] = v_mixup[14] ^ (v_mixup[59] & ~v_mixup[60]) ^ v_mixup[50] ^ v_mixup[57] ^ v_mixin[(i + 11) % 96];
            v_res[15] = v_mixup[15] ^ (v_mixup[60] & ~v_mixup[61]) ^ v_mixup[51] ^ v_mixup[58] ^ v_mixin[(i + 15) % 96];
            v_res[16] = v_mixup[16] ^ (v_mixup[61] & ~v_mixup[62]) ^ v_mixup[52] ^ v_mixup[59] ^ v_mixin[(i + 45) % 96];
            v_res[17] = v_mixup[17] ^ (v_mixup[62] & ~v_mixup[63]) ^ v_mixup[53] ^ v_mixup[60] ^ v_mixin[(i + 61) % 96];
            v_res[18] = v_mixup[18] ^ (v_mixup[63] & ~v_mixup[64]) ^ v_mixup[54] ^ v_mixup[61] ^ v_mixin[(i + 80) % 96];
            v_res[19] = v_mixup[19] ^ (v_mixup[64] & ~v_mixup[65]) ^ v_mixup[55] ^ v_mixup[62] ^ v_mixin[(i + 19) % 96];
            v_res[20] = v_mixup[20] ^ (v_mixup[65] & ~v_mixup[66]) ^ v_mixup[56] ^ v_mixup[63] ^ v_mixin[(i + 33) % 96];
            v_res[21] = v_mixup[21] ^ (v_mixup[66] & ~v_mixup[67]) ^ v_mixup[57] ^ v_mixup[64] ^ v_mixin[(i + 35) % 96];
            v_res[22] = v_mixup[22] ^ (v_mixup[67] & ~v_mixup[68]) ^ v_mixup[58] ^ v_mixup[65] ^ v_mixin[(i + 62) % 96];
            v_res[23] = v_mixup[23] ^ (v_mixup[68] & ~v_mixup[69]) ^ v_mixup[59] ^ v_mixup[66] ^ v_mixin[(i +  1) % 96];
            v_res[24] = v_mixup[24] ^ (v_mixup[69] & ~v_mixup[70]) ^ v_mixup[60] ^ v_mixup[67] ^ v_mixin[(i + 74) % 96];
            v_res[25] = v_mixup[25] ^ (v_mixup[70] & ~v_mixup[71]) ^ v_mixup[61] ^ v_mixup[68] ^ v_mixin[(i + 18) % 96];
            v_res[26] = v_mixup[26] ^ (v_mixup[71] & ~v_mixup[72]) ^ v_mixup[62] ^ v_mixup[69] ^ v_mixin[(i + 90) % 96];
            v_res[27] = v_mixup[27] ^ (v_mixup[72] & ~v_mixup[73]) ^ v_mixup[63] ^ v_mixup[70] ^ v_mixin[(i + 66) % 96];
            v_res[28] = v_mixup[28] ^ (v_mixup[73] & ~v_mixup[74]) ^ v_mixup[64] ^ v_mixup[71] ^ v_mixin[(i + 67) % 96];
            v_res[29] = v_mixup[29] ^ (v_mixup[74] & ~v_mixup[75]) ^ v_mixup[65] ^ v_mixup[72] ^ v_mixin[(i + 88) % 96];
            v_res[30] = v_mixup[30] ^ (v_mixup[75] & ~v_mixup[76]) ^ v_mixup[66] ^ v_mixup[73] ^ v_mixin[(i + 28) % 96];
            v_res[31] = v_mixup[31] ^ (v_mixup[76] & ~v_mixup[77]) ^ v_mixup[67] ^ v_mixup[74] ^ v_mixin[(i + 53) % 96];
            v_res[32] = v_mixup[32] ^ (v_mixup[77] & ~v_mixup[78]) ^ v_mixup[68] ^ v_mixup[75] ^ v_mixin[(i + 23) % 96];
            v_res[33] = v_mixup[33] ^ (v_mixup[78] & ~v_mixup[79]) ^ v_mixup[69] ^ v_mixup[76] ^ v_mixin[(i + 94) % 96];
            v_res[34] = v_mixup[34] ^ (v_mixup[79] & ~v_mixup[80]) ^ v_mixup[70] ^ v_mixup[77] ^ v_mixin[(i + 55) % 96];
            v_res[35] = v_mixup[35] ^ (v_mixup[80] & ~v_mixup[81]) ^ v_mixup[71] ^ v_mixup[78] ^ v_mixin[(i + 37) % 96];
            v_res[36] = v_mixup[36] ^ (v_mixup[81] & ~v_mixup[82]) ^ v_mixup[72] ^ v_mixup[79] ^ v_mixin[(i + 34) % 96];
            v_res[37] = v_mixup[37] ^ (v_mixup[82] & ~v_mixup[83]) ^ v_mixup[73] ^ v_mixup[80] ^ v_mixin[(i + 24) % 96];
            v_res[38] = v_mixup[38] ^ (v_mixup[83] & ~v_mixup[84]) ^ v_mixup[74] ^ v_mixup[81] ^ v_mixin[(i + 65) % 96];
            v_res[39] = v_mixup[39] ^ (v_mixup[84] & ~v_mixup[85]) ^ v_mixup[75] ^ v_mixup[82] ^ v_mixin[(i + 46) % 96];
            v_res[40] = v_mixup[40] ^ (v_mixup[85] & ~v_mixup[86]) ^ v_mixup[76] ^ v_mixup[83] ^ v_mixin[(i + 32) % 96];
            v_res[41] = v_mixup[41] ^ (v_mixup[86] & ~v_mixup[87]) ^ v_mixup[77] ^ v_mixup[84] ^ v_mixin[(i + 84) % 96];
            v_res[42] = v_mixup[42] ^ (v_mixup[87] & ~v_mixup[88]) ^ v_mixup[78] ^ v_mixup[85] ^ v_mixin[(i + 79) % 96];
            v_res[43] = v_mixup[43] ^ (v_mixup[88] & ~v_mixup[89]) ^ v_mixup[79] ^ v_mixup[86] ^ v_mixin[(i + 48) % 96];
            v_res[44] = v_mixup[44] ^ (v_mixup[89] & ~v_mixup[90]) ^ v_mixup[80] ^ v_mixup[87] ^ v_mixin[(i + 92) % 96];
            v_res[45] = v_mixup[45] ^ (v_mixup[90] & ~v_mixup[91]) ^ v_mixup[81] ^ v_mixup[88] ^ v_mixin[(i + 57) % 96];
            v_res[46] = v_mixup[46] ^ (v_mixup[91] & ~v_mixup[92]) ^ v_mixup[82] ^ v_mixup[89] ^ v_mixin[(i + 41) % 96];
            v_res[47] = v_mixup[47] ^ (v_mixup[92] & ~v_mixup[93]) ^ v_mixup[83] ^ v_mixup[90] ^ v_mixin[(i + 27) % 96];
            v_state_y1[96 * i +: 96] = {v_res, r_state_y[96 * i + 48 +: 48]};
        end
        
        for (i = 0; i < streams; i = i + 1) begin
            v_mixin = r_state_x ^ salts[96 * i +: 96];
            v_mixup = v_state_y1[96 * ((i + 1) % streams) +: 96];
            v_res[ 0] = v_mixup[ 0] ^ (v_mixup[45] & ~v_mixup[46]) ^ v_mixup[36] ^ v_mixup[43] ^ v_mixin[(i + 64) % 96];
            v_res[ 1] = v_mixup[ 1] ^ (v_mixup[46] & ~v_mixup[47]) ^ v_mixup[37] ^ v_mixup[44] ^ v_mixin[(i + 95) % 96];
            v_res[ 2] = v_mixup[ 2] ^ (v_mixup[47] & ~v_mixup[48]) ^ v_mixup[38] ^ v_mixup[45] ^ v_mixin[(i + 70) % 96];
            v_res[ 3] = v_mixup[ 3] ^ (v_mixup[48] & ~v_mixup[49]) ^ v_mixup[39] ^ v_mixup[46] ^ v_mixin[(i +  6) % 96];
            v_res[ 4] = v_mixup[ 4] ^ (v_mixup[49] & ~v_mixup[50]) ^ v_mixup[40] ^ v_mixup[47] ^ v_mixin[(i + 93) % 96];
            v_res[ 5] = v_mixup[ 5] ^ (v_mixup[50] & ~v_mixup[51]) ^ v_mixup[41] ^ v_mixup[48] ^ v_mixin[(i + 21) % 96];
            v_res[ 6] = v_mixup[ 6] ^ (v_mixup[51] & ~v_mixup[52]) ^ v_mixup[42] ^ v_mixup[49] ^ v_mixin[(i + 76) % 96];
            v_res[ 7] = v_mixup[ 7] ^ (v_mixup[52] & ~v_mixup[53]) ^ v_mixup[43] ^ v_mixup[50] ^ v_mixin[(i + 85) % 96];
            v_res[ 8] = v_mixup[ 8] ^ (v_mixup[53] & ~v_mixup[54]) ^ v_mixup[44] ^ v_mixup[51] ^ v_mixin[(i + 40) % 96];
            v_res[ 9] = v_mixup[ 9] ^ (v_mixup[54] & ~v_mixup[55]) ^ v_mixup[45] ^ v_mixup[52] ^ v_mixin[(i + 83) % 96];
            v_res[10] = v_mixup[10] ^ (v_mixup[55] & ~v_mixup[56]) ^ v_mixup[46] ^ v_mixup[53] ^ v_mixin[(i + 56) % 96];
            v_res[11] = v_mixup[11] ^ (v_mixup[56] & ~v_mixup[57]) ^ v_mixup[47] ^ v_mixup[54] ^ v_mixin[(i + 29) % 96];
            v_res[12] = v_mixup[12] ^ (v_mixup[57] & ~v_mixup[58]) ^ v_mixup[48] ^ v_mixup[55] ^ v_mixin[(i + 12) % 96];
            v_res[13] = v_mixup[13] ^ (v_mixup[58] & ~v_mixup[59]) ^ v_mixup[49] ^ v_mixup[56] ^ v_mixin[(i +  9) % 96];
            v_res[14] = v_mixup[14] ^ (v_mixup[59] & ~v_mixup[60]) ^ v_mixup[50] ^ v_mixup[57] ^ v_mixin[(i + 68) % 96];
            v_res[15] = v_mixup[15] ^ (v_mixup[60] & ~v_mixup[61]) ^ v_mixup[51] ^ v_mixup[58] ^ v_mixin[(i + 73) % 96];
            v_res[16] = v_mixup[16] ^ (v_mixup[61] & ~v_mixup[62]) ^ v_mixup[52] ^ v_mixup[59] ^ v_mixin[(i + 78) % 96];
            v_res[17] = v_mixup[17] ^ (v_mixup[62] & ~v_mixup[63]) ^ v_mixup[53] ^ v_mixup[60] ^ v_mixin[(i + 69) % 96];
            v_res[18] = v_mixup[18] ^ (v_mixup[63] & ~v_mixup[64]) ^ v_mixup[54] ^ v_mixup[61] ^ v_mixin[(i + 22) % 96];
            v_res[19] = v_mixup[19] ^ (v_mixup[64] & ~v_mixup[65]) ^ v_mixup[55] ^ v_mixup[62] ^ v_mixin[(i + 47) % 96];
            v_res[20] = v_mixup[20] ^ (v_mixup[65] & ~v_mixup[66]) ^ v_mixup[56] ^ v_mixup[63] ^ v_mixin[(i + 42) % 96];
            v_res[21] = v_mixup[21] ^ (v_mixup[66] & ~v_mixup[67]) ^ v_mixup[57] ^ v_mixup[64] ^ v_mixin[(i + 82) % 96];
            v_res[22] = v_mixup[22] ^ (v_mixup[67] & ~v_mixup[68]) ^ v_mixup[58] ^ v_mixup[65] ^ v_mixin[(i + 44) % 96];
            v_res[23] = v_mixup[23] ^ (v_mixup[68] & ~v_mixup[69]) ^ v_mixup[59] ^ v_mixup[66] ^ v_mixin[(i + 54) % 96];
            v_res[24] = v_mixup[24] ^ (v_mixup[69] & ~v_mixup[70]) ^ v_mixup[60] ^ v_mixup[67] ^ v_mixin[(i + 36) % 96];
            v_res[25] = v_mixup[25] ^ (v_mixup[70] & ~v_mixup[71]) ^ v_mixup[61] ^ v_mixup[68] ^ v_mixin[(i +  5) % 96];
            v_res[26] = v_mixup[26] ^ (v_mixup[71] & ~v_mixup[72]) ^ v_mixup[62] ^ v_mixup[69] ^ v_mixin[(i +  3) % 96];
            v_res[27] = v_mixup[27] ^ (v_mixup[72] & ~v_mixup[73]) ^ v_mixup[63] ^ v_mixup[70] ^ v_mixin[(i + 63) % 96];
            v_res[28] = v_mixup[28] ^ (v_mixup[73] & ~v_mixup[74]) ^ v_mixup[64] ^ v_mixup[71] ^ v_mixin[(i + 31) % 96];
            v_res[29] = v_mixup[29] ^ (v_mixup[74] & ~v_mixup[75]) ^ v_mixup[65] ^ v_mixup[72] ^ v_mixin[(i + 16) % 96];
            v_res[30] = v_mixup[30] ^ (v_mixup[75] & ~v_mixup[76]) ^ v_mixup[66] ^ v_mixup[73] ^ v_mixin[(i + 87) % 96];
            v_res[31] = v_mixup[31] ^ (v_mixup[76] & ~v_mixup[77]) ^ v_mixup[67] ^ v_mixup[74] ^ v_mixin[(i + 38) % 96];
            v_res[32] = v_mixup[32] ^ (v_mixup[77] & ~v_mixup[78]) ^ v_mixup[68] ^ v_mixup[75] ^ v_mixin[(i + 10) % 96];
            v_res[33] = v_mixup[33] ^ (v_mixup[78] & ~v_mixup[79]) ^ v_mixup[69] ^ v_mixup[76] ^ v_mixin[(i + 81) % 96];
            v_res[34] = v_mixup[34] ^ (v_mixup[79] & ~v_mixup[80]) ^ v_mixup[70] ^ v_mixup[77] ^ v_mixin[(i + 60) % 96];
            v_res[35] = v_mixup[35] ^ (v_mixup[80] & ~v_mixup[81]) ^ v_mixup[71] ^ v_mixup[78] ^ v_mixin[(i + 51) % 96];
            v_res[36] = v_mixup[36] ^ (v_mixup[81] & ~v_mixup[82]) ^ v_mixup[72] ^ v_mixup[79] ^ v_mixin[(i + 43) % 96];
            v_res[37] = v_mixup[37] ^ (v_mixup[82] & ~v_mixup[83]) ^ v_mixup[73] ^ v_mixup[80] ^ v_mixin[(i + 75) % 96];
            v_res[38] = v_mixup[38] ^ (v_mixup[83] & ~v_mixup[84]) ^ v_mixup[74] ^ v_mixup[81] ^ v_mixin[(i +  8) % 96];
            v_res[39] = v_mixup[39] ^ (v_mixup[84] & ~v_mixup[85]) ^ v_mixup[75] ^ v_mixup[82] ^ v_mixin[(i + 89) % 96];
            v_res[40] = v_mixup[40] ^ (v_mixup[85] & ~v_mixup[86]) ^ v_mixup[76] ^ v_mixup[83] ^ v_mixin[(i + 39) % 96];
            v_res[41] = v_mixup[41] ^ (v_mixup[86] & ~v_mixup[87]) ^ v_mixup[77] ^ v_mixup[84] ^ v_mixin[(i + 86) % 96];
            v_res[42] = v_mixup[42] ^ (v_mixup[87] & ~v_mixup[88]) ^ v_mixup[78] ^ v_mixup[85] ^ v_mixin[(i + 14) % 96];
            v_res[43] = v_mixup[43] ^ (v_mixup[88] & ~v_mixup[89]) ^ v_mixup[79] ^ v_mixup[86] ^ v_mixin[(i +  7) % 96];
            v_res[44] = v_mixup[44] ^ (v_mixup[89] & ~v_mixup[90]) ^ v_mixup[80] ^ v_mixup[87] ^ v_mixin[(i + 52) % 96];
            v_res[45] = v_mixup[45] ^ (v_mixup[90] & ~v_mixup[91]) ^ v_mixup[81] ^ v_mixup[88] ^ v_mixin[(i +  0) % 96];
            v_res[46] = v_mixup[46] ^ (v_mixup[91] & ~v_mixup[92]) ^ v_mixup[82] ^ v_mixup[89] ^ v_mixin[(i + 49) % 96];
            v_res[47] = v_mixup[47] ^ (v_mixup[92] & ~v_mixup[93]) ^ v_mixup[83] ^ v_mixup[90] ^ v_mixin[(i + 17) % 96];
            v_state_y2[96 * i +: 96] = {v_res, v_state_y1[96 * i + 48 +: 48]};
        end
        
    end
    
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            
            r_state_x <= seed_x;
            r_state_y <= seed_y;
            
        end else if (enable == 1'b1) begin
            
            r_state_x[ 0] <= r_state_x[ 2] ^ r_state_x[75] ^ r_state_x[41] ^ r_state_x[57] ^ r_state_x[14];
            r_state_x[ 1] <= r_state_x[ 9] ^ r_state_x[13] ^ r_state_x[15] ^ r_state_x[10] ^ r_state_x[59] ^ r_state_x[88];
            r_state_x[ 2] <= r_state_x[ 6] ^ r_state_x[78] ^ r_state_x[53] ^ r_state_x[ 3] ^ r_state_x[59];
            r_state_x[ 3] <= r_state_x[92] ^ r_state_x[43] ^ r_state_x[20] ^ r_state_x[ 8] ^ r_state_x[38] ^ r_state_x[56];
            r_state_x[ 4] <= r_state_x[38] ^ r_state_x[25] ^ r_state_x[47] ^ r_state_x[ 0] ^ r_state_x[ 7];
            r_state_x[ 5] <= r_state_x[52] ^ r_state_x[18] ^ r_state_x[94] ^ r_state_x[66] ^ r_state_x[28] ^ r_state_x[13];
            r_state_x[ 6] <= r_state_x[54] ^ r_state_x[14] ^ r_state_x[51] ^ r_state_x[52] ^ r_state_x[18];
            r_state_x[ 7] <= r_state_x[16] ^ r_state_x[62] ^ r_state_x[64] ^ r_state_x[88] ^ r_state_x[43] ^ r_state_x[61];
            r_state_x[ 8] <= r_state_x[ 0] ^ r_state_x[85] ^ r_state_x[62] ^ r_state_x[28] ^ r_state_x[23];
            r_state_x[ 9] <= r_state_x[50] ^ r_state_x[25] ^ r_state_x[ 6] ^ r_state_x[41] ^ r_state_x[30] ^ r_state_x[95];
            r_state_x[10] <= r_state_x[76] ^ r_state_x[95] ^ r_state_x[58] ^ r_state_x[16] ^ r_state_x[85];
            r_state_x[11] <= r_state_x[43] ^ r_state_x[36] ^ r_state_x[45] ^ r_state_x[80] ^ r_state_x[78] ^ r_state_x[17];
            r_state_x[12] <= r_state_x[ 1] ^ r_state_x[42] ^ r_state_x[75] ^ r_state_x[81] ^ r_state_x[59];
            r_state_x[13] <= r_state_x[19] ^ r_state_x[56] ^ r_state_x[23] ^ r_state_x[55] ^ r_state_x[84] ^ r_state_x[79];
            r_state_x[14] <= r_state_x[12] ^ r_state_x[46] ^ r_state_x[19] ^ r_state_x[ 5] ^ r_state_x[48];
            r_state_x[15] <= r_state_x[71] ^ r_state_x[ 6] ^ r_state_x[59] ^ r_state_x[44] ^ r_state_x[10] ^ r_state_x[39];
            r_state_x[16] <= r_state_x[11] ^ r_state_x[77] ^ r_state_x[ 4] ^ r_state_x[21] ^ r_state_x[58];
            r_state_x[17] <= r_state_x[ 9] ^ r_state_x[44] ^ r_state_x[62] ^ r_state_x[15] ^ r_state_x[84] ^ r_state_x[40];
            r_state_x[18] <= r_state_x[25] ^ r_state_x[93] ^ r_state_x[48] ^ r_state_x[87] ^ r_state_x[32];
            r_state_x[19] <= r_state_x[48] ^ r_state_x[82] ^ r_state_x[45] ^ r_state_x[ 8] ^ r_state_x[29] ^ r_state_x[90];
            r_state_x[20] <= r_state_x[10] ^ r_state_x[30] ^ r_state_x[59] ^ r_state_x[46] ^ r_state_x[69];
            r_state_x[21] <= r_state_x[55] ^ r_state_x[88] ^ r_state_x[78] ^ r_state_x[53] ^ r_state_x[ 1] ^ r_state_x[63];
            r_state_x[22] <= r_state_x[62] ^ r_state_x[80] ^ r_state_x[33] ^ r_state_x[37] ^ r_state_x[53];
            r_state_x[23] <= r_state_x[ 3] ^ r_state_x[35] ^ r_state_x[34] ^ r_state_x[37] ^ r_state_x[ 1] ^ r_state_x[23];
            r_state_x[24] <= r_state_x[52] ^ r_state_x[51] ^ r_state_x[86] ^ r_state_x[69] ^ r_state_x[17];
            r_state_x[25] <= r_state_x[27] ^ r_state_x[50] ^ r_state_x[79] ^ r_state_x[83] ^ r_state_x[76] ^ r_state_x[95];
            r_state_x[26] <= r_state_x[78] ^ r_state_x[42] ^ r_state_x[70] ^ r_state_x[57] ^ r_state_x[94];
            r_state_x[27] <= r_state_x[87] ^ r_state_x[22] ^ r_state_x[26] ^ r_state_x[49] ^ r_state_x[84] ^ r_state_x[83];
            r_state_x[28] <= r_state_x[94] ^ r_state_x[76] ^ r_state_x[28] ^ r_state_x[42] ^ r_state_x[14];
            r_state_x[29] <= r_state_x[11] ^ r_state_x[22] ^ r_state_x[92] ^ r_state_x[58] ^ r_state_x[88] ^ r_state_x[16];
            r_state_x[30] <= r_state_x[40] ^ r_state_x[77] ^ r_state_x[12] ^ r_state_x[65] ^ r_state_x[34];
            r_state_x[31] <= r_state_x[31] ^ r_state_x[ 8] ^ r_state_x[21] ^ r_state_x[15] ^ r_state_x[68] ^ r_state_x[75];
            r_state_x[32] <= r_state_x[39] ^ r_state_x[64] ^ r_state_x[90] ^ r_state_x[69] ^ r_state_x[79];
            r_state_x[33] <= r_state_x[85] ^ r_state_x[35] ^ r_state_x[61] ^ r_state_x[90] ^ r_state_x[63] ^ r_state_x[92];
            r_state_x[34] <= r_state_x[34] ^ r_state_x[12] ^ r_state_x[73] ^ r_state_x[57] ^ r_state_x[ 1];
            r_state_x[35] <= r_state_x[79] ^ r_state_x[37] ^ r_state_x[32] ^ r_state_x[47] ^ r_state_x[66] ^ r_state_x[86];
            r_state_x[36] <= r_state_x[43] ^ r_state_x[35] ^ r_state_x[25] ^ r_state_x[65] ^ r_state_x[72];
            r_state_x[37] <= r_state_x[40] ^ r_state_x[24] ^ r_state_x[77] ^ r_state_x[59] ^ r_state_x[16] ^ r_state_x[50];
            r_state_x[38] <= r_state_x[45] ^ r_state_x[20] ^ r_state_x[56] ^ r_state_x[46] ^ r_state_x[80];
            r_state_x[39] <= r_state_x[25] ^ r_state_x[70] ^ r_state_x[64] ^ r_state_x[31] ^ r_state_x[46] ^ r_state_x[74];
            r_state_x[40] <= r_state_x[72] ^ r_state_x[65] ^ r_state_x[ 2] ^ r_state_x[36] ^ r_state_x[69];
            r_state_x[41] <= r_state_x[90] ^ r_state_x[ 3] ^ r_state_x[71] ^ r_state_x[86] ^ r_state_x[18] ^ r_state_x[63];
            r_state_x[42] <= r_state_x[47] ^ r_state_x[ 4] ^ r_state_x[27] ^ r_state_x[24] ^ r_state_x[92];
            r_state_x[43] <= r_state_x[48] ^ r_state_x[67] ^ r_state_x[68] ^ r_state_x[42] ^ r_state_x[89] ^ r_state_x[85];
            r_state_x[44] <= r_state_x[10] ^ r_state_x[51] ^ r_state_x[13] ^ r_state_x[60] ^ r_state_x[89];
            r_state_x[45] <= r_state_x[60] ^ r_state_x[ 7] ^ r_state_x[32] ^ r_state_x[68] ^ r_state_x[30] ^ r_state_x[71];
            r_state_x[46] <= r_state_x[33] ^ r_state_x[19] ^ r_state_x[ 3] ^ r_state_x[65] ^ r_state_x[ 8];
            r_state_x[47] <= r_state_x[34] ^ r_state_x[30] ^ r_state_x[86] ^ r_state_x[38] ^ r_state_x[31] ^ r_state_x[29];
            r_state_x[48] <= r_state_x[55] ^ r_state_x[41] ^ r_state_x[26] ^ r_state_x[ 9] ^ r_state_x[ 7];
            r_state_x[49] <= r_state_x[ 4] ^ r_state_x[53] ^ r_state_x[ 7] ^ r_state_x[44] ^ r_state_x[36] ^ r_state_x[24];
            r_state_x[50] <= r_state_x[ 4] ^ r_state_x[ 7] ^ r_state_x[49] ^ r_state_x[93] ^ r_state_x[22];
            r_state_x[51] <= r_state_x[ 6] ^ r_state_x[53] ^ r_state_x[66] ^ r_state_x[75] ^ r_state_x[35] ^ r_state_x[95];
            r_state_x[52] <= r_state_x[30] ^ r_state_x[14] ^ r_state_x[24] ^ r_state_x[28] ^ r_state_x[87];
            r_state_x[53] <= r_state_x[10] ^ r_state_x[52] ^ r_state_x[13] ^ r_state_x[11] ^ r_state_x[33] ^ r_state_x[40];
            r_state_x[54] <= r_state_x[19] ^ r_state_x[ 4] ^ r_state_x[83] ^ r_state_x[32] ^ r_state_x[ 7];
            r_state_x[55] <= r_state_x[85] ^ r_state_x[27] ^ r_state_x[93] ^ r_state_x[94] ^ r_state_x[ 7] ^ r_state_x[73];
            r_state_x[56] <= r_state_x[68] ^ r_state_x[92] ^ r_state_x[32] ^ r_state_x[13] ^ r_state_x[10];
            r_state_x[57] <= r_state_x[57] ^ r_state_x[90] ^ r_state_x[36] ^ r_state_x[87] ^ r_state_x[75] ^ r_state_x[54];
            r_state_x[58] <= r_state_x[ 2] ^ r_state_x[24] ^ r_state_x[ 0] ^ r_state_x[38] ^ r_state_x[45];
            r_state_x[59] <= r_state_x[21] ^ r_state_x[ 0] ^ r_state_x[28] ^ r_state_x[13] ^ r_state_x[53] ^ r_state_x[54];
            r_state_x[60] <= r_state_x[40] ^ r_state_x[73] ^ r_state_x[80] ^ r_state_x[95] ^ r_state_x[46];
            r_state_x[61] <= r_state_x[84] ^ r_state_x[43] ^ r_state_x[73] ^ r_state_x[22] ^ r_state_x[92] ^ r_state_x[38];
            r_state_x[62] <= r_state_x[52] ^ r_state_x[ 1] ^ r_state_x[76] ^ r_state_x[39] ^ r_state_x[86];
            r_state_x[63] <= r_state_x[48] ^ r_state_x[ 2] ^ r_state_x[86] ^ r_state_x[17] ^ r_state_x[49] ^ r_state_x[93];
            r_state_x[64] <= r_state_x[74] ^ r_state_x[25] ^ r_state_x[69] ^ r_state_x[ 6] ^ r_state_x[37];
            r_state_x[65] <= r_state_x[15] ^ r_state_x[23] ^ r_state_x[52] ^ r_state_x[77] ^ r_state_x[91] ^ r_state_x[51];
            r_state_x[66] <= r_state_x[81] ^ r_state_x[20] ^ r_state_x[64] ^ r_state_x[ 5] ^ r_state_x[87];
            r_state_x[67] <= r_state_x[51] ^ r_state_x[15] ^ r_state_x[20] ^ r_state_x[72] ^ r_state_x[39] ^ r_state_x[60];
            r_state_x[68] <= r_state_x[43] ^ r_state_x[89] ^ r_state_x[35] ^ r_state_x[70] ^ r_state_x[37];
            r_state_x[69] <= r_state_x[71] ^ r_state_x[40] ^ r_state_x[34] ^ r_state_x[66] ^ r_state_x[60] ^ r_state_x[14];
            r_state_x[70] <= r_state_x[48] ^ r_state_x[32] ^ r_state_x[29] ^ r_state_x[76] ^ r_state_x[87];
            r_state_x[71] <= r_state_x[44] ^ r_state_x[89] ^ r_state_x[19] ^ r_state_x[20] ^ r_state_x[ 9] ^ r_state_x[77];
            r_state_x[72] <= r_state_x[81] ^ r_state_x[ 8] ^ r_state_x[75] ^ r_state_x[49] ^ r_state_x[47];
            r_state_x[73] <= r_state_x[29] ^ r_state_x[41] ^ r_state_x[67] ^ r_state_x[12] ^ r_state_x[ 6] ^ r_state_x[56];
            r_state_x[74] <= r_state_x[49] ^ r_state_x[82] ^ r_state_x[ 5] ^ r_state_x[17] ^ r_state_x[58];
            r_state_x[75] <= r_state_x[78] ^ r_state_x[62] ^ r_state_x[19] ^ r_state_x[68] ^ r_state_x[63] ^ r_state_x[94];
            r_state_x[76] <= r_state_x[18] ^ r_state_x[45] ^ r_state_x[57] ^ r_state_x[41] ^ r_state_x[ 1];
            r_state_x[77] <= r_state_x[83] ^ r_state_x[58] ^ r_state_x[72] ^ r_state_x[31] ^ r_state_x[74] ^ r_state_x[63];
            r_state_x[78] <= r_state_x[13] ^ r_state_x[79] ^ r_state_x[47] ^ r_state_x[67] ^ r_state_x[71];
            r_state_x[79] <= r_state_x[31] ^ r_state_x[91] ^ r_state_x[69] ^ r_state_x[47] ^ r_state_x[74] ^ r_state_x[65];
            r_state_x[80] <= r_state_x[16] ^ r_state_x[72] ^ r_state_x[81] ^ r_state_x[82] ^ r_state_x[26];
            r_state_x[81] <= r_state_x[42] ^ r_state_x[57] ^ r_state_x[41] ^ r_state_x[88] ^ r_state_x[95] ^ r_state_x[12];
            r_state_x[82] <= r_state_x[81] ^ r_state_x[91] ^ r_state_x[40] ^ r_state_x[11] ^ r_state_x[26];
            r_state_x[83] <= r_state_x[50] ^ r_state_x[93] ^ r_state_x[27] ^ r_state_x[70] ^ r_state_x[77] ^ r_state_x[92];
            r_state_x[84] <= r_state_x[80] ^ r_state_x[ 9] ^ r_state_x[64] ^ r_state_x[34] ^ r_state_x[70];
            r_state_x[85] <= r_state_x[ 2] ^ r_state_x[74] ^ r_state_x[29] ^ r_state_x[83] ^ r_state_x[67] ^ r_state_x[18];
            r_state_x[86] <= r_state_x[20] ^ r_state_x[47] ^ r_state_x[33] ^ r_state_x[60] ^ r_state_x[19];
            r_state_x[87] <= r_state_x[17] ^ r_state_x[52] ^ r_state_x[39] ^ r_state_x[89] ^ r_state_x[67] ^ r_state_x[91];
            r_state_x[88] <= r_state_x[54] ^ r_state_x[ 5] ^ r_state_x[39] ^ r_state_x[79] ^ r_state_x[77];
            r_state_x[89] <= r_state_x[82] ^ r_state_x[21] ^ r_state_x[84] ^ r_state_x[42] ^ r_state_x[36] ^ r_state_x[66];
            r_state_x[90] <= r_state_x[ 9] ^ r_state_x[32] ^ r_state_x[ 0] ^ r_state_x[11] ^ r_state_x[23];
            r_state_x[91] <= r_state_x[ 5] ^ r_state_x[56] ^ r_state_x[61] ^ r_state_x[72] ^ r_state_x[18] ^ r_state_x[55];
            r_state_x[92] <= r_state_x[58] ^ r_state_x[95] ^ r_state_x[86] ^ r_state_x[81] ^ r_state_x[22];
            r_state_x[93] <= r_state_x[73] ^ r_state_x[26] ^ r_state_x[70] ^ r_state_x[ 3] ^ r_state_x[61] ^ r_state_x[82];
            r_state_x[94] <= r_state_x[44] ^ r_state_x[ 8] ^ r_state_x[ 2] ^ r_state_x[50] ^ r_state_x[42];
            r_state_x[95] <= r_state_x[55] ^ r_state_x[83] ^ r_state_x[ 5] ^ r_state_x[33] ^ r_state_x[16] ^ r_state_x[21];
            
            r_state_y <= v_state_y2;
            
        end
    end
    
endmodule
