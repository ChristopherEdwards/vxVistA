VFDXTNUM ;DSS/SGM - MODIFIED XTVNUM FOR DSS ;02 Dec 2009 11:31
 ;;2009.2;DSS,INC VXVISTA;;23 NOV 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;  This is a clone of the XTVNUM program to reset the version#
 ;  of routines.  Some of the differences from XTVNUM:
 ;  1. extraneous code removed
 ;  2. Check for third line to start with these characters
 ;     " ;Copyright"
 ;     If 3rd line does not start, then insert copyright statement
 ;     Else replace copyright statement on 3rd line
 ;
 ;DBIA# Supported References
 ;----- ------------------------------
 ;10005 DT^DICRW
 ;10026 ^DIR
 ;10048 FM read of Package file (#9.4)
 ;10086 HOME^%ZIS
 ;10103 ^XLFDT: $$FMTE, $$NOW, $$HTE
 ;10104 $$UP^XLFSTR
 ;10141 ^XPDUTL: $$PKG, $$VER
 ;
 ;Routine cloned, then enhanced from the XTVNUM routine
 ;XTVNUM ;SF-ISC/RWF - TO UPDATE THE VERSION NUMBER ;04/05/99  08:35
 ;;7.3;TOOLKIT;**20,39**;Apr 25, 1995
 ;
 N I,X,Y,Z,VFDCH,VROOT,XTVCH,XTV
 Q:$$ZOSF^VFDVZOSF("OS")'["OpenM"
 D DT^DICRW,HOME^%ZIS W @IOF
 S VROOT=$NA(^UTILITY($J))
 ; vfdch = 1-4
 ; vfdch(bld)   = 9.6 ien ^ build name ^ build ver ^ build patch#
 ; vfdch(copy)  = 1 if copyright to be added
 ; vfdch(date)  = external date for 1st or 2nd line
 ; vfdch(pkg)   = PACKAGE file name ^ pkg namespace
 ; vfdch(patch) = new patch number
 ; vfdch(ver)   = new version number
 F X="BLD","COPY","DATE","NMSP","PKG","PATCH","VER" S VFDCH(X)=""
 S X="Update Routine Version, Patch, 1st Line Date, Copyright"
 D MSG(X,1) S X=$$ASK^VFDXTRU(VROOT) I X<1 G KILL
 ; routine update option
 S X=$$DIR1 Q:X<1  S VFDCH=X S:X=4 VFDCH("COPY")=1
 ; if ch<4 then ask if copyright update
 I X<4 S X=$$DIR2 Q:X<0  S VFDCH("COPY")=X
 D BLDNM
 ; ask for new version number
 I VFDCH=1 S X=$$DIR4 S:X>0 VFDCH("VER")=X I X'>0 G KILL
 ; ask for patch number
 I VFDCH=2 S X=$$DIR5 S:X>0 VFDCH("PATCH")=X I X'>0 G KILL
 ; ask for date
 I 13[VFDCH S X=$$DIR6 S:X>0 VFDCH("DATE")=X I X'>0 G KILL
 ; ask for package name
 I VFDCH=1 S X=$$DIR7 S:X>0 VFDCH("PKG")=$P(X,U,2,3) I X=-1 G KILL
 ; see list of routines selected
 S X=$$DIR8 D:X<0 KILL Q:X<0  I X=1 D LIST^VFDXTRU(VROOT)
 ; continue
 I $$DIR9=1 D UPD,LIST
 ;
KILL K ^UTILITY($J),^TMP($J)
 Q
 ;
 ;=====================================================================
 ;                         Private Subroutines
 ;=====================================================================
BLDNM ; initialize VFDCH array if selected build
 N I,X,Y,Z,BLD
 S Z=$G(@VROOT@(0))
 S BLD=$P(Z,U,4) I BLD S VFDCH("BLD")=$P(Z,U,4,5)
 S Y=$P(Z,U,2) I Y'="" S VFDCH("PKG")=Y
 S Y=$P(Z,U,3) I Y'="" S $P(VFDCH("PKG"),U,2)=Y
 Q:'BLD  S X=$P(BLD,U,2)
 S Y=$$VER^XPDUTL(X) I +Y S $P(BLD,U,3)=Y
 S Y=$P(X,"*",3) I Y>0 S $P(BLD,U,4)=Y
 I X["*",Y=0 S $P(BLD,U,2)=$P(X,"*")_" "_$P(X,"*",2)
 S VFDCH("BLD")=BLD
 Q
 ;
COPY() ; return current up-to-date copyright statement
 ;;Document Storage Systems Inc. All Rights Reserved
 N X,Y S Y=1700+$E(DT,1,3)
 S X=" ;Copyright 1995-"_Y_","_$P($T(COPY+1),";",3)
 Q X
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
DIR1() ; update option
 ;;SO^1:New version#;2:Add a patch#;3:First line date;4:Copyright only
 ;;Option 1 will replace version# on 2nd line and will clear out patch list
 ;;Option 2 will add a patch number to the patch list on the 2nd line
 ;;Option 3 will update the date/time on the 1st line of the routines in a VA
 ;;  SACC compliant format.
 ;;Option 4 will just add the Copyright statment to the routines as the 3rd
 ;;  line of that routine.  It will use the copyright statement on the 3rd
 ;;  line of this routine as the template for all routines.  This program will
 ;;  change the TO date to the current date before inserting the 3rd line.
 N I,X,Y,Z
 S Z(0)=$P($T(DIR1+1),";",3,99)
 S Z("A")="Routine Update Option",Z("?")="   "
 F I=2:1:9 S X=$TR($T(DIR1+I),";"," ") S Z("?",I-1)=X
 D MSG("Routine Update Option",1)
 Q $$DIR
 ;
DIR2() ; ask if copyright to be updated
 ;;This will add the Copyright statment to the routines as the 3rd of
 ;;those routines.  It will use the copyright statement on the 3rd of
 ;;this routine as the template for all routines.  This program will
 ;;change the TO date to the current date before inserting the 3rd line
 N I,X,Y,Z
 S Z(0)="YOA",Z("B")="YES",Z("?")="   "
 S Z("A")="Update Copyright on 3rd line? "
 F I=1:1:4 S X=$TR($T(DIR1+I),";"," ") S Z("?",I)=X
 D MSG("Copyright Update",1)
 S X=$$DIR I X'=0,X'=1 S X=-1
 Q X
 ;
DIR4() ; ver#
 ;;Enter a version number to be placed in the 3rd ";"-piece on the 2nd
 ;;line of routines.  Valid version numbers are of the form nn.nn where
 ;;there must be at least one decimal number.  If you wish to use test
 ;;designations then you can append a Tnn or Vnn after the version number.
 N I,X,Y,Z
 S Z(0)="FO^1:8^K:'(X?1.N1"".""1.2N.1(1""T"",1""V"").2N) X"
 S Z("A")="Enter New Version Number",Z("?")="   "
 F I=1:1:4 S X=$TR($T(DIR4+I),";"," ") S Z("?",I)=X
 S X="New Version Number For Routine Second Line"
 D MSG(X,1)
 Q $$DIR
 ;
DIR5() ; patch#
 ;;Update Patch List With New Patch Number
 ;;This assumes that any existing patch list is in the proper syntax
 N I,X,Y,Z
 S Z(0)="NO^1:9999:0",Z("A")="Enter Patch Number"
 S Z("?")="Enter the whole number for this patch"
 S X=$P($T(DIR5+1),";",3) D MSG(X,1)
 S X=$TR($T(DIR5+2),";"," ") D MSG(X)
 Q $$DIR
 ;
DIR6() ; date
 ;;The SACC standards do not specify the meaning of the date with
 ;;optional time on the first line of the routine.  But it requires a
 ;;date there nevertheless.  Many utilities presume that the date on the
 ;;first line is the date/time that this routine was last modified.
 ;;
 ;;The date on the second line of the routine should only be set when a
 ;;new version of the package has been released.  The date should be the
 ;;date that the package was released for customer use.  This is date
 ;;only, time is not allowed.
 N I,X,Y,Z,DATE,NOW
 S X=$P($$HTE^XLFDT($H,9),":",1,2),DATE=$P(X,"@"),NOW=X
 S Z(0)="DO^::AEX" I VFDCH=3 D
 .S Z(0)=Z(0)_"T"
 .S Z("A")="Enter First Line Date(time)"
 .S Z("B")=NOW,Z("?")="   "
 .F I=1:1:4 S X=$TR($T(DIR6+I),";"," ") S Z("?",I)=X
 .S Y="First Line Date(time)"
 .Q
 I VFDCH=1 D
 .S Z("A")="Enter Package Release Date"
 .S Z("B")=DATE,Z("?")="   "
 .F I=6:1:9 S X=$TR($T(DIR6+I),";"," ") S Z("?",I-5)=X
 .S Y="Package Release Date"
 .Q
 D MSG(Y,1) S X=$$DIR I X>0 S X=$TR($$FMTE^XLFDT(X,9),"@"," ")
 Q X
 ;
DIR7() ; package
 ;;The 4th ";"-piece of the second line of routines must contain the
 ;;name of the package that is responsible for maintenance of this
 ;;routine.
 N I,X,Y,Z,VFDA
 S Z(0)="PO^9.4:QAEMZ"
 S X=$P(VFDCH("PKG"),U) S:X="" X="VENDOR - DOCUMENT STORAGE SYS"
 S Z("B")=X,Z("A")="Enter Package Name"
 F I=1:1:3 S X=$TR($T(DIR7+I),";"," ") S Z("?",I)=X
 D MSG("Package Name",1)
 S X=$$DIR(.VFDA) S:X="" X=-1 I VFDA>0 S X=(+X)_U_$P(VFDA(0),U,1,2)
 Q X
 ;
DIR8() ; list routines
 N I,X,Y,Z
 S Z("A")="Do wish to see a list of the routines selected? "
 S Z(0)="YOA",Z("B")="YES"
 Q $$DIR
 ;
DIR9() ; continue?
 N I,X,Y,Z
 S Z(0)="YOA",Z("A")="Do you wish to continue? ",Z("B")="NO"
 Q $$DIR
 ;
LIST ;
 ;;* - routines which had no action taken
 ;;@ - routines which for which the application had a problem
 D LIST^VFDXTRU(VROOT)
 W !,$TR($T(LIST+1),";"," ")
 W !,$TR($T(LIST+2),";"," ")
 Q
 ;
MSG(STR,CJ) S:$G(CJ) STR=$$CJ^XLFSTR(" "_STR_" ",79,"-") W !,STR Q
 ;
UPD ; actually update the routines
 N I,J,L,X,Y,Z,L1,L2,L3,L3U,COM,COPY,DOIT,LOAD,PKG,ROOT,ROU,SAVE
 S ROOT=$NA(^TMP($J))
 S LOAD=$$ZOSF^VFDVZOSF("LOAD",1,,,ROOT)
 S SAVE=$$ZOSF^VFDVZOSF("SAVE",1,,,ROOT)
 S COPY=$$COPY
 S COM="DOCUMENT STORAGE SYSTEMS"
 S X=0 F  S X=$O(@VROOT@(X)) Q:X=""  D
 .I X="VFDXTNUM" S @VROOT@(X)="*" Q
 .S DOIT=0 X LOAD
 .; date stamp the first line
 .I VFDCH=3,VFDCH("DATE")'="" D
 ..S L=@ROOT@(1),Y=$P(L,";",1,2)_";"_VFDCH("DATE")
 ..S @ROOT@(1)=Y,DOIT=1
 ..Q
 .; change version number on second line
 .I VFDCH=1,+VFDCH("VER"),VFDCH("DATE")'="" D
 ..S Y=VFDCH("PKG"),PKG=$P(Y,U) I PKG="" S PKG=$P(Y,U,2)
 ..Q:PKG=""
 ..S Z=" ;;"_VFDCH("VER")_";"_PKG_";;"_VFDCH("DATE")
 ..S @ROOT@(2)=Z,DOIT=1
 ..Q
 .; add patches
 .S L2=@ROOT@(2)
 .I VFDCH=2,+VFDCH("PATCH") D
 ..K Z S L=$TR($P(L2,";",5),"*")
 ..I $L(L) F J=1:1:$L(L,",") S Y=$P(L,",",2) S:Y Z(J)=Y,Z("B",Y)=J
 ..S Y=VFDCH("PATCH") Q:$D(Z("B",Y))  S J=1+$O(Z("A"),-1),Z(J)=Y
 ..S Y="",J=0 F  S J=$O(Z(J)) Q:'J  S Y=Y_Z(J)_","
 ..S Y=$E(Y,1,$L(Y)-1) Q:Y=""
 ..S $P(L2,";",5)="**"_Y_"**",@ROOT@(2)=L2,DOIT=1
 ..Q
 .; add copyright statement
 .I $S(VFDCH=4:1,'DOIT:0,1:+VFDCH("COPY")) D
 ..S L3=@ROOT@(3),L3U=$$UP(L3),L=2.1
 ..I L3=COPY S:VFDCH=4 DOIT=-1 Q
 ..S Y=$P(L3U,";",2) I $P(Y," ")="COPYRIGHT",Y[COM S L=3
 ..B  S @ROOT@(L)=COPY I VFDCH=4 S DOIT=1
 ..Q 
 .I DOIT>0 X SAVE
 .I DOIT<1 S @VROOT@(X)=$S('DOIT:"@",1:"*")
 .Q
 K @ROOT
 Q
 ;
UP(X) Q $S(X?.E1L.E:$$UP^XLFSTR(X),1:X)
