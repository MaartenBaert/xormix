-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file contains stubs for some primitives from the Xilinx Unisim library.
-- This is meant to support verification with open-source tools like GHDL without
-- depending on the official Xilinx Unisim library.

library ieee;
use ieee.std_logic_1164.all;

package vcomponents is

    component LUT5 is
        generic (
            INIT : bit_vector := X"00000000"
        );
        port (
            O : out std_ulogic;
            I0 : in std_ulogic;
            I1 : in std_ulogic;
            I2 : in std_ulogic;
            I3 : in std_ulogic;
            I4 : in std_ulogic
        );
    end component;

    component LUT6 is
        generic (
            INIT : bit_vector := X"0000000000000000"
        );
        port (
            O : out std_ulogic;
            I0 : in std_ulogic;
            I1 : in std_ulogic;
            I2 : in std_ulogic;
            I3 : in std_ulogic;
            I4 : in std_ulogic;
            I5 : in std_ulogic
        );
    end component;

end vcomponents;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LUT5 is
    generic (
        INIT : bit_vector := X"00000000"
    );
    port (
        O : out std_ulogic;
        I0 : in std_ulogic;
        I1 : in std_ulogic;
        I2 : in std_ulogic;
        I3 : in std_ulogic;
        I4 : in std_ulogic
    );
end LUT5;

architecture rtl of LUT5 is
begin
    O <= 'U' when (I4 xor I3 xor I2 xor I1 xor I0) = 'U' else 'X' when (I4 xor I3 xor I2 xor I1 xor I0) = 'X' else
        to_stdulogic(INIT(to_integer(unsigned'(I4 & I3 & I2 & I1 & I0))));
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LUT6 is
    generic (
        INIT : bit_vector := X"0000000000000000"
    );
    port (
        O : out std_ulogic;
        I0 : in std_ulogic;
        I1 : in std_ulogic;
        I2 : in std_ulogic;
        I3 : in std_ulogic;
        I4 : in std_ulogic;
        I5 : in std_ulogic
    );
end LUT6;

architecture rtl of LUT6 is
begin
    O <= 'U' when (I5 xor I4 xor I3 xor I2 xor I1 xor I0) = 'U' else 'X' when (I5 xor I4 xor I3 xor I2 xor I1 xor I0) = 'X' else
        to_stdulogic(INIT(to_integer(unsigned'(I5 & I4 & I3 & I2 & I1 & I0))));
end rtl;
