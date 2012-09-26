RMPFRPC3        ;DDC/PJU - ROES3 ELIGIBILITY MESSAGES ;11/01/02
 ;;3.0;REMOTE ORDER ENTRY SYSTEM;;11/01/02
START(RE,DUZ,GRP,SUBJ,RMPFARR)    ;ELIG MSGS;
 ;RE WILL RETURN 1 if OK, 0 if error and XMZ if mail msg sent
 ;DUZ OF USER
 ;MAIL GROUP RECEIVING
 ;SUBJECT LINE
 ;ARRAY OF TEXT LINES FOR MSG
 N CT,XMZ,EL,AP,SSN,SG,DFN S RE=1,(AP,EL,SG,SSN,DFN)=""
SEND D KILL^XM
 S CT=0 F  S CT=$O(RMPFARR(CT)) Q:'CT  D
 .S:$P(RMPFARR(CT)," ",1)="Eligibility:" EL=$P(RMPFARR(CT),":",2),EL=$$TRIM^XLFSTR(EL)
 .S:$P(RMPFARR(CT)," ",1)="SSN:" SSN=$P(RMPFARR(CT),":",2),SSN=$$TRIM^XLFSTR(SSN)
 .S:$P(RMPFARR(CT),":",1)="Suggested Eligibility" SG=$P($G(RMPFARR(CT)),":",2),SG=$$TRIM^XLFSTR(SG)
 .S:$P(RMPFARR(CT)," ",1)="Request:" AP=$P(RMPFARR(CT),":",2),AP=$$TRIM^XLFSTR(AP) ;approved/disapproved
 S XMSUB=SUBJ
 S XMDUZ=DUZ
 D XMZ^XMA2
 I XMZ<0 S RE=0 G END
 S RE=XMZ
 S DIE=3.9,DA=XMZ,DR="1.7////P" D ^DIE K DIE,DA,DR ;send priority
 S XMY(DUZ)=""
 S XMY(GRP)=""
 S XMTEXT="RMPFARR("
 S XMDUZ=DUZ
 D EN1^XMD ;SEND MSG
 S:$G(XMERR) RE=0 ;error occurred
END ;
 I XMZ>0 D
 .I SUBJ="ROES Eligibility Request" D  ;setup node after msg from asps to psas
 ..S DFN=$O(^DPT("SSN",SSN,0)) Q:'DFN
 ..S DIC="^RMPF(791814,",DIC(0)="FZ",X=DFN,DLAYGO=791814
 ..K DD,D0 D FILE^DICN Q:Y<1  S DIE=DIC,DA=+Y
 ..S DR=".02////"_DT_";.03////"_DUZ_";.04///"_$$FMADD^XLFDT(DT,60) D ^DIE ;60 DAYS FOR PSAS TO ACT
 ..S DR="1.01////"_SG_";1.02////"_XMZ_";2.02////2" D ^DIE K DIE,DA,DR
 D KILL^XM
 Q
