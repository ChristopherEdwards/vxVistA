VFDXWBA ;DSS/LM/SGM - BROKER AUDIT FOR HIPAA/CCHIT;23 Nov 2009 16:06
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;This routine is not to be invoked directly.  It is only invoked
 ;from the VFDXWB routine
 ;
 ; ICR#   SUPPORTED REFERENCES
 ;------  ------------------------------------------------------
 ;        UPDATE^DIE
 ;        ^DIK
 ;        ^XLFDT: $$FMADD, $$LIST, $$NOW
 ;        $$GET^XPAR
 ;        ^%ZISH: CLOSE, OPEN, $$PWD
 ;        Global read of files
 ;           38.1 - zeroth node
 ;         8994   - AVFD whole file index
 ;           
 ;------------------------  RPC AUDIT SUPPORT  ------------------------
ARCHIVE ;[Option] VFD RPC AUDIT ARCHIVE
 ; Come here from tasked option to copy/purge VFD RPC AUDIT LOG
 ;
 N VFDAYS,VFDEDT,VFDHNDL,VFDPATH,VFDFILE,VFDMODE,VFDSDT
 S VFDAYS=$$GET^XPAR("SYS","VFD RPC AUDIT DAYS-TO-KEEP")
 S:'VFDAYS VFDAYS=7 S VFDEDT=$$FMADD^XLFDT(DT,-VFDAYS,0,0,0)
 S VFDSDT=$P($O(^VFD(21615,"B",0)),".") Q:'VFDSDT!'(VFDSDT<VFDEDT)
 S VFDHNDL="VFD-"_$J
 S VFDPATH=$$GET^XPAR("SYS","VFD RPC AUDIT PATH")
 S:VFDPATH="" VFDPATH=$$PWD^%ZISH
 S VFDFILE="RPC-Audit-"_VFDSDT_"-"_VFDEDT_".txt"
 S VFDMODE=$S($$EXISTS(VFDPATH,VFDFILE):"A",1:"W")
 N IO,POP D OPEN^%ZISH(VFDHNDL,VFDPATH,VFDFILE,VFDMODE)
 I POP D XCPT($$NOW^XLFDT,"RPC Audit Archive","Open failed: "_VFDFILE) Q
 N VFDA,VFDFN,VFDI,VFDT,VFDX U IO
 S VFDT=VFDSDT F  S VFDT=$O(^VFD(21615,"B",VFDT)) Q:'VFDT!'(VFDT<VFDEDT)  D
 .S VFDA=0 F  S VFDA=$O(^VFD(21615,"B",VFDT,VFDA))  Q:'VFDA  D WRT,DIK
 .Q
 D CLOSE^%ZISH(VFDHNDL)
 ; Archive/Purge complete
 Q
 ;
RPCLOG ; called From LOG^XWBDLOG
 Q:$G(VFDQUIT)
 ; quit - no log entries before user sign-on
 I '$G(VFDIENS) Q:'$G(DUZ)  D NEWLOG
 I $G(VFDDFN) D NEWDFN
 D ADDREC
 Q
 ;
 ;-----------------------  PRIVATE SUBROUTINES  -----------------------
ADDREC ; Add a data record
 ; VFDIENS is defined
 N VFD0,VFD1 S VFD0=$P(VFDIENS,",",2),VFD1=+VFDIENS I VFD0,VFD1,$L($G(MSG))
 E  Q  ;Cannot file data
 S MSG=$$TR(MSG) I MSG?1"RPC: ".E D
 .N VFDX S VFDX=$P(MSG,"RPC: ",2)
 .I VFDX]"" S VFDRPC=$S($D(^XWB(8994,"AVFD",VFDX)):1,1:0)
 .Q
 S:MSG?1"rd: [XWB]".E VFDRPC=0 ;Skip next read
 Q:'VFDRPC  ;RPC is not in audit list
 S:MSG?1"Call: ".E MSG=$$XP(MSG)
 S VFDCNT=1+VFDCNT,$P(^VFD(21615,VFD0,1,VFD1,1,0),U,3,4)=VFDCNT_U_VFDCNT
 S ^VFD(21615,VFD0,1,VFD1,1,VFDCNT,0)=$H_U_MSG
 Q
 ;
DIK ; Purge one VFD RPC AUDIT LOG entry after archiving
 ; Variable VFDA required
 I $G(VFDA) N DA,DIK S DIK="^VFD(21615,",DA=VFDA D ^DIK
 Q
 ;
EXISTS(VFDPATH,VFDFILE) ; Test existence of path/file
 ; Return 1 if and only if path and file are specified and
 ; file exists in path.  Else return 0.
 I $L($G(VFDPATH)),$L($G(VFDFILE)) N VFDARR,VFDRET
 E  Q 0 ;Path or file not specified
 S VFDARR(VFDFILE)="" I $$LIST^%ZISH(VFDPATH,$NA(VFDARR),$NA(VFDRET))
 Q $O(VFDRET(""))[VFDFILE
 ;
NEWDFN ; Create a new PATIENT multiple entry
 ; VFDDFN and VFDIENS are defined
 S:$L(VFDIENS,",")=3 VFDIENS=$P(VFDIENS,",",2)_"," ;Reset IENS to top level
 ; Mode-specific screens
 I 'VFDPMODE,$D(^VFD(21615.1,1,2,"B",+VFDDFN)) S VFDDFN="" Q  ;EXCLUDED PATIENT
 I VFDPMODE=1,'$P($G(^DGSL(38.1,+VFDDFN,0)),U,2) S VFDDFN="" Q  ;NOT SENSITIVE PATIENT
 I VFDPMODE=2,'$D(^VFD(21615.1,1,1,"B",+VFDDFN)) S VFDDFN="" Q  ;NOT SELECTED PAT.
 ; End screens
 ; 
 N VFD0,VFDFDA,VFDIEN,VFDL S VFD0=+VFDIENS
 S VFDL=$L(VFDIENS,","),VFDIENS=$P(VFDIENS,",",VFDL-1,VFDL)
 S VFDFDA(21615.01,"?+1,"_VFDIENS,.01)=+VFDDFN
 D UPDATE^DIE(,$NA(VFDFDA),$NA(VFDIEN))
 S VFDDFN="" Q:'$G(VFDIEN(1))
 S VFDIENS=$G(VFDIEN(1))_","_VFDIENS
 S VFDCNT=+$P($G(^VFD(21615,VFD0,1,VFDIEN(1),1,0)),U,3)
 Q
 ;
NEWLOG ; Create a new log entry
 ; VFDHNDL and DUZ are defined
 ;
 ; Mode-specific screens
 I VFDUMODE,'$D(^VFD(21615.1,1,3,"B",+DUZ)) S VFDQUIT=1 Q  ;Not SELECTED USER
 I 'VFDUMODE,$D(^VFD(21615.1,1,4,"B",+DUZ)) S VFDQUIT=1 Q  ;EXCLUDED USER
 ; End screens
 ; 
 N VFDFDA,VFDIEN,VFDR S VFDR=$NA(VFDFDA(21615,"+1,"))
 S @VFDR@(.01)=$P(VFDHNDL,"~")
 S @VFDR@(.02)=+DUZ
 S @VFDR@(.03)=$P(VFDHNDL,"~",2)
 D UPDATE^DIE(,$NA(VFDFDA),$NA(VFDIEN))
 S VFDIENS=$G(VFDIEN(1))_","
 Q
 ;
TR(X) ; Translate control characters in message
 ; Note: The following temporarily translates all control characters to "|".
 ;       To do: Revise translation to meaningful values
 Q $TR(X,$C(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),"|||||||||||||||||||||||||||||||")
 ;
WRT ; Write one VFD RPC AUDIT LOG entry to archive file
 ; Assumes valid context
 Q:'$G(^VFD(21615,VFDA,0))  W ^(0),!
 S VFDFN=0 F  S VFDFN=$O(^VFD(21615,VFDA,1,VFDFN)) Q:'VFDFN  D
 .Q:'$G(^VFD(21615,VFDA,1,VFDFN,0))  W ^(0),!
 .F VFDI=1:1 Q:'$D(^VFD(21615,VFDA,1,VFDFN,1,VFDI,0))  W ^(0),!
 .Q
 W !
 Q
 ;
XCPT(VXDT,APPL,DESC,HLID,SVER,DATA,VFDXVARS) ; Record exception
 ; Wraps vxVistA exception handler
 I $T(XCPT^VFDXX)]"" D XCPT^VFDXX(.VXDT,.APPL,.DESC,.HLID,.SVER,.DATA,.VFDXVARS)
 Q
 ;
XP(X) ; Expand parameters in X
 S X=$G(X)
 N %,I,PAR F I=0:1 S %=$NA(XWB(5,"P",I)) Q:'(X[%)  D
 .S PAR=$G(@(%))
 .S X=$P(X,%)_$S(PAR=+PAR:PAR,1:""""_PAR_"""")_$P(X,%,2)
 .Q
 Q X
