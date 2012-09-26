PXCAVIMM ;ISL/dee - Validates & Translates data from the PCE Device Interface into PCE's PXK format for Immunizations ;3/14/97
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**27,124**;Aug 12, 1996
 Q
 ; Variables
 ;   PXCAIMM  Copy of a IMMUNIZATION node of the PXCA array
 ;   PXCAPRV   Pointer to the provider (200)
 ;   PXCANUMB  Count of the number if IMMs
 ;   PXCAINDX  Count of the number of IMMUNIZATION for one provider
 ;   PXCAFTER  Temp used to build ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,0,"AFTER")
 ;   PXCAPNAR  Pointer to the provider narrative (9999999.27)
 ;
IMM(PXCAIMM,PXCANUMB,PXCAPRV,PXCAERRS) ;
 N PXCAFTER
 S PXCAFTER=$P(PXCAIMM,"^",1)_"^"_PXCAPAT_"^"_PXCAVSIT_"^"
 S PXCAFTER=PXCAFTER_$P(PXCAIMM,"^",2,4)
 S ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,"IEN")=""
 S ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,0,"BEFORE")=""
 ;PX*1*124
 S ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,0,"AFTER")=PXCAFTER_"^^"_$P(PXCAIMM,"^",8)_"^"_$P(PXCAIMM,"^",9)_"^"_$P(PXCAIMM,"^",10)_"^"_$P(PXCAIMM,"^",11)_"^"_$P(PXCAIMM,"^",12)_"^"_$P(PXCAIMM,"^",13)_"^"_$P(PXCAIMM,"^",14)_"^"_$P(PXCAIMM,"^",15)
 S ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,12,"BEFORE")=""
 S ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,12,"AFTER")=$P(PXCAIMM,"^",6)_"^^^"_$S(PXCAPRV>0:PXCAPRV,1:"")
 S ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,811,"BEFORE")=""
 S ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,811,"AFTER")=$P(PXCAIMM,"^",7)
 S ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,812,"BEFORE")=""
 S ^TMP(PXCAGLB,$J,"IMM",PXCANUMB,812,"AFTER")="^"_PXCAPKG_"^"_PXCASOR
 Q
 ;
IMMUN(PXCA,PXCABULD,PXCAERRS) ;Validation routine for IMM
 Q:'$D(PXCA("IMMUNIZATION"))
 N PXCAIMM,PXCAPRV,PXCANUMB,PXCAINDX
 N PXCAITEM,PXCAITM2
 S PXCAPRV=""
 S PXCANUMB=0
 F  S PXCAPRV=$O(PXCA("IMMUNIZATION",PXCAPRV)) Q:PXCAPRV']""  D
 . I PXCAPRV>0 D
 .. I '$$ACTIVPRV^PXAPI(PXCAPRV,PXCADT) S PXCA("ERROR","IMMUNIZATION",PXCAPRV,0,0)="Provider is not active or valid^"_PXCAPRV
 .. E  I PXCABULD!PXCAERRS D ANOTHPRV^PXCAPRV(PXCAPRV)
 . S PXCAINDX=0
 . F  S PXCAINDX=$O(PXCA("IMMUNIZATION",PXCAPRV,PXCAINDX)) Q:PXCAINDX']""  D
 .. S PXCAIMM=$G(PXCA("IMMUNIZATION",PXCAPRV,PXCAINDX))
 .. S PXCANUMB=PXCANUMB+1
 .. I PXCAIMM="" S PXCA("ERROR","IMMUNIZATION",PXCAPRV,PXCAINDX,0)="IMMUNIZATION data missing" Q
 .. S PXCAITEM=+$P(PXCAIMM,U,1)
 .. I $G(^AUTTIMM(PXCAITEM,0))="" S PXCA("ERROR","IMMUNIZATION",PXCAPRV,PXCAINDX,1)="IMMUNIZATION type not in file 9999999.14^"_PXCAITEM
 .. S PXCAITEM=$P(PXCAIMM,U,2)
 .. I '(PXCAITEM=""!(PXCAITEM="P")!(PXCAITEM="C")!(PXCAITEM="B")!((PXCAITEM=(PXCAITEM\1))&(PXCAITEM>0)&(PXCAITEM<9))) S PXCA("ERROR","IMMUNIZATION",PXCAPRV,PXCAINDX,2)="IMMUNIZATION series must be P|C|B|1|2|3|4|5|6|7|8^"_PXCAITEM
 .. S PXCAITEM=$P(PXCAIMM,U,4)
 .. I '((PXCAITEM=(PXCAITEM\1)&(PXCAITEM>0)&(PXCAITEM<12))!(PXCAITEM="")) S PXCA("ERROR","IMMUNIZATION",PXCAPRV,PXCAINDX,4)="IMMUNIZATION reaction must be an integer form 1 to 11^"_PXCAITEM
 .. S PXCAITEM=$P(PXCAIMM,U,5)
 .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","IMMUNIZATION",PXCAPRV,PXCAINDX,5)="IMMUNIZATION contraindicated flag bad^"_PXCAITEM
 .. S PXCAITEM=$P(PXCAIMM,U,6)
 .. S PXCAITEM=$P(PXCAIMM,U,7)
 .. I $L(PXCAITEM)>80 S PXCA("ERROR","IMMUNIZATION",PXCAPRV,PXCAINDX,6)="IMMUNIZATION remarks must be 1-80 Characters^"_PXCAITEM
 .. I PXCABULD&'$D(PXCA("ERROR","IMMUNIZATION",PXCAPRV,PXCAINDX))!PXCAERRS D IMM(PXCAIMM,.PXCANUMB,PXCAPRV,PXCAERRS)
 Q
 ;
