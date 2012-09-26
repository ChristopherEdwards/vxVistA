ENLBL5 ;(WASH ISC)/DH-Print Bar Coded Equipment Labels ;10.10.97
 ;;7.0;ENGINEERING;**12,16,35,45**;Aug 17, 1993
CMR ;Complete CMR
 S ENERR=0 D STA^ENLBL3 G:ENEQSTA="^" QUIT^ENLBL3
 D EN^ENLBL9 G:$D(DIRUT) EXIT1^ENLBL8
 I '$D(ENEQIO),%<0 G EXIT1^ENLBL8
 S ENLOCSRT=1
CMR1 S DIC="^ENG(6914.1,",DIC(0)="AEMQ" D ^DIC G:Y'>0 EXIT1^ENLBL8 S ENEQDA=+Y
CMR11 W !,"Sort labels by LOCATION" S %=1 D YN^DICN G:%<0 EXIT1^ENLBL8
 I %=0 W !,"Say YES to sort labels by DIVISION, BUILDING, and then by ROOM.",!,"If you say NO, labels will be sorted by Category Stock Number." G CMR11
 S:%=2 ENLOCSRT=0
 S %ZIS("A")="Select BARCODE PRINTER: ",%ZIS("B")="",%ZIS="Q" I $D(ENEQIO),ENEQIO=IO S %ZIS=""
 K IO("Q") D ^%ZIS K %ZIS G:POP EXIT1^ENLBL8
 S ENBCIO=IO,ENBCIOSL=IOSL,ENBCIOF=IOF,ENBCION=ION,ENBCIOST=IOST,ENBCIOST(0)=IOST(0),ENBCIOS=IOS S:$D(IO("S")) ENBCIO("S")=IO("S")
 I $D(IO("Q")) S ZTIO=ION,ZTRTN="CMR2^ENLBL5",ZTSAVE("EN*")="",ZTDESC="Barcode Labels by CMR" D ^%ZTLOAD K ZTSK,IO("Q") G EXIT1^ENLBL8
CMR2 S ENEQBY="CMR "_$P(^ENG(6914.1,ENEQDA,0),U,1)
 I $D(ENEQIO) D OPEN^ENLBL9 I POP G:$D(ZTQUEUED) REQ^ENLBL8 W !,*7,"Companion Printer UNAVAILABLE." D HOLD G EXIT1^ENLBL8
 K ^TMP($J) F I1=0:0 S I1=$O(^ENG(6914,"AD",ENEQDA,I1)) Q:I1'>0  S DA=I1 D STATCK^ENLBL3 I DA]"" D CMRSRT D:'(DA#10) DOTS^ENLBL3
 I $D(^TMP($J)) U ENBCIO D FORMAT^ENLBL7 S I1="" F J1=0:0 S I1=$O(^TMP($J,I1)) Q:I1=""  F DA=0:0 S DA=$O(^TMP($J,I1,DA)) Q:DA'>0  U ENBCIO D NXPRT^ENLBL7 D:$D(ENEQIO) CPRNT^ENLBL9 D:'(DA#10) DOTS^ENLBL3 D BCDT^ENLBL7
 G EXIT^ENLBL8
 ;
CMRSRT I ENLOCSRT=1 D SORT^ENLBL3 Q
 S X=$$GET1^DIQ(6914,DA,18) S:X="" X=0
 S ^TMP($J,X,DA)=""
 Q
 ;
ALL ;By Equipment ID
 S ENERR=0 D STA^ENLBL3 G:ENEQSTA="^" QUIT^ENLBL3
 D EN^ENLBL9 G:$D(DIRUT) EXIT1^ENLBL8
 I '$D(ENEQIO),%<0 G EXIT1^ENLBL8
ALL1 K ENFR,ENTO W !!,"Would you like to specify a range of entries" S %=1 D YN^DICN G:%=2 ALL2 G:%<0 EXIT1^ENLBL8 I %<1 W *7 G ALL1
 S DIC="^ENG(6914,",DIC(0)="AEQN",D="B",DIC("A")="Starting with: " D IX^DIC G:Y'>0 EXIT1^ENLBL8 S ENFR=+Y
 S D="B",DIC("A")="And ending with: ",DIC("S")="I +Y>ENFR" D IX^DIC K DIC("S") G:Y'>0 EXIT1^ENLBL8 S ENTO=+Y
ALL2 I '$D(ENFR) W !,"You have chosen to print labels for the ENTIRE Equipment File.",!,"(All "_$P(^ENG(6914,0),U,3)_" entries.)"
 S ENLOCSRT=1
ALL21 W !,"Sort labels by LOCATION" S %=1 D YN^DICN G:%<0 EXIT1^ENLBL8
 I %=0 W !,"Say YES to sort labels by DIVISION, BUILDING, then by ROOM.",!,"If you say NO, labels will be sorted by EQUIPMENT ID#." G ALL21
 S:%=2 ENLOCSRT=0
 S %ZIS("A")="Select BAR CODE PRINTER: ",%ZIS("B")="",%ZIS="Q" I $D(ENEQIO),ENEQIO=IO S %ZIS=""
 K IO("Q") D ^%ZIS K %ZIS G:POP EXIT1^ENLBL8
 S ENBCIO=IO,ENBCIOSL=IOSL,ENBCIOF=IOF,ENBCION=ION,ENBCIOST=IOST,ENBCIOST(0)=IOST(0),ENBCIOS=IOS S:$D(IO("S")) ENBCIO("S")=IO("S")
 I $D(IO("Q")) K IO("Q") S ZTIO=ION,ZTRTN="ALL3^ENLBL5",ZTSAVE("EN*")="",ZTDESC="All Equipment Labels (Bar Code)" D ^%ZTLOAD K ZTSK G EXIT1^ENLBL8
ALL3 S ENEQBY=$S($D(ENFR):"Equipment ID#: "_ENFR_" to "_ENTO,1:"ENTIRE EQUIPMENT FILE")
 I $D(ENEQIO) D OPEN^ENLBL9 I POP G:$D(ZTQUEUED) REQ^ENLBL8 W !,*7,"Companion Printer UNAVAILABLE." D HOLD G EXIT1^ENLBL8
 K ^TMP($J) S ENDA=$S($D(ENFR):ENFR,1:$O(^ENG(6914,0)))
ALL4 S DA=ENDA D STATCK^ENLBL3 I DA]"" D SORT^ENLBL3 D:'(DA#10) DOTS^ENLBL3
 S ENDA=$O(^ENG(6914,ENDA)) I $D(ENTO),ENDA=+ENDA,ENDA'>ENTO G ALL4
 I ENDA=+ENDA,'$D(ENTO) G ALL4
 I $D(^TMP($J)) U ENBCIO D FORMAT^ENLBL7 S I1="" F J1=0:0 S I1=$O(^TMP($J,I1)) Q:I1=""  F DA=0:0 S DA=$O(^TMP($J,I1,DA)) Q:DA'>0  U ENBCIO D NXPRT^ENLBL7 D:$D(ENEQIO) CPRNT^ENLBL9 D:'(DA#10) DOTS^ENLBL3 D BCDT^ENLBL7
 G EXIT^ENLBL8
 ;
HOLD W !,"Press <RETURN> to continue..." R X:DTIME
 Q
 ;ENLBL5
