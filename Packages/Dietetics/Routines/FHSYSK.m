FHSYSK ; HISC/REL - Purge Old Diet Activities ;2/13/95  13:34 
 ;;5.5;DIETETICS;;Jan 28, 2005
 S X="T-400",%DT="X" D ^%DT S EDT=+Y
D1 W !!,"Purge To: ",$E(EDT,4,5),"-",$E(EDT,6,7),"-",$E(EDT,2,3)," // " R X:DTIME Q:'$T!(X="^")  G:X="" D2 S %DT="EX" D ^%DT Q:U[X!$D(DTOUT)  G:Y<1 D1
 I Y>EDT W *7,!!,"CANNOT PURGE DATA LATER THAN T-400 DAYS!" G D1
 S EDT=+Y
D2 K ZTUCI,ZTDTH,ZTIO,ZTSAVE S ZTRTN="Q1^FHSYSK",ZTREQ="@",ZTSAVE("ZTREQ")="",ZTSAVE("EDT")=""
 W !!,"Request will be Queued."
 S ZTIO="",ZTDESC="Purge Old Dietetic Activities" D ^%ZTLOAD K ZTSK Q
Q1 ; Process Purge
 F FHDFN=0:0 S FHDFN=$O(^FHPT(FHDFN)) Q:FHDFN<1  F ADM=0:0 S ADM=$O(^FHPT(FHDFN,"A",ADM)) Q:ADM<1  S X=$P($G(^DGPM(ADM,0)),"^",17) I X S X=$P($G(^DGPM(+X,0)),"^",1) I X,X<EDT D K0
 F D1="ADLT","ADR","ADRU" S D2="" F K1=0:0 S D2=$O(^FHPT(D1,D2)) Q:D2=""  F FHDFN=0:0 S FHDFN=$O(^FHPT(D1,D2,FHDFN)) Q:FHDFN<1  F ADM=0:0 S ADM=$O(^FHPT(D1,D2,FHDFN,ADM)) Q:ADM<1  I '$D(^FHPT(FHDFN,"A",ADM)) K ^FHPT(D1,D2,FHDFN,ADM)
 K %DT,ADM,D1,D2,FHDFN,DFN,EDT,K1,X,Y Q
K0 K ^FHPT(FHDFN,"A",ADM),^FHPT("ADTF",FHDFN,ADM),^FHPT("AOO",FHDFN,ADM),^FHPT("ASP",FHDFN,ADM) Q
