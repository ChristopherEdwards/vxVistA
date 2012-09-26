HBHCNTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ;OCT 26, 1993@09:11:36
 ;;1.0;HOSPITAL BASED HOME CARE;;NOV 01, 1993
 ;;7.1;OCT 26, 1993@09:11:36
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
HBHCADM ;;11962743
HBHCAPPT ;;3801207
HBHCCAN ;;3167005
HBHCDIS ;;2879397
HBHCEDSP ;;2626063
HBHCFILE ;;9462975
HBHCI001 ;;9839629
HBHCI002 ;;13532905
HBHCI003 ;;14186672
HBHCI004 ;;13204334
HBHCI005 ;;12185113
HBHCI006 ;;11426349
HBHCI007 ;;13685750
HBHCI008 ;;12022124
HBHCI009 ;;15164076
HBHCI010 ;;11247687
HBHCI011 ;;13717638
HBHCI012 ;;13025280
HBHCI013 ;;10084111
HBHCI014 ;;9246223
HBHCI015 ;;11431129
HBHCI016 ;;12922254
HBHCI017 ;;1388745
HBHCI018 ;;3399284
HBHCI019 ;;2045359
HBHCI020 ;;3565067
HBHCI021 ;;1617617
HBHCI022 ;;3516730
HBHCI023 ;;1973542
HBHCI024 ;;7994337
HBHCI025 ;;6824175
HBHCI026 ;;3220051
HBHCI027 ;;2802522
HBHCI028 ;;2885704
HBHCI029 ;;5392074
HBHCI030 ;;1430033
HBHCI031 ;;3627256
HBHCI032 ;;9589531
HBHCI033 ;;4178993
HBHCI034 ;;1013953
HBHCI035 ;;8757557
HBHCI036 ;;10163687
HBHCI037 ;;12256522
HBHCI038 ;;1976037
HBHCI039 ;;3268087
HBHCI040 ;;3432031
HBHCI041 ;;5632588
HBHCI042 ;;4912648
HBHCI043 ;;7625911
HBHCI044 ;;3640608
HBHCI045 ;;4549871
HBHCI046 ;;2208710
HBHCI047 ;;10681339
HBHCI048 ;;12380522
HBHCI049 ;;11192803
HBHCI050 ;;8368601
HBHCI051 ;;9568074
HBHCI052 ;;6781152
HBHCI053 ;;7736330
HBHCI054 ;;8232052
HBHCI055 ;;6727960
HBHCI056 ;;5618113
HBHCI057 ;;7748722
HBHCI058 ;;4760902
HBHCI059 ;;4258429
HBHCI060 ;;3546965
HBHCINI1 ;;5526064
HBHCINI2 ;;5215729
HBHCINI3 ;;15730129
HBHCINI4 ;;3357677
HBHCINI5 ;;2561001
HBHCINIT ;;10782659
HBHCRP1 ;;8660601
HBHCRP10 ;;6625145
HBHCRP11 ;;9560543
HBHCRP12 ;;7849689
HBHCRP13 ;;6167393
HBHCRP2 ;;18125923
HBHCRP3 ;;7022984
HBHCRP4 ;;10163481
HBHCRP5 ;;15359951
HBHCRP6 ;;443595
HBHCRP7 ;;10624801
HBHCRP8 ;;6228007
HBHCRP9 ;;346728
HBHCRXMT ;;8914669
HBHCUPD ;;9674302
HBHCUTL ;;14512316
HBHCUTL1 ;;16556234
HBHCUTL2 ;;16455754
HBHCXMA ;;16976380
HBHCXMA1 ;;6206944
HBHCXMC ;;1196490
HBHCXMD ;;15371308
HBHCXMD1 ;;10169772
HBHCXMT ;;5373539
HBHCXMV ;;10735029
