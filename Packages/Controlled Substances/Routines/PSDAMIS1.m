PSDAMIS1 ;BIR/JPW-Print NAOU AMIS Report by Drug ; 1 Sept 94
 ;;3.0; CONTROLLED SUBSTANCES ;**17**;13 Feb 97
 ;
 ;References to ^PSD(58.8, are covered by DBIA 2711
 ;References to ^PSD(58.81 are covered by DBIS 2808
 ;References to ^PSDRUG( are covered by DBIA 221
START ;entry point for report
 K ^TMP("PSDAMIS",$J),^TMP("PSDAMISS",$J),^TMP("PSDAMIST",$J),^TMP("PSDAMISG",$J),^TMP("PSDAMISQT",$J),^TMP("PSDAMISQ",$J),^TMP("PSDAMISC",$J),^TMP("PSDAMISCN",$J),^TMP("PSDAMISCG",$J)
 K ^TMP("PSDM",$J),^TMP("PSDAMISVG",$J),^TMP("PSDAMISCVG",$J)
 I $D(ALL) D ALL G CHK
 F PSDR=0:0 S PSDR=$O(LOC(PSDR)) Q:'PSDR  F JJ=PSDSD:0 S JJ=$O(^PSD(58.81,"ACT",JJ)) Q:'JJ!(JJ>PSDED)  F JJ1=0:0 S JJ1=$O(^PSD(58.81,"ACT",JJ,JJ1)) Q:'JJ1  F KK=0:0 S KK=$O(^PSD(58.81,"ACT",JJ,JJ1,PSDR,2,KK)) Q:'KK  D SET
CHK ;checks for zero cost data & sends e-mail from ^PSDCOSM
 I $D(^TMP("PSDM",$J)) S PSDCHO(1)="AMIS Report by DRUG",Y=PSDT X ^DD("DD") S PSDT(1)=Y D ^PSDCOSM K PSDCHO,^TMP("PSDM",$J)
 G ^PSDAMIS0
ALL ;loops for all drugs
 Q:'$D(ALL)
 F JJ=PSDSD:0 S JJ=$O(^PSD(58.81,"ACT",JJ)) Q:'JJ!(JJ>PSDED)  F JJ1=0:0 S JJ1=$O(^PSD(58.81,"ACT",JJ,JJ1)) Q:'JJ1  F PSDR=0:0 S PSDR=$O(^PSD(58.81,"ACT",JJ,JJ1,PSDR)) Q:'PSDR  D
 .F KK=0:0 S KK=$O(^PSD(58.81,"ACT",JJ,JJ1,PSDR,2,KK)) Q:'KK  D SET
 Q
SET ;sets data
 Q:'$D(^PSD(58.81,KK,0))  S NODE=^PSD(58.81,KK,0),PSD=+$P(NODE,"^",18),PSDS=+$P(NODE,"^",3)
 Q:$P($G(^PSD(58.8,PSD,0)),"^",3)'=+PSDSITE  Q:$D(^PSD(58.81,KK,5))
 S PSDRN=$S($P($G(^PSDRUG(+PSDR,0)),"^")]"":$P(^(0),"^"),1:"DRUG NAME MISSING")
 S NAOUN=$S($P($G(^PSD(58.8,PSD,0)),"^")]"":$P(^(0),"^"),1:"NAOU NAME MISSING")
 S PSDSN=$S($P($G(^PSD(58.8,PSDS,0)),"^")]"":$P(^(0),"^"),1:"DISP. SITE NAME MISSING")
 S PSDPN=$S($P(NODE,"^",17)]"":$P(NODE,"^",17),1:"DISP W/O GS"),QTY=+$P(NODE,"^",6)
 S:+$P($G(^PSD(58.81,KK,4)),"^",3) QTY=+$P(^(4),"^",3)
 S COST=+$P($G(^PSDRUG(PSDR,660)),"^",6),COST=COST*QTY
 ;
 ;DAVE B (PSD*3*17 29APR99) - More detail on zero cost
 I 'COST S Y=$P(NODE,"^",4) X ^DD("DD") S ^TMP("PSDM",$J,PSDRN,Y)=$P(NODE,"^",1)_"^"_+$P($G(^PSDRUG(PSDR,660)),"^",6)_"^"_QTY W !,"SETTING GLBL"
 S ^TMP("PSDAMIS",$J,PSDRN,NAOUN,PSDPN,JJ)=QTY_"^"_COST
 S:'$D(^TMP("PSDAMIST",$J,PSDRN)) ^TMP("PSDAMIST",$J,PSDRN)=0 S ^TMP("PSDAMIST",$J,PSDRN)=+^TMP("PSDAMIST",$J,PSDRN)+1
 S:'$D(^TMP("PSDAMISQT",$J,PSDRN)) ^TMP("PSDAMISQT",$J,PSDRN)=0 S ^TMP("PSDAMISQT",$J,PSDRN)=+^TMP("PSDAMISQT",$J,PSDRN)+QTY
 S:'$D(^TMP("PSDAMISS",$J,PSDRN,NAOUN)) ^TMP("PSDAMISS",$J,PSDRN,NAOUN)=0 S ^TMP("PSDAMISS",$J,PSDRN,NAOUN)=+^TMP("PSDAMISS",$J,PSDRN,NAOUN)+1
 S:'$D(^TMP("PSDAMISQ",$J,PSDRN,NAOUN)) ^TMP("PSDAMISQ",$J,PSDRN,NAOUN)=0 S ^TMP("PSDAMISQ",$J,PSDRN,NAOUN)=+^TMP("PSDAMISQ",$J,PSDRN,NAOUN)+QTY
 S:'$D(^TMP("PSDAMISG",$J)) ^TMP("PSDAMISG",$J)=0 S ^TMP("PSDAMISG",$J)=+^TMP("PSDAMISG",$J)+1
 S:'$D(^TMP("PSDAMISVG",$J,PSDSN)) ^TMP("PSDAMISVG",$J,PSDSN)=0 S ^TMP("PSDAMISVG",$J,PSDSN)=+^TMP("PSDAMISVG",$J,PSDSN)+1
 S:'$D(^TMP("PSDAMISC",$J,PSDRN,NAOUN)) ^TMP("PSDAMISC",$J,PSDRN,NAOUN)=0 S ^TMP("PSDAMISC",$J,PSDRN,NAOUN)=+^TMP("PSDAMISC",$J,PSDRN,NAOUN)+COST
 S:'$D(^TMP("PSDAMISCN",$J,PSDRN)) ^TMP("PSDAMISCN",$J,PSDRN)=0 S ^TMP("PSDAMISCN",$J,PSDRN)=+^TMP("PSDAMISCN",$J,PSDRN)+COST
 S:'$D(^TMP("PSDAMISCG",$J)) ^TMP("PSDAMISCG",$J)=0 S ^TMP("PSDAMISCG",$J)=+^TMP("PSDAMISCG",$J)+COST
 S:'$D(^TMP("PSDAMISCVG",$J,PSDSN)) ^TMP("PSDAMISCVG",$J,PSDSN)=0 S ^TMP("PSDAMISCVG",$J,PSDSN)=+^TMP("PSDAMISCVG",$J,PSDSN)+COST
 Q
