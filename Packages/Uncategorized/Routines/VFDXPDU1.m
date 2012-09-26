VFDXPDU1 ;DSS/LM - Build/Transport/Install support ; 5/9/2008
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;Reference: ICR 1157
 ;
ADD(MENU,OPT,SYN,ORD) ;From ADD^VFDXPDU - Wraps ADD^XPDMENU
 ;Add options to a menu or extended action
 ;
 ;See ADD^VFDXPDU for details
 ;
 I $L($G(MENU)),$L($G(OPT)) S SYN=$G(SYN),ORD=$G(ORD)
 E  Q "-1^Required parameter missing or invalid"
 N VFD S VFD=$$ADD^XPDMENU(MENU,OPT,SYN,ORD)
 Q $S(VFD:VFD,1:"-1^ADD~XPDMENU returned an error: "_$P(VFD,U,2))
 ;
DELETE(MENU,OPT) ;From DELETE^VFDXPDU - Wraps DELETE^XPDMENU
 ;Delete item from menu or extended action.
 ;
 ;See DELETE^VFDXPDU for details
 ;
 I $L($G(MENU)),$L($G(OPT)) N VFD S VFD=$$DELETE^XPDMENU(MENU,OPT)
 E  Q "-1^Required parameter missing or invalid"
 Q $S(VFD:VFD,1:"-1^ADD~XPDMENU returned an error: "_$P(VFD,U,2))
 ;
RENAME(OLD,NEW) ;From RENAME^VFDXPDU - Wraps RENAME^XPDMENU
 ;Rename option
 ;
 ;See RENAME^VFDXPDU for details
 ;
 I $L($G(OLD)),$L($G(NEW)) D RENAME^XPDMENU(OLD,NEW)
 Q
LKOPT(X) ;From LKOPT^VFDXPDU - Wraps LKOPT^XPDMENU
 ;Lookup option on "B" cross-reference
 ;
 ;See LKOPT^VFDXPDU for details
 ;
 I $L($G(X)) Q $$LKOPT^XPDMENU(X)
 E  Q "-1^Required parameter missing or invalid"
 ;
OUT(OPT,TXT) ;From OUT^VFDXPDU - Wraps OUT^XPDMENU
 ;Set option out of order
 ;
 ;See OUT^VFDXPDU for details
 ;
 I $L($G(OPT)) S TXT=$G(TXT) D OUT^XPDMENU(OPT,TXT)
 Q
