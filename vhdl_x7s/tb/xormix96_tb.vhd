-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl.py`.

library ieee;
use ieee.std_logic_1164.all;

entity xormix96_tb is
end xormix96_tb;

architecture bhv of xormix96_tb is
    
    -- configuration
    constant streams : integer := 4;
    constant results : integer := 100;
    constant seed_x  : std_logic_vector(95 downto 0) :=
        x"68c05428e4e09ee89b1b9fca";
    constant seed_y  : std_logic_vector(96 * streams - 1 downto 0) :=
        x"f7befce70ccd49dca6f5461a529e8bde2140bcd0ca1a0aa95bc17792ed7859048b5534034dc9848ca5d58940c44a8a4b";
    
    -- reference result
    type result_array_t is array(0 to results - 1) of std_logic_vector(96 * streams - 1 downto 0);
    signal ref_result : result_array_t := (
        x"f7befce70ccd49dca6f5461a529e8bde2140bcd0ca1a0aa95bc17792ed7859048b5534034dc9848ca5d58940c44a8a4b",
        x"7993775a3148a7ccb699e2e927c021670f4190c4a6085643f610ceb9f33854e99483129e996e188c89c509f91626c3df",
        x"698b4872e44a8213e82af61f83a5daca74f5ae7bef42f4fcf92aacf831bb382292da1e5e001caf4d4e3a13b33bbce643",
        x"c88dce43ed54376739546e89d2da1f877cb0f6738516554d666b2807880efbbd1ce39c42eccf101ad1ef0a5bfee33408",
        x"0e0b4f76d102a80f9c4b1406cc15237a4ea648d10aceb5df5f71122a03145991a515055d8b9024df6acf312be27bdb35",
        x"ad82f616f4cf15948d5cc8b5a9ca13e13645977b0f0fb5e2285204459ee75342b05db4b3ba7b41cd9af3e63c9dbdce17",
        x"c76a20aba3a6406933af5da08f7b335329ecd90d5813f85a5a3c0d5ceec26a27873c892450b555985e26be41e5c5c0d3",
        x"d41dc05d2ac423f7d522b31268d2cc2898c32b837dacbb5346c49a26561e8d987816fe1a8b562d22a2dbcc1bba734ba0",
        x"6c95ead5a8a171bd2cc9c7147ca0c3082e53d34292d01c78106ed67942c4253cc5eafa0bb94df4cfec942e9c46ebf73a",
        x"d49528034bc4ce9c36dd1e5b26f04470d4e0129302b4a83b0a7c79deb06f3e0d70c05f6d5312ce0c88dee3f09e35437f",
        x"6762f0203edfd7b023941fffa4cbba2c67fb0f39739c4d5069958d567463e55322fb35519e65518b20e42d21a096ce5a",
        x"7afca73a910df0d1bb51c6a58bcc53889b8bc27bb07f7fcdb014bc79b639353447607e3ead77aaefe2a817b4aa8c0c4d",
        x"8cee099096cb183368fe14332a1cbef6848292836633557305985ca6d7d3ec715ae31c8a8467e8e00e74bad1110621b1",
        x"6b8906a2c4c80592d62a8cfdb8c097ec347d1dbed5fcdc4d4e4fd3dcf3fea5aa2369dfca04b9d76dc7fe86b0414f2f86",
        x"18f127e1b0eefb68ef5f36dbc42dc4f23a5f0dd7624f225a9e9abbb46b094dd552a71be53ae92f4d2d17f85bbc4b8d21",
        x"9db8fdcf0a2abd6ff40754e27658216c8d8e6a70b6ed1cf76d9ee6eb8dd6e66383ac5f6b86a5da1061942e170cf8d511",
        x"78b9f11496dc369e00195ce649018e4ff0187207bde642565597e022b45cf16dae6f27bf44df2934e73e17532ec86661",
        x"c035fc63e865349d05457e6c3a68e4036e5bee078dab8af8535cbb8341dc3cba3c2c15fd7611ece7a8dd6521023c992c",
        x"6b8cceb766cd913e59e46e073f2444ee98f2039f70aa21a217efa864e929a19a704c3338d2d36ec73bf4946837145e50",
        x"590a423f038e4e8a1e79e9b2ad9173d664af47e049ead3aac4d4978916c6429f4ee9fbad5c43d40a471c91fa817e78c8",
        x"b7ffa183265fca71bc66106a55d4f8038a0bb69b566130a012112e9ac73bdfd4f41b831b97fd261938bf6aeba5aa93fd",
        x"60b9b99a910ddecbc3f3fdec4610437e4c8bf859c0e818fbac238a5a69db6cba2237a9690b84a36e3f17a88e1682ecc2",
        x"be3d94aa66c912965e8e71ae9483ded376f66c0d4dc1e145dbfb1ce34a915d6a2530b02d580994ad6fabcf6923f58d09",
        x"28f161469384c39c3670c1305b0628684c688ace1a7619779d641d9663c0742d84c5ba50d360e9ce8e46458f86e0b5a1",
        x"ccf97c8404000a89c530fc47a679de77f37ceb997025ca7da843efb2a23baff28454bff9d0f72dc25c1a6b1a3c30d02b",
        x"46c9f65f3aa120e7bfb30a906926f13080b30045800c62b00300bbbef9ee9f9da403fe5f7c25280e1c6f522d3f08573f",
        x"a31db6497459f7309b9080527ec74c9bc6cace9b7f592a6df2ffa56034a9296e9814fbd49f5c32ce94bdcf341b4d9a0f",
        x"ac99d78df830a7b0546247f33a4d79946cca1b8f697d4187af6b7b03bfe67074ed1859a7438931039e2869e5ab8dbbd5",
        x"4e8db7a38ce42e21f310b8cd754b50d8547272d2712462e343e12b0317a8e600a10b730c3941d30bd25bae8a866225d2",
        x"8d8f3f159c70d86ee221c828804e8e0a1b040777dfa92fb181db0e4c7ce9113681d5925bd53f455845f55e2415adb475",
        x"b45439dae3a94e4ee6d724dcc046fc81c4342a4a4a90684f944c5b88c9c6a04e576ab215b055150155409ce55b805650",
        x"f3031b164a40b0b92391a812e21466d66739b2e203343faff9735047931f0562911f21ffa6909d39483b668112535aa9",
        x"c5f518809e9064395eb891d859bb40c7cbb67b2a262541458cd914794b6560b6908a683d624c5615aa19db3e3cc2c383",
        x"b2502c5c964061eb84fcc6de037cd5d1f9b387603027205de49c20784d4aee798aa338da03e10b99d47de2ba5158d057",
        x"1554b383fe4550f7e4a9395d5c46c5bb19b372168525a05f83e4398fa5e061c3d9b134508318ed5a45aab9ae2469b3e8",
        x"f7073531d846e2946138e2adf3ce45f5ab5d55b48f8321ab9c405a3a718b0bd14580dca61104e641c173d4f829958aae",
        x"b2512309b1f425ef780734efea33fb746d77f861871460d0eb857d48c2f73d3f4ab11faeb5cc8a615e335e26c4622f1a",
        x"1e8b0cfd0f8f7ea4fadbab2fa009f347dc76aa1667919d63fb18f170a894f40236f04eac8f2e01deb918f5defcbf7422",
        x"c4518f704bbd215c0069dc25bba504492fd32a734eacf7d540f0c5bebd3f3f96f01f636e4c8f001bfeb5135c9beab385",
        x"538007e396441c018065adfa486531fc46514d00d8b7e9c37c703ee79d3d1f5b5592c5054763b6946152a79604058d99",
        x"71835298673e5c5968ddb371f051c46064fded41a3a1571553e10790cd87b07d4e6af48d7f30cd24c6dbaf083380a3e4",
        x"b2b38adcc805d2c6870f579ea69b422e63f29fa830e079d32cfa4b711bbf53151ead034c41deeddb347f08207c7dbcc1",
        x"234b5d620e879aa24b6d0d10c9445cd7843394d2bc080c94bc8f7f9604b297c9d9efbab5ded1d4afe7912c038a956375",
        x"d4af208d195640cb7512081c282585761c1afc979724cb091da324ae41d14e066178e27a4036bdaaa7e4379c17e99e0d",
        x"a60d732a9aab9f21e44d333ee5881ccd5eeb264f288cccc5c8b229585339e79cc3ca267360ccd58b6d704fb812b94248",
        x"037ccb9b45301bb5aa1a83e640bf5edd0c3180c62728b361139cd1514ea29d00b57356ea103ab3d9fadbc9c1c1b2cc28",
        x"f30eee577e2816f931248002ace48459b188e60a28b4ae9118d95946ecfae9806d6f96c1e79f8af13cb2e34765ed4b11",
        x"fb725658fe212f79dabcb39e9eb7ba669282f006fe91765370e4895a03f855667a89e64baea444848d2d204bab7a2630",
        x"1be1ae884045efeabd03c33d76c9eaa53d97f7eefc895bfeeb6c9aee9ed4e4d0cb95f102c46588e93f50449f17f9798c",
        x"5d30223ac5bfa48bae5042306a270f053d6a3bd9540729dfdf233a8cd61968bbf6d653a483c3d73fc82d33619338bf66",
        x"666d47e2a20f43a22f127081ca7a27838746e4a9067f6f69c2efedf7dbe2be18e18a50a6e5588a1d36fd1271b990360e",
        x"8d23ed0061ff43386e28e7ca8456aed67a03e7d98e5f643eb9ded51b808b970fc3bff5d4f26bd8b2015fbecd16b9617b",
        x"a5794183012f2d8b1324fadb350c438f919eeb055624d6556061486d33a3e47335c255c9d34d4ef1938fdababebec164",
        x"44ce131345de7141ce8376a248e9d93f647b73dba9af0b9de130fedf2343b3da8559e0b6fb6fef4c5db7362611984938",
        x"1176f242e16a553ee2182954d1a098b5d311995888c054079e28e543822c9edfd44ac08c4944312a6944d2efaf4aea59",
        x"2e0450e78795850b502ff48b75558e875f924f5941a5dbf007a29d984b24858f47d1fd1dd927d3fb477b4161a81aae8d",
        x"eaa99e0dfc7f874e39b70e9eeffeb662bbef6a78508fca6bf3562bebf93765a66efdc304094f2710c3851cd9a033bcd5",
        x"db7a565a8017e09b429adb9554033a2727cff3836cb5e1fc30fcf2e3ceeffa3dadc48d92a0459442db41142c2bf56e52",
        x"25b068bbcfd36b6f87f4e3be03bf5155ee5a5046ce34b11316b351639052b73b52865b0d2c3cd5370c3f7d0c6e469d7e",
        x"52a0da48a9b9d5dbad309f477dee099c45ab7c2e61d58413e3e9e2d868546fa72b8bef7f684424019e169350135c50b5",
        x"b2ef30a4dd9c755302482cf1dc15057d0234b7bf5c38c96ac9d28544828bbf72d6ab5b0dfe6e648c74ce397690148cca",
        x"4aa01afaaa13742cb82f8023b600414ecfb9d3ff174481736a39a063a3e2f369ddbebb104c90e67380bfaa85b3615db0",
        x"3ded50fb7d9454c6d0c8e8a8f4498b805b1fb2540427d6f044c83cdfc04ff584424c5cf8db4d776f4e628ef31fff0285",
        x"d032e22c672090206e44f6955eea906a92dd0bca38a3843dd51866f1ab36bddeef82fbd49c825110e1d3d835b66d352a",
        x"e38f46125f94c262d242159287e282e58d4b6fd0a18ddd7b288221e87bb8a4f7cbe7333d8bede42a48cd225881ab9e16",
        x"176ba91096763995268b349ba7aa9fd9a56f9183068e4ac5d742e40d8a2b72563086389a1b3edce4ec445e793f9235d8",
        x"30ec6adfe5467a783dca4c9ad74d93e64b2e6a3b1d4960016b83032364ee0063f2c99a9eeac3e755c7ce1f9ba4a96b86",
        x"846726d5d42a3cc21bf73082f44eea16124ee8dd293f5658ffd3ca09b3ce47a5dc4c8593744b6a16e59b63f9639ed810",
        x"cd88bdc596c97c44772848ce1c9d4c73b83fcd4ed1e00079eda39acbae7857840be4c9044442fe8cdb90689016de3cd3",
        x"aadd8379878d4b110223aae826b59e6bd2e32083b11d3729acccf2914f71e0ead9808eb0ed7e48384ebb4e062ffbe552",
        x"47ed8e80bf7dd30e6efbe34b8d76b1a4b715098fd368f92b477700509da8f1b0462794ebbc23c9865deae18708d576a7",
        x"b4fa4555c58d02cb5f210a38a3d10d50c3d57a69387361d97b2b4cfd113893459847a5d13b2faf20efcfe6555b2ed25e",
        x"6ffaf067cff6920223c9da3df05ca913e3e9093d9f046f0cf34e1afee9217d138abe906ddfc2fac6909145772cb3edee",
        x"5983847e95e666b89fe19450e7f77ece60df5b5da866bca5eb950262650824f2fcafa574f996d9d260882865cfaa77b5",
        x"8ab3122949462a64d23d757f7c80e31295a11ca09afb0cd4feb11fdccd0b40eab7cdc61191d604221817fc536851556a",
        x"cd068b0900032e987eb577a945313d3d07f944dfe307183501edd0971fbe32c48faab63fa4018806feab4653705faa39",
        x"03b6e2b53a8e4a42051aa4e30fe678ae2e8a675bf255cf6483dce31e6a47ed81aa8a16dc3c604c7956176a82631fef58",
        x"6db3a03487a5b995b0dc1f517e6bc0b8a24fcc2f53c184743ee2dd224d5f8f0b25cc0b3044b2b99465147cdcb282a567",
        x"576ae877d3758750d32bc4d9d4829a021953535f996612bb759652e17a5576bdaea1da5bbefe1d55188b48a2e5a0cd47",
        x"aff634d4e1e84fae03642177170d266682fdf1cf3dbd8be046182f19639465af5c167be1a1dd32a9530e91487d81663b",
        x"99695334dc3ba962b9d331f744e7af6a8bd01af84d04ecefdc8ea060ff2fffa625478247ff0cd09e89e1b3929b46144b",
        x"8de69829398be1866cc819b776f71b34d9ac8d48402e85dde05c39386461addd05d990f28b79c11dd33b4e1fbb60051d",
        x"23fd9626cddaff8c31e17b06f14df1f3b89a8e2cb7988b97e4d86f3d015d64ba43a05010ae6148108dbbd00b92013132",
        x"67fe3aac35f847acbb646aa50e9fa742e044002e60993a8eae00551af93a6a7ce20e1cab359462e3e2c450bb0a6ed9a5",
        x"8159ef589231f12438f53de41f7dc3c70976afa5e38ece0ba9c0ad55bee56cfc9953de3d4bd0dcc421e4c687f2f5a12c",
        x"9cf040ec00d2f526ea1064de87e89b923e23a1ede82b88e7f1445e2b78affe6a5cc62bcba30ac7033ab7d189e23a0871",
        x"cc29d90f2c33ef329c137b416caf645c27acdbceb3caf2bb4ade41a1c320f63e65148acc1732584b8128b90b11d3ca67",
        x"bff3306faa737f1b9b628f5c577af331cf8180e9e137810693834560c911e8413b11d5ac770b0951139247a145595746",
        x"8f2050e137073eb98694924d54975bf19e360da3119c8dc32b7df3696273759430aa5bdf2a88dafa896feafbabd15ddf",
        x"2def0320df9469d7e1b1d60b8a7dbddd9a5017f56ebf27d9fad34ed37add58ed4e97b2412c53f02b8ef0df4042dd4710",
        x"bfeb7be44711beff9f387cf0e3e999879d98db78acb5e91bae814123aea2681ca71c5c784bbd990bddf11aadae0e86ff",
        x"ce04048e7a48a2383eb1b90f89a473d7c1baec254d127eafe0e857ce4b67adcf93dd6cbb542215918e6e23afc32973e8",
        x"c8cb904a46a11a6f3fca7fe5ca3787e07122103bad011e8a79bee65425dbb7eab21bab57d29b0492b79a3231b8417082",
        x"218bd681d44c3e28c92a529c3a6a5dc326a900015e2c5a347064186171e11b626c1b373e55d3e431654efbf9af1cdb6c",
        x"9fab272403e54bc92ff5bb599d1be9c30ac7ad4dbf3e6c3ade81da33b5ef2947aca4e241b11c83fae0d52d309aa070d8",
        x"12e18f1ec022887623c021ebc55f8468b19945f56e697e7efba8bb0c178b20f4d7caf2361b7ff9cb992dff9ed6cefc29",
        x"b1b979b552b7e7afff6d39ac3deeddaacc15a43f39fa16b98bc2f1b396e84204ebee4a7edef83c0264f8dc7062a5c70c",
        x"bc4abd135dccc0646339bfc4166d8ecb82793f05066c11ad48be7e3d651119de6b04783d318087db73442886026fd9b7",
        x"896685b20ae9e2d654a7ddb109173900cba37709f2311f7eaeace1a69b073073109f277465c656d699ce1b069cab8290",
        x"3835376f9f69297b39fe2503b3f7bdb93bf354bb7ca1badba61f768665b918a37dd49b9ccf41d06610c1f972d0e40d16"
    );
    
    -- DUT signals
    signal clk    : std_logic := '0';
    signal rst    : std_logic;
    signal enable : std_logic;
    signal result : std_logic_vector(96 * streams - 1 downto 0);
    
    -- flag to stop simulation
    signal run : boolean := true;
    
begin
    
    -- DUT
    inst_xormix : entity work.xormix96_x7s generic map(
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
