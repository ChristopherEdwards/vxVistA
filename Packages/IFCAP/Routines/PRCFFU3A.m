PRCFFU3A ;WISC/SJG-FMS LIN,RCA,RCB,RCC SEGMENTS (AR TRANSACTION);4/27/94  1:39 PM
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;BUILD 'LIN' SEGMENT
LIN S TMPLINE=TMPLINE+1
 S ^TMP($J,"PRCMO",INT,TMPLINE)="LIN^~"
 Q
 ;
 ;BUILD 'RCA' SEGMENT
RCA N SEG,BOC,AMT,NUM,FOB
 S FOB=""
 I $D(PRCFA("FOB")),TYCODE'="M"!(PRCFA("FOB")]"") S FOB=$G(PRCTMP(442,+PO,6.4,"I")) I FOB="" S FOB="D"
 I PRCFA("MP")=21,TRCODE'="MO",TYCODE="M" D  G MOASEG
 .S BOC=+$P(TRNODE(3),"^",6)
 .S AMT=$J($P(TRNODE(4),"^",8),0,2)
 .S NUM=$E("00"_NUMB,$L(NUMB),99)
 ; POs, MOs, orig 1358
 S AMT=$P(FMSNOD,U,2) I TYCODE="E" Q:AMT'>0
 S BOC=$P(FMSNOD,U),AMT=$J($P(FMSNOD,U,2),0,2),NUMB=$P(FMSNOD,U,3),NUM=$E("00"_NUMB,$L(NUMB),99)
 I TYCODE="E" I NUM=991 I (FOB="D")&(+AMT=0) Q
 I TYCODE="M",'$D(PRCFCHG("BOC",BOC,NUMB)) Q
 I TYCODE="M",$D(PRCFCHG("BOC",BOC,NUMB)) D
 .S AMT=$J($P(PRCFCHG("BOC",BOC,NUMB),U,2),0,2)
 .S IDFLAG=$P(PRCFCHG("BOC",BOC,NUMB),U,4)
 ;
MOASEG S TMPLINE=TMPLINE+1,SEG=""
 I TYCODE="E" S $P(SEG,U,21)="01"
 S $P(SEG,U,19)=NUM,$P(SEG,U,20)=NUM,$P(SEG,U,22)=PRCBUD,$P(SEG,U,30)=BOC
 I $D(PRCFMO("JOB")),PRCFMO("JOB")="Y" S $P(SEG,U,32)=$P(PRCSTR,U,10)
 I $D(PRCFMO("RC")),PRCFMO("RC")="Y" S $P(SEG,U,33)=""
 S $P(SEG,U,34)=$FN(AMT,"-",2),$P(SEG,U,35)=IDFLAG
 I IDFLAG="D" S $P(SEG,U,36)="F"
 S ^TMP($J,"PRCMO",INT,TMPLINE)="LIN^~RCA^"_SEG_"^~"
 QUIT
 ;
 ;BUILD 'RCB' SEGMENT
RCB N SEG
 S TMPLINE=TMPLINE+1,SEG=""
 S ^TMP($J,"PRCMO",INT,TMPLINE)="RCB^~"
 I SEG S ^TMP($J,"PRCMO",INT,TMPLINE)="RCB^"_SEG_"^~"
 Q
 ;
 ;BUILD 'RCC' SEGMENT
RCC N SEG
 S TMPLINE=TMPLINE+1,SEG=""
 S ^TMP($J,"PRCMO",INT,TMPLINE)="RCC^~"
 I SEG S ^TMP($J,"PRCMO",INT,TMPLINE)="RCC^"_SEG_"^~"
 Q
