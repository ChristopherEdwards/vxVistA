PSDACT2 ;BIR/JPW-Print Daily Activity Log (cont'd) ; 2 Aug 94
 ;;3.0; CONTROLLED SUBSTANCES ;**30**;13 Feb 97
PRINT ;prints data
 K LN S (CNT,FLAG,PG,PSDOUT)=0,$P(LN,"-",132)=""
 I '$D(^TMP("PSDACT",$J)) D HDR W !!,?15,"**** NO DAILY ACTIVITY ****",!! G DONE
 S PSDRG="" F  S PSDRG=$O(^TMP("PSDACT",$J,PSDRG)) Q:PSDRG=""!(PSDOUT)  S PG=0 D PAGE Q:PSDOUT  D HDR Q:PSDOUT  S CNT=1 W !,?5,"=> ",PSDRG F PSD=0:0 S PSD=$O(^TMP("PSDACT",$J,PSDRG,PSD)) Q:'PSD!(PSDOUT)  D
 .F TYP=0:0 S TYP=$O(^TMP("PSDACT",$J,PSDRG,PSD,TYP)) Q:'TYP!(PSDOUT)  F PSDA=0:0 S PSDA=$O(^TMP("PSDACT",$J,PSDRG,PSD,TYP,PSDA)) Q:'PSDA!(PSDOUT)  S NODE=^TMP("PSDACT",$J,PSDRG,PSD,TYP,PSDA) D
 ..W:CNT ?115,$P(NODE,"^"),!! S CNT=0,FLAG=1
 ..I $Y+4>IOSL D HDR Q:PSDOUT  W !,?5,"=> ",PSDRG,?115,$P(NODE,"^")
 ..S Y=PSD X ^DD("DD") S DATE=Y
 ..;Dave B (PSD*3*30) Include Returned to stock indicator.
 ..W !,DATE,?22,$P(NODE,"^",2),?45,$P(NODE,"^",3),?95,$J($P(NODE,"^",4),6) W:$P(NODE,"^",6)=1 " (RTS)" W ?115,$P(NODE,"^")+$P(NODE,"^",4),?128,$P(NODE,"^",5)
DONE I $E(IOST)'="C" W @IOF
 I $E(IOST,1,2)="C-",'PSDOUT W ! K DIR,DIRUT S DIR(0)="EA",DIR("A")="END OF REPORT!  Press <RET> to return to the menu" D ^DIR K DIR
END ;
 D KVAR^VADPT
 K %,%DT,%H,%I,%ZIS,ACT,ALL,BFWD,C,CNT,DA,DATE,DIC,DIR,DIROUT,DIRUT,DTOUT,DUOUT,FLAG,LN,MFG,NAOU,NODE,NQTY,NUM
 K PAT,PG,PHARM,POP,PSD,PSDA,PSDATE,PSDED,PSDEV,PSDIO,PSDOUT,PSDPN,PSDR,PSDRG,PSDRGN,PSDS,PSDSD,PSDSN,PSDUZ,PSDUZN,RX,TEXT,TYP,QTY,TYP,TYPE,X,Y,VA("BID"),VA("PID")
 K ^TMP("PSDACT",$J),ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
 Q
HDR ;header
 I $E(IOST,1,2)="C-",PG K DA,DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSDOUT=1 Q
 S PG=PG+1 W:$Y @IOF W !,?20,"Daily Activity Log for ",PSDSN,?115,"Page: ",PG,!,?20,"Date: ",$P(PSDATE,"^")," to ",$P(PSDATE,"^",2),!!
 W "DATE/TIME",?22,"NUMBER",?45,"TYPE OF ACTIVITY",?95,"QUANTITY",?115,"BALANCE",?128,"BY",!,LN,!!
 Q
PAGE ;page stop after each drug
 I $E(IOST,1,2)="C-",FLAG W !! K DA,DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSDOUT=1 Q
 Q
