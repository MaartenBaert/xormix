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
        x"44142d94edb0e960818fdc17da1cd8b37f3c540b4a833079",
        x"2b907831ffc980803130b3ba8c06ac8bd30a6f0eb656cd3c",
        x"3726f583187ff2a08361d50905efa38f61967f80c6c99085",
        x"63aada424d89398a2a2614ff1fb3dc7983e5f1b06189e4ff",
        x"2c275105ae7ae54c959f360e9254e7935dc9bb5ef3d03166",
        x"5110e3d2c8a0264fbc18f7180e1b41d04b3dc53ff17507e7",
        x"956f689845014de289e1da237d399724641cb607192793ab",
        x"51a654c5942eea760031fd93a303cab154a30cb36ab16b89",
        x"72da9f6d144fd9658b6e674d82fda387ea6e561402d02a52",
        x"47c7ce476d3b854ab9d0b0229fe4a5ea7dbf98a4d3a94028",
        x"e43b9cc8b0544879ab34c6aef41b51834b15062d49de4f70",
        x"09eeefcd7b2da5649773f97bd8c03a46cfa27d9d73bf85d1",
        x"8a75da5766fc179fab3485043d4da22f30d4da5cadf2b69a",
        x"f156eb0822dc902c0e48b5248b7030dd002741e256ec6e37",
        x"15021cdbe2819b88a93eba5195693d002a31ea0fe9e54b98",
        x"8048d49c1c577d8d7a40ab3a28d69dc852948f8c9c088633",
        x"7c346b2c87f1983a6c88643d7d202e8693f27f9c42de65c0",
        x"689f6f5c28ee3999f73534bc4429c276a08fe6acb37f2933",
        x"0b257db78d449d97d69ee5dc246bd0b4553c6123a19177fe",
        x"54434ca1a2f23968709c9d41b1c5f4d4b5584fe4365d25d6",
        x"2b9016f58a2a89c15d656ce63637c509fd9287485641923c",
        x"9ab2d9ffee9848c69942e541809905609e2de379bbf595d8",
        x"1882f8c0ee1a2842e187ac8d8b77b7d7bbd0b0f75aa7c2ed",
        x"054748c4eb7e415d6e028462bbb069965cbd83652a12a942",
        x"19245dcbc3215751d16ec6e5ab9748c7ef0f855cb65cbd75",
        x"66b7af8319fe543da84a80c398a726cb7f30f4448f419b5a",
        x"6214c00b115f8618ff57d66cdeac31dbf5ae4b4608dc6cc9",
        x"ce1dde06022466112f3bb73ca98870b3d9ecd5f9e3394c92",
        x"82e75728d7a8ed663e6e8b46ab95b068084d8ddfaf8081e8",
        x"63456cc5f997a37357873d487e81c6418dfafc0eb33553de",
        x"68b5e8ba086134b9d7711523e31b382455504d0232f5d287",
        x"2c0a6a38087d993850052e921f0ad84718c496c1bbe0033e",
        x"ac6d7217b71164470578e9fd916729d0b7c3b597f603e878",
        x"946d359d88d69e8e8f30d763bd9e282233db748658c2d05c",
        x"40557a98e08ffa0ac462ee229c5e77a1d14d993aaf411da3",
        x"3ed2886b5bd6ebd6e359bf23379cf69846f4ff2f41954757",
        x"9e21d6ef9a8e240d53455ccd1d8d32ec2ac3a1e41a46289f",
        x"0fadfca6e06546ee2dcb3e7c5db51fee86cb2c34ce986ec6",
        x"a704d129ec53aeed9f5a8f71352f9f31f7ed2fb6086d0d73",
        x"b9d6827a978cd67724d97c66a0d6067d86b05b91ad14995f",
        x"141b19c3051c1f87d2be68cc74961a5e1ef985dc00bfb360",
        x"20d283f16210f3ce01709d9f7b1f36f3e8fe2a4f8387d5d9",
        x"6572508552fe09c45c799d798afc0868f690ea2e4074eef6",
        x"39093611bfa66cc6624c0979ef3b7ea38809ace3132298ad",
        x"48212bafa3f260cf9cc470ccb446785f94ae56e59472dd6a",
        x"18bc0f72fac13b594765f8c8a94b2078a001e9fde7114653",
        x"00beb6650e4d0125455c3efd853df2ad02c52babb39069b2",
        x"24c8d2e7c6b12c9e51534cf16edc61204ef2fabd9b428803",
        x"9cdcb7d4f10afc11d49ca4206969ab255af4c286beda47e2",
        x"d30e6b70ac907ac0681dac93d382510db62cff4d7c60452a",
        x"695207eb99d4139e768bfb85ec9b87d09dfda36b9a5b3366",
        x"37caf25090f70f32ce1e6819280bda91be0628d20090c438",
        x"b501352a37ccc7b820038382ac5bb6823bb09d77f753398e",
        x"054a4e452536165445b470638147623c8ab160e1fab7847c",
        x"9bc4aa0ffffd740c009f1b4fcdebb9974a61a9c03789cbfb",
        x"1ee3bf4f094ef5d8b347851c0de4e19e74c75d14effe4c64",
        x"9737fd02852aa1c128a01ea311bf39f23c9fb26c375e8659",
        x"7510c130a8108ddda43280971e0d58d2b48be4e1439e9bf4",
        x"ae70db176e6d4e17cba1dd426ed27bd97861821515c9d143",
        x"a1ac086617c7b8bda24a9cf8f50844dd186d67912c07dff5",
        x"7d73e6e36ec140bb9741ba5553b0977a514e9c0abe3008f4",
        x"f1c0a72e628994ea09324bf4af24a63cc053ce067bf1f3d4",
        x"0e617aebc7310e8598d148ec9f999bf2bfe166ced52b8754",
        x"d522b8b661ce93afae89bedf2893449166e647186815ae1a",
        x"d99788b31f907a40990336b52b80dfd339f9bac25235177e",
        x"f66506a73206613110f66210ad86b40727096ce051e959ad",
        x"a2b6fabeb045fabe24c03cea14a726c1a69861b464f0145d",
        x"52eddc83d81a8b8a1062262f3e1364376ec31b7538e985da",
        x"7615b705b89098d00ebe3f832fe1e3727c7d9491e58bf593",
        x"9de8da65397cb44622ee6f6b2e911961c8e98a7f757d23a6",
        x"fe625685a3d0bac733061047c0e419766de434c9849691d0",
        x"905dafa714266f0a23522bb9cf5f1953fee13562e8d03ae6",
        x"41a039bdb2d586841ed6cc204191e811cbffa8c12ee5c2bc",
        x"6e58cbe0cf4557dccc89b1d94f65ad728f323eb2341068a2",
        x"270335a717457b908fb4a5f5d4f8fce77b6be26a0a8dcd4c",
        x"925e418b28e93bbc128a0b8b9e863db9d873a34a47d649cb",
        x"13f4c2ae18bee312fd05d09b9ea2d18c19422203acd768b9",
        x"5de4b142eb6a8c5a5dff3c50663ad9d2d17fcdb0d4d23252",
        x"6d14be27b59c70e617c88f91881d8e04129428067ec583d5",
        x"6f54f97221f9e7788eadc29b5179ae96e3ce0ae7d1fdf48c",
        x"b3b15ec331c57567e75917dc5516d6ff9cd234abbdce3d2d",
        x"6aa13a0ccd6d0dde21ca537fc7a930cb98e8f5b2da0fec13",
        x"66e542c30cddb2c523a6c82b2fb0bd94661190b2f6f237a0",
        x"a496c117ea3d7d4d28b03440795e7b11ddaec740ddb1ab2b",
        x"7d7084a6e5be57cb625bd2427193355f5512a9690bc0a210",
        x"67ca5b6969296970c9c919db3f4b4843af4432ba0b024fed",
        x"e39df50ec670100b629d98b0e331eafd402a7f83089e7aaf",
        x"a300436acca2edcf90fa12cb7c945eb8d11d052df4c4d3ee",
        x"05de28d409952f70344b2cb9014c542e31947bd7e8f3702c",
        x"f8f363881a3cc8df505968fbb46a53dc75e58cfff7d28fe3",
        x"52386a14ded95ba98e9c5e81ba47a32adc329eb160dff2f9",
        x"3ced032f60d21a5ad7f106693565c79fda28de38e7c02961",
        x"3291856188346741e6d7c31ee13b929be137da6adc2970e9",
        x"2c15bc0108168793dda498c6a8749c5dea1ea536b11da4dd",
        x"c1b929ee97cf8e031e428ed5168ad7ede2c4e0fcc641834a",
        x"f9a45068fe49e3bb046b4a212d00beb495f1ab5eea8032ad",
        x"aa1e5cad4878d0b7f6a41aa54c0d8de1a5b562951950c06c",
        x"805c96a4da9e1c23d22f1a034865040af5bd289a0ce00489"
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

