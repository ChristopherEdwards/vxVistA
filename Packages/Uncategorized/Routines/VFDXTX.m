VFDXTX ;DSS/LM - Implementation-specific API support ;13 Aug 2009 14:50
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ; Line tags above the Private Subroutines may be called from external
 ; references
 ;
 Q
X(VFDAPI) ; Xecute an implementation-specific or supported API
 ; VFDAPI - req - Supported API exact name
 ; 
 Q:'$L($G(VFDAPI))  N VFDSIEN,VFDX
 S VFDSIEN=$O(^VFD(21614.1,"B",VFDAPI,0)) Q:'VFDSIEN
 ; check for implementation specific xecute first, then check for
 ; supported API default xecute
 S VFDX=$G(^VFD(21614,VFDSIEN,1))
 I VFDX="" S VFDX=$G(^VFD(21614.1,VFDSIEN,2))
 I VFDX'="" X VFDX
 Q
 ;
TOHEX(X) ; String to hex
 ; X - req - ASCII string to be converted to hex
 ; 
 N %,Y
 S Y="" F %=1:1:$L($G(X)) S Y=Y_$TR($J($$CNV^XLFUTL($A($E(X,%)),16),2)," ",0)
 Q Y
 ;
FRHEX(X) ; Hex to string
 ; X - req - Hex string to be converted to decimal
 ; 
 N %,Y
 S Y="" F %=1:2:$L($G(X)) S Y=Y_$C($$DEC^XLFUTL($E(X,%,%+1),16))
 Q Y
 ;
 ;-----------------------  PRIVATE SUBROUTINES  -----------------------
DIM(X) ; Check X in ^DIM
 ; X - req - Non-empty M code string to check
 I $L($G(X)) D ^DIM Q $D(X)
 Q 0
 ;
OK(X,VFDTYPE) ;[Private] Miscellaneous check X
 ;       X - req - Non-empty M code string to check
 ; VFDTYPE - opt - 0=DEFAULT (default), 1=IMPLEMENTATION-SPECIFIC
 ;sgm - 8/13/2009 - no longer used
 S VFDTYPE=$G(VFDTYPE,0)
 I $L($G(X)) ;Non-empty
 ;I $T,'VFDTYPE!$D(^VFD(21614,"C",$P($$SITE^VASITE,U,3),VFDSIEN))
 ; Insert other checks here
 Q $T
