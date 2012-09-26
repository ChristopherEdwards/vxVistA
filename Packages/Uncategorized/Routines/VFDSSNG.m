VFDSSNG ;DSS/WLC - SSN NUMBER GENERATOR AND MRN UPDATE ; 4/13/09 6:59am
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 Q
QUE ; Queue job
 Q:'$$GET^XPAR("SYS","VFD AUTO-GENERATE MRN")  ;DSS/LM - 11/26/2008
 N ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTIO
 S ZTDESC="Auto-generate MRN",ZTDTH=$H,ZTIO="",ZTRTN="SSN^VFDSSNG"
 S ZTSAVE("DA")=""
 D ^%ZTLOAD
 Q
 ;
 ; Sub-routine to generate MRN's / psuedo-SSN's.
 ; Use current namespace to calculate second digit of number (1st digit always 8),
 ; followed by the DFN padded with zeroes out to 7 digits.
 ; i.e. 840000010 for DFN = 10 on the east coast.
 ;
 ; Namespace 6th piece        Time Zone      SSN digit indicator (piece 2)
 ; -------------------        ---------      -------------------
 ; P                          Pacific        1
 ; M                          Mountain       2
 ; C                          Central        3
 ; E                          Eastern        4
 ;
 ; Logic flow:
 ;
 ;  Variables:
 ;
 ;   PSSN = Patient SSN from PATIENT (#2) file.  (Field .09)
 ;    SSN = generated SSN
 ;    MRN = Patient Alternate ID from sub-file 21600 (Field .02)
 ;
 ;  If PSSN exists:
 ;
 ;     If PSSN = SSN, then no update.
 ;     If 'PSSN, then SSN update.
 ;     If MRN, MRN=SSN, then no MRN update performed.
 ;     If MRN,MRN'=SSN, change MRN type to OMRN, add SSN into Alternate ID sub-file as type MRN.
 ;
SSN ;
 Q:'$$GET^XPAR("SYS","VFD AUTO-GENERATE MRN")  ;DSS/LM - 11/26/2008
 N A,ALTID,B,C,IEN,MFLG,MSG,PSSN,SFLG,SSN,VFDFDA,VFDTZ
 K VFDFDA S SFLG=0
 ; DSS/LM - Default MRN timezone from ^%ZVFD("MRN TZ")
 S A=$E($$CUR^VFDVMOS,7),VFDTZ=$G(^%ZVFD("MRN TZ"))
 I VFDTZ]"",'("^P^M^C^E^"[(U_A_U)) S A=VFDTZ Q:A=""
 ; DSS/LM - End modification
 I "PMCE"'[A Q  ; time-zone not defined in name space
 S B=$F("PMCE",A)-1
 S SSN="8"_B_$E(100000000+DA,3,9),(SFLG,MFLG)=0
 ; DSS/LM - 11/26/2008 Parameterize filing generated MRN to SSN
 I $$GET^XPAR("SYS","VFD AUTO-FILE MRN TO SSN"),SSN'=$$GET1^DIQ(2,DA_",",.09) D
 . S VFDFDA(2,DA_",",.09)=SSN
 . N DA D FILE^DIE(,"VFDFDA","MSG") K VFDFDA
 S MFLG=0
 D:$D(^DPT(DA,21600))  ; check for valid MRN
 . S C=0 F  S C=$O(^DPT(DA,21600,C)) Q:'C  D
 . . S ALTID=$G(^DPT(DA,21600,C,0)) Q:ALTID=""
 . . I $P(ALTID,U,2)=SSN S MFLG=1 Q
 . . I $P(ALTID,U,5)="MRN",$P(ALTID,U,2)'=SSN D
 . . . ;DSS/LM Remove BREAK command from next
 . . . S VFDFDA(2.0216,C_","_DA_",",.04)=0,VFDFDA(2.0216,C_","_DA_",",.05)="OMRN"
 . . . N DA D FILE^DIE(,"VFDFDA","MSG") K VFDFDA
 Q:MFLG
 S IEN="+2,"_DA_","
 S VFDFDA(2.0216,IEN,.01)=+$$SITE^VASITE ;DSS/LM - Changed from '89' 3/3/2009
 S VFDFDA(2.0216,IEN,.02)=SSN
 S VFDFDA(2.0216,IEN,.04)=$$GET^XPAR("SYS","VFD AUTO-MRN IS DEFAULT") ;DSS/LM Changed from '1' 3/3/2009
 S VFDFDA(2.0216,IEN,.05)="MRN"
 D UPDATE^DIE(,"VFDFDA",,"MSG")
 Q
 ;
