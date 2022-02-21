Xormix Hardware Module (VHDL/Verilog) Interface
===============================================

This document describes the interface of the xormix hardware modules. There are portable hardware implementations in VHDL and Verilog that can be found in the `vhdl` and `verilog` directories, and a non-portable implementation optimized for Xilinx 7 Series FPGAs that can be found in the `vhdl_x7s` directory.

Portable VHDL/Verilog implementations
-------------------------------------

The portable VHDL and Verilog implementations are identical in functionality and interface. These modules were intentionally kept as simple as possible, for this reason they do not include flow control or seed management. It is expected that users will modify these modules to meet the requirements of their application. The recommended seeding procedure is described on the [Xormix Algorithm](doc/algorithm.md) page.

The following hardware modules are available:

- xormix16
- xormix24
- xormix32
- xormix48
- xormix64
- xormix96
- xormix128

All modules have the same interface:

| Port   | Direction | Type       | Size  | Description                                       |
| ------ | --------- | ---------- | ----- | ------------------------------------------------- |
| clk    | input     | bit        | 1     | Clock                                             |
| rst    | input     | bit        | 1     | Synchronous reset/reseed signal, active high      |
| seed_x | input     | bit vector | N     | X seed value (first stage), applied during reset  |
| seed_y | input     | bit vector | S * N | Y seed value (second stage), applied during reset |
| enable | input     | bit        | 1     | Enable input, advances the PRNG to the next value |
| result | output    | bit vector | S * N | Random data output, registered                    |

The following timing diagram shows the typical usage of the module:

![Block diagram](wavedrom/timing-diagram.svg)

Non-portable Xilinx 7 Series FPGA implementation
------------------------------------------------

This implementation can be found in the `vhdl_x7s` directory. It is identical to the portable implementation in terms of functionality and interface, but rather than relying on the synthesis software to map the logical functions to LUTs, this implementation explicitly instantiates LUTs to generate the most efficient mapping possible, which is often much better than what the synthesis software is able to generate. The module is implemented in VHDL, but can also be used in Verilog designs.
