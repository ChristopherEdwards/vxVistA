PXCEVFIL ;ISL/dee - Main routine to edit a visit or v-file entry ;10/15/04 11:50am
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**9,30,22,73,88,89,104,147,124,169**;Aug 12, 1996
 ;
 Q
EN(PXCECAT) ; -- main entry point for PXCE pxcecat EDIT
 I PXCECAT="SIT"!(PXCECAT="HIST") D PATINFO^PXCEPAT(.PXCEPAT) Q:$D(DIRUT)
 I PXCECAT'="SIT",PXCECAT'="APPM",PXCECAT'="HIST" Q:'$D(PXCEFIEN)!'$D(PXCEVIEN)!'$D(PXCEPAT)
 E  Q:(PXCEVIEW["P"&'$D(PXCEPAT))!(PXCEVIEW["H"&'$D(PXCEHLOC))!("~H~P~"'[("~"_$P(PXCEVIEW,"^")_"~"))
 I PXCECAT="CSTP",$L($T(DATE^SCDXUTL)),$$DATE^SCDXUTL(+$G(^AUPNVSIT(PXCEVIEN,0))) W !!,$C(7),"Stop Codes can not be added to encounters after "_$$FMDATE^SCDXUTL Q
 N PXCEQUIT
 I "~CPT~CSTP~"[PXCECAT D  Q:PXCEQUIT
 . S PXCEQUIT=0
 . I $P($G(^AUPNVSIT(PXCEVIEN,0)),"^",7)="E" D  Q:$G(PXCEQUIT)
 .. I PXCECAT="CSTP" W !!,$C(7),"Historical Encounters cannot have Stop Codes." D WAIT^PXCEHELP S PXCEQUIT=1 Q
 K PXCEQUIT
 D FULL^VALM1
 ;
 N PXCEVFIL,PXCELOOP,PXCENOER
 N PXCECODE,PXCEAUPN,PXCECATS,PXCECATT,PXCEFILE
 N PXCEPSCC
 S PXCECATS=$S(PXCECAT="SIT":"VST",PXCECAT="APPM":"VST",PXCECAT="HIST":"VST",PXCECAT="CSTP":"VST",1:PXCECAT)
 S PXCECODE="PXCE"_$S(PXCECAT="IMM":"VIMM",1:PXCECAT)
 S PXCEAUPN=$P($T(FORMAT^@PXCECODE),"~",5)
 S PXCECATT=$P($P($T(FORMAT^@PXCECODE),";;",2),"~",1)
 S PXCEFILE=$P($T(FORMAT^@PXCECODE),"~",2)
 S PXCEQUIT=0
 I '$D(PXCAAFTR),PXCECAT'="SIT",PXCECAT'="APPM",PXCECAT'="HIST",PXCEFIEN'>0 D ASK^PXCEVFI2(PXCEVIEN,.PXCEFIEN,PXCEAUPN,PXCECATT,PXCECODE)
 Q:PXCEQUIT
 I PXCECAT'="SIT",PXCECAT'="APPM",PXCECAT'="HIST" S PXCELOOP=+PXCEFIEN
 E  S PXCELOOP=1,PXCEFIEN=PXCEVIEN
 I PXCECAT="CSTP" D
 . I $$VSTAPPT^PXUTL1(PXCEPAT,+^AUPNVSIT(PXCEVIEN,0),PXCEHLOC,PXCEVIEN) S PXCELOOP=0
 . E  S PXCELOOP=1
 I $D(PXCAAFTR) S PXCELOOP=1
 F  D DOONE Q:PXCELOOP
 K PXCEFIEN
 Q
 ;
DOONE ;
 N PXCEUP,PXELAP
 N PXCEAFTR
 D INIT
 Q:PXCEQUIT
DOONE2 ;
 K PXKERROR
 S PXCENOER=0
 D EDIT^PXCEVFI1
 I 'PXCEQUIT,PXCECAT="SIT",$P($G(PXCEAFTR(0)),"^")]"",$P($G(PXCEAFTR(0)),"^",22)]"" D
 . I $D(^DPT(DFN,"S",$P(PXCEAFTR(0),"^"),0)),$P($G(^DPT(DFN,"S",$P(PXCEAFTR(0),"^"),0)),"^")=$P(PXCEAFTR(0),"^",22),$P(^DPT(DFN,"S",$P(PXCEAFTR(0),"^"),0),"^",2)["C" D
 .. S PXCEQUIT=1,$P(PXCEAFTR(0),"^")=""
 .. W !,$C(7),"Cannot create encounter for appointment date/time and clinic that was previously cancelled, NOTHING was STORED"
 .. D WAIT^PXCEHELP
 I ($P(PXCEAFTR(0),"^")]"") D
 . I PXCEQUIT D
 .. I 'PXCEFIEN,PXCECAT="CPT" D
 ... D REMOVE(^TMP("PXK",$J,PXCECAT,1,"IEN"))
 .. I 'PXCENOER D
 ... I PXCEFIEN>0 D
 .... D:PXCECAT="CPT" MODUPD
 .... W !,$C(7),"The last entry did not have all of the required data and NOTHING was CHANGED."
 ... E  W !,$C(7),"The last entry did not have all of the required data and NOTHING was STORED."
 ... D WAIT^PXCEHELP
 . E  D SAVE^PXCEVFI2
 D EXIT
 Q
 ;
INIT ; -- init variables and list array
 N PXCENODS,PXCEFOR,PXCENODE
 K ^TMP("PXK",$J),PXCEAFTR
 S ^TMP("PXK",$J,"SOR")=PXCESOR
 S ^TMP("PXK",$J,"VST",1,"IEN")=PXCEVIEN
 I PXCECAT="SIT"!(PXCECAT="APPM")!(PXCECAT="HIST") D
 . I PXCEVIEN>0 L +@(PXCEAUPN_"(PXCEVIEN)"):5 E  W !!,$C(7),"Cannot edit at this time, try again later." D PAUSE^PXCEHELP S PXCEQUIT=1 Q
 . F PXCENODE=0,21,150,800,811,812 D
 .. S PXCEAFTR(PXCENODE)=$S(PXCEVIEN>0:$G(^AUPNVSIT(PXCEVIEN,PXCENODE)),1:"")
 .. S ^TMP("PXK",$J,"VST",1,PXCENODE,"BEFORE")=PXCEAFTR(PXCENODE)
 E  D
 . I PXCEFIEN>0 L +@(PXCEAUPN_"(PXCEFIEN)"):5 E  W !!,$C(7),"Cannot edit at this time, try again later." D PAUSE^PXCEHELP S PXCEQUIT=1 Q
 . F PXCENODE=0,21,150,800,811,812 D
 .. S ^TMP("PXK",$J,"VST",1,PXCENODE,"BEFORE")=$G(^AUPNVSIT(+PXCEVIEN,PXCENODE))
 .. S ^TMP("PXK",$J,"VST",1,PXCENODE,"AFTER")=^TMP("PXK",$J,"VST",1,PXCENODE,"BEFORE")
 . ;
 . S ^TMP("PXK",$J,PXCECATS,1,"IEN")=PXCEFIEN
 . S PXCENODS=$P($T(FORMAT^@PXCECODE),"~",3)
 . F PXCEFOR=1:1 S PXCENODE=$P(PXCENODS,",",PXCEFOR) Q:PXCENODE']""  D
 .. I PXCEFIEN>0 D
 ... I PXCECAT="CPT",PXCENODE=1 D
 .... ;Retrieve CPT Modifiers from multiple field
 .... S PXCESEQ=0
 .... F  S PXCESEQ=$O(@(PXCEAUPN_"(PXCEFIEN,PXCENODE,PXCESEQ)")) Q:'PXCESEQ  D
 ..... S ^TMP("PXK",$J,PXCECATS,1,PXCENODE,PXCESEQ,"BEFORE")=$G(@(PXCEAUPN_"(PXCEFIEN,PXCENODE,PXCESEQ,0)"))
 ..... S PXCEAFTR(PXCENODE,PXCESEQ)=^TMP("PXK",$J,PXCECATS,1,PXCENODE,PXCESEQ,"BEFORE")
 ... E  D
 .... S ^TMP("PXK",$J,PXCECATS,1,PXCENODE,"BEFORE")=$G(@(PXCEAUPN_"(PXCEFIEN,PXCENODE)"))
 .... S PXCEAFTR(PXCENODE)=^TMP("PXK",$J,PXCECATS,1,PXCENODE,"BEFORE")
 .. E  D
 ... I PXCECAT="CPT",PXCENODE=1 D  Q
 .... S ^TMP("PXK",$J,PXCECATS,1,PXCENODE,1,"BEFORE")=""
 ... S ^TMP("PXK",$J,PXCECATS,1,PXCENODE,"BEFORE")=""
 ... S PXCEAFTR(PXCENODE)=^TMP("PXK",$J,PXCECATS,1,PXCENODE,"BEFORE")
 Q:PXCEQUIT
 ;
 I PXCEAUPN'="^AUPNVSIT" D
 . ;Set the Patient and Visit pointers in the V-File.
 . S:'$P(PXCEAFTR(0),"^",2) $P(PXCEAFTR(0),"^",2)=PXCEPAT
 . S:'$P(PXCEAFTR(0),"^",3) $P(PXCEAFTR(0),"^",3)=PXCEVIEN
 . I $P(PXCEAFTR(0),"^",1)="" D
 .. S:'$P(PXCEAFTR(812),"^",2) $P(PXCEAFTR(812),"^",2)=PXCEPKG
 .. S:'$P(PXCEAFTR(812),"^",3) $P(PXCEAFTR(812),"^",3)=PXCESOR
 E  D
 . ;If new visit set package and source.
 . I $P(PXCEAFTR(0),"^",1)="" D
 .. S:'$P(PXCEAFTR(812),"^",2) $P(PXCEAFTR(812),"^",2)=PXCEPKG
 .. S:'$P(PXCEAFTR(812),"^",3) $P(PXCEAFTR(812),"^",3)=PXCESOR
 . ;Set the Patient in the Visit for new visit.
 . I $G(PXCEAPDT)>0 D
 .. S:'$P(PXCEAFTR(0),"^",1) $P(PXCEAFTR(0),"^",1)=PXCEAPDT
 .. I '$P(PXCEAFTR(0),"^",21) D
 ... ;Get the ELIGIBILITY for the appointment
 ... N PXCEELIG
 ... S PXCEELIG=$$ELIGIBIL^PXCEVSIT(PXCEPAT,PXCEHLOC,PXCEAPDT)
 ... S:PXCEELIG>0 $P(PXCEAFTR(0),"^",21)=PXCEELIG
 . S:'$P(PXCEAFTR(0),"^",5)&($G(PXCEPAT)>0) $P(PXCEAFTR(0),"^",5)=PXCEPAT
 . S:'$P(PXCEAFTR(0),"^",22)&($G(PXCEHLOC)>0) $P(PXCEAFTR(0),"^",22)=PXCEHLOC
 Q
 ;
EXIT ; -- exit code
 I PXCECAT="SIT"!(PXCECAT="APPM")!(PXCECAT="HIST") L:PXCEVIEN>0 -@(PXCEAUPN_"(PXCEVIEN)"):30
 E  L:PXCEFIEN>0 -@(PXCEAUPN_"(PXCEFIEN)"):30
 S PXCEFIEN=""
 K ^TMP("PXK",$J)
 K PXCEAFTR
 S PXCEQUIT=0
 Q
 ;
MODUPD ;Update the MODIFIER list for the currently edited CPT code when all
 ;the reqired data is not entered.
 ;
 N SQ,DA,DIC,DIK,X
 S SQ=""
 F  S SQ=$O(PXCEAFTR(1,SQ)) Q:'SQ  D
 .S DA(1)=PXCEFIEN,DA=SQ
 .S DIK="^AUPNVCPT("_DA(1)_","_1_","
 .D ^DIK
 F  S SQ=$O(^TMP("PXK",$J,"CPT",1,1,SQ)) Q:'SQ  D
 .S X=^TMP("PXK",$J,"CPT",1,1,SQ,"BEFORE")
 .Q:X']""
 .K DD,DO
 .S DA(1)=PXCEFIEN
 .S DIC="^AUPNVCPT("_DA(1)_","_1_","
 .S DIC(0)="L",DIC("P")=$P(^DD(9000010.18,1,0),"^",2)
 .D FILE^DICN
 Q
 ;
REMOVE(DA) ;REMOVE INCOMPLETE CPT ENTRY
 N DIK
 S DIK="^AUPNVCPT("
 I $G(DA) D ^DIK ;PX*1*124
 Q
