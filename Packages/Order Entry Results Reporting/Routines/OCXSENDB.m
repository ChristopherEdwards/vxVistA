OCXSENDB ;SLC/RJS,CLA - BUILD RULE TRANSPORTER ROUTINES (Get List of Objects to Transport  continued) ;8/04/98  13:21
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,105,143**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
 ;
DIC(OCXDIC,OCXDIC0,OCXDICA,OCXX,OCXDICS,OCXW) ;
 ;
 N DIC,X,Y
 S DIC=$G(OCXDIC) Q:'$L(DIC) -1
 S DIC(0)=$G(OCXDIC0) S:$L($G(OCXX)) X=OCXX
 S:$L($G(OCXDICS)) DIC("S")=OCXDICS
 S:$L($G(OCXDICA)) DIC("A")=OCXDICA
 S:$L($G(OCXW)) DIC("W")=OCXW
 D ^DIC Q:(Y<1) 0 Q Y
 ;
CHECK(FILE,VALUE) ;
 ;
 N IEN,OCXID
 Q:'$L(VALUE)
 I (VALUE[U),VALUE S VALUE=+VALUE
 I (VALUE=+VALUE) S IEN=VALUE
 E  S IEN=+$$DIC(FILE,"XM","",VALUE)
 I 'IEN W !!,$P(^OCXS(FILE,0),U,1)," -1-> ",VALUE,"  [",IEN,"]  ERROR - RECORD NOT FOUND" Q
 I '$D(^OCXS(FILE,IEN)) W !!,$P(^OCXS(FILE,0),U,1)," -2-> ",VALUE," [",IEN,"]  ERROR - RECORD NOT FOUND" Q
 D ADDREC^OCXSEND1(FILE,IEN)
 Q
 ;
8602 ; ORDER CHECK RULE
 ;
 N D0,MSG,PIEC
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"C",D0)) Q:'D0  D  ; TRUTH ELEMENTS multiple
 .D CHECK(860.3,$P($G(^OCXS(FILE,REC,"C",D0,0)),U,2)) ; ELEMENT NAME
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"R",D0)) Q:'D0  D  ; RELATION ACTIONS multiple
 .S MSG=$G(^OCXS(FILE,REC,"R",D0,"MSG"))
 .I (MSG["|") F PIEC=2:2:$L(MSG,"|")  D CHECK(860.4,$P(MSG,"|",PIEC))
 .S MSG=$G(^OCXS(FILE,REC,"R",D0,"OCMSG"))
 .I (MSG["|") F PIEC=2:2:$L(MSG,"|")  D CHECK(860.4,$P(MSG,"|",PIEC))
 ;
 Q
 ;
8603 ; ORDER CHECK ELEMENT
 ;
 N D0,OPER,TERM
 ;
 D CHECK(860.6,$P($G(^OCXS(FILE,REC,0)),U,2)) ; ELEMENT CONTEXT
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"COND",D0)) Q:'D0  D  ; CONDITIONAL EXPRESSION multiple
 .D CHECK(860.4,$P($G(^OCXS(FILE,REC,"COND",D0,"DFLD1")),U,1)) ; DATA FIELD 1
 .D CHECK(863.9,$G(^OCXS(FILE,REC,"COND",D0,"OPER"))) ; OPERATOR/FUNCTION
 .D CHECK(860.4,$G(^OCXS(FILE,REC,"COND",D0,"DFLD2"))) ; DATA FIELD 2
 .D CHECK(860.4,$P($G(^OCXS(FILE,REC,"COND",D0,"DFLD3")),U,1)) ; DATA FIELD 3
 .;
 .S OPER=$G(^OCXS(FILE,REC,"COND",D0,"OPER")) Q:'OPER
 .S OPER=$P($G(^OCXS(863.9,+OPER,0)),U,1) Q:'(OPER["TERM")
 .S TERM=$G(^OCXS(FILE,REC,"COND",D0,"VAL1"))
 .D CHECK(860.9,TERM)
 ;
 Q
 ;
8604 ; ORDER CHECK DATA FIELD
 ;
 N D0
 ;
 D CHECK(864.1,$P($G(^OCXS(FILE,REC,0)),U,3)) ; DATATYPE
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"LINK",D0)) Q:'D0  D  ; DATA SOURCES multiple
 .D CHECK(860.6,$P($G(^OCXS(FILE,REC,"LINK",D0,0)),U,1)) ; DATA CONTEXT
 .D CHECK(860.5,$P($G(^OCXS(FILE,REC,"LINK",D0,0)),U,2)) ; DATA SOURCE
 .D CHECK(863.3,$G(^OCXS(FILE,REC,"LINK",D0,"DATAPATH"))) ; LINK
 ;
 Q
 ;
8605 ; ORDER CHECK DATA SOURCE
 ;
 N D0
 ;
 D CHECK(860.6,$P($G(^OCXS(FILE,REC,0)),U,2)) ; CONTEXT
 Q
 ;
8608 ; ORDER CHECK COMPILER FUNCTIONS
 ;
 N D0,TEXT,PIEC,CALL
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"CODE",D0)) Q:'D0  D  ; CODE multiple
 .S TEXT=$G(^OCXS(FILE,REC,"CODE",D0,0))
 .;
 .I (TEXT["$$") F PIEC=2:1:$L(TEXT,"$$")  D
 ..S CALL=$P($P(TEXT,"$$",PIEC),"(",1) Q:'$L(CALL)  Q:(CALL[U)
 ..D CHECK(860.8,CALL)
 ;
 Q
 ;
863 ; OCX MDD CLASS
 ;
 N D0
 ;
 D CHECK(863,$P($G(^OCXS(FILE,REC,0)),U,3)) ; PARENT CLASS
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .D CHECK(863.8,$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)) ; PARAMETER
 ;
 Q
 ;
8631 ; OCX MDD APPLICATION
 ;
 N D0
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .D CHECK(863.8,$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)) ; PARAMETER NAME
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"SUBJ",D0)) Q:'D0  D  ; PRIMARY SUBJECT multiple
 .D CHECK(863.2,$P($G(^OCXS(FILE,REC,"SUBJ",D0,0)),U,1)) ; PRIMARY SUBJECT
 ;
 Q
 ;
8632 ; OCX MDD SUBJECT
 ;
 N D0
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .D CHECK(863.8,$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)) ; PARAMETER NAME
 ;
 Q
 ;
8633 ; OCX MDD LINK
 ;
 N D0
 ;
 D CHECK(863.2,$P($G(^OCXS(FILE,REC,0)),U,2)) ; PARENT SUBJECT
 D CHECK(863.2,$P($G(^OCXS(FILE,REC,0)),U,3)) ; DESCENDANT SUBJECT
 D CHECK(863.4,$P($G(^OCXS(FILE,REC,0)),U,5)) ; ATTRIBUTE
 ;
 S FCPARM=$O(^OCXS(863.8,"B","OCXO EXTERNAL FUNCTION CALL",0))
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .N PARM,PIEC
 .S PARM=$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1) ; PARAMETER NAME
 .D CHECK(863.8,PARM) ; PARAMETER NAME
 .S PARMV=$G(^OCXS(FILE,REC,"PAR",D0,"VAL")) ; PARAMETER NAME
 .Q:'(PARM=FCPARM)
 .I '($P(PARMV,"(")[U) D CHECK(860.8,$P(PARMV,"(",1))
 .I (PARMV["|") F PIEC=2:2:$L(PARMV,"|")  D CHECK(860.4,$P(PARMV,"|",PIEC))
 ;
 Q
 ;
8634 ; OCX MDD ATTRIBUTE
 ;
 N D0
 ;
 D CHECK(863.4,$P($G(^OCXS(FILE,REC,"MOM")),U,1)) ; PARENT ATTRIBUTE
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .D CHECK(863.8,$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)) ; PARAMETER NAME
 ;
 Q
 ;
8635 ; OCX MDD VALUES
 ;
 N D0
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .D CHECK(863.8,$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)) ; PARAMETER
 ;
 Q
 ;
8636 ; OCX MDD METHOD
 ;
 N D0
 ;
 D CHECK(863,$P($G(^OCXS(FILE,REC,0)),U,3)) ; CLASS FILE
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .D CHECK(863.8,$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)) ; PARAMETER NAME
 ;
 Q
 ;
8637 ; OCX MDD PUBLIC FUNCTION
 ;
 N D0
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .D CHECK(863.8,$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)) ; PARAMETERS
 ;
 Q
 ;
8638 ; OCX MDD PARAMETER
 ;
 N D0
 ;
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER ATTRIBUTE multiple
 .D CHECK(863.8,$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)) ; PARAMETER
 ;
 Q
 ;
8639 ; OCX MDD CONDITION/FUNCTION
 ;
 N D0
 ;
 D CHECK(864.1,$P($G(^OCXS(FILE,REC,0)),U,2)) ; DATATYPE
 D CHECK(863.7,$P($G(^OCXS(FILE,REC,0)),U,3)) ; CODE GENERATOR FUNCTION
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .S PARM=$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)
 .S PARMV=$G(^OCXS(FILE,REC,"PAR",D0,"VAL"))
 .D CHECK(863.8,PARM) ; PARAMETER
 .I (PARM="OCXO GENERATE CODE FUNCTION") D CHECK(863.7,PARMV)
 ;
 Q
 ;
8641 ; OCX MDD DATATYPE
 ;
 N D0
 ;
 D CHECK(864.1,$P($G(^OCXS(FILE,REC,"MOM")),U,1)) ; PARENT DATA TYPE
 S D0=0 F  S D0=$O(^OCXS(FILE,REC,"PAR",D0)) Q:'D0  D  ; PARAMETER multiple
 .D CHECK(863.8,$P($G(^OCXS(FILE,REC,"PAR",D0,0)),U,1)) ; PARAMETER NAME
 ;
 Q
