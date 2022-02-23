-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl.py`.

library ieee;
use ieee.std_logic_1164.all;

entity xormix24_tb is
end xormix24_tb;

architecture bhv of xormix24_tb is
    
    -- configuration
    constant streams : integer := 4;
    constant results : integer := 100;
    constant seed_x  : std_logic_vector(23 downto 0) :=
        x"1244da";
    constant seed_y  : std_logic_vector(24 * streams - 1 downto 0) :=
        x"09e3cd3f2a82eedcfdda1a8e";
    
    -- reference result
    type result_array_t is array(0 to results - 1) of std_logic_vector(24 * streams - 1 downto 0);
    signal ref_result : result_array_t := (
        x"09e3cd3f2a82eedcfdda1a8e",
        x"9c8ab069d787303c1f17b52c",
        x"ceb88eb52c06f287dd6c5f5b",
        x"c83766f3eb444959d0bd3c6b",
        x"79ebd99d9a5eac1943a67b15",
        x"5bc6cf6a33081ac1b96f917a",
        x"f90a4a744e31633301d9119b",
        x"c8c9bc9337eca3b5ce634ab1",
        x"436f725fd07c3627e939e0c4",
        x"5d4918ec97185b7ed436dc91",
        x"01c93b2aeb5bb4fb167b3e3b",
        x"616bf5ca23049e6930fa6d9b",
        x"cd880216b4474042918825b4",
        x"bf706eae0db8ce0eac28f083",
        x"7d10c1ac68c47923cdab93ce",
        x"d4342ffdc443187d6a014194",
        x"ded7412168edcb4f8e717fdf",
        x"c754ee93942c50e2ea353974",
        x"ecf552732c91d93e079e36fa",
        x"c990155c35b14d592d8c978d",
        x"4918d606a2f1563e084feab4",
        x"c8e68454e45e6b0fe2284b17",
        x"56e9b02caf537a38ef5c1f21",
        x"f69923ea35c2887c27353f16",
        x"63c1cf5d3ae6a96a792f0812",
        x"4bc53f6d232d946786fc2a91",
        x"3f6ead1327f8426f65dd561c",
        x"312a18ab2e8b4887c6c82175",
        x"fc4cc2b0429581ab3c324692",
        x"4c8653637cae35f20bf3500b",
        x"a8727fba135343be9f096848",
        x"59d2477cd8b9f17f23face77",
        x"3631e17bff11d45fbc4acba4",
        x"cb5e4f6b0d766a994e0d23aa",
        x"2a7c88a23bb57af6174e3eed",
        x"744dfdb5a23bccc0c65fddf6",
        x"57798e6698f2c31b8357157c",
        x"21881de045fef344ae4c2d39",
        x"76d1dbbda9c21651a387d2fe",
        x"ff8eb0690a7e40c1a0b4fe8a",
        x"a5e71629d04f98b6234b9960",
        x"0cca658627bf270e5fe1f7a6",
        x"9d8d6046b24b8a9d84ec9713",
        x"c9ecb099f4be932b2958a8cd",
        x"fec1d48518b2d48926407014",
        x"082fbba2e2a52cd06c1b6216",
        x"82872b68219b5cdb1a5ed197",
        x"7d9dac9642b4f7d5be35222f",
        x"f4b9ff4db84ec70029bae036",
        x"1dfe633de6e9f6dd9e56a6a4",
        x"c3d7da7ba7eb8c723bfd9b5b",
        x"4136db281444000bf52f4b5b",
        x"c102264cde60fe0f5c4ce42e",
        x"9661b1dc8e7daac83afc7634",
        x"ba6e514df6d227b7da609b5c",
        x"c7bab3a1b657556bfd54927d",
        x"eb7ca1a7be421ff488658f73",
        x"69f1abf94c15a845b2a2a8cd",
        x"ad3ec9656f14a1d289e110d1",
        x"e68a2ac1756765bb10122e04",
        x"23c4433d921492a58a2a991b",
        x"bc3fdf511d993cb000de554f",
        x"2eae39d09e2d5351ff4320c1",
        x"9bb0e8079d36bd19d889b8b7",
        x"c3378ac57797c8652672fe5d",
        x"f2390b97cc64db08e7c91668",
        x"d9170599239d592d1581a424",
        x"fe89e1d2adbc28fb4e937f95",
        x"e969f41c0afcc073027fa89a",
        x"98cebd98ad755cf9bf449f63",
        x"6947172febe065929b30828c",
        x"e43c1b066a618f649c46c473",
        x"407fa1bb3137bd2be8cb7f82",
        x"e9dfe14bf62909d46736ad1f",
        x"7641437fc0d1469bcc652123",
        x"90f3597ed70edf03a3f1b98f",
        x"7b6787457f38c25e4c93d4f2",
        x"e52f404a04890b306ddd7e73",
        x"3cb8550d177d3ebacdc5e24b",
        x"557e7025427e38c3fb80a7f2",
        x"9083f22e75de481716b87bdd",
        x"194cc566ecd509f99496caa6",
        x"d0edbdf5c07ffe2225904b1c",
        x"ec7ce310797ae94a3d2d161e",
        x"a814a760607dbc4530592e6d",
        x"42185c768dbff5516e317fd0",
        x"16c236b125284ab0aeab01b4",
        x"19762df46da5d81984b4457c",
        x"6db259a9a7d82e177d34abdc",
        x"9b38950a733f1ebf41dfc7e9",
        x"e46d87410f91c0cfbbfeb763",
        x"cb79203fefd50f609449d6e1",
        x"2e55b6bfa121a6e5ad5590d5",
        x"6b9f89d53a55ce73401ae895",
        x"7c7fb732a1d0f133a63477d7",
        x"6438734e8f4669e5885d3b1c",
        x"39aa0a84b9ee19798475b839",
        x"f7f2f0a3afbbc8cd5c9d9a59",
        x"0ec7e3c689a0f28d7f1f205f",
        x"995a1972ed2e1a603f5cec46"
    );
    
    -- DUT signals
    signal clk    : std_logic := '0';
    signal rst    : std_logic;
    signal enable : std_logic;
    signal result : std_logic_vector(24 * streams - 1 downto 0);
    
    -- flag to stop simulation
    signal run : boolean := true;
    
begin
    
    -- DUT
    inst_xormix : entity work.xormix24_x7s generic map(
        streams => streams
    ) port map (
        clk    => clk,
        rst    => rst,
        seed_x => seed_x,
        seed_y => seed_y,
        enable => enable,
        result => result
    );
    
    -- clock process
    process
    begin
        while run loop
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
        end loop;
        wait;
    end process;
    
    -- input/output process
    process
        variable errors : natural := 0;
    begin
        wait until rising_edge(clk);
        rst <= '1';
        enable <= '0';
        wait until rising_edge(clk);
        rst <= '0';
        enable <= '1';
        for i in 0 to results - 1 loop
            wait until rising_edge(clk);
            if result /= ref_result(i) then
                report "Incorrect result for i=" & integer'image(i) severity warning;
                errors := errors + 1;
            end if;
        end loop;
        report "Test complete, number of errors: " & integer'image(errors) severity note;
        run <= false;
        wait;
    end process;
    
end bhv;
