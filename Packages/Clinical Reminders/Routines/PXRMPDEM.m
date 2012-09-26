PXRMPDEM ; SLC/PKR - Computed findings for patient demographics. ;05/06/2008
 ;;2.0;CLINICAL REMINDERS;**5,4,11**;Feb 04, 2005;Build 39
 ;
 ;======================================================
AGE(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for returning a patient's
 ;age
 S DATE=$$NOW^PXRMDATE,TEST=1
 I $D(PXRMPDEM) D  Q
 . S VALUE=PXRMPDEM("AGE")
 . I +PXRMPDEM("DOD")=0 S VALUE("DECEASED")=0 Q
 . I +PXRMPDEM("DOD")>0 S VALUE("DECEASED")=1,TEXT="Patient is deceased"
 I '$D(PXRMPDEM) D
 . N DOB,DOD
 .;DBIA #10035
 . S DOB=$P(^DPT(DFN,0),U,3)
 . S DOD=$P($G(^DPT(DFN,.35)),U,1)
 . S VALUE=$$AGE^PXRMAGE(DOB,DOD,$$NOW^PXRMDATE)
 . I +DOD=0 S VALUE("DECEASED")=0 Q
 . I +DOD>0 S VALUE("DECEASED")=1,TEXT="Patient is deceased"
 Q
 ;
 ;======================================================
DOB(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for a patient's
 ;date of birth.
 I $D(PXRMPDEM) S VALUE=PXRMPDEM("DOB")
 ;DBIA #10035 DATE OF BIRTH is a required field.
 I '$D(PXRMPDEM) S VALUE=$P(^DPT(DFN,0),U,3)
 S TEST=$S(VALUE<$$NOW^PXRMDATE:1,1:0)
 I TEST S DATE=VALUE,TEXT=$$EDATE^PXRMDATE(VALUE)
 Q
 ;
 ;======================================================
DOD(DFN,TEST,DATE,VALUE,TEXT)   ;Computed finding for a patient's
 ;date of death.
 I $D(PXRMPDEM) S VALUE=+PXRMPDEM("DOD")
 ;DBIA #10035
 I '$D(PXRMPDEM) S VALUE=+$P($G(^DPT(DFN,.35)),U,1)
 S TEST=$S(VALUE=0:0,VALUE>$$NOW^PXRMDATE:0,1:1)
 I TEST S DATE=VALUE,TEXT=$$EDATE^PXRMDATE(VALUE)
 Q
 ;
 ;======================================================
ETHNY(DFN,NGET,BDT,EDT,NFOUND,TEST,DATE,VALUE,TEXT) ;Computed finding for
 ;a patient's ethnicity.
 N CNT,CNT1,VADM
 D DEM^VADPT
 I $D(VADM(11))'=11 S NFOUND=0 D KVA^VADPT Q
 S NGET=$S(NGET<0:-NGET,1:NGET)
 S (CNT,CNT1)=0
 F  S CNT=$O(VADM(11,CNT)) Q:(CNT="")!(CNT1=NGET)  D
 . S CNT1=CNT1+1,TEST(CNT1)=1,DATE(CNT1)=$$NOW^PXRMDATE
 . S TEXT(CNT1)="",VALUE(CNT1,"VALUE")=$P($G(VADM(11,CNT)),U,2)
 S NFOUND=CNT1
 D KVA^VADPT
 Q
 ;
 ;======================================================
HDISCH(DFN,NGET,BDT,EDT,NFOUND,TEST,DATE,DATA,TEXT) ;Computed finding for
 ;a list of a patient's discharge dates from PTF.
 ;References to ^DGPT covered by DBIA #1372.
 N DAS,DDATE,DDATEL,DONE,FEEBASIS,IEN,IND,INCEN,INFEE,NF,SDIR,TEMP,TYPE
 S TEMP=$$UP^XLFSTR(TEST)
 S TEMP=$P(TEMP,"IN:",2)
 S INFEE=$S(TEMP["FEE":1,1:0)
 S INCEN=$S(TEMP["CEN":1,1:0)
 S IEN="",NFOUND=0
 F  S IEN=$O(^DGPT("B",DFN,IEN)) Q:IEN=""  D
 . S DDATE=+$P($G(^DGPT(IEN,70)),U,1)
 . I DDATE>0,DDATE'<BDT,DDATE'>EDT S NFOUND=NFOUND+1,DDATEL(DDATE,NFOUND)=^DGPT(IEN,0)
 I NFOUND=0 Q
 S SDIR=$S(NGET<0:1,1:-1)
 S NGET=$S(NGET<0:-NGET,1:NGET)
 S (DONE,NF)=0
 S DDATE=""
 F IND=1:1:NFOUND Q:DONE  D
 . S DDATE=$O(DDATEL(DDATE),SDIR)
 . I DDATE="" S DONE=1 Q
 . S IEN=0
 . F  S IEN=$O(DDATEL(DDATE,IEN)) Q:(IEN="")!(DONE)  D
 .. S FEEBASIS=$P(DDATEL(DDATE,IEN),U,4)
 .. I FEEBASIS=1,'INFEE Q
 ..;Type 1 is PTF, Type 2 is Census
 .. S TYPE=$P(DDATEL(DDATE,IEN),U,11)
 .. I TYPE=2,'INCEN Q
 .. S NF=NF+1
 .. S TEST(NF)=1,(DATE(NF),VALUE(NF))=DDATE
 .. I FEEBASIS=1 S TEXT(NF)="Fee basis"
 .. I TYPE=2 S TEXT(NF)="Census"
 .. I NF=NGET S DONE=1
 S NFOUND=NF
 Q
 ;
 ;======================================================
NEWRACE(DFN,NGET,BDT,EDT,NFOUND,TEST,DATE,VALUE,TEXT) ;Computed finding
 ;for returning a patient's multi-valued race.
 N CNT,CNT1,IND,VADM
 D DEM^VADPT
 I $D(VADM(12))'=11 S NFOUND=0 D KVA^VADPT Q
 S NGET=$S(NGET<0:-NGET,1:NGET)
 S (CNT,CNT1)=0
 F  S CNT=$O(VADM(12,CNT)) Q:(CNT="")!(CNT1=NGET)  D
 . S CNT1=CNT1+1,TEST(CNT1)=1,DATE(CNT1)=$$NOW^PXRMDATE
 . S TEXT(CNT1)="",VALUE(CNT1,"VALUE")=$P($G(VADM(12,CNT)),U,2)
 F CNT=1:1:CNT1 F IND=1:1:CNT1 S VALUE(CNT,"RACE",IND)=VALUE(IND,"VALUE")
 S NFOUND=CNT1
 D KVA^VADPT
 Q
 ;
 ;======================================================
PATTYPE(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return the patient
 ;type
 N VAEL
 S VALUE=""
 S DATE=$$NOW^PXRMDATE
 D ELIG^VADPT
 S TEST=$S($G(VAEL(6))'="":1,1:0)
 S VALUE=$P(VAEL(6),U,2)
 D KVA^VADPT
 Q
 ;======================================================
RACE(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for checking a patient's race.
 N RACE
 S DATE=$$NOW^PXRMDATE
 ;DBIA #10035
 S RACE=$P($G(^DPT(DFN,0)),U,6)
 I RACE="" S TEST=0,VALUE="" Q
 Q
 ;
 ;======================================================
SEX(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for returning a patient's
 ;sex.
 S DATE=$$NOW^PXRMDATE,TEST=1
 I $D(PXRMPDEM) S VALUE=PXRMPDEM("SEX") Q
 ;DBIA #10035 SEX is a required field.
 I '$D(PXRMPDEM) S VALUE=$P(^DPT(DFN,0),U,2)
 Q
 ;
