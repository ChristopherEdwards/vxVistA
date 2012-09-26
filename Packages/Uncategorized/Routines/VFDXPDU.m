VFDXPDU ;DSS/LM - Build/Transport/Install support ; 5/9/2008
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;Reference: ICR 1157
 ;
ADD(MENU,OPT,SYN,ORD) ;Extrinsic function - Wraps ADD^XPDMENU
 ;Add options to a menu or extended action
 ;
 ;MENU=[Required] Target option NAME
 ;OPT=[Required] Option NAME to add
 ;SYN=[Optional] Synonym
 ;ORD=[Optional  Display order
 ;
 ;Returns 0=success or -1^Message on failure
 ;
 Q $$ADD^VFDXPDU1(.MENU,.OPT,.SYN,.ORD)
 ;
DELETE(MENU,OPT) ;Extrinsic function - Wraps DELETE^XPDMENU
 ;Delete item from menu or extended action.
 ;
 ;MENU=[Required] Target option NAME
 ;OPT=[Required] Option NAME to add
 ;
 ;Returns 0=success or -1^Message on failure
 ;
 Q $$DELETE^VFDXPDU1(.MENU,.OPT)
 ;
RENAME(OLD,NEW) ;Procedure - Wraps RENAME^XPDMENU
 ;Rename option
 ;
 ;OLD=[Required] Old option NAME
 ;NEW=[Required] New option NAME
 ;
 ;No return value
 ;
 D RENAME^VFDXPDU1(.OLD,.NEW)
 Q
LKOPT(X) ;Extrinsic function - Wraps LKOPT^XPDMENU
 ;Lookup option on "B" cross-reference
 ;
 ;X=[Required] Option NAME
 ;
 ;Returns Option IEN if found, or the empty string if not found.
 ;        -1^Message if error
 ;
 Q $$LKOPT^VFDXPDU1(.X)
 ;
OUT(OPT,TXT) ;Procedure - Wraps OUT^XPDMENU
 ;Set option out of order
 ;
 ;OPT=[Required] NAME of option to set out of order
 ;TXT=[Required] Text of out-of-order message
 ;
 ;No return value
 ;
 D OUT^VFDXPDU1(.OPT,.TXT)
 Q
