ENPLPC ; GENERATED FROM 'ENPLP005' PRINT TEMPLATE (#157) ; 06/11/96 ; (FILE 6925, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(157,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 F Y=0:0 Q:$Y>-1  W !
 D N:$X>0 Q:'DN  W ?0 W "VHA"
 D N:$X>19 Q:'DN  W ?19 W "PROJECT APPLICATION - SIGN OFF SUMMARY"
 D N:$X>65 Q:'DN  W ?65 W "PROJECT NUMBER"
 S X=$G(^ENG("PROJ",D0,0)) D N:$X>67 Q:'DN  W ?67,$E($P(X,U,1),1,11)
 D N:$X>0 Q:'DN  W ?0 W "PROJECT PROGRAM: "
 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>49 Q:'DN  W ?49 W "FACILITY PRIORITY: "
 S X=$G(^ENG("PROJ",D0,15)) W ?0,$E($P(X,U,9),1,3)
 D N:$X>0 Q:'DN  W ?0 W "FACILITY: "
 X DXS(1,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>49 Q:'DN  W ?49 W "TOTAL PROJECT SCORE: "
 X ^DD(6925,235,9.8) S X=X+Y W $E(X,1,6) K Y(6925,235)
 D N:$X>0 Q:'DN  W ?0 W "PROJECT TITLE: "
 S X=$G(^ENG("PROJ",D0,0)) W ?0,$E($P(X,U,3),1,50)
 D N:$X>0 Q:'DN  W ?0 W "EMERGENCY APPLICATION: "
 X DXS(2,9.3) S X=$S(DIP(4):DIP(6),DIP(7):X) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "EQUIPMENT OVER $250K APPLICATION: "
 X DXS(3,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "BUILDING NUMBER(S): "
 X DXS(4,9) K DIP K:DN Y W $E(X,1,50)
 D N:$X>0 Q:'DN  W ?0 W "BUILDING OCCUPANCY: "
 S X=$G(^ENG("PROJ",D0,15)) S Y=$P(X,U,4) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "PROJECT CATEGORY: "
 S X=$G(^ENG("PROJ",D0,52)) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^OFM(7336.8,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,40)
 D N:$X>0 Q:'DN  W ?0 W "BUDGET CATEGORY: "
 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^OFM(7336.9,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,40)
 D N:$X>0 Q:'DN  W ?0 W "NET BED CHANGE: "
 S X=$G(^ENG("PROJ",D0,15)) W ?0,$E($P(X,U,2),1,4)
 D N:$X>49 Q:'DN  W ?49 W "NET PARKING CHANGE: "
 W ?0,$E($P(X,U,3),1,5)
 D N:$X>0 Q:'DN  W ?0 W "LISTED ON 5 YR FACILITY PLAN: "
 X DXS(5,9) K DIP K:DN Y W $E(X,1,4)
 D N:$X>49 Q:'DN  W ?49 W "5-YR FACILITY PLAN FY: "
 S X=$G(^ENG("PROJ",D0,15)) W ?0,$E($P(X,U,6),1,4)
 D N:$X>0 Q:'DN  W ?0 W "NEW NET SQ. FT.: "
 X DXS(6,9) K DIP K:DN Y W $E(X,1,9)
 D N:$X>39 Q:'DN  W ?39 W "NEW GROSS SQ. FT.: "
 X DXS(7,9) K DIP K:DN Y W $E(X,1,9)
 D N:$X>0 Q:'DN  W ?0 W "RENOVATED NET SQ. FT.: "
 X DXS(8,9) K DIP K:DN Y W $E(X,1,9)
 D N:$X>39 Q:'DN  W ?39 W "RENOVATED GROSS SQ. FT.: "
 X DXS(9,9) K DIP K:DN Y W $E(X,1,9)
 D N:$X>0 Q:'DN  W ?0 W "AE $ REQUIRED IN FY: "
 S X=$G(^ENG("PROJ",D0,5)) W ?0,$E($P(X,U,7),1,4)
 D N:$X>39 Q:'DN  W ?39 W "CONSTRUCTION $ REQUIRED IN FY: "
 S X=$G(^ENG("PROJ",D0,0)) W ?0,$E($P(X,U,7),1,4)
 D N:$X>0 Q:'DN  W ?0 W "PLANNED CONSTRUCTION METHOD: "
 S X=$G(^ENG("PROJ",D0,15)) S Y=$P(X,U,7) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 D N:$X>44 Q:'DN  W ?44 W "TOTAL PROJECT COSTS: $ "
 X ^DD(6925,222,9.3) S Y(6925,222,5)=X S X=$P(Y(6925,222,6),U,8),X=$S(Y(6925,222,2):Y(6925,222,4),Y(6925,222,5):X)+Y(6925,222,7)+$P(Y(6925,222,6),U,7)+$P(Y(6925,222,6),U,6) S X=$J(X,0,0) W $E(X,1,11) K Y(6925,222)
 D N:$X>0 Q:'DN  W ?0 W "PROJECT DESCRIPTION:"
 S I(1)=17,J(1)=6925.0192 F D1=0:0 Q:$O(^ENG("PROJ",D0,17,D1))'>0  S D1=$O(^(D1)) D:$X>22 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ENG("PROJ",D0,17,D1,0)) S DIWL=1,DIWR=56 D ^DIWP
 Q
A1R ;
 D A^DIWW
 D N:$X>0 Q:'DN  W ?0 W "PROJECT JUSTIFICATION:"
 S I(1)=26,J(1)=6925.05 F D1=0:0 Q:$O(^ENG("PROJ",D0,26,D1))'>0  S D1=$O(^(D1)) D:$X>24 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^ENG("PROJ",D0,26,D1,0)) S DIWL=1,DIWR=54 D ^DIWP
 Q
B1R ;
 D A^DIWW
 D N:$X>0 Q:'DN  W ?0 W "WORKLOAD:"
 S I(1)=27,J(1)=6925.06 F D1=0:0 Q:$O(^ENG("PROJ",D0,27,D1))'>0  S D1=$O(^(D1)) D:$X>11 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^ENG("PROJ",D0,27,D1,0)) S DIWL=1,DIWR=67 D ^DIWP
 Q
C1R ;
 D 0^DIWW K DIP K:DN Y
 D ^DIWW K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
