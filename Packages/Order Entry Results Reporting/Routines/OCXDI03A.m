OCXDI03A ;SLC/RJS,CLA - OCX PACKAGE DIAGNOSTIC ROUTINES ;SEP 7,1999 at 10:30
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^OCXDIAG
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXDIAG",$J,$O(^TMP("OCXDIAG",$J,"A"),-1)+1)=TEXT
 ;
 G ^OCXDI03B
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"860.2:","860.22:1",6,"E"
 ;;D^Patient allergic to contrast medias: |CONTRAST MEDIA CODE TRANSLATION|
 ;;EOR^
 ;;KEY^860.2:^RECENT BARIUM STUDY
 ;;R^"860.2:",.01,"E"
 ;;D^RECENT BARIUM STUDY
 ;;R^"860.2:","860.21:1",.01,"E"
 ;;D^BARIUM
 ;;R^"860.2:","860.21:1",1,"E"
 ;;D^RECENT BARIUM STUDY ORDERED
 ;;R^"860.2:","860.22:1",.01,"E"
 ;;D^1
 ;;R^"860.2:","860.22:1",1,"E"
 ;;D^BARIUM
 ;;R^"860.2:","860.22:1",2,"E"
 ;;D^RECENT BARIUM STUDY
 ;;R^"860.2:","860.22:1",6,"E"
 ;;D^Recent Barium study: |RECENT BARIUM STUDY TEXT| [|RECENT BARIUM STUDY ORDER STATUS|]
 ;;EOR^
 ;;KEY^860.2:^CLOZAPINE
 ;;R^"860.2:",.01,"E"
 ;;D^CLOZAPINE
 ;;R^"860.2:","860.21:1",.01,"E"
 ;;D^WITH WBC
 ;;R^"860.2:","860.21:1",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:1",1,"E"
 ;;D^CLOZAPINE DRUG SELECTED WITH WBC
 ;;R^"860.2:","860.21:2",.01,"E"
 ;;D^WITHOUT WBC
 ;;R^"860.2:","860.21:2",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:2",1,"E"
 ;;D^CLOZAPINE DRUG SELECTED WITHOUT WBC
 ;;R^"860.2:","860.22:1",.01,"E"
 ;;D^1
 ;;R^"860.2:","860.22:1",1,"E"
 ;;D^WITH WBC
 ;;R^"860.2:","860.22:1",2,"E"
 ;;D^CLOZAPINE APPROPRIATENESS
 ;;R^"860.2:","860.22:1",6,"E"
 ;;D^Clozapine - Most recent WBC result - |RECENT WBC|
 ;;R^"860.2:","860.22:2",.01,"E"
 ;;D^2
 ;;R^"860.2:","860.22:2",1,"E"
 ;;D^WITHOUT WBC
 ;;R^"860.2:","860.22:2",2,"E"
 ;;D^CLOZAPINE APPROPRIATENESS
 ;;R^"860.2:","860.22:2",6,"E"
 ;;D^No WBC past seven days - pharmacy cannot fill clozapine order.  Most recent WBC result: |RECENT WBC|
 ;;EOR^
 ;;KEY^860.2:^AMINOGLYCOSIDE ORDER
 ;;R^"860.2:",.01,"E"
 ;;D^AMINOGLYCOSIDE ORDER
 ;;R^"860.2:","860.21:1",.01,"E"
 ;;D^AGS ORDER
 ;;R^"860.2:","860.21:1",1,"E"
 ;;D^AMINOGLYCOSIDE ORDER SESSION
 ;;R^"860.2:","860.22:1",.01,"E"
 ;;D^1
 ;;R^"860.2:","860.22:1",1,"E"
 ;;D^AGS ORDER
 ;;R^"860.2:","860.22:1",2,"E"
 ;;D^AMINOGLYCOSIDE ORDERED
 ;;R^"860.2:","860.22:1",6,"E"
 ;;D^Aminoglycoside - est. CrCl: |CRCLV| (|FORMATTED RENAL LAB RESULTS|)
 ;;EOR^
 ;;KEY^860.2:^CT OR MRI PHYSICAL LIMIT CHECK
 ;;R^"860.2:",.01,"E"
 ;;D^CT OR MRI PHYSICAL LIMIT CHECK
 ;;R^"860.2:","860.21:1",.01,"E"
 ;;D^TOO BIG
 ;;R^"860.2:","860.21:1",1,"E"
 ;;D^PATIENT OVER CT OR MRI DEVICE LIMITATIONS
 ;;R^"860.2:","860.22:1",.01,"E"
 ;;D^1
 ;;R^"860.2:","860.22:1",1,"E"
 ;;D^TOO BIG
 ;;R^"860.2:","860.22:1",2,"E"
 ;;D^CT & MRI PHYSICAL LIMITATIONS
 ;;R^"860.2:","860.22:1",6,"E"
 ;;D^Patient may be |PATIENT TOO BIG FOR SCANNER TEXT| for the |PATIENT TOO BIG FOR SCANNER DEVICE|.
 ;;EOR^
 ;;KEY^860.2:^CREATININE CLEARANCE ESTIMATION
 ;;R^"860.2:",.01,"E"
 ;;D^CREATININE CLEARANCE ESTIMATION
 ;;R^"860.2:","860.21:1",.01,"E"
 ;;D^CREAT CLEAR
 ;;R^"860.2:","860.21:1",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:1",1,"E"
 ;;D^CREATININE CLEARANCE ESTIMATE
 ;;R^"860.2:","860.21:2",.01,"E"
 ;;D^CREATININE CLEARANCE DATE
 ;;R^"860.2:","860.21:2",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:2",1,"E"
 ;;D^CREATININE CLEARANCE DATE/TIME
 ;;R^"860.2:","860.21:3",.01,"E"
 ;;D^RENAL RESULTS
 ;;R^"860.2:","860.21:3",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:3",1,"E"
 ;;D^RENAL RESULTS
 ;;R^"860.2:","860.22:1",.01,"E"
 ;;D^1
 ;;R^"860.2:","860.22:1",1,"E"
 ;;D^IF CREAT CLEAR AND ( CREATININE CLEARANCE DATE OR RENAL RESULTS )
 ;;R^"860.2:","860.22:1",2,"E"
 ;;D^ESTIMATED CREATININE CLEARANCE
 ;;R^"860.2:","860.22:1",6,"E"
 ;;D^Est. CrCl: |CRCLV| (|FORMATTED RENAL LAB RESULTS|)
 ;;EOR^
 ;;KEY^860.2:^FOOD/DRUG INTERACTION
 ;;R^"860.2:",.01,"E"
 ;;D^FOOD/DRUG INTERACTION
 ;;R^"860.2:","860.21:1",.01,"E"
 ;;D^INPATIENT FOOD DRUG REACTION
 ;;R^"860.2:","860.21:1",1,"E"
 ;;D^INPATIENT FOOD-DRUG REACTION
 ;;R^"860.2:","860.22:1",.01,"E"
 ;;D^1
 ;;R^"860.2:","860.22:1",1,"E"
 ;;D^INPATIENT FOOD DRUG REACTION
 ;;R^"860.2:","860.22:1",3,"E"
 ;;D^FOOD/DRUG INTERACTION
 ;;R^"860.2:","860.22:1",5,"E"
 ;;D^|PHARMACY LOCAL ORDERABLE ITEM TEXT| ordered - adjust diet accordingly.
 ;;EOR^
 ;;KEY^860.2:^GLUCOPHAGE - CONTRAST MEDIA
 ;;R^"860.2:",.01,"E"
 ;;D^GLUCOPHAGE - CONTRAST MEDIA
 ;;R^"860.2:","860.21:1",.01,"E"
 ;;D^PROC USES NON-BARIUM MEDIA
 ;;R^"860.2:","860.21:1",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:1",1,"E"
 ;;D^RADIOLOGY PROCEDURE CONTAINS NON-BARIUM CONTRAST MEDIA
 ;;R^"860.2:","860.21:2",.01,"E"
 ;;D^PATIENT TAKING GLUCOPHAGE
 ;;R^"860.2:","860.21:2",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:2",1,"E"
 ;;D^PATIENT WITH GLUCOPHAGE MED
 ;;R^"860.2:","860.22:1",.01,"E"
 ;;D^1
 ;;R^"860.2:","860.22:1",1,"E"
 ;;D^IF PROC USES NON-BARIUM MEDIA AND PATIENT TAKING GLUCOPHAGE 
 ;;R^"860.2:","860.22:1",2,"E"
 ;;D^GLUCOPHAGE-CONTRAST MEDIA
 ;;R^"860.2:","860.22:1",6,"E"
 ;1;
 ;