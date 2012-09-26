VFDXTR09 ;DSS/SGM - DIR PROMPTING UTILITY;03 Feb 2009 17:21
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;This routine should only be invoked from other VFDXTR routines
 ;
 ; ICR#  Supported Description
 ;-----  --------------------------------------------
 ;
 ;
DIR(L) ; DIR call
 ; L - req - line tag to use to set up DIR()
 ; return value of Y from DIR call
 ;   or if timeout return -3, if ^-out return -2
 N I,J,X,Y,Z,DIR,DIROUT,DIRUT,DTOUT,DUOUT
 I $G(L)'?1.N Q $$ERR(1)
 I $T(@L)="" Q $$ERR(1)
 D @L W ! D ^DIR I $D(DUOUT)!$D(DIRUT)!$D(DIROUT) S Y=-2
 I $D(DTOUT) S Y=-3
 Q Y
 ;
 ;--------------  P R I V A T E   S U B R O U T I N E S  --------------
ERR(A) ;
 N T
 I A=1 S T="API called improperly"
 Q "-1^"_T
 ;
1 ; are you sure
 S DIR(0)="YOA",DIR("B")="No"
 S DIR("A")="Do you wish to continue? "
 Q
 ;
2 ; list routines?
 S DIR(0)="YOA",DIR("A")="Display the list of routines? "
 S DIR("B")="YES"
 Q
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
