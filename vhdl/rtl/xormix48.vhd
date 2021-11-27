-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl.py`.

library ieee;
use ieee.std_logic_1164.all;

entity xormix48 is
    generic (
        streams : integer range 1 to 48 := 1
    );
    port (
        
        -- clock and synchronous reset
        clk    : in std_logic;
        rst    : in std_logic;
        
        -- configuration
        seed_x : in std_logic_vector(47 downto 0);
        seed_y : in std_logic_vector(48 * streams - 1 downto 0);
        
        -- random number generator
        enable : in std_logic;
        result : out std_logic_vector(48 * streams - 1 downto 0)
        
    );
end xormix48;

architecture rtl of xormix48 is
    
    type salts_t is array(0 to 47) of std_logic_vector(47 downto 0);
    constant salts : salts_t := (
        x"dc2a970723c9", x"e3e9a7b5f00f", x"368fddfe10b2", x"75cf3224f670",
        x"adc3319ee962", x"c9fdd5da7238", x"838aa6d68e51", x"34504e889c4e",
        x"16f61844dd41", x"316767a3bcb6", x"4f2b4ee6a079", x"8a9ef2995097",
        x"8f8919a04ad3", x"54d0862260f6", x"59bf4852d6de", x"e182ee2c64dc",
        x"117087d44a4c", x"2de1ba749c87", x"4db37369078b", x"c4d0b2be2d19",
        x"fe1e25f4f213", x"11f41b1ba06e", x"0f2cf602d40a", x"1a4f0b78edd2",
        x"0635bdf9a9a1", x"e6066341f129", x"d63a2e6c6b6e", x"3f0b1417a83e",
        x"aa5f9fc3447b", x"fd4ca29740b2", x"d307b0424a1f", x"377cf18c8a09",
        x"4ae1ee2f8ff1", x"6470f197fbcc", x"93fb56272e46", x"b8ff040d894b",
        x"7de7947afb4b", x"8c2c614e379f", x"981e3a7298fb", x"1d16c2d1672f",
        x"3e8785982f5c", x"e92ab1204c26", x"f7c8549141c1", x"109c81c9df19",
        x"9379f90a2ff8", x"583491406df0", x"00302447d0cf", x"34c3236725e9"
    );
    
    signal r_state_x : std_logic_vector(47 downto 0);
    signal r_state_y : std_logic_vector(48 * streams - 1 downto 0);
    
begin
    
    result <= r_state_y;
    
    process (clk)
        
        variable v_state_y : std_logic_vector(48 * streams - 1 downto 0);
        
        variable v_mixin : std_logic_vector(47 downto 0);
        variable v_mixup : std_logic_vector(47 downto 0);
        variable v_res : std_logic_vector(23 downto 0);
        
    begin
        if rising_edge(clk) then
            if rst = '1' then
                
                r_state_x <= seed_x;
                r_state_y <= seed_y;
                
            elsif enable = '1' then
                
                r_state_x( 0) <= r_state_x(22) xor r_state_x(15) xor r_state_x(43) xor r_state_x( 7) xor r_state_x(11);
                r_state_x( 1) <= r_state_x(42) xor r_state_x(14) xor r_state_x(12) xor r_state_x(35) xor r_state_x(11) xor r_state_x(17);
                r_state_x( 2) <= r_state_x(15) xor r_state_x(31) xor r_state_x(24) xor r_state_x(44) xor r_state_x(47);
                r_state_x( 3) <= r_state_x(26) xor r_state_x(32) xor r_state_x(47) xor r_state_x(21) xor r_state_x(35) xor r_state_x(11);
                r_state_x( 4) <= r_state_x( 6) xor r_state_x(46) xor r_state_x(36) xor r_state_x( 4) xor r_state_x(33);
                r_state_x( 5) <= r_state_x(33) xor r_state_x(19) xor r_state_x(24) xor r_state_x(32) xor r_state_x( 3) xor r_state_x(38);
                r_state_x( 6) <= r_state_x( 1) xor r_state_x(38) xor r_state_x(47) xor r_state_x(16) xor r_state_x(21);
                r_state_x( 7) <= r_state_x(25) xor r_state_x(28) xor r_state_x(29) xor r_state_x(24) xor r_state_x(35) xor r_state_x(43);
                r_state_x( 8) <= r_state_x(34) xor r_state_x( 5) xor r_state_x(41) xor r_state_x( 3) xor r_state_x( 0);
                r_state_x( 9) <= r_state_x(37) xor r_state_x(34) xor r_state_x(22) xor r_state_x( 2) xor r_state_x(13) xor r_state_x(14);
                r_state_x(10) <= r_state_x(45) xor r_state_x( 1) xor r_state_x(40) xor r_state_x( 8) xor r_state_x(17);
                r_state_x(11) <= r_state_x(20) xor r_state_x(41) xor r_state_x( 9) xor r_state_x(23) xor r_state_x(32) xor r_state_x(24);
                r_state_x(12) <= r_state_x( 4) xor r_state_x(23) xor r_state_x(25) xor r_state_x( 5) xor r_state_x(35);
                r_state_x(13) <= r_state_x( 8) xor r_state_x(19) xor r_state_x(14) xor r_state_x(28) xor r_state_x(44) xor r_state_x(26);
                r_state_x(14) <= r_state_x( 3) xor r_state_x(10) xor r_state_x(35) xor r_state_x(46) xor r_state_x(12);
                r_state_x(15) <= r_state_x(15) xor r_state_x( 2) xor r_state_x(35) xor r_state_x(31) xor r_state_x(43) xor r_state_x(29);
                r_state_x(16) <= r_state_x( 6) xor r_state_x( 5) xor r_state_x(11) xor r_state_x( 8) xor r_state_x(20);
                r_state_x(17) <= r_state_x(28) xor r_state_x(10) xor r_state_x(37) xor r_state_x(24) xor r_state_x(35) xor r_state_x( 5);
                r_state_x(18) <= r_state_x(31) xor r_state_x(42) xor r_state_x(17) xor r_state_x(45) xor r_state_x(21);
                r_state_x(19) <= r_state_x(42) xor r_state_x(45) xor r_state_x(36) xor r_state_x( 9) xor r_state_x(31) xor r_state_x(28);
                r_state_x(20) <= r_state_x(27) xor r_state_x(39) xor r_state_x(19) xor r_state_x( 0) xor r_state_x(38);
                r_state_x(21) <= r_state_x(14) xor r_state_x(40) xor r_state_x(16) xor r_state_x( 9) xor r_state_x(25) xor r_state_x(18);
                r_state_x(22) <= r_state_x(20) xor r_state_x(27) xor r_state_x( 2) xor r_state_x(45) xor r_state_x(42);
                r_state_x(23) <= r_state_x(44) xor r_state_x(40) xor r_state_x(20) xor r_state_x( 3) xor r_state_x(25) xor r_state_x( 7);
                r_state_x(24) <= r_state_x(16) xor r_state_x(22) xor r_state_x(39) xor r_state_x( 8) xor r_state_x(13);
                r_state_x(25) <= r_state_x( 4) xor r_state_x(46) xor r_state_x(38) xor r_state_x(33) xor r_state_x(40) xor r_state_x(26);
                r_state_x(26) <= r_state_x(13) xor r_state_x( 6) xor r_state_x(47) xor r_state_x( 2) xor r_state_x( 7);
                r_state_x(27) <= r_state_x(27) xor r_state_x(28) xor r_state_x(10) xor r_state_x(32) xor r_state_x( 0) xor r_state_x(12);
                r_state_x(28) <= r_state_x(36) xor r_state_x( 3) xor r_state_x(26) xor r_state_x(39) xor r_state_x(30);
                r_state_x(29) <= r_state_x(39) xor r_state_x(12) xor r_state_x(21) xor r_state_x(38) xor r_state_x(46) xor r_state_x(30);
                r_state_x(30) <= r_state_x( 9) xor r_state_x(41) xor r_state_x(27) xor r_state_x(12) xor r_state_x(18);
                r_state_x(31) <= r_state_x(45) xor r_state_x(12) xor r_state_x(47) xor r_state_x( 1) xor r_state_x( 3) xor r_state_x(23);
                r_state_x(32) <= r_state_x(24) xor r_state_x(25) xor r_state_x(29) xor r_state_x(20) xor r_state_x(18);
                r_state_x(33) <= r_state_x(31) xor r_state_x( 2) xor r_state_x(45) xor r_state_x(11) xor r_state_x(25) xor r_state_x(30);
                r_state_x(34) <= r_state_x(17) xor r_state_x( 7) xor r_state_x(10) xor r_state_x(34) xor r_state_x(44);
                r_state_x(35) <= r_state_x( 4) xor r_state_x(27) xor r_state_x( 0) xor r_state_x(41) xor r_state_x(43) xor r_state_x(17);
                r_state_x(36) <= r_state_x( 5) xor r_state_x(17) xor r_state_x(46) xor r_state_x(44) xor r_state_x(39);
                r_state_x(37) <= r_state_x( 4) xor r_state_x(42) xor r_state_x( 0) xor r_state_x( 6) xor r_state_x(23) xor r_state_x(22);
                r_state_x(38) <= r_state_x(40) xor r_state_x(43) xor r_state_x( 7) xor r_state_x( 6) xor r_state_x(29);
                r_state_x(39) <= r_state_x(23) xor r_state_x(29) xor r_state_x(43) xor r_state_x(32) xor r_state_x(36) xor r_state_x(14);
                r_state_x(40) <= r_state_x( 0) xor r_state_x(13) xor r_state_x(15) xor r_state_x(16) xor r_state_x(25);
                r_state_x(41) <= r_state_x(19) xor r_state_x(30) xor r_state_x(16) xor r_state_x( 6) xor r_state_x(36) xor r_state_x(44);
                r_state_x(42) <= r_state_x(37) xor r_state_x( 4) xor r_state_x(23) xor r_state_x(41) xor r_state_x(13);
                r_state_x(43) <= r_state_x(33) xor r_state_x(22) xor r_state_x(19) xor r_state_x(41) xor r_state_x(28) xor r_state_x(37);
                r_state_x(44) <= r_state_x(24) xor r_state_x(34) xor r_state_x( 5) xor r_state_x( 1) xor r_state_x( 9);
                r_state_x(45) <= r_state_x(27) xor r_state_x(37) xor r_state_x(33) xor r_state_x(32) xor r_state_x( 7) xor r_state_x(47);
                r_state_x(46) <= r_state_x(41) xor r_state_x(10) xor r_state_x(15) xor r_state_x( 8) xor r_state_x(42);
                r_state_x(47) <= r_state_x( 8) xor r_state_x(18) xor r_state_x(19) xor r_state_x( 3) xor r_state_x(10) xor r_state_x(37);
                
                for i in 0 to streams - 1 loop
                    v_mixin := r_state_x xor salts(i);
                    v_mixup := r_state_y(48 * ((i + 1) mod streams) + 47 downto 48 * ((i + 1) mod streams));
                    v_res( 0) := v_mixup( 0) xor (v_mixup(19) and not v_mixup(21)) xor v_mixup(15) xor v_mixup(22) xor v_mixin((i +  8) mod 48);
                    v_res( 1) := v_mixup( 1) xor (v_mixup(20) and not v_mixup(22)) xor v_mixup(16) xor v_mixup(23) xor v_mixin((i + 23) mod 48);
                    v_res( 2) := v_mixup( 2) xor (v_mixup(21) and not v_mixup(23)) xor v_mixup(17) xor v_mixup(24) xor v_mixin((i +  2) mod 48);
                    v_res( 3) := v_mixup( 3) xor (v_mixup(22) and not v_mixup(24)) xor v_mixup(18) xor v_mixup(25) xor v_mixin((i + 15) mod 48);
                    v_res( 4) := v_mixup( 4) xor (v_mixup(23) and not v_mixup(25)) xor v_mixup(19) xor v_mixup(26) xor v_mixin((i + 46) mod 48);
                    v_res( 5) := v_mixup( 5) xor (v_mixup(24) and not v_mixup(26)) xor v_mixup(20) xor v_mixup(27) xor v_mixin((i + 31) mod 48);
                    v_res( 6) := v_mixup( 6) xor (v_mixup(25) and not v_mixup(27)) xor v_mixup(21) xor v_mixup(28) xor v_mixin((i + 22) mod 48);
                    v_res( 7) := v_mixup( 7) xor (v_mixup(26) and not v_mixup(28)) xor v_mixup(22) xor v_mixup(29) xor v_mixin((i + 12) mod 48);
                    v_res( 8) := v_mixup( 8) xor (v_mixup(27) and not v_mixup(29)) xor v_mixup(23) xor v_mixup(30) xor v_mixin((i + 27) mod 48);
                    v_res( 9) := v_mixup( 9) xor (v_mixup(28) and not v_mixup(30)) xor v_mixup(24) xor v_mixup(31) xor v_mixin((i + 17) mod 48);
                    v_res(10) := v_mixup(10) xor (v_mixup(29) and not v_mixup(31)) xor v_mixup(25) xor v_mixup(32) xor v_mixin((i +  9) mod 48);
                    v_res(11) := v_mixup(11) xor (v_mixup(30) and not v_mixup(32)) xor v_mixup(26) xor v_mixup(33) xor v_mixin((i + 39) mod 48);
                    v_res(12) := v_mixup(12) xor (v_mixup(31) and not v_mixup(33)) xor v_mixup(27) xor v_mixup(34) xor v_mixin((i + 42) mod 48);
                    v_res(13) := v_mixup(13) xor (v_mixup(32) and not v_mixup(34)) xor v_mixup(28) xor v_mixup(35) xor v_mixin((i + 19) mod 48);
                    v_res(14) := v_mixup(14) xor (v_mixup(33) and not v_mixup(35)) xor v_mixup(29) xor v_mixup(36) xor v_mixin((i + 28) mod 48);
                    v_res(15) := v_mixup(15) xor (v_mixup(34) and not v_mixup(36)) xor v_mixup(30) xor v_mixup(37) xor v_mixin((i + 45) mod 48);
                    v_res(16) := v_mixup(16) xor (v_mixup(35) and not v_mixup(37)) xor v_mixup(31) xor v_mixup(38) xor v_mixin((i +  1) mod 48);
                    v_res(17) := v_mixup(17) xor (v_mixup(36) and not v_mixup(38)) xor v_mixup(32) xor v_mixup(39) xor v_mixin((i +  0) mod 48);
                    v_res(18) := v_mixup(18) xor (v_mixup(37) and not v_mixup(39)) xor v_mixup(33) xor v_mixup(40) xor v_mixin((i + 41) mod 48);
                    v_res(19) := v_mixup(19) xor (v_mixup(38) and not v_mixup(40)) xor v_mixup(34) xor v_mixup(41) xor v_mixin((i + 30) mod 48);
                    v_res(20) := v_mixup(20) xor (v_mixup(39) and not v_mixup(41)) xor v_mixup(35) xor v_mixup(42) xor v_mixin((i +  3) mod 48);
                    v_res(21) := v_mixup(21) xor (v_mixup(40) and not v_mixup(42)) xor v_mixup(36) xor v_mixup(43) xor v_mixin((i + 38) mod 48);
                    v_res(22) := v_mixup(22) xor (v_mixup(41) and not v_mixup(43)) xor v_mixup(37) xor v_mixup(44) xor v_mixin((i + 25) mod 48);
                    v_res(23) := v_mixup(23) xor (v_mixup(42) and not v_mixup(44)) xor v_mixup(38) xor v_mixup(45) xor v_mixin((i + 29) mod 48);
                    v_state_y(48 * i + 47 downto 48 * i) := v_res & r_state_y(48 * i + 47 downto 48 * i + 24);
                end loop;
                
                for i in 0 to streams - 1 loop
                    v_mixin := r_state_x xor salts(i);
                    v_mixup := v_state_y(48 * ((i + 1) mod streams) + 47 downto 48 * ((i + 1) mod streams));
                    v_res( 0) := v_mixup( 0) xor (v_mixup(19) and not v_mixup(21)) xor v_mixup(15) xor v_mixup(22) xor v_mixin((i + 24) mod 48);
                    v_res( 1) := v_mixup( 1) xor (v_mixup(20) and not v_mixup(22)) xor v_mixup(16) xor v_mixup(23) xor v_mixin((i +  5) mod 48);
                    v_res( 2) := v_mixup( 2) xor (v_mixup(21) and not v_mixup(23)) xor v_mixup(17) xor v_mixup(24) xor v_mixin((i + 32) mod 48);
                    v_res( 3) := v_mixup( 3) xor (v_mixup(22) and not v_mixup(24)) xor v_mixup(18) xor v_mixup(25) xor v_mixin((i + 44) mod 48);
                    v_res( 4) := v_mixup( 4) xor (v_mixup(23) and not v_mixup(25)) xor v_mixup(19) xor v_mixup(26) xor v_mixin((i + 26) mod 48);
                    v_res( 5) := v_mixup( 5) xor (v_mixup(24) and not v_mixup(26)) xor v_mixup(20) xor v_mixup(27) xor v_mixin((i + 21) mod 48);
                    v_res( 6) := v_mixup( 6) xor (v_mixup(25) and not v_mixup(27)) xor v_mixup(21) xor v_mixup(28) xor v_mixin((i + 37) mod 48);
                    v_res( 7) := v_mixup( 7) xor (v_mixup(26) and not v_mixup(28)) xor v_mixup(22) xor v_mixup(29) xor v_mixin((i + 34) mod 48);
                    v_res( 8) := v_mixup( 8) xor (v_mixup(27) and not v_mixup(29)) xor v_mixup(23) xor v_mixup(30) xor v_mixin((i + 13) mod 48);
                    v_res( 9) := v_mixup( 9) xor (v_mixup(28) and not v_mixup(30)) xor v_mixup(24) xor v_mixup(31) xor v_mixin((i + 18) mod 48);
                    v_res(10) := v_mixup(10) xor (v_mixup(29) and not v_mixup(31)) xor v_mixup(25) xor v_mixup(32) xor v_mixin((i + 35) mod 48);
                    v_res(11) := v_mixup(11) xor (v_mixup(30) and not v_mixup(32)) xor v_mixup(26) xor v_mixup(33) xor v_mixin((i +  6) mod 48);
                    v_res(12) := v_mixup(12) xor (v_mixup(31) and not v_mixup(33)) xor v_mixup(27) xor v_mixup(34) xor v_mixin((i + 11) mod 48);
                    v_res(13) := v_mixup(13) xor (v_mixup(32) and not v_mixup(34)) xor v_mixup(28) xor v_mixup(35) xor v_mixin((i + 36) mod 48);
                    v_res(14) := v_mixup(14) xor (v_mixup(33) and not v_mixup(35)) xor v_mixup(29) xor v_mixup(36) xor v_mixin((i + 43) mod 48);
                    v_res(15) := v_mixup(15) xor (v_mixup(34) and not v_mixup(36)) xor v_mixup(30) xor v_mixup(37) xor v_mixin((i +  7) mod 48);
                    v_res(16) := v_mixup(16) xor (v_mixup(35) and not v_mixup(37)) xor v_mixup(31) xor v_mixup(38) xor v_mixin((i + 40) mod 48);
                    v_res(17) := v_mixup(17) xor (v_mixup(36) and not v_mixup(38)) xor v_mixup(32) xor v_mixup(39) xor v_mixin((i + 33) mod 48);
                    v_res(18) := v_mixup(18) xor (v_mixup(37) and not v_mixup(39)) xor v_mixup(33) xor v_mixup(40) xor v_mixin((i + 20) mod 48);
                    v_res(19) := v_mixup(19) xor (v_mixup(38) and not v_mixup(40)) xor v_mixup(34) xor v_mixup(41) xor v_mixin((i + 10) mod 48);
                    v_res(20) := v_mixup(20) xor (v_mixup(39) and not v_mixup(41)) xor v_mixup(35) xor v_mixup(42) xor v_mixin((i + 47) mod 48);
                    v_res(21) := v_mixup(21) xor (v_mixup(40) and not v_mixup(42)) xor v_mixup(36) xor v_mixup(43) xor v_mixin((i +  4) mod 48);
                    v_res(22) := v_mixup(22) xor (v_mixup(41) and not v_mixup(43)) xor v_mixup(37) xor v_mixup(44) xor v_mixin((i + 14) mod 48);
                    v_res(23) := v_mixup(23) xor (v_mixup(42) and not v_mixup(44)) xor v_mixup(38) xor v_mixup(45) xor v_mixin((i + 16) mod 48);
                    r_state_y(48 * i + 47 downto 48 * i) <= v_res & v_state_y(48 * i + 47 downto 48 * i + 24);
                end loop;
                
            end if;
        end if;
    end process;
    
end rtl;

