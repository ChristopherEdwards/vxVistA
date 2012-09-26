SISREG00 ;SIS/LM - Clone and modify routine DGREG00
 ;;1.0;NON-VA REGISTRATION;;;Build 15
 ;Copyright 2008 - 2009, Sea Island Systems, Inc.  Rights are granted as follows:
 ;Sea Island Systems, Inc. conveys this modified VistA routine to the PUBLIC DOMAIN.
 ;This software comes with NO warranty whatsoever.  Sea Island Systems, Inc. will NOT be
 ;liable for any damages that may result from either the use or misuse of this software.
 ;
DGREG00 ;ALB/JDS-REGISTER A PATIENT, CONT. ; 1/3/05 6:18pm
 ;;5.3;Registration;**86,108,113,91,149,642,624**;Aug 13, 1993
W1 ;
 ; SIS/LM non-VA registration -
 ;Skip 10-10, DRUG PROFILE (and Health Summary), ROUTING SLIP (parameter based)
 G:$$GET^XPAR("ALL","SIS REG BYPASS 10-10 PRINT ETC")=1 EMBOS
 ; End non-VA modification
 D NOW^%DTC S DGNOW=% K A,DGOPT
 ;Print 10-10EZ
 N FORM,EASMTIEN
 S FORM=$$SEL1010^DG1010P("EZ")
 S EASMTIEN=0
 I FORM="EZ" D
 . N EAPP,EAIP
 . S (EAPP,EAIP)=0 F  S EAPP=$O(^EAS(712,"AC",DFN,EAPP)) Q:'EAPP!EAIP  D
 . . I $$GET1^DIQ(712,EAPP,7.1)="" D
 . . . N EAIX,EADT F EAIX="REV","PRT","SIG" Q:EAIP  D
 . . . . S EADT=0 F  S EADT=$O(^EAS(712,EAIX,EADT)) Q:'EADT!EAIP  I $D(^EAS(712,EAIX,EADT,EAPP)) S EAIP=1
 . I EAIP D  Q
 . . N DIR
 . . W !!,"No data have been found for the selected patient, or"
 . . W !,"the patient may have an on-line 10-10EZ application"
 . . W !,"in progress.  The 10-10EZ form shall not be printed."
 . . S DIR(0)="E" D ^DIR
 . . S FORM=""
 . S EASMTIEN=$$MTPRMPT^DG1010P(DFN,$G(DGMTI))
 I FORM="EZ" S DB=1
 ;
W3 S PRF=0,RT=0 G QU:'$D(^DG(43,1,0))
PRO I $$PROMPRN^DG1010PA("PRO") S PRF=1
 I $$PROMPRN^DG1010PA("HS") S DGHS=1
RT W !,"ROUTING SLIP" S %=1 D YN^DICN G Q:%=-1 I '% S DGPRINT=4 D HLP G RT
 S RT=(%=1)
QU I $G(DB) D
 .S ZTRTN="EN^EASEZPDG",ZTDTH=DGNOW,ZTDESC="1010EZ - FROM REGISTRATION"
 .S ZTSAVE("DA")=DFN,ZTSAVE("DFN")=DFN,ZTSAVE("DFN1")=DFN1
 .S ZTSAVE("EASDFN")=DFN,ZTSAVE("EASFLAG")="",ZTSAVE("ZUSR")=DUZ
 .S ZTSAVE("EASMTIEN")=EASMTIEN
 .S ZTIO=DGIO(10) D ^%ZTLOAD
QUPRF I $G(PRF) D
 .S ZTRTN="DFN^PSOSD1",ZTDTH=DGNOW,ZTDESC="DRUG PROFILE - FROM REGISTRATION",ZTSAVE("PSOINST")=$G(PSOINST),ZTSAVE("PSONOPG")=$G(PSONOPG)
 .S ZTSAVE("PSOPAR")=$G(PSOPAR),ZTSAVE("PSTYPE")=$G(PSTYPE),ZTSAVE("DFN")=DFN,ZTSAVE("DFN1")=DFN1,ZTIO=DGIO("PRF")
 .D ^%ZTLOAD
QUHS I $G(DGHS)&$G(GMTSTYP) D
 .S ZTRTN="ENXQ^GMTSDVR",ZTDTH=DGNOW,ZTDESC="HEALTH SUMMARY - FROM REGISTRATION",ZTSAVE("GMTSTYP")=GMTSTYP,ZTSAVE("DFN")=DFN,ZTIO=DGIO(10)
 .D ^%ZTLOAD
 .K DGHS,GMTSTYP
QURT I $G(RT) S ZTRTN="EN1^SDROUT1",ZTDTH=DGNOW,ZTDESC="ROUTING SLIP - FROM REGISTRATION",ZTSAVE("DFN")=DFN,ZTSAVE("DIV")=DIV,ZTSAVE("DT")=DT,ZTIO=DGIO("RT") D ^%ZTLOAD
EMBOS ;W ! D EMBOS^DGQEMA
 D EF^DG1010P
Q K:'$D(DGASKDEV) DGIO
Q1 ;
 D EVNT
 D CIRN
 K %,%DT,A,B,ANS,APD,B,CURR,DA,DB,DE,DEF,DG1,DGCLPR,DGDAY,DGDFN,DGE,DGL,DGLL,DFMD,DGNEW,DGNOW,DGO,DIC,DIE,DINUM,DOW,DP,DR,I,I1,IOZBK,IOZFO,L,L1,L2,LL,LL1,LL2,MDCARD,PARA,PRF,RT,S,SC,SEEN
 ; SIS/LM non-VA registration -
 ; Return to A^SISREG in place of A^DGREG
 K VET,X,X1,X2,Y,Y1,ZTSK,D0,D1,DIV,DLAYGO,J,PGM,Z,EASMTIEN G A^SISREG:('$D(DGRPFEE)&('$D(RGMPI))) Q
 ; End non-VA custom modification
 ;
DT G DT^DIQ:Y
 Q
SSD S DIV=$S('$D(^DG(40.8,+$P(A(0),"^",4),0)):" 1",1:" "_$P(A(0),"^",4))
 Q
HLP S DGPRINT=$P("10-10^10-10I^DRUG PROFILE^ROUTING SLIP","^",DGPRINT) W !!,"CHOOSE FROM",!?4,"YES - To include a copy of the ",DGPRINT," for this patient.",!?4,"NO  - If you don't want to print a copy of the ",DGPRINT,"." K DGPRINT Q
 ;
EVNT ;list of external calls
 N VAFHDATE
 S VAFHDATE=+$G(^DPT(DFN,"DIS",DFN1,0))
 K VAFHFLG D:+$$SEND^VAFHUTL() EN^VAFHLA04(DFN,VAFHDATE) ;fires Registration HL7 V1.5 message
 K VAFHMRG
 Q
CIRN ;
 Q:$P($$SEND^VAFHUTL(),"^",2)'>0
 ;W !,"Doing CIRN Messaging..."
 N DGZDATE,ERR
 S DGZDATE=+$G(^DPT(DFN,"DIS",DFN1,0))
 S ERR=$$EN^VAFCA04(DFN,DGZDATE) ; fires off HL7 V1.6 message
 Q