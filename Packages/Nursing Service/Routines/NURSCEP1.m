NURSCEP1 ;HIRMFO/JH/MH-LIST STAFF (#210) FILE DISCREPANCIES - CONT. ;7/15/97
 ;;4.0;NURSING SERVICE;**6**;Apr 25, 1997
 S (NURSDA,NURTYPE)=0
 F  S NURSDA=$O(^TMP("NURS",$J,"L",NURSDA)) Q:NURSDA'>0!(NUROUT)  S NAME="" F  S NAME=$O(^TMP("NURS",$J,"L",NURSDA,NAME)) Q:NAME=""  S NUM=^(NAME) D:'NSW1!($Y>(IOSL-6)) HDR Q:$G(NUROUT)  W !,NURSDA,?10,NAME D WRT Q:$G(NUROUT)  W !
 I $E(IOST)="C",$D(^TMP("NURS",$J)) D ENDPG^NURSUT1 Q:$G(NUROUT)
 S (NSW1,NAM)=0,NURTYPE=1
 F  S NAM=$O(^TMP("NURP",$J,NAM)) Q:NAM'>0!(NUROUT)  S NOD=0 F  S NOD=$O(^TMP("NURP",$J,NAM,NOD)) Q:NOD'>0  S NDA=0 F  S NDA=$O(^TMP("NURP",$J,NAM,NOD,NDA)) Q:NDA'>0  S NURX=^TMP("NURP",$J,NAM,NOD,NDA) D PRINT Q:$G(NUROUT)
 I $E(IOST)="C",$D(^TMP("NURP",$J)) D ENDPG^NURSUT1 Q:$G(NUROUT)
 S (NSW1,NAM)=0,NURTYPE=2
 F  S NAM=$O(^TMP("NOSTAFF",$J,NAM)) Q:NAM'>0!(NUROUT)  S NOD=0 F  S NOD=$O(^TMP("NOSTAFF",$J,NAM,NOD)) Q:NOD'>0  S NDA=0 F  S NDA=$O(^TMP("NOSTAFF",$J,NAM,NOD,NDA)) Q:NDA'>0  S NURX=^(NDA) D PRINT Q:$G(NUROUT)
 I $E(IOST)="C",$D(^TMP("NOSTAFF",$J)) D ENDPG^NURSUT1 Q:$G(NUROUT)
 S (NSW1,NAM)=0,NURTYPE=3
 F  S NAM=$O(^TMP("INACT",$J,NAM)) Q:NAM'>0!(NUROUT)  S NOD=0 F  S NOD=$O(^TMP("INACT",$J,NAM,NOD)) Q:NOD'>0  S NDA=0 F  S NDA=$O(^TMP("INACT",$J,NAM,NOD,NDA)) Q:NDA'>0  S NURX=^(NDA) D PRINT Q:$G(NUROUT)
 Q
WRT ;
 I $Y>(IOSL-6) D HDR Q:$G(NUROUT)
 S SW=0 F  S SW=$O(^TMP("NURS",$J,"L1",NUM,SW)) Q:SW'>0  D
 .  I SW=1 W !?6,"STAFF RECORD HAS NO CORRESPONDING NEW PERSON (#200) FILE ENTRY."
 .  I SW=2 W !?6,"STAFF RECORD CONTAINS MISSING/INVALID DATA IN NAME FIELD."
 .  I SW=3 W !?6,"STAFF RECORD CONTAINS MISSING/INVALID STATUS DATA."
 .  I SW=4 W !?6,"STAFF RECORD MISSING THE `B' INDEX ENTRY."
 .  I SW=5 W !?6,"STAFF RECORD HAS ACTIVE STATUS AND NO CURRENT FILE 211.8 ASSIGNMENT(S)."
 .  I SW=6 W !?6,"STAFF RECORD HAS `B' INDEX ENTRY AND NO DATA ON ZEROTH NODE."
 .  Q
 Q
PRINT ; WRITE POSITION CONTROL REPORT DETAIL LINE
 I 'NSW1!($Y>(IOSL-6)) D HDR Q:$G(NUROUT)
 W:'(NURTYPE=3) !,NOD_",1,"_NDA_",0)" W:$G(NURTYPE)=3 !,$P($G(^VA(200,+NAM,0)),U) W:'(NURTYPE=3) ?15,$P($G(^VA(200,+NAM,0)),U) W ?40,$P(NURX,U),?53,$E($P(NURX,U,2),1,10),?65,$P(NURX,U,3),?72,$P(NURX,U,4)
 Q
STAT(NOD) ; DETERMINE IF THE NURSING LOCATION IS ACTIVE BASED ON A NURS
 ; POSITION CONTROL FILE POINTER (NOD)
 N NURSTAT
 S NURSTAT=0,NPWARD=+$G(^NURSF(211.8,NOD,0)) D EN7^NURSAUTL Q:$G(NPWARD)=""
 S NURLOC="NUR "_NPWARD,SCDA=$O(^SC("B",NURLOC,0)),NURDA=$O(^NURSF(211.4,"B",+SCDA,0))
 I $G(^NURSF(211.4,+NURDA,"I"))="I" S NURSTAT=1
 Q NURSTAT
HDR I NSW1,'NURQUEUE,'$G(NUROUT),$E(IOST)="C" D ENDPG^NURSUT1 I $G(NUROUT) Q
 S NURPAGE=(NURPAGE+1) W:$E(IOST)="C"!(NURPAGE>1) @IOF
 W "NURS POSITION CONTROL/NURS STAFF File Integrity Report  " S X="T" D ^%DT D:+Y D^DIQ W ?57,Y,?71," PAGE: ",NURPAGE
 I NURTYPE=0 W !,"RECORD#",?12,"NAME",!,?6,"DISCREPANCY"
 I NURTYPE=1!(NURTYPE=2)!(NURTYPE=3) W:NURTYPE=1!(NURTYPE=2) !,"GLOBAL REF." W:NURTYPE=3 !,"NAME" W:'(NURTYPE=3) ?15,"NAME" W ?40,"POSITION",?53,"UNIT",?64,"FTEE",?70,"START DATE"
 W !,$$REPEAT^XLFSTR("-",80)
 I NURTYPE=1 W !!,"The following assignments are duplicates in the NURS Position Control (211.8)",!,"File. To deactivate a specific assignment use the global root ^NURSF(211.8,",!,"and the global reference indicated for that assignment:",!!
 I NURTYPE=2 W !!,"The following assignments have no corresponding Nurs Staff (#210) File entry.",!,"To remove the assignment use the global root ^NURSF(211.8, and the global",!,"reference indicated for that assignment:",!!
 I NURTYPE=3 W !!,"The following active employees are assigned to inactive nursing locations.",!,"To deactivate or edit a specific assignment use the Status and Position Option",!,"[NURAED-STF-STAT/POS] of the Staff Record Edit",!!
 S NSW1=1
 Q
