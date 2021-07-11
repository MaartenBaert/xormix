// Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
// Available under the MIT License - see LICENSE.txt for details.

// This file was generated by `generate_verilog.py`.

`timescale 1ns/1ps

module xormix96_tb;
    
    // configuration
    localparam streams = 4;
    localparam results = 100;
    localparam [95 : 0] seed_x =
        96'h68c05428e4e09ee89b1b9fca;
    localparam [96 * streams - 1 : 0] seed_y =
        384'hf7befce70ccd49dca6f5461a529e8bde2140bcd0ca1a0aa95bc17792ed7859048b5534034dc9848ca5d58940c44a8a4b;
    
    // reference result
    localparam [96 * streams * results - 1 : 0] ref_result = {
        384'hc80b197649cb7b3f1f3675641815fbdf725ee910fe20cb34e5e77103e697c7f7ec7f081a5c87bbf7f62ba27625432a3d,
        384'h736bbf27d95c5900776989aab2bf695986002e4f0eccdb33789811591edd2098ab84782002d52d5f23a4f7c2a098098e,
        384'h023f7f0e099296fd2390a67bb4f7fa111bced566fd28b3d530bbde235d46009b68510046de5723754efb0933da1d8fc5,
        384'h8460e65fc1553c9d5bd0fb4d8e5bea0c6029d59364e2c3446b1f1c1ba07ea703c46b24534143297762524fa61ebbff44,
        384'hb7ce71865cf43e68eb55cc918e9b13f94009ec59829f8140a21184fa19d62a4eeb11c64ad29157467857fa1d5d81acda,
        384'h28d959a5cd98002fc2f78f5db9a0c8ef4f9317b22f617e53c69298567d9840a91a286e8fe5186afca002944d4cec8303,
        384'h484509bdfa0eb941f1f53daa09de9c1524f62bfec98cc12a225aa43d487be46802c98c99266a5941f58e18c5f59bd011,
        384'hb5c839b4a4854b892c371cec7b22526bf39bae8cb9908f5955c0f34329cf02215f7a01d7f8fd5cef92376ad57ad041f5,
        384'hc7a3e79b55ecb498814efaa6dec7bcd822c2ccf22d6475d3533acb988895d5254e72b4fa8464e765ab4d6e1acb3feb7a,
        384'h9a5cd84af09d923d924c2a281683a2de88db53be0e5ae2ff726d92d71e1a4831b5277fe9463ec0d66e3a6be4e68d6ef4,
        384'h887e8771041325bc351b0b0f3643f2be74814762aa404521428b53909e89c87a6ea3a883a39d67477e92ba22b4980794,
        384'h6771fd524ec75f852a37f0419d9e7696eb6aa25aec60db25b5322873bcbb193f4a6f8838f3de720b1f0dab6b3ce9ce59,
        384'he8021fccfa6b5eae7553c6da051fc4a9910416d67f69598a565e76834eecfe67bfc3f044763a373ccdbfd09de547f703,
        384'h5e79ea34237b548d9ec90db89fb1c4378c54a58d263dd43c291e96a258c738d1db4dbfcf0ba875c27b7741c91b67b2f2,
        384'he243ad1b2b92b85622bf163892adf08d4519710b0f0d8d88d823fd3c4201124b810d5e2cc37870bf631d044fc5b2c062,
        384'had5700a0eafc94f6de1c29a69f2e0f3ef81f552dddcb5b2908f6ad9db36a14b841f8a5b661ba41810a51bbcc15c84278,
        384'he0b87ebe97abb58e069bcf715147f82b1141d271317409a3254f06fc55bf999050521ac679550cc3a3ac725376265e8c,
        384'h33d3ff4d6739ae2d2e2f84e1648591a4ae3d82cf8050423443b5ecc9ee6a5522edfda5ae3bcaf01b1f628f4203bcea14,
        384'h49dcedc6aa47863d61cbfff6870ad5b230e84ed88c0928a29245a23274bb549b30e12edccbe2609da0ef5ed0d00e7613,
        384'hda2af73bd680c10c503248731f277ed283c6abebf10c24e56e9a0ae0692886618ef295d107d917a8e8f0c128a1958701,
        384'h5161a7d1dd8323b0eef18c1eb9cd8c803fce83e3872221f054f21a169c8a876747bd0de2d2c3ee71d29f8c60b16900c1,
        384'ha6e795b06f711ad7cba0475ff8e0a9709e24bd6316f92363abbf5cf421bb49a4ab728581f6eb376d6ff285603bafaf42,
        384'hb35067d0f6b2e421f4790e66665b5624dccd272b100141ddb672154db6af3fbaef6763e72951d4c6a27c3912ba4d35aa,
        384'hc85d0a31a96d1470a1cc150873c068fddcfb498572b66e9357f79fee7452a04984ee38e9c30218d017285e2573198651,
        384'h1d2471f3d66ba3bf23b9df803861fb3742fcbecb3c03012c37f7529dc20eda2136ed53c6a600bcf13444777c4f3f79e0,
        384'h15167c0632348ee90acabe49b5f280dd6079a807fb8bc1f11a4d63d915fcc48c16fc47f5fa61c6de7a37c7c50180bbf9,
        384'hbf567859ecdb777a9aa7dae1e5dd70e152d003a03cf439e9000536794584ca6a0cf808196099ad4ff04fd99f96bccb49,
        384'ha83ab5f02ad3855e5628b6ddabe0ad841df71da849bb6ace611d96819b7fc4a6b5df5309ebd8fe76e5dd379f1a4d5cf6,
        384'h3ea4e4d26e1b407fa6caebc932e5b556557963d58b521650b633d296e99a99418e4e13143bc87773496618b3027d4eb4,
        384'hcb3ee7b8ababb788c057e786377ceda1ac3dfc437a78ea40ed16a1afc3c384d2baf9434bf1e101c709623e9a45063fd5,
        384'hceb51888158399625dc45f6eefaa0b1057060bbd1739bac033cac51d45ce3c6f8e166b35b6990ed4992bfd308e25978d,
        384'h59f87414325b0c64393b13e8b8a9d1c5b80cf57dce4d83ec74a1e6f06d19a0e72a4d668b7dc59366125d35fe6fd25643,
        384'hee23b4bbb10a6ad96a5d5a497fbcd9a7412b372dae5dc50117a530fbce122f7375a861dbede1cf5add80c3e523d306a3,
        384'h648e3241769f0ce03d252d77e1b387810e6abe880d5b4ee6bab5f4cdcc135d32f1cff0f4510e91d030c08bf54d7d0078,
        384'h6ce3a0e5aee5f89bc46876c701925d768b27a85b93f60e9bad9eb17ae000a64dc945e48981f7e70a3fe389cd8d3c5653,
        384'h42b74b09687674fb0e63b3831aaac9a48732c3dca5542ab9fbf5a92c935adeb037421ef1f6e55a115b67474b8e8a47c3,
        384'hecbe6800778ec289f6c2c54a222393529dc0b7f54b6318a13a942c246e008726006baefbb655c0e993d32960d9c13398,
        384'h0d7136517d3548f36e3f8de5e69e3743c74c8bc65e173164d673503b3d8d1a272049bd09542fcfe326ec878de4ccfa90,
        384'h663d84a6ba823d37e95d556f5f565455fc6f78868b3d23321878aa36d6ae72778bfdbafd7bed29d0c938a69aaaf3a96f,
        384'h661f0a0a9b6c41a552ed055570d40d410692cbd49743fbdcb7a9876448460c60a02688cd2fd1ae52c6fed67d25d1a686,
        384'hb90246b43faa0d05c3fdfa7c18e096c3a73c8ccba47a4925634a316750230e1b89eaa6071c543a9b91b3a699dfe738d4,
        384'hb02e21fffa45c8f5147843060cb520cc88929db22a2691f79113e1b6f04e9a6680a958c7f2feee77cb8e180c4c21ba3c,
        384'hb3933e381ab74071a51ebcc2cebed198a76545e79ed2c0e4918b7e9bd19d35e756fd78dfd1ff853efba3133e8c2d33c7,
        384'hf579a80e062f388d9764fbb63f75b165fe9da9a5e54ec7a770f95645ed5b719caee740c8b2881f864f275f1331bc248f,
        384'h748deb0d0e188ee4866627c3af87a99a03f3c7b45331f8acc025d63fc6508dc6d15547234798434f26713536022fce40,
        384'h3be3269446f71efafb84117cb6776a2c37340227108a62d34f1422dddc2687531002606040f55c99e1b8718f589b47a2,
        384'hc7dbc33228fed5037336ed50977f3a6f7208241f84a1f6be025d58b8643f46f2484a6c211980413a2b5ec4944e3adc7f,
        384'h8aeebb92372671d4026ff27473faeb611a2841fe1cb8c00c724dafff929de267bb14d15deaefbb086125eb22ef399637,
        384'h0918de08c6da40b09176058477cbe296671b86ae42eb5f9fb4a26c7377e98949cd53e28dcddf8b9ce4a80a309ab60f0b,
        384'h4d05f7f798444661381c7ef438cf670caf22a00fd7ff2cf7021bb1e730a40e4d0452453ebc834f075ec7e1964c7f5ae3,
        384'h834e6c3ea6f0bbc3d9cc88507219f274934495d58a5952e12013a5fb6ae8bfe831a49082f5c834784979fc3fb6796c6a,
        384'h1fac67cba5274f4f9f02e82a5cc3d0edc287a1f5f40458d28b5a6d5dd51529839db634e4032a5fb31980416bbfaf671a,
        384'h1f78c5a3e49a55e394d79a0b34c4479c9724255e1f1fb9d906ab5a591e2e1ec0edd5979fec375d35673e3543765f51a5,
        384'h8f6c571545b9f9b1e41aeab49f1e01d766a59d272bf72e0b7e90d387e1e83ae3515dd6d07473a1627c00447b09ba576f,
        384'hda3cf33a7a828f4914f98cdd2db00662259a4a6c9c06b6d2d8b8677c063b03cc402bd31a809c7e7a7d40b2b96667eb86,
        384'h7fc312c485ccf9a7fac609fb1c2db22ccb5f98b7ca29e8017add20a4afa6069d28ec1c828a5fcf48f0ba2f5236a7d32f,
        384'h94bd7fcc029229c22a1b5b4161faeffe42c01aebeeb0b6a23ba2730bd6071be8089bf70242c685bd693a05f46c9d16e9,
        384'hed7db32b1486e1ea31f3f083b09ec6901c6108d2c67022bab49685b08a87a032ffd18d79d7ab7b0b27d43cae1c06ed59,
        384'h2df887fde4f6d2e49dc00caceda6f7db5f66c88a147abc4ab4fc6177191903fe306c9fe628640f75cac23b80d1929380,
        384'he1346a2bef4ce4e8377e62edcc56272db9f3e3fc34e0f4edd075e1882b3cd12969a8e6a7c8add6f1a8c2e2c1c79be976,
        384'h43494137e7d3619c6104d3aebae10d0ab4cc5c07b9d0359710ea64a086b9b4b2ac6f3560a5108acb63ab19414e5420b4,
        384'hf04f1c0ee8fa78b496fcb88644869ff60473d6de308f777291dbae76d546e93cdf19e606ffd7741544005f8ce9a7c482,
        384'h89c6e978b005d2a5ecb3d641e0e019e88662c5c67a566a8a22472dc28707f9c1c235fef666385193de2f2387dbe71692,
        384'h24eddc7248820ed744ebe6e550787fb541fbc39d163e74c891a5afadf363341e48005eafb476043b4fdbe91239486620,
        384'h99940b89fde5d80eec7e1dbeafc39d60278b1a7ee1e77e3f8af1cd7958df40e907ccfb658beaa24fef8be00145928c2d,
        384'h96b689578f2df6ed5ef3616d185a7bfd9af00d2f346cc46622686eab2a7328c6c6349fbe7cdc7224a9d26fbe3c285c4b,
        384'h44ed87b0306c419425c0514d90fc4a79d99ed462c0966477c616c32da9f9d27608ffc7f32f858198a63d39d3122d1c6f,
        384'h0c2f22ee37d99ac198cf6d546a4e2f909c19d3e765ae4165aef25785e5a7659c870afd973b1bb40f9299729ed5220375,
        384'h08764bcf4ac88204b6a7607a36518058676b5d909d50339f98aafdb872f9ff423a51b6f0d6bafb0dbf334b17bb9cd92a,
        384'hb76abecacdc3f20c65305ea46860c95b920db85b621e6fb4e4ba0c0716cb996bf09e21fdfa0b41317eb8dc9c92205d7d,
        384'h8e7e630e79fbc5859c0591923eb5503747e3a48bbbea640a6c464c25b73b93953f4e060f9feae897181d388667fdaed3,
        384'hf39e13cd5c3953671892ca66ef3dd5fbe1fad8413e23e181ba98c67392e0b1f8ea5d4997e3fb62ce6a79ef4610497ba9,
        384'hb35b641580145297a283442795524758f0a9223869df1e9c859ea0533f002f6b49af79d4a9b76d65b85c749f025a98be,
        384'hdd489a9c7a5cde98bed92fc00f26aec2de6bc9aa33486de69ca70482690ef8864970470ef891f5d51abeb8847087725a,
        384'hb9470441a1a59d6c5506f0471c5d5d73232ef543b476056c32becfdab9e838a62a62e8797bf5f9e526a27d223a3db9da,
        384'hf781686d4b214e189b25b68a1b462f9a9ee101c32da71323de65a0b181e10ca1162fd871c3614c630f4fab7ee6d651c8,
        384'h5a9e437abcdc7bd3caf5a410b494219b3526884076c345ffa655224f70afb9d6b74a9f70990b434ce24dba4a6659fd68,
        384'he2580349a11952812b160a0f555ccc7985429866a644e3b111bee9621f8b3fe3deeefdcb5cafb75264da054b9f2a1f9e,
        384'hd7eafba480fba1385f0fdc5459570c1d5261a78c8cd3d71baa15afd67063a93a55ec9ff8f2e426732d106a5d50a9e0e3,
        384'h2f5326e04d7d7e700ff9803fc756a16aa494d0f93abc81debce480ac4bf1d9e73c7a619b63fb3fda9433f04be022a243,
        384'h078dfb85ef888a5618587df44580626e705470131c6fe57ec68258f45ed714b242306e2510383e6c2cfe1c14fd9bb2d2,
        384'haa271e0e0828ed9a6a856e8c808a28b4a2c68087a38fb6231a0f8b1c51ffb8142633ffb38b07d0907810f3afe75ff5b1,
        384'h8a439e406f53448e23763642668b93876090a553707053e9151b709965c5a63aa38c22cbb3dbec5a21b0d3985af6548e,
        384'h370cabf81e73870fb253032973bd19b8b89b6dcc7ef18b8a34ec31d7f0f2103a2ce3ec504be1d44d71b8bc740ce1016c,
        384'h6439c2d2b876a211cfeee45c4a74cb360ebca36bbd790ec1d3608fcbaf24b5bbac299774b0162f99fef1f101e6dc163d,
        384'h03d7f96a27facf52504014632537010c02fc297136e62d589482529fde81943794371fa22d793b5f634afefb6b9acc51,
        384'h1be983dd52704d3d7e676d5a6641ee2a966724b418770c4987a01fa72141c27d41115b361bb1505600de41feb384ddf6,
        384'ha6aa9d988aa6bec474ca0aad08f95bbd250c05e7e4fb2edc5539704de4d3b64373c542cf92bb76c224dfbf8b5df34f8e,
        384'hbff200664351581b8a6d5acb01737bf1cbf86dbaa6c0de27d9813b51309b6e9c41f43f51428e2b9323371a0c17ac174a,
        384'h9c6ac8337363477657d288c280b324fe776e0cef9a9e4de2130604a65de8ebf26e8116140601e5bccba4e280dd7c21a6,
        384'h41e59ee499065ec8648f90290b9e75a9aab19e8047b5d397434dc76a04c028a9baa6f1cd34aead3f72ddc468a19eb210,
        384'h4014b7f50ebce453422b34999ba4d9674b6c365976d13e464b112776a6a2e69e796ead2dd8e6d58de5079c3d7b99ff10,
        384'h39c43a8750919600519bdb65032a2b87ff027819420ced635cc963beffab3f2f3cc3ef7dd3657a9a927450f516651b95,
        384'hf53789f1d8ad2003fb0eb290afa8e29551aedcae8b3396387f3fd21cba55fe24570e82bf454228105f7060aaf2e4e4b3,
        384'h6eea02a3c08f5a085f533144bd1ea55f9737a7aa3be39eb41f69c5cda19db2ec39c659cc3f58d42819369cbb316b2949,
        384'h80c8d890dbb09f0f64105847d492a7df007cdb4b218b2730e1a5b6cfb3ffb51872ab6ce79aff6034ec4b7995ef8b38fe,
        384'he6d37d810b3dbca537ad4c1dbd9e68ef13850b83b27cd01978afae12227207c1abc8cb107e63b19ebe01abddedfac86b,
        384'h808624b5bc20478cb156f4878f89707e318a7541e5c91ca7f1c71cb0c796f4dd5b05a2281e4959fcfdfb31d3f26932e2,
        384'h9f60d26f223d071ced3243dd8849eedeec0da0963b3e6fedd0e703a7bbd05c2b32be54e1d02da58534313020657a4d7b,
        384'hf7befce70ccd49dca6f5461a529e8bde2140bcd0ca1a0aa95bc17792ed7859048b5534034dc9848ca5d58940c44a8a4b
    };
    
    // DUT signals
    reg clk = 0;
    reg reset;
    reg enable;
    wire [96 * streams - 1 : 0] result;
    
    // flag to stop simulation
    integer run = 1;
    
    // DUT
    xormix96 #(
        .streams(streams)
    ) inst_xormix (
        .clk(clk),
        .reset(reset),
        .seed_x(seed_x),
        .seed_y(seed_y),
        .enable(enable),
        .result(result)
    );
    
    // clock process
    initial begin
        while (run == 1) begin
            clk = 1'b1;
            #5;
            clk = 1'b0;
            #5;
        end
    end
    
    integer i;
    
    // input/output process
    initial begin
        @(posedge clk);
        reset <= 1'b1;
        enable <= 1'b0;
        @(posedge clk);
        reset <= 1'b0;
        enable <= 1'b1;
        for (i = 0; i < results; i = i + 1) begin
            @(posedge clk);
            if (result !== ref_result[96 * streams * i +: 96 * streams])
                $display("Incorrect result");
        end
        run <= 0;
    end
    
endmodule

