XDRPTSSN ;SF-IRMFO/IHS/OHPRD/JCM;COMPARES SSN'S; ;1/27/97  15:20
 ;;7.3;TOOLKIT;**23**;Apr 25, 1995
 ;;
 ;
START ;
 I XDRCD(XDRFL,XDRCD,.09,"I")']""!(XDRCD2(XDRFL,XDRCD2,.09,"I")']"") G END
 D INIT
 D COMPARE
END D EOJ
 Q
 ;
INIT ;
 D EOJ
 S XDRDSSN("MATCH")=$P(XDRDTEST(XDRDTO),U,6)
 S XDRDSSN("NO MATCH")=$P(XDRDTEST(XDRDTO),U,7)
 S XDRDSN=XDRCD(XDRFL,XDRCD,.09,"I")
 I XDRDSN'?9N.E S XDRDSN="",^XTMP("XDRERR","BADSSN",XDRCD)=""
 S XDRDSN2=XDRCD2(XDRFL,XDRCD2,.09,"I")
 I XDRDSN2'?9N.E S XDRDSN="",^XTMP("XDRERR","BADSSN",XDRCD2)=""
 S XDRDSNF=$E(XDRDSN,1,3),XDRDSN2F=$E(XDRDSN2,1,3)
 S XDRDSNS=$E(XDRDSN,4,5),XDRDSN2S=$E(XDRDSN2,4,5)
 S XDRDSNT=$E(XDRDSN,6,9),XDRDSN2T=$E(XDRDSN2,6,9)
 Q
 ;
COMPARE ;
 I XDRDSN=""!(XDRDSN2="") G COMPAREX
 ; SKIP SSN'S IF THEY ARE PSEUDOS
 I $E(XDRDSN,10)="P"!($E(XDRDSN2,10)="P") G COMPAREX
 ; SKIP SSN'S IF THEY ARE NOT REAL (I.E., 00000NNNN)
 I $E(XDRDSN,1,5)="00000"!($E(XDRDSN2,1,5)="00000") G COMPAREX
 ; ADDED LOGIC TO DETERMINE IF ONLY ONE DIGIT IS CHANGED, OR TWO
 ; DIGITS SWITCHED
 ;   THIS IS ASSIGNED THE MAXIMUM MATCH VALUE, AND LAST 4, ETC LESS.
 ;
 N N
 S N=$$NUMCOMP^XDRPTCLN(XDRDSN,XDRDSN2,XDRDSSN("MATCH"),XDRDSSN("NO MATCH"),1) I N=XDRDSSN("MATCH") S XDRD("TEST SCORE")=XDRDSSN("MATCH") G COMPAREX
 ;CHECK TO SEE IF LAST FOUR MATCH OR TWO OF THREE PARTS MATCH
 I XDRDSNT=XDRDSN2T D  G COMPAREX
 . S XDRD("TEST SCORE")=.6*XDRDSSN("MATCH")
 . I $E($P(^DPT(XDRCD,0),U))=$E($P(^DPT(XDRCD2,0),U)) D
 . . S XDRD("TEST SCORE")=.8*XDRDSSN("MATCH")
 S XDRDSSN("CNT")=0
 I XDRDSNF=XDRDSN2F S XDRDSSN("CNT")=XDRDSSN("CNT")+1
 I XDRDSNS=XDRDSN2S S XDRDSSN("CNT")=XDRDSSN("CNT")+1
 I XDRDSSN("CNT")>1 S XDRD("TEST SCORE")=XDRDSSN("MATCH")*.4 K XDRDSSN("CNT") G COMPAREX
 ;
 ;CHECK POSITIONAL RELATIONSHIP OF LAST FOUR DIGITS OF SSN'S
 S XDRDSSN("PCNT")=0
 F XDRDSSN("I")=1:1:4 Q:(XDRDSSN("PCNT")>2)  I $E(XDRDSNT,XDRDSSN("I"))'=$E(XDRDSN2T,XDRDSSN("I")) S XDRDSSN("PCNT")=XDRDSSN("PCNT")+1
 I XDRDSSN("PCNT")'>2,XDRDSSN("CNT")>0 S XDRD("TEST SCORE")=XDRDSSN("MATCH")*.2 G COMPAREX
 ;
 ;ASSIGN NEGATIVE VALUE FOR NO SSN MATCH
 S XDRD("TEST SCORE")=XDRDSSN("NO MATCH")
COMPAREX ;
 Q
 ;
EOJ ;
 K XDRDSN,XDRDSN2,XDRDSNF,XDRDSN2F,XDRDSNS,XDRDSN2S,XDRDSNT,XDRDSN2T
 K XDRDSSN
 Q
