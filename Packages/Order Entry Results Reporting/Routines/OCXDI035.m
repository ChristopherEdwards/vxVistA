OCXDI035 ;SLC/RJS,CLA - OCX PACKAGE DIAGNOSTIC ROUTINES ;SEP 7,1999 at 10:30
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
 G ^OCXDI036
 ;
 Q
 ;
DATA ;
 ;
 ;;D^2
 ;;R^"860.3:","860.31:2",1,"E"
 ;;D^RECENT SERUM CREATININE RESULT
 ;;R^"860.3:","860.31:2",2,"E"
 ;;D^GREATER THAN
 ;;R^"860.3:","860.31:2",3,"E"
 ;;D^1.5
 ;;EOR^
 ;;KEY^860.3:^NO CREATININE W/IN 60 DAYS
 ;;R^"860.3:",.01,"E"
 ;;D^NO CREATININE W/IN 60 DAYS
 ;;R^"860.3:",.02,"E"
 ;;D^DATABASE LOOKUP
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^RECENT SERUM CREATININE FLAG
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^LOGICAL FALSE
 ;;EOR^
 ;;KEY^860.3:^SITE FLAGGED FINAL CONSULT RESULT
 ;;R^"860.3:",.01,"E"
 ;;D^SITE FLAGGED FINAL CONSULT RESULT
 ;;R^"860.3:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^FILLER
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^GMRC
 ;;R^"860.3:","860.31:2",.01,"E"
 ;;D^2
 ;;R^"860.3:","860.31:2",1,"E"
 ;;D^REQUEST STATUS (OBR)
 ;;R^"860.3:","860.31:2",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:2",3,"E"
 ;;D^F
 ;;R^"860.3:","860.31:3",.01,"E"
 ;;D^3
 ;;R^"860.3:","860.31:3",1,"E"
 ;;D^SITE FLAGGED RESULT
 ;;R^"860.3:","860.31:3",2,"E"
 ;;D^LOGICAL TRUE
 ;;R^"860.3:","860.31:4",.01,"E"
 ;;D^4
 ;;R^"860.3:","860.31:4",1,"E"
 ;;D^CONTROL CODE
 ;;R^"860.3:","860.31:4",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:4",3,"E"
 ;;D^RE
 ;;EOR^
 ;;KEY^860.3:^STAT CONSULT RESULT
 ;;R^"860.3:",.01,"E"
 ;;D^STAT CONSULT RESULT
 ;;R^"860.3:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^FILLER
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^GMRC
 ;;R^"860.3:","860.31:2",.01,"E"
 ;;D^2
 ;;R^"860.3:","860.31:2",1,"E"
 ;;D^REQUEST STATUS (OBR)
 ;;R^"860.3:","860.31:2",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:2",3,"E"
 ;;D^F
 ;;R^"860.3:","860.31:3",.01,"E"
 ;;D^3
 ;;R^"860.3:","860.31:3",1,"E"
 ;;D^ORDER PRIORITY (ORC)
 ;;R^"860.3:","860.31:3",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:3",3,"E"
 ;;D^S
 ;;R^"860.3:","860.31:4",.01,"E"
 ;;D^4
 ;;R^"860.3:","860.31:4",1,"E"
 ;;D^CONTROL CODE
 ;;R^"860.3:","860.31:4",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:4",3,"E"
 ;;D^RE
 ;;EOR^
 ;;KEY^860.3:^GLUCOPHAGE CREATININE > 1.5
 ;;R^"860.3:",.01,"E"
 ;;D^GLUCOPHAGE CREATININE > 1.5
 ;;R^"860.3:",.02,"E"
 ;;D^DATABASE LOOKUP
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^RECENT GLUCOPHAGE CREATININE RESULT
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^GREATER THAN
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^1.5
 ;;EOR^
 ;;KEY^860.3:^NO GLUCOPHAGE CREATININE
 ;;R^"860.3:",.01,"E"
 ;;D^NO GLUCOPHAGE CREATININE
 ;;R^"860.3:",.02,"E"
 ;;D^DATABASE LOOKUP
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^RECENT GLUCOPHAGE CREATININE FLAG
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^LOGICAL FALSE
 ;;EOR^
 ;;KEY^860.3:^GENERIC QUERY MODE
 ;;R^"860.3:",.01,"E"
 ;;D^GENERIC QUERY MODE
 ;;R^"860.3:",.02,"E"
 ;;D^GENERIC QUERY
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^GENERIC QUERY MODE
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^TEST
 ;;EOR^
 ;;KEY^860.3:^CLOZAPINE ANC < 1.5
 ;;R^"860.3:",.01,"E"
 ;;D^CLOZAPINE ANC < 1.5
 ;;R^"860.3:",.02,"E"
 ;;D^CPRS ORDER PRESCAN
 ;;R^"860.3:","860.31:4",.01,"E"
 ;;D^4
 ;;R^"860.3:","860.31:4",1,"E"
 ;;D^CLOZAPINE ANC W/IN 7 RESULT
 ;;R^"860.3:","860.31:4",2,"E"
 ;;D^LESS THAN
 ;;R^"860.3:","860.31:4",3,"E"
 ;;D^1.5
 ;;R^"860.3:","860.31:5",.01,"E"
 ;;D^5
 ;;R^"860.3:","860.31:5",1,"E"
 ;;D^CLOZAPINE ANC W/IN 7 FLAG
 ;;R^"860.3:","860.31:5",2,"E"
 ;;D^LOGICAL TRUE
 ;;EOR^
 ;;KEY^860.3:^CLOZAPINE ANC >= 1.5
 ;;R^"860.3:",.01,"E"
 ;;D^CLOZAPINE ANC >= 1.5
 ;;R^"860.3:",.02,"E"
 ;;D^CPRS ORDER PRESCAN
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^CLOZAPINE ANC W/IN 7 RESULT
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^GREATER THAN
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^1.499
 ;;R^"860.3:","860.31:2",.01,"E"
 ;;D^2
 ;;R^"860.3:","860.31:2",1,"E"
 ;;D^CLOZAPINE ANC W/IN 7 FLAG
 ;;R^"860.3:","860.31:2",2,"E"
 ;;D^LOGICAL TRUE
 ;;EOR^
 ;;KEY^860.3:^CLOZAPINE DRUG SELECTED
 ;;R^"860.3:",.01,"E"
 ;;D^CLOZAPINE DRUG SELECTED
 ;;R^"860.3:",.02,"E"
 ;;D^CPRS ORDER PRESCAN
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^ORDER MODE
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^SELECT
 ;;R^"860.3:","860.31:2",.01,"E"
 ;;D^2
 ;;R^"860.3:","860.31:2",1,"E"
 ;;D^FILLER
 ;;R^"860.3:","860.31:2",2,"E"
 ;;D^STARTS WITH
 ;;R^"860.3:","860.31:2",3,"E"
 ;;D^PS
 ;;R^"860.3:","860.31:5",.01,"E"
 ;;D^5
 ;;R^"860.3:","860.31:5",1,"E"
 ;;D^CLOZAPINE MED
 ;;R^"860.3:","860.31:5",2,"E"
 ;;D^LOGICAL TRUE
 ;;EOR^
 ;;KEY^860.3:^CLOZAPINE NO ANC W/IN 7 DAYS
 ;;R^"860.3:",.01,"E"
 ;1;
 ;
