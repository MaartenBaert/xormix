-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl.py`.

library ieee;
use ieee.std_logic_1164.all;

entity xormix96 is
    generic (
        streams : integer range 1 to 96 := 1
    );
    port (
        
        -- clock and synchronous reset
        clk    : in std_logic;
        rst    : in std_logic;
        
        -- configuration
        seed_x : in std_logic_vector(95 downto 0);
        seed_y : in std_logic_vector(96 * streams - 1 downto 0);
        
        -- random number generator
        enable : in std_logic;
        result : out std_logic_vector(96 * streams - 1 downto 0)
        
    );
end xormix96;

architecture rtl of xormix96 is
    
    type salts_t is array(0 to 95) of std_logic_vector(95 downto 0);
    constant salts : salts_t := (
        x"6319a0b833efe6e1c2523bab", x"6065db7e5e9528c24e41956c", x"45405efdaa7a8343f957dbb2", x"0e1f7d0fa053e5d590c79c4e",
        x"a5b1c14726c172f51066b415", x"aead4a87a54e563e593aef70", x"f85964c82d1057eacf751855", x"c8d61c3bdd042220e6f59d5c",
        x"ffdfe8c9ec04bbdf7bee652e", x"0bb59f564d1d3cf833623b5c", x"68ab49b831b7dc4a4b49c11d", x"b657de372e382df2d4f33c4c",
        x"1b15b9b87e0bb24f224d200f", x"e0592230e4f0f05e619655c0", x"55568b9e8eb9df8518243c1e", x"2097eb070e750e2fda153d84",
        x"a8eefca08e65f7411d8164ba", x"89ada553c5679f8fd13e40e1", x"2ee76cd6b4ec42c1ec2f26a4", x"2c6c0454a632bf6b2c0f4a77",
        x"0b37c3a328d89981c733d157", x"35dd3d4dfe6191ec2c80e292", x"417e0444496792df5700a660", x"ca4e892f298a13178eb22a88",
        x"6b62bb76b84522e412ce68ac", x"50401c5a2989c7eb98ab64fb", x"afc0de3b891e7fd3e8882b5c", x"2539fb51cfa4d3b5fd0b6e9a",
        x"67d1e7005a5054442f94ba0a", x"5ab4670b4474e57d2914a95c", x"0c94162c5cd979a2d0002c45", x"62842083ccff93988a99d2a4",
        x"d9714416b2cae88fa0370fef", x"71e565420304e2da8b9c4ea0", x"f600635b03e92f2fb54339b7", x"3b2b25e41fd40e07b212e026",
        x"1437b070792723e29f5da7d4", x"14f049c34ce725aa2c490b12", x"980a5232856ce525a0aec14c", x"621ca5773ee005f36b66d06c",
        x"38fed51e65bc0562992c8488", x"acb5372755de946dfd193631", x"b2c1198a220c9f9668cc5101", x"fb904152a0011280558611fb",
        x"ced40885938f39870226cc5b", x"db2b3756627f87cf98d9ec8a", x"4948ad10dbffb552f5e0efac", x"ebedd4ed7a029ae094807b62",
        x"85efd26b94b3cf95a9421cbc", x"124a583ab57fab16980c1af0", x"0162d2d5a8a530c7d02d3520", x"d4bf39f96519f627fe72b19f",
        x"59b142a05f99b1fa91c8f332", x"105feec6ab487d1fbd5a4fec", x"e5532b05511358d1bc75473a", x"8dfbf97fde56ad24ebcbc639",
        x"de40acfad1d7202f6ab8b81f", x"2e921e597fb8abf6b6da65ab", x"aa0f40d36ad7f3e4fde1f23e", x"5d02c224218a45f4cff511f6",
        x"4b12bd11e2b967fe411d9e2d", x"c6e89b6f342a8419d1c4e967", x"8ce6c1f47c8cac99c26d675f", x"a4436deb7759e3bab96783bc",
        x"9cd991a210523ae251322632", x"ef206554e9b3cc1466d55960", x"756e211b269c1a5d49fd8319", x"d09797bac005ff7fc38f9668",
        x"96ca13281ff64d69d6a9f493", x"9a50ef154caa345ddd4b8448", x"3c4c5f09a90e00465de9b33e", x"526d1f91c85c680358a4e882",
        x"1c82cd96109c8d647b5b52c2", x"316799a62a2b444c30435136", x"08380ff335a17a11ab09ac47", x"ba77c19d9e6c52f50325a5fe",
        x"41c3c9dbbde1af343fd91134", x"e0999d460fed097784e989e9", x"a3dd3f1b7fd7e392762e4443", x"eea1f4020b54b2e4df3ef598",
        x"bf2b253de7f82582bb31175f", x"66b33be6f1649b539c55a908", x"3c5cc9869dbc64772b58fd36", x"caaed07863593c4c06197a6c",
        x"1a90406dce189bc627cd9cba", x"84812ab822175870f588b01e", x"3e5e9bdd1d64b04f9d92d83b", x"3bc6cf51e924f7c6ec628791",
        x"41cd883fb8ff53f739d3546a", x"87477f4ae25467ff87f2efa6", x"ea009c451178d52621247482", x"a84713d6f74b340bb2cc2fab",
        x"fa0fdf6dc5d11206f6e198a4", x"64fd0ca64551dbecdcd28ff9", x"c4d5c6cf20379c2bcf02bcf7", x"1bff24a6febaa737fdefa863"
    );
    
    signal r_state_x : std_logic_vector(95 downto 0);
    signal r_state_y : std_logic_vector(96 * streams - 1 downto 0);
    
begin
    
    result <= r_state_y;
    
    process (clk)
        
        variable v_state_y : std_logic_vector(96 * streams - 1 downto 0);
        
        variable v_mixin : std_logic_vector(95 downto 0);
        variable v_mixup : std_logic_vector(95 downto 0);
        variable v_res : std_logic_vector(47 downto 0);
        
    begin
        if rising_edge(clk) then
            if rst = '1' then
                
                r_state_x <= seed_x;
                r_state_y <= seed_y;
                
            elsif enable = '1' then
                
                r_state_x( 0) <= r_state_x( 2) xor r_state_x(75) xor r_state_x(41) xor r_state_x(57) xor r_state_x(14);
                r_state_x( 1) <= r_state_x( 9) xor r_state_x(13) xor r_state_x(15) xor r_state_x(10) xor r_state_x(59) xor r_state_x(88);
                r_state_x( 2) <= r_state_x( 6) xor r_state_x(78) xor r_state_x(53) xor r_state_x( 3) xor r_state_x(59);
                r_state_x( 3) <= r_state_x(92) xor r_state_x(43) xor r_state_x(20) xor r_state_x( 8) xor r_state_x(38) xor r_state_x(56);
                r_state_x( 4) <= r_state_x(38) xor r_state_x(25) xor r_state_x(47) xor r_state_x( 0) xor r_state_x( 7);
                r_state_x( 5) <= r_state_x(52) xor r_state_x(18) xor r_state_x(94) xor r_state_x(66) xor r_state_x(28) xor r_state_x(13);
                r_state_x( 6) <= r_state_x(54) xor r_state_x(14) xor r_state_x(51) xor r_state_x(52) xor r_state_x(18);
                r_state_x( 7) <= r_state_x(16) xor r_state_x(62) xor r_state_x(64) xor r_state_x(88) xor r_state_x(43) xor r_state_x(61);
                r_state_x( 8) <= r_state_x( 0) xor r_state_x(85) xor r_state_x(62) xor r_state_x(28) xor r_state_x(23);
                r_state_x( 9) <= r_state_x(50) xor r_state_x(25) xor r_state_x( 6) xor r_state_x(41) xor r_state_x(30) xor r_state_x(95);
                r_state_x(10) <= r_state_x(76) xor r_state_x(95) xor r_state_x(58) xor r_state_x(16) xor r_state_x(85);
                r_state_x(11) <= r_state_x(43) xor r_state_x(36) xor r_state_x(45) xor r_state_x(80) xor r_state_x(78) xor r_state_x(17);
                r_state_x(12) <= r_state_x( 1) xor r_state_x(42) xor r_state_x(75) xor r_state_x(81) xor r_state_x(59);
                r_state_x(13) <= r_state_x(19) xor r_state_x(56) xor r_state_x(23) xor r_state_x(55) xor r_state_x(84) xor r_state_x(79);
                r_state_x(14) <= r_state_x(12) xor r_state_x(46) xor r_state_x(19) xor r_state_x( 5) xor r_state_x(48);
                r_state_x(15) <= r_state_x(71) xor r_state_x( 6) xor r_state_x(59) xor r_state_x(44) xor r_state_x(10) xor r_state_x(39);
                r_state_x(16) <= r_state_x(11) xor r_state_x(77) xor r_state_x( 4) xor r_state_x(21) xor r_state_x(58);
                r_state_x(17) <= r_state_x( 9) xor r_state_x(44) xor r_state_x(62) xor r_state_x(15) xor r_state_x(84) xor r_state_x(40);
                r_state_x(18) <= r_state_x(25) xor r_state_x(93) xor r_state_x(48) xor r_state_x(87) xor r_state_x(32);
                r_state_x(19) <= r_state_x(48) xor r_state_x(82) xor r_state_x(45) xor r_state_x( 8) xor r_state_x(29) xor r_state_x(90);
                r_state_x(20) <= r_state_x(10) xor r_state_x(30) xor r_state_x(59) xor r_state_x(46) xor r_state_x(69);
                r_state_x(21) <= r_state_x(55) xor r_state_x(88) xor r_state_x(78) xor r_state_x(53) xor r_state_x( 1) xor r_state_x(63);
                r_state_x(22) <= r_state_x(62) xor r_state_x(80) xor r_state_x(33) xor r_state_x(37) xor r_state_x(53);
                r_state_x(23) <= r_state_x( 3) xor r_state_x(35) xor r_state_x(34) xor r_state_x(37) xor r_state_x( 1) xor r_state_x(23);
                r_state_x(24) <= r_state_x(52) xor r_state_x(51) xor r_state_x(86) xor r_state_x(69) xor r_state_x(17);
                r_state_x(25) <= r_state_x(27) xor r_state_x(50) xor r_state_x(79) xor r_state_x(83) xor r_state_x(76) xor r_state_x(95);
                r_state_x(26) <= r_state_x(78) xor r_state_x(42) xor r_state_x(70) xor r_state_x(57) xor r_state_x(94);
                r_state_x(27) <= r_state_x(87) xor r_state_x(22) xor r_state_x(26) xor r_state_x(49) xor r_state_x(84) xor r_state_x(83);
                r_state_x(28) <= r_state_x(94) xor r_state_x(76) xor r_state_x(28) xor r_state_x(42) xor r_state_x(14);
                r_state_x(29) <= r_state_x(11) xor r_state_x(22) xor r_state_x(92) xor r_state_x(58) xor r_state_x(88) xor r_state_x(16);
                r_state_x(30) <= r_state_x(40) xor r_state_x(77) xor r_state_x(12) xor r_state_x(65) xor r_state_x(34);
                r_state_x(31) <= r_state_x(31) xor r_state_x( 8) xor r_state_x(21) xor r_state_x(15) xor r_state_x(68) xor r_state_x(75);
                r_state_x(32) <= r_state_x(39) xor r_state_x(64) xor r_state_x(90) xor r_state_x(69) xor r_state_x(79);
                r_state_x(33) <= r_state_x(85) xor r_state_x(35) xor r_state_x(61) xor r_state_x(90) xor r_state_x(63) xor r_state_x(92);
                r_state_x(34) <= r_state_x(34) xor r_state_x(12) xor r_state_x(73) xor r_state_x(57) xor r_state_x( 1);
                r_state_x(35) <= r_state_x(79) xor r_state_x(37) xor r_state_x(32) xor r_state_x(47) xor r_state_x(66) xor r_state_x(86);
                r_state_x(36) <= r_state_x(43) xor r_state_x(35) xor r_state_x(25) xor r_state_x(65) xor r_state_x(72);
                r_state_x(37) <= r_state_x(40) xor r_state_x(24) xor r_state_x(77) xor r_state_x(59) xor r_state_x(16) xor r_state_x(50);
                r_state_x(38) <= r_state_x(45) xor r_state_x(20) xor r_state_x(56) xor r_state_x(46) xor r_state_x(80);
                r_state_x(39) <= r_state_x(25) xor r_state_x(70) xor r_state_x(64) xor r_state_x(31) xor r_state_x(46) xor r_state_x(74);
                r_state_x(40) <= r_state_x(72) xor r_state_x(65) xor r_state_x( 2) xor r_state_x(36) xor r_state_x(69);
                r_state_x(41) <= r_state_x(90) xor r_state_x( 3) xor r_state_x(71) xor r_state_x(86) xor r_state_x(18) xor r_state_x(63);
                r_state_x(42) <= r_state_x(47) xor r_state_x( 4) xor r_state_x(27) xor r_state_x(24) xor r_state_x(92);
                r_state_x(43) <= r_state_x(48) xor r_state_x(67) xor r_state_x(68) xor r_state_x(42) xor r_state_x(89) xor r_state_x(85);
                r_state_x(44) <= r_state_x(10) xor r_state_x(51) xor r_state_x(13) xor r_state_x(60) xor r_state_x(89);
                r_state_x(45) <= r_state_x(60) xor r_state_x( 7) xor r_state_x(32) xor r_state_x(68) xor r_state_x(30) xor r_state_x(71);
                r_state_x(46) <= r_state_x(33) xor r_state_x(19) xor r_state_x( 3) xor r_state_x(65) xor r_state_x( 8);
                r_state_x(47) <= r_state_x(34) xor r_state_x(30) xor r_state_x(86) xor r_state_x(38) xor r_state_x(31) xor r_state_x(29);
                r_state_x(48) <= r_state_x(55) xor r_state_x(41) xor r_state_x(26) xor r_state_x( 9) xor r_state_x( 7);
                r_state_x(49) <= r_state_x( 4) xor r_state_x(53) xor r_state_x( 7) xor r_state_x(44) xor r_state_x(36) xor r_state_x(24);
                r_state_x(50) <= r_state_x( 4) xor r_state_x( 7) xor r_state_x(49) xor r_state_x(93) xor r_state_x(22);
                r_state_x(51) <= r_state_x( 6) xor r_state_x(53) xor r_state_x(66) xor r_state_x(75) xor r_state_x(35) xor r_state_x(95);
                r_state_x(52) <= r_state_x(30) xor r_state_x(14) xor r_state_x(24) xor r_state_x(28) xor r_state_x(87);
                r_state_x(53) <= r_state_x(10) xor r_state_x(52) xor r_state_x(13) xor r_state_x(11) xor r_state_x(33) xor r_state_x(40);
                r_state_x(54) <= r_state_x(19) xor r_state_x( 4) xor r_state_x(83) xor r_state_x(32) xor r_state_x( 7);
                r_state_x(55) <= r_state_x(85) xor r_state_x(27) xor r_state_x(93) xor r_state_x(94) xor r_state_x( 7) xor r_state_x(73);
                r_state_x(56) <= r_state_x(68) xor r_state_x(92) xor r_state_x(32) xor r_state_x(13) xor r_state_x(10);
                r_state_x(57) <= r_state_x(57) xor r_state_x(90) xor r_state_x(36) xor r_state_x(87) xor r_state_x(75) xor r_state_x(54);
                r_state_x(58) <= r_state_x( 2) xor r_state_x(24) xor r_state_x( 0) xor r_state_x(38) xor r_state_x(45);
                r_state_x(59) <= r_state_x(21) xor r_state_x( 0) xor r_state_x(28) xor r_state_x(13) xor r_state_x(53) xor r_state_x(54);
                r_state_x(60) <= r_state_x(40) xor r_state_x(73) xor r_state_x(80) xor r_state_x(95) xor r_state_x(46);
                r_state_x(61) <= r_state_x(84) xor r_state_x(43) xor r_state_x(73) xor r_state_x(22) xor r_state_x(92) xor r_state_x(38);
                r_state_x(62) <= r_state_x(52) xor r_state_x( 1) xor r_state_x(76) xor r_state_x(39) xor r_state_x(86);
                r_state_x(63) <= r_state_x(48) xor r_state_x( 2) xor r_state_x(86) xor r_state_x(17) xor r_state_x(49) xor r_state_x(93);
                r_state_x(64) <= r_state_x(74) xor r_state_x(25) xor r_state_x(69) xor r_state_x( 6) xor r_state_x(37);
                r_state_x(65) <= r_state_x(15) xor r_state_x(23) xor r_state_x(52) xor r_state_x(77) xor r_state_x(91) xor r_state_x(51);
                r_state_x(66) <= r_state_x(81) xor r_state_x(20) xor r_state_x(64) xor r_state_x( 5) xor r_state_x(87);
                r_state_x(67) <= r_state_x(51) xor r_state_x(15) xor r_state_x(20) xor r_state_x(72) xor r_state_x(39) xor r_state_x(60);
                r_state_x(68) <= r_state_x(43) xor r_state_x(89) xor r_state_x(35) xor r_state_x(70) xor r_state_x(37);
                r_state_x(69) <= r_state_x(71) xor r_state_x(40) xor r_state_x(34) xor r_state_x(66) xor r_state_x(60) xor r_state_x(14);
                r_state_x(70) <= r_state_x(48) xor r_state_x(32) xor r_state_x(29) xor r_state_x(76) xor r_state_x(87);
                r_state_x(71) <= r_state_x(44) xor r_state_x(89) xor r_state_x(19) xor r_state_x(20) xor r_state_x( 9) xor r_state_x(77);
                r_state_x(72) <= r_state_x(81) xor r_state_x( 8) xor r_state_x(75) xor r_state_x(49) xor r_state_x(47);
                r_state_x(73) <= r_state_x(29) xor r_state_x(41) xor r_state_x(67) xor r_state_x(12) xor r_state_x( 6) xor r_state_x(56);
                r_state_x(74) <= r_state_x(49) xor r_state_x(82) xor r_state_x( 5) xor r_state_x(17) xor r_state_x(58);
                r_state_x(75) <= r_state_x(78) xor r_state_x(62) xor r_state_x(19) xor r_state_x(68) xor r_state_x(63) xor r_state_x(94);
                r_state_x(76) <= r_state_x(18) xor r_state_x(45) xor r_state_x(57) xor r_state_x(41) xor r_state_x( 1);
                r_state_x(77) <= r_state_x(83) xor r_state_x(58) xor r_state_x(72) xor r_state_x(31) xor r_state_x(74) xor r_state_x(63);
                r_state_x(78) <= r_state_x(13) xor r_state_x(79) xor r_state_x(47) xor r_state_x(67) xor r_state_x(71);
                r_state_x(79) <= r_state_x(31) xor r_state_x(91) xor r_state_x(69) xor r_state_x(47) xor r_state_x(74) xor r_state_x(65);
                r_state_x(80) <= r_state_x(16) xor r_state_x(72) xor r_state_x(81) xor r_state_x(82) xor r_state_x(26);
                r_state_x(81) <= r_state_x(42) xor r_state_x(57) xor r_state_x(41) xor r_state_x(88) xor r_state_x(95) xor r_state_x(12);
                r_state_x(82) <= r_state_x(81) xor r_state_x(91) xor r_state_x(40) xor r_state_x(11) xor r_state_x(26);
                r_state_x(83) <= r_state_x(50) xor r_state_x(93) xor r_state_x(27) xor r_state_x(70) xor r_state_x(77) xor r_state_x(92);
                r_state_x(84) <= r_state_x(80) xor r_state_x( 9) xor r_state_x(64) xor r_state_x(34) xor r_state_x(70);
                r_state_x(85) <= r_state_x( 2) xor r_state_x(74) xor r_state_x(29) xor r_state_x(83) xor r_state_x(67) xor r_state_x(18);
                r_state_x(86) <= r_state_x(20) xor r_state_x(47) xor r_state_x(33) xor r_state_x(60) xor r_state_x(19);
                r_state_x(87) <= r_state_x(17) xor r_state_x(52) xor r_state_x(39) xor r_state_x(89) xor r_state_x(67) xor r_state_x(91);
                r_state_x(88) <= r_state_x(54) xor r_state_x( 5) xor r_state_x(39) xor r_state_x(79) xor r_state_x(77);
                r_state_x(89) <= r_state_x(82) xor r_state_x(21) xor r_state_x(84) xor r_state_x(42) xor r_state_x(36) xor r_state_x(66);
                r_state_x(90) <= r_state_x( 9) xor r_state_x(32) xor r_state_x( 0) xor r_state_x(11) xor r_state_x(23);
                r_state_x(91) <= r_state_x( 5) xor r_state_x(56) xor r_state_x(61) xor r_state_x(72) xor r_state_x(18) xor r_state_x(55);
                r_state_x(92) <= r_state_x(58) xor r_state_x(95) xor r_state_x(86) xor r_state_x(81) xor r_state_x(22);
                r_state_x(93) <= r_state_x(73) xor r_state_x(26) xor r_state_x(70) xor r_state_x( 3) xor r_state_x(61) xor r_state_x(82);
                r_state_x(94) <= r_state_x(44) xor r_state_x( 8) xor r_state_x( 2) xor r_state_x(50) xor r_state_x(42);
                r_state_x(95) <= r_state_x(55) xor r_state_x(83) xor r_state_x( 5) xor r_state_x(33) xor r_state_x(16) xor r_state_x(21);
                
                for i in 0 to streams - 1 loop
                    v_mixin := r_state_x xor salts(i);
                    v_mixup := r_state_y(96 * ((i + 1) mod streams) + 95 downto 96 * ((i + 1) mod streams));
                    v_res( 0) := v_mixup( 0) xor (v_mixup(45) and not v_mixup(46)) xor v_mixup(36) xor v_mixup(43) xor v_mixin((i + 50) mod 96);
                    v_res( 1) := v_mixup( 1) xor (v_mixup(46) and not v_mixup(47)) xor v_mixup(37) xor v_mixup(44) xor v_mixin((i + 20) mod 96);
                    v_res( 2) := v_mixup( 2) xor (v_mixup(47) and not v_mixup(48)) xor v_mixup(38) xor v_mixup(45) xor v_mixin((i + 91) mod 96);
                    v_res( 3) := v_mixup( 3) xor (v_mixup(48) and not v_mixup(49)) xor v_mixup(39) xor v_mixup(46) xor v_mixin((i + 59) mod 96);
                    v_res( 4) := v_mixup( 4) xor (v_mixup(49) and not v_mixup(50)) xor v_mixup(40) xor v_mixup(47) xor v_mixin((i + 26) mod 96);
                    v_res( 5) := v_mixup( 5) xor (v_mixup(50) and not v_mixup(51)) xor v_mixup(41) xor v_mixup(48) xor v_mixin((i +  4) mod 96);
                    v_res( 6) := v_mixup( 6) xor (v_mixup(51) and not v_mixup(52)) xor v_mixup(42) xor v_mixup(49) xor v_mixin((i + 58) mod 96);
                    v_res( 7) := v_mixup( 7) xor (v_mixup(52) and not v_mixup(53)) xor v_mixup(43) xor v_mixup(50) xor v_mixin((i + 25) mod 96);
                    v_res( 8) := v_mixup( 8) xor (v_mixup(53) and not v_mixup(54)) xor v_mixup(44) xor v_mixup(51) xor v_mixin((i + 71) mod 96);
                    v_res( 9) := v_mixup( 9) xor (v_mixup(54) and not v_mixup(55)) xor v_mixup(45) xor v_mixup(52) xor v_mixin((i + 77) mod 96);
                    v_res(10) := v_mixup(10) xor (v_mixup(55) and not v_mixup(56)) xor v_mixup(46) xor v_mixup(53) xor v_mixin((i + 13) mod 96);
                    v_res(11) := v_mixup(11) xor (v_mixup(56) and not v_mixup(57)) xor v_mixup(47) xor v_mixup(54) xor v_mixin((i +  2) mod 96);
                    v_res(12) := v_mixup(12) xor (v_mixup(57) and not v_mixup(58)) xor v_mixup(48) xor v_mixup(55) xor v_mixin((i + 30) mod 96);
                    v_res(13) := v_mixup(13) xor (v_mixup(58) and not v_mixup(59)) xor v_mixup(49) xor v_mixup(56) xor v_mixin((i + 72) mod 96);
                    v_res(14) := v_mixup(14) xor (v_mixup(59) and not v_mixup(60)) xor v_mixup(50) xor v_mixup(57) xor v_mixin((i + 11) mod 96);
                    v_res(15) := v_mixup(15) xor (v_mixup(60) and not v_mixup(61)) xor v_mixup(51) xor v_mixup(58) xor v_mixin((i + 15) mod 96);
                    v_res(16) := v_mixup(16) xor (v_mixup(61) and not v_mixup(62)) xor v_mixup(52) xor v_mixup(59) xor v_mixin((i + 45) mod 96);
                    v_res(17) := v_mixup(17) xor (v_mixup(62) and not v_mixup(63)) xor v_mixup(53) xor v_mixup(60) xor v_mixin((i + 61) mod 96);
                    v_res(18) := v_mixup(18) xor (v_mixup(63) and not v_mixup(64)) xor v_mixup(54) xor v_mixup(61) xor v_mixin((i + 80) mod 96);
                    v_res(19) := v_mixup(19) xor (v_mixup(64) and not v_mixup(65)) xor v_mixup(55) xor v_mixup(62) xor v_mixin((i + 19) mod 96);
                    v_res(20) := v_mixup(20) xor (v_mixup(65) and not v_mixup(66)) xor v_mixup(56) xor v_mixup(63) xor v_mixin((i + 33) mod 96);
                    v_res(21) := v_mixup(21) xor (v_mixup(66) and not v_mixup(67)) xor v_mixup(57) xor v_mixup(64) xor v_mixin((i + 35) mod 96);
                    v_res(22) := v_mixup(22) xor (v_mixup(67) and not v_mixup(68)) xor v_mixup(58) xor v_mixup(65) xor v_mixin((i + 62) mod 96);
                    v_res(23) := v_mixup(23) xor (v_mixup(68) and not v_mixup(69)) xor v_mixup(59) xor v_mixup(66) xor v_mixin((i +  1) mod 96);
                    v_res(24) := v_mixup(24) xor (v_mixup(69) and not v_mixup(70)) xor v_mixup(60) xor v_mixup(67) xor v_mixin((i + 74) mod 96);
                    v_res(25) := v_mixup(25) xor (v_mixup(70) and not v_mixup(71)) xor v_mixup(61) xor v_mixup(68) xor v_mixin((i + 18) mod 96);
                    v_res(26) := v_mixup(26) xor (v_mixup(71) and not v_mixup(72)) xor v_mixup(62) xor v_mixup(69) xor v_mixin((i + 90) mod 96);
                    v_res(27) := v_mixup(27) xor (v_mixup(72) and not v_mixup(73)) xor v_mixup(63) xor v_mixup(70) xor v_mixin((i + 66) mod 96);
                    v_res(28) := v_mixup(28) xor (v_mixup(73) and not v_mixup(74)) xor v_mixup(64) xor v_mixup(71) xor v_mixin((i + 67) mod 96);
                    v_res(29) := v_mixup(29) xor (v_mixup(74) and not v_mixup(75)) xor v_mixup(65) xor v_mixup(72) xor v_mixin((i + 88) mod 96);
                    v_res(30) := v_mixup(30) xor (v_mixup(75) and not v_mixup(76)) xor v_mixup(66) xor v_mixup(73) xor v_mixin((i + 28) mod 96);
                    v_res(31) := v_mixup(31) xor (v_mixup(76) and not v_mixup(77)) xor v_mixup(67) xor v_mixup(74) xor v_mixin((i + 53) mod 96);
                    v_res(32) := v_mixup(32) xor (v_mixup(77) and not v_mixup(78)) xor v_mixup(68) xor v_mixup(75) xor v_mixin((i + 23) mod 96);
                    v_res(33) := v_mixup(33) xor (v_mixup(78) and not v_mixup(79)) xor v_mixup(69) xor v_mixup(76) xor v_mixin((i + 94) mod 96);
                    v_res(34) := v_mixup(34) xor (v_mixup(79) and not v_mixup(80)) xor v_mixup(70) xor v_mixup(77) xor v_mixin((i + 55) mod 96);
                    v_res(35) := v_mixup(35) xor (v_mixup(80) and not v_mixup(81)) xor v_mixup(71) xor v_mixup(78) xor v_mixin((i + 37) mod 96);
                    v_res(36) := v_mixup(36) xor (v_mixup(81) and not v_mixup(82)) xor v_mixup(72) xor v_mixup(79) xor v_mixin((i + 34) mod 96);
                    v_res(37) := v_mixup(37) xor (v_mixup(82) and not v_mixup(83)) xor v_mixup(73) xor v_mixup(80) xor v_mixin((i + 24) mod 96);
                    v_res(38) := v_mixup(38) xor (v_mixup(83) and not v_mixup(84)) xor v_mixup(74) xor v_mixup(81) xor v_mixin((i + 65) mod 96);
                    v_res(39) := v_mixup(39) xor (v_mixup(84) and not v_mixup(85)) xor v_mixup(75) xor v_mixup(82) xor v_mixin((i + 46) mod 96);
                    v_res(40) := v_mixup(40) xor (v_mixup(85) and not v_mixup(86)) xor v_mixup(76) xor v_mixup(83) xor v_mixin((i + 32) mod 96);
                    v_res(41) := v_mixup(41) xor (v_mixup(86) and not v_mixup(87)) xor v_mixup(77) xor v_mixup(84) xor v_mixin((i + 84) mod 96);
                    v_res(42) := v_mixup(42) xor (v_mixup(87) and not v_mixup(88)) xor v_mixup(78) xor v_mixup(85) xor v_mixin((i + 79) mod 96);
                    v_res(43) := v_mixup(43) xor (v_mixup(88) and not v_mixup(89)) xor v_mixup(79) xor v_mixup(86) xor v_mixin((i + 48) mod 96);
                    v_res(44) := v_mixup(44) xor (v_mixup(89) and not v_mixup(90)) xor v_mixup(80) xor v_mixup(87) xor v_mixin((i + 92) mod 96);
                    v_res(45) := v_mixup(45) xor (v_mixup(90) and not v_mixup(91)) xor v_mixup(81) xor v_mixup(88) xor v_mixin((i + 57) mod 96);
                    v_res(46) := v_mixup(46) xor (v_mixup(91) and not v_mixup(92)) xor v_mixup(82) xor v_mixup(89) xor v_mixin((i + 41) mod 96);
                    v_res(47) := v_mixup(47) xor (v_mixup(92) and not v_mixup(93)) xor v_mixup(83) xor v_mixup(90) xor v_mixin((i + 27) mod 96);
                    v_state_y(96 * i + 95 downto 96 * i) := v_res & r_state_y(96 * i + 95 downto 96 * i + 48);
                end loop;
                
                for i in 0 to streams - 1 loop
                    v_mixin := r_state_x xor salts(i);
                    v_mixup := v_state_y(96 * ((i + 1) mod streams) + 95 downto 96 * ((i + 1) mod streams));
                    v_res( 0) := v_mixup( 0) xor (v_mixup(45) and not v_mixup(46)) xor v_mixup(36) xor v_mixup(43) xor v_mixin((i + 64) mod 96);
                    v_res( 1) := v_mixup( 1) xor (v_mixup(46) and not v_mixup(47)) xor v_mixup(37) xor v_mixup(44) xor v_mixin((i + 95) mod 96);
                    v_res( 2) := v_mixup( 2) xor (v_mixup(47) and not v_mixup(48)) xor v_mixup(38) xor v_mixup(45) xor v_mixin((i + 70) mod 96);
                    v_res( 3) := v_mixup( 3) xor (v_mixup(48) and not v_mixup(49)) xor v_mixup(39) xor v_mixup(46) xor v_mixin((i +  6) mod 96);
                    v_res( 4) := v_mixup( 4) xor (v_mixup(49) and not v_mixup(50)) xor v_mixup(40) xor v_mixup(47) xor v_mixin((i + 93) mod 96);
                    v_res( 5) := v_mixup( 5) xor (v_mixup(50) and not v_mixup(51)) xor v_mixup(41) xor v_mixup(48) xor v_mixin((i + 21) mod 96);
                    v_res( 6) := v_mixup( 6) xor (v_mixup(51) and not v_mixup(52)) xor v_mixup(42) xor v_mixup(49) xor v_mixin((i + 76) mod 96);
                    v_res( 7) := v_mixup( 7) xor (v_mixup(52) and not v_mixup(53)) xor v_mixup(43) xor v_mixup(50) xor v_mixin((i + 85) mod 96);
                    v_res( 8) := v_mixup( 8) xor (v_mixup(53) and not v_mixup(54)) xor v_mixup(44) xor v_mixup(51) xor v_mixin((i + 40) mod 96);
                    v_res( 9) := v_mixup( 9) xor (v_mixup(54) and not v_mixup(55)) xor v_mixup(45) xor v_mixup(52) xor v_mixin((i + 83) mod 96);
                    v_res(10) := v_mixup(10) xor (v_mixup(55) and not v_mixup(56)) xor v_mixup(46) xor v_mixup(53) xor v_mixin((i + 56) mod 96);
                    v_res(11) := v_mixup(11) xor (v_mixup(56) and not v_mixup(57)) xor v_mixup(47) xor v_mixup(54) xor v_mixin((i + 29) mod 96);
                    v_res(12) := v_mixup(12) xor (v_mixup(57) and not v_mixup(58)) xor v_mixup(48) xor v_mixup(55) xor v_mixin((i + 12) mod 96);
                    v_res(13) := v_mixup(13) xor (v_mixup(58) and not v_mixup(59)) xor v_mixup(49) xor v_mixup(56) xor v_mixin((i +  9) mod 96);
                    v_res(14) := v_mixup(14) xor (v_mixup(59) and not v_mixup(60)) xor v_mixup(50) xor v_mixup(57) xor v_mixin((i + 68) mod 96);
                    v_res(15) := v_mixup(15) xor (v_mixup(60) and not v_mixup(61)) xor v_mixup(51) xor v_mixup(58) xor v_mixin((i + 73) mod 96);
                    v_res(16) := v_mixup(16) xor (v_mixup(61) and not v_mixup(62)) xor v_mixup(52) xor v_mixup(59) xor v_mixin((i + 78) mod 96);
                    v_res(17) := v_mixup(17) xor (v_mixup(62) and not v_mixup(63)) xor v_mixup(53) xor v_mixup(60) xor v_mixin((i + 69) mod 96);
                    v_res(18) := v_mixup(18) xor (v_mixup(63) and not v_mixup(64)) xor v_mixup(54) xor v_mixup(61) xor v_mixin((i + 22) mod 96);
                    v_res(19) := v_mixup(19) xor (v_mixup(64) and not v_mixup(65)) xor v_mixup(55) xor v_mixup(62) xor v_mixin((i + 47) mod 96);
                    v_res(20) := v_mixup(20) xor (v_mixup(65) and not v_mixup(66)) xor v_mixup(56) xor v_mixup(63) xor v_mixin((i + 42) mod 96);
                    v_res(21) := v_mixup(21) xor (v_mixup(66) and not v_mixup(67)) xor v_mixup(57) xor v_mixup(64) xor v_mixin((i + 82) mod 96);
                    v_res(22) := v_mixup(22) xor (v_mixup(67) and not v_mixup(68)) xor v_mixup(58) xor v_mixup(65) xor v_mixin((i + 44) mod 96);
                    v_res(23) := v_mixup(23) xor (v_mixup(68) and not v_mixup(69)) xor v_mixup(59) xor v_mixup(66) xor v_mixin((i + 54) mod 96);
                    v_res(24) := v_mixup(24) xor (v_mixup(69) and not v_mixup(70)) xor v_mixup(60) xor v_mixup(67) xor v_mixin((i + 36) mod 96);
                    v_res(25) := v_mixup(25) xor (v_mixup(70) and not v_mixup(71)) xor v_mixup(61) xor v_mixup(68) xor v_mixin((i +  5) mod 96);
                    v_res(26) := v_mixup(26) xor (v_mixup(71) and not v_mixup(72)) xor v_mixup(62) xor v_mixup(69) xor v_mixin((i +  3) mod 96);
                    v_res(27) := v_mixup(27) xor (v_mixup(72) and not v_mixup(73)) xor v_mixup(63) xor v_mixup(70) xor v_mixin((i + 63) mod 96);
                    v_res(28) := v_mixup(28) xor (v_mixup(73) and not v_mixup(74)) xor v_mixup(64) xor v_mixup(71) xor v_mixin((i + 31) mod 96);
                    v_res(29) := v_mixup(29) xor (v_mixup(74) and not v_mixup(75)) xor v_mixup(65) xor v_mixup(72) xor v_mixin((i + 16) mod 96);
                    v_res(30) := v_mixup(30) xor (v_mixup(75) and not v_mixup(76)) xor v_mixup(66) xor v_mixup(73) xor v_mixin((i + 87) mod 96);
                    v_res(31) := v_mixup(31) xor (v_mixup(76) and not v_mixup(77)) xor v_mixup(67) xor v_mixup(74) xor v_mixin((i + 38) mod 96);
                    v_res(32) := v_mixup(32) xor (v_mixup(77) and not v_mixup(78)) xor v_mixup(68) xor v_mixup(75) xor v_mixin((i + 10) mod 96);
                    v_res(33) := v_mixup(33) xor (v_mixup(78) and not v_mixup(79)) xor v_mixup(69) xor v_mixup(76) xor v_mixin((i + 81) mod 96);
                    v_res(34) := v_mixup(34) xor (v_mixup(79) and not v_mixup(80)) xor v_mixup(70) xor v_mixup(77) xor v_mixin((i + 60) mod 96);
                    v_res(35) := v_mixup(35) xor (v_mixup(80) and not v_mixup(81)) xor v_mixup(71) xor v_mixup(78) xor v_mixin((i + 51) mod 96);
                    v_res(36) := v_mixup(36) xor (v_mixup(81) and not v_mixup(82)) xor v_mixup(72) xor v_mixup(79) xor v_mixin((i + 43) mod 96);
                    v_res(37) := v_mixup(37) xor (v_mixup(82) and not v_mixup(83)) xor v_mixup(73) xor v_mixup(80) xor v_mixin((i + 75) mod 96);
                    v_res(38) := v_mixup(38) xor (v_mixup(83) and not v_mixup(84)) xor v_mixup(74) xor v_mixup(81) xor v_mixin((i +  8) mod 96);
                    v_res(39) := v_mixup(39) xor (v_mixup(84) and not v_mixup(85)) xor v_mixup(75) xor v_mixup(82) xor v_mixin((i + 89) mod 96);
                    v_res(40) := v_mixup(40) xor (v_mixup(85) and not v_mixup(86)) xor v_mixup(76) xor v_mixup(83) xor v_mixin((i + 39) mod 96);
                    v_res(41) := v_mixup(41) xor (v_mixup(86) and not v_mixup(87)) xor v_mixup(77) xor v_mixup(84) xor v_mixin((i + 86) mod 96);
                    v_res(42) := v_mixup(42) xor (v_mixup(87) and not v_mixup(88)) xor v_mixup(78) xor v_mixup(85) xor v_mixin((i + 14) mod 96);
                    v_res(43) := v_mixup(43) xor (v_mixup(88) and not v_mixup(89)) xor v_mixup(79) xor v_mixup(86) xor v_mixin((i +  7) mod 96);
                    v_res(44) := v_mixup(44) xor (v_mixup(89) and not v_mixup(90)) xor v_mixup(80) xor v_mixup(87) xor v_mixin((i + 52) mod 96);
                    v_res(45) := v_mixup(45) xor (v_mixup(90) and not v_mixup(91)) xor v_mixup(81) xor v_mixup(88) xor v_mixin((i +  0) mod 96);
                    v_res(46) := v_mixup(46) xor (v_mixup(91) and not v_mixup(92)) xor v_mixup(82) xor v_mixup(89) xor v_mixin((i + 49) mod 96);
                    v_res(47) := v_mixup(47) xor (v_mixup(92) and not v_mixup(93)) xor v_mixup(83) xor v_mixup(90) xor v_mixin((i + 17) mod 96);
                    r_state_y(96 * i + 95 downto 96 * i) <= v_res & v_state_y(96 * i + 95 downto 96 * i + 48);
                end loop;
                
            end if;
        end if;
    end process;
    
end rtl;

