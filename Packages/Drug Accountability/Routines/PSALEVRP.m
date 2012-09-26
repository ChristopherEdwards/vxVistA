PSALEVRP ;BIR/LTL,JMB-Stock and Reorder Report ;7/23/97
 ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**15**; 10/24/97
 ;This routine prints a report of all drugs with their stock and reorder
 ;levels in a pharmacy location.
 ;
 ;References to ^PSDRUG( are covered by IA #2095
 ;
 D LOC G MASTER
 ;
 ;Gets locations
LOC S PSAOUT=0,PSALOC=+$O(^PSD(58.8,"ADISP","P",0))
 I 'PSALOC W !!?5,"No Drug Accountability location has been created yet." S PSAOUT=1 G MASTER
 ;
 ;Collect locations in alpha order
 S (PSACNT,PSALOC)=0 W !
 F  S PSALOC=+$O(^PSD(58.8,"ADISP","P",PSALOC)) Q:'PSALOC  D
 .Q:'$D(^PSD(58.8,PSALOC,0))!($P($G(^PSD(58.8,PSALOC,0)),"^")="")
 .I +$G(^PSD(58.8,PSALOC,"I")),+^PSD(58.8,PSALOC,"I")'>DT Q
 .Q:'$O(^PSD(58.8,PSALOC,1,0))  D SITES^PSAUTL1
 .S PSACNT=PSACNT+1
 .S PSALOCA($P(^PSD(58.8,PSALOC,0),"^")_PSACOMB,PSALOC)=$P(^(0),"^",3)_"^"_$P(^(0),"^",10)_"^"_+$G(^PSD(58.8,PSALOC,"I"))
 S PSACHK=$O(PSALOCA("")) I PSACHK="" G MASTER
 Q:$G(PSAHIS)&(PSACNT=1)
 ;
DISPLOC ;Displays the available pharmacy locations.
 W @IOF,!,"Choose one or many pharmacy locations:",!
 S PSACNT=0,PSALOCN=""
 F  S PSALOCN=$O(PSALOCA(PSALOCN)) Q:PSALOCN=""  D
 .S PSALOC=0 F  S PSALOC=$O(PSALOCA(PSALOCN,PSALOC)) Q:'PSALOC  D
 ..S PSACNT=PSACNT+1,PSAMENU(PSACNT,PSALOCN,PSALOC)=""
 ..W !,$J(PSACNT,2)
 ..W:$L(PSALOCN)>76 ?4,$P(PSALOCN,"(IP)",1)_"(IP)",!?21,$P(PSALOCN,"(IP)",2) W:$L(PSALOCN)<77 ?4,PSALOCN
 ;
SELLOC W ! S DIR(0)="LO^1:"_PSACNT,DIR("A")="Select PHARMACY LOCATION",DIR("?")="Enter the number(s) of the Pharmacy Location",DIR("??")="^D HELP^PSAUTL3"
 D ^DIR K DIR I $G(DTOUT)!($G(DUOUT)) S PSAOUT=1 G EXIT
 Q:Y=""&('$G(PSAHIS))  I Y="",$G(PSAHIS) S PSAOUT=1 Q
 S PSASEL=Y
 F PSAPC=1:1 S PSANUM=+$P(PSASEL,",",PSAPC) Q:'PSANUM  D
 .S PSALOCN=$O(PSAMENU(PSANUM,"")),PSALOC=$O(PSAMENU(PSANUM,PSALOCN,0))
 .S PSALOC(PSALOCN,PSALOC)=PSALOCA(PSALOCN,PSALOC)
 ;
 S PSACHK=$O(PSALOC(""))
 I PSACHK="",'PSALOC W !,"There are no active pharmacy locations." G EXIT1
 W ! S PSALOCN="" F  S PSALOCN=$O(PSALOC(PSALOCN)) Q:PSALOCN=""!(PSAOUT)  S PSALOC=0 F  S PSALOC=$O(PSALOC(PSALOCN,PSALOC)) Q:'PSALOC!(PSAOUT)  D
 .I '$O(^PSD(58.8,PSALOC,1,0)) D
 ..W:$L(PSALOCN)>79 !!,$P(PSALOCN,"(IP)",1)_"(IP)",!!?17,$P(PSALOCN,"(IP)",2) W:$L(PSALOCN)<80 !!,PSALOCN
 ..W !,"There are no drugs in the pharmacy location."
 Q
 ;
MASTER G:'$D(^XUSEC("PSA ORDERS",DUZ)) TEST S (PSAMVN,PSAMV)=0
 F  S PSAMV=+$O(^PSD(58.8,"ADISP","M",PSAMV)) Q:'PSAMV  D
 .I +$G(^PSD(58.8,PSAMV,"I")),+^PSD(58.8,PSAMV,"I")'>DT Q
 .S PSAMVN=PSAMVN+1,PSAMV($P(^PSD(58.8,PSAMV,0),"^"),PSAMV)=""
 G:'PSAMVN TEST
 ;
DISPMV ;Displays active master vaults
 W @IOF,!,"Choose one or many master vaults:",!
 S PSA=0,PSAMVA="" F  S PSAMVA=$O(PSAMV(PSAMVA)) Q:PSAMVA=""  D
 .S PSAMV=0 F  S PSAMV=$O(PSAMV(PSAMVA,PSAMV)) Q:'PSAMV  D
 ..S PSA=PSA+1,PSAVAULT(PSA,PSAMVA,PSAMV)="" W !,$J(PSA,2)_".",?4,PSAMVA
 K PSAMV
 ;
SELMV ;Select displayed master vaults
 W ! S DIR(0)="LO^1:"_PSA,DIR("A")="Select Master Vault",DIR("?")="Select the Master Vault that received the invoice's drugs",DIR("??")="^D MV^PSAPROC"
 D ^DIR K DIR I $G(DTOUT)!($G(DUOUT)) S PSAOUT=1 Q
 G:Y="" TEST S PSASEL=Y
 F PSAPC=1:1 S PSA=+$P(PSASEL,",",PSAPC) Q:'PSA  D
 .S PSAMVA="",PSAMVA=$O(PSAVAULT(PSA,PSAMVA)) Q:PSAMVA=""
 .S PSAMVIEN=+$O(PSAVAULT(PSA,PSAMVA,0)) Q:'PSAMVIEN
 .S PSAMAST(PSAMVA,PSAMVIEN)=""
 K PSAVAULT
 ;
TEST G:PSAOUT EXIT
 S PSA=$O(PSALOC("")),PSAMV=$O(PSAMAST(""))
 I PSA="",PSAMV="" G EXIT
 ;
DEV ;Asks device & queueing info
 W !!,"Each pharmacy location can contain all drugs in the DRUG file. Therefore,",!,"this report could be very long. It is advised to queue the report to run",!,"during non-critical hours.",!
 K IO("Q") K %ZIS,IOP,POP S %ZIS="Q",%ZIS("B")=""
 D ^%ZIS I POP W !,"NO DEVICE SELECTED OR OUTPUT PRINTED!" Q
 I $D(IO("Q")) D  G EXIT
 .N ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTDTH,ZTSK
 .S ZTRTN="COMPILE^PSALEVRP",ZTDESC="Drug Acct. - Stock and Reorder Report"
 .S:PSA'="" ZTSAVE("PSALOC(")="" S:PSAMV'="" ZTSAVE("PSAMAST(")=""
 .D ^%ZTLOAD
 ;
COMPILE ;Compiles data
 S PSA=$O(PSALOC("")) G:PSA="" MV
 S PSALOCN="" F  S PSALOCN=$O(PSALOC(PSALOCN)) Q:PSALOCN=""  D
 .S PSALOC=0 F  S PSALOC=$O(PSALOC(PSALOCN,PSALOC)) Q:'PSALOC  D
 ..S PSADRG=0 F  S PSADRG=+$O(^PSD(58.8,PSALOC,1,PSADRG)) Q:'PSADRG  D
 ...Q:'$D(^PSD(58.8,PSALOC,1,PSADRG,0))!($P($G(^PSDRUG(PSADRG,0)),"^")="")
 ...S ^TMP("PSALEV",$J,1,PSALOC,$P(^PSDRUG(PSADRG,0),"^"))=+$P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",3)_"^"_+$P(^(0),"^",5)
 ;
MV S PSA=$O(PSAMAST("")) G:PSA="" PRINT
 S PSAMVN="" F  S PSAMVN=$O(PSAMAST(PSAMVN)) Q:PSAMVN=""  D
 .S PSAMV=0 F  S PSAMV=$O(PSAMAST(PSAMVN,PSAMV)) Q:'PSAMV  D
 ..S PSADRG=0 F  S PSADRG=+$O(^PSD(58.8,PSAMV,1,PSADRG)) Q:'PSADRG  D
 ...Q:'$D(^PSD(58.8,PSAMV,1,PSADRG,0))!($P($G(^PSDRUG(PSADRG,0)),"^")="")
 ...S ^TMP("PSALEV",$J,2,PSAMV,$P(^PSDRUG(PSADRG,0),"^"))=+$P(^PSD(58.8,PSAMV,1,PSADRG,0),"^",3)_"^"_+$P(^(0),"^",5)
 ;
PRINT ;Prints report
 D NOW^%DTC S PSARUN=%,PSARUN=$E(PSARUN,4,5)_"/"_$E(PSARUN,6,7)_"/"_$E(PSARUN,2,3)_"@"_$E($P(PSARUN,".",2),1,2)_":"_$E($P(PSARUN,".",2),3,4)
 S PSAPG=0,PSASLN="",$P(PSASLN,"-",80)="",PSAOUT=0 K Y
 S PSAFIRST=1,PSALOC=0 F  S PSALOC=+$O(^TMP("PSALEV",$J,1,PSALOC)) Q:'PSALOC!(PSAOUT)  D
 .D SITES^PSAUTL1 S PSALOCN=$P(^PSD(58.8,PSALOC,0),"^")_PSACOMB
 .I PSAFIRST D HDR Q:PSAOUT  S PSAFIRST=0
 .S PSADRG="" F  S PSADRG=$O(^TMP("PSALEV",$J,1,PSALOC,PSADRG)) Q:PSADRG=""!(PSAOUT)  D
 ..I $Y+5>IOSL D HDR Q:PSAOUT
 ..S PSASTOCK=$P(^TMP("PSALEV",$J,1,PSALOC,PSADRG),"^"),PSAREORD=$P(^(PSADRG),"^",2)
 ..W !,PSADRG
 ..W ?(45-$L($P(PSASTOCK,".",2))),$J(PSASTOCK,9,+$L($P(PSASTOCK,".",2)))
 ..W ?(67-$L($P(PSAREORD,".",2))),$J(PSAREORD,9,+$L($P(PSAREORD,".",2)))
 ;
 S PSA=$O(^TMP("PSALEV",$J,2,"")) G:PSA="" EXIT
 S PSAFIRST=1,PSAMV=0
 F  S PSAMV=+$O(^TMP("PSALEV",$J,2,PSAMV)) Q:'PSAMV!(PSAOUT)  D  S PSAFIRST=1
 .I PSAFIRST D HDR Q:PSAOUT  S PSAFIRST=0
 .S PSADRG="" F  S PSADRG=$O(^TMP("PSALEV",$J,2,PSAMV,PSADRG)) Q:PSADRG=""!(PSAOUT)  D
 ..I $Y+5>IOSL D HDR Q:PSAOUT
 ..S PSASTOCK=$P(^TMP("PSALEV",$J,2,PSAMV,PSADRG),"^"),PSAREORD=$P(^(PSADRG),"^",2)
 ..W !,PSADRG
 ..W ?(45-$L($P(PSASTOCK,".",2))),$J(PSASTOCK,9,+$L($P(PSASTOCK,".",2)))
 ..W ?(67-$L($P(PSAREORD,".",2))),$J(PSAREORD,9,+$L($P(PSAREORD,".",2)))
 I 'PSAOUT,$E(IOST,1,2)="C-" S PSAOUT=1 D END^PSAPROC G:PSAOUT EXIT1
 ;
EXIT W:$E(IOST,1,2)="C-" @IOF D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
EXIT1 K IO("Q"),^TMP("PSALEV",$J)
 K %,%ZIS,DIR,DTOUT,DUOUT,PSA,PSACHK,PSACNT,PSACOMB,PSADRG,PSAFIRST,PSAISIT,PSAISITN,PSALOC,PSALOCA,PSALOCN,PSAMAST,PSAMENU,PSAMV,PSAMVA,PSAMVIEN,PSAMVN
 K PSANUM,PSAOSIT,PSAOSITN,PSAOUT,PSAPC,PSAPG,PSAREORD,PSARUN,PSASEL,PSASLN,PSASTOCK,PSAVAULT,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 Q
 ;
HDR ;Report header
 I $E(IOST,1,2)="C-" W:'PSAPG @IOF D:+PSAPG END^PSAPROC Q:PSAOUT
 I $E(IOST)'="C",+PSAPG W @IOF
 S PSAPG=PSAPG+1
 W !?20,"DRUG ACCOUNTABILITY/INVENTORY INTERFACE",?72,"PAGE "_PSAPG
 W !?25,"STOCK AND REORDER LEVEL REPORT",!
 I $E(IOST)'="C" W "RUN: "_PSARUN
 I $G(PSALOC) W ?31,"PHARMACY LOCATION" W:$L(PSALOCN)>79 !!,$P(PSALOCN,"(IP)",1)_"(IP)",!!?17,$P(PSALOCN,"(IP)",2) W:$L(PSALOCN)<80 !!,PSALOCN
 I $G(PSAMV) W !,"MASTER VAULT: "_$P($G(^PSD(58.8,PSAMV,0)),"^")
 W !!,"DRUG",?43,"STOCK LEVEL",?63,"REORDER LEVEL",!,PSASLN
 Q
