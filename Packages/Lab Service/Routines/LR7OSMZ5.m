LR7OSMZ5 ;slc/dcm - Silent Micro rpt - BACTERIA, ANTIBIOTICS ;8/11/97
 ;;5.2;LAB SERVICE;**121,187,244**;Sep 27, 1994
BACT ;from LR7OSMZ2
 Q:+$O(^LR(LRDFN,"MI",LRIDT,3,0))<1
 S LRFMT=$P(^LAB(69.9,1,0),U,11),LRFMT=$S(LRFMT="":"I",1:LRFMT)
 K LRRES,LRINT
 N X,LRBUG,LRABCNT,LRBN,LRAO,LRACNT
 S (LRBUG,LRABCNT,LRBN,LRAO,LRACNT)=0
 F A=1:1 S LRBUG=+$O(^LR(LRDFN,"MI",LRIDT,3,LRBUG)) Q:LRBUG<1  S:+$O(^(LRBUG,2))'["2." A=A-1 I +$O(^(2))["2." D CHECK
 F  S LRBN=+$O(LRRES(LRBN)) Q:LRBN<1  S LRABCNT=LRABCNT+1
 Q:'LRABCNT!($G(LREND))
 D LINE^LR7OSUM4,LINE^LR7OSUM4
 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"ANTIBIOTIC SUSCEPTIBILITY TEST RESULTS:")
 D BUGHDR
 S LRCOMTAB=$S(LRFMT="B":A*13+17,1:A*5+17)
 F  S LRAO=$O(^LAB(62.06,"AO",LRAO)) Q:LRAO<.001!($G(LREND))  S B=$O(^LAB(62.06,"AO",LRAO,0)) I B>0,$D(^LAB(62.06,B,0)) D AB
 D LINE^LR7OSUM4
 K LR1PASS,LRRES,LRINT
 Q
CHECK ;
 N LRBN,LR1PASS,LRFLAG,B,B1,B2,B3
 S LRFLAG=0,LRBN=2
 F  S LRBN=+$O(^LR(LRDFN,"MI",LRIDT,3,LRBUG,LRBN)) Q:LRBN'["2."!($G(LREND))  S B=^(LRBN),B1=$P(B,U),B2=$P(B,U,2) I $L(B1),$D(^LAB(62.06,"AI",LRBN,B1)) S X=^(B1) D FIRST
 S LRBN=2
 F  S LRBN=+$O(LR1PASS(LRBN)) Q:LRBN<1!($G(LREND))  S B=LR1PASS(LRBN),B1=$P(B,U),B2=$P(B,U,2),B3=$P(B,U,3) D LAB
 Q
FIRST ;
 S B2=$S(B2]"":B2,1:X),B3=$P(B,U,3)
 S:$E(B2)'="R"&("A"[B3) LRFLAG=1
 S LR1PASS(LRBN)=B1_U_B2_U_B3,^LR(LRDFN,"MI",LRIDT,3,LRBUG,LRBN)=LR1PASS(LRBN)
 Q
LAB ;
 I $D(^XUSEC("LRLAB",DUZ)),'$D(LRWRDVEW) S $P(LRRES(LRBN),U,A)=$S(B3="N"!(B3="R"&LRFLAG):B1_"*",1:B1),$P(LRINT(LRBN),U,A)=$S(B3="N"!(B3="R"&LRFLAG):B2_"*",1:B2) Q
 I B3=""!(B3="A")!(B3="R"&'LRFLAG) S $P(LRRES(LRBN),U,A)=B1,$P(LRINT(LRBN),U,A)=B2
 Q
AB ;
 Q:$G(LREND)
 S X=^LAB(62.06,B,0),J=$P(X,U,2)
 I $D(LRINT(J)),LRINT(J)'?."^" D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,$E($P(X,U),1,14)) S LRDCOM=$P(X,U,3),LRACNT=LRACNT+1 D SIR
 Q
BUGHDR ;
 S LRBUG=0
 F A=0:1 S LRBUG=+$O(^LR(LRDFN,"MI",LRIDT,3,LRBUG)) Q:LRBUG<1!($G(LREND))  S LRORG=$P(^(LRBUG,0),U),LRORG=$P(^LAB(61.2,LRORG,0),U) S:+$O(^LR(LRDFN,"MI",LRIDT,3,LRBUG,2))'["2." A=A-1 I +$O(^(2))["2." D ORG
 I LRFMT="B" D LN^LR7OSMZ1 S ^TMP("LRC",$J,GCNT,0)="" F J=1:1:A S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(J-1*13+15,CCNT,":")
 D LN^LR7OSMZ1
 S ^TMP("LRC",$J,GCNT,0)=""
 F J=1:1:A D
 . I LRFMT'="B" S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(J*5+10,CCNT,":")
 . I LRFMT="B" S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(J-1*13+15,CCNT,"SUSC  INTP")
 Q
ORG ;
 D LINE^LR7OSUM4
 S ^TMP("LRC",$J,GCNT,0)=""
 F J=1:1:A S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS($S(LRFMT="B":J-1*13+15,1:J*5+10),CCNT,":") ;I A>0 BEFORE FOR LOOP
 S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS($S(LRFMT="B":A*13+15,1:A*5+15),CCNT,$S(LR2ORMOR:LRBUG_". ",1:"")_LRORG)
 Q
SIR ;
 F II=1:1:10 D:$P(LRINT(J),U,II,10)="" DCOM Q:$P(LRINT(J),U,II,10)=""  S:LRFMT'="B" ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(II*5+10,CCNT,$S(LRFMT="I":$P(LRINT(J),U,II),1:$P(LRRES(J),U,II))) I LRFMT="B" D SIR1
 Q
DCOM ;
 S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(LRCOMTAB,CCNT,LRDCOM) I $D(LRDCOM(J)) S K=0,A=0 D
 . F  S A=+$O(LRDCOM(J,A)) Q:A<1  D:'('K&(LRDCOM="")) LINE^LR7OSUM4 S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(LRCOMTAB,CCNT,LRDCOM(J,A)) S K=1
 Q
SIR1 ;
 S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(II-1*13+15,CCNT,$S($D(LRRES(J)):$P(LRRES(J),U,II),1:""))_$$S^LR7OS(II-1*13+21,CCNT,$P(LRINT(J),U,II)_"  ")
 Q
 D LINE^LR7OSUM4
 S X="",$P(X,"-",GIOM)="",^TMP("LRC",$J,GCNT,0)=X
 D LINE^LR7OSUM4
 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"PATIENT'S IDENTIFICATION")_$$S^LR7OS(60,CCNT,"MICROBIOLOGY REPORT")
 D LINE^LR7OSUM4
 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"ACCESSION: "_LRACC)_$$S^LR7OS(25,CCNT,"TAKEN:"_LRTK)_$$S^LR7OS(52,CCNT,"RECEIVED:"_LRRC)
 Q
