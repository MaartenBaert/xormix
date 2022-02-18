-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl_x7s.py`.
-- This is a non-portable implementation optimized for Xilinx 7-Series FPGAs.
-- Revision: 1

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity xormix24_x7s is
    generic (
        streams : integer range 1 to 24 := 1
    );
    port (
        
        -- clock and synchronous reset
        clk    : in std_logic;
        rst    : in std_logic;
        
        -- configuration
        seed_x : in std_logic_vector(23 downto 0);
        seed_y : in std_logic_vector(24 * streams - 1 downto 0);
        
        -- random number generator
        enable : in std_logic;
        result : out std_logic_vector(24 * streams - 1 downto 0)
        
    );
end xormix24_x7s;

architecture rtl of xormix24_x7s is
    
    constant lutval_xor5 : bit_vector(31 downto 0) := x"96696996";
    constant lutval_xor6 : bit_vector(63 downto 0) := x"6996966996696996";
    constant lutval_mix0 : bit_vector(63 downto 0) := x"59a6a659a65959a6";
    constant lutval_mix1 : bit_vector(63 downto 0) := x"a65959a659a6a659";
    
    function select_lutval_mix(
        bit : std_logic
    ) return bit_vector is
    begin
        if bit = '0' then
            return lutval_mix0;
        else
            return lutval_mix1;
        end if;
    end select_lutval_mix;
    
    type matrix_t is array(0 to 11, 0 to 10) of integer range 0 to 23;
    constant matrix : matrix_t := (
        ( 0, 17,  2,  9, 22, 18,  1, 14, 11,  4,  9),
        (19, 15, 17, 23,  7, 18, 13, 14,  0,  6,  7),
        (18, 20,  1, 19, 11, 23, 15,  5, 16,  4,  3),
        ( 2,  6,  3, 15, 20,  4,  5, 16,  8, 12, 21),
        (20,  5, 10, 15,  2,  3, 23, 14,  0,  9, 20),
        ( 1, 11,  0, 23, 13, 20,  8, 10, 14,  7,  2),
        ( 8,  6,  0,  3, 16,  5, 22, 16,  2, 18, 11),
        ( 2, 22,  3,  8,  1,  5, 21, 22,  7, 11, 10),
        (12,  6, 15, 14,  4,  9,  4,  1, 17,  6, 19),
        (12, 20, 22,  9, 21, 16, 19, 18, 12,  0,  3),
        ( 3, 10, 14, 17,  1, 23, 13, 21,  9, 12,  7),
        (22, 14,  8,  9, 10,  8, 19, 21, 23, 17, 13)
    );
    
    type salts_t is array(0 to 23) of std_logic_vector(23 downto 0);
    constant salts : salts_t := (
        x"d96a94", x"8c3c8d", x"b8b710", x"112b89",
        x"6aaf55", x"295e05", x"a64b72", x"39b1db",
        x"5c5955", x"915302", x"040da6", x"e79f3f",
        x"f52624", x"ce7aee", x"74c90b", x"00c73d",
        x"1cee53", x"eb76b1", x"271093", x"73ac8e",
        x"57622b", x"bf29d0", x"02efea", x"a1befc"
    );
    
    type shuffle_t is array(0 to 23) of integer range 0 to 23;
    constant shuffle : shuffle_t := (
         0,  7, 17,  8,  9, 13, 11, 12,
         2, 16, 14,  4, 21, 10,  3, 20,
        22, 19, 15,  1,  5, 23,  6, 18
    );
    
    signal r_state_x : std_logic_vector(23 downto 0);
    signal r_state_y : std_logic_vector(24 * streams - 1 downto 0);
    
    signal state_x_next : std_logic_vector(23 downto 0);
    signal state_y_next : std_logic_vector(24 * streams - 1 downto 0);
    
    type state_sr_t is array(0 to streams - 1) of std_logic_vector(47 downto 0);
    signal state_sr : state_sr_t;
    
begin
    
    result <= r_state_y;
    
    gen_bits: for i in 0 to 11 generate
        lut_xor5: LUT5 generic map (
            INIT => lutval_xor5
        ) port map (
            O => state_x_next(2 * i),
            I0 => r_state_x(matrix(i, 0)),
            I1 => r_state_x(matrix(i, 1)),
            I2 => r_state_x(matrix(i, 2)),
            I3 => r_state_x(matrix(i, 3)),
            I4 => r_state_x(matrix(i, 4))
        );
        lut_xor6: LUT6 generic map (
            INIT => lutval_xor6
        ) port map (
            O => state_x_next(2 * i + 1),
            I0 => r_state_x(matrix(i, 5)),
            I1 => r_state_x(matrix(i, 6)),
            I2 => r_state_x(matrix(i, 7)),
            I3 => r_state_x(matrix(i, 8)),
            I4 => r_state_x(matrix(i, 9)),
            I5 => r_state_x(matrix(i, 10))
        );
    end generate;
    
    gen_stream: for i in 0 to streams - 1 generate
        constant k : integer := (i + 1) mod streams;
    begin
        state_sr(i)(23 downto 0) <= r_state_y(24 * i + 23 downto 24 * i);
        gen_bit: for j in 0 to 23 generate
            constant l : integer := (i + shuffle(j)) mod 24;
        begin
            lut_mix: LUT6 generic map (
                INIT => select_lutval_mix(salts(i)(l))
            ) port map (
                O => state_sr(i)(j + 24),
                I0 => state_sr(k)(j),
                I1 => state_sr(k)(j + 8),
                I2 => state_sr(k)(j + 12),
                I3 => state_sr(k)(j + 9),
                I4 => state_sr(k)(j + 11),
                I5 => r_state_x(l)
            );
        end generate;
        state_y_next(24 * i + 23 downto 24 * i) <= state_sr(i)(47 downto 24);
    end generate;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r_state_x <= seed_x;
                r_state_y <= seed_y;
            elsif enable = '1' then
                r_state_x <= state_x_next;
                r_state_y <= state_y_next;
            end if;
        end if;
    end process;
    
end rtl;

