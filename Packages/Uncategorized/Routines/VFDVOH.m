VFDVOH ;DSS/LM - Receive and process ORDER messages ; 12/18/2007
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ; (c) Document Storage Systems, Inc. 2005
 ;
 ; Active integration agreements
 ; 
 ; 2164   GENERATE^HLMA
 ; 3630   BLDPID^VAFCQRY
 ; 10063  ^%ZTLOAD
 ; 10108  CREATE^HLTF
 Q
EN(VFDVMSG,VFDVTO) ;;Main entry
 ; VFDVMSG (array or name of array)
 ; VFDVTO=Namespace of target application -
 ;        DGPM, FH, GMRC, LRAP, LRBB, LRCH, ORG, PS, RA
 ;
 Q:'$$ACTIVE^VFDVOHU("VFDV VISTA")
 I $$NOQ D DQ^VFDVOH Q  ;Do not task
 N ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 S (ZTSAVE("VFDVMSG("),ZTSAVE("VFDVTO"))=""
 S ZTIO="",ZTDTH=$$NOW^XLFDT(),ZTRTN="DQ^VFDVOH"
 S ZTDESC="cVistA Orders HL7"
 D ^%ZTLOAD
 Q
NOQ() ;;TRUE if and only if continuation should NOT be queued.
 ; Returns 1 or 0
 Q:$G(VFDVTO)="PS"&($$GET^XPAR("ALL","VFDVOH PSO AUTO")=1) 1
 ; Additional "no queue" conditions here
 Q 0
 ;
DQ ;;Dequeue task - Process message
 ;D DEBUG^VFDVOHU("DQ~VFDVOH reached.  ZTSK="_$G(ZTSK)_", $J="_$J)
 N HL,HLA Q:$$INIT^VFDVOHU(.HL,"VFDV ORM-O01 SERVER")
 I $G(VFDVMSG(1))?1"BHS".E!($G(VFDVMSG(1))?1"BTS".E) D BHS,QUIT Q  ;HL7 batch
 ; Single message
 N DFN S DFN=$$MSGDFN^VFDVOHU(.VFDVMSG,"|") Q:'DFN  ;Required
 N VFDVI S VFDVI=0
 ; Omit EVN
 N VFDVERR,VFDVPID S VFDVERR=""
 D BLDPID^VAFCQRY(DFN,1,"1,2,3,7,18,19",.VFDVPID,.HL,.VFDVERR)
 ;D DEBUG^VFDVOHU(VFDVERR)
 Q:'$D(VFDVPID)
 S VFDVI=VFDVI+1 S HLA("HLS",VFDVI)=VFDVPID(1)
 N J F J=2:1 Q:'$D(VFDVPID(J))  S HLA("HLS",VFDVI,J-1)=VFDVPID(J)
 S VFDVI=VFDVI+1,HLA("HLS",VFDVI)=$$PV1^VFDVOHU1(DFN)
 N I,X F I=1:1 Q:'$D(VFDVMSG(I))  D  ;Merge remaining segments
 .M X=VFDVMSG(I) Q:"MSH^PID^PV1"[$E(X,1,3)!($E(X)="Z")
 .S VFDVI=VFDVI+1 M HLA("HLS",VFDVI)=X
 .Q
 ; Coding in progress
 D APP
 ; Coding in progress
 N HLEXROU,VFDVRSLT D GENERATE^HLMA(HL("EID"),"LM",1,.VFDVRSLT)
 ;D DEBUG^VFDVOHU(.VFDVRSLT)
 D QUIT
 Q
BHS ;;Process batch here
 Q  ; Ignore batch wrapper.  Process included messages individually.
 ;D DEBUG^VFDVOHU("BHS~VFDVOH")
 N VFDVBEID S VFDVBEID=HL("EID") ;From DQ
 N VFDVBMID,VFDVBIEN D CREATE^HLTF(.VFDVBMID,.VFDVBIEN) Q:'$G(VFDVBMID)
 N VFDVBCNT,VFDVBMSG S VFDVBCNT=0,VFDVBMSG=$NA(^TMP("HLS",$J)) K @VFDVBMSG
 ; Generate component messages here
 ; First approximation has no change to messages, except to replace MSH
 N VFDVI,VFDVJ S VFDVJ=0 F VFDVI=2:1 Q:'$D(VFDVMSG(VFDVI))  D
 .I VFDVMSG(VFDVI)?1"MSH".E D  Q
 ..S VFDVBCNT=1+VFDVBCNT N HLEXROU,HLRSLT S HLRSLT=""
 ..D MSH^HLFNC2(.HL,VFDVBMID_"-"_VFDVBCNT,.HLRSLT)
 ..S VFDVJ=1+VFDVJ,@VFDVBMSG@(VFDVJ)=HLRSLT
 ..Q
 .; Modify PID etc. here
 .S VFDVJ=1+VFDVJ,@VFDVBMSG@(VFDVJ)=VFDVMSG(VFDVI)
 .Q
 ; Coding in progress - Application specific modifications
 ; Finally -
 Q:'$G(VFDVBCNT)!'$D(@VFDVBMSG)  ;No batch contents
 N HLRSLT D GENERATE^HLMA(VFDVBEID,"GB",1,.HLRSLT,VFDVBIEN)
 D QUIT
 Q
APP ;;Branch to application-specific code
 I "^DGPM^FH^GMRC^LRAP^LRBB^LRCH^ORG^PS^RA^"["^"_$G(VFDVTO)_"^" D @VFDVTO
 Q
DGPM ;;
 ;D DEBUG^VFDVOHU("PIMS (DGPM) order message received.")
 Q
FH ;;
 ;D DEBUG^VFDVOHU("Diet (FH) order message received.")
 Q
GMRC ;;
 ;D DEBUG^VFDVOHU("Consult (GMRC) order message received.")
 Q
LRAP ;;
 ;D DEBUG^VFDVOHU("Anatomic Pathology (LRAP) order message received.")
 Q
LRBB ;;
 ;D DEBUG^VFDVOHU("Blood Bank (LRBB) order message received.")
 Q
LRCH ;;
 ;D DEBUG^VFDVOHU("LAB (LRCH) order message received.")
 Q
ORG ;;
 ;D DEBUG^VFDVOHU("Generic (ORG) order message received.")
 Q
PS ;;
 ;D DEBUG^VFDVOHU("Pharmacy (PS) order message received.")
 ;
 ; Next is for vxVistA auto-release
 Q:'($$GET^XPAR("ALL","VFDVOH PSO AUTO")=1)
 N VFDRTN S VFDRTN="RELEASE^VFDPSOR" Q:'($T(@VFDRTN)]"")
 ; Set VFDORD equal to the (placer) ORDER ID
 N VFDI,VFDORD S VFDORD="" F VFDI=1:1 Q:'$D(VFDVMSG(VFDI))!VFDORD  D
 .I $E(VFDVMSG(VFDI),1,3)="ORC" S VFDORD=$P($P(VFDVMSG(VFDI),"|",3),"^")
 .Q
 D @VFDRTN ;Call vxVistA auto-release routine
 Q
RA ;;
 ;D DEBUG^VFDVOHU("Radiology (RA) order message received.")
 Q
NOP ;;VFDVOH*1.0*1 [No-operation] Dummy processing routine
 ; Attach to VFDV ORM-O01 CLIENT protocol when no logical link
 ; is attached to this protocol.
 Q
QUIT ;;Final cleanup
 ;D DEBUG^VFDVOHU("Quit")
 Q
