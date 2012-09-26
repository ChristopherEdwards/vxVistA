GMRCR ;SLC/DLT - Driver for reviewing patient consult/requests - Used by Medicine Package to link Consults to Medicine results ;9/18/98  16:26
 ;;3.0;CONSULT/REQUEST TRACKING;**1,5**;DEC 27, 1997
EN ;Entry point for medicine results entry by procedure or consult type
 ;Required variables:
 ;  GMRCPRNM = name of procedure file with results.
 ;  DFN = patient file (2) ien
 ;Optional variables:
 ;  GMRCSR = variable pointer for results
 ;  ORSTS = order status
 ;  GMRCI = 0 or undefined, assume interactive
 ;          1, assume non-interactive - not operational currently
 ;Returned variables:
 ;  ORIFN = Pointer to the consult order in file 100
 ;  GMRCO = Pointer to the Request/Consultation entry in file 123.5
 ;
 K DTOUT,DUOUT,ORIFN,GMRCO,GMRCX
 I '$D(GMRCPNM) D DEM^GMRCU
 I $D(GMRCPRNM) S GMRC=$O(^ORD(101,"B","GMRCR "_GMRCPRNM,0)),GMRCTYPE="GMRCOR REQUEST"
 E  I $D(GMRCPR) S GMRC=GMRCPR,GMRCTYPE="GMRCOR REQUEST"
 I $D(GMRCCT) S GMRC=GMRCCT,GMRCTYPE="GMRCOR CONSULT"
 I $D(GMRC)=1!($D(GMRC)=11),+GMRC D
 .S GMRCVP=GMRC_";ORD(101,",GMRCNM=$S($D(^ORD(101,GMRC,0)):$P(^(0),"^",2),1:"")
 .S GMRCSS=$P($G(^ORD(101,+GMRCVP,5)),"^"),GMRCSS=+GMRCSS
EN1 ;Entry point for
 Q  I 'GMRCSS D ASRV^GMRCASV D  Q:GMRCEND  S GMRCSS=+GMRCDG I 'GMRCDG S GMRCEND=1 K GMRCSS Q
 .I $D(DTOUT)!($D(DIROUT)) S GMRCEND=1 K DTOUT,DIROUT,DIRUT,DUOUT Q
 .Q
 E  S GMRCDG=GMRCSS D SERV1^GMRCASV
 I '$D(ORTKG) S ORTKG=$$PACKAGE I ORTKG="" S GMRCMSG="Missing package entry for CONSULT/REQUEST TRACKING" D EXAC^GMRCADC(GMRCMSG) K GMRCMSG S GMRCEND=1 Q
 ;old code? D TEAM^GMRCASV
 S GMRCSSNM=$P(^GMR(123.5,GMRCSS,0),"^",1)
 ;old codeN GMRCQIT
 ;old code? S ORVP=DFN_";DPT(",GMRCGRP=0
 ;old code? K ^TMP("GMRCR",$J)
 K GMRCOER,GMRCQUT
 S GMRCEN=1
 D EN^GMRCMENU ; used to be D EN^GMRCACTM
 S GMRCOER=0
 D AD^GMRCSLM1 ; used to be D AD^GMRCRA
 D EN^VALM("GMRC CONSULT TRACKING")
 D KILL
 Q
KILL ; Kill variables, but don't kill GMRCO and ORIFN if from MC option
 ;K VALMCNT,VALMBCK,VALMPGE
 ;K ^TMP("GMRCR",$J,"CS"),^TMP("GMRCS",$J)
 K X,Y,Z,DTOUT,DUOUT,DIROUT
 K GMRC,GMRCA,GMRCACT,GMRCACTM,GMRCAGE,GMRCCT,GMRCCTX,GMRCDG,GMRCDGT
 K GMRCDOB,GMRCDTM,GMRCGRP,GMRCH,GMRCHDR,GMRCIFN,GMRCLFG,GMRCNM,GMRCNPG
 K GMRCPNM,GMRCRB,GMRCWARD,GMRCSN,GMRCRPG,GMRCNPG,GMRCTITL,GMRCX,GMRCHDR,GMRCH,GMRCDTM
 K GMRCSTS,GMRCTYPE,GMRCVP,GMRCEND,GMRCTO,GMRCURG,GMRCL,GMRCDT,GMRCDIC
 K VA,VAIN,VAINDT,VADM,VAEL,VAPA,VAERR,VAROOT
 K O,OREND,ORINDX,ORNS,POP,SEX,W,XQORSPEW
 I $D(XQY0),$E(XQY0,1,2)="MC" S:'$D(GMRCO) (ORIFN,GMRCO)="" Q
 K ORIFN,GMRCO,GMRCSR
 Q
RESULT ;Entry point to set up variable pointer to results and update OE/RR status
 Q
 Q:'$D(GMRCSR)  Q:'$D(GMRCO)  S (GMRCSS,GMRCSSNM,GMRCNM,GMRC,GMRCVP)=""
 S GMRCOM=0,GMR(0)=$S($D(^GMR(123,+GMRCO,0)):^(0),1:""),GMRCSS=$P(GMR(0),"^",5) I GMRCSS,$D(^GMR(123.5,GMRCSS,0)) S GMRCSSNM=$S($L($P(^GMR(123.5,GMRCSS,0),"^",9)):$P(^(0),"^",9),1:$P(^(0),"^"))
 S GMRCVP=$P(GMR(0),"^",8) I +GMRCVP S DIC="^"_$P(GMRCVP,";",2)_$P(GMRCVP,";")_",0)" I $L(DIC),$D(@DIC) S GMRCNM=@(DIC),GMRCNM=$P(GMRCNM,"^",2)
 I '$D(ORSTS) S ORSTS=6 ;Assume order entry status of active
 S GMRCA=$O(^GMR(123.1,"AC",+ORSTS,"")) I 'GMRCA S GMRCA=9
 S DIE=123,DA=GMRCO,DR="11////^S X=GMRCSR;8////^S X=ORSTS;9////^S X=GMRCA"
 L +^GMR(123,GMRCO) I '$T S GMRCMSG="Consult/Request Is Being Used By Another User.",GMRCMSG(1)="RESULT UPDATE WAS UNSUCCESSFUL!  Try Again Later" D EXAC^GMRCADC(.GMRCMSG) K GMRCO,ORIFN,GMRCMSG D KILL Q
 D ^DIE K DIE,DA,DR
 L -^GMR(123,GMRCO) D AUDIT^GMRCP
 S:'$D(ORIFN) ORIFN=$P(^GMR(123,+GMRCO,0),"^",3)
 S GMRCORNP=$P(GMR(0),"^",14),GMRCTYPE=$P(GMR(0),"^",17)
 I $L($P(GMR(0),"^",14)) S GMRCADUZ($P(GMR(0),"^",14))=""
 I ORIFN D EN^GMRCHL7(DFN,GMRCO,$G(GMRCTYPE),$G(GMRCRB),"RE",GMRCORNP,$G(GMRCVSIT),.GMRCOM)
 K GMR,GMRCSS,GMRCORVP,GMRCVP,GMRCNM,DIC,GMRCPR
 Q
 ;
PACKAGE() ;  Returns the package entry number for 'CONSULT/REQUEST TRACKING"
 Q $$FIND1^DIC(9.4,,"QX","CONSULT/REQUEST TRACKING")
 ;
