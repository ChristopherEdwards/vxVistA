VFDLRLST ;DSS/RAF - BUILD LIST OF LAB ORDERS FROM CPRS ORDER LIST PASSED IN ;02/20/2007 15:00
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;;DSSBUILD - VFD LR 1.0T1 * 06/18/08 * DSS-DEV-RF_TTUEP
 ;
 ; 
 ; Non DSIC calls used in this routine
 ;
 ;      --$$GET1^DIQ(60,VFDTNUM,.01,"E") - convert file 60 pointer (VFDTNUM) to test name
 ;      --$$GET1^DIQ(100,VFDORIFN,1,"E") - convert pointer(VFDMD) to clinician name
 ;      --$$GET1^DIQ(9.4,$P(^OR(100,VFDORIFN,0),U,14),.01,"E") - convert pkg pointer to pkg name
 ;      --$$GET1^DIQ(100,VFDORIFN,33,"I") - get package reference  for lookup in 69
 ;      --$$NAME^XUAF4(+$$SITE^VASITE) - get the name of the System or requesting facility
 ;      --$$PADD^XUAF4(+$$SITE^VASITE) - get physical address of requesting facility
 ;                *****still need a phone number, clia#, and cap# ?
 ;      --GETS^DIQ(4,VFDRLAB,"*","E","VFDLIST") - get name and address for receiving facility 'VFDRLAB'
 ;      --$$GET1^DIQ(60,VFDTNUM,.01,"E") - get the test name for other test array value
 ;      --GET1^DIQ(69.03,IENS,99,"","WP") - get the order comment for the Misc test
 ;      --$$VALUE^ORX8(VFDORIFN,"SCHEDULE",,"E") - get the value of any prompt for an order
 ;      --$$GET1^DIQ(100,+VFDORLST(1),6,"E") - get patient location
 ;
 ;===========================================================================
LAB(VFDFORM,VFDORLST) ; RPC; VFD LR TEST ORDER SHEET returns data in array
 ;===========================================================================
 ;
 ; Input parameter
 ;       VFDORLST(#)=ORIFN
 ;
 ; Return parameter
 ;       VFDFORM(0)= ERROR MESSAGE
 ;       VFDFORM(#)=p1^p2 where
 ;           p1 - the name of the data field
 ;           p2 - the value of the data field
 ; ARRAY definitions:
 ;     VFDFORM(1)="$START LRFORM"   <= beginning marker of order record
 ;     VFDFORM(2)="CADD1^"_[address of ordering site]
 ;     VFDFORM(3)="CCITY^"_[city of ordering site]
 ;     VFDFORM(4)="CNAME^"_[name of ordering site]
 ;     VFDFORM(5)="CSTATE^"_[state of ordering site]
 ;     VFDFORM(6)="CZIP^"_[zip code of ordering site]
 ;     VFDFORM(7)="DIAG^"_[patients primary diagnosis]
 ;     VFDFORM(8)="LAB TEST OTH^"_[local test name]^^[diag]^[comment]^[cpt code]  ;cpt added 12/19/08
 ;     VFDFORM(9)="LAB TEST^"_[lab test name]^[order code]^[associated diag]
 ;     VFDFORM(10)="LAB UID^"_[UID made up of Lab Ord #;order date^Lab ord#;...
 ;     VFDFORM(11)="MD^"_[ordering physician name]
 ;     VFDFORM(12)="PAT AD CITY^"_[city of patient]
 ;     VFDFORM(13)="PAT AD L1^"_[1st line of patient address]
 ;     VFDFORM(14)="PAT AD L2^"_[2nd line of patient address]
 ;     VFDFORM(15)="PAT AD L3^"_[3rd line of patient address]
 ;     VFDFORM(16)="PAT AD STATE^"_[state of patient address]
 ;     VFDFORM(17)="PAT AD ZIP^"_[zip code of patient address]
 ;     VFDFORM(18)="PAT DOB^"_[date of birth of patient]
 ;     VFDFORM(19)="PAT NAME^"_[name of patient]
 ;     VFDFORM(20)="PAT SSN^"_[SSN of patient]
 ;     VFDFORM(21)="PHONE #^"_[home phone of patient]
 ;     VFDFORM(22)="REF LAB^"_[name of the reference lab]
 ;     VFDFORM(23)="REF LAB AD^"_[address of reference lab]
 ;     VFDFORM(24)="REF LAB CITY^"_[city of reference lab]
 ;     VFDFORM(25)="REF LAB STATE^"_[state of reference lab]
 ;     VFDFORM(26)="REF LAB ZIP^"_[zip code of reference lab]
 ;     VFDFORM(27)="LOC^"_[patient location name]
 ;     VFDFORM(27)="$END LRFORM"   <= end marker of order record
 ;     
 ;     Do to developmental changes the sequence numbers may not match the actual placement of
 ;     the data fields in the final VFDFORM() array.
 ;
 I '$L($T(TRANS^DSICHLOT)) S VFDERR="-1^routine TRANS~DSICHLOT not available" Q
 N VFDDATE,VFDERR,VFDFN,VFDIENS,VFDINST,VFDLOC,VFDLRDFN,VFDLRORD,VFDNUM,VFDOXRF,VFDPKG,VFDPREF
 N VFDSEQ,VFDTNUM,VFDX,VFDUID,VFDDATE,VFDERR,VFDIENS,VFDLRDFN,VFDLRLST,VFDLRORD,VFDORD,VFDSITE
 S VFDLRLST=$NA(^TMP("VFDLRLST",$J)) K @VFDLRLST
 S VFDERR=0
 D RFACIL
 D ORDERS I VFDERR S VFDFORM(0)=VFDERR Q
 D ARRAY
 D UIDFIX
 Q
RFACIL ; set up requisting facility demographics
 S @VFDLRLST@("SITE","CNAME")=$$NAME^XUAF4(+$$SITE^VASITE),VFDSITE=$$PADD^XUAF4($$SITE^VASITE)
 S @VFDLRLST@("SITE","CADD1")=$P(VFDSITE,U),@VFDLRLST@("SITE","CCITY")=$P(VFDSITE,U,2),@VFDLRLST@("SITE","CSTATE")=$P(VFDSITE,U,3)
 S @VFDLRLST@("SITE","CZIP")=$P(VFDSITE,U,4)
 Q
ORDERS ; start loop thru orders looking for only lab orders
 N I F I=1:1 Q:'$D(VFDORLST(I))  S VFDOXRF(+VFDORLST(I))=""
 I '$D(VFDOXRF) S VFDFORM(0)="-1^No orders in list to print" Q  ;this should never happen
 S VFDLOC=$$GET1^DIQ(100,+VFDORLST(1),6,"E")  ; get patient location for order
 S VFDFN=+$$GET1^DIQ(100,+VFDORLST(1),.02,"I"),VFDERR=0
 I 'VFDFN S VFDERR="-1^Order # "_VFDORLST(1)_" does not exist" Q
 S VFDX="" F  S VFDX=$O(VFDOXRF(VFDX)) Q:'VFDX  D  Q:VFDERR
 .S VFDPKG=$$GET1^DIQ(9.4,$P(^OR(100,VFDX,0),U,14),1,"E")
 .I VFDPKG'="LR" Q  ;this should never happen
 .S VFDPREF=$$GET1^DIQ(100,VFDX,33,"I") D  Q:VFDERR
  .I VFDPREF'[";" S VFDERR="-1^No lab package reference for order "_VFDX Q  ; could be an unsigned order
  .S VFDLRORD=+VFDPREF,VFDDATE=$P(VFDPREF,";",2),VFDSEQ=$P(VFDPREF,";",3)
 .S VFDIENS=VFDSEQ_","_VFDDATE_",",VFDLRDFN=$$GET1^DIQ(69.01,VFDIENS,.01,"I",)
 .I $$GET1^DIQ(63,VFDLRDFN_",",.03,"I",)=VFDFN S VFDOXRF(VFDX,VFDFN)=""
 .I '$D(^TMP("VFDLRLST",$J,"PAT")) D DEM^VFDCDPT(.DSICDAT,VFDFN,,,,) D
 ..S @VFDLRLST@("PAT","PAT NAME")=$G(DSICDAT(1)),@VFDLRLST@("PAT","PAT SSN")=$P($G(DSICDAT(2)),";")
 ..S @VFDLRLST@("PAT","PAT AD L1")=$G(DSICDAT(11)),@VFDLRLST@("PAT","PAT AD L2")=$G(DSICDAT(12))
 ..S @VFDLRLST@("PAT","PAT AD L3")=$G(DSICDAT(13)),@VFDLRLST@("PAT","PAT AD CITY")=$G(DSICDAT(14))
 ..S @VFDLRLST@("PAT","PAT AD STATE")=$G(DSICDAT(15)),@VFDLRLST@("PAT","PAT AD ZIP")=$G(DSICDAT(16))
 ..S @VFDLRLST@("PAT","PAT DOB")=$P($G(DSICDAT(3)),";",2),@VFDLRLST@("PAT","PHONE #")=$G(DSICDAT(18))
 ..S @VFDLRLST@("PAT","LOC")=$G(VFDLOC)
 ..K DSICDAT
 .; set up reference lab demographics
 .N VFDREFNM,VFDRADD,VFDEFAULT
 .S VFDINST=+$$SITE^VASITE,VFDEFAULT=1  ; set default to SITE to resolve a build problem for tests with no valid schedule
 .;S VFDREFNM=$$VALUE^ORX8(VFDX,"SCHEDULE",,"E") I VFDREFNM[":" S VFDINST=$$IDX^XUAF4("ADMIN SCHED",VFDREFNM),VFDEFAULT=0
 .I '$D(^TMP("VFDLRLST",$J,VFDINST)) I 'VFDEFAULT D
 ..S @VFDLRLST@(VFDINST,"REF LAB")=$$NAME^XUAF4(VFDINST),VFDRADD=$$PADD^XUAF4(VFDINST)
 ..S @VFDLRLST@(VFDINST,"REF LAB AD")=$P(VFDRADD,U),@VFDLRLST@(VFDINST,"REF LAB CITY")=$P(VFDRADD,U,2),@VFDLRLST@(VFDINST,"REF LAB STATE")=$P(VFDRADD,U,3)
 ..S @VFDLRLST@(VFDINST,"REF LAB ZIP")=$P(VFDRADD,U,4)
 .I +$G(VFDINST)=+$$SITE^VASITE S @VFDLRLST@(VFDINST,"REF LAB")="Local Collection"  ;$P($$SITE^VASITE,U,2)
 .; get and set diagnosis from CPRS order
 .N DIAG,DX,VFDDIAG
 .D GETS^DIQ(100,VFDX,"5.1*","E","DIAG")
 .I $D(DIAG) D
 ..N DX,I
 ..S I=0 F  S I=$O(DIAG(100.051,I)) Q:'I  D
 ...I $D(DIAG(100.051,I,.01,"E")) D
 ....S DX=$G(DIAG(100.051,I,.01,"E"))
 ....I $D(VFDDIAG) S VFDDIAG=$G(VFDDIAG)_";"_DX  ;handles multiples
 ....I '$D(VFDDIAG) S VFDDIAG=DX
 .E  S VFDDIAG=""
 .; get primary diagnosis for the patient
 .N DSIC D PCE^DSICPX2(.DSIC,VFDFN,) D
 ..I +DSIC'="-1" S @VFDLRLST@(VFDINST,"DIAG")=$P(DSIC,U,2)
 ..E  S @VFDLRLST@(VFDINST,"DIAG")=""
 .; set LAB UID for non reference lab tests, also the ordering provider
 .I VFDINST=+$$SITE^VASITE S @VFDLRLST@(VFDINST,"LAB UID")=VFDLRORD_";"_VFDDATE,@VFDLRLST@(VFDINST,"MD")=$$GET1^DIQ(100,VFDX,1,"E")
 .; gather lab test information
 .S VFDNUM=0 F  S VFDNUM=$O(^LRO(69,+VFDDATE,1,+VFDSEQ,2,VFDNUM)) Q:'VFDNUM  D
 ..I $P(^LRO(69,VFDDATE,1,VFDSEQ,2,VFDNUM,0),U,7)=VFDX D
 ...N VFDHL7V,VFDOTN,X
 ...S VFDTNUM=+$G(^LRO(69,VFDDATE,1,VFDSEQ,2,VFDNUM,0))
 ...S VFDHL7V=$$TRANS^DSICHLOT("THOM","VX101",VFDTNUM,"HLT") ;change HL to HLT when loaded on TTUEP account
 ...I $P($G(VFDHL7V),U)>0 D
 ....; combine test name^test code^diagnosis into the "LAB TEST" variable - per Lee Miller
 ....S @VFDLRLST@(VFDINST,"LAB TEST",VFDTNUM)=$P(VFDHL7V,U,2)_U_+VFDHL7V_U_$G(VFDDIAG)
 ....S @VFDLRLST@(VFDINST,"LAB UID")=VFDLRORD_";"_VFDDATE,@VFDLRLST@(VFDINST,"MD")=$$GET1^DIQ(100,VFDX,1,"E")
 ...E  S VFDOTN=$$GET1^DIQ(60,VFDTNUM,.01,"E") D
 ....N IENS,VFDWP,VFDCPT  ;VFDCPT added 12/8/08
 ....D LABCPT(.VFDCPT,VFDTNUM,)  ;get CPT code from National VA Lab Code added 12/19/08
 ....S IENS=VFDNUM_","_VFDSEQ_","_VFDDATE_"," D GET1^DIQ(69.03,IENS,99,"","VFDWP")
 ....S @VFDLRLST@(VFDINST,"LAB TEST OTH",VFDTNUM)=$G(VFDOTN)_U_U_VFDDIAG_U_$G(VFDWP(2))_U_$G(VFDCPT)
 ...I $D(VFDUID(VFDINST)) D
 ....I VFDUID(VFDINST)'[VFDLRORD S VFDUID(VFDINST)=VFDUID(VFDINST)_"_"_VFDLRORD_";"_VFDDATE
 ...I '$D(VFDUID(VFDINST)) D
 ....S VFDUID(VFDINST)=VFDLRORD_";"_VFDDATE
 ; replace all LAB UID's in the VFDFORM array with the cumulative VFDUID
 ;N I,I1
 ;S I=0 F  S I=$O(^TMP("VFDLRLST",$J,I)) Q:'I  D
 ;.S I1="" F  S I1=$O(^TMP("VFDLRLST",$J,I,I1)) Q:I1=""  D
 ;..I I1="LAB UID" S ^TMP("VFDLRLST",$J,I,I1)=VFDUID(I)
 ;S I=0 F  S I=$O(VFDFORM(I)) Q:'I  I VFDFORM(I)["LAB UID" S $P(VFDFORM(I),U,2)=VFDUID
 Q
ARRAY ; convert TMP global data to VFDFORM array
 I $D(VFDFORM(0)) Q
 ;I '$D(^TMP("VFDLRLST",$J,"PAT")) S @VFDLRLST@(0)="-1^No lab orders were selected for printing" S VFDFORM=@VFDLRLST@(0) Q
 N CNT,I,I1,I2,I3,I4,SUB
 S CNT=1
 S I=0 F  S I=$O(^TMP("VFDLRLST",$J,I)) Q:'I  D
 .S VFDFORM(CNT)="$START LRFORM",CNT=CNT+1
 .S I2="" F  S I2=$O(^TMP("VFDLRLST",$J,"PAT",I2)) Q:I2=""  D
 ..S VFDFORM(CNT)=I2_U_^TMP("VFDLRLST",$J,"PAT",I2),CNT=CNT+1
 .S I3="" F  S I3=$O(^TMP("VFDLRLST",$J,"SITE",I3)) Q:I3=""  D
 ..S VFDFORM(CNT)=I3_U_^TMP("VFDLRLST",$J,"SITE",I3),CNT=CNT+1
 .S I1="" F  S I1=$O(^TMP("VFDLRLST",$J,I,I1)) Q:I1=""  D
 ..I I1["MD" S VFDFORM(CNT)=I1_U_^TMP("VFDLRLST",$J,I,I1),CNT=CNT+1
 ..I I1["REF" S VFDFORM(CNT)=I1_U_^TMP("VFDLRLST",$J,I,I1),CNT=CNT+1
 ..I I1["DIAG" S VFDFORM(CNT)=I1_U_^TMP("VFDLRLST",$J,I,I1),CNT=CNT+1
 ..I I1["LAB UID" S VFDFORM(CNT)=I1_U_^TMP("VFDLRLST",$J,I,I1),CNT=CNT+1
 ..S I4=0 F  S I4=$O(^TMP("VFDLRLST",$J,I,I1,I4)) Q:'I4  D
 ...I I1="LAB TEST OTH" S VFDFORM(CNT)=I1_U_^TMP("VFDLRLST",$J,I,I1,I4),CNT=CNT+1 Q
 ...I I1="LAB TEST" S VFDFORM(CNT)="LAB TEST"_U_^TMP("VFDLRLST",$J,I,I1,I4),CNT=CNT+1
 .S VFDFORM(CNT)="$END LRFORM",CNT=CNT+1
 Q
 ;
UIDFIX ; replace all LAB UID's in the VFDFORM array with the cumulative VFDUID
 N I
 S I=0 F  S I=$O(VFDFORM(I)) Q:'I  I VFDFORM(I)["LAB UID" S $P(VFDFORM(I),U,2)=VFDUID(VFDINST)
 Q
 ;
LABCPT(VFDCPT,VFDTNUM,VFDORDT) ; API to return the active CPT code for a lab test by
 ; getting the National VA code entry from file 60 and using it to get the CPT code
 ; associated with the NLT code in file 64
 N VFDERR,VFDLST
 S VFDERR=0
 D GET Q:VFDERR
 D DATE(.VFDLST,.VFDORDT)
 Q
GET N IENS,NLT,VFDGETS,VFDIENS,VFDFLD,VFDCODE
 S NLT=$$GET1^DIQ(60,VFDTNUM,64,"I")
 I '$D(NLT) S VFDERR="-1^No NLT code found",VFDCPT="" Q
 S IENS=NLT_","
 K VFDGETS D GETS^DIQ(64,IENS,"18*","NRI","VFDGETS")
 I '$D(VFDGETS) S VFDERR="-1^No CPT data available for NLT:"_$G(NLT),VFDCPT="" Q
 S VFDIENS="" F  S VFDIENS=$O(VFDGETS(64.018,VFDIENS)) Q:VFDIENS=""  D
 .S VFDFLD="" F  S VFDFLD=$O(VFDGETS(64.018,VFDIENS,VFDFLD)) Q:VFDFLD=""  D
 ..I VFDFLD="CODE" S VFDCODE=+$G(VFDGETS(64.018,VFDIENS,VFDFLD,"I")),VFDLST(VFDCODE)=VFDCODE
 ..I VFDFLD="INACTIVE DATE" S $P(VFDLST(VFDCODE),U,2)=$G(VFDGETS(64.018,VFDIENS,VFDFLD,"I"))
 ..I VFDFLD="RELEASE DATE" S $P(VFDLST(VFDCODE),U,3)=$G(VFDGETS(64.018,VFDIENS,VFDFLD,"I"))
 ..I VFDFLD="REPLACEMENT CODE" S $P(VFDLST(VFDCODE),U,4)=$G(VFDGETS(64.018,VFDIENS,VFDFLD,"I"))
 ..I VFDFLD="TYPE" S $P(VFDLST(VFDCODE),U,5)=$G(VFDGETS(64.018,VFDIENS,VFDFLD,"I"))
 ..Q
 .Q
 Q
DATE(VFDLST,VFDORDT) ;compare order date against the inactive date to find the correct CPT code
 ; associated with the order at the time it was placed
 N CODE,INADT,REDT
 S CODE=0 F  S CODE=$O(VFDLST(CODE)) Q:'CODE  D
 .S INADT=+$P(VFDLST(CODE),U,2),REDT=+$P(VFDLST(CODE),U,3)
 .I 'INADT S VFDCPT=CODE
 .I $D(VFDORDT) D
 ..I VFDORDT<INADT,VFDORDT>REDT S VFDCPT=CODE
 .Q
 Q
