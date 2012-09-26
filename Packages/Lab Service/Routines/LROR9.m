LROR9 ;SLC/DCM - ADD TESTS TO AN EXISTING ORDER THRU OE/RR; 9/23/88  15:15 ;2/8/91  07:29 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
EN Q:'$D(ORPK)  S LRODT=$P(ORPK,"^"),LRSN=$P(ORPK,"^",2),LRTN=$P(ORPK,"^",3) I 'LRODT!('LRSN)!('LRTN) W !,"Cannot add to this order." Q
 I '$D(^LRO(69,LRODT,1,LRSN,0)) W !,"Cannot add to this order." Q
 S LR2ORD=1 I $D(^LRO(69,LRODT,1,LRSN,2,LRTN,0)),$P(^(0),"^",3) W !,"Tests have been accessioned, call the lab to add tests to the same order." G END
 S LRADDTST="",LRORD=$P(^LRO(69,LRODT,1,LRSN,.1),"^") D:'$D(LRPARAM) EN^LRPARAM D PT,A
END K X3,T,LRADDTST,LRFLOG,LRIOZERO,LRGCOM,LRM,LRNCWL,LRORDER,LRORDTIM,LRORIFN,LRSSX,LRSTIK,LRSVSN,LRTSTNM,LRTXD,LRTXP,LRWPC,LRBED,LRCCOM,LRCDT,LRCOM,LRCS,LRCSN,LRCSP,LRCSS,LRCSX,LRDFN,LRDPF,LRDTO,LREND,LREXP,LRI,LRIO,LRLLOC,LRLWC
 K LR2ORD,LRMAX,LRMOR,LRNN,LRODT,LRORD,LRPR,LRPRAC,LRSAMP,LRTSTN,LRSN,LRSNO,LRSPEC,LRSSP,LRTEST,LRTIME,LRTN,LRTP,LRTSN,LRTY,LRUR,LRUSI,LRUSNM,LRXS,LRXST,LRY,PNM,SEX,SSN,J,K,S,X,Y,LRSN1,LRSAME
 K DIC,L,LRAA,LRAAO,LRACN0,LRAD,LRAN,LRCW,LRFOOT,LRHF,LRLAB,LRLL,LROD0,LROD1,LROD3,LROOS,LROS,LROSD,LRBLOOD,LRC,LRDT0,LRJ,LRMD,LRODTSV,LROR,LRORN,LRPARAM,LRPLASMA,LRSERUM,LRSNSV,LRTNSV,LRUNKNOW,LRUNQ,LRURG,LRURINE,LRWRD,LRZX,NOW,X1,X5
 K LROT,LRROD,LRSAV,LRSORD,LRSS,LRTSTS,LRZ
 Q
A S X=^LRO(69,LRODT,1,LRSN,0),LRSAMP=$P(X,"^",3),LRSPEC=$S($D(^(4,1,0)):+^(0),1:0) I LRSPEC,LRSAMP D B
 K T S DA=0 F  S DA=$O(^LRO(69,LRODT,1,"AA",LRDFN,DA)) Q:DA<1  I $S($D(^LRO(69,LRODT,1,DA,1)):$P(^(1),"^",4)'="U",1:1) S S=$S($D(^LRO(69,LRODT,1,DA,4,1,0)):+^(0),1:0) S I=0 F  S I=$O(^LRO(69,LRODT,1,DA,2,I)) Q:I<1  S T(+^(I,0),DA)=S
 D ADD^LROW
 Q
B S I=0 F  S I=$O(^LRO(69,LRODT,1,LRSN,2,I)) Q:I<1  S X3(+^(I,0),LRSAMP,LRSPEC)=""
 Q
PT S LROR=$S($D(^LRO(69,LRODT,1,LRSN,0)):^(0),1:-1),LRDFN=+LROR I LRDFN<1 W "  NO PATIENT" Q
 S LRDPF=$P(^LR(LRDFN,0),"^",2),DFN=$P(^(0),"^",3) D PT^LRX
 H 1 W !!,"ORDER #: ",LRORD,?30,"PATIENT: ",PNM,?60,"SSN: ",SSN
 S Y=$S($D(^LRO(69,LRODT,1,LRSN,1)):+^(1),1:"") I Y D DD^LRX W !,"  DRAW TIME:   ",Y
 W ! S Y=$S($D(^LRO(69,LRODT,1,LRSN,3)):+^(3),1:"") I Y D DD^LRX W "  LAB ARRIVAL: ",Y
 W:$D(^DPT(DFN,.1)) ?40,"WARD: ",^(.1)
 W:$P(LROR,"^",3) !,"  SPECIMEN: ",$S($D(^LAB(62,$P(LROR,"^",3),0)):$P(^(0),"^"),1:"??")
 S L=+$P(^LRO(69,LRODT,1,LRSN,0),"^",6) I L S LRMD=$S($D(^VA(200,L,0)):$P(^(0),"^"),1:L) W ?30,"PHYSICIAN: ",LRMD
TST S I=0 F  S I=$O(^LRO(69,LRODT,1,LRSN,2,I)) Q:I<1  D TEST
 I $D(^LRO(69,LRODT,1,LRSN,1)),$L($P(^(1),"^",6)) W !,"COMMENT: ",$P(^(1),"^",6)
 S I=0 F  S I=$O(^LRO(69,LRODT,1,LRSN,6,I)) Q:I<1  W !,?3,^(I,0)
 Q:'$D(LRADDTST)  W !,"Is this the one" S %=1 D YN^DICN S LRADDTST=$S(%=1:LRORD,1:"") I %=1 S X=^LRO(69,LRODT,1,LRSN,0),LRLLOC=$P(X,"^",7),LROLLOC=$P(X,"^",9),LRORDTIM=$P($P(X,"^",8),".",2),LRPRAC=$P(X,"^",6),LRLWC=$P(X,"^",4)
 Q
TEST S X=^LRO(69,LRODT,1,LRSN,2,I,0) S:$P(^(0),"^",3) LRNOP=1 W !,"  TEST: ",$S($D(^LAB(60,+X,0)):$P(^(0),"^"),1:"UNKNOWN"),?28,"  " S LRURG=+$P(X,"^",2) W $S($D(^LAB(62.05,LRURG,0)):$P(^(0),"^"),1:"ROUTINE")
 W ?38,"  ",$S($D(^LRO(68,+$P(X,"^",4),0)):$P(^(0),"^"),1:""),?50,"  ",$P(X,"^",5)
 Q
