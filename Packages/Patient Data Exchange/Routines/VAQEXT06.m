VAQEXT06 ;ALB/JFP - CONTINUATION ROUTINE FOR VAQEXT01;20-MAY-93
 ;;1.5;PATIENT DATA EXCHANGE;;NOV 17, 1993
DISMAX ; -- Displays the segments which exceed the max time & occur limits
 Q:'$D(MAXARR)
 Q:'$D(@MAXARR)
 S SEGDE="",SEGMENT=""
 S X=$$SETSTR^VALM1("Segments exceeding maximum time and occurrence limits:","",1,80) D TMP^VAQEXT01
 F  S SEGDE=$O(@MAXARR@(SEGDE)) Q:SEGDE=""  D
 .S SEG=$P($G(^VAT(394.71,SEGDE,0)),U,2)
 .I ($L(SEGMENT_", "_SEG)>80) D
 ..S X=$$SETSTR^VALM1($E(SEGMENT,1,$L(SEGMENT-1)),"",1,80) D TMP^VAQEXT01
 ..S SEGMENT=""
 .S:SEGMENT'="" SEGMENT=SEGMENT_", "_SEG
 .S:SEGMENT="" SEGMENT="  "_SEGMENT_SEG
 S X=$$SETSTR^VALM1(SEGMENT,"",1,80) D TMP^VAQEXT01
 K @MAXARR,MAXARR
 QUIT
 ;
SEG ; -- Gather segments into display lines
 I '$D(^VAT(394.61,TRDE,"SEG",0)) D  QUIT
 .S SEGMENT($J,1)="No segments requested"
 K SEGMENT($J)
 N K,SEQ,SEGND,SEG,HSCOMPND,OLIMIT,TLIMIT
 S K=1,SEQ=0
 S:'$D(SEGMENT($J,K)) SEGMENT($J,K)=""
 F  S SEQ=$O(^VAT(394.61,TRDE,"SEG",SEQ))  Q:'SEQ  D
 .S SEGND=$G(^VAT(394.61,TRDE,"SEG",SEQ,0))
 .S SEGDE=+$P(SEGND,U,1),TLIMIT=$P(SEGND,U,2),OLIMIT=$P(SEGND,U,3)
 .S SEG=$P($G(^VAT(394.71,SEGDE,0)),U,2)
 .S HSCOMPND=$$HLTHSEG^VAQDBIH3(SEG,0)
 .I $P(HSCOMPND,U,1)'=0 D SEGDIS1
 .S SEG=$E(SEG_"               ",1,15) ; -- 15 spaces
 .I $L(SEGMENT($J,K)_SEG)>69 S K=K+1,SEGMENT($J,K)=""
 .S SEGMENT($J,K)=SEGMENT($J,K)_SEG
 K SEQ
 QUIT
 ;
SEGDIS ; -- Sets up segment display
 S SEGND=$G(^TMP("VAQSEG",$J,DOM,SEG))
 S TLIMIT=$P(SEGND,U,3)
 S OLIMIT=$P(SEGND,U,4)
SEGDIS1 ;
 I (TLIMIT="")&($P(HSCOMPND,U,2)=0) S TLIMIT="NA"
 I (OLIMIT="")&($P(HSCOMPND,U,3)=0) S OLIMIT="NA"
 I (TLIMIT="NA")&(OLIMIT="NA") QUIT
 S SEG=SEG_" ["_TLIMIT_":"_OLIMIT_"]"
 QUIT
