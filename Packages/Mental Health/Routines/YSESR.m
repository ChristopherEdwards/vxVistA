YSESR ;SLC/DCM-MAIN MENU FOR RUNNING A DECISION SUPPORT ALGORITHM ; 12/2/88  14:30 ;
 ;;5.01;MENTAL HEALTH;;Dec 30, 1994
 ;DECISION EXPERT SYSTEM (VERSION 1.0) FOR MENTAL HEALTH PACKAGE - DWIGHT MCDANIEL / REGION 5 ISC, SLC
 ;
 ; Called by routine YSESL
E S OPT="",ESDBP="^YS(628,",DIC=ESDBP,ESDBP1=ESDBP_"""B"","
MEN W @IOF,!,$E(STR,1,20),"  AVAILABLE DECISION SUPPORT SYSTEMS  ",$E(STR,1,20),!,"**",?76,"**",!
 S ESI="" W "** " F ESJ=0:1 S ESI=$O(@(ESDBP1_Q_ESI_Q_")")) Q:ESI=""  W ESI,?41 W:ESJ#2 ?76,"**",!,"** "
 W ?76,"**",!,$E(STR,1,20),"  AVAILABLE DECISION SUPPORT SYSTEMS  ",$E(STR,1,20),!
 S DIC(0)="AEMQZ",DIC("A")="Select an Algorithm: " D ^DIC G:Y=-1 ^YSESM S GN=$P(Y,U),A5ASYS=$P(Y(0),U)
 G:Y=-1 ^YSESM D ^YSESD
 G E
