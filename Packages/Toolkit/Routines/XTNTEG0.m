XTNTEG0 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;2950425.092013
 ;;7.3;TOOLKIT;;Apr 25, 1995
 ;;7.3;2950425.092013
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 G CONT^XTNTEG01
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
XTLKEFOP ;;12288261
XTLKKSCH ;;5117176
XTLKKWL ;;2673960
XTLKKWL1 ;;8089076
XTLKKWL2 ;;8570562
XTLKKWLD ;;830939
XTLKMGR ;;8218132
XTLKPRT ;;3890354
XTLKPST ;;561010
XTLKTICD ;;2688040
XTLKTOKN ;;3207127
XTLKWIC ;;2000831
XTRCMP ;;4749536
XTRGRPE ;;342530
XTRTHV ;;6157862
XTSPING ;;258974
XTSUMBLD ;;10426704
XTVCHG ;;2433675
XTVGC1 ;;22093368
XTVGC1A ;;6994193
XTVGC2 ;;20558103
XTVGC2A ;;17354751
XTVGC2A1 ;;9865117
XTVNUM ;;7898211
XTVRC1 ;;9444013
XTVRC1A ;;18908374
XTVRC1Z ;;573177
XTVRC2 ;;18916359
XTVRCRES ;;5210571
XUCIN001 ;;6331531
XUCIN002 ;;7847815
XUCIN003 ;;5328738
XUCIN004 ;;5633578
XUCIN005 ;;4016858
XUCIN006 ;;6384285
XUCIN007 ;;2842241
XUCIN008 ;;4454633
XUCIN009 ;;7054787
XUCIN00A ;;3478716
XUCIN00B ;;3162587
XUCIN00C ;;4414148
XUCIN00D ;;5426793
XUCIN00E ;;6950804
XUCIN00F ;;6487754
XUCIN00G ;;5536118
XUCIN00H ;;5595361
XUCIN00I ;;3636839
XUCIN00J ;;4985882
XUCIN00K ;;1326743
XUCIN00L ;;1575674
XUCIN00M ;;5562214
XUCIN00N ;;5268349
XUCIN00O ;;4317063
XUCIN00P ;;5661675
XUCIN00Q ;;7342486
XUCIN00R ;;8641639
XUCIN00S ;;5853502
XUCIN00T ;;5815554
XUCIN00U ;;6204905
XUCIN00V ;;4353627
XUCIN00W ;;5144510
XUCIN00X ;;5630258
XUCIN00Y ;;6331276
XUCIN00Z ;;7705187
XUCIN010 ;;5146314
XUCIN011 ;;2024106
XUCINIS ;;2173432
XUCINIT ;;10781726
XUCINIT1 ;;5752814
XUCINIT2 ;;5232654
XUCINIT3 ;;16094813
XUCINIT4 ;;3357826
XUCINIT5 ;;1367458
XUCMBR1 ;;5837802
XUCMBR2 ;;10844732
XUCMBR3 ;;9625086
XUCMBRTL ;;8754496
XUCMDSL ;;4295323
XUCMFGI ;;1467166
XUCMFIL ;;5382924
XUCMGRAF ;;1687213
XUCMNI2A ;;20928196
XUCMNIT ;;11960925
XUCMNIT1 ;;7377867
XUCMNIT2 ;;16835662
XUCMNIT3 ;;5784566
XUCMNIT4 ;;11052588
XUCMNIT5 ;;4264655
XUCMNT3A ;;10767827
XUCMPA ;;7085998
XUCMPA1 ;;7618346
XUCMPA2 ;;6586755
XUCMPA2A ;;5655040
XUCMPA2B ;;9904709
XUCMPOST ;;1750081
XUCMPRE ;;2500182
XUCMTM ;;9551796
XUCMTM1 ;;3008863
XUCMVPG ;;4016494
XUCMVPG1 ;;5894133
XUCMVPI ;;5930227
XUCMVPM ;;4086669
XUCMVPM1 ;;11280175
XUCMVPS ;;6211427
XUCMVPU ;;3071852
XUCPCLCT ;;3573145
XUCPFRMT ;;13051323
XUCPRAW ;;13134609
XUCS1E ;;5744464
XUCS1R ;;11414218
XUCS1RA ;;11144520
XUCS1RB ;;11341248
XUCS1RBA ;;6176633
XUCS2E ;;5426963
XUCS2R ;;7996923
XUCS2RA ;;6913779
XUCS2RB ;;8006304
XUCS2RBA ;;4179178
XUCS4E ;;1556880
XUCS4R ;;11653758
XUCS4RB ;;9766381
XUCS5E ;;1037983
XUCS5EA ;;5223554
XUCS6E ;;1362981
XUCS6R ;;6132484
XUCS8E ;;2709944
XUCS8R ;;12237493
XUCS8RB ;;10517473
XUCS8RG ;;5086949
XUCS8RGA ;;4599537
XUCSCDE ;;3642152
XUCSCDG ;;6572594
XUCSCDGA ;;4312009
XUCSCDR ;;9885385
XUCSCDRB ;;8466812
XUCSI001 ;;6807214
XUCSI002 ;;8095362
XUCSI003 ;;7090131
XUCSI004 ;;6290195
XUCSI005 ;;3935311
XUCSI006 ;;4874125
XUCSI007 ;;6391003
XUCSI008 ;;6245860
XUCSI009 ;;6641536
XUCSI00A ;;7072648
XUCSI00B ;;6183955
XUCSI00C ;;5840656
XUCSI00D ;;5871453
XUCSI00E ;;2444351
XUCSI00F ;;850326
XUCSI00G ;;5117155
XUCSI00H ;;7689858
XUCSI00I ;;6887131
XUCSI00J ;;6573491
XUCSI00K ;;6171637
XUCSI00L ;;4221793
