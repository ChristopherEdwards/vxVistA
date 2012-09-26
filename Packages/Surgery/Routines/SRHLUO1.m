SRHLUO1 ;BIR/DLR - Surgery Interface (Cont.) Utilities for building Outgoing HL7 Segments ; [ 05/20/99   7:14 AM ]
 ;;3.0; Surgery ;**41,88,127**;24 Jun 93
 ; Per VHA Directive 10-93-142, this routine SHOULD NOT be modified.
 ;INIT^HLTRANS MUST BE called before calling this routine.
ZCH(SRI,SREVENT,SRSTATUS,SRENT) ;sets ^TMP(SRENT,$J global for sending ZCH Scheduling Appointment Information segment(s)
 N ADD,ADD1,ADDR,PHONE,SRJ,SRM,SRP,SRREP,SRX,XX,ZCH,SROERR
 S (ZCH(1),ZCH(3))=HL("Q")
 S ZCH(2)=CASE
 ;eventid^text(STATUS)^coding scheme^...
 S ZCH(4)=$G(SREVENT)_HLCOMP_$G(SRSTATUS)_HLCOMP_"L"
 I $D(^SRF(CASE,"OP")) S ZCH(5)=$P($G(^("OP")),U,2) I ZCH(5)'="" D
 .S SRX=$$CPT^ICPTCOD(ZCH(5),$P($G(^SRF(CASE,0)),"^",9)),ZCH(5)=$P(SRX,U,2)_HLCOMP_$P(SRX,U,3)_HLCOMP_"C4"
 .S (SRJ,SRREP)=0 F  S SRJ=$O(^SRF(CASE,"OPMOD",SRJ)) Q:'SRJ  S SRP=$P(^SRF(CASE,"OPMOD",SRJ,0),U),SRM=$$MOD^ICPTMOD(SRP,"I",$P($G(^SRF(CASE,0)),U,9)) D
 ..S ZCH(18)=$G(ZCH(18))_$S(SRREP:HLREP,1:"")_$P(SRM,U,2)_HLCOMP_$P(SRM,U,3)_HLCOMP,SRREP=1
 I $G(ZCH(5))="" S ZCH(5)=HLCOMP_$P($G(^SRF(CASE,"OP")),U)
 I $D(^SRF(CASE,".4")) S ZCH(6)=$P($G(^(.4)),U) I ZCH(6)'="" S ZCH(6)=($P(ZCH(6),":")*60)+($P($G(ZCH(6)),":",2))_HLCOMP_"min"
 I $G(SRSTATUS)="(SCHEDULED)" D
 .S ZCH(7)=HLCOMP_HLCOMP_HLCOMP_$$HLDATE^HLFNC($P($G(^SRF(CASE,31)),U,4))_HLCOMP_$$HLDATE^HLFNC($P($G(^(31)),U,5))_HLCOMP_HLCOMP_HLCOMP_HLCOMP_HLCOMP_$P($G(^SRF(CASE,0)),U,11)
 I $G(SRSTATUS)'="(SCHEDULED)" S ZCH(7)=HLCOMP_HLCOMP_HLCOMP_$$HLDATE^HLFNC($P(^SRF(CASE,0),U,9))_HLCOMP_HLCOMP_HLCOMP_HLCOMP_HLCOMP_HLCOMP_$P($G(^SRF(CASE,0)),U,11)
 I $D(^SRF(CASE,"1.0")) S ZCH(12)=$P($G(^("1.0")),U,10) I ZCH(12)'="" S ZCH(12)=$$HNAME^SRHLU($G(ZCH(12)))
 I $D(^SRF(CASE,"CON")) S ZCH(17)=$P($G(^("CON")),U)
 S ^TMP(SRENT,$J,SRI)="ZCH"_HL("FS") F XX=1:1:18 S ^TMP(SRENT,$J,SRI)=^TMP(SRENT,$J,SRI)_$G(ZCH(XX))_$S(XX=18:"",1:HL("FS"))
 S SRI=SRI+1
 Q
ZIG(SRI,SRENT) ;sets ^TMP(SRENT,$J global for sending ZIG Appointment Information - General Resource Segment(s)
 Q:'$D(^SRF(CASE,27,0))
 N MON,ZIG
 S MON=0 F  S MON=$O(^SRF(CASE,27,MON)) Q:'MON  S ZIG=^SRF(CASE,27,MON,0) D
 .S ZIG(1)=$P(ZIG,U)_HLCOMP_$P($G(^SRO(133.4,$P(ZIG,U),0)),U)_HLCOMP_"99VA133.4"
 .S ZIG(2)=HLCOMP_"MONITOR"_HLCOMP
 .S ^TMP(SRENT,$J,SRI)="ZIG"_HL("FS") F XX=1:1:4 S ^TMP(SRENT,$J,SRI)=^TMP(SRENT,$J,SRI)_$G(ZIG(XX))_$S(XX=4:"",1:HL("FS")),ZIG(XX)=""
 .S SRI=SRI+1
 Q
ZIL(SRI,SRENT) ;sets ^TMP(SRENT,$J global for sending ZIL Appointment Information - Location Resource Segment(s)
 N FAC,LOC,SRC,X,ZIL
 I '$P(^SRF(CASE,0),U,2),'$D(^SRF(CASE,"NON")) Q
 I $P(^SRF(CASE,0),U,2) S LOC=$P($G(^SRS($P(^SRF(CASE,0),U,2),0)),U) I $G(LOC)'="" S LOC=$P(^SC(LOC,0),U),FAC=$P(^(0),U,4) I $G(FAC)="" S FAC=$P($G(^SRF(CASE,8)),U)
 I $D(^SRF(CASE,"NON")),$P(^("NON"),U,2) S LOC=$P(^SRF(CASE,"NON"),U,2) I $G(LOC)'="" S LOC=$P(^SC(LOC,0),U),FAC=$P(^(0),U,4) I $G(FAC)="" S FAC=$P($G(^SRF(CASE,8)),U)
 S ZIL(1)=$G(FAC)_HLCOMP_HLCOMP_HLCOMP_$G(LOC)
 S ZIL(2)=HLCOMP_$S($P($G(^SRF(CASE,"NON")),U)="Y":"NON OR",1:"OPERATING ROOM")
 S SRC=0 D  S ZIL(6)=$S($G(SRC)=1:"PENDING",1:"CONFIRMED")
 .I $D(^SRF(CASE,"REQ"))&($G(SRSTATUS)="(REQUESTED)") S:^SRF(CASE,"REQ")=1&($P($G(^SRF(CASE,.2)),U,2)="") SRC=1
 .I SRSTATUS="(SCHEDULED)" D STAT
 S ^TMP(SRENT,$J,SRI)="ZIL"_HL("FS") F X=1:1:6 S ^TMP(SRENT,$J,SRI)=^TMP(SRENT,$J,SRI)_$G(ZIL(X))_$S(X=6:"",1:HL("FS")),ZIL(X)=""
 S SRI=SRI+1
 Q
ZIP(SRI,SRENT) ;sets ^TMP(SRENT,$J,I) global for sending ZIP Appointment Information - Personnel Segment(s)
 N SRC,X,XX,ZIP
 I $D(^SRF(CASE,"NON")) D
 .I $P(^SRF(CASE,"NON"),U,6)'="" S ZIP(1)=$$HNAME^SRHLU($P(^("NON"),U,6)),ZIP(2)=HLCOMP_"PROVIDER"_HLCOMP_"99VA200" D SZIP
 .I $P(^SRF(CASE,"NON"),U,7)'="" S ZIP(1)=$$HNAME^SRHLU($P(^("NON"),U,7)),ZIP(2)=HLCOMP_"ATTEND PROVIDER"_HLCOMP_"99VA200" D SZIP
 I $D(^SRF(CASE,.1)) F X=4,5,6,13 S ZIP(1)=$P($G(^SRF(CASE,.1)),U,X) I $G(ZIP(1))'="" D
 .S ZIP(1)=$$HNAME^SRHLU(ZIP(1)),ZIP(2)=HLCOMP_$S(X=4:"SURGEON",X=5:"1ST ASST.",X=6:"2ND ASST.",X=13:"ATT. SURGEON",1:"")_HLCOMP_"99VA200"
 .D SZIP
 S X=0 F X=1,4 S ZIP(1)=$P($G(^SRF(CASE,.3)),U,X) I $G(ZIP(1))'="" D
 .S ZIP(1)=$$HNAME^SRHLU(ZIP(1)),ZIP(2)=HLCOMP_$S(X=1:"PRIN. ANES.",X=4:"ANES. SUPER.",1:"")_HLCOMP_"99VA200"
 .D SZIP
 Q
SZIP ;set the ZIP segment
 S SRC=0 D  S ZIP(6)=$S($G(SRC)=1:"PENDING",1:"CONFIRMED")
 .I $D(^SRF(CASE,"REQ"))&($G(SRSTATUS)="(REQUESTED)") S:^SRF(CASE,"REQ")=1&($P($G(^SRF(CASE,.2)),U,2)="") SRC=1
 .I SRSTATUS="(SCHEDULED)" D STAT
 S ^TMP(SRENT,$J,SRI)="ZIP"_HL("FS") F XX=1:1:6 S ^TMP(SRENT,$J,SRI)=^TMP(SRENT,$J,SRI)_$G(ZIP(XX))_$S(XX=6:"",1:HL("FS")),ZIP(XX)=""
 S SRI=SRI+1
 Q
STAT ;check scheduled cases to scheduled close time
 N SRI,SRS,SRTIME,X1,X2
 Q:'$D(^SRF(CASE,31))
 S SRI=$P($G(^SRF(CASE,8)),U),SRS=$O(^SRO(133,"B",SRI,0)),SRTIME=$P(^SRO(133,SRS,0),U,12) S:SRTIME="" SRTIME=1500
 S X1=$E($P(^SRF(CASE,0),U,9),1,7),X2=-1,SRYN="N" D C^%DTC D  Q:X'=DT  S SRTIME=X_"."_SRTIME D NOW^%DTC I %>SRTIME S SRC=0
 .I X'<DT S SRC=1
 .I X<DT S SRC=0
 Q
