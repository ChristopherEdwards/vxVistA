FHSP11 ; HISC/NCA,RTK - Print Standing Orders Labels ;2/26/96  09:59
 ;;5.5;DIETETICS;**5,8**;Jan 28, 2005;Build 28
 ;patch #5 - added outpatient SOs.
 K ^TMP($J,"NAME") F NX=0:0 S NX=$O(^FH(118.3,NX)) Q:NX<1  S Y=^(NX,0),N1=$P(Y,"^",1) I '$D(^FH(118.3,NX,"I")) S ^TMP($J,"NAME",NX)=$P(Y,"^",1)
 D P1
 Q
P1 S DTP=DT D DTP^FH S DTE=DTP_" "_$S(MEAL="B":"BREAK",MEAL="N":"NOON",1:"EVEN"),S1=$S(LAB=1:6,1:9),S2=LAB=2*5+33
 F SP=0:0 S SP=$O(^TMP($J,"SOL",SP)) Q:SP<1  D P2
 Q
P2 S WRD="" F  S WRD=$O(^TMP($J,"SOL",SP,WRD)) Q:WRD=""  D P3
 Q
P3 F FHDFN=0:0 S FHDFN=$O(^TMP($J,"SOL",SP,WRD,FHDFN)) Q:FHDFN<1  D PID^FHDPA,P4
 Q
P4 F FHL=0:0 S FHL=$O(^TMP($J,"SOL",SP,WRD,FHDFN,FHL)) Q:FHL<1  D P5
 Q
P5 S Y=^(FHL)
 S IS=$P(Y,"^",4),FHORD=$P(Y,"^",1) Q:'FHORD  S M1=$P(Y,"^",2) Q:M1'[MEAL  S Q=$P(Y,"^",3) S:'Q Q=1
 D PATNAME^FHOMUTL I FHPTNM="" Q
 S ALG="" D ALG^FHCLN
 Q:$P($G(^FH(118.3,+FHORD,0)),"^",2)'="Y"
 S NAM=FHPTNM
 I LAB>2 D LL Q
 W !,$E(NAM,1,S2-$L(WRD)),?(S2+2-$L(WRD)),$E(WRD,3,99),!?$S(LAB=1:3,1:0),FHBID,$S(ALG="":"",1:" *ALG") W:IS'="" ?(S2-22),"*NURSE" W ?(S2-15),DTE S LN=2 I LAB=2 W !! S LN=4
 W !,$J(Q,2)," ",$S($D(^TMP($J,"NAME",FHORD)):$P(^TMP($J,"NAME",FHORD),"^",1),$D(^FH(118.3,+FHORD,0)):$P(^(0),"^",1),1:"") S LN=LN+1
 I LN<S1 F L=LN+1:1:S1 W !
 Q
LL ;
 S FHCOL=$S(LAB=3:3,1:2)
 I LABSTART>1 F FHLABST=1:1:(LABSTART-1)*FHCOL D  S LABSTART=1
 .I LAB=3 S (PCL1,PCL2,PCL3,PCL4,PCL5,PCL6)="" D LL3^FHLABEL
 .I LAB=4 S (PCL1,PCL2,PCL3,PCL4,PCL5,PCL6,PCL7,PCL8)="" D LL4^FHLABEL
 .Q
 S FHTAB=$S(LAB=3:24,1:37)
 S WRD1=$E(WRD,3,99)
 S NAM=$E(NAM,1,FHTAB-$L(WRD1)),BIDIS=BID_$S(ALG="":"",1:" *ALG")
 I IS="N" S BIDIS=BIDIS_" *NURSE"
 S LNA=NAM_$J(WRD1,FHTAB+1-$L(NAM)),LNB=BIDIS_$J(DTE,FHTAB+1-$L(BIDIS))
 S LNC=$J(Q,2)_" "_$P($G(^FH(118.3,+FHORD,0)),U,1)
 I LAB=3 S (PCL1,PCL4,PCL6)="",PCL2=LNA,PCL3=LNB,PCL5=LNC
 I LAB=4 S (PCL1,PCL2,PCL5,PCL7,PCL8)="",PCL3=LNA,PCL4=LNB,PCL6=LNC
 D:LAB=3 LL3^FHLABEL D:LAB=4 LL4^FHLABEL
 Q
