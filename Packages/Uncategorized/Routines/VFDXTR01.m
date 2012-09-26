VFDXTR01 ;DSS/SGM - VARIOUS ROUTINE UTILITIES;03 Feb 2009 17:21
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;This routine should only be invoked via the VFDXTR routine
 ;
 ; ICR#  Supported Description
 ;-----  ---------------------------------------------------
 ;
 Q
 ;
DEL ; delete selected routines
 N I,J,X,Y,Z,DEL,ROU
 Q:'$$ASK^VFDXTRU("ROU")
 D ASEL("ROU","ROUTINES TO BE DELETED")
 Q:$$DIR^VFDXTR09(1)'=1
 Q:$O(ROU(0))=""
 W !!,"Deleting these routines . . . ",!
 S DEL=$$DELCODE,X=0
 F  S X=$O(ROU(X)) Q:X=""  X DEL W $E(X_"          ",1,10) I $X>70 W !
 Q
 ;
 ;---------------------------------------------------------------------
 ;       GENERIC SUBROUTINES TO BE CALLED BY ANY VFDXTR* MODULE
 ;---------------------------------------------------------------------
ASEL(R,TITLE) ; ask if wish to see selected routines
 ;   R - opt - default to ^UTILITY($J)
 ;     expects list of routine names @R@(X)
 N I,X,Y,Z
 S R=$G(R) I R="" S R=$NA(^UTILITY($J))
 I $$DIR^VFDXTR09(2)=1 D LIST^VFDXTRU(R,$G(TITLE))
 Q
 ;
 ;--------------  P R I V A T E   S U B R O U T I N E S  --------------
DELCODE() ; create executable to delete a single routine
 Q $$ZOSF^VFDVZOSF("DEL",1)
