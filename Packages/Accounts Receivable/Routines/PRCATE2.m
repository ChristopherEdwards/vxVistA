PRCATE2 ; ;10/06/97
 D DE G BEGIN
DE S DIE="^PRCA(430,",DIC=DIE,DP=430,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^PRCA(430,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,5) S:%]"" DE(5)=% S %=$P(%Z,U,10) S:%]"" DE(7)=% S %=$P(%Z,U,19) S:%]"" DE(1)=% S %=$P(%Z,U,20) S:%]"" DE(3)=%
 I $D(^(100)) S %Z=^(100) S %=$P(%Z,U,2) S:%]"" DE(10)=%
 I $D(^(104)) S %Z=^(104) S %=$P(%Z,U,1) S:%]"" DE(11)=%
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
N I X="" G A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) I X?.ANP D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) I DV'["*" D ^DIC S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
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
BEGIN S DNM="PRCATE2",DQ=1
1 S DW="0;19",DV="P36'",DU="",DLB="SECONDARY INSURANCE CARRIER",DIFLD=19
 S DU="DIC(36,"
 G RE
X1 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S:X="" Y="@4"
 Q
3 S DW="0;20",DV="P36'",DU="",DLB="TERTIARY INSURANCE CARRIER",DIFLD=19.1
 S DU="DIC(36,"
 G RE
X3 Q
4 S DQ=5 ;@4
5 S DW="0;5",DV="R*P430.6'OX",DU="",DLB="BILL RESULTING FROM",DIFLD=4.5
 S DQ(5,2)="S Y(0)=Y I $D(^PRCA(430.6,+Y,0)) S Y=$P(^PRCA(430.6,+Y,0),U,2)"
 S DU="PRCA(430.6,"
 G RE
X5 S DIC("S")="S Z0=$P(^PRCA(430,DA,0),U,2) Q:+Z0'>0  S Z0=$P(^PRCA(430.2,Z0,0),U,6) I ($P(^PRCA(430.6,Y,0),U,4)[Z0)!($P(^(0),U,4)[""X"")" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S $P(^PRCA(430,D0,7),U,1)=X
 Q
7 S DW="0;10",DV="RDX",DU="",DLB="DATE BILL PREPARED",DIFLD=10
 G RE
X7 S %DT="E" D ^%DT S X=Y K:Y<1!(X>DT) X
 Q
 ;
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 S I(0,0)=D0 S Y(1)=$S($D(^PRCA(430,D0,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S D(0)=+X S X=$S(D(0)>0:D(0),1:"")
 S DGO="^PRCATE3",DC="^340^RCD(340," G DIEZ^DIE0
R8 D DE G A
 ;
9 S D=0 K DE(1) ;1
 S DIFLD=1,DGO="^PRCATE4",DC="7^430.01IA^2^",DV="430.01MRFX",DW="0;1",DOW="FISCAL YEAR",DLB="Select "_DOW S:D DC=DC_D
 G RE:D I $D(DSC(430.01))#2,$P(DSC(430.01),"I $D(^UTILITY(",1)="" X DSC(430.01) S D=$O(^(0)) S:D="" D=-1 G M9
 S D=$S($D(^PRCA(430,DA,2,0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M9 I D>0 S DC=DC_D I $D(^PRCA(430,DA,2,+D,0)) S DE(9)=$P(^(0),U,1)
 G RE
R9 D DE
 S D=$S($D(^PRCA(430,DA,2,0)):$P(^(0),U,3,4),1:1) G 9+1
 ;
10 S DW="100;2",DV="RP49'",DU="",DLB="SERVICE",DIFLD=101
 S DU="DIC(49,"
 G RE
X10 Q
11 S DW="104;1",DV="P200'",DU="",DLB="APPROVING OFFICIAL (SERVICE)",DIFLD=111
 S DU="VA(200,"
 G RE
X11 Q
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 S $P(^PRCA(430,D0,0),U,12)=$S($D(PRCA("SITE")):PRCA("SITE"),1:"")
 Q
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 S $P(^PRCA(430,D0,0),U,4)=$S($D(PRCAGLN):PRCAGLN,1:"")
 Q
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 K PRCAQS
 Q
15 G 0^DIE17
