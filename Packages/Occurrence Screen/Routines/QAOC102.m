QAOC102 ;HISC/DAD-OCCURRENCE SCREEN AUTO ENROLLMENT ;6/14/93  07:11
 ;;3.0;Occurrence Screen;;09/14/1993
 ;SCREEN 102 -- ADMISSION WITHIN 3 DAYS OF UNSCHEDULED AMBULATORY CARE VISIT
 Q:$$INACTIVE^QAOC0(102)
 S QAODISPL=3600*$P($G(^QA(740,1,"OS")),"^",6)
 F QAOSDT=(QAMTODAY-.0000001):0 S QAOSDT=$O(^DGPM("AMV1",QAOSDT)) Q:QAOSDT'>0!(QAOSDT>(QAMTODAY+.24))!(QAOSDT\1'?7N)  F QAOSDFN=0:0 S QAOSDFN=$O(^DGPM("AMV1",QAOSDT,QAOSDFN)) Q:QAOSDFN'>0  D
 . F QAOSD0=0:0 S QAOSD0=$O(^DGPM("AMV1",QAOSDT,QAOSDFN,QAOSD0)) Q:QAOSD0'>0  S QAOSZERO=$G(^DGPM(QAOSD0,0)) I QAOSZERO]"" D MAIN
 . Q
 Q
MAIN ;
 Q:$$SCHED^QAOC0(QAOSDFN,QAOSDT)
 S INTYP=$P(QAOSZERO,"^",18) Q:INTYP=40
 S SPECDT=+$O(^DGPM("APTT6",QAOSDFN,+QAOSZERO-.0000001))
 S SPECD0=$O(^DGPM("APTT6",QAOSDFN,SPECDT,0))
 S TXSP=$S(SPECD0'>0:"",$D(^DGPM(SPECD0,0))#2:$P(^(0),"^",9),1:"")
 Q:$$TXSP^QAOC0("AS",TXSP)'>0  ; Change "AS" to "ASP" to include psych
 S X1=QAOSDT,X2=-4 D C^%DTC
 S (SV,VIS,REGEND)=X\1_".24",REGEND=9999999-REGEND,FLG=0,QAOVISIT=""
 S QACLINIC=""
 G:'$D(^DPT(QAOSDFN,"S",0)) TYPE2
 F VIS=VIS:0 S VIS=$O(^DPT(QAOSDFN,"S",VIS)) Q:(VIS'>0)!(VIS>QAOSDT)!(VIS\1=(QAOSDT\1))!(VIS\1'?7N)  D:$P(^DPT(QAOSDFN,"S",VIS,0),"^",2)="" LOOP1 Q:FLG
TYPE2 ;
 G:FLG FILE
 ;F SV=SV:0 S SV=$O(^SDV("B",SV)) Q:(SV'>0)!(SV>QAOSDT)!(SV\1=(QAOSDT\1))!(SV\1'?7N)  I $D(^SDV(SV,0)),$P(^(0),"^",2)=QAOSDFN S FLG=1,QAOVISIT=SV Q
TYPE3 ;
 G FILE:FLG,FILE:'$D(^DPT(QAOSDFN,"DIS",0))
 S X1=QAOSDT,X2=-1 D C^%DTC S REG=9999999-(X\1_".24")
 F REG=REG:0 S REG=$O(^DPT(QAOSDFN,"DIS",REG)) Q:(REG'>0)!(REG'<REGEND)!(REG\1'?7N)  D LOOP2 Q:FLG
FILE ;
 D:FLG
 . D VADPT^QAOC0(QAOSDFN,QAOSD0)
 . S WARDCLIN=+VAIP(5)_"^"_$S(QACLINIC:QACLINIC,1:"")
 . S ^UTILITY($J,"QAM CONDITION",QAMD1,QAOSDFN,QAMTODAY)=""
 . S ^UTILITY($J,"QAM FALL OUT",QAMD0,QAOSDFN,QAMTODAY,"WARD")=WARDCLIN
 . S ^UTILITY($J,"QAM FALL OUT",QAMD0,QAOSDFN,QAMTODAY,"TXSP")=+VAIP(8)
 . S ^UTILITY($J,"QAM FALL OUT",QAMD0,QAOSDFN,QAMTODAY,"MVDT")=QAOVISIT
 . S ^UTILITY($J,"QAM FALL OUT",QAMD0,QAOSDFN,QAMTODAY,"DIAG")=VAIP(9)
 . S ^UTILITY($J,"QAM FALL OUT",QAMD0,QAOSDFN,QAMTODAY,"AADM")=VAIP(13)
 . Q
 Q
LOOP1 ;
 S LOC=^DPT(QAOSDFN,"S",VIS,0) I LOC]"",$P(LOC,"^",7)=4 S FLG=1,QAOVISIT=VIS,QACLINIC=+$P(LOC,"^")
 Q
LOOP2 ;
 Q:$D(^DPT(QAOSDFN,"DIS",REG,0))[0  S LOC=^(0) Q:$P(LOC,"^",2)>1
 S OUT=$P(LOC,"^",6) Q:OUT'>0
 S X=QAOSDT D H^%DTC S QAOSH=%H,QAOST=%T,X=OUT
 D H^%DTC S QAOSH=QAOSH-%H,QAOST=QAOST-%T
 S QAOST=QAOST+(86400*QAOSH) ; TIME BETWEEN ADMISSION & LOG OUT
 Q:QAOST<QAODISPL  ; QUIT IF TIME < MIN TIME BETWEEN LOG OUT & ADM
 S FLG=1,QAOVISIT=9999999-REG
 Q
