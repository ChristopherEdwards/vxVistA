OCXOZ02 ;SLC/RJS,CLA - Order Check Scan ;APR 17,2009 at 14:23
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,221,243**;Dec 17,1997;Build 242
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
 ; ***************************************************************
 ; ** Warning: This routine is automatically generated by the   **
 ; ** Rule Compiler (^OCXOCMP) and ANY changes to this routine  **
 ; ** will be lost the next time the rule compiler executes.    **
 ; ***************************************************************
 ;
 Q
 ;
CHK1 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from UPDATE+10^OCXOZ01.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK1 Variables
 ; OCXDF(1) ----> Data Field: CONTROL CODE (FREE TEXT)
 ; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
 ; OCXDF(5) ----> Data Field: ORDER PRIORITY (OBR) (FREE TEXT)
 ; OCXDF(6) ----> Data Field: ABNORMAL FLAG (FREE TEXT)
 ; OCXDF(12) ---> Data Field: LAB RESULT (FREE TEXT)
 ; OCXDF(15) ---> Data Field: RESULT STATUS (OBX) (FREE TEXT)
 ; OCXDF(21) ---> Data Field: ORDER PRIORITY (ORC) (FREE TEXT)
 ; OCXDF(23) ---> Data Field: REQUEST STATUS (OBR) (FREE TEXT)
 ; OCXDF(34) ---> Data Field: ORDER NUMBER (NUMERIC)
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(113) --> Data Field: LAB TEST ID (NUMERIC)
 ; OCXDF(146) --> Data Field: INPT/OUTPT (FREE TEXT)
 ; OCXDF(152) --> Data Field: LAB SPECIMEN ID (NUMERIC)
 ;
 ;      Local Extrinsic Functions
 ; FILE(DFN,16, -----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: HL7 OERR ORDER)
 ; LIST( ------------> IN LIST OPERATOR
 ; PATLOC( ----------> PATIENT LOCATION
 ;
 I $L(OCXDF(23)) D CHK2
 I $L(OCXDF(1)) D CHK12^OCXOZ03
 I $L(OCXDF(2)),(OCXDF(2)="OR") S OCXOERR=$$FILE(DFN,16,"") Q:OCXOERR 
 I $L(OCXDF(6)) D CHK34^OCXOZ04
 I $L(OCXDF(15)),$$LIST(OCXDF(15),"F,C") D CHK47^OCXOZ05
 I $L(OCXDF(34)) D CHK113^OCXOZ06
 I $L(OCXDF(5)),(OCXDF(5)="S") D CHK151^OCXOZ07
 I $L(OCXDF(21)),(OCXDF(21)="S") D CHK157^OCXOZ07
 I $L(OCXDF(37)) S OCXDF(146)=$P($$PATLOC(OCXDF(37)),"^",1) I $L(OCXDF(146)) D CHK436^OCXOZ0E
 I $L(OCXDF(12)),$L(OCXDF(152)),$L(OCXDF(113)) D CHK463^OCXOZ0F
 Q
 ;
CHK2 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK1+25.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK2 Variables
 ; OCXDF(1) ----> Data Field: CONTROL CODE (FREE TEXT)
 ; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
 ; OCXDF(23) ---> Data Field: REQUEST STATUS (OBR) (FREE TEXT)
 ;
 ;      Local Extrinsic Functions
 ; LIST( ------------> IN LIST OPERATOR
 ;
 I $$LIST(OCXDF(23),"F,C"),$L(OCXDF(1)),$$LIST(OCXDF(1),"RE"),$L(OCXDF(2)) D CHK6
 I (OCXDF(23)="F"),$L(OCXDF(1)),$$LIST(OCXDF(1),"RE"),$L(OCXDF(2)) D CHK121^OCXOZ07
 Q
 ;
CHK6 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK2+13.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK6 Variables
 ; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
 ; OCXDF(34) ---> Data Field: ORDER NUMBER (NUMERIC)
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(55) ---> Data Field: SITE FLAGGED RESULT (BOOLEAN)
 ; OCXDF(96) ---> Data Field: ORDERABLE ITEM NAME (FREE TEXT)
 ; OCXDF(146) --> Data Field: INPT/OUTPT (FREE TEXT)
 ; OCXDF(147) --> Data Field: PATIENT LOCATION (FREE TEXT)
 ;
 ;      Local Extrinsic Functions
 ; ORDITEM( ---------> GET ORDERABLE ITEM FROM ORDER NUMBER
 ; PATLOC( ----------> PATIENT LOCATION
 ;
 I ($E(OCXDF(2),1,2)="LR"),$L(OCXDF(34)) S OCXDF(96)=$$ORDITEM(OCXDF(34)) I $L(OCXDF(37)) S OCXDF(147)=$P($$PATLOC(OCXDF(37)),"^",2) D CHK11
 I (OCXDF(2)="RA"),$L(OCXDF(37)) S OCXDF(146)=$P($$PATLOC(OCXDF(37)),"^",1) I $L(OCXDF(146)),$L(OCXDF(34)) S OCXDF(55)=$$SITERES^ORB3F1(OCXDF(34),OCXDF(146)) D CHK302^OCXOZ0C
 I (OCXDF(2)="GMRC"),$L(OCXDF(37)) S OCXDF(146)=$P($$PATLOC(OCXDF(37)),"^",1) I $L(OCXDF(146)),$L(OCXDF(34)) S OCXDF(55)=$$SITERES^ORB3F1(OCXDF(34),OCXDF(146)) D CHK336^OCXOZ0C
 Q
 ;
CHK11 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK6+18.
 ;
 Q:$G(OCXOERR)
 ;
 ;      Local Extrinsic Functions
 ; FILE(DFN,5, ------> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: HL7 FINAL LAB RESULT)
 ;
 S OCXOERR=$$FILE(DFN,5,"12,37,96,113,147,152") Q:OCXOERR 
 Q
 ;
FILE(DFN,OCXELE,OCXDFL) ;     This Local Extrinsic Function logs a validated event/element.
 ;
 N OCXTIMN,OCXTIML,OCXTIMT1,OCXTIMT2,OCXDATA,OCXPC,OCXPC,OCXVAL,OCXSUB,OCXDFI
 S DFN=+$G(DFN),OCXELE=+$G(OCXELE)
 ;
 Q:'DFN 1 Q:'OCXELE 1 K OCXDATA
 ;
 S OCXDATA(DFN,OCXELE)=1
 F OCXPC=1:1:$L(OCXDFL,",") S OCXDFI=$P(OCXDFL,",",OCXPC) I OCXDFI D
 .S OCXVAL=$G(OCXDF(+OCXDFI)),OCXDATA(DFN,OCXELE,+OCXDFI)=OCXVAL
 ;
 M ^TMP("OCXCHK",$J,DFN)=OCXDATA(DFN)
 ;
 Q 0
 ;
LIST(DATA,LIST) ;   IS THE DATA FIELD IN THE LIST
 ;
 S:'($E(LIST,1)=",") LIST=","_LIST S:'($E(LIST,$L(LIST))=",") LIST=LIST_"," S DATA=","_DATA_","
 Q (LIST[DATA)
 ;
ORDITEM(OIEN) ;  Compiler Function: GET ORDERABLE ITEM FROM ORDER NUMBER
 Q:'$G(OIEN) ""
 ;
 N OITXT,X S OITXT=$$OI^ORQOR2(OIEN) Q:'OITXT "No orderable item found."
 S X=$G(^ORD(101.43,+OITXT,0)) Q:'$L(X) "No orderable item found."
 Q $P(X,U,1)
 ;
PATLOC(DFN) ;  Compiler Function: PATIENT LOCATION
 ;
 N OCXP1,OCXP2
 S OCXP1=$G(^TMP("OCXSWAP",$J,"OCXODATA","PV1",2))
 S OCXP2=$P($G(^TMP("OCXSWAP",$J,"OCXODATA","PV1",3)),"^",1)
 I OCXP2 D
 .S OCXP2=$P($G(^SC(+OCXP2,0)),"^",1,2)
 .I $L($P(OCXP2,"^",2)) S OCXP2=$P(OCXP2,"^",2)
 .E  S OCXP2=$P(OCXP2,"^",1)
 .S:'$L(OCXP2) OCXP2="NO LOC"
 I $L(OCXP1),$L(OCXP2) Q OCXP1_"^"_OCXP2
 ;
 S OCXP2=$G(^DPT(+$G(DFN),.1))
 I $L(OCXP2) Q "I^"_OCXP2
 Q "O^OUTPT"
 ;
