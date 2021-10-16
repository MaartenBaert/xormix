-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl.py`.

library ieee;
use ieee.std_logic_1164.all;

entity xormix48_tb is
end xormix48_tb;

architecture bhv of xormix48_tb is
    
    -- configuration
    constant streams : integer := 4;
    constant results : integer := 100;
    constant seed_x  : std_logic_vector(47 downto 0) :=
        x"6628a302e856";
    constant seed_y  : std_logic_vector(48 * streams - 1 downto 0) :=
        x"fb9cd8807a15a8c2e722a2a3c3c4bac365bea0720bfb3dce";
    
    -- reference result
    type result_array_t is array(0 to results - 1) of std_logic_vector(48 * streams - 1 downto 0);
    signal ref_result : result_array_t := (
        x"fb9cd8807a15a8c2e722a2a3c3c4bac365bea0720bfb3dce",
        x"d83ab17ee70a6ac3732ed6c5aa4a726805c29a1466b254d6",
        x"796cc761f9ae87e61091c413022462c0ec5ce047d486f8ee",
        x"e9cba8764dbcb4b9f960e92ec091f157358017bdbe49db86",
        x"8c160380c21cd21fff98a6c4e764132ffbc7a362b589026e",
        x"c02a5e094d3a295f3114ab41288c9edecfb5b8c680aa5ee6",
        x"54f2f480278e5bcd5bcb8b22b1129f307d493121e2449a87",
        x"c19e44190c4953c6c2577ef7f9449088accba143797f8411",
        x"49a1cd0dc719af356e409e767b1b38d401ccfa06cd555b00",
        x"746949e61c53b553a9edf3b7fc613bebc15ec32c0747cfb5",
        x"fb8924c35361adae6a357b9b552a2ba0d3077dcf94e0b0a6",
        x"251d58eb11c84ea0b7ef58adf0567a30fec4ca982de268aa",
        x"d69bc4915e5718ed7a13f6871afcf4ad5d3e0c5aec7acbf3",
        x"4d5a4b8e35d69dcbcfc59e5079c08974d536a0bc2a4993b2",
        x"a89d78b3ca6224f91d8dcd9cc93e68a622f658b288eacb19",
        x"cfeb5a8f4171c32187ac29be15d8b44b0df6e77ced6e41aa",
        x"7890aef8e263a6a4a4178bd64f07ded891ba233568381912",
        x"9adbf56dba6ff88310a31037852f432a4b0f3dcfb6db178d",
        x"3f3c98c07ac799d8eb2bdc744ec2956df1e369f88300a54f",
        x"76cba787e6344657c89ba8eb0468bb613dddcbfadd46d701",
        x"23f061d73940f46a522543923845ffa9f16e3e429c0892a1",
        x"9d8ce22ddd7934b7533edd1f497f2964941b950fd2d8d1b6",
        x"4a387542ed3c8e46a7db7ce4bde1d8cdace51261dd88f538",
        x"c7f73c35ea4d4fefcd992eca292f08e8b185a82181cfc2ae",
        x"2e94e9ef75f2335d45dd559cc839ed9403a6ea587ff57fdf",
        x"bcb85db8b0fcf25496cad655a9d2696a1b3706b5ae7a5cb1",
        x"6bc9e6c202439c4da62f0d57f83a7fc6c292bd0f76784b6f",
        x"4c81b52a74f2e4f21bf51ab90e13ba8ca03115314a034725",
        x"0952da7fa17ddc8b0c5df107e02446263a128afdc2c0bdfc",
        x"92fecfe48a3c425b83f5044d321c4bbec470e8b0f774e08e",
        x"528595379471b2d69647c9c050804a9536f1fd574d07a182",
        x"b2941a30a90effb1bde24df6e5046970e583b6918a7271db",
        x"157fe978e05ed9cc04ce2f949a66243b5f71db17c498863d",
        x"00b3f9d584fd364dba563c9e1a269e5dbf06e2769747663a",
        x"a5fcb670fa84ffe8e5510566c1bea817ebd09d7394de6223",
        x"5b9dc332a71337a363dfb518bb42e068dc13a186a1b88fcc",
        x"152ece0fc9e28b225a24786d370135b4dc9ff7efe5584b4f",
        x"260dce147a8543c5f4129d7cbd1f7c7fe7cd2522a57a1a28",
        x"930ff2a1acbba12e4ecd9a7fc347b5ea3ba942c2bbd569b0",
        x"12a31c778c1061f0d7a3212b41589d42b3d0c198d5fcdb28",
        x"65f1263de4c05585c127c2deb89956544d948675ef2e0b68",
        x"cc33234548ef37ecc0be95a07f286e6853b6bbc4d065dcbb",
        x"315dcf4bcba2fcaee16140abcdf54fe149c0e38d19d77a30",
        x"29b9965ff9f273f7bf960627d4839752bbdde4fefc33e993",
        x"f4b62ee5534a2ac2c87a0044b91daa084a2ad0b96bcbd398",
        x"554861d280b0b340b10c17d50f288d99eb5e3a15977bd09a",
        x"55e132d69fb349e87c86da8b8a8f68bf09254ab64a0ea8aa",
        x"211e2f0cd6fa6253c52403944fa1d8139a3c2eb8a2483f26",
        x"43bf904602c91bd6f120c809a5ced6caf05ed1e37ae761df",
        x"d3d77b83bf6d9538184d0253e032fdc7774f9e168a600558",
        x"e82618a9b106a6424b8ded1f85baf6d70e890e84200d38d0",
        x"eda3263d2de5b740c91cf2fd6dd8a7cf81b8487c4eaeaa26",
        x"06fa51769fbfafdb6e4f71a47854bc2415855ed6a02b99f5",
        x"9a41bebede2537b75ad65015a541ed4d1c0af5a58f4e5007",
        x"8ad203c36505006d639afdaa9a7cbd1e00866c5e3be967c9",
        x"65a24c42bc3d0c33f4073dd949b0ac0b84ea03751e6696db",
        x"805ef75b6d60e0984a8b932298f6fde8d7bee78d05f80f72",
        x"2a696ef6daeb54462dffbbafbac10709e08d10394c9c6e5a",
        x"73473c158488ff171e69b2c10bdd09a5ffc895f1c914e239",
        x"009e7a2f9749e52e19cf1974edba221436deab08effa992e",
        x"44bf281c7bb1869da693521bf6c88dde5d67d95d13237714",
        x"e065423d7ebe7dfd43faf162d1f83ea291daadca92832eee",
        x"dc788ac532864391c4c47e8f8d371c2937dc35f78edb67da",
        x"1cdff5b2e556237a33ad9e29a95e40c47291641a87c75848",
        x"c181c6df23e0ee3008a286d7183624c98c5d80c62a3b9231",
        x"9f7f7359d36b65555aa68c53c780ff7fea166b89e47fa756",
        x"cdc851e8c56c05fd0f594648cfe446f196bd9c6461e91c64",
        x"6c5f57e5161a7bbd42f0abf5ae6f8800da2aea67b9932581",
        x"47101fd9781f2d477b7104cf06e6731090d2fbf2eabcdcc4",
        x"bb29051a0e5dccb52d8d5cea03671eb44c517d9aa07f8073",
        x"ecc0ea1aac44d7ac787ef532cb14b309c6e1ccca25e5806e",
        x"1c292600487cfdb4684bc9ef8d19c9b0fecb621aeb47382a",
        x"73f47defba3a1eca8fa5986773a5707b88826ff2771f5ed2",
        x"2d2a01decfb6cfc426ff72f2cdc51010f551a4cb23ff617d",
        x"eb07d2ce795f06096df2d3d2d7fef16da679e9b316a24538",
        x"41e6ce9b5bf9fdd9ab928dbe5da8939177f253973ca6e166",
        x"8ac9de1391891a7281a8063b635d9228c134688a0bc8e257",
        x"2468a61d631d74f915351e8dbe4c3ff0938ea8577492fa0c",
        x"388ae312d0b2633980dce120f21e6e2d2947c8f514f96d09",
        x"f627bd8799a3f1a31a39a056cfbfd1ecabeb09d2ef353699",
        x"54c85abfc53e8a60a6e05ae290ff0b90aac62f88d8584c37",
        x"6e6ea461ca5c7b7a86c025a7b893f90db4e98cfef096ffc9",
        x"123ac975cfeab53dfd136b4756d11cf04d9a274d092de4c3",
        x"78cf4926d449c728b8c4a3f59b8b9856baa8e5bfe3187327",
        x"8e7dca0526454f869e718e8f71ba7f1d84d68d5bea097c39",
        x"632aadf0946ba41fe402700e96b4181525ea54166af3f5d2",
        x"d41a37fa719bf9ca533891236802464935d23ecde14320bb",
        x"ee7e4db3ce042127d727d98e5347c39295df4c157e744b26",
        x"c881f6160fa8ab13183103742dc6a158c438ca7c4e3d1543",
        x"178833cb3102d6ea2410b1b9467e4adfa9e15b868e74f5bb",
        x"2578997c1c6f272f5907199dcdd60cbd5b5a5a4131743819",
        x"6fce09834f6f5f7e4768609f56bd429c801902dd8c4d55e9",
        x"4c1f2845aa78b90dc78da0a850f205c02be9dcd8496b11c8",
        x"042e4656907e05dfd785b4dfe85ce690545ceda28711f435",
        x"57d1508dca00e57ed797fd7f827f99ff2ae84b4076e58de6",
        x"cdd86100e70fe7a6dfb66832ccf08c23f95aa93ee0703be6",
        x"78e9fafdabf1be8dd8d5487b83927a194b3062f5a804d657",
        x"12f30a735fe4a483ac16f1c77962b1bd15fb48cc3d5ac0c5",
        x"fc60723fea5611d60df93cba7cae281793308e2964d87031",
        x"0271d530e0db8336ac4758b7df61bf5307af7f2e1648eb35"
    );
    
    -- DUT signals
    signal clk    : std_logic := '0';
    signal rst    : std_logic;
    signal enable : std_logic;
    signal result : std_logic_vector(48 * streams - 1 downto 0);
    
    -- flag to stop simulation
    signal run : boolean := true;
    
begin
    
    -- DUT
    inst_xormix : entity work.xormix48 generic map(
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

