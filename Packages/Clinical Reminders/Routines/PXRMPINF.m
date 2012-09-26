PXRMPINF ; SLC/PKR - Routines relating to patient information. ;10/07/2004
 ;;2.0;CLINICAL REMINDERS;;Feb 04, 2005
 ;
 ;======================================================
DATACHG ;This entry point is called whenever patient data has changed.
 ;It is attached to the following event points:
 ;PXK VISIT DATA EVENT
 ;
 I '$D(^TMP("PXKCO",$J)) Q
 N DATA,DFN,DGBL,NODE,PXRMDFN,VIEN,VISIT,VF,VFL,VGBL
 S DFN=""
 ;Look for PXK VISIT DATA EVENT data.
 S VISIT=$O(^TMP("PXKCO",$J,""))
 S VIEN=$O(^TMP("PXKCO",$J,VISIT,"VST",""))
 S NODE=$O(^TMP("PXKCO",$J,VISIT,"VST",VIEN,""))
 S DATA=$G(^TMP("PXKCO",$J,VISIT,"VST",VIEN,NODE,"AFTER"))
 I DATA="" S DATA=$G(^TMP("PXKCO",$J,VISIT,"VST",VIEN,NODE,"BEFORE"))
 S DFN=$P(DATA,U,5)
 S PXRMDFN="PXRMDFN"_DFN
 ;Build the list of V Files.
 S VF=""
 F  S VF=$O(^TMP("PXKCO",$J,VISIT,VF)) Q:VF=""  D
 . S DGBL=$S(VF="CPT":"PXD(811.2,",VF="HF":"AUTTHF(",VF="IMM":"AUTTIMM(",VF="PED":"AUTTEDT(",VF="POV":"PXD(811.2,",VF="SK":"AUTTSK(",VF="XAM":"AUTTEXAM(",1:"")
 . S VGBL=$S(VF="CPT":"AUPNVCPT(",VF="HF":"AUPNVHF(",VF="IMM":"AUPNVIMM(",VF="PED":"AUPNVPED(",VF="POV":"AUPNVPOV(",VF="SK":"AUPNVSK(",VF="XAM":"AUPNVXAM(",1:"")
 . S VFL(VF)=DGBL_U_VGBL
 ;Call the routines that need to process the data.
 D UPDPAT^PXRMMST(DFN,VISIT,.VFL)
 Q
 ;
 ;======================================================
DEM(DFN,TODAY,DEMARR) ;Load the patient demographics into DEMARR
 ;The patient's age is calculated using whatever date is passed as
 ;TODAY. If there is a date of death and it is greater than TODAY
 ;then set the date of death to null. Direct read of patient file
 ;supported DBIA #10035. DATE OF BIRTH and SEX are required fields
 ;in the patient file.
 N TEMP
 K DEMARR
 I $L(DFN)'>0 S DEMARR("PATIENT")="" Q
 S TEMP=$G(^DPT(DFN,0))
 I TEMP="" S DEMARR("PATIENT")="" Q
 S DEMARR("PATIENT")=$P(TEMP,U,1)
 S DEMARR("SEX")=$P(TEMP,U,2)
 S DEMARR("DOB")=$P(TEMP,U,3)
 S DEMARR("SSN")=$P(TEMP,U,9)
 S DEMARR("DOD")=$P($G(^DPT(DFN,.35)),U,1)
 I DEMARR("DOD")>TODAY S DEMARR("DOD")=""
 S DEMARR("DFN")=DFN
 S DEMARR("AGE")=$$AGE^PXRMAGE(DEMARR("DOB"),DEMARR("DOD"),TODAY)
 ;DBIA #1096
 S TEMP=$O(^DGPM("ATID1",DFN,""))
 I TEMP'="" S TEMP=9999999.999999-TEMP
 S DEMARR("LAD")=TEMP
 Q
 ;
