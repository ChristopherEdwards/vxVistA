VFDDFN ;DSS/LM - Utilities supporting PATIENT lookup ;June 5, 2008
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ; See also routine ^DSIWDPT (aka ^VFDWDPT)
 ; 
 Q
ID(VFDFN,VFDLOC,VFDTYPE,VFDXDT) ;[Public] Return PATIENT alternate ID
 ; satisfying the given parameters
 ; 
 ; VFDFN=[Required]   Patient IEN
 ; 
 ; VFDLOC=[Optional]  File 9999999.06 IEN (=File 4 IEN) or "*" for ANY
 ;                    Default=+$$SITE^VASITE()
 ; 
 ; VFDTYPE=[Optional] #.05 subfield value to match
 ;                    Defaults to either the DEFAULT (active) entry =or=
 ;                    the MRN type alternate ID
 ;                    
 ; VFDXDT=[Optional]   Fileman Date.Time Defaults to TODAY.
 ;                    Screen out, if EXPIRATION DATE < or = VFDXDT.
 ;                    
 ; Returns alternate ID or -1^Text
 ; 
 I $G(VFDFN)>0 S VFDLOC=$G(VFDLOC,+$$SITE^VASITE),VFDTYPE=$G(VFDTYPE),VFDXDT=$G(VFDXDT,$$DT^XLFDT)
 E  Q "-1^Missing or invalid patient IEN (DFN)"
 Q:'(VFDLOC!(VFDLOC="*")) "-1^Invalid location value"
 N VFDERR,VFDI,VFDJ,VFDX,VFDY S (VFDI,VFDJ)=0,(VFDERR,VFDY)=""
 F  S VFDI=$O(^DPT(+VFDFN,21600,VFDI)) Q:'VFDI!$L(VFDY)!VFDERR  D
 .S VFDX=$G(^(VFDI,0)) I VFDLOC Q:'(VFDLOC=$P(VFDX,U))
 .I $L(VFDTYPE) Q:'(VFDTYPE=$$UP^XLFSTR($P(VFDX,U,5)))
 .I $P(VFDX,U,3) Q:'(VFDXDT<$P(VFDX,U,3))
 .; Fall through on satisfying all constraints
 .I $L(VFDTYPE) S VFDY=$P(VFDX,U,2) Q  ;Matches specified type
 .; Type is complex - Defaults first to DEFAULT alternate ID
 .I $P(VFDX,U,4)=1 S VFDY=$P(VFDX,U,2) Q  ;Default
 .Q:'($$UP^XLFSTR(($P(VFDX,U,5)))="MRN")  ;Not default, not MRN
 .S VFDJ=VFDJ+1,VFDY(VFDJ)=$P(VFDX,U,2) ; Candidate value
 .Q
 ;
 Q:$L(VFDY) VFDY ;Unique match (or default) found
 I $O(VFDY(""),-1)=1 Q VFDY(1) ;Match to MRN
 I $O(VFDY(""),-1)>1 Q "-1^More than one alternate ID match"
 Q "-1^No match found" ;
 ;
DFN(VFDAID,VFDLOC,VFDTYPE,VFDXDT) ;[Public] Return PATIENT IEN
 ; satisfying the given parameters
 ;  
 ; VFDAID-[Required]  Alternate ID value to match
 ; 
 ; VFDLOC=[Optional]  File 9999999.06 IEN (=File 4 IEN) or "*" for ANY
 ;                    Default=+$$SITE^VASITE()
 ; 
 ; VFDTYPE=[Optional] #.05 subfield value to match
 ;                    Defaults to either the DEFAULT (active) entry =or=
 ;                    the MRN type alternate ID
 ;                    
 ; VFDXDT=[Optional]   Fileman Date.Time Defaults to TODAY.
 ;                    Screen out, if EXPIRATION DATE < or = VFDXDT.
 ;                    
 ; Returns DFN or -1^Text
 ;
 I $L($G(VFDAID)) S VFDLOC=$G(VFDLOC,+$$SITE^VASITE),VFDTYPE=$G(VFDTYPE),VFDXDT=$G(VFDXDT,$$DT^XLFDT)
 E  Q "-1^Missing or invalid patient ID (Alternate ID)"
 Q:'(VFDLOC!(VFDLOC="*")) "-1^Invalid location value"
 N VFDA,VFDFN,VFDJ,VFDL,VFDX,VFDY S VFDJ=0,(VFDL,VFDY)=""
 F  S VFDL=$O(^DPT("AVFD",VFDL)) Q:'VFDL!VFDY  D:VFDL=VFDLOC!'VFDLOC
 .S VFDFN="" F  S VFDFN=$O(^DPT("AVFD",VFDL,VFDAID,VFDFN)) Q:'VFDFN!VFDY  D
 ..S VFDA=""  F  S VFDA=$O(^DPT("AVFD",VFDL,VFDAID,VFDFN,VFDA)) Q:'VFDA!VFDY  D
 ...S VFDX=$G(^DPT(VFDFN,21600,VFDA,0)) ;Location OK
 ...I $L(VFDTYPE) Q:'(VFDTYPE=$$UP^XLFSTR($P(VFDX,U,5)))
 ...I $P(VFDX,U,3) Q:'(VFDXDT<$P(VFDX,U,3))
 ...; Fall through on satisfying all constraints
 ...I $L(VFDTYPE) S VFDY=VFDFN Q  ;Matches specified type
 ...; Type is complex - Defaults first to DEFAULT alternate ID
 ...I $P(VFDX,U,4)=1 S VFDY=VFDFN Q  ;Default
 ...Q:'($$UP^XLFSTR(($P(VFDX,U,5)))="MRN")  ;Not default, not MRN
 ...S VFDJ=VFDJ+1,VFDY(VFDJ)=VFDFN ; Candidate value
 ...Q
 ..Q
 .Q
 ;
 Q:VFDY VFDY ;Unique match (or default) found
 I $O(VFDY(""),-1)=1 Q VFDY(1) ;Match to MRN
 I $O(VFDY(""),-1)>1 D  ;More than one alternate ID match - May be same DFN
 .S VFDY=VFDY(1) F VFDJ=2:1 Q:'$D(VFDY(VFDJ))  I '(VFDY=VFDY(VFDJ)) S VFDY="" Q
 .Q
 Q:VFDY VFDY ;More than one matching AID entry resolve to the same DFN
 Q "-1^No match found or ambiguous match" ;
 ;
