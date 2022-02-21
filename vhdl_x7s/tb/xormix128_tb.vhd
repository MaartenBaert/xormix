-- Copyright (c) 2020-2021 Maarten Baert <info@maartenbaert.be>
-- Available under the MIT License - see LICENSE.txt for details.

-- This file was generated by `generate_vhdl.py`.

library ieee;
use ieee.std_logic_1164.all;

entity xormix128_tb is
end xormix128_tb;

architecture bhv of xormix128_tb is
    
    -- configuration
    constant streams : integer := 4;
    constant results : integer := 100;
    constant seed_x  : std_logic_vector(127 downto 0) :=
        x"e2972dcc8cdcb548a9e3e90ca899f952";
    constant seed_y  : std_logic_vector(128 * streams - 1 downto 0) :=
        x"a945550d9502bb425014177ee6d2a06ada3304e52777c1021712e597973b8eabab234957d07d1f22f2ccedebacc74c558f071a3a18b674a82870a0335c85314c";
    
    -- reference result
    type result_array_t is array(0 to results - 1) of std_logic_vector(128 * streams - 1 downto 0);
    signal ref_result : result_array_t := (
        x"a945550d9502bb425014177ee6d2a06ada3304e52777c1021712e597973b8eabab234957d07d1f22f2ccedebacc74c558f071a3a18b674a82870a0335c85314c",
        x"be41715a18b21940e52f08b0c3af6f5e5566fcaceba9e6272d7fda93dba231f85a12e8e0ad740d03ca4a00c257ad3058ea4dbf7049eb7dc88d929c85b05fe0c1",
        x"b8044653a18af8d08cc6ad3717d05784132fe40f5654b5f8704789272299231d8dbc26c6b6ffcbcfc2d78d5f0dc657779a45f801d6fcb7b913bf7b09dce7dc1e",
        x"564e1bc2e33aa549f66706470e9e00069ee55597a4042cc9e9f2cb8b9a05c149d811818bf219f9ba8b63c3c0370b58c48ff3c44cee0b2dd0dd3acf31fde375b4",
        x"63451e5f8a00489b03d5c38fdac6157a277709ba1c1f9c0a3ee46ef2537e9b3bee61df50038ed01e36a4f49a9f358e54173959d20f2ccf44dda2d9ca2f0825e5",
        x"2b609407aa2bb0b1e451d129a0f49d9254e8db711a8ae033fe013aa37e531a8bd3871bdaf29d3c7975fde7bfdf564d4a3203c7b052023b9f0039b2ddb4abc1ea",
        x"7c5e2d279cb65bea7835a43b638d55ac6b76a7d25841682b116ac922fce8c0a80762c74bd7cc54695d257c9967f655c3f7c1905abebfb4d5509736b4fc65bd4f",
        x"21dded2f0c0de3e5eacee1a4e2542d96d0130b1799b1b8290fb07660d3c78de9643cf32cc70f7b86ebce53f25ca95514153fb17770154cb15ab8f7989f01c2fe",
        x"ab529e6ecb76246131d7f129760148de67360558458ed8b9a8949c15585b75604ac1e3b879f748603fef63f2201ca16eef166bb68bd762c893eeefdacc31bf84",
        x"d88d5a3862b7f8f312f7c96e287c1ffcbfd4092419150cd3a0be999c4c5b39e06a9606d1afe2b1dccc61ad4392d2a003d84fd82665dd5724cf3fd41bdac2a796",
        x"327a6c86d86ac037b2ed69599ca3c19e0d0c762fde22f97988b76812752da43d2c4a126c2be757becf50ca904ae5158e7f4a0f39434bdbcafc83642610d6e920",
        x"3c85cea8d233677123b83088b68dad8d0092a6eab5b8953b9489d59cf5b0a91049dc4ab98cfe033bf6e0dacd36177a9408881d508f5d4c5790a976c17c1a1a12",
        x"9910db0291cbf3126f0d86030ffdb51b583952a69128c6038b13a9170794ead3bb4fc9a3c4e6404e59f12f172e940162fae5a762021754556fa81a57ac3b7d8b",
        x"ca98deefa9934d32db1701300ba68a2a7bfff973eadc5ed781ca3f385bcff8fa6e1d4efa0331c37acfc21f144de75dd2e6ab6e8bd6815f23fba43cb5f94a759f",
        x"ec9c2aff83c9268918e4a6c9fa4af7e10958a6be3e6cc6b16c5c6b6400157b7129386d11de4bab543b32b668946e93aa06e6704e79aefa13357b48c2c81e6b03",
        x"ea58bdbea2d6070939f6dd627f70d463c4f36688039f369c7aa2c7380678c4cbfa1ea06ddb6e15ce66ee4c5a67770aaab8ddf7c3fd4006e889956a8e90275641",
        x"5b6917c300c4f41291f27aecbc09746233a2081e18ac204536486d0fcd146586f95640c74a5c7837afa976512f49ab22968307463414c67b54c0457507b9eb10",
        x"d745c97b6e94a6ae1ef70465801d7df4c5e32c6ea9f578eab8f0f8374c55ae08ae9db50a4cda8c6e8d2a5d16444aa01c5c2f505eee58b3ee738dcba0fc0b2bd5",
        x"ccda4286f58ac4dd2ed5ffb89c332978cdf5a20963051fd51b742a02e1ad8cef41fd08e153b9145a7b163ed98241e44bad8c21b3913c38dd4d537bcfdb010b11",
        x"514f8e70fac3d4ef1b2f2b1aff25a254b980736b0abab0a19e1e3322a7136ac43e62a31f10ebec26973301ef0683323e742de8f0cfff19374304ad0eadbcf02f",
        x"b0e8acc80ba667c92077bb8551b864bb93f0ecc85c24fbc305a31f689b9f984eb4fb3754e88229399f1884a4d6e42b3dc25e3306b98e60f8dcf1f907ab1ed528",
        x"b69faf441d8f28b430b81655a7e98962404528d85e2e4769311d7885334144e8aa9258a8eefa647eb19548a7cc64af06edfa434e76fc2fd2c2b2cb7e59bc09ee",
        x"3bbd086d4d4dc98f2b7553aa3466b94f43ebe603ae993fbcbac4aef4eae7289678456600901fd9cdbfa9f9e7494d90be2ae798db9efb036fc51a4c73460d82c5",
        x"b25ebcd22283526aedf05557926956c08aa19ef03dcb1b98e975f44a4ec5317578474454346e91f557dc7dfd5cb7c92a7750a1381f73603c3527157bced6bc08",
        x"fe9f06164dc8c775fbdc99e14615ab56be57f7b08b761d9a5982f1d3bbf298b15b195aea799c556d1983d9ecf7f94ea4f28d828ca1379d95d5ac9e15315da04a",
        x"15018d3565706e79cf68724580a7fcba78a29f4c204bbfcd4d995450629af705d3907d0fb0601668fa9f114afb657c57e8cbeea4beaf665f515c05e8373fe230",
        x"046c0ab47ab65bef6522e5de207a5184b5f46bc8943c3ef6017c81ca271cc901bfd43ac16e6ad6be252c5bef05604db93f5df03a5f7b2db59f4317eba03574d7",
        x"f9e6724374262da758e83acc1c2bf20948240566ed88420ecfa62a6ebb8c3f93acb7a3fa9e4bf775e733017763f3ace2e33acb9f8c3925774abc22b83f638f19",
        x"f3c40a76835afa45c01229f58361b59081fdae9425e2826a784915fefbeaf15de38bd9c24a11990f379cde6be2e0c18a354e45c41b9aab596c239d2f58c758d5",
        x"1b6baaaa3460597eb54b6420e9b104873ae14fecd085561e6a5e84caa1e2428643719aff8dfa0606a86636fba8879df5c13ba9d35f649c3a9fc2dc07be7f4df4",
        x"fa01d122eac55b263097b11cf4aa72ff9affab353859fff8ef61fa9a7d120682258cf3cce49ba48a7887c99e5244d64351de19caac3fc7858768e5c593544afb",
        x"f4ca09eb0636f74c7ed163cc980103742179d91e2e91da38da33946ad79ca1acd3890b3eb201ca87744864da2e266dc7c16dc3170f5f5fe276620857991d2acb",
        x"05be3786183285f721e5f13e8b954157db89fbef97caef93e93712030275fd84792f907577421e607eaf2264437d83a2efd305ca4ab3e861084d262f5a0f8816",
        x"5ce57043fa937f3a749e5aec3609b583c691e60f42b0341f66c8cde60beef940693cae53b80cda3ce1853bda564433f78537875e621c10729c28697cd42b07ee",
        x"28704d583c2617345e007897605e0f325583e0bc9737102926f32c1f4352a855f76fc0bee73315078770afa6d9dcc9cb3372286670a53c5391350c696521c867",
        x"75a6247b694c78b4f55b07504fedb4b28a2e0b20c406687f2a699939d38bf1d11ce98a59bb9c7189d7ca008ba39ed5677c3b4855a81b8a61a915d094cced4d9b",
        x"c10273249e858ca3e650c464bad7c52bab3b2be3c4084a59b91e5dd239d4afcbe74e849a3141a063373b0c036ba9c5854a9aa9742f795d48043b54adf0e09139",
        x"2fead78cb9401afc6c286737429f481c777c769692e8ef059167f567d6da9257450be3964126a541cf4902baba933c253f18f630f8945e9154073fe2b6f9e818",
        x"d6749ea3a3a62ccdcf9be2864011a123cca95fb2a37f04e768f138e40e5f512b90387db33fa0026c70fbfdebd2982cba82cc9372f76f46ba78a8c237e7d22a47",
        x"7e0693bb6fb9191cadbb20925c83839996f49eff68d8fc6ae676afcfe749f9927756baff67d87e2539c8ba9b88317213974aa7446e822a51a04ec7401a46a593",
        x"5502cfefecefd116eb7e40e676ea8be007dbd297adedbfbf1a5a897f34c6d365a418273dc8c17e94822a8220b3ca5cde287f1d5c37d0d73599f549e4a1e754b3",
        x"fde6a87a456a19764926135fdfa2743dbf61402b8d693577651b8379e68ff1484ded6d11bdff963accd2d632ee1da10abc06b88a12dc4690331d7cc74c55e727",
        x"e16f830efd3a10ee9bf3d31ed146d548113db57704490a5c3bc4c804e031e2370194325df16b2894ca131454b51e2ec7784c0eb39c7c82fd2a7bce7205cf0c9f",
        x"4138ce0764545dc680fc210a6ac462ea916eb77788b60c0ca506df7970fd5418a3ec807d453ef657ce9b4c9a837a84f3b57834d481b124ee41f23018469f0eed",
        x"40c836ec0d26ada365fe91d7698be09f9de6bda9e4d66396a0d0c8f952edddbc3ca1cae8da722cc05032686119d8541d72296a0ffc36a1bc7a8a4eb48fab354a",
        x"b15f47ec2b11bd1b0f40173400dffecd4f61ab0b3e3bacde6261da05c11f6af00fe8218ecf59d9d8072ea59c96520e17feac5e425434b5c32b89b139156fc0d8",
        x"33cabea98cd97f0d83358a8e3f203f8b9ee78a21c91e6269e281461a4405bad0ff7105d2cdd5c1617aa78d1d1428ce348601efc9ec7a1882c64e32aac8aa32f2",
        x"ca11b19d4f1c71b0e15e9619fdf2403fdb50b577020d7b1f6e10c5be0185e8fa24ed7149f685c6feada1b3f00808a595f42a77231377b692a2f2272656614efb",
        x"3d017ff2c1ca25b59accd70cc61162754e15b2f7f6531880349ce7d0ef5f177aa8b7f4ef41d592a70a40f9ab97b0b9db83fae106c1a0668b3f372cc79c806255",
        x"78c5fb6b9cddcf23e2464fe56bf7a7a13eac05bf695556dd3a8d972c48e8da4c80ea132d1d1b2d7337596760c7bf2780f92a0d3dd3402dfb373e21bb8fa4c8c2",
        x"08432ae520cf8bff8139f0e65d96eb2a5092ccd133b3783f526706848a659fefb3cfbd147a6f7c4509042eab681c24b958ff1f38bd8b37573947b468d586a96b",
        x"bcdec1e6e0196d6b0bc52e5cfdd33aa46efdeedde98296c927690fa24b6f0c182423934c975c2b8a46d4f3688b775b75e7d681101a23b630c8d68b1c45f34184",
        x"1dbbaf685dae59b1300f08ccf43015c03a5796f408a9b262d89d09e1a64995e2c0b5e436bc163e8ea21313cc50374516d6c87d1f908cee0665fa613cd1913bf5",
        x"4219e41a0bda53d2fec8dbb469b39d557eaff6b421e3385646a83ab4f8313e5e553981624462c4fa0e6689efede41bf441fe546f626f56151fd0d533d30807da",
        x"897a76204bf18758b3c684e015340f2e1d1a14afb8dd8d54f714561412daacc383f110f820970a2b5c3142b6822552e76e466b43bcec4aee01ed972c297bae62",
        x"46a694f89f66856d45c028f9e781447d3642b7dd92d7dd46b98bf341719e6648a11c213bafa1cda7b0869e528934a71afba04cbfddc8b65102f1adb7acd66368",
        x"fbdd2524f33b95e60d3b2ee0b1bb884bfb23022ebe5fdf4efa6f9c1b6a5556b0874ad676aab28f0be3a67f94d365c5d54cd6306e2d804c8b254916b46ceb9786",
        x"6240e1e0bc2dd4bb7318ffc001796de3625713819121441c6bcbed3bcb6704de0da84e914ab2982f2eb6a4431cb1e7c8954a40b2b22c062c5475d4e5d2862418",
        x"f4f87c300301a8141fa5c7d8558ea6bd7eac147cc0d0cdffde988af38abdde8c7ca91bd0c017838e4af203d6cc178ebb5ccc2707fe31b5abe72a1b0f1139f039",
        x"fd12b777c18e10aa4dcd1002bc2cb4f783fc9dfa39bff023e3dc2a1344ff712696ad7a8e8255babbf8b90c1c255bf5d035e0494f0277e14ae03eeafe7c4f9faf",
        x"63d74d92db3fa35c7cba16afbeac706f57f294ab9c864a7cdaf977340be93eef5bc62f9f737d514aff6147bae6e867aa86507539c3414ba536e0c8f81500b9a9",
        x"10718a9b50c77bf9325fb94f442fe5b55ce43d6f6d962380347102e61a48cff19ac6bd319be96b10c5b8a2c7830aa37bf22127527dfd181af08d3a86153a3a20",
        x"d647248501e1f160217b7b39c2820e412e0fa0d70ec784e14404080c0ca2da72ab8c3e4498ce5ba7fcaa6c31f1f20514f05c20d07ff940b684309baf2e91c776",
        x"bfb1319e62cbaa5fb38f4a7c11130e38808e1b892d749bfe7086f3a0f18079a1a1c2dcb16125d1f7d0e2b460189476d66381e995a4202eceba1b1f0cb4809c9a",
        x"419129b077d776472e161d98c21de284ed1e4d9c25c65fc9da297c2bdd077cfb86ab79a19e7b7b46d640350ed1928f6882fed6d13095d4dc73fa531a284ab8ae",
        x"f04ce210bea1dbb909d284c3f4b12cff5a9efd772bf9a29c419e49dfcbad94cafdd4e1c46f95bd62ceb93a9daba3bf77d1327e0d6c76361da84171f43b89ded6",
        x"a186c51fa408967400ddd75f4b35808a9d233cd31d5d45030ee5be652e721f2649aa343e5f082b7c016e24276caba4ba45a167d6dd5e7fb4fe35783b66852e84",
        x"5c5b01c03a733750699b061653bcda18fd360b05af47ba6cda02493d0f1b78f7c4a50919a83964d1e248d894ec705c468d323c2972b04f3b21c612fa64646387",
        x"4d6c2a9b769a199dbf6999551cc38f87a295ed2b4a6e6a2723c39ffef50ce9e5048490c8079f455b08d072f1a0ce64f6b7edfa66a76739cf6d4a7e39b217d329",
        x"7c8e3f80fe36b7098eff3b0abb1d012531dc821846aef05ef65105788152eaa9aba560fef3a21cfd7d87a74a240749be359a2cc2f7247ff25ee134e88ab1b260",
        x"b60ce68e0f6a866946724458b6a408aa3009d855831476a08c22674f8aa33c419838bdf30dbcee2acd78bb10c13855aab6c8b94f61326939c57034b1133a37d4",
        x"16810719f89c5e10d049bbaffeacaad8fd0ce6c320e8f7f85b87fabe416e3d15e77c81f5caf75ab271c156343169c6edcc5f3958a474d348ef6ff42c24a32e87",
        x"0d96fb53cdb925b9ac0468b1da94a7c07f50c8656d609b9147a6447d566441f2c3d0e36044406fc147be213f010d121d5c2430f6f23608e45afa59b5d2a063a0",
        x"a39e70155c2d258f74ba8fe635ab1575eb10a6e42ee8b7cad3360ab0f9920f1b07cabd586854438dd082d041d61573e6f4703d6ce6125e14817c883a9b7d8656",
        x"551ce91c4eb23ca838274396fc1c06b797435705a643602458d3655854ebb7dea041a444a856c2dae40015ec98338806f90cd9e9488085a6be97bc07deab95ab",
        x"6d9afc1ec7cdfd817879419c6707babc4602ff2df15d65d4db1f15f894aad72260d0490ade22b480d46475826783ab384c03fda4fa2b6fcc63eb0b205cc95b04",
        x"26cd329208f0e1dc381403f558f7085bded47727e09e5d1529d927b00fe0b8e4e99a7974034cf5cbb0fcbfb39da0383843586ff867e5d24ea1775fa6b7a6c4f8",
        x"42a78908ddf0e8933abd8fbe31604981e4497add942bcea737abe443ad9e7d7ec05ef5bda540b6844d8d91a2c2bd02030edfdd5fe709b0476d6ce77bc51067bf",
        x"c37f95919619a4c46ceef83ec2cadeaf1be27bed5b9de9b1cab5286596af6ebe7a35c094e5cfab921790118bd34070622a8f05af932409765aecdb09acbef622",
        x"c0e28db8f94f61f817fc2917b2c4594d05045b1136c6619065d088f22d9f66e58921f13d9ddb04d30775e6bdd806a7dcaf0d305b010b86271c0701e4866afdf0",
        x"e7f773a47022a1248520994303c7e6918e1bcdf56d3397287c0009940dbb8ba0ded4ae801890e44e01d117563e5228227352222575a4d48654f6d3f72aae6221",
        x"80ccfdb6de3be1cfe2d3b6ce0cba8d7b130f1b452dc482e30160eb0fb1f033d576ac6115e4f9f4e08aef337d3f4d68def5624f62ea4a64d42ef3ac77b2f00a74",
        x"9556e51295fa80d2215d74b309b0170257f798cd7e629893598a9dd78d2d01c4a3e87ef5504b09afce309b41468db242eaf29ebb3cd1c7a3a170b48cf394be21",
        x"a212506aa585ae63d594e2d8f2682744ce5c1d14fda14020de1e82c377077e270f1774c959d2bb5cf2c600f9cc30ac5969a0496c1eab26e1faa52877350dd4b2",
        x"75f271c9ed805e2255c51894ee9ff63adaf51eb5a026f40a7cf81dafb8d18a3241e8af8b74507893abdd37631f437b106c2ac5facad56178495f5da0da8ff6c0",
        x"10dfc1e387c7efea8a566f5f3087c47e805178368cb97d574185d09ba54f05485beed82490e8f7e8855fc7b1ee3c27199187dd458135052a4653016c64a0d23e",
        x"58ff3da3ff077b8117e5bbfa3a7454d481f627d4ada1c63500c31dec9e98c9e00724e99dca4829343703eecd5e8306dee9e5d9694a24fda0522b6bd46c5d0658",
        x"346cf632a027678d15ed3b94cb80511558a7554d3f7ab856961dbd08af43c1c95467c229fb6a63ef2d65461609e5be80a5d0b4335566e345ec2b67652c641721",
        x"bf133e01097c64dcbdff76b42918dad40a80c27a99eb258fccaa3320ad2275fb0ebc4cfffe24d31bc805fead3c26af16fa9e7cf2a1c4fed56d90ace30afb3fe5",
        x"9767bcce3a39a6db5511127a9993efa70ddfd200e6efbc21e2b3dca3e75d7a50e2ce7fd706f0eed87d86205299074688990b8694e8eedb26bfd63e8683090e68",
        x"107e3098f521b5a212a9278d9e36fb3478a16cc798647967b5779cd946666f8805e019b9a87f9c782c066503d36c38698a79020484a05486f79cf14e622f2963",
        x"12c654e984ab3da65ec697b7620d136d24232b4afc19411d11ef2ec45331776e64f88fdf9b93ffc558fb83b6aa8b9db29b0fe637a7ed22915a224310a1bb52ec",
        x"b1d3aa7a8fe0d76584c86eaca6f05726ea415e96a594c951741e0b8b388baf4c36e005db36121657116f90502b30836206558db3d3f0f87c249319e148783930",
        x"420847ad4685d43417b5bc1319b6db9b6b1ff1193a82704bd1b6011de7d5c2162136609b6d750bb2fb148bded09882ee8566e059a571c89ee6add914c233eb6d",
        x"90be11f75d5fe7eb876f026bb7af76e1d3ce7896044c604354641bef53262af7983ae1e3672603ecc36f90680dfc3e2a62ebd18fc3ab382aeca6973a9a532a8a",
        x"8411f54096faef9878437083bdb0fbf7508dd8be1502ef2963f0a2ec51f34ae393b4d0aab5a0cad038a0e82fe62a4bb9b8af78ae549da306aba516498d98f151",
        x"c151515d444c70ce9fd4b90a57438d6f4c02db0561dfa392f0f39fb6c3056088fa11408d70795a1076e4d38a64fe9cee04e452881ab7a3b4ace38e635f177f15",
        x"8edfac9cfa1b021811dec4653ba6ab1c1b1853b77d3e3c2d31aa4f525ca41fad17e18769be66e7fff45c4bde257f74bcc3fb349e5a99a5cdc8f8f0a5001a9fc6",
        x"7295404e815a531386c5182eda75eec054b865f090d3add4c199f58a907e680d1eb657f9d26ce2ffd383ee8b9de89d0599cb1c94cf56105c8c185448067415d5",
        x"098c6432cd88108726b993fa62386ee5eb396e2e3ae4568a1dc6948bb8d40938914b0bf12e1d7b3382f1f1998fad6fa6eaf06cf17007b85eb23fb7c5d32052be"
    );
    
    -- DUT signals
    signal clk    : std_logic := '0';
    signal rst    : std_logic;
    signal enable : std_logic;
    signal result : std_logic_vector(128 * streams - 1 downto 0);
    
    -- flag to stop simulation
    signal run : boolean := true;
    
begin
    
    -- DUT
    inst_xormix : entity work.xormix128_x7s generic map(
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
