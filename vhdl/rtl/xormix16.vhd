-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl.py`.
-- Revision: 1

library ieee;
use ieee.std_logic_1164.all;

entity xormix16 is
    generic (
        streams : integer range 1 to 16 := 1
    );
    port (
        
        -- clock and synchronous reset
        clk    : in std_logic;
        rst    : in std_logic;
        
        -- configuration
        seed_x : in std_logic_vector(15 downto 0);
        seed_y : in std_logic_vector(16 * streams - 1 downto 0);
        
        -- random number generator
        enable : in std_logic;
        result : out std_logic_vector(16 * streams - 1 downto 0)
        
    );
end xormix16;

architecture rtl of xormix16 is
    
    type salts_t is array(0 to 15) of std_logic_vector(15 downto 0);
    constant salts : salts_t := (
        x"d2ba", x"bc36", x"16a6", x"e3eb",
        x"b749", x"5bc4", x"09f7", x"f491",
        x"5e28", x"2d5a", x"da5d", x"2cab",
        x"4058", x"7547", x"e94c", x"0a05"
    );
    
    signal r_state_x : std_logic_vector(15 downto 0);
    signal r_state_y : std_logic_vector(16 * streams - 1 downto 0);
    
begin
    
    result <= r_state_y;
    
    process (clk)
        
        variable v_state_y : std_logic_vector(16 * streams - 1 downto 0);
        
        variable v_mixin : std_logic_vector(15 downto 0);
        variable v_mixup : std_logic_vector(15 downto 0);
        variable v_res : std_logic_vector(7 downto 0);
        
    begin
        if rising_edge(clk) then
            if rst = '1' then
                
                r_state_x <= seed_x;
                r_state_y <= seed_y;
                
            elsif enable = '1' then
                
                r_state_x( 0) <= r_state_x( 3) xor r_state_x(11) xor r_state_x( 1) xor r_state_x( 4) xor r_state_x(13);
                r_state_x( 1) <= r_state_x(11) xor r_state_x(12) xor r_state_x(10) xor r_state_x( 2) xor r_state_x( 8) xor r_state_x( 9);
                r_state_x( 2) <= r_state_x( 0) xor r_state_x(10) xor r_state_x(11) xor r_state_x( 4) xor r_state_x(15);
                r_state_x( 3) <= r_state_x( 1) xor r_state_x(11) xor r_state_x(13) xor r_state_x( 0) xor r_state_x( 6) xor r_state_x(10);
                r_state_x( 4) <= r_state_x( 8) xor r_state_x( 3) xor r_state_x( 6) xor r_state_x( 1) xor r_state_x( 7);
                r_state_x( 5) <= r_state_x( 3) xor r_state_x( 5) xor r_state_x( 4) xor r_state_x( 1) xor r_state_x(14) xor r_state_x( 6);
                r_state_x( 6) <= r_state_x( 8) xor r_state_x( 7) xor r_state_x(12) xor r_state_x(11) xor r_state_x(13);
                r_state_x( 7) <= r_state_x(14) xor r_state_x( 7) xor r_state_x( 8) xor r_state_x( 5) xor r_state_x(13) xor r_state_x(10);
                r_state_x( 8) <= r_state_x( 7) xor r_state_x( 0) xor r_state_x( 4) xor r_state_x(12) xor r_state_x(13);
                r_state_x( 9) <= r_state_x(15) xor r_state_x( 3) xor r_state_x( 9) xor r_state_x( 2) xor r_state_x(11) xor r_state_x( 5);
                r_state_x(10) <= r_state_x( 0) xor r_state_x( 9) xor r_state_x( 6) xor r_state_x(11) xor r_state_x( 4);
                r_state_x(11) <= r_state_x(12) xor r_state_x(15) xor r_state_x( 2) xor r_state_x( 3) xor r_state_x(14) xor r_state_x( 0);
                r_state_x(12) <= r_state_x(14) xor r_state_x( 3) xor r_state_x( 9) xor r_state_x(13) xor r_state_x( 0);
                r_state_x(13) <= r_state_x( 6) xor r_state_x(10) xor r_state_x(12) xor r_state_x( 7) xor r_state_x( 2) xor r_state_x( 1);
                r_state_x(14) <= r_state_x( 5) xor r_state_x( 7) xor r_state_x( 1) xor r_state_x(15) xor r_state_x( 6);
                r_state_x(15) <= r_state_x( 0) xor r_state_x( 7) xor r_state_x(10) xor r_state_x(14) xor r_state_x( 9) xor r_state_x( 1);
                
                for i in 0 to streams - 1 loop
                    v_mixin := r_state_x xor salts(i);
                    v_mixup := r_state_y(16 * ((i + 1) mod streams) + 15 downto 16 * ((i + 1) mod streams));
                    v_res( 0) := v_mixup( 0) xor (v_mixup( 4) and not v_mixup( 8)) xor v_mixup( 5) xor v_mixup( 7) xor v_mixin((i +  4) mod 16);
                    v_res( 1) := v_mixup( 1) xor (v_mixup( 5) and not v_mixup( 9)) xor v_mixup( 6) xor v_mixup( 8) xor v_mixin((i +  5) mod 16);
                    v_res( 2) := v_mixup( 2) xor (v_mixup( 6) and not v_mixup(10)) xor v_mixup( 7) xor v_mixup( 9) xor v_mixin((i + 14) mod 16);
                    v_res( 3) := v_mixup( 3) xor (v_mixup( 7) and not v_mixup(11)) xor v_mixup( 8) xor v_mixup(10) xor v_mixin((i +  2) mod 16);
                    v_res( 4) := v_mixup( 4) xor (v_mixup( 8) and not v_mixup(12)) xor v_mixup( 9) xor v_mixup(11) xor v_mixin((i +  9) mod 16);
                    v_res( 5) := v_mixup( 5) xor (v_mixup( 9) and not v_mixup(13)) xor v_mixup(10) xor v_mixup(12) xor v_mixin((i +  7) mod 16);
                    v_res( 6) := v_mixup( 6) xor (v_mixup(10) and not v_mixup(14)) xor v_mixup(11) xor v_mixup(13) xor v_mixin((i +  3) mod 16);
                    v_res( 7) := v_mixup( 7) xor (v_mixup(11) and not v_mixup(15)) xor v_mixup(12) xor v_mixup(14) xor v_mixin((i +  0) mod 16);
                    v_state_y(16 * i + 15 downto 16 * i) := v_res & r_state_y(16 * i + 15 downto 16 * i + 8);
                end loop;
                
                for i in 0 to streams - 1 loop
                    v_mixin := r_state_x xor salts(i);
                    v_mixup := v_state_y(16 * ((i + 1) mod streams) + 15 downto 16 * ((i + 1) mod streams));
                    v_res( 0) := v_mixup( 0) xor (v_mixup( 4) and not v_mixup( 8)) xor v_mixup( 5) xor v_mixup( 7) xor v_mixin((i + 10) mod 16);
                    v_res( 1) := v_mixup( 1) xor (v_mixup( 5) and not v_mixup( 9)) xor v_mixup( 6) xor v_mixup( 8) xor v_mixin((i +  6) mod 16);
                    v_res( 2) := v_mixup( 2) xor (v_mixup( 6) and not v_mixup(10)) xor v_mixup( 7) xor v_mixup( 9) xor v_mixin((i + 13) mod 16);
                    v_res( 3) := v_mixup( 3) xor (v_mixup( 7) and not v_mixup(11)) xor v_mixup( 8) xor v_mixup(10) xor v_mixin((i +  8) mod 16);
                    v_res( 4) := v_mixup( 4) xor (v_mixup( 8) and not v_mixup(12)) xor v_mixup( 9) xor v_mixup(11) xor v_mixin((i + 11) mod 16);
                    v_res( 5) := v_mixup( 5) xor (v_mixup( 9) and not v_mixup(13)) xor v_mixup(10) xor v_mixup(12) xor v_mixin((i + 15) mod 16);
                    v_res( 6) := v_mixup( 6) xor (v_mixup(10) and not v_mixup(14)) xor v_mixup(11) xor v_mixup(13) xor v_mixin((i +  1) mod 16);
                    v_res( 7) := v_mixup( 7) xor (v_mixup(11) and not v_mixup(15)) xor v_mixup(12) xor v_mixup(14) xor v_mixin((i + 12) mod 16);
                    r_state_y(16 * i + 15 downto 16 * i) <= v_res & v_state_y(16 * i + 15 downto 16 * i + 8);
                end loop;
                
            end if;
        end if;
    end process;
    
end rtl;
