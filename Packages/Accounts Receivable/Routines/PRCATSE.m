PRCATSE ; GENERATED FROM 'PRCASV REL' INPUT TEMPLATE(#824), FILE 430;12/22/97
 D DE G BEGIN
DE S DIE="^PRCA(430,",DIC=DIE,DP=430,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^PRCA(430,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(1)=% S %=$P(%Z,U,7) S:%]"" DE(7)=% S %=$P(%Z,U,9) S:%]"" DE(2)=% S %=$P(%Z,U,10) S:%]"" DE(4)=%
 I $D(^(104)) S %Z=^(104) S %=$P(%Z,U,1) S:%]"" DE(3)=% S %=$P(%Z,U,3) S:%]"" DE(5)=%
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
BEGIN S DNM="PRCATSE",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=824,U="^"
1 S DW="0;2",DV="R*P430.2'X",DU="",DLB="CATEGORY",DIFLD=2
 S DU="PRCA(430.2,"
 S X=PRCASV("CAT")
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X1 Q
2 S DW="0;9",DV="R*P340X",DU="",DLB="DEBTOR",DIFLD=9
 S DE(DW)="C2^PRCATSE"
 S DU="RCD(340,"
 S X=PRCADEBT
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C2 G C2S:$D(DE(2))[0 K DB S X=DE(2),DIC=DIE
 K ^PRCA(430,"C",$E(X,1,30),DA)
 S X=DE(2),DIC=DIE
 I $P(^PRCA(430,DA,0),"^",8) K ^PRCA(430,"AS",X,$P(^PRCA(430,DA,0),"^",8),DA)
 S X=DE(2),DIC=DIE
 D UPATDS^PRCAUTL I $D(^RCD(340,X,0)),$P(^(0),"^")[";DPT(",$D(^PRCA(430,DA,6)),$P(^(6),"^",21) S ^PRCA(430,"ATD",X,$P(^PRCA(430,DA,6),"^",21),DA)=""
C2S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^PRCA(430,"C",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 I $P(^PRCA(430,DA,0),"^",8) S ^PRCA(430,"AS",X,$P(^PRCA(430,DA,0),"^",8),DA)=""
 S X=DG(DQ),DIC=DIE
 D UPATDS^PRCAUTL I $D(^RCD(340,X,0)),$P(^(0),"^")[";DPT(",$D(^PRCA(430,DA,6)),$P(^(6),"^",21) S ^PRCA(430,"ATD",X,$P(^PRCA(430,DA,6),"^",21),DA)=""
 Q
X2 Q
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="104;1",DV="P200'",DU="",DLB="APPROVING OFFICIAL (SERVICE)",DIFLD=111
 S DU="VA(200,"
 S X=PRCASV("APR")
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X3 Q
4 S DW="0;10",DV="RDX",DU="",DLB="DATE BILL PREPARED",DIFLD=10
 S X=PRCASV("BDT")
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X4 Q
5 S DW="104;3",DV="D",DU="",DLB="DATE SIGNED (APPROVED)",DIFLD=113
 S X=DT
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X5 Q
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S:PRCAT'["T" Y="@1"
 Q
7 S DW="0;7",DV="RP2'",DU="",DLB="PATIENT",DIFLD=7
 S DE(DW)="C7^PRCATSE"
 S DU="DPT("
 S X=PRCASV("PAT")
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C7 G C7S:$D(DE(7))[0 K DB S X=DE(7),DIC=DIE
 K ^PRCA(430,"E",X,DA)
C7S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 I $P(^PRCA(430,DA,0),"^",2),$P(^PRCA(430.2,+$P(^(0),"^",2),0),"^",6)["T" S ^PRCA(430,"E",X,DA)=""
 Q
X7 Q
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 S:'$D(PRCASV("2NDINS")) Y="@1"
 Q
9 D:$D(DG)>9 F^DIE17 G ^PRCATSE1
