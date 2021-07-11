-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl.py`.

library ieee;
use ieee.std_logic_1164.all;

entity xormix32_tb is
end xormix32_tb;

architecture bhv of xormix32_tb is
    
    -- configuration
    constant streams : integer := 4;
    constant results : integer := 100;
    constant seed_x  : std_logic_vector(31 downto 0) :=
        X"df2c403b";
    constant seed_y  : std_logic_vector(32 * streams - 1 downto 0) :=
        X"a9140006e47066dd25e5a545abac0809";
    
    -- reference result
    type result_array_t is array(0 to results - 1) of std_logic_vector(32 * streams - 1 downto 0);
    signal ref_result : result_array_t := (
        X"a9140006e47066dd25e5a545abac0809",
        X"72f2ab4fbd5698b41657384cfb444495",
        X"0b8fcaf74312ea43dacfe300984c07a4",
        X"15fffe97fda43c5acf9c2d620fd34603",
        X"64cca5f1395dfebaba3b508793084fc6",
        X"d60dac92060e345d1b79f99ce1f5ef9e",
        X"71ea421610ae033c5e43ecd327b58de9",
        X"a42017328857fbdf7a9c0d6b6bedf270",
        X"afcb8ecea23e27163ff47fdfea8ca751",
        X"974108c6a8ae883f7c128a26a8ba0554",
        X"94caeced541f4abf93d717903d2b14e1",
        X"7e2797101410a49b3745c443c91224ab",
        X"4c4c2530ad735e40f32a80a7c842a60b",
        X"ff939b23e13458f6189a2f6aac2777cc",
        X"9b83f85af1b7e6ce1a4071cd8e1152c4",
        X"fe4fd0febddb09eef98f9102089f2658",
        X"27e48465db64421e0c3205074aefdae0",
        X"da900db03a917327effdb5549a9d099a",
        X"de0f326c7acc3a6ab647ac1d762d69ea",
        X"82d908e7a8766ae94308dfe7edf137c6",
        X"4ba832bd0421a023cea7ffb0e24b637a",
        X"8dba6698e15e09d4286002d8c32af55f",
        X"26a522f91acfad657d2fd460326a4304",
        X"41b7381d6e6f3e3360c3784436907503",
        X"8bcd067165171afbf2aa820af4a849ff",
        X"dc9d9b1a75b0e28bd0b8ff2b97722842",
        X"2fa433ec9b267623e7831a060568029e",
        X"dfa368df301166437c554e7f9de94d3c",
        X"137ecf12affffe1b6ee0c7fcd7262855",
        X"3ce202cec6443fd42f7fd055cd31052b",
        X"f0ed91522fb9ffc360b8eac119dbf9f2",
        X"f963720ca66c4402b63a83b7eff48c07",
        X"2070af6b8564a43069ca50b3cd7af47d",
        X"f47b7bbeceecb4d7f2a644689d1a7839",
        X"a214f6d0f9266e1b5f75132be8b21e77",
        X"eb2ef6a9608393b0a21caa49fc149697",
        X"f74421d35c56502dc6e1f81ec92c0462",
        X"8fdee6eece2b896384f6bb581d2f009a",
        X"cf926986b625ea98190f9d2d0a73d43e",
        X"b1cc14dd8071c063acd333dd005113d2",
        X"10c84ee06129bc1a9ff9a066aacbf866",
        X"385550bac40d532579c616372dbc1a6d",
        X"944b5e63e8d441ac29de2b5035effd01",
        X"cccc2523c5e87bc0ad9d9323d97725e4",
        X"6fa47038361d240989afd0c17a3c81a0",
        X"943928b6e8804b28a76067a7d6679493",
        X"e60d5390629d452eaf58066c09133a32",
        X"1737c2e738d53c3836c864648b9bba53",
        X"979cedbe2d590145239373aefddffbd8",
        X"07285a746788dd8a863b1c2147abbfb7",
        X"75b50fc2a4e6e2abeb92b310ff23332c",
        X"9f417bce52e3fc2e17f7f4e56a10e5a7",
        X"bb709c959c074e90eb3ab65a2bf2c76e",
        X"1d3a9359b83b25af20aef25a9b4ee7e5",
        X"fe71c6254f75a9a784104fb832dd4687",
        X"8acf268dc18547e1e88a03b1b037c684",
        X"d488b74758818db067946f78014b024e",
        X"a7fd5aceb7205939e2ac035fb5f248e6",
        X"fd59b88df31c6c42955401263798ec5b",
        X"35cd33e403cbb1c5f2220adc75ea98dc",
        X"529c736c08aa6c99473bfb286eae13d5",
        X"cb276b9560649c9a22d414ead8c2d2b0",
        X"d762b38a9b1a0a3d63d357b6509963d0",
        X"e346ca0b1c938ca4acad5caece8df638",
        X"654f5ac763485723d69cd3c426eec6b7",
        X"89608e4333007fae1fdb9d60d255f1d8",
        X"639a623703741406f0a07faa69ad8444",
        X"eb7f5d111e641485d619b41b76bfffbc",
        X"954125a797806824488993ef8d5e65bd",
        X"2bea23436c1fb8740b0a542c613e1a95",
        X"d9988e23bfccbdac2a9d20e7ce51e0eb",
        X"d386d5b3f9640bf87f026fec787b02ba",
        X"3b0ff073e96fcf97072be9c0d490286b",
        X"5ad48112b3d9faee85ad58926d187f91",
        X"d8030d03b25d513f2c2d328f1cee4eb8",
        X"dc12177132e26e634e1fcdc26aca1017",
        X"ba1a8e08c48363d84852cdfc5e1e0367",
        X"c7996e95db3e42af163a2a14abfa4340",
        X"8cc269301f84838b7e82ba6305e4b400",
        X"de08f175f9b3677b1023e8fcb61b2e4c",
        X"dff7227c4468739d54915ee6230bad4b",
        X"509cd2e991620b8c833f75871d3e87db",
        X"626a0c24cd0a870dacfe481274a2c7f5",
        X"7eeae1cfc7b3eca6d5f4c509cdedc06a",
        X"70d8dc98fd2738066ae2dfcd2137d265",
        X"f2179eac3312a30186d90d7c13846e56",
        X"b4211a0835482136b403ef1f0ff4f5cf",
        X"c59c702970130c130a847c9d3b2124c8",
        X"511a52e54c09aaa706f9aeded5439523",
        X"fd4343a0549e50c2d987fd9bbcd37d12",
        X"3b2c3fbc01de0d960e2840c15fcee1b2",
        X"5851d9821a2a67c4d0f2d4992415ca05",
        X"11d23950f6a5014e9d29f6054cd0578a",
        X"4aaaedcd3bef7a76ef8442bff12a3e03",
        X"18b7e8decb2a34e344cfc4977c55c0d3",
        X"ddb815e21d3b1f93f94fd0d73537c84d",
        X"a27f3f2dff73dc30f84f18b7ebc3c4df",
        X"18de61837e278fc2d2bcd875c4052565",
        X"fa4063ed313ac7f2c9b13801c9394551",
        X"768a44b79e27b1c7af5a64a3a254adf3"
    );
    
    -- DUT signals
    signal clk    : std_logic := '0';
    signal reset  : std_logic;
    signal enable : std_logic;
    signal result : std_logic_vector(32 * streams - 1 downto 0);
    
    -- flag to stop simulation
    signal run : boolean := true;
    
begin
    
    -- DUT
    inst_xormix : entity work.xormix32 generic map(
        streams => streams
    ) port map (
        clk    => clk,
        reset  => reset,
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
    begin
        wait until rising_edge(clk);
        reset <= '1';
        enable <= '0';
        wait until rising_edge(clk);
        reset <= '0';
        enable <= '1';
        for i in 0 to results - 1 loop
            wait until rising_edge(clk);
            assert result = ref_result(i) report "Incorrect result" severity warning;
        end loop;
        run <= false;
        wait;
    end process;
    
end bhv;

