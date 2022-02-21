-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl.py`.

library ieee;
use ieee.std_logic_1164.all;

entity xormix64_tb is
end xormix64_tb;

architecture bhv of xormix64_tb is
    
    -- configuration
    constant streams : integer := 4;
    constant results : integer := 100;
    constant seed_x  : std_logic_vector(63 downto 0) :=
        x"91eb2642dd235c45";
    constant seed_y  : std_logic_vector(64 * streams - 1 downto 0) :=
        x"76151b36c1b25d925fe5385d7b0d285ce1fb2a562c946e0ee02c9cdec24e8b50";
    
    -- reference result
    type result_array_t is array(0 to results - 1) of std_logic_vector(64 * streams - 1 downto 0);
    signal ref_result : result_array_t := (
        x"76151b36c1b25d925fe5385d7b0d285ce1fb2a562c946e0ee02c9cdec24e8b50",
        x"06059f171acf0136b7dd4058c006162e232ff81497a486174d50dcc76171dd41",
        x"8cdfe196b76bcf357983acd3dccf9ae48d9dc35b7e36e4ffa94e9c3c76a529ca",
        x"0e31a6f7032be176adec5e88b806466224beb22f63007c7e2b83fe52a1ad7aa8",
        x"6a8013034a05b300a784049a08cc961d3df5f77441b8700b54df02ce2b3d7078",
        x"735b5be061251bb522dd740016f14d48e54b09d51de905f98cfb9970a7a6f722",
        x"8ded46bf87534668ca4cb105b80e9510a855aecd68d7ec1c837e4a4692421f67",
        x"e221612e6e4fdd3f83f0889683058ab3c70277424f2eade0fe4d51090856c8b1",
        x"6735ec77334bc875a4a13d92bf3980fb4f14e327778eccc7dbbfe13a732b3d73",
        x"7a042b24f88938d4d93d76a2759fabb3a7f9ccf0b5200604c22c4bca13814ead",
        x"a5e1ea51a4b13c0e505a2c632743dfd27c1ed927ffe178f0b9318c38429d487c",
        x"672373ed2732243dc17b8a04f1d03ddc04a6ab4bbbb617bbaefdf39e2e466d87",
        x"b4a36ad4767a12c6a36f3537d45fbb8fc45cb218e844634d93b8e384fecd94b3",
        x"5d121a87368972d83875e2155458e865624039b20fae68bedbe5bd65b778a20d",
        x"f2e10508b6d6e76c016738f13946625e9b535296b3b4aacef222f6dd2544e2a5",
        x"8ad8fc04836569bbc609794252510141910ba5722d652ff20b560c85c106b3d6",
        x"5096d2d3f1b58595c79195735159a4c56b3e5640e4cc271418eb74bbb1707d7d",
        x"76b1c781dd0a478c5e41cd68f36191d877035936dc991c0b5235437eda582c2e",
        x"8bd0e3c9028dcdb4561509e5e638b0088e0ff35d8a15fd8a656a280e2ad9c28a",
        x"ba51038cb379f0baf9ca027fdd5034d9bada49e9734a1d44a8d31ef30a83edb5",
        x"15bfc1306e27ee67f17b03678e36f94789958dbf6a1db6bcfe67ce1b8ad90b78",
        x"3a62cae79acec5baa00b75b3d17fc9fc4f172dfc8f7c5863ac9c6c9208ab201f",
        x"4a4f7b0e0b0ce719c217bcdae631632bcd5b4b9f2c17260e4f1260f13f956062",
        x"d0ce4dc9e72906b10abefa780662fab8c1125261e27deb63c7f8f38337207789",
        x"35a387f59579c6b2c213122d347e659ffffa718473b3a59603cf1d16717042dd",
        x"5631f8d399539a8b439ef22ec752eb5a97e7e4fabd6bb5cf35b0aa91429a52c4",
        x"555a699b92879f8bc406eae187b699c3383e4e82a2c07af389932d7fb704677e",
        x"c8d6f9f5c9a81b78506cbbcf3c19d6a37f573f51d58d8529c95ee05e80226cf9",
        x"b466c09214d2c9e4694ac6acaf6ebbdf6dce7e13f108eac7d3f9c789d7d9eddc",
        x"c11e8b85c71ffe3adae07d37b558551b00907d47beb20c4ea8ebbcd04497f895",
        x"1aeb14fd09cc3d34f04a3f93ffd18c279325e5a2fce2b1fdecdd7e62854fcbfa",
        x"aa78db26ca40a791ca3c38e766c3880cc94e193d55a85d7f931e21cc93520afc",
        x"ed251255118a5818199b5f792d72949a9d53ea2a83fa1702de5c845fbbfbc058",
        x"a252a1dda920bf7b1c1fe8ec667ef1a9305af40166ce1742bf3768ec2d35c678",
        x"0d9a9c48807d8ff92af5da4fe79d0be436040fb7400a6eaf6fa348f0e09c1896",
        x"b1a316a9ffb4cdf910ddb43bbc5fc81e2ca5cb4f4e27d9373aed568e12b533ad",
        x"2ba2789a4b2a38448aafbb06209c2a3d11457a21df70c61864edadb1622e0a94",
        x"31ac7d0b34dfd57dd185135beea5ee402e64c7769036cb0c11ac519d95e11733",
        x"af214c4f328d6f88e59652fbdf2ffdb528029276b68a47417a5abbfb8aa06a47",
        x"7283db0d78271de223b51385feeffe3e38dbfdb1aeb56fb5cdb3a81b63c6f07e",
        x"4900b8c2865bdd04e0811d406e7fc165e95007c1d95030a0f26b58863d99def8",
        x"43c5c4784733404e254254346001fd3e3e22c39238bae921084ae7de8b3e098b",
        x"bf7246687705331abde78f1ce7bd951139a77e12e4ae1e4250922f6fd49edd9d",
        x"3055f1c6e840a9551bedfefd806e10e8d28ef2ed193c6b5cbfd5e6889458b3d7",
        x"d1227c2245bd1429f57d30aad101518cf25503305a4e56263fc1a6fe13ccb671",
        x"7b2f30afe127c87ca02dac17e454da97c0ac6eec6d6e9e7fb98a63be99fc78ba",
        x"4569d7510eb1ad6de9ccb0baac8bd00f1dea973fcf9330becd48863bdc71394d",
        x"f84fc5b60f2c179bd5554c9ec18963bf25d6c4d2a28d3cb4a36cbcaa25f38c7d",
        x"9db473818e532c96e57b9ed218ce60e53ac329951e9fbdf619e5f9dc91aced35",
        x"180b265ca771312fcaa1d9a0874e4088b4b41d8b77e2b4bef7433bf38a296881",
        x"0006d46ab226551bebe8e7f941f04ffdcd8da5e6e22baaa139cc34c0c848784a",
        x"31cb7c468e87622ebe2fa02f2e3dca4551d8c1e3a88a43d215aa5cf250a70973",
        x"9c3cec124a9f9c897deed018ed2ddd5f804703e5469adf0a86fee8da50ce0cb0",
        x"a82cacdc615e4a25314cbf6e9a2f8acf72ad625fa41c0a58db260ff6e597c7c2",
        x"21ffbfd43fe8a2280cc1d0071ab30b8ecfb095f359f311f8bb06506703b50f8d",
        x"2aaa5ce2c267cf68359881051b75c9aa6c6d19ad53edb717764f74606c255f80",
        x"ca2c1445a5607031f580b98489686e39cd75a6040e31de0ceb5a0e4a1786cd56",
        x"58c00b84f2d3f2c7158850d5ee37dad9916f6f2ad76fb1724615dc6956c12f75",
        x"025dd7517a263bd013bd1f93c49672fdffcd7c8cfd41f25d1052f81bc7e522cd",
        x"297ab38f853c66ef4034548e8e8160ea3ff4e072e7d355262e045df373327f77",
        x"d8a76d7b5289e2fde212260f906f5016fc62dae0cbdfc57d3bec639ab9ff6776",
        x"355ec97d23b950b4102ed45ea570ef183846e178bba904c3831a0e9f632e2cbe",
        x"cc837a059dc5580d85399a6852d1d81acaa084e9dad3937092b86bb29ae36191",
        x"a56bae3d10d28f141c82f077d079025f1033e9c3c6ed2ddc3721a3e28c2942f0",
        x"71108c5de0acd8eb486aa176f5fec2ed97f92c68456e8b8677ee2facc69ee353",
        x"a1af6f5c587e925651b27cbb13d180f8512bf39e581e6a75263d7ec5517387b3",
        x"4276e9e77d3100763fbdedf02ca3f5721f5ff9b0bf1ae1a25eb07630e595f190",
        x"d04837dc8a450801c9f914b882ffa1a26a767580334186015c9e9dfeac16f2fc",
        x"8167831c18d6af62bfde7e51a6288fa3c22b008c8931ae714d1f6f0b004d5816",
        x"b615c0794950a72e840cf81558167d25353ef9fce93de1c80b85cebe4d3a58d7",
        x"a25648287b8763f81aa3827d9c919e26977eb455a7913bb58eb820b80ff05ba2",
        x"a188960073877828f773484cca7d54957b51fc65ad596d6d28c19c5662bc7b20",
        x"7b9dca2552cfd833df54cd6ad62270c9deb5c3bce06933570b9b50e80a0fe52e",
        x"d25c0e8f2542ce5865b180522d47c4ed1a0d5130020d8dbe3a03526f1b88417e",
        x"dfbf313a8fceee0f8b2c07c88f57f18558cb6e00ed2b7a3ec10638b71de74bc6",
        x"fcb32b226122a356dba4013ab606aca00b48684eaf090f5b9361c3ff7e67345f",
        x"7a115b8cf3e5842d9f06febf70bd4a52d318299c094c78d9f79d4396e94f5273",
        x"3a9a2dd981106ed2f5b4e500623e31039eaf6c4fc05631a4a81039bc0b408c44",
        x"c185553e4a49f6a2d5a73e7cdc2c371622453ed99afab2764c8909349383821a",
        x"b61a70b8c9375b90762ce088e8b29f5cef1c8427d13f2780714a58636dc57dde",
        x"e0cd1785f81d572f0ae0e25631f880460b456c36e50535421b00212af5e2d0e9",
        x"701202b00b4bde68c990d3dc8437d9eebaf031acdbed2d1eaaa4d1787a07b4f8",
        x"e24230178a959a94d667931e5a71c7f27d9dcc9d824c0a73600ecdec2cf7a961",
        x"f08ddd1805785bd1afb2a69f2e8ab6d0be9a263757cb90d7c5c49aa72162d910",
        x"860d28f7c561df7c779d6a01a06ba7df4e16d8e780bad4f9365bd73fb1815c8f",
        x"1249d4a4ab7d917939cc513ac23eeaafa944367af3e84ebd19f64a7fbe271712",
        x"4c9d08256801c6e71f06cbae3466dc7ad4f34869ceeb9188f0f714b487d8ea9e",
        x"8f044392f68081c67c1fa83c3a28b2d6c7ed915c5e967a87b0dfcf0acdbd95ac",
        x"efec3a09392ae9d836176dd69c48b772ea5c96564c1ffac234b4ff25e4030b4c",
        x"51296928f7a432460e08cf4d84fbf9a0688c8d644c7e2c16a53d2fd6de785a5d",
        x"bdf779e0754b4407d0ad471bceced20118a29272009511d2b55a8521864bf621",
        x"0516de41035fe8527c28e05f83679946718d2dcf29306bd3997ce1ce2520c3ff",
        x"184cab7e97536f1404edca8324b40fe3854949410ee1b7ebcd9ea0f7aeda0249",
        x"3e2b6003ebef2d61629ae549670ee8dc0e3e0072cb94301641c9e44ed4cbe89c",
        x"385a9e423bb14aa2af504220a13bd11808fa09dc98d28411c7413c8ffa284472",
        x"0a43c7da79bc3ff77418d77c2ea8e892a91fa74427d97faf59c1748a3e66039f",
        x"5bc0281f7dde6a1c91a59bd70540c6ad301d51b5772b48995c4aeb8c0498c258",
        x"2aceaf819791d1e4f62180ef5a6863de139d7b8d2f3029cbe926da907978bd8e",
        x"17f18fd86510d206778558cc14d45019216e5fce864afd1c2c8b2649ec0c458c",
        x"a7bf00f6f9adc12dc66d48eff41761e37d628be251c3cc09e6f6885a333b5b8f"
    );
    
    -- DUT signals
    signal clk    : std_logic := '0';
    signal rst    : std_logic;
    signal enable : std_logic;
    signal result : std_logic_vector(64 * streams - 1 downto 0);
    
    -- flag to stop simulation
    signal run : boolean := true;
    
begin
    
    -- DUT
    inst_xormix : entity work.xormix64_x7s generic map(
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
