PSGWNU ;BHAM ISC/PTD,CML-Print Drugs (Items) with NO Usage for Selected Date Range ; 19 Mar 93 / 8:31 AM
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
BDT S %DT="AEX",%DT("A")="BEGINNING date for report: " D ^%DT K %DT G:Y<0 END^PSGWNU1 S BDT=Y
EDT S %DT="AEX",%DT(0)=BDT,%DT("A")="ENDING date for report: " D ^%DT K %DT G:Y<0 END^PSGWNU1 S EDT=Y
 D SEL^PSGWUTL1 G:'$D(SEL) END^PSGWNU1 I SEL="I" F JJ=0:0 S JJ=$O(AOULP(JJ)) Q:'JJ  I $S('$D(^PSI(58.1,JJ,"I")):0,'^("I"):0,^("I")>DT:0,1:1) K AOULP(JJ)
 G:SEL="I" EN
ASKAOU F JJ=0:0 S DIC="^PSI(58.1,",DIC(0)="QEAM",DIC("S")="I $S('$D(^(""I"")):1,'^(""I""):1,^(""I"")>DT:1,1:0)" D ^DIC K DIC Q:Y<0  S AOULP(+Y)=""
 I '$D(AOULP)&(X'="^ALL") G END^PSGWNU1
 I X="^ALL" F AOU=0:0 S AOU=$O(^PSI(58.1,AOU)) Q:'AOU  I $S('$D(^PSI(58.1,AOU,"I")):1,'^("I"):1,^("I")>DT:1,1:0) S AOULP(AOU)=""
EN G:'$D(AOULP) END^PSGWNU1 W !!,"The right margin for this report is 80.",!,"You may queue the report to print at a later time.",!!
DEV K %ZIS,IOP S %ZIS="QM",%ZIS("B")="" D ^%ZIS I POP W !,"NO DEVICE SELECTED OR REPORT PRINTED!" G END^PSGWNU1
 I $D(IO("Q")) K IO("Q") S PSGWIO=ION,ZTIO="" K ZTSAVE,ZTDTH,ZTSK S ZTRTN="ENQ^PSGWNU",ZTDESC="Compile Zero Usage" S:$D(AOULP) ZTSAVE("AOULP(")="" F G="BDT","EDT","AOU","PSGWIO","SEL","IGDA" S:$D(@G) ZTSAVE(G)=""
 I  D ^%ZTLOAD,HOME^%ZIS K ZTSK G END^PSGWNU1
 U IO
 ;
ENQ ;ENTRY POINT WHEN QUEUED
 K ^TMP("PSGWNU",$J) S AOU=""
AOU S AOU=$O(AOULP(AOU)) G:('AOU)&($D(ZTQUEUED)) PRTQUE G:'AOU ^PSGWNU1
DRUG ;LOOP THROUGH DRUGS FOR AOU
 S DRGDA=0
DRGLP S DRGDA=$O(^PSI(58.1,AOU,1,DRGDA)) G:'DRGDA AOU S DRGNM=$P(^PSI(58.1,AOU,1,DRGDA,0),"^")
 I '$O(^PSDRUG(DRGNM,0)) S DIK="^PSI(58.1,"_AOU_",1,",DA=DRGDA,DA(1)=AOU D ^DIK K DIK G DRGLP
 S DRGNAME=$P(^PSDRUG(DRGNM,0),"^")
INACT I $P(^PSI(58.1,AOU,1,DRGDA,0),"^",10)="Y",$P(^(0),"^",3)="" S $P(^(0),"^",10)=""
 I $P(^PSI(58.1,AOU,1,DRGDA,0),"^",3)'="" G DRGLP
 ;
AR ;AUTOMATIC REPLENISHMENT INVENTORIES
 S (DRGQD,INVDA)=0,AR=""
INVLP S INVDA=$O(^PSI(58.1,AOU,1,DRGDA,1,INVDA)) G:'INVDA OD S ARDT=$S($D(^PSI(58.19,INVDA,0)):$P(^(0),"^"),1:"")
 I 'ARDT,'$D(^PSI(58.19,INVDA,0)) S DIE="^PSI(58.1,AOU,1,DRGDA,1,",DA=INVDA,DA(1)=DRGDA,DA(2)=AOU,DR=".01///@" D ^DIE K DIE G INVLP
 S QD=$P(^PSI(58.1,AOU,1,DRGDA,1,INVDA,0),"^",5) I (QD'="")&(QD>0)&(ARDT>AR) S AR=ARDT
 I (ARDT'<BDT)&(ARDT'>EDT) S DRGQD=DRGQD+QD
 G INVLP
 ;
OD ;ON DEMAND REQUESTS
 S ODA=0,OD=""
ODLP S ODA=$O(^PSI(58.1,AOU,1,DRGDA,5,ODA)) G:'ODA RET S ODT=$P($P(^PSI(58.1,AOU,1,DRGDA,5,ODA,0),"^"),".")
 S QD=$P(^PSI(58.1,AOU,1,DRGDA,5,ODA,0),"^",2) I (QD'="")&(QD>0)&(ODT>OD) S OD=ODT
 I (ODT'<BDT)&(ODT'>EDT) S DRGQD=DRGQD+QD
 G ODLP
 ;
RET ;RETURNS
 S RETDT=0,RFLG="N"
RETLP S RETDT=$O(^PSI(58.1,AOU,1,DRGDA,3,RETDT)) G:'RETDT SETGL
 I (RETDT'<BDT)&(RETDT'>EDT) S QD=$P(^PSI(58.1,AOU,1,DRGDA,3,RETDT,0),"^",2),DRGQD=DRGQD-QD,RFLG="Y"
 G RETLP
 ;
SETGL S:DRGQD<1 ^TMP("PSGWNU",$J,AOU,DRGNAME)=AR_"^"_OD_"^"_RFLG_"^"_DRGQD_"^"_DRGNM G DRGLP
 ;
PRTQUE ;AFTER DATA IS COMPILED, QUEUE THE PRINT
 K ZTSAVE,ZTIO S ZTIO=PSGWIO,ZTRTN="^PSGWNU1",ZTDESC="Print Zero Usage",ZTDTH=$H,ZTSAVE("^TMP(""PSGWNU"",$J,")="" F G="BDT","EDT","AOU","SEL","IGDA" S:$D(@G) ZTSAVE(G)=""
 D ^%ZTLOAD K ^TMP("PSGWNU",$J) G END^PSGWNU1
 ;
