PRCATE ; GENERATED FROM 'PRCA SET' INPUT TEMPLATE(#799), FILE 430;10/06/97
 D DE G BEGIN
DE S DIE="^PRCA(430,",DIC=DIE,DP=430,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^PRCA(430,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,7) S:%]"" DE(9)=% S %=$P(%Z,U,8) S:%]"" DE(2)=% S %=$P(%Z,U,16) S:%]"" DE(4)=% S %=$P(%Z,U,21) S:%]"" DE(6)=%
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
BEGIN S DNM="PRCATE",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=799,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 I ('$D(PRCAT))!('$D(PRCABN)) S Y=""
 Q
2 S DW="0;8",DV="R*P430.3'X",DU="",DLB="CURRENT STATUS",DIFLD=8
 S DE(DW)="C2^PRCATE"
 S DU="PRCA(430.3,"
 S Y="INCOMPLETE"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C2 G C2S:$D(DE(2))[0 K DB S X=DE(2),DIC=DIE
 K ^PRCA(430,"AC",$E(X,1,30),DA)
 S X=DE(2),DIC=DIE
 I $P(^PRCA(430,DA,0),"^",9) K ^PRCA(430,"AS",$P(^PRCA(430,DA,0),"^",9),X,DA)
 S X=DE(2),DIC=DIE
 ;
 S X=DE(2),DIC=DIE
 ;
 S X=DE(2),DIC=DIE
 I $P(^PRCA(430,DA,0),U,14) K ^PRCA(430,"ASDT",X,$P($P(^PRCA(430,DA,0),U,14),"."),DA)
C2S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^PRCA(430,"AC",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 I $P(^PRCA(430,DA,0),"^",9) S ^PRCA(430,"AS",$P(^PRCA(430,DA,0),"^",9),X,DA)=""
 S X=DG(DQ),DIC=DIE
 X ^DD(430,8,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^PRCA(430,D0,6)):^(6),1:"") S X=$P(Y(1),U,21),X=X S DIU=X K Y S X=DIV D NOW^%DTC S X=% X ^DD(430,8,1,3,1.4)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^PRCA(430,D0,0)):^(0),1:"") S X=$P(Y(1),U,14),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(430,8,1,4,1.4)
 S X=DG(DQ),DIC=DIE
 I $P(^PRCA(430,DA,0),U,14) S ^PRCA(430,"ASDT",X,$P($P(^PRCA(430,DA,0),U,14),"."),DA)=""
 Q
X2 D CKSTAT^PRCAUT3
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 I PRCAT'["C" S Y="@6"
 Q
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW="0;16",DV="R*P430.2'",DU="",DLB="TYPE OF CARE",DIFLD=15.1
 S DU="PRCA(430.2,"
 G RE
X4 S DIC("S")="I $P(^(0),U,7)<4" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 S PRCAQS=+X
 Q
6 S DW="0;21",DV="NJ3,0",DU="",DLB="SEGMENT",DIFLD=20.1
 S X=$P(^PRCA(430.2,PRCAQS,0),U,3)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X6 K:+X'=X!(X>500)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
7 S DQ=8 ;@6
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 I "T"'[PRCAT S Y="@3"
 Q
9 S DW="0;7",DV="RP2'",DU="",DLB="PATIENT",DIFLD=7
 S DE(DW)="C9^PRCATE"
 S DU="DPT("
 G RE
C9 G C9S:$D(DE(9))[0 K DB S X=DE(9),DIC=DIE
 K ^PRCA(430,"E",X,DA)
C9S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 I $P(^PRCA(430,DA,0),"^",2),$P(^PRCA(430.2,+$P(^(0),"^",2),0),"^",6)["T" S ^PRCA(430,"E",X,DA)=""
 Q
X9 Q
10 S DQ=11 ;@3
11 D:$D(DG)>9 F^DIE17 G ^PRCATE1