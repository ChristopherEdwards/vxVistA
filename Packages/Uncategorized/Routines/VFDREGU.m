VFDREGU ;DSS/LM - Patient/Person Registration Utilities - 10/4/2005
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;  DBIA#  Supported References
 ;  -----  -----------------------------------------------------
 ;   2171  $$NNT^XUAF4
 ;   2541  $$KSP^XUPARAM
 ;
 Q
ISVOE() ;;Is (this environment) VistA Office EHR?
 ;
 N VFDRDINS S VFDRDINS=$$KSP^XUPARAM("INST") ;KSP Default Institution
 Q:'VFDRDINS 0 ;No default institution
 N VFDRINS S VFDRINS=$$NNT^XUAF4(VFDRDINS) ;NAME^NUMBER^TYPE
 Q $P(VFDRINS,U,3)="VOE"
 ;
ENV(VFDRSLT) ;;Type of environment
 ; Returns internal value of field 95 for default INSTITUTION.
 ; If field 95 is null, returns "V"
 ; 
 S VFDRSLT=$$GET1^DIQ(4,+$$KSP^XUPARAM("INST"),95,"I")
 S:VFDRSLT="" VFDRSLT="V"
 Q
 ;
AGE(VFDDOB,VFDATE) ;;Pediatric-aware age
 ; VFDDOB=Date of Birth in FileMan format
 ; VFDATE=Reference date for age (optional)
 ; 
 ; Returns age in days, months or years
 ; Examples: 9d, 13m, 29 (no suffix implies years)
 ; 
 I $G(VFDDOB) S VFDATE=$G(VFDATE,DT)
 E  Q "" ;Date of Birth required
 N VFDDAYS,VFDWEKS,VFDMONS
 S VFDDAYS=$$GET^XPAR("ALL","VFDR AGE IN DAYS")
 S VFDWEKS=$$GET^XPAR("ALL","VFDR AGE IN WEEKS")
 S VFDMONS=$$GET^XPAR("ALL","VFDR AGE IN MONTHS")
 ;
 ; To do: Replace above with VFDR AGE multi-instance parameter and use ^VFDCXPR
 ; N VFDLIST D GET^VFDCXPR(.VFDLST,"~VFDR AGE")
 ; 
 ; INSTANCE DOMAIN: 1:DAYS;2:WEEKS;3:MONTHS
 ; 
 ; Example return
 ; VFDLST(1)="1^DAYS^14^14"
 ; VFDLST(2)="2^WEEKS^12^12"
 ; VFDLST(3)="3^MONTHS^12^12"
 ; 
 S:'VFDDAYS VFDDAYS=30 S:'VFDWEKS VFDWEKS=26 S:'VFDMONS VFDMONS=24 ;Defaults
 N %Y,X,X1,X2,W S X1=DT,X2=VFDDOB D ^%DTC ;Age in days
 Q:'(VFDDAYS<X) X_"d"
 S W=X\7 Q:'(VFDWEKS<W) W_"w"
 S VFDDOBY=$E(VFDDOB,1,3),VFDDOBM=$E(VFDDOB,4,5),VFDDOBD=$E(VFDDOB,6,7)
 N M S M=$E(VFDATE,1,3)-$E(VFDDOB,1,3)*12+$E(VFDATE,4,5)-$E(VFDDOB,4,5)-($E(VFDATE,6,7)<$E(VFDDOB,6,7))
 Q:'(VFDMONS<M) M_"m"
 Q $E(VFDATE,1,3)-$E(VFDDOB,1,3)-($E(VFDATE,4,7)<$E(VFDDOB,4,7))
 ;
DPTAGE() ;;[Private] Patient File VFDR AGE field (#21601) adaptor
 ;Leave Naked at ^DPT(DFN,0)
 N VFDDOB,VFDATE S VFDATE=$P($G(^(.35)),U),VFDDOB=$P($G(^(0)),U,3)
 Q:'VFDDOB $G(X)
 Q:'VFDATE $$AGE(VFDDOB)
 Q $$AGE(VFDDOB,VFDATE)
 ;
