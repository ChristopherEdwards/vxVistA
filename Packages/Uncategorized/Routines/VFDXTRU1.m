VFDXTRU1 ;DSS/SGM - ROUTINE UTILITIES;22 Mar 2008 22:40
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;THIS ROUTINE SHOULD ONLY BE INVOKED VIA THE VFDXTRU ROUTINE
 ;
 ;DBIA# Supported References
 ;----- ------------------------------
 ;10026 ^DIR
 ;      ^DIC
 ;      ^DIC: $$FIND1, $$GET1
 ;      ^DIQ: $$GET1
 ;      ^XLFSTR - $$CJ
 ;=====================================================================
 ;               ASK FOR METHOD TO GET LIST OF ROUTINES
 ;=====================================================================
ASK() ;
 ;  VFDR - opt - named reference to put list of routines
 ;NOINIT - opt - if '$G(NOINIT) then K @VFDR
 ;SOURCE - opt - null or F or B or 9.6_ien>0
 ;Extrinsic Function returns
 ;  if problems, return -1, -2, or -3 (see DIR0
 ;  -1 if source="" and no method selected
 ;  else return number of routines selected
 ;                          
 ;NOTES: this will K ^UTILITY($J) if VFDR'=$NA(^UTILITY($J))&'NOINIT
 ;
 N I,X,Y,Z,UTL
 I SOURCE="" S SOURCE=$$DIR1 I +SOURCE=-1 Q SOURCE
 S UTL=$NA(^UTILITY($J))
 I UTL'=VFDR K @UTL K:'NOINIT @VFDR
 I UTL=VFDR,'NOINIT K @UTL
 I SOURCE="F" Q $$RSEL
 Q $$BLD
 ;
 ;=====================================================================
 ;                        WRITE MESSAGE HEADER
 ;=====================================================================
MSG(STR,CJ) S:$G(CJ) STR=$$CJ^XLFSTR(" "_STR_" ",79,"-") W !!,STR Q
 ;
 ;=====================================================================
 ;                   Private Subroutines for VFDXTR*
 ;=====================================================================
ASKFILE() ; interactive entry to prompt for file name
 ;  file not verified as to whether it exists or not
 ;  return user input or (null or -n if problems)
 N I,X,Y,Z
 S Z(0)="FO^3:80",Z("A")="Enter file name"
 Q $$DIR(.Z)
 ;
ASKPATH(VPATH) ; interactive entry to prompt for path name
 ; syntax of path is not verified
 ; VPATH - opt - default path
 ; return user input or <null>
 N I,X,Y,Z
 S Z(0)="FO^3:100",Z("A")="Enter directory name or path"
 S Z("A",1)="Format of path name is not verified as valid"
 S Z("A",2)="Examples:  c:\hfs\   SPL$:[SPOOL]"
 S Z("A",3)="",Z("B")=$S($G(VPATH)'="":VPATH,1:$$PATH)
 Q $$DIR(.Z)
 ;
BLD() ; get list of routines from BUILD file
 ; vret = total # rtns^ pkg name ^ pkg nmsp ^ build ien ^ build name
 N I,X,Y,Z,IEN,TOT,VRET,VFDBLD,VFDX
 I SOURCE="B" D  I X<1 Q X
 .S X=$$DIC(9.6,.VFDBLD) Q:X<1
 .S IEN=+X,VRET=U_$P(VFDBLD(0),U,2)_U_U_$P(VFDBLD,U,1,2)
 .Q
 I SOURCE>0 D  I +X=-1 Q X
 .N Y,Z,VFDX
 .S Z="`"_IEN,X=$$FIND1(9.6,Z) I X<1 S:X="" X=$$ERR(1) Q
 .S VRET="^^^"_X_U,IEN=+X
 .Q
 I $G(IEN)<1 Q $$ERR(2)
 D RTN^XTRUTL1(IEN) S (X,TOT)=0
 F  S X=$O(@UTL@(X)) Q:X=""  S TOT=TOT+1 S:UTL'=VFDR @VFDR@(X)=""
 I UTL'=VFDR K @UTL
 S $P(VRET,U)=TOT
 S X=$P(VRET,U,2) I X="" S $P(VRET,U,2)=$$GET1(9.6,IEN,1,"E")
 S X=$P(VRET,U,3) I X="" S $P(VRET,U,3)=$$GET1(9.6,IEN,"1:1","E")
 S X=$P(VRET,U,4) I 'X S $P(VRET,U,4)=IEN
 S X=$P(VRET,U,5) I X="" S $P(VRET,U,5)=$$GET1(9.6,IEN,.01,"E")
 S @VFDR@(0)=VRET
 Q TOT
 ;
DIC(FILE,XBLD) ;  utility to invoke ^DIC
 N X,Y,DIC,DTOUT,DUOUT
 S DIC=FILE,DIC(0)="QAEMZ" W ! D ^DIC
 I Y<1!$D(DTOUT)!$D(DUOUT) Q -1
 M XBLD=Y
 Q Y
 ;
DIR(VFDA) ; Prompter
 ; return y or -1 if ^-out, -2 if timeout, or -3 if ^^-out
 ; Expects Z() = DIR()
 N I,R,X,Y,DIR,DIROUT,DIRUT,DTOUT,DUOUT
 M DIR=Z I $G(Z(0))="" Q -1
 W ! D ^DIR
 S X=$S($D(DTOUT):-2,$D(DUOUT):-1,$D(DIROUT):-3,Y="":-1,Y?." ":-1,1:Y)
 M VFDA=Y
 Q X
 ;
DIR1() ; method to get routines
 ;;You can get the list of routines from KIDS Build file entry
 ;;Or you can select the routines from the routine select utility
 N I,X,Y,Z
 S Z(0)="SO^F:Free Form;B:Build File",Z("?")="   "
 S Z("A")="Choose Routine Selection Method"
 F I=1,2 S X=$TR($T(DIR1+I),";"," ") S Z("?",I-1)=X
 D MSG("Routine Selection Method",1)
 S X=$$DIR S:X="" X=-1
 Q X
 ;
ERR(A) ;
 N T
 I A=1 S T="KIDS Build file with ien "_SOURCE_" not found"
 I A=2 S T="Error getting data from Build record number "_SOURCE
 I A=3 S T="No routines found in KIDS Build IEN: "_SOURCE
 I A=4 S T="No value for path received"
 I A=5 S T="No host files server (HFS) name received"
 I A=6 S T="No value for the ROOT parameter received"
 Q "-1^"_T
 ;
FIND1(FILE,VAL) ;
 N I,X,Y,Z,DIERR,VFDER
 S X=$$FIND1^DIC(FILE,,"QUX",VAL,,,"VFDER")
 I $D(DIERR) S X="-1^Error encountered"
 Q X
 ;
GET1(FILE,IENS,FLD,FLAG) ;
 N X,Y,Z,DIERR,VFDER
 S IENS=IENS_","
 S X=$$GET1^DIQ(FILE,IENS,FLD,FLAG,,"VFDER")
 I $D(DIERR) S X=""
 Q X
 ;
RSEL() ; call M routine selector
 N I,X,Y,Z,TOT
 S TOT=0,Y=$$ZOSF^VFDVZOSF("RSEL"),X=0
 F  S X=$O(@UTL@(X)) Q:X=""  S TOT=TOT+1 S:UTL'=VFDR @VFDR@(X)=""
 I TOT S @VFDR@(0)=TOT
 I UTL'=VFDR K @UTL
 Q TOT
 ;
UP(A) Q $$UP^XLFSTR(A)
 ;
 ;---------------------------------------------------------------------
 ;                            %ZISH Wrapper
 ;---------------------------------------------------------------------
FTG(PATH,FILE,ROOT,INC) ; move HFS file to a global
 ; ROOT - opt - $NAME value to place file in
 ;              default to ^TMP("VFDXTR",$J,1) and initialize it
 ;  INC - opt - node in ROOT to be incremented; default to $QL(ROOT)
 ;Return 1 if successful, 0 if not successful, or -1^message
 N I,X,Y,Z
 S X=$$ZINIT(12) I X<0 Q X
 Q $$FTG^%ZISH(PATH,FILE,ROOT,INC)
 ;
GTF(PATH,FILE,ROOT,INC) ; move array to HFS file
 ; ROOT - req - $NAME value which holds data for file
 ;  INC - opt - the node in ROOT to be incremented
 ;              default to $QL(ROOT)
 ;Return 1 if successful, 0 if not successful, or -1^message
 N I,X,Y,Z
 S X=$$ZINIT(123) I X<0 Q X
 Q $$GTF^%ZISH(ROOT,INC,PATH,FILE)
 ;
LIST(PATH,VFLIST,VFRET) ; call list^%zish
 ; vflist - req -$name of array that contains file(s) to get
 ;          OR single value equal to name of file; use to check for
 ;          existence of file
 ; vfret - opt - $name of array to return files found
 ;         DO NOT pass if checking for existence of a single file
 ;Return 1 if success, else return 0 or 0^msg
 N I,X,Y,Z
 S X=$$ZINIT(1) I X<0 Q X
 I $G(VFLIST)="" Q "0^No file(s) received"
 I $G(VFLIST)'="",'$D(VFRET) S VFLIST(VFLIST)=""
 I $G(VFRET)="" S VFRET="Z" ; don't return list of files
 Q $$LIST^%ZISH(PATH,$G(VFLIST),$G(VFRET))
 ;
LIST1(VFDV,PATH,EXT,FILES) ; get list of files
 ;  EXT - opt - passed by reference - list of file extensions to get
 ;              Example: EXT("KID")
 ;              extension will be treated as case insensitive
 ;FILES - opt - passed by reference - list of specific files to get
 ;              If $D(FILES) ignore EXT()
 ;If '$D(EXT),'$D(FILES) then get all files starting with an alpha
 ; VFDV - return @VFDV@(upper_filename,upper_ext)=<total number>
 ;        @VFDV@(upper_filename,upper_ext,i)=<actual file name>
 ;        if the OS allows files with same name but different case,
 ;        then you will get back all filenames sorted together
 ;Extrinsic funtion - return 1 if files list returned, else return 0
 ;                    or -1^msg
 N A,B,I,L,X,Y,Z,EXTX,FILEX,RETX,TMP,TOT
 S X=$$ZINIT(1) I X<0 Q X
 I $G(VFDV)="" Q 0
 I $D(FILES) M TMP=FILES
 E  I $D(EXT) S X=0 F  S X=$O(EXT(X)) Q:X=""  D
 .S TMP("*."_X)="" S:X?.E1L.E TMP("*."_$$UP(X))=""
 .Q
 I '$D(TMP) F I=65:1:90,97:1:122 S TMP($C(I)_"*")=""
 S X=$$LIST(PATH,"TMP","RETX")
 I X'=1 Q 0
 S A="" F  S A=$O(EXT(A)) Q:A=""  I A?.E1L.E K EXT(A) S EXT($$UP(A))=""
 S X="" F  S X=$O(RETX(X)) Q:X=""  D
 .S L=$L(X,"."),Y=$P(X,".",1,L-1),Z=$P(X,".",L)
 .S EXTX=Z I Z?.E1L.E S EXTX=$$UP(Z)
 .S FILEX=Y I Y?.E1L.E S FILEX=$$UP(Y)
 .I '$D(FILES),$D(EXT),'$D(EXT(EXTX)) Q
 .S A=1+$G(@VFDV@(FILEX,EXTX)),@VFDV@(FILEX,EXTX)=A
 .S @VFDV@(FILEX,EXTX,A)=X
 .Q
 Q $O(@VFDV@(0))'=""
 ;
PATH() Q $$PWD^%ZISH
 ;
ZINIT(A) ;
 S A=$G(A)
 I A[1,$G(PATH)="" Q $$ERR(4)
 I A[2,$G(FILE)="" Q $$ERR(5)
 I A'[3,$G(ROOT)="" S ROOT=$NA(^TMP("VFDXTR",$J,1)),INC=3 K @ROOT
 I A[3,$G(ROOT)="" Q $$ERR(6)
 I $G(INC)="" S INC=$QL(ROOT)
 Q 1
