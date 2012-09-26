LRAPS3 ;SLC/DCM - AP PATIENT SCREEN DISPLAY FOR OE/RR ;12/10/90  12:21
 ;;5.2;LAB SERVICE;**242**;Sep 27, 1994
OERR ;ENTRY POINT FOR OE/RR PATIENT LISTS
 S LRDFN=$$LRDFN^LR7OR1(DFN) I 'LRDFN W !,"No Lab Data for: "_$P(^DPT(DFN,0),"^") Q
 S LRDPF="2^DPT(" I '$D(^LR(LRDFN,0)) W !,"No Lab Data for: "_$P(^DPT(DFN,0),"^") Q
 S LRQ=1 D INI^LRBLPD1
GETP S LRA("A")=""
 I '$D(^LR(LRDFN,"CY")),'$D(^("SP")),'$D(^("EM")),'$D(^("AU")) W $C(7),!!,"No tissue pathology results for this patient.",!! Q
 G:'$D(^LR(LRDFN,"SP"))&('$D(^("CY")))&('$D(^("EM"))) AU
 D HDR,S^LRAPS1 Q:LRA("A")]""
AU I $D(^LR(LRDFN,"AU")),+^("AU") D ^LRAPS2 K LRAU
 Q
HDR W @IOF,$E(LRP,1,30),?31,SSN,?43,SEX,?45,"DOB: ",DOB,?63,"LOC: ",$E(LRLLOC,1,12) Q
SET S LR("Q")=0,LRS(5)=1 D L^LRU,EN^LRUA S LRDPAF=1
 Q
CLEAN ;
 K AGE,B,DFN,DOB,E,H,I,LR,LRA,LRADM,LRADX,LRAU,LRAWRD,LRDFN,LRDPAF,LRDPF,LRFNAM,LRH,LRI,LRMD,LRP,LRPF,LRPFN,LRS,LRSVC,M,N,O,P,S,SEX,SSN,W,X,Y
 Q
