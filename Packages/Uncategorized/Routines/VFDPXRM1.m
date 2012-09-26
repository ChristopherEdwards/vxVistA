VFDPXRM1 ;DSS/RAF - PXRM COMPUTED FINDINGS UTILITY ; 10/7/08 11:56am
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
LMP(DFN,TEST,DATE,VALUE,TEXT) ; check length of time since last menstrual period
 ; DFN = PATIENT IDENTIFIER
 ; TEST = return 1 or zero based on true or false
 ; DATE = FM date
 ; VALUE = [optional] display value for reminder
 ; TEXT = [optional] display text
 ;
 ;
 ; In order to interactively test a reminder you must replace TEST with another name
 ; for example, ZTEST or XXX. Somehow, when triggered from the reminder computed finding
 ; the implicit new of TEST doesn't seem to effect the value of TEST being set in this routine
 S (VALUE,TEST)=0,(DATE,TEXT)=""
 N VDATE,IEN
 S VDATE=+$O(^PXRMINDX(120.5,"IP",23,DFN,""),-1) I VDATE>0 D
 .S IEN=$O(^PXRMINDX(120.5,"IP",23,DFN,VDATE,""))
 .S DATE=$$GET1^DIQ(120.5,IEN,1.2,"I",) ;date entered into RATE field
 .S VALUE=$$FMDIFF^XLFDT(DT,DATE,1)
 .I VALUE>0 S TEST=1
 ;
 Q
