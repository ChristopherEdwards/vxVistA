VFDXTRSZ ;DSM/SGM - ROUTINE SIZE UTILITY;22 Mar 2008 22:40
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;This program will calculate routine size per the 3/2007 VA
 ;Programming SAC.  20K total size, 15K executable code size,
 ;5K minimum comment size.
 ;
 N I,X,Y,Z,CH,TMP,UTL
 S UTL=$NA(^UTILITY($J)) K @UTL
 S TMP=$NA(^TMP($J)) K @TMP
 ; ask for routine selection and get routines
 Q:$$ASK^VFDXTRU<1  S CH=$$DIR Q:"NS"'[CH
 W @IOF,"Calculating ... ",!
 S X=0 F  S X=$O(@UTL@(X)) Q:X=""  S @UTL@(X)=$$SIZE(X)
 D LIST
 Q
 ;
 ;======================== PRIVATE SUBROUTINES ========================
DIR() ; sort
 ;;You can sort the display by routine name or by the size of the
 ;;routines (# of characters) in descending order, that is, the routine
 ;;with the most characters will be displayed first
 ;;
 N I,X,Y,Z
 S Z(0)="SO^N:Routine Name;S:Size of routine (descending)"
 S Z("A")="Select sort type",Z("B")="Routine Name",Z("?")="   "
 F I=1:1:4 S Z("?",I)=$TR($T(DIR+I),";"," ")
 Q $$DIR^VFDXTRU1(.Z)
 ;
LIST ; display routine size
 ;;|Routine   | Total Size |Execute Size|Comment Size|Number Lines|
 ;;|----------|------------|------------|------------|------------|
 ; TOT = total number of routine
 ; TOT(1) = total size of all routines
 ; TOT(2) = total number of lines
 ; SORT() = rtn ^ exe size ^ non size ^ tot size ^ # lines
 N I,J,L,X,Y,Z,SP,TOT
 I $O(@UTL@(0))="" W !!,"No routine names found in "_UTL Q
 D MSG^VFDXTRU1("Routine List",1) W !
 I CH'="S" S (I,X)=0 F  S X=$O(@UTL@(X)) Q:X=""  S Y=^(X) D
 .S I=I+1,^TMP($J,1,I)=X_U_Y
 .Q
 I CH="S" D SORT
 S (TOT,TOT(1),TOT(2))=0,$P(SP," ",15)=""
 S L(1)=$P($T(LIST+1),";",3),L(2)=$P($T(LIST+2),";",3)
 W !!,?4,L(1),!?4,L(2)
 F I=1:1 S X=$G(^TMP($J,1,I)) Q:X=""  D
 .S Y="    |"_$P(X,U),$E(Y,16)="|"
 .S TOT=TOT+1 F J=2,3,4,5 D
 ..S A=$P(X,U,J),T=$J($FN(A,","),10)
 ..I J=2 S TOT(1)=TOT(1)+A S:A>20000 T=T_"*"
 ..I J=3,A>15000 S T=T_"*"
 ..I J=5 S TOT(2)=TOT(2)+A
 ..S Y=Y_$E(T_SP,1,12)_"|"
 ..Q
 .W !,Y
 .Q
 W !?4,L(2)
 S Y="    |"_$J($FN(TOT,","),9)_" |"_$J($FN(TOT(1),","),11)_" |"
 S Y=Y_"            |            |"_$J($FN(TOT(2),","),11)_" |"
 W !,Y
 Q
 ;
 ;=====================================================================
 ;                      CALCULATE SIZE OF ROUTINE
 ;=====================================================================
SIZE(X,VFDS) ; calculate size of routine
 ; either X or VFDS is required.
 ; X = routine name
 ; VFDS() contains routine at @vfds@(n) or @vfds@(n,0) where
 ;  @vfds@(n) is the nth line of the routine for n=1,2,3,4,...
 ; If $G(VFDS)'=""&($O(@VFDS@(0))=1) then ignore X even if passed
 ; Else get the routine X
 ; Return total_size^execute_size^comment_size^#_lines
 S X=$G(X),VFDS=$G(VFDS)
 N I,L,Y,Z,VRTN,ZTOT
 I VFDS'="" M VRTN=@VFDS
 I $O(VRTN(0))'=1,X'="" D  I '$D(VRTN) Q ""
 .K VRTN S Z=$$ZOSF^VFDVZOSF("LOAD",,X,,"VRTN")
 .I Z'=1 K VRTN
 .Q
 I '$D(VRTN(1)) Q ""
 F I=1:1:4 S ZTOT(I)=0
 F I=1:1 Q:'$D(VRTN(I))  D
 .S L=$G(VRTN(I)) S:L="" L=$G(VRTN(I,0)) Q:L=""
 .S Y=$L(L)+2,ZTOT(1)=ZTOT(1)+Y,ZTOT(4)=ZTOT(4)+1
 .I L?1" ;".E,$E(L,3)'=";" S ZTOT(3)=ZTOT(3)+Y
 .E  I L?1" ."." "1";".E S ZTOT(3)=ZTOT(3)+Y
 .E  S ZTOT(2)=ZTOT(2)+Y
 .Q
 Q ZTOT(1)_U_ZTOT(2)_U_ZTOT(3)_U_ZTOT(4)
 ;
SORT ; sort routine list by inverse size order
 N I,N,R,X,Y,Z,SZ
 S X=0 F  S X=$O(@UTL@(X)) Q:X=""  S Y=^(X),SZ=$P(Y,U) D
 .S ^TMP($J,0,-SZ,X)=X_U_Y
 .Q
 S I=0,N="" F  S N=$O(^TMP($J,0,N)) Q:'N  S X=0 D
 .F  S X=$O(^TMP($J,0,N,X)) Q:X=""  S I=I+1,Y=^(X),^TMP($J,1,I)=Y
 .Q
 Q
 ;
WR(X,CJ,SLF,ELF,LINE) ; do screen writes
 ; X - req - string to write out
 ; CJ - opt - single char to use in center justifying
 ; SLF - opt - # of leading line feeds, default to 1
 ; ELF - opt - # of ending line feeds, default to 0
 ; LINE - opt - if 1 then write a dashed line before write x
 ;              if 2 then write a dashed line after write x
 D WR^VFDXTRU($G(X),$G(CJ),$G(SLF),$G(ELF),$G(LINE))
 Q
