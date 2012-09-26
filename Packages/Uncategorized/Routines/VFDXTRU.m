VFDXTRU ;DSS/SGM - ROUTINE UTILITIES;24 Mar 2008 10:23
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ; ICR#   Description
 ;------  -------------------------------------------------------
 ;        $$CJ^XLFSTR
 ;
 ;
 ;                  Main driver for VFDXTRU* routines
 ;============== ASK FOR METHOD TO GET LIST OF ROUTINES ===============
 ;  VFDR - opt - named reference to put list of routines
 ;               default to ^UTILITY($J)
 ;               @VFDR@(0) = total number of routines
 ;               @VFDR@(routine name)=""
 ;NOINIT - opt - Boolean - if '$G(NOINIT) then K @VFDR prior to loading
 ;               routines.  Default to 0
 ;SOURCE - opt - default - if "" then ask for method
 ;               if equals "F" then use routine selector
 ;               if equals "B" then ask for BUILD file name
 ;               if +source>0 then source=BUILD file ien
 ;Extrinsic Function returns
 ;  if problems, return -1, -2, or -3 (see DIR^VFDXTU1)
 ;  -1 if source="" and no method selected
 ;  else return number of routines selected
 ;Return @VFDR@(n) where
 ;  if n=0 @vfdr@(0)=p1^p2^p3^p4^p5
 ;p1=tot # rtns   p2=pkg name  p3=pkg nmsp  p4=build ien  p5=build name
 ;  if n'=0 @vfdr@(routine name)=""
 ;                          
 ;NOTES: this will K ^UTILITY($J) if VFDR'=$NA(^UTILITY($J))&'NOINIT
ASK(VFDR,NOINIT,SOURCE) ;
 S NOINIT=+$G(NOINIT),SOURCE=$G(SOURCE),VFDR=$G(VFDR)
 I VFDR="" S VFDR=$NA(^UTILITY($J))
 Q $$ASK^VFDXTRU1
 ;
 ;=============  GENERIC DIR PROMPTER EXTRINSIC FUNCTION  =============
 ;This will use file 21604 to build the DIR() array.  It will set up
 ;the DIR call, call DIR, and return the value of Y or Y(0)
 ; VAL - opt - lookup value (name or ien) to file 21604
 ; RTN - opt - name of routine where this is called from
 ; TAG - opt - line tag in routine where this is called from
 ; SCR - opt - Fileman screen logic when doing a ^DIC call to find the
 ;             entry for the input value.
 ;REQUIRED - VAL must be passed OR RTN & TAG passed
 ;RETURN - if problems return -1^message
 ;         if no problems return Y or Y_U_Y(0) if Y(0) exists
 ;         if "^".E was entered, then return -2
 ;         if "^^" was entered then return -3
 ;         if timeout occurred then return -4
DIR(VAL,RTN,TAG,SCR) ;
 N A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 N DA,DIC,DIR,DIROUT,DIRUT,DTOUT,DUOUT
 F X="VAL","RTN","TAG","SCR" S @(X_"=$G(@X)")
 I VAL="",RTN="" Q "-1^API improperly called"
 Q
 ;
 ;====================== DISPLAY LIST OF ROUTINES =====================
 ; R - opt - named reference which contains routine names
 ;  Default to ^UTILITY($J)
 ; TITLE - opt - title to display before list of routines 
 ;Expects @R@(routine name)=value
 ;  value is usually null.  If it is equal to a single punctuation char
 ;    then append that char to beginning of routine name
 ;
LIST(R,TITLE) ; display list of routines
 N I,X,Y,Z,SP,TOT
 S TITLE=$G(TITLE) I TITLE'="" D WR(TITLE," ",1,,12)
 S (X,TOT)=0,$P(SP," ",15)=""
 W ! F  S X=$O(@R@(X)) Q:X=""  S Y=@R@(X) D
 .S Z=X,TOT=1+TOT
 .I Y?1P,Y'=" " S Z=Y_X,TOT(Y)=1+$G(TOT(Y))
 .W $E(Z_SP,1,10) W:$X>70 !
 .Q
 W !!,"Total number of routines: "_TOT
 I $O(TOT(0)) S X=0 D
 .F  S X=$O(TOT(X)) Q:X=""  W !,"Total routines with "_X_":    "_TOT(X)
 .Q
 I TITLE'="" D WR(,,-1,1,2)
 Q
 ;
 ;
 ;===================== CALCULATE SIZE OF ROUTINE =====================
SIZE(X,VFDS) ; calculate size of routine
 ; either X or VFDS is required.
 ; X = routine name
 ; VFDS() contains routine at @vfds@(n) or @vfds@(n,0) where
 ;  @vfds@(n) is the nth line of the routine for n=1,2,3,4,...
 ; If $G(VFDS)'=""&($O(@VFDS@(0))=1) then ignore X even if passed
 ; Else get the routine X
 ; Return execute_size^comment_size^total_size^#_lines
 Q $$SIZE^VFDXTRSZ($G(X),$G(VFDS))
 ;
 ;==================== COMMON SCREEN WRITE UTILITY ====================
WR(X,CJ,SLF,ELF,LINE) ; do screen writes
 ; X - req - string to write out
 ; CJ - opt - single char to use in center justifying
 ; SLF - opt - # of leading line feeds, default to 1
 ;             if SLF<0 then no leading line feeds
 ; ELF - opt - # of ending line feeds, default to 0
 ; LINE - opt - if 1 then write a dashed line before write x
 ;              if 2 then write a dashed line after write x
 N I,L,Y,Z
 S X=$G(X),$P(L,"-",80)=""
 S CJ=$G(CJ),LINE=$G(LINE)
 S SLF=$G(SLF) S:'SLF SLF=1
 I SLF>0 F I=1:1:SLF W !
 I LINE[1 W L,!
 S Y=X S:CJ'="" Y=$$CJ^XLFSTR(X,80,CJ) W Y
 I LINE[2 W !,L
 I $G(ELF) F I=1:1:ELF W !
 Q
