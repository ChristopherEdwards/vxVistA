ACKQTE ; GENERATED FROM 'ACKQAS VISIT ENTRY' INPUT TEMPLATE(#1338), FILE 509850.6;07/15/03
 D DE G BEGIN
DE S DIE="^ACK(509850.6,",DIC=DIE,DP=509850.6,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^ACK(509850.6,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(13)=% S %=$P(%Z,U,5) S:%]"" DE(18)=%
 I $D(^(5)) S %Z=^(5) S %=$P(%Z,U,8) S:%]"" DE(10)=%
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
BEGIN S DNM="ACKQTE",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(1338,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=1338,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 I $G(ACKVISIT)'="NEW",$G(ACKVISIT)'="EDIT" W !!,"This option must only be run from QUASAR" S Y="@999"
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 D SETUP^ACKQUTL4
 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 D HLOSS^ACKQUTL4
 Q
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 S ACKCP=$$ACKCP^ACKQUTL4
 Q
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 S ACKCPNO=$S(+ACKCP=0:"",1:$P(ACKCP,U,2)),ACKCP=+ACKCP
 Q
6 S DQ=7 ;@10
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 D EN^ACKQUTL7
 Q
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 I $D(ACKDIRUT) S Y="@999"
 Q
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 I $$TIMECHEK^ACKQASU5(ACKVIEN,1) S Y="@15"
 Q
10 S DW="5;8",DV="RFXO",DU="",DLB="APPOINTMENT TIME",DIFLD=55
 S DQ(10,2)="S Y(0)=Y Q:'$D(Y)  S Y=$TR(Y,""."",""""),Y=$$FMT^ACKQUTL6(Y)"
 S DE(DW)="C10^ACKQTE"
 G RE
C10 G C10S:$D(DE(10))[0 K DB
 S X=DE(10),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
 S X=DE(10),DIC=DIE
 X "D KILLREF^ACKQUTL5(X,DA,""T"")"
C10S S X="" G:DG(DQ)=X C10F1 K DB
 S X=DG(DQ),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
 S X=DG(DQ),DIC=DIE
 X "D SETREF^ACKQUTL5(X,DA,""T"")"
C10F1 Q
X10 K:$L(X)>8!($L(X)<1) X I $D(X) S X=$$DATACHEK^ACKQUTL6(X,DA) K:'X X I $D(X) I '$$DUPECHK^ACKQUTL6(X,DA,$G(ACKPAT)) S ACKITME=X K X
 I $D(X),X'?.ANP K X
 Q
 ;
11 S DQ=12 ;@15
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 I ACKVISIT="EDIT" S Y="@16"
 Q
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW="0;2",DV="RP509850.2X",DU="",DLB="PATIENT NAME",DIFLD=1
 S DE(DW)="C13^ACKQTE"
 S DU="ACK(509850.2,"
 S X=ACKPAT
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(509850.6,1,1,1,2.4)
 S X=DE(13),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(509850.6,1,1,2,2.4)
 S X=DE(13),DIC=DIE
 K ^ACK(509850.6,"APT",$E(X,1,30),DA)
 S X=DE(13),DIC=DIE
 ;
 S X=DE(13),DIC=DIE
 K ^ACK(509850.6,"APD",X,+^ACK(509850.6,DA,0),DA)
 S X=DE(13),DIC=DIE
 K ^ACK(509850.6,"C",$E(X,1,30),DA)
 S X=DE(13),DIC=DIE
 X "D KILLREF^ACKQUTL5(X,DA,""P"")"
 S X=DE(13),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C13S S X="" G:DG(DQ)=X C13F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y X ^DD(509850.6,1,1,1,1.1) X ^DD(509850.6,1,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X=DIV D AOA^ACKQAS X ^DD(509850.6,1,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 S ^ACK(509850.6,"APT",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 X ^DD(509850.6,1,1,4,89.2) S X=$P(Y(101),U,2) S D0=I(0,0) S DIU=X K Y S X=DIV D IVD^ACKQAS X ^DD(509850.6,1,1,4,1.4)
 S X=DG(DQ),DIC=DIE
 S ^ACK(509850.6,"APD",X,+^ACK(509850.6,DA,0),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^ACK(509850.6,"C",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 X "D SETREF^ACKQUTL5(X,DA,""P"")"
 S X=DG(DQ),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C13F1 Q
X13 Q
14 S DQ=15 ;@16
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 S I(0,0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S D(0)=+X S X=$S(D(0)>0:D(0),1:"")
 S DGO="^ACKQTE1",DC="^509850.2^ACK(509850.2," G DIEZ^DIE0
R15 D DE G A
 ;
16 S DQ=17 ;@30
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 I ACKCP=0 S Y="@40"
 Q
18 D:$D(DG)>9 F^DIE17,DE S DQ=18,DW="0;5",DV="S",DU="",DLB="Is this a C&P Visit ?",DIFLD=2.5
 S DE(DW)="C18^ACKQTE"
 S DU="0:NO;1:YES;"
 S Y="YES"
 G Y
C18 G C18S:$D(DE(18))[0 K DB
 S X=DE(18),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV D TRIGCP^ACKQUTL X ^DD(509850.6,2.5,1,1,2.4)
C18S S X="" G:DG(DQ)=X C18F1 K DB
 D ^ACKQTE2
C18F1 Q
X18 Q
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 S ACKCP=X
 Q
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 S:'ACKCP Y="@40"
 Q
21 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=21 D X21 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X21 S:ACKCPNO="" Y="@40"
 Q
22 D:$D(DG)>9 F^DIE17 G ^ACKQTE3
