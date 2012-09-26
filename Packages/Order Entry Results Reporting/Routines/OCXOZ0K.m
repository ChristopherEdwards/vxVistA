OCXOZ0K ;SLC/RJS,CLA - Order Check Scan ;APR 17,2009 at 14:23
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
R5R1B ; Send Order Check, Notication messages and/or Execute code for  Rule #5 'ORDER FLAGGED FOR CLARIFICATION'  Relation #1 'ORDER FLAGGED'
 ;  Called from R5R1A+10^OCXOZ0J.
 ;
 Q:$G(OCXOERR)
 ;
 ;      Local Extrinsic Functions
 ; GETDATA( ---------> GET DATA FROM THE ACTIVE DATA FILE
 ; NEWRULE( ---------> NEW RULE MESSAGE
 ;
 Q:$D(OCXRULE("R5R1B"))
 ;
 N OCXNMSG,OCXCMSG,OCXPORD,OCXFORD,OCXDATA,OCXNUM,OCXDUZ,OCXQUIT,OCXLOGS,OCXLOGD
 S OCXCMSG=""
 S OCXNMSG="Order(s) needing clarification: Flagged "_$$GETDATA(DFN,"44^",115)_"."
 ;
 Q:$G(OCXOERR)
 ;
 ; Send Notification
 ;
 S (OCXDUZ,OCXDATA)="",OCXNUM=0
 I ($G(OCXOSRC)="GENERIC HL7 MESSAGE ARRAY") D
 .S OCXDATA=$G(^TMP("OCXSWAP",$J,"OCXODATA","ORC",2))_"|"_$G(^TMP("OCXSWAP",$J,"OCXODATA","ORC",3))
 .S OCXDATA=$TR(OCXDATA,"^","@"),OCXNUM=+OCXDATA
 I ($G(OCXOSRC)="CPRS ORDER PROTOCOL") D
 .I $P($G(OCXORD),U,3) S OCXDUZ(+$P(OCXORD,U,3))=""
 .S OCXNUM=+$P(OCXORD,U,2)
 S:($G(OCXOSRC)="CPRS ORDER PRESCAN") OCXNUM=+$P(OCXPSD,"|",5)
 S OCXRULE("R5R1B")=""
 I $$NEWRULE(DFN,OCXNUM,5,1,6,OCXNMSG) D  I 1
 .D:($G(OCXTRACE)<5) EN^ORB3(6,DFN,OCXNUM,.OCXDUZ,OCXNMSG,.OCXDATA)
 Q
 ;
R5R2A ; Verify all Event/Elements of  Rule #5 'ORDER FLAGGED FOR CLARIFICATION'  Relation #2 'ORDER UNFLAGGED'
 ;  Called from EL134+5^OCXOZ0G.
 ;
 Q:$G(OCXOERR)
 ;
 ;      Local Extrinsic Functions
 ; MCE134( ---------->  Verify Event/Element: 'ORDER UNFLAGGED'
 ;
 Q:$G(^OCXS(860.2,5,"INACT"))
 ;
 I $$MCE134 D R5R2B
 Q
 ;
R5R2B ; Send Order Check, Notication messages and/or Execute code for  Rule #5 'ORDER FLAGGED FOR CLARIFICATION'  Relation #2 'ORDER UNFLAGGED'
 ;  Called from R5R2A+10.
 ;
 Q:$G(OCXOERR)
 ;
 ;      Local Extrinsic Functions
 ; GETDATA( ---------> GET DATA FROM THE ACTIVE DATA FILE
 ;
 Q:$D(OCXRULE("R5R2B"))
 ;
 N OCXNMSG,OCXCMSG,OCXPORD,OCXFORD,OCXDATA,OCXNUM,OCXDUZ,OCXQUIT,OCXLOGS,OCXLOGD
 S OCXCMSG=""
 S OCXNMSG=""
 ;
 ;
 ; Run Execute Code
 ;
 D UNFLAG^ORB3FUP1($$GETDATA(DFN,"134^",37))
 Q:$G(OCXOERR)
 Q
 ;
R6R1A ; Verify all Event/Elements of  Rule #6 'ORDER REQUIRES CHART SIGNATURE'  Relation #1 'SIGNATURE'
 ;  Called from EL45+5^OCXOZ0G.
 ;
 Q:$G(OCXOERR)
 ;
 ;      Local Extrinsic Functions
 ; MCE45( ----------->  Verify Event/Element: 'ORDER REQUIRES CHART SIGNATURE'
 ;
 Q:$G(^OCXS(860.2,6,"INACT"))
 ;
 I $$MCE45 D R6R1B
 Q
 ;
R6R1B ; Send Order Check, Notication messages and/or Execute code for  Rule #6 'ORDER REQUIRES CHART SIGNATURE'  Relation #1 'SIGNATURE'
 ;  Called from R6R1A+10.
 ;
 Q:$G(OCXOERR)
 ;
 ;      Local Extrinsic Functions
 ; NEWRULE( ---------> NEW RULE MESSAGE
 ;
 Q:$D(OCXRULE("R6R1B"))
 ;
 N OCXNMSG,OCXCMSG,OCXPORD,OCXFORD,OCXDATA,OCXNUM,OCXDUZ,OCXQUIT,OCXLOGS,OCXLOGD
 S OCXCMSG=""
 S OCXNMSG="Order released - requires chart signature."
 ;
 Q:$G(OCXOERR)
 ;
 ; Send Notification
 ;
 S (OCXDUZ,OCXDATA)="",OCXNUM=0
 I ($G(OCXOSRC)="GENERIC HL7 MESSAGE ARRAY") D
 .S OCXDATA=$G(^TMP("OCXSWAP",$J,"OCXODATA","ORC",2))_"|"_$G(^TMP("OCXSWAP",$J,"OCXODATA","ORC",3))
 .S OCXDATA=$TR(OCXDATA,"^","@"),OCXNUM=+OCXDATA
 I ($G(OCXOSRC)="CPRS ORDER PROTOCOL") D
 .I $P($G(OCXORD),U,3) S OCXDUZ(+$P(OCXORD,U,3))=""
 .S OCXNUM=+$P(OCXORD,U,2)
 S:($G(OCXOSRC)="CPRS ORDER PRESCAN") OCXNUM=+$P(OCXPSD,"|",5)
 S OCXRULE("R6R1B")=""
 I $$NEWRULE(DFN,OCXNUM,6,1,5,OCXNMSG) D  I 1
 .D:($G(OCXTRACE)<5) EN^ORB3(5,DFN,OCXNUM,.OCXDUZ,OCXNMSG,.OCXDATA)
 Q
 ;
R7R1A ; Verify all Event/Elements of  Rule #7 'PATIENT ADMISSION'  Relation #1 'ADMISSION'
 ;  Called from EL21+5^OCXOZ0G.
 ;
 Q:$G(OCXOERR)
 ;
 ;      Local Extrinsic Functions
 ; MCE21( ----------->  Verify Event/Element: 'PATIENT ADMISSION'
 ;
 Q:$G(^OCXS(860.2,7,"INACT"))
 ;
 I $$MCE21 D R7R1B^OCXOZ0L
 Q
 ;
CKSUM(STR) ;  Compiler Function: GENERATE STRING CHECKSUM
 ;
 N CKSUM,PTR,ASC S CKSUM=0
 S STR=$TR(STR,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 F PTR=$L(STR):-1:1 S ASC=$A(STR,PTR)-42 I (ASC>0),(ASC<51) S CKSUM=CKSUM*2+ASC
 Q +CKSUM
 ;
GETDATA(DFN,OCXL,OCXDFI) ;     This Local Extrinsic Function returns runtime data
 ;
 N OCXE,VAL,PC S VAL=""
 F PC=1:1:$L(OCXL,U) S OCXE=$P(OCXL,U,PC) I OCXE S VAL=$G(^TMP("OCXCHK",$J,DFN,OCXE,OCXDFI)) Q:$L(VAL)
 Q VAL
 ;
MCE134() ; Verify Event/Element: ORDER UNFLAGGED
 ;
 ;  OCXDF(37) -> PATIENT IEN data field
 ;
 N OCXRES
 S OCXDF(37)=$P($G(OCXORD),"^",1) I $L(OCXDF(37)) S OCXRES(134,37)=OCXDF(37)
 Q:'(OCXDF(37)) 0 I $D(^TMP("OCXCHK",$J,OCXDF(37),134)) Q $G(^TMP("OCXCHK",$J,OCXDF(37),134))
 Q 0
 ;
MCE21() ; Verify Event/Element: PATIENT ADMISSION
 ;
 ;  OCXDF(37) -> PATIENT IEN data field
 ;
 N OCXRES
 S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) S OCXRES(21,37)=OCXDF(37)
 Q:'(OCXDF(37)) 0 I $D(^TMP("OCXCHK",$J,OCXDF(37),21)) Q $G(^TMP("OCXCHK",$J,OCXDF(37),21))
 Q 0
 ;
MCE45() ; Verify Event/Element: ORDER REQUIRES CHART SIGNATURE
 ;
 ;  OCXDF(37) -> PATIENT IEN data field
 ;
 N OCXRES
 S OCXDF(37)=$P($G(OCXORD),"^",1) I $L(OCXDF(37)) S OCXRES(45,37)=OCXDF(37)
 Q:'(OCXDF(37)) 0 I $D(^TMP("OCXCHK",$J,OCXDF(37),45)) Q $G(^TMP("OCXCHK",$J,OCXDF(37),45))
 Q 0
 ;
NEWRULE(OCXDFN,OCXORD,OCXRUL,OCXREL,OCXNOTF,OCXMESS) ; Has this rule already been triggered for this order number
 ;
 ;
 Q:'$G(OCXDFN) 0 Q:'$G(OCXRUL) 0
 Q:'$G(OCXREL) 0  Q:'$G(OCXNOTF) 0  Q:'$L($G(OCXMESS)) 0
 S OCXORD=+$G(OCXORD),OCXDFN=+OCXDFN
 ;
 N OCXNDX,OCXDATA,OCXDFI,OCXELE,OCXGR,OCXTIME,OCXCKSUM,OCXTSP,OCXTSPL
 ;
 S OCXTIME=(+$H)
 S OCXCKSUM=$$CKSUM(OCXMESS)
 ;
 S OCXTSP=($H*86400)+$P($H,",",2)
 S OCXTSPL=($G(^OCXD(860.7,"AT",OCXTIME,OCXDFN,OCXRUL,+OCXORD,OCXCKSUM))+$G(OCXTSPI,300))
 ;
 Q:(OCXTSPL>OCXTSP) 0
 ;
 K OCXDATA
 S OCXDATA(OCXDFN,0)=OCXDFN
 S OCXDATA("B",OCXDFN,OCXDFN)=""
 S OCXDATA("AT",OCXTIME,OCXDFN,OCXRUL,+OCXORD,OCXCKSUM)=OCXTSP
 ;
 S OCXGR="^OCXD(860.7"
 D SETAP(OCXGR_")",0,.OCXDATA,OCXDFN)
 ;
 K OCXDATA
 S OCXDATA(OCXRUL,0)=OCXRUL_U_(OCXTIME)_U_(+OCXORD)
 S OCXDATA(OCXRUL,"M")=OCXMESS
 S OCXDATA("B",OCXRUL,OCXRUL)=""
 S OCXGR=OCXGR_","_OCXDFN_",1"
 D SETAP(OCXGR_")","860.71P",.OCXDATA,OCXRUL)
 ;
 K OCXDATA
 S OCXDATA(OCXREL,0)=OCXREL
 S OCXDATA("B",OCXREL,OCXREL)=""
 S OCXGR=OCXGR_","_OCXRUL_",1"
 D SETAP(OCXGR_")","860.712",.OCXDATA,OCXREL)
 ;
 S OCXELE=0 F  S OCXELE=$O(^OCXS(860.2,OCXRUL,"C","C",OCXELE)) Q:'OCXELE  D
 .;
 .N OCXGR1
 .S OCXGR1=OCXGR_","_OCXREL_",1"
 .K OCXDATA
 .S OCXDATA(OCXELE,0)=OCXELE
 .S OCXDATA(OCXELE,"TIME")=OCXTIME
 .S OCXDATA(OCXELE,"LOG")=$G(OCXOLOG)
 .S OCXDATA("B",OCXELE,OCXELE)=""
 .K ^OCXD(860.7,OCXDFN,1,OCXRUL,1,OCXREL,1,OCXELE)
 .D SETAP(OCXGR1_")","860.7122P",.OCXDATA,OCXELE)
 .;
 .S OCXDFI=0 F  S OCXDFI=$O(^TMP("OCXCHK",$J,OCXDFN,OCXELE,OCXDFI)) Q:'OCXDFI  D
 ..N OCXGR2
 ..S OCXGR2=OCXGR1_","_OCXELE_",1"
 ..K OCXDATA
 ..S OCXDATA(OCXDFI,0)=OCXDFI
 ..S OCXDATA(OCXDFI,"VAL")=^TMP("OCXCHK",$J,OCXDFN,OCXELE,OCXDFI)
 ..S OCXDATA("B",OCXDFI,OCXDFI)=""
 ..D SETAP(OCXGR2_")","860.71223P",.OCXDATA,OCXDFI)
 ;
 Q 1
 ;
SETAP(ROOT,DD,DATA,DA) ;  Set Rule Event data
 M @ROOT=DATA
 I +$G(DD) S @ROOT@(0)="^"_($G(DD))_"^"_($P($G(@ROOT@(0)),U,3)+1)_"^"_$G(DA)
 I '$G(DD) S $P(@ROOT@(0),U,3,4)=($P($G(@ROOT@(0)),U,3)+1)_"^"_$G(DA)
 ;
 Q
 ;
 ;