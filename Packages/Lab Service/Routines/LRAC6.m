LRAC6 ;SLC/DCM/MIWL/JMC - PRINT CUMULATIVE REPORT CONT. (MISC.) ; 1/31/89  15:02 ;
 ;;5.2;LAB SERVICE;**174,225**;Sep 27, 1994
LRFD1 S LRFD1=0 F  S LRFD1=$O(^TMP($J,"K",K,LRFD,LRFD1)) Q:LRFD1<1  S ^LAC("LRKILL",LRDFN,LRMH,K,LRFD,LRFD1)=^TMP($J,"K",K,LRFD,LRFD1)
 Q:'$D(^LR(LRDFN,"CH",K(3),0))  S P=$P(^(0),U,9)
 S $P(^LR(LRDFN,"CH",K(3),0),U,9)=$S(P[LRMH_":"_LRPG:P,P[":":P_","_LRMH_":"_LRPG,1:LRMH_":"_LRPG)
 Q
HEAD1 I 'LRFULL!(LRPERM=1) S LRKL=1
 E  I 'LRRE S ^LR(LRDFN,"PG",LRMH)=LRMH_U_LRPG S K=0 F  S K=$O(^TMP($J,"K",K)) Q:K<1  S LRFD=0 F  S LRFD=$O(^TMP($J,"K",K,LRFD)) Q:LRFD<1  S Z=^(LRFD,0),K(2)=$P(Z,U,2),K(3)=$P(Z,U,3),^LAC("LRKILL",LRDFN,LRMH,K,LRFD,0)=Z D LRFD1
 K LRFD,K Q
HEAD ;from LRAC3, LRAC4, LRAC5, LRAC7
 D LRBOT D TOP Q
TOP ;from LRAC3
 W:$G(LRJ02)!($E(IOST,1,2)="C-") @IOF
 S LRJ02=1
 W !,PNM,?20,SSN,?33,"AGE: ",AGE
 I +LRDPF=2,$L($G(LRWRD)) W ?(IOM-42)," LOC: ",LRWRD
 W ?(IOM-22),$S($D(LRCDT):LRCDT,1:"??"),?(IOM-13),"PAGE: "
 W $S($D(LRMISC):"MISC",1:LRMH),":",LRPG W:LRBOT="T" !
 W !,$S($D(^LAB(64.5,1,1,LRMH,0)):$P(^(0),U,2),1:$P(^LAB(64.5,1,0),U,9))
 K ^TMP($J,"K") S LRKL=1,LRAG=0 Q
LRBOT ;from LRAC3
 W !
Y I $Y'>(IOSL-6) W ! G Y
 W $E(PNM,1,20),?21,SSN,?(IOM-46),"ROUTING: ",$E(LRLLOC,1,15),?(IOM-26)
 W $S(LRFULL!(LRPERM):" **PERMANENT**",1:"              ")
 W "  CHART COPY"
 W:LRBOT="B" !
 W $S($D(^LAB(64.5,1,1,LRMH,0)):$P(^(0),U,2),1:$P(^LAB(64.5,1,0),U,9))
 W:LRBOT'="B" !
 W ?(IOM-22),$S($D(LRCDT):LRCDT,1:"??"),?(IOM-13),"PAGE: "
 W $S($D(LRMISC):"MISC",1:LRMH),":",LRPG
 S LRTAB=(LRMH-1)*10#80 W !?LRTAB,$E(LRMHN,1,IOM-LRTAB)
 S:'$D(LRPG1) LRPG=LRPG+1
 Q
LRUDT S LRTIM=$E(LRFDT,9,12) F I=0:0 Q:$L(LRTIM)=4  S LRTIM=LRTIM_0
 S LRTIM=$S(LRTIM?4"0":"     ",1:$E(LRTIM,1,2)_":"_$E(LRTIM,3,4))
 S LRUDT=$E(LRFDT,4,5)_"/"_$E(LRFDT,6,7)_"/"_$E(LRFDT,2,3)_" "_$J(LRTIM,5)_" "
 Q
LRKILL D HEAD1,HEAD Q
 Q
LRMISC I LRPERM=0 Q:'$D(^LAC("LGOT",LRDFN,"MISC"))  S:'$D(LRPG1) LRPG=LRPG+1 K ^TMP($J,"K")
 S LRFDT=0 D TOP
MHI S LRMHN=$P(^LAC(LRXLR,LRDFN,LRMH,1,0),U,1),LRCNT=12 D WR
MDT S LRFDT=$O(^LAC(LRXLR,LRDFN,"MISC",1,1,LRFDT)) G:LRFDT<1 END
 I $D(DUZ("AG")),$L(DUZ("AG")),"ARMYAFN"[DUZ("AG"),LRDPF=2 D REG^LRAC9
 D LRUDT,LRCNT,WR:($Y>(IOSL-LRCNT))
 S ^TMP($J,"K",LRFDT,0)=^LAC(LRXLR,LRDFN,"MISC",1,1,LRFDT,0),LRMIT=0
LRMIT S LRMIT=$O(^LAC(LRXLR,LRDFN,"MISC",1,1,LRFDT,1,LRMIT)) G:LRMIT<1 TXT
 S ^TMP($J,"K",LRFDT,LRMIT)=$P(^LAC(LRXLR,LRDFN,"MISC",1,1,LRFDT,1,LRMIT,0),U,5)
 S LRLO="",LRHI=""
 S LRVAL=$P(^LAC(LRXLR,LRDFN,"MISC",1,1,LRFDT,1,LRMIT,0),U,1),LRX19=^(0)
 S X1=$P(LRX19,U,4),LRSPE=$P(LRX19,U,2),LRTEST=$P(LRX19,U,3)
 S LRSPEM=$S($L(LRSPE):$P(^LAB(61,LRSPE,0),U,1),1:"")
 I 'LRTEST W !,"COMMENT: ",LRVAL G LRMIT
 S LRUNT="",LRNAME=$P(^LAB(60,LRTEST,.1),U,1),LRPC=$P(^(.1),U,3)
 I $L(LRSPE),$D(^LAB(60,LRTEST,1,LRSPE,0)) S @("LRLO="_$S($L($P(^(0),U,2)):$P(^(0),U,2),1:"""""")),@("LRHI="_$S($L($P(^(0),U,3)):$P(^(0),U,3),1:"""""")),LRUNT=$P(^(0),U,7)
WR1 S:'$D(LRCW) LRCW=13 S X=LRVAL
 W !!,LRUDT,?15,LRSPEM,?36,LRNAME,":",?50,@$S(LRPC="":"X",1:LRPC)," "
 W X1,"  ",LRUNT,?67 W:$L(LRLO) LRLO,"-",LRHI
 I $D(IA) W !,IA K IA,IAX,IARNO,IADA
 G LRMIT
WR I $Y>(IOSL-LRCNT) D EQUALS^LRX S LRFULL=1 D ENT^LRAC7,HEAD K ^TMP($J,"K") S LRFULL=0
 S LRCL=21-$L(LRMHN) W !!!?LRCL F I=1:1:8 W "* "
 F I=1:1:$L(LRMHN) W " ",$E(LRMHN,I)
 W " " F I=1:1:8 W " *"
 W !!,"  Date   Time   Specimen",?37,"Test",?50,"Results"
 W ?64,"Ref ranges" D DASH^LRX
 Q
TXT S I=0
 F  S I=$O(^LAC(LRXLR,LRDFN,"MISC",1,1,LRFDT,"TX",I)) Q:'I  W !,^(I,0)
 G MDT
END D EQUALS^LRX
 D LRBOT S LRLO="" K LRSB,LRMISC Q
PRE ;from LRAC3
 Q:$O(^LAC(LRXLR,LRDFN,"MISC",1,0))'>0  S LRX21=^(0)
 S LRMISC=1
 I '$D(LRPG1) S LRPG=$S($L($P(LRX21,U,2))&($G(LRRE)):$P(LRX21,U,2),$D(^LR(LRDFN,"PG",LRMH)):$P(^(LRMH),U,2),1:0)
 S LRMH="MISC"
 S:'$L($P(^LAC(LRXLR,LRDFN,"MISC",1,0),U,2))!'$G(LRRE) $P(^(0),U,2)=LRPG
 G LRMISC
LRCNT S LRCNT=0,I=0
 F  S I=$O(^LAC(LRXLR,LRDFN,LRMH,1,1,LRFDT,1,I)) Q:I<1  S LRCNT=LRCNT+1
 S LRCTN=0 I $D(^LAC(LRXLR,LRDFN,LRMH,1,1,LRFDT,"TX")) S J=0 F  S J=$O(^LAC(LRXLR,LRDFN,LRMH,1,1,LRFDT,"TX",J)) Q:'J  S LRCTN=LRCTN+1
 S LRCNT=LRCNT*2+5+LRCTN
 Q
