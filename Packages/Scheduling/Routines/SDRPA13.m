SDRPA13 ;BP-OIFO/ESW - UTILITY ; 6/9/04 8:24am
 ;;5.3;Scheduling;**376**;Aug 13, 1993
EN(ST) ;
 N SR,II,STR,SA,STE,GG,SS,SQS,ER,SB,SM,SQ
 F II=1:1 S STR=$P($T(@ST+II),";;",2) Q:+STR'=ST  D
 .S SA=$P(STR,";",2) Q:SA'="B"
 .S SB=$P(STR,";",3),SM=$P(STR,";",4) D
 ..F GG=1:1 S STE=$P($T(@ST+II+GG),";;",2) Q:+STE'=ST!($P(STE,";",2)="B")  D
 ...S ER=$P(STE,";",3) S SQS=$P(STE,";",4) F SS=1:1 S SQ=$P(SQS,",",SS) Q:SQ=""  D PR^SD376P(SB,SM,ER,SQ)
 ..;update batch acknowledgement
 ..S ER="" S SQ=$O(^SDWL(409.6,"AMSG",SM,"")) Q:SQ=""  D PR^SD376P(SB,SM,ER,SQ)
 Q
554 ;;
 ;;554;B;55437796563;55448521745
 ;;554;ER;350;388,
 ;;554;B;55437797821;55448523185
 ;;554;ER;350;1674,
 ;;554;ER;400;283,
 ;;554;B;55437799590;55448525823
 ;;554;ER;350;2430,
 ;;554;B;55437800230;55448526572
 ;;554;ER;350;4361,
 ;;554;B;55437800577;55448526877
 ;;554;ER;350;389,
 ;;554;B;55437801818;55448528456
 ;;554;ER;400;4932,
 ;;554;B;55437806185;55448532888
 ;;554;ER;400;4856,4857,4858,4859,
 ;;554;B;55437816254;55448544676
 ;;554;ER;400;649,
 ;;554;B;55437909261;55448657090
 ;;554;ER;400;119,
556 ;;
 ;;556;B;55614723975;55621263555
 ;;556;ER;350;2967,
 ;;556;B;55614724139;55621263748
 ;;556;ER;350;1708,
 ;;556;B;55614724207;55621263828
 ;;556;ER;350;4497,
557 ;;
 ;;557;B;55723601318;55729649231
 ;;557;ER;700;672,
558 ;;
 ;;558;B;55830098578;55844865732
 ;;558;ER;350;1113,2920,
 ;;558;B;55830102189;55844871123
 ;;558;ER;350;4287,
 ;;558;B;55830103593;55844873399
 ;;558;ER;350;1955,
561 ;;
 ;;561;B;56130833860;56129081726
 ;;561;ER;700;2271,
 ;;561;B;56130901834;56129473527
 ;;561;ER;350;2830,
 ;;561;B;56130903196;56129481304
 ;;561;ER;350;343,
 ;;561;B;56130903290;56129482010
 ;;561;ER;350;3491,
562 ;;
 ;;562;B;5627678452;5626309900
 ;;562;ER;350;3253,
565 ;;
 ;;565;B;56516370753;56523143655
 ;;565;ER;350;1249,4039,
568 ;;
 ;;568;B;56810669869;56815555226
 ;;568;ER;200;2077,
 ;;568;B;56810669876;56815555246
 ;;568;ER;200;3855,3858,3861,3864,3867,3872,3875,3876,3877,3878,3879,3880,4279,
 ;;568;B;56810669881;56815555251
 ;;568;ER;200;4148,4151,4152,4153,4154,4155,4156,4157,4158,4159,4160,4161,
 ;;568;B;56810669904;56815555280
 ;;568;ER;200;4219,
 ;;568;B;56810669927;56815555303
 ;;568;ER;200;150,608,709,868,888,1011,1257,1511,1834,1890,2171,2644,2696,2789,2948,2989,3797,3969,4013,4016,4020,4024,4027,4030,4031,4032,4033,4034,4035,
 ;;568,ER;200;4036,4075,4077,4080,4082,4083,4084,4085,4086,4087,4088,4089,4090,4091,4092,4093,4096,4097,4098,4099,4100,4101,4102,4103,4113,4265,4318,4592,4608,4632,4648,4670,4676,4807,4906,
 ;;568;B;56810669937;56815555313
 ;;568;ER;200;3062,3066,3067,3069,3070,3071,3072,3073,3074,3075,3076,3077,3078,4284,4717,4718,4719,4720,4721,4906,4910,4914,4918,4921,4924,4927,4929,4930,4931,4932,4933,
 ;;568;B;56810669946;56815555322
 ;;568;ER;200;3474,3477,3478,3479,3480,3481,4217,4218,4219,4220,4221,4222,4223,4224,4225,4226,4227,4923,
 ;;568;B;56810669968;56815555343
 ;;568;ER;200;2596,2601,2604,2608,2611,2613,2616,2618,2619,2620,2621,2622,
 ;;568;B;56810669978;56815555355
 ;;568;ER;200;1179,1182,1185,1188,1190,1193,1195,1197,1198,1199,1200,4076,4079,4082,4085,4086,4087,4088,4089,4090,4091,4092,
 ;;568;B;56810669983;56815555360
 ;;568;ER;200;4935,4937,4939,4940,4941,4942,4943,4944,4945,4946,
 ;;568;B;56810669986;56815555363
 ;;568;ER;200;560,788,842,925,955,1006,1173,1265,1352,1391,1793,2034,3174,3361,3653,3654,3658,3661,3665,3668,3670,3673,3676,3678,3679,3680,4233,4315,4589,
 ;;568,ER;200;4594,4597,4600,4603,4606,4609,4610,4611,4612,4613,4645,4669,4672,4675,4678,4681,4684,4687,4689,4692,4696,4699,4700,4701,4761,4831,4859,4885,4892,4898,4910,4915,4921,
 ;;568;B;56810670008;56815555376
 ;;568;ER;200;2821,2831,2836,2839,2841,2844,2846,2849,2852,2855,2856,2857,4660,
 ;;568;B;56810670085;56815555454
 ;;568;ER;200;1026,1031,1035,1037,1042,1044,1047,1050,3814,3815,3816,3817,3818,3819,3820,3821,3822,3823,3824,3825,
 ;;568;B;56810670093;56815555473
 ;;568;ER;200;2009,2195,3523,3525,3526,3527,3528,3529,3530,3531,3532,3533,3534,3535,4246,
 ;;568;B;56810670098;56815555478
 ;;568;ER;200;4793,4795,4796,4797,4798,4799,4800,4801,4802,4803,4804,4805,4808,4811,4812,4813,4814,4815,4816,4818,4819,4820,4821,4822,
 ;;568;B;56810670101;56815555481
 ;;568;ER;200;580,1141,1330,1433,1687,1690,1693,1695,1698,1701,1703,1705,1708,1711,1713,1714,1774,1997,2061,2075,3296,3298,3300,3301,3302,3303,3304,
 ;;568;ER;200;3305,3306,3307,3308,3309,3748,4816,4818,4821,4823,4826,4829,4832,4834,4836,4839,4842,4843,
 ;;568;B;56810670128;56815555505
 ;;568;ER;200;2789,2888,3422,3479,3484,3489,3493,3498,3501,3505,3509,3512,3514,3515,3516,4195,4205,4266,4317,4338,4402,4508,4571,4787,4911,
 ;;568;ER;200;1222,1223,1224,1225,1226,1227,1228,1229,1230,1231,1232
 ;;568;ER;200;1222,1223,1224,1225,1226,1227,1228,1229,1230,1231,1232,1233,4842,4846,4850,4853,4856,4859,4862,4865,4866,4867,4868,4869,
 ;;568;B;56810670150;56815555529
 ;;568;ER;200;3958,3962,3965,3968,3971,3974,3977,3981,3982,3983,3984,3985,4484,4489,4494,4499,4503,4507,4512,4515,4517,4518,4519,
 ;;568;B;56810670151;56815555532
 ;;568;ER;200;2252,2253,2254,2255,2256,2257,2258,2259,2260,2261,2262,2263,
 ;;568;B;56810670156;56815555543
 ;;568;ER;200;2308,2309,2310,2311,2312,2313,2314,2315,2316,2317,2318,2465,2466,2467,2468,2469,2470,2471,2472,2473,2474,2475,
 ;;568;B;56810670169;56815555566
 ;;568;ER;200;118,754,796,1460,1764,2435,2669,4468,4471,4472,4473,4474,4475,4476,4477,4478,4479,4480,4481,
 ;;568;B;56810670178;56815555575
 ;;568;ER;200;2472,2770,3180,3445,3532,3740,3873,3903,4143,4274,4293,4411,4607,4762,4803,4813,4827,4839,4931,4944,4952,4963,
 ;;568;B;56810670187;56815555585
 ;;568;ER;200;1507,1508,1509,1510,1511,1512,1513,1514,1515,1516,1517,1518,4274,4278,4280,4283,4288,4291,4294,4297,4298,4299,4300,4301,
 ;;568;B;56810670188;56815555586
 ;;568;ER;200;2206,2314,
 ;;568;B;56810670193;56815555591
 ;;568;ER;200;2074,2189,
 ;;568;B;56810670242;56815555640
 ;;568;ER;200;300,372,1468,1605,1753,2116,2161,3371,3955,3956,3964,3965,3972,3973,3976,3977,3978,3979,3980,3981,3982,3983,3984,3985,3986,3987,3988,3989,3990,3991,3992,4161,4423,4681,4682,4683,4684,
 ;;568;B;56810670243;56815555641
 ;;568;ER;200;1174,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,2144,2145,2146,2147,2148,2149,2150,2151,2152,2153,2154,2155,4089,4137,4326,4604,4606,4607,4608,4609,4610,4611,4612,4623,4767,4857,4895,
 ;;568;B;56810670244;56815555642
 ;;568;ER;200;4006,4009,4010,4011,4012,4013,4014,4015,4016,4017,4018,4554,4555,4556,4557,4558,4559,4560,4561,4562,4563,4564,4565,
 ;;568;B;56810670249;56815555643
 ;;568;ER;200;440,1999,
 ;;568;B;56810670250;56815555648
 ;;568;ER;200;2099,3746,3747,3748,3749,3750,3751,3752,3753,3754,3755,3756,3849,3850,3851,3852,3853,3854,3855,3856,3857,3858,3859,3860,
 ;;568;B;56810670267;56815555666
 ;;568;ER;200;4522,4529,4535,4536,4537,4538,4539,4540,4541,4542,4543,4544,4897,4900,4906,4909,4912,4915,4918,4919,4920,4921,4922,4923,
 ;;568;B;56810670272;56815555677
 ;;568;ER;200;1370,1373,1376,1379,1382,1384,1385,1386,1387,1388,1389,2035,2045,2154,3795,
 ;;568;B;56810670277;56815555682
 ;;568;ER;200;540,816,817,1009,1602,1608,1699,2200,2401,2701,3026,3374,3822,4066,4254,4456,4707,4717,4848,4855,4861,4946,
 ;;568;B;56810670293;56815555698
 ;;568;ER;200;1177,1180,1183,1188,1191,1194,1197,1198,1199,1200,4620,4623,4626,4629,4632,4635,4637,4638,4639,4640,4641,
 ;;568;ER;350;3973,
 ;;568;B;56810670298;56815555703
 ;;568;ER;200;1470,1473,1474,1475,1476,1477,1478,1479,1480,1481,1482,1483,4491,4918,4919,4920,4921,4922,4923,4924,4925,4926,4927,4928,4929,
 ;;568;ER;200;426,925,1591,1596,1599,1602,1605,1608,1611,1613,1614,1
 ;;568;ER;200;426,925,1591,1596,1599,1602,1605,1608,1611,1613,1614,1615,1616,1617,2887,3120,3386,3505,3508,3511,3514,3517,3521,3525,3529,3531,3533,3534,3535,3841,3845,3850,3854,3858,3862,3868,3870,3872,3874,3876,3877,
 ;;568;B;56810670313;56815555741
 ;;568;ER;200;2007,2010,2013,2016,2019,2022,2024,2025,2026,2027,2028,2870,2932,3220,3855,4799,4810,4860,4862,4863,4864,4865,4866,4867,4868,4873,4879,4894,
 ;;568;B;56810670351;56815555786
 ;;568;ER;200;2539,2545,2551,2557,2560,2561,2563,2564,2565,2566,2567,2568,
570 ;;
 ;;570;B;57010414709;5707880258
 ;;570;ER;350;3290,
 ;;570;B;57010414740;5707880290
 ;;570;ER;400;1323,
 ;;570;B;57010414742;5707880292
 ;;570;ER;350;4114,
 ;;570;B;57010414760;5707880310
 ;;570;ER;350;5000,
 ;;570;B;57010414762;5707880313
 ;;570;ER;350;3633,
 ;;570;ER;400;98,
 ;;570;B;57010414824;5707880399
 ;;570;ER;400;1075,
 ;;570;B;57010414853;5707880442
 ;;570;ER;400;419,
