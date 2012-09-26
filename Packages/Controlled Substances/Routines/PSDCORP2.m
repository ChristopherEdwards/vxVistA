PSDCORP2 ;BIR/JPW-CS Correction Log Deleted Green Sheets ; 2 Aug 94
 ;;3.0; CONTROLLED SUBSTANCES ;;13 Feb 97
START ;
 K ^TMP("PSDCOR2",$J)
 F PSD=PSDSD:0 S PSD=$O(^PSD(58.87,"AC",TYPE,PSDS,PSD)) Q:'PSD!(PSD>PSDED)  F PSDA=0:0 S PSDA=$O(^PSD(58.87,"AC",TYPE,PSDS,PSD,PSDA)) Q:'PSDA  I $D(^PSD(58.87,PSDA,0)) D
 .S NODE=^PSD(58.87,PSDA,0),PSDPN=$S($P(NODE,"^",4)]"":$P(NODE,"^",4),1:"UNKNOWN")
 .S DRUG=+$P(NODE,"^",5),DRUGN=$S($P($G(^PSDRUG(DRUG,0)),"^")]"":$P(^(0),"^"),1:"DRUG NAME MISSING")
 .S NAOU=+$P(NODE,"^",6),NAOUN=$S($P($G(^PSD(58.8,NAOU,0)),"^")]"":$P(^(0),"^"),1:"NAOU NAME MISSING")
 .S TECH=+$P(NODE,"^",10),TECHN=$S($P($G(^VA(200,TECH,0)),"^")]"":$P(^(0),"^"),1:"UNKNOWN")
 .S PHARM=+$P(NODE,"^",3),PHARMN=$S($P($G(^VA(200,PHARM,0)),"^")]"":$P(^(0),"^"),1:"UNKNOWN") I PHARMN'="UNKNOWN" S PHARMN=$P(PHARMN,",")_","_$E($P(PHARMN,",",2))
 .S Y=PSD X ^DD("DD") S PSDT=Y
 .S ^TMP("PSDCOR2",$J,NAOUN,PSDPN,PSDA)=DRUGN_"^"_PSDT_"^"_PHARMN_"^"_TECHN
PRINT ;prints log
 K LN S (PG,PSDOUT)=0,$P(LN,"-",132)="" D NOW^%DTC S Y=+$E(%,1,12) X ^DD("DD") S RPDT=Y
 I '$D(^TMP("PSDCOR2",$J)) D HDR W !!,?20,"** NO GREEN SHEET DELETIONS REPORTED FROM ",$P(PSDATE,"^")," TO ",$P(PSDATE,"^",2)," **",!! G DONE
 D HDR S PSD="" F  S PSD=$O(^TMP("PSDCOR2",$J,PSD)) Q:PSD=""!(PSDOUT)  W !,?5,"=> ",PSD,! D
 .S NUM="" F  S NUM=$O(^TMP("PSDCOR2",$J,PSD,NUM)) Q:NUM=""!(PSDOUT)  F JJ=0:0 S JJ=$O(^TMP("PSDCOR2",$J,PSD,NUM,JJ)) Q:'JJ!(PSDOUT)  D
 ..S NODE=^TMP("PSDCOR2",$J,PSD,NUM,JJ)
 ..I $Y+4>IOSL D HDR Q:PSDOUT  W !,?5,"=> ",PSD,!!
 ..W NUM,?12,$P(NODE,"^"),?54,$P(NODE,"^",2),?76,$P(NODE,"^",3),?100,$P(NODE,"^",4),!
DONE I $E(IOST)'="C" W @IOF
 I $E(IOST,1,2)="C-",'PSDOUT W ! K DIR,DIRUT S DIR(0)="EA",DIR("A")="END OF REPORT!  Press <RET> to return to the menu" D ^DIR K DIR
END K %,%DT,%H,%I,C,DA,DIC,DIE,DIR,DIROUT,DIRUT,DR,DRUG,DRUGN,DTOUT,DUOUT,IO("Q"),JJ,LN
 K NAOU,NAOUN,NODE,NUM,PHARM,PHARMN,PG,POP,PSD,PSDA,PSDATE,PSDED,PSDEV,PSDPN,PSDOUT,PSDOUT,PSDS,PSDSD,PSDSN,PSDT,RPDT,TECH,TECHN,TYPE,X,Y
 K ^TMP("PSDCOR2",$J),ZTDESC,ZTIO,ZTRTN,ZTSAVE D ^%ZISC
 D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
 Q
HDR ;header for log
 I $E(IOST,1,2)="C-",PG W ! K DA,DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSDOUT=1 Q
 S PG=PG+1 W:$Y @IOF W !,?25,"CS CORRECTION LOG - DELETED GREEN SHEETS",?115,"Page: ",PG,!,?25,"Report Range ",$P(PSDATE,"^")," to ",$P(PSDATE,"^",2),!,?25,"Report Printed: ",RPDT,!
 W !!,?5,"=> NAOU",!,?57,"DATE",?74,"CORRECTED BY"
 W !,"DISP #",?12,"DRUG",?54,"CORRECTED",?75,"PHARMACIST",?100,"ENTERED BY PHARMACIST",!,LN,!
 Q
