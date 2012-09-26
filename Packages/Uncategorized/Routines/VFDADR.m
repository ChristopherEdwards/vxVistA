VFDADR ;DSS/LM - VFD ADDRESS file API support ; 5/9/2008
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;See also routine ^VFDPSUTL for related APIs
 ;
 Q
SITE(VFDFILE,VFDIEN,VFDFLD) ;[Public] Return IEN of related OUTPATIENT SITE (File 59)
 ; entry for given file and entry number.
 ; 
 ; VFDFILE=[Required] File number
 ; VFDIEN=[Required] Entry number
 ; VFDFLD=[Optional] Field number
 ; 
 ; If VFDFILE is a subfile, VFDIEN must be an IENS
 ; 
 ; Returns a File 59 internal entry number, or -1^Error Text
 ; 
 Q $$SITE^VFDADR1(.VFDFILE,.VFDIEN,.VFDFLD)
 ;
ADR(VFDFILE,VFDIEN,VFDFLD,VFDPKG) ;[Public] Return IEN of related VFD ADDRESS (File 21612)
 ; entry for given file and entry number.
 ; 
 ; VFDFILE=[Required] File number
 ; VFDIEN=[Required] Entry number
 ; VFDFLD=[Optional] Field number
 ; VFDPKG=[Optional] Package prefix, default=PS
 ; 
 ; If VFDFILE is a subfile, VFDIEN must be an IENS
 ; 
 ; Returns a File 21612 internal entry number, or -1^Error Text
 ; 
 Q $$ADR^VFDADR1(.VFDFILE,.VFDIEN,.VFDFLD,.VFDPKG)
 ;
