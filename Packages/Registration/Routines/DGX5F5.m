DGX5F5 ; ;05/01/09
 D DE G BEGIN
DE S DIE="^DGPT(D0,""M"",",DIC=DIE,DP=45.02,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^DGPT(D0,"M",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,26) S:%]"" DE(30)=%,DE(33)=% S %=$P(%Z,U,27) S:%]"" DE(36)=%,DE(39)=% S %=$P(%Z,U,31) S:%]"" DE(24)=%,DE(27)=%
 I $D(^(300)) S %Z=^(300) S %=$P(%Z,U,4) S:%]"" DE(1)=%,DE(5)=% S %=$P(%Z,U,5) S:%]"" DE(9)=% S %=$P(%Z,U,6) S:%]"" DE(13)=% S %=$P(%Z,U,7) S:%]"" DE(17)=%
 K %Z Q
 ;
W W !?DL+DL-2,DLB_": "
 Q
O D W W Y W:$X>45 !?9
 I $L(Y)>19,'DV,DV'["I",(DV["F"!(DV["K")) G RW^DIR2
 W:Y]"" "// " I 'DV,DV["I",$D(DE(DQ))#2 S X="" W "  (No Editing)" Q
TR R X:DTIME E  S (DTOUT,X)=U W $C(7)
 Q
A K DQ(DQ) S DQ=DQ+1
B G @DQ
RE G PR:$D(DE(DQ)) D W,TR
N I X="" G NKEY:$D(^DD("KEY","F",DP,DIFLD)),A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) I X?.ANP D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) G:DV["*" AST^DIED D NOSCR^DIED S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U D:$G(DE(DW,"INDEX")) SAVEVALS G:'$$KEYCHK UNIQFERR^DIE17 S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
X W:'$D(ZTQUEUED) $C(7),"??" I $D(DB(DQ)) G Z^DIE17
 S X="?BAD"
QS S DZ=X D D,QQ^DIEQ G B
D S D=DIFLD,DQ(DQ)=DLB_U_DV_U_DU_U_DW_U_$P($T(@("X"_DQ))," ",2,99) Q
Y I '$D(DE(DQ)) D O G RD:"@"'[X,A:DV'["R"&(X="@"),X:X="@" S X=Y G N
PR S DG=DV,Y=DE(DQ),X=DU I $D(DQ(DQ,2)) X DQ(DQ,2) G RP
R I DG["P",@("$D(^"_X_"0))") S X=+$P(^(0),U,2) G RP:'$D(^(Y,0)) S Y=$P(^(0),U),X=$P(^DD(X,.01,0),U,3),DG=$P(^(0),U,2) G R
 I DG["V",+Y,$P(Y,";",2)["(",$D(@(U_$P(Y,";",2)_"0)")) S X=+$P(^(0),U,2) G RP:'$D(^(+Y,0)) S Y=$P(^(0),U) I $D(^DD(+X,.01,0)) S DG=$P(^(0),U,2),X=$P(^(0),U,3) G R
 X:DG["D" ^DD("DD") I DG["S" S %=$P($P(";"_X,";"_Y_":",2),";") S:%]"" Y=%
RP D O I X="" S X=DE(DQ) G A:'DV,A:DC<2,N^DIE17
I I DV'["I",DV'["#" G RD
 D E^DIE0 G RD:$D(X),PR
 Q
SET N DIR S DIR(0)="SV"_$E("o",$D(DB(DQ)))_U_DU,DIR("V")=1
 I $D(DB(DQ)),'$D(DIQUIET) N DIQUIET S DIQUIET=1
 D ^DIR I 'DDER S %=Y(0),X=Y
 Q
SAVEVALS S @DIEZTMP@("V",DP,DIIENS,DIFLD,"O")=$G(DE(DQ)) S:$D(^("F"))[0 ^("F")=$G(DE(DQ))
 I $D(DE(DW,"4/")) S @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")=""
 E  K @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")
 Q
NKEY W:'$D(ZTQUEUED) "??  Required key field" S X="?BAD" G QS
KEYCHK() Q:$G(DE(DW,"KEY"))="" 1 Q @DE(DW,"KEY")
BEGIN S DNM="DGX5F5",DQ=1
1 S DW="300;4",DV="P45.61'X",DU="",DLB="SUBSTANCE ABUSE",DIFLD=300.04
 S DU="DIC(45.61,"
 G RE
X1 S DGFLAG=4 D 501^DGPTSC01 K:DGER X K DGER,DGFLAG
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S:X]"" DGDUP(4)=1
 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 S Y="@840"
 Q
4 S DQ=5 ;@835
5 S DW="300;4",DV="P45.61'X",DU="",DLB="SUBSTANCE ABUSE",DIFLD=300.04
 S DU="DIC(45.61,"
 S X=DGTX
 S Y=X
 G Y
X5 S DGFLAG=4 D 501^DGPTSC01 K:DGER X K DGER,DGFLAG
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S:X]"" DGDUP(4)=1
 Q
7 S DQ=8 ;@840
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 I '$D(DGBPC(5))!(DGDUP(5)) S Y="@850"
 Q
9 S DW="300;5",DV="SX",DU="",DLB="PSYCHIATRY CLASS. SEVERITY",DIFLD=300.05
 S DU="0:INADEQUATE INFO OR NO CHANGE;1:NONE;2:MILD;3:MODERATE;4:SEVERE;5:EXTREME;6:CATASTROPHIC;"
 G RE
X9 S DGFLAG=5 D 501^DGPTSC01 K:DGER X K DGER,DGFLAG
 Q
 ;
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S:X]"" DGDUP(5)=1
 Q
11 S DQ=12 ;@850
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 I '$D(DGBPC(6))!(DGDUP(6)) S Y="@860"
 Q
13 S DW="300;6",DV="NJ2,0X",DU="",DLB="CURRENT PSYCH CLASS ASSESS",DIFLD=300.06
 G RE
X13 S DGFLAG=6 D 501^DGPTSC01 S:DGER X="" K DGFLAG,DGER K:+X'=X!(X>90)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S:X]"" DGDUP(6)=1
 Q
15 S DQ=16 ;@860
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 I '$D(DGBPC(7))!(DGDUP(7)) S Y="@899"
 Q
17 S DW="300;7",DV="NJ2,0X",DU="",DLB="HIGH LEVEL PSYCH CLASS",DIFLD=300.07
 G RE
X17 S DGFLAG=7 D 501^DGPTSC01 S:DGER X="" K DGER,DGFLAG K:+X'=X!(X>90)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 S:X]"" DGDUP(7)=1
 Q
19 S DQ=20 ;@899
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 K DGPTIT S Y=DGNFLD
 Q
21 S DQ=22 ;@900
22 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=22 D X22 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X22 K DGEXQ D CHQUES^DGPTSPQ I '$D(DGEXQ) S Y="@999"
 Q
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 D X23 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X23 I '$D(DGEXQ(6)) S Y="@904"
 Q
24 S DW="0;31",DV="S",DU="",DLB="WAS TREATMENT RELATED TO COMBAT?",DIFLD=31
 S DU="Y:YES;N:NO;"
 S Y="YES"
 G Y
X24 Q
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 S Y="@905"
 Q
26 S DQ=27 ;@904
27 S DW="0;31",DV="S",DU="",DLB="POTENTIALLY RELATED TO COMBAT",DIFLD=31
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X27 Q
28 S DQ=29 ;@905
29 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=29 D X29 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X29 I '$D(DGEXQ(1)) S Y="@910"
 Q
30 S DW="0;26",DV="SX",DU="",DLB="WAS TREATMENT RELATED TO AGENT ORANGE EXPOSURE?",DIFLD=26
 S DU="Y:YES;N:NO;"
 G RE
X30 S DGFLAG=1 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
31 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=31 D X31 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X31 S Y="@915"
 Q
32 S DQ=33 ;@910
33 S DW="0;26",DV="SX",DU="",DLB="TREATED FOR AO CONDITION",DIFLD=26
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X33 S DGFLAG=1 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
34 S DQ=35 ;@915
35 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=35 D X35 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X35 I '$D(DGEXQ(2)) S Y="@920"
 Q
36 S DW="0;27",DV="SX",DU="",DLB="WAS TREATMENT RELATED TO IONIZING RADIATION EXPOSURE?",DIFLD=27
 S DU="Y:YES;N:NO;"
 G RE
X36 S DGFLAG=2 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
37 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=37 D X37 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X37 S Y="@925"
 Q
38 S DQ=39 ;@920
39 S DW="0;27",DV="SX",DU="",DLB="TREATED FOR IR CONDITION",DIFLD=27
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X39 S DGFLAG=2 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
40 S DQ=41 ;@925
41 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=41 D X41 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X41 I '$D(DGEXQ(3)) S Y="@930"
 Q
42 D:$D(DG)>9 F^DIE17 G ^DGX5F6
