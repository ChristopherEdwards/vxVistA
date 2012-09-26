APCDDMU1 ; IHS/CMI/LAB - EDITS FOR AUPNVSIT (VISIT:9000010) 24-MAY-1993 ; [ 02/19/03  1:57 PM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**3,4,5**;MAR 09, 1999
 ;
FOOT ;EP
 K APCDVSIT
 I $P(APCDREC,U,11)="" Q
 S APCDDMDT=$P(APCDREC,U,11)
 S APCDMTYP=$O(^AUTTEXAM("B","DIABETIC FOOT EXAM, COMPLETE",0))
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update foot exam.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVXAM("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVXAM(X,0),U)=APCDMTYP S G=1
 I G W !!,"Already have a foot exam on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.13 (ADD)]"
 S APCDALVR("APCDTEX")="`"_APCDMTYP
 S APCDALVR("APCDTRES")=$P(APCDREC,U,21)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Exam Entry for Foot Exam.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
EYE ;EP
 K APCDVSIT
 I $P(APCDREC,U,12)="" Q
 S APCDDMDT=$P(APCDREC,U,12)
 S APCDMTYP=$O(^AUTTEXAM("B","DIABETIC EYE EXAM",0))
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update eye exam.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVXAM("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVXAM(X,0),U)=APCDMTYP S G=1
 I G W !!,"Already have a exam exam on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.13 (ADD)]"
 S APCDALVR("APCDTEX")="`"_APCDMTYP
 S APCDALVR("APCDTRES")=$P(APCDREC,U,22)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Exam Entry for Eye Exam.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
DENTAL ;EP
 K APCDVSIT
 I $P(APCDREC,U,13)="" Q
 S APCDDMDT=$P(APCDREC,U,13)
 S APCDMTYP=$O(^AUTTEXAM("B","DENTAL EXAM",0))
 I 'APCDMTYP S APCDMTYP=$O(^AUTTEXAM("C",30,0))
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update dental exam.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVXAM("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVXAM(X,0),U)=APCDMTYP S G=1
 I G W !!,"Already have a dental exam on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.13 (ADD)]"
 S APCDALVR("APCDTEX")="`"_APCDMTYP
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Exam Entry for Dental Exam.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
PAP ;EP
 K APCDVSIT
 I $P(APCDREC,U,14)="" Q
 S APCDDMDT=$P(APCDREC,U,14)
 S APCDMTYP=$O(^ICD0("AB",91.46,0))
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update pap procedure.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVPRC("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVPRC(X,0),U)=APCDMTYP S G=1
 I G W !!,"Already have a pap procedure on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.08 (ADD)]"
 S APCDALVR("APCDTPRC")="`"_APCDMTYP
 S APCDALVR("APCDTNQ")=$P(^ICD0(APCDMTYP,0),U,4)
 S APCDALVR("APCDTPD")=$$FMTE^XLFDT(APCDDMDT)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Procedure Entry for PAP Procedure.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
MAM ;EP
 K APCDVSIT
 I $P(APCDREC,U,15)="" Q
 S APCDDMDT=$P(APCDREC,U,15)
 S APCDMTYP=$O(^ICD0("AB",87.37,0))
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update mammogram procedure.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVPRC("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVPRC(X,0),U)=APCDMTYP S G=1
 I G W !!,"Already have a pap procedure on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.08 (ADD)]"
 S APCDALVR("APCDTPRC")="`"_APCDMTYP
 S APCDALVR("APCDTNQ")=$P(^ICD0(APCDMTYP,0),U,4)
 S APCDALVR("APCDTPD")=$$FMTE^XLFDT(APCDDMDT)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Procedure Entry for MAMMOGRAM Procedure.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
FLU ;EP
 K APCDVSIT
 I $P(APCDREC,U,16)=""!($P(APCDREC1,U,11)="") Q
 S APCDDMDT=$P(APCDREC,U,16)
 S APCDMTYP=$P(APCDREC1,U,11)
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update Flu Immunization.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVIMM("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVIMM(X,0),U)=APCDMTYP S G=1
 I G W !!,"Already have a flu immunization on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.11 (ADD)]"
 S APCDALVR("APCDTIMM")="`"_APCDMTYP
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Immunization Entry for Flu Immunization.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
PNEU ;EP
 K APCDVSIT
 I $P(APCDREC,U,17)=""!($P(APCDREC1,U,12)="") Q
 S APCDDMDT=$P(APCDREC,U,17)
 S APCDMTYP=$P(APCDREC1,U,12)
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update Pneumovac Immunization.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVIMM("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVIMM(X,0),U)=APCDMTYP S G=1
 I G W !!,"Already have a pneumovac immunization on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.11 (ADD)]"
 S APCDALVR("APCDTIMM")="`"_APCDMTYP
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Immunization Entry for Pneumovac Immunization.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
TD ;EP
 K APCDVSIT
 I $P(APCDREC,U,18)=""!($P(APCDREC1,U,13)="") Q
 S APCDDMDT=$P(APCDREC,U,18)
 S APCDMTYP=$P(APCDREC1,U,13)
 D EVSIT ;get event visit
 I '$G(APCDVSIT) W !!,"Could not Create PCC Visit when attempting to update Pneumovac Immunization.",! S APCDDMER=1 Q
 S (X,G)=0 F  S X=$O(^AUPNVIMM("AD",APCDVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVIMM(X,0),U)=APCDMTYP S G=1
 I G W !!,"Already have a TD immunization on Visit Date ",$$FMTE^XLFDT($P(^AUPNVSIT(APCDVSIT,0),U)) S APCDDMER=1 Q
 K APCDALVR
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.11 (ADD)]"
 S APCDALVR("APCDTIMM")="`"_APCDMTYP
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Immunization Entry for TD Immunization.  PCC not updated.",! S APCDDMER=1
 K APCDALVR
 Q
ID ;
 S:$E(APCDDMDT,6,7)="00" APCDDMDT=$E(APCDDMDT,1,5)_"01" S:$E(APCDDMDT,4,5)="00" APCDDMDT=$E(APCDDMDT,1,3)_"01"_$E(APCDDMDT,6,7)
 Q
BI() ;EP- check to see if using new imm package or not 1/5/1999 IHS/CMI/LAB
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
EVSIT ;get/create event visit
 K APCDVSIT
 K APCDALVR
 S APCDALVR("APCDAUTO")=""
 S APCDALVR("APCDPAT")=APCDDMPT
 S APCDALVR("APCDCAT")="E"
 S APCDALVR("APCDLOC")=DUZ(2)
 S APCDALVR("APCDTYPE")=$S($P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^APCCCTRL(DUZ(2),0),U,4),1:"O")
 S APCDALVR("APCDDATE")=APCDDMDT_".12"
 D ^APCDALV
 S APCDVSIT=$G(APCDALVR("APCDVSIT"))
 K APCDALVR
 Q
 ;
