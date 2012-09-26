SDOERPC ;ALB/MJK - ACRP RPCs For An Encounter ;8/12/96
 ;;5.3;Scheduling;**131,196**;Aug 13, 1993
 ;06/22/99 ACS - Added CPT modifier logic for the AMB CARE toolkit
 ;
 ; ------------------------- cpt rpcs --------------------------
 ;
CPT(SDOEY,SDOE) ; -- SDOE ASSIGNED A PROCEDURE             [API ID: 65]
 S SDOEY=$$CPT^SDOECPT(SDOE)
 Q
 ;
GETCPT(SDOEY,SDOE) ; -- SDOE GET PROCEDURES           [API ID: 61]
 D GETCPT^SDOECPT(.SDOE,"SDOEY")
 ;
 ; The following logic will remove the 2nd level subscripts
 ; (containing modifier information) from the CPT array because they
 ; aren't relevant for this routine
 N LEVEL1,LEVEL2
 S (LEVEL1,LEVEL2)=""
 F  S LEVEL1=$O(SDOEY(LEVEL1)) Q:'LEVEL1  D
 . F  S LEVEL2=$O(SDOEY(LEVEL1,LEVEL2)) Q:LEVEL2=""  D
 .. K SDOEY(LEVEL1,LEVEL2)
 .. Q
 . Q
 Q
 ;
FINDCPT(SDOEY,SDOE,SDCPTID) ; -- SDOE FIND PROCEDURE   [API ID: 71]
 S SDOEY=$$FINDCPT^SDOECPT(SDOE,SDCPTID)
 Q
 ;
 ; ------------------------- dx rpcs --------------------------
 ;
DX(SDOEY,SDOE) ; -- SDOE ASSIGNED A DIAGNOSIS             [API ID: 64]
 S SDOEY=$$DX^SDOEDX(SDOE)
 Q
 ;
GETDX(SDOEY,SDOE) ; -- SDOE GET DIAGNOSES                    [API ID: 56]
 D GETDX^SDOEDX(.SDOE,"SDOEY")
 Q
 ;
FINDDX(SDOEY,SDOE,SDDXID) ; -- SDOE FIND DIAGNOSIS           [API ID: 70]
 S SDOEY=$$FINDDX^SDOEDX(SDOE,SDDXID)
 Q
 ;
GETPDX(SDOEY,SDOE) ; -- SDOE GET PRIMARY DIAGNOSIS    [API ID: 73]
 S SDOEY=$$GETPDX^SDOEDX(SDOE)
 Q
 ;
 ; ------------------------- provider rpcs --------------------------
 ;
PRV(SDOEY,SDOE) ; -- SDOE ASSIGNED A PROVIDER              [API ID: 63]
 S SDOEY=$$PRV^SDOEPRV(SDOE)
 Q
 ;
GETPRV(SDOEY,SDOE) ; -- SDOE GET PROVIDERS            [API ID: 58]
 D GETPRV^SDOEPRV(.SDOE,"SDOEY")
 Q
 ;
FINDPRV(SDOEY,SDOE,SDPRVID) ; -- SDOE FIND PROVIDER    [API ID: 69]
 S SDOEY=$$FINDPRV^SDOEPRV(SDOE,SDPRVID)
 Q
 ;
 ; --------------------------------oe rpcs--------------------------
 ;
GETOE(SDOEY,SDOE) ; -- SDOE GET ZERO NODE                    [API ID: 98]
 S SDOEY=$$GETOE^SDOEOE(SDOE)
 Q
 ;
GETGEN(SDOEY,SDOE) ; -- SDOE GET GENERAL DATA         [API ID: 76]
 N SDAT,SDATAOE
 S SDAT="SDATAOE"
 D GETGEN^SDOEOE(.SDOE,.SDAT)
 D BUILD(.SDATAOE,.SDOEY)
 Q
 ;
PARSE(SDOEY,SDATA,SDFMT) ; -- SDOE PARSE GENERAL DATA       [API ID: 78]
 N SDY
 S SDY="SDATAOE"
 D PARSE^SDOEOE(.SDATA,.SDFMT,.SDY)
 D BUILD(.SDATAOE,.SDOEY)
 Q
 ;
EXAE(SDOEY,DFN,SDBEG,SDEND,SDFLAGS) ; -- SDOE FIND FIRST STANDALONE [API ID: 72]
 S SDOEY=$$EXAE^SDOEOE(.DFN,.SDBEG,.SDEND,$G(SDFLAGS))
 Q
 ;
GETLAST(SDOEY,DFN,SDBEG,SDFLAGS) ; -- SDOE FIND LAST STANDALONE          [API ID: 75]
 S SDOEY=$$GETLAST^SDOEOE(.DFN,.SDBEG,$G(SDFLAGS))
 Q
 ;
EXOE(SDOEY,DFN,SDBEG,SDEND,SDFLAGS) ; -- SDOE FIND FIRST ENCOUNTER  [API ID: 74]
 S SDOEY=$$EXOE^SDOEOE(.DFN,.SDBEG,.SDEND,$G(SDFLAGS))
 Q
 ;
 ;
LIST(SDOEY,SDBEG,SDEND) ; -- RPC: SDOE LIST ENCOUNTERS FOR DATES
 N SDQID
 D OPEN(.SDOEY,.SDQID)
 IF '$$ERRCHK^SDQUT() D INDEX^SDQ(.SDQID,"DATE/TIME","SET")
 IF '$$ERRCHK^SDQUT() D DATE^SDQ(.SDQID,SDBEG,SDEND,"SET")
 D CLOSE(.SDQID)
LISTQ Q
 ;
LISTPAT(SDOEY,SDFN,SDBEG,SDEND) ; -- RPC: SDOE LIST ENCOUNTERS FOR PAT
 N SDQID
 D OPEN(.SDOEY,.SDQID)
 IF '$$ERRCHK^SDQUT() D INDEX^SDQ(.SDQID,"PATIENT/DATE","SET")
 IF '$$ERRCHK^SDQUT() D PAT^SDQ(.SDQID,SDFN,"SET")
 IF '$$ERRCHK^SDQUT() D DATE^SDQ(.SDQID,SDBEG,SDEND,"SET")
 D CLOSE(.SDQID)
LISTPATQ Q
 ;
LISTVST(SDOEY,SDVST) ; -- RPC: SDOE LIST ENCOUNTERS FOR VISIT
 N SDQID
 D OPEN(.SDOEY,.SDQID)
 IF '$$ERRCHK^SDQUT() D INDEX^SDQ(.SDQID,"VISIT","SET")
 IF '$$ERRCHK^SDQUT() D VISIT^SDQ(.SDQID,SDVST,"SET")
 D CLOSE(.SDQID)
LISTVSTQ Q
 ;
OPEN(SDOEY,SDQID) ; -- initialize query
 S SDOEY=$NA(^TMP("SD ENCOUNTER LIST",$J))
 K ^TMP("SD ENCOUNTER LIST",$J)
 D OPEN^SDQ(.SDQID)
OPENQ Q
 ;
CLOSE(SDQID) ; -- finalize query + scan + close
 IF '$$ERRCHK^SDQUT() D SCANCB^SDQ(.SDQID,"D CB^SDOERPC(Y,Y0,.SDSTOP)","SET")
 IF '$$ERRCHK^SDQUT() D ACTIVE^SDQ(.SDQID,"TRUE","SET")
 IF '$$ERRCHK^SDQUT() D SCAN^SDQ(.SDQID)
 D CLOSE^SDQ(.SDQID)
CLOSEQ Q
 ;
CB(SDOE,SDOE0,SDSTOP) ; -- callback for LIST* tags
 S ^TMP("SD ENCOUNTER LIST",$J,SDOE)=SDOE_";;"_SDOE0
 Q
 ;
BUILD(IN,OUT) ; -- build array for rpc lists
 N IEN
 S IEN=""
 F  S IEN=$O(IN(IEN)) Q:IEN=""  S OUT(IEN)=IEN_";;"_IN(IEN)
 Q
 ;
