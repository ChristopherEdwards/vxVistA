QAMNTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ;SEP 13, 1993@10:24:02
 ;;1.0;Clinical Monitoring System;;09/13/1993
 ;;7.0;SEP 13, 1993@10:24:02
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
QAMAHO1 ;;13519726
QAMAHO2 ;;10344951
QAMAHO3 ;;6035849
QAMAHO3A ;;11476228
QAMAHO4 ;;7656720
QAMAHO5 ;;5688190
QAMAHOC ;;6915667
QAMAPGRP ;;867681
QAMARCH0 ;;7523632
QAMARCH1 ;;6562099
QAMAUTO0 ;;9756005
QAMAUTO1 ;;10013460
QAMAUTO2 ;;6370885
QAMAUTO3 ;;7561731
QAMAUTO4 ;;16251365
QAMAUTO5 ;;5096785
QAMAUTO6 ;;1733251
QAMAUTO7 ;;6409975
QAMAUTO8 ;;6266089
QAMC0 ;;1697
QAMC1 ;;3503224
QAMC10 ;;9917495
QAMC11 ;;10610333
QAMC12 ;;10546368
QAMC13 ;;4323573
QAMC14 ;;3900265
QAMC15 ;;3615839
QAMC16 ;;12936687
QAMC17 ;;15971002
QAMC18 ;;12045749
QAMC19 ;;9416245
QAMC2 ;;6414343
QAMC20 ;;9682209
QAMC21 ;;11414085
QAMC22 ;;8020479
QAMC23 ;;13333075
QAMC24 ;;3465336
QAMC25 ;;1899426
QAMC3 ;;6624119
QAMC4 ;;1198638
QAMC5 ;;6803011
QAMC6 ;;3255007
QAMC7 ;;8674914
QAMC8 ;;9947471
QAMC9 ;;8396448
QAMDUP0 ;;5634386
QAMEDT0 ;;14457590
QAMEDT1 ;;1683863
QAMEDT2 ;;14249388
QAMEDT3 ;;2250000
QAMEDT4 ;;9700021
QAMEDT5 ;;18080508
QAMEDT5A ;;9809256
QAMEDT6 ;;13540381
QAMEDT7 ;;14609780
QAMGPOP0 ;;4938857
QAMGRP1 ;;3953916
QAMGRP2 ;;4144531
QAMPBMW0 ;;3766912
QAMPBMW1 ;;8481112
QAMPFAL0 ;;9791557
QAMPFAL1 ;;4613077
QAMPHIS1 ;;7823461
QAMPINQ1 ;;9132290
QAMPINQ2 ;;6209223
QAMPINQ3 ;;6483708
QAMPINQ4 ;;8566250
QAMPINQ5 ;;1834055
QAMPMON0 ;;8857969
QAMPMON1 ;;10931686
QAMPRUN0 ;;8091519
QAMSANE ;;6322601
QAMTIME0 ;;3671119
QAMUTL0 ;;7958787
QAMUTL1 ;;11876082
QAMUTL2 ;;2157829
