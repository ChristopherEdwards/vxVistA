LRRP6 ;DALISC/J0 - LAB TEST/WORKLOAD CODE REPORTS ;12/07/92
 ;;5.2;LAB SERVICE;**201**;Sep 27, 1994
EN ;
 S LREND=0
 D SELECT
 D:'LREND DEVICE
 D:'LREND @ZTRTN
 D WRAPUP
 Q
SELECT ;
 D SITE Q:LREND
 D DIV Q:LREND
 D DATES Q:LREND
 D METHOD Q:LREND
 D ACCAREA Q:LREND
 I ZTRTN="DQ^LRRP6A1" D SETACCN Q:LREND
 D REPTYP Q:LREND
 Q
SITE ;
 S LRSITNUM=+$P($G(^XMB(1,1,"XUS")),U,17)
 I 'LRSITNUM W !!,"NO SITE DEFINED  -- CAN'T REPORT" S LREND=1 Q
 S LRSITE=$P($G(^DIC(4,LRSITNUM,0)),U) S:LRSITE="" LRSITE="UNKNOWN"
 Q
DIV ;
 S %=2 W !,"Do you want to print a specific DIVISION (YES or NO)"
 D YN^DICN
 I %=-1 S LREND=1 Q
 I %=1 D
 . S DIC("A")="Select a Division:",DIC=4,DIC(0)="AEMQ"
 . F  D ^DIC Q:Y=-1  D
 . . S LRDIVSEL=+Y
 . . S LRDIVSEL(+Y)=$S($L($P($G(^DIC(4,+Y,0)),U)):$P(^(0),U),1:"ERROR"_Y)
 I ($D(DTOUT)#2)!(($D(DUOUT)#2)&('$D(LRDIVSEL))) S LREND=1 Q
 Q
DATES ;
 S %DT="AEX",%DT("A")="BEGIN DATE : "
 D ^%DT I (X=U)!(X="") S LREND=1 Q
 S LRSDT=Y
 S LRSDAT=$$Y2K^LRX(Y)
 S %DT="AEX",%DT("A")="END DATE : "
 D ^%DT I (X=U)!(X="") S LREND=1 Q
 S LREDT=Y
 S LREDAT=$$Y2K^LRX(Y)
 I LREDT<LRSDT S X=LREDT,LREDT=LRSDT,LRSDT=X
 S LRSDT=LRSDT-.000001
 S LRDATRNG=LRSDAT_" to "_LREDAT
 Q
METHOD ;
 K DIR S DIR("A",1)="TEST AUDIT should not be used for workload reporting."
 S DIR("A",2)="It should ONLY be used for trouble Shooting.",DIR("A",3)=" "
 S DIR(0)="SM^T:TEST AUDIT (File 68);W:WORKLOAD CODE (File 64.1)",DIR("A")="REPORT BY"
 D ^DIR I ($D(DUOUT))!($D(DTOUT)) S LREND=1 Q
 S ZTRTN=$S(Y="T":"DQ^LRRP6A1",Y="W":"DQ^LRRP6B1")
 K DIR
 Q
ACCAREA ;
 K DIC S DIC=68,DIC(0)="AEMQZ"
 S DIC("A")="Select ACCESSION AREA (required - 1 only): "
 D ^DIC
 I Y=-1 S LREND=1 Q
 S LRX=$P(Y,U,2),LRAA=+Y
 S ACCTRNS=$P(^LRO(68,LRAA,0),U,3)
 Q
SETACCN ;
 ;S LRANL=+$P(^LRO(68,LRAA,1,LRDT,1,0),U,4)
 K DIR
 S DIR(0)="NO^1:999999"
 S DIR("A")="Start with accession #",DIR("B")=1
 D ^DIR I $D(DUOUT)!($D(DTOUT)) S LREND=1 Q
 S:X>0 LRANF=X-1
 S:ACCTRNS="Y" LRDT=$E(LRSDT,1,3)_"0000"
 S:ACCTRNS'="Y" LRDT=$E(LRSDT,1,3)_"00"
 ;S LAST=$P(^LRO(68,LRAA,1,LRDT,1,0),U,4)
 K DIR
 S DIR(0)="NO^1:999999"
 S DIR("A")="End with accession #",DIR("B")=999999
 D ^DIR I $D(DUOUT)!($D(DTOUT)) S LREND=1 Q
 S LRANL=+X
 Q
REPTYP ;
 K DIR S DIR(0)="SM^D:DETAILED;C:CONDENSED",DIR("A")="REPORT TYPE"
 D ^DIR I $D(DUOUT)!($D(DTOUT)) S LREND=1 Q
 S LRREPTYP=Y
 K DIR
 Q
DEVICE ;
 K IOP,IO("Q") S POP=0,%ZIS="QP" D ^%ZIS
 I POP S LREND=1 Q
 I $D(IO("Q")) D QUE S LREND=1 Q
 Q
WRAPUP ;
 W:'LREND !!,?23,"***  END OF REPORT  ***"
 D:($E(IOST,1,2)="C-")&('LREND) PAUSE
 W !! W:$E(IOST,1,2)="P-" @IOF D:'$D(ZTQUEUED) ^%ZISC
 S:$D(ZTQUEUED) ZTREQ="@"
 K ^TMP("LR",$J)
 K DTOUT,DUOUT,DIRUT,DIROUT,X,Y,%,%ZIS,DIC,%Y,%DT,I,POP,DIR
 K ZTIO,ZTRTN,ZTSAVE,ZTDESC,ZTSK,LRAA,LRANN,LRSUM,LRTMULT
 K LREND,LRPAG,LRDT,LRDAT,LRSDT,LREDT,LRSDAT,LREDAT,LRDATRNG,LRX,LRNODE
 K LRTIC,LRANF,LRANL
 K LRDIV,LRDIVNAM,LRDIVSEL,LRFIRST,LRREPTYP,LRTN,LRTST,LRTSTREC,LRTNAM
 K LRSITNUM,LRSITE,LRCC,LRAN,LRCPN,LRDASH,LRSTAR,LRSUBH,LRV657,LRV658
 D WKLDCLN^LRCAPU
 Q
QUE ;
 K IO("Q") I '$D(ZTIO),$D(ION),ION="" S ZTIO=""
 S ZTDESC="LRRP6_ - TEST/WKLD/VENIPUNCTURE REP"
 S ZTSAVE("LR*")="" D ^%ZTLOAD
 Q
PAUSE ;
 K DIR S DIR(0)="E" D ^DIR
 S:($D(DTOUT))!($D(DUOUT)) LREND=1
 Q
