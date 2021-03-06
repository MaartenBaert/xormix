// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

// This file was generated by `generate_verilog.py`.

`timescale 1ns/1ps

module xormix16_tb;
    
    // configuration
    localparam streams = 4;
    localparam results = 100;
    localparam [15 : 0] seed_x =
        16'h2138;
    localparam [16 * streams - 1 : 0] seed_y =
        64'h626e6b2fc22539a4;
    
    // reference result
    localparam [16 * streams * results - 1 : 0] ref_result = {
        64'h180ddc11f504cf72,
        64'heb2929cb008ee444,
        64'h08f50bc4028f8d83,
        64'hea8f776b51c064de,
        64'h6352987350a71852,
        64'h9a35601212afe909,
        64'h2c1676e60d3a1b76,
        64'h27523fa868247f44,
        64'hbff32714ed83414d,
        64'h94cf86dd58373717,
        64'hd78788238f58ca95,
        64'h438e7bc5b5f37504,
        64'h91178c67755ecb0c,
        64'h7df8182f25735f41,
        64'h3fb0ad12ba22b1b6,
        64'h29c3b9323ce4d0f5,
        64'hd8df25d328c621a4,
        64'h57305a64ac1ae4c0,
        64'h245c5b833635f2cc,
        64'hbcce56d304ce423f,
        64'he90202775ad783c4,
        64'hc20351047a6447c7,
        64'he8d22edf2898672e,
        64'hb01bfffa1de1264c,
        64'ha57e5e49c03b518f,
        64'h9c1c64e2512061f4,
        64'hd09b2a545ce37d12,
        64'h976b1c51f47c114a,
        64'h5f02a251355f6e45,
        64'h1948b6bd87d7c100,
        64'hdf9a6f141b84a7ae,
        64'h805c7a978811c5bb,
        64'hbeac2f95da8db45e,
        64'h7ff7d667f25ac2cc,
        64'hb3f80596cb4af430,
        64'hcaf07a34d43b50c5,
        64'h330988989108e1a9,
        64'h6fcbe01c56e48bac,
        64'h53cdb26ac48e83a1,
        64'h83d489ee944b4354,
        64'h75c23fc17ddaa3a8,
        64'h69db7e9834094ead,
        64'h9a425d6a5a2067f7,
        64'he626892bbb0cdcbf,
        64'h6c7c00314852c580,
        64'hdfc75cc365d8fc45,
        64'hef76db6565f6d63f,
        64'h511d86ed1e38801c,
        64'hcf34908db3483b67,
        64'h2cf6ec11a0c938e1,
        64'h266034617aab9bd2,
        64'h8d2aaf56c34442a7,
        64'h16f1dbd8b18f9e5b,
        64'hb5666647b61a2235,
        64'hf37a960f2e550644,
        64'h16ec23d2d87d673b,
        64'hd85b3c2f657e646e,
        64'hf4061091ed96c44b,
        64'h9e286cd025fca669,
        64'hd67cc6b9c9c50936,
        64'h85f472c0ab116786,
        64'h4ef609759fbaafba,
        64'h67bcc3d9ee685b9a,
        64'hc5f6c9fcfc862e51,
        64'h61efbcb2b0bde314,
        64'h9b074623255ec881,
        64'hf06569a869b4a918,
        64'hcef331211c051d24,
        64'h9204004d5af269c8,
        64'h143b4838c2e2193b,
        64'h8bb834fab0e1f733,
        64'h6842668cc61eba5c,
        64'h9aa01c0f9352e7d1,
        64'h19f9e8c9f96ae95e,
        64'h3441a8b52d90d6ae,
        64'hc41cbe81bd747e8e,
        64'hf89eb8fb947a3e52,
        64'h0f128f59259317ef,
        64'hfbe9227d76337329,
        64'hafca1d652d2fe0c9,
        64'hfed41f0b05c03945,
        64'ha912f546c593ecdd,
        64'hd4f42c9da069f5da,
        64'h8705d9aca121dbe5,
        64'h6ba645d03312d753,
        64'h5b268caabdda8744,
        64'hf11a77b9d918a03d,
        64'hf72fbad55ce2a076,
        64'h1fdc4f9dd3735ea7,
        64'h12f0845930322701,
        64'h0aa8427a846126d6,
        64'h76b2e87382aae5e0,
        64'hba2f2b861af57daa,
        64'hffbccb8e6fc7c26a,
        64'hb8c6a31a16eab1c2,
        64'h6a30758d38487807,
        64'ha4900829f70d5098,
        64'h2762db54f63e35c6,
        64'hc5dd4a17cf8c11a4,
        64'h626e6b2fc22539a4
    };
    
    // DUT signals
    reg clk = 0;
    reg rst;
    reg enable;
    wire [16 * streams - 1 : 0] result;
    
    // flag to stop simulation
    integer run = 1;
    
    // error counter
    integer errors = 0;
    
    // DUT
    xormix16 #(
        .streams(streams)
    ) inst_xormix (
        .clk(clk),
        .rst(rst),
        .seed_x(seed_x),
        .seed_y(seed_y),
        .enable(enable),
        .result(result)
    );
    
    // clock process
    initial begin
        while (run == 1) begin
            clk = 1'b1;
            #5;
            clk = 1'b0;
            #5;
        end
    end
    
    integer i;
    
    // input/output process
    initial begin
        @(posedge clk);
        rst <= 1'b1;
        enable <= 1'b0;
        @(posedge clk);
        rst <= 1'b0;
        enable <= 1'b1;
        for (i = 0; i < results; i = i + 1) begin
            @(posedge clk);
            if (result !== ref_result[16 * streams * i +: 16 * streams]) begin
                $display("Incorrect result for i=%d", i);
                errors = errors + 1;
            end
        end
        $display("Test complete, number of errors: %d", errors);
        run <= 0;
    end
    
endmodule
