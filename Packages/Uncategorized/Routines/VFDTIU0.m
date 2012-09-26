VFDTIU0 ;DSS/RAF; - TIU OBJECT CALLS ;3/5/2007
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ; Non DSIC calls used in the routine:
 ;
 ; D FASTVIT^ORQQVI(.VFD,DFN,DT,DT) - used in both Vitals calls. Same call CPRS coversheet uses
 ; $$NAME^XUSER(DUZ,) - Returns the user name in a mixed case First Last format in CUSER
 ; D PROBL^ORQQPL3(.VFDLST,DFN,VFDCON) - same call used by CPRS problem list tab n PROB
 ; $$FMADD^XLFDT($$NOW^XLFDT,365) - used to set start/end dates in FAPPT and LAPPT
 ; $$FMTE^XLFDT - used to convert FM date/time to external for RXTEXT
 ; D AGET^ORWORR(.ROOT,DFN,"2^0",13,0,0,) - used in RXTEXT to find free text RX orders for patient
 ;
PNAME(DFN) ; returns the patient name in FIRST LAST format
 N DSICDAT,VFDPNAME
 D DEM^VFDCDPT(.DSICDAT,DFN,"","","","")
 I $G(DSICDAT(1))]"" S VFDPNAME=$P(DSICDAT(1),",",2)_" "_$P(DSICDAT(1),",")
 E  S VFDPNAME="-1^NO PATIENT NAME FOUND"
 Q VFDPNAME
 ;
NMADD(DFN) ; returns patient name and address information
 N DSICDAT,SP,VFDCS,VFDPNAME
 K ^TMP("VFDTIU0",$J)
 S $P(SP," ",30)=""
 D DEM^VFDCDPT(.DSICDAT,DFN,"","","","")
 I $G(DSICDAT(1))]"" S VFDPNAME=$P(DSICDAT(1),",",2)_" "_$P(DSICDAT(1),",")
 S VFDCS=$G(DSICDAT(14))_", "_$G(DSICDAT(15))
 S ^TMP("VFDTIU0",$J,1,0)=$G(VFDPNAME)
 S ^TMP("VFDTIU0",$J,2,0)=$S($G(DSICDAT(11))]"":$G(DSICDAT(11)),1:"Missing address information")
 S ^TMP("VFDTIU0",$J,3,0)=$G(VFDCS)
 S ^TMP("VFDTIU0",$J,4,0)=$E(SP,1,$L($G(VFDCS))-5)_$G(DSICDAT(16))
 Q "~@^TMP(""VFDTIU0"","_$J_")"
 ;
VITALS(DFN) ; returns all of today's vitals
 ; UNDER CONSTRUCTION
 N NUM,SP,VFD,VFDATA,VFDATE,VFDOTH,VFDTIME,VFDVAL,VFDVIT
 K ^TMP("VFDTIU0",$J)
 S VFD(0)="",$P(SP," ",8)=""
 D FASTVIT^ORQQVI(.VFD,DFN,DT,DT)
 I $D(VFD(1)) D
 .S ^TMP("VFDTIU0",$J,1,0)="Vital Signs found for "_$$CNVT^VFDCDT(,DT,"F","E",,,1)
 .S NUM=0 F  S NUM=$O(VFD(NUM)) Q:'NUM  I $D(VFD(NUM)) D
 ..S VFDATA=VFD(NUM),VFDVIT=$P(VFDATA,U,2),VFDVAL=$P(VFDATA,U,5),VFDATE=$$CNVT^VFDCDT(,$P(VFDATA,U,4),"F","E",,,1)
 ..S VFDOTH=$P(VFDATA,U,6),VFDTIME="@"_$P(VFDATE,"@",2)
 ..S ^TMP("VFDTIU0",$J,NUM+1,0)=VFDVIT_$E(SP,1,($L(SP)-$L(VFDVIT)))_VFDVAL_$E(SP,1,($L(SP)-$L(VFDVAL)))_VFDTIME_$E(SP,1,($L(SP)-$L(VFDTIME)))_"  "_VFDOTH
 E  S ^TMP("VFDTIU0",$J,1,0)="No Vitals results found for Today"
 Q "~@^TMP(""VFDTIU0"","_$J_")"
 ;
VIT5D(DFN) ; returns all coversheet vitals within the last 5 days
 ;
 N NUM,SP,VFD,VFDBDT,VFDATE,VFDATA,VFDOTH,VFDTIME,VFDVAL,VFDVIT,X,Y
 ;set beginning date to T-5
 S X="T-5" D ^%DT S VFDBDT=Y
 K ^TMP("VFDTIU0",$J)
 S VFD(0)="",$P(SP," ",8)=""
 D FASTVIT^ORQQVI(.VFD,DFN,VFDBDT,DT)
 I $D(VFD(1)) D
 .S ^TMP("VFDTIU0",$J,1,0)="Most recent Vital Signs found between "_$$CNVT^VFDCDT(,VFDBDT,"F","E",,,1)_" and "_$$CNVT^VFDCDT(,DT,"F","E",,,1)
 .S NUM=0 F  S NUM=$O(VFD(NUM)) Q:'NUM  I $D(VFD(NUM)) D
 ..S VFDATA=VFD(NUM),VFDVIT=$P(VFDATA,U,2),VFDVAL=$P(VFDATA,U,5),VFDATE=$$CNVT^VFDCDT(,$P(VFDATA,U,4),"F","E",,,1)
 ..S VFDOTH=$P(VFDATA,U,6),VFDTIME="@"_$P(VFDATE,"@",2)
 ..S ^TMP("VFDTIU0",$J,NUM+1,0)=VFDVIT_$E(SP,1,($L(SP)-$L(VFDVIT)))_VFDVAL_$E(SP,1,($L(SP)-$L(VFDVAL)))_VFDATE_$E(SP,1,($L(SP)-$L(VFDATE)))_"  "_VFDOTH
 E  S ^TMP("VFDTIU0",$J,1,0)="No Vitals results found within the last 5 days"
 Q "~@^TMP(""VFDTIU0"","_$J_")"
 ;
CUSER(DUZ) ; returns the name of the current user in First Last format
 Q $$NAME^XUSER(DUZ,)
 ;
PHONE(DFN) ; returns the home and work phone number if available
 ;
 K ^TMP("VFDTIU0",$J)
 N VFDDEM
 D DEM^VFDCDPT(.VFDDEM,DFN)
 S ^TMP("VFDTIU0",$J,1,0)="Patient Phone Numbers"
 S ^TMP("VFDTIU0",$J,2,0)="Home: "_$S($G(VFDDEM(18))]"":$G(VFDDEM(18)),1:"No data found")
 S ^TMP("VFDTIU0",$J,3,0)="Work: "_$S($G(VFDDEM(19))]"":$G(VFDDEM(19)),1:"No data found")
 Q "~@^TMP(""VFDTIU0"","_$J_")"
 ;
FAPPT(DFN) ; get next future appointment
 ;
 K ^TMP("VFDTIU0",$J),^TMP("DSIC",$J,"APPT")
 N VFDATA,VFDDATE,VFDNODE,VFDNUM,VFDRT,VFDSTOP,X
 S VFDDATE=$$FMADD^XLFDT($$NOW^XLFDT,365)
 S VFDATA=DFN_U_$$NOW^XLFDT_U_VFDDATE_U
 I '($T(APPT^DSICVT0)]"") Q "-1^Routine ~DSICVT0 is required."
 D APPT^DSICVT0(.VFDRT,VFDATA,)
 S (VFDSTOP,VFDNUM)=0 F  S VFDNUM=$O(^TMP("DSIC",$J,"APPT",VFDNUM)) Q:'VFDNUM!VFDSTOP  I $D(^TMP("DSIC",$J,"APPT",VFDNUM)) D
 .S VFDNODE=^TMP("DSIC",$J,"APPT",VFDNUM)
 .S ^TMP("VFDTIU0",$J,1,0)=$P(VFDNODE,U)_"   "_$P(VFDNODE,U,2)
 .I $P(VFDNODE,U,3)>$$NOW^XLFDT S VFDSTOP=1 Q
 I '$D(^TMP("VFDTIU0",$J,1,0)) S ^TMP("VFDTIU0",$J,1,0)="No future appointment found"
 Q "~@^TMP(""VFDTIU0"","_$J_")"
 ;
LAPPT(DFN) ; get most recent past appointment
 K ^TMP("VFDTIU0",$J),^TMP("DSIC",$J,"APPT")
 N VFDATA,VFDNODE,VFDNUM,VFDRT,X
 S VFDATA=DFN_U_U_$$NOW^XLFDT_U
 I '($T(APPT^DSICVT0)]"") Q "-1^Routine ~DSICVT0 is required."
 D APPT^DSICVT0(.VFDRT,VFDATA,)
 S VFDNUM=0 F  S VFDNUM=$O(^TMP("DSIC",$J,"APPT",VFDNUM)) Q:'VFDNUM  I $D(^TMP("DSIC",$J,"APPT",VFDNUM)) D
 .S VFDNODE=^TMP("DSIC",$J,"APPT",VFDNUM)
 .I $P(VFDNODE,U,3)>$$NOW^XLFDT Q
 .S ^TMP("VFDTIU0",$J,1,0)=$P(VFDNODE,U)_"   "_$P(VFDNODE,U,2)
 I '$D(^TMP("VFDTIU0",$J,1,0)) S ^TMP("VFDTIU0",$J,1,0)="No past appointment found"
 Q "~@^TMP(""VFDTIU0"","_$J_")"
 ;
PROB(DFN,VFDCON,VFDCAT) ; returns a list of both active and inactive problems
 ; VFDCON = context of the filter
 ;          "B" - returns both active and inactive problems
 ;          "I" - returns only inactive problems
 ;          "A" - returns only active probelms
 ; VFDCAT = category filter
 ;          "m" - returns problems assigned a category of med/surg
 ;          "f" - returns problems assigned a category of family
 ;          "s" - returns problems assigned a category of social
 ;.........."u" - returns unassigned problems (not an official category but needed as a filter)
 ;
 ; If VFDCON is not defined the default will be ACTIVE problems
 ;
 K ^TMP("VFDTIU0",$J)
 N CNT,VFDCATXT,VFDLST,VFDNUM
 S VFDCATXT=$S($G(VFDCAT)="m":"MED/SURG",$G(VFDCAT)="f":"FAMILY",$G(VFDCAT)="s":"SOCIAL",1:"")
 D PROBL^ORQQPL3(.VFDLST,DFN,$G(VFDCON))
 S CNT=2
 S VFDNUM=0 F  S VFDNUM=$O(VFDLST(VFDNUM)) Q:'VFDNUM  D
 .I $G(VFDCAT)]"" D
 ..I $P(VFDLST(VFDNUM),U,19)=$G(VFDCAT) D
 ...S ^TMP("VFDTIU0",$J,CNT,0)="     "_$P(VFDLST(VFDNUM),U,3)_"("_$P(VFDLST(VFDNUM),U,4)_")",CNT=CNT+1
 .I $G(VFDCAT)="" D  ;needed to build all problems when VFDCAT is passed as a null value
 ..S ^TMP("VFDTIU0",$J,CNT,0)="     "_$P(VFDLST(VFDNUM),U,3)_"("_$P(VFDLST(VFDNUM),U,4)_")",CNT=CNT+1
 .I $G(VFDCAT)="u",$P(VFDLST(VFDNUM),U,19)="" D
 ..S ^TMP("VFDTIU0",$J,CNT,0)="     "_$P(VFDLST(VFDNUM),U,3)_"("_$P(VFDLST(VFDNUM),U,4)_")",CNT=CNT+1
 I $D(^TMP("VFDTIU0",$J)),$G(VFDCAT)'="u" D
 .S ^TMP("VFDTIU0",$J,1,0)="All Active "_$G(VFDCATXT)_" Problems"
 I $D(^TMP("VFDTIU0",$J)),$G(VFDCAT)="u" D
 .S ^TMP("VFDTIU0",$J,1,0)="Unassigned Problems"
 I '$D(^TMP("VFDTIU0",$J)) S ^TMP("VFDTIU0",$J,1,0)="No Active "_$G(VFDCATXT)_" Problems found."
 Q "~@^TMP(""VFDTIU0"","_$J_")"
 ;
DCMEDS(DFN) ; returns discontinued meds for a patient
 ; temporary work up code to find the best way to get dc'd meds
 ;
 ; the status codes used in this object are DC=1, DC/edit=12
 ;
 ; This code can be used until the ALL OUTPATIENT health summary gets fixed by having the 
 ; "P" and "P","A" nodes in ^PS(55, reindexed. After that has been corrected the following
 ; call can be used:
 ; D RPT^ORWRP(.ROOT,DFN,"OR_RXOP:ALL OUTPATIENT~RXOP;ORDV06;28;10",,,,)
 ; this will return all the meds for a patient that can be screened for status
 ;
 K ^TMP("VFDTIU0",$J)
 N VFDARRAY,VFDDATE,VFDDCDT,VFDNUM,VFDPREF,VFDORIFN,VFDRX,VFDSP,VFDSTA,VFDSTRNG,VFDSTXT,VFDTXT
 S $P(VFDSP,".",132)="."
 S CNT=2,VFDDATE=0 F  S VFDDATE=$O(^OR(100,"ACT",DFN_";DPT(",VFDDATE)) Q:'VFDDATE  D
 .S VFDNUM=0 F  S VFDNUM=$O(^OR(100,"ACT",DFN_";DPT(",VFDDATE,VFDNUM)) Q:'VFDNUM  D
 ..S VFDORIFN=0 F  S VFDORIFN=$O(^OR(100,"ACT",DFN_";DPT(",VFDDATE,VFDNUM,VFDORIFN)) Q:'VFDORIFN  D
 ...I $D(^OR(100,VFDORIFN,0)),($$GET1^DIQ(9.4,$P(^OR(100,VFDORIFN,0),U,14),1,"E")="PSO") D
 ....D GETS^DIQ(100,VFDORIFN,".8*","","VFDARRAY") S VFDPREF=$$GET1^DIQ(100,VFDORIFN,33,"I")
 ....S VFDRX=$$GET1^DIQ(52,VFDPREF,.01,"I"),VFDSTA=$P(^OR(100,VFDORIFN,3),U,3)
 ....S VFDDCDT=$P($$GET1^DIQ(100,VFDORIFN,22,"E"),"@")
 ....I (VFDSTA=1)!(VFDSTA=12) D
 .....; formatting the output
 .....S VFDTXT=$G(VFDARRAY(100.008,"1,"_VFDORIFN_",",.1,1)),VFDSTXT=$$GET1^DIQ(100,VFDORIFN,5,,"E")
 .....S VFDSTRNG=" "_VFDTXT,VFDSTRNG=VFDSTRNG_$E(VFDSP,1,57-$L(VFDSTRNG))
 .....S VFDSTRNG=VFDSTRNG_VFDRX,VFDSTRNG=VFDSTRNG_$E(VFDSP,1,67-$L(VFDSTRNG))
 .....S VFDSTRNG=VFDSTRNG_VFDDCDT,VFDSTRNG=VFDSTRNG_$E(VFDSP,1,76-$L(VFDSTRNG))
 .....S ^TMP("VFDTIU0",$J,VFDRX,0)=VFDSTRNG_"   "_VFDORIFN
 .....;S ^TMP("VFDTIU0",$J,CNT,0)=VFDSTRNG,CNT=CNT+1
 I '$D(^TMP("VFDTIU0",$J)) S ^TMP("VFDTIU0",$J,1,0)="No discontinued medications found."
 E  S ^TMP("VFDTIU0",$J,1,0)="Discontinued Medications                                 Rx #        Dc Date"
 Q "~@^TMP(""VFDTIU0"","_$J_")"
 ;
EXPMEDS(DFN) ; returns a list of expired meds for a patient
 ; temporary work up code to find the best way to get expired meds
 ; the status used for this screen is Expired=7
 ;
 ; This code can be used until the ALL OUTPATIENT health summary gets fixed by having the 
 ; "P" and "P","A" nodes in ^PS(55, reindexed. After that has been corrected the following
 ; call can be used:
 ; D RPT^ORWRP(.ROOT,DFN,"OR_RXOP:ALL OUTPATIENT~RXOP;ORDV06;28;10",,,,)
 ; this will return all the meds for a patient that can be screened for status
 ;
 K ^TMP("VFDTIU0",$J)
 N CNT,VFDARRAY,VFDPREF,VFDORIFN,VFDRX,VFDSP,VFDSTA,VFDSTRNG,VFDSTDT,VFDSTXT,VFDTXT
 S $P(VFDSP,".",132)="."
 S CNT=2,VFDORIFN=0 F  S VFDORIFN=$O(^OR(100,VFDORIFN)) Q:'VFDORIFN  D
 .I $P(^OR(100,VFDORIFN,0),U,2)=(DFN_";DPT(")&($P(^OR(100,VFDORIFN,0),U,14)=60) D
 ..D GETS^DIQ(100,VFDORIFN,".8*","","VFDARRAY") S VFDPREF=$$GET1^DIQ(100,VFDORIFN,33,"I")
 ..S VFDRX=$$GET1^DIQ(52,VFDPREF,.01,"I"),VFDSTA=$P(^OR(100,VFDORIFN,3),U,3)
 ..S VFDSTDT=$P($$GET1^DIQ(100,VFDORIFN,22,"E"),"@")
 ..I VFDSTA=7 D
 ...; formatting the output
 ...S VFDTXT=$G(VFDARRAY(100.008,"1,"_VFDORIFN_",",.1,1)),VFDSTXT=$$GET1^DIQ(100,VFDORIFN,5,,"E")
 ...S VFDSTRNG="  "_VFDTXT,VFDSTRNG=VFDSTRNG_$E(VFDSP,1,65-$L(VFDSTRNG))
 ...S VFDSTRNG=VFDSTRNG_VFDRX,VFDSTRNG=VFDSTRNG_$E(VFDSP,1,76-$L(VFDSTRNG))
 ...S VFDSTRNG=VFDSTRNG_VFDSTDT,VFDSTRNG=VFDSTRNG_$E(VFDSP,1,85-$L(VFDSTRNG))
 ...S ^TMP("VFDTIU0",$J,CNT,0)=VFDSTRNG,CNT=CNT+1
 I '$D(^TMP("VFDTIU0",$J)) S ^TMP("VFDTIU0",$J,1,0)="No expired medications found."
 E  S ^TMP("VFDTIU0",$J,1,0)="Expired Medications                                              Rx #       Expiration Date"
 Q "~@^TMP(""VFDTIU0"","_$J_")"
RXTEXT(DFN) ; find all pharmacy text order for a patient
 N ROOT
 D AGET^ORWORR(.ROOT,DFN,"2^0",13,0,0,)  ; gets list of all Nursing orders for patient
 ; DFN=patient IEN from file 2
 ; 13 = nursing orders display group
 ; Returns data in ^TMP("ORR",$J,
 ;
 N CNT,VFDORD,VFDH,VFDNXT,VFDLINE,VFD,VFDQUIT,VFDVAR,VFDVAR1
 S VFDH=$O(^TMP("ORR",$J,"")),VFDNXT=.9 F  S VFDNXT=$O(^TMP("ORR",$J,VFDH,VFDNXT)) Q:'VFDNXT  D
 .I $D(^TMP("ORR",$J,VFDH,.1)) D
 ..S VFDORD=+$G(^TMP("ORR",$J,VFDH,VFDNXT)) I $G(^OR(100,VFDORD,4.5,1,2,1,0))["~99" D
 ...S VFD(VFDORD)=""  ;builds array of just Rx Text orders based on the ~99 found in first line
 ; get data and set ^TMP("VFDTIU0",$J for TIU output
 N CNT,CNT2,VFDORIFN,VFDEDT,VFDSDT,VFDNODE,VFDSEQ,VFDZERO
 S (VFDEND,VFDQUIT)=0,CNT=3
 S VFDORIFN=0 F  S VFDORIFN=$O(VFD(VFDORIFN)) Q:'VFDORIFN  D
 .N VFDVAR1 S VFDEND=0
 .S VFDZERO=$G(^OR(100,VFDORIFN,0)),VFDSDT=$$FMTE^XLFDT($P(VFDZERO,U,8)),VFDEDT=$$FMTE^XLFDT($P(VFDZERO,U,9))
 .S (VFDQUIT,VFDSEQ)=0 F  S VFDSEQ=$O(^OR(100,VFDORIFN,4.5,1,2,VFDSEQ)) Q:'VFDSEQ  D  I VFDEND D LINE Q:VFDEND
 ..S VFDVAR=$G(^OR(100,VFDORIFN,4.5,1,2,VFDSEQ,0))_"~",VFDVAR1=$G(VFDVAR1)_VFDVAR
 ..I $G(^OR(100,VFDORIFN,4.5,1,2,VFDSEQ,0))["$" S VFDEND=1
 I $D(VFDLINE) D
 .M ^TMP("VFDTIU0",$J)=VFDLINE
 I '$D(VFDLINE) S ^TMP("VFDTIU0",$J,1,0)="No Free Text Pharmacy Orders found"
 E  S ^TMP("VFDTIU0",$J,1,0)="All Free Text Pharmacy Orders",^TMP("VFDTIU0",$J,2,0)=""
 Q "~@^TMP(""VFDTIU0"","_$J_")"
 Q
LINE ; compose VFDLINE() array for use in merge command once done
 ; this code is part of RXTEXT free text pharmacy object
 S CNT2=3
 I $D(VFDVAR1) F  D  Q:VFDQUIT
 .I $P(VFDVAR1,"~",CNT2)["$" D
 ..S VFDLINE(CNT,0)="Start Date: "_VFDSDT_"   End Date: "_VFDEDT,CNT=CNT+1
 ..S VFDLINE(CNT,0)="",VFDQUIT=1,CNT=CNT+1
 .;I $p(VFDVAR1,"~",CNT2)["$" S VFDQUIT=1
 .I $P(VFDVAR1,"~",CNT2)'["$" S VFDLINE(CNT,0)=$P(VFDVAR1,"~",CNT2),CNT=CNT+1,CNT2=CNT2+1
 Q
