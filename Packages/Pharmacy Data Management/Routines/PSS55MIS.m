PSS55MIS ;BIR/TSS - API FOR VARIOUS DATA FROM PHARMACY PATIENT FILE; 5 Sep 03
 ;;1.0;PHARMACY DATA MANAGEMENT;**112**;9/30/97;Build 30
STATUS(PSSFILE,PSSFIELD,LIST) ;
 ;PSSFILE - FILE NUMBER (VALIDATED AGAINST "FILES" LINE-TAG BELOW)
 ;PSSFIELD - FIELD NUMBER FROM FILE
 ;LIST - NAME OF LOCAL ARRAY RETURNED
 ;Returns the set of codes valid for the status field
 S PSSDIY=""
 Q:'$G(PSSFILE)  Q:'$G(PSSFIELD)  Q:$G(LIST)=""
 N PSSTEST S PSSTEST=$$VALID(PSSFILE,PSSFIELD)
 I PSSTEST'>0 S PSSDIY=-1 Q
 D FIELD^DID(PSSFILE,PSSFIELD,"","POINTER",LIST) Q
VALID(PSTFILE,PSTFIELD) ;TEST FOR VALID DATA INPUT FOR PSOFILE AND DIC
 N PSVLOOP,PSVTEST,PSVALID S PSVALID=-1
 F PSVLOOP=1:1 S PSVTEST=$P($T(FILES+PSVLOOP),";;",2)_";;"_$P($T(FILES+PSVLOOP),";;",3) Q:$G(PSVTEST)'>0!(PSVALID=1)  D
 .I PSTFILE=$P(PSVTEST,";;",1) D  Q
 ..I PSTFIELD=$P(PSVTEST,";;",2) S PSVALID=1
 Q PSVALID
 ;
FILES ;ACCESS FILE LIST
 ;;55.06;;28
 ;;55.01;;100
 ;;55.05;;5
 Q
CLINIC(PSSORD,PSSDFN,PSSMED) ;
 ;PSSORD - ORDER NUMBER
 ;PSSDFN - DFN NUMBER
 ;PSSMED - MED TYPE: "U" FOR UNIT DOSE, "I" FOR IV
 N PSSOUT S PSSOUT=""
 Q:'PSSORD
 Q:'PSSDFN
 Q:$G(PSSMED)=""
 S PSSIEN=PSSORD_","_PSSDFN
 K ^TMP($J,"TEMP")
 ;DMS TEST CASES FOR UNIT DOSE: 73,739
 ;TEST CASES FOR IV: 6,1
 I PSSMED="U" D
 .D GETS^DIQ(55.06,PSSIEN,"130","IE","^TMP($J,""TEMP"")")
 .I $G(^TMP($J,"TEMP",55.06,PSSIEN_",",130,"I"))'="" S PSSOUT=$G(^TMP($J,"TEMP",55.06,PSSIEN_",",130,"I"))_"^"_$G(^TMP($J,"TEMP",55.06,PSSIEN_",",130,"E"))
 I PSSMED="I" D
 .D GETS^DIQ(55.01,PSSIEN,"136","IE","^TMP($J,""TEMP"")")
 .I $G(^TMP($J,"TEMP",55.01,PSSIEN_",",136,"I"))'="" S PSSOUT=$G(^TMP($J,"TEMP",55.01,PSSIEN_",",136,"I"))_"^"_$G(^TMP($J,"TEMP",55.01,PSSIEN_",",136,"E"))
 K ^TMP($J,"TEMP")
 Q PSSOUT
 ;
