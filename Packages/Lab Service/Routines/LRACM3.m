LRACM3 ;SLC/DCM - REPRINT/INITIALIZE PATIENT CUM REPORT ;6/12/89  16:21 ;
 ;;5.2;LAB SERVICE;**174,201**;Sep 27, 1994
EN02 ;
PAT D A^LRACM1 I LRNOT D MSG^LRACM
 D ASK^LRACM1 S LRRE=1 D LOOP,END^LRACM Q
LOOP K DIC D ^LRDPA Q:LRDFN<1  S LRNM=PNM,LRPAT=1 I '$D(^LAC(LRXLR,LRDFN)) W !!,$C(7),"NO DATA IN CUMULATIVE FILE FOR THIS PATIENT!!!"
 D LOC^LRWU
 Q:LREND
 R !!,"Select (1) Re-initialize/Print patient's entire cumulative",!,"       (2) Reprint patient's previous cumulative. 2// ",LRTI:DTIME Q:'$T
 S:LRTI="" LRTI=2 Q:"12"'[LRTI  I LRTI["1" D TIRE Q:Y<0
 K IO("Q") S %ZIS="QM" D ^%ZIS Q:POP
 I $D(IO("Q")) K IO("Q") S ZTRTN="DQ^LRACM3",ZTSAVE("D*")="",ZTSAVE("LR*")="",ZTSAVE("S*")="",ZTSAVE("U")="" D ^%ZTLOAD,^%ZISC K ZTSK,ZTRTN,ZTIO,ZTDESC,ZTSAVE Q
 U IO
DQ D LOAD^LRACM,PT^LRX S LRIDT=0
 I LRTI["1" D A,PAT^LRAC1
 D:LRTI'["1" LRCALE^LRAC2,ENT^LRAC3,MICRO^LRAC1
 W @IOF D ^%ZISC K LRPAT,LREN,LRRE,LRAC D END^LRACM S ZTREQ="@" Q
TIRE W !!?10,$C(7),"** THIS PRINT-OUT MUST BE CHARTED!!! **",! S J=0
 S I=0 F  S I=$O(^LRO(68,"AC",LRDFN,I)) Q:I<1  S J=I
 I J>0 S J=9999999-J W:J>1 !,"STARTING DATE SHOULD AT LEAST GO BACK TO ",$$Y2K^LRX($P(J,".")),".",!,"There is data in the cross-reference back to this date that should be ",!,"on this patient's cumulative.",!
 S %DT="AEQ",%DT("A")="ENTER STARTING DATE FOR REINITIALIZATION: " D ^%DT K %DT Q:Y<0  S LRXDT=9999999-Y
 Q
A ;
 S LRRE=0 K ^LR(LRDFN,"PG"),^LAC(LRXLR,LRDFN),^LAC("LGOT",LRDFN),^LRO(68,"AC",LRDFN),^LRO(68,"MI",LRDFN)
LRIDT S LRIDT=0 F  S LRIDT=$O(^LR(LRDFN,"CH",LRIDT)) Q:LRIDT<1!(LRIDT>LRXDT)  S $P(^(LRIDT,0),U,9)="" D LRSB
 Q:'$D(^LR(LRDFN,"MI"))  S LRIDT=0 F  S LRIDT=$O(^LR(LRDFN,"MI",LRIDT)) Q:LRIDT<1!(LRIDT>LRXDT)  F LRSB=1,5,8,11,16 I $D(^LR(LRDFN,"MI",LRIDT,LRSB)),'$D(^LRO(68,"MI",LRDFN,LRIDT,LRSB)) S ^(LRSB)="" W ":"
 Q
LRSB S LRSB=0 F  S LRSB=$O(^LR(LRDFN,"CH",LRIDT,LRSB)) Q:LRSB<1  I '$D(^LRO(68,"AC",LRDFN,LRIDT,LRSB)) S ^(LRSB)="" W "."
 Q
