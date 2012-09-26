FBCHACT0 ;AISC/DMK-NON-VA HOSPITAL ACTIVITY CONT ;01JUL01
 ;;3.5;FEE BASIS;**28**;JAN 30, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
ENT S (SCNT,MCNT,PCNT,SDED,MDED,PDED,ASCNT,AMCNT,APCNT,DSCNT,DMCNT,DPCNT,RSCNT,RMCNT,RPCNT,FBDAYS,FBMDAY,FBSDAY,FBPDAY)=0,FBBED=""
 F J="AA","AD","AR" F I=0:0 S I=$O(^TMP("FBCH",$J,J,FBK,I)) Q:I'>0  I $D(^FBAAA("AG",I_";FB7078(")) D 161
 D EN,WRT
 K AMCNT,APCNT,ASCNT,DMCNT,DPCNT,DSCNT,FBADDT,FBCHDT,FBDA,FBDAYS,FBDED,FBFRDT,FBMDAY,FBPDAY,FBSDAY,FBTODT,FBTYPE,I,J,MCNT,PCNT,PDED,Q,QQ,RMCNT,RPCNT,RSCNT,SCNT,SDED,X,Y,MDED Q
161 S FBDA(1)=$O(^FBAAA("AG",I_";FB7078(",0)),FBDA=$O(^FBAAA("AG",I_";FB7078(",FBDA(1),0)) Q:'$D(^FBAAA(FBDA(1),1,FBDA,0))  S FBADDT=$P(^(0),"^",18),FBFRDT=$P(^(0),"^"),FBTODT=$P(^(0),"^",2)
 S FBFRDT=$S(FBCHDT>FBFRDT:FBCHDT,1:FBFRDT),FBTODT=$S(FBTODT="":FBENDDT,FBTODT>FBENDDT:FBENDDT,1:FBTODT)
 I FBADDT="00" S SCNT=SCNT+1
 I FBADDT=10 S MCNT=MCNT+1
 I FBADDT=86 S PCNT=PCNT+1
 I J="AA" S ASCNT=ASCNT+SCNT,AMCNT=AMCNT+MCNT,APCNT=APCNT+PCNT D RESET Q
 I J="AD" S DSCNT=DSCNT+SCNT,DMCNT=DMCNT+MCNT,DPCNT=DPCNT+PCNT D RESET Q
 I J="AR" S RSCNT=RSCNT+SCNT,RMCNT=RMCNT+MCNT,RPCNT=RPCNT+PCNT D RESET Q
 Q
WRT D HED
 W !,"MEDICINE",!,"--------" D HED1
 W ?3,AMCNT,?17,DMCNT-MDED,?32,MDED,?45,RMCNT,?59,FBMDAY,?73,^TMP("FB",$J,FBK,10),!
 W !,"SURGERY",!,"-------" D HED1
 W ?5,ASCNT,?20,DSCNT-SDED,?32,SDED,?45,RSCNT,?59,FBSDAY,?73,^TMP("FB",$J,FBK,"00"),!
 W !,"PSYCHIATRY",!,"----------" D HED1
 W ?5,APCNT,?20,DPCNT-PDED,?32,PDED,?45,RPCNT,?59,FBPDAY,?73,^TMP("FB",$J,FBK,86),!
 Q
HED S Q="=",$P(Q,"=",79)="=",Y=FBCHDT X ^DD("DD") S FBCHDT=Y
 W !,?21,FBHED_" ACTIVITY REPORT",!,?21,"----------------------------------",!,?1,"For the month of: ",FBCHDT,!,Q,! Q
RESET S (MCNT,SCNT,PCNT)=0 Q
DAYS S FBDAYS=0,X1=FBTODT,X2=FBFRDT D D^%DTC S FBDAYS=$S(X<1:1,1:X+1)
 Q
HED1 W !?41,"PATIENTS",?57,"DAYS OF",?70,"DAYS OF",!?1,"ADMISSIONS",?15,"DISCHARGES",?30,"DEATHS",?40,"REMAINING",?58,"CARE",?69,"UNAUTH CARE",! F QQ=1:1:80 W "-"
 W ! Q
EN F I=FBCHDT:0 S I=$O(^FB7078("AD",FBTYPE,I)) Q:I'>0  F J=0:0 S J=$O(^FB7078("AD",FBTYPE,I,J)) Q:J'>0  D VENTYPE^FBCHACT I FBVENTP=FBK I $D(^FB7078(J,0)) S FBADMIT=$P(^(0),"^",4),FBTODT=I D GETBED,CHK
 Q
CHK Q:FBADMIT>FBENDDT  S FBFRDT=$S(FBADMIT<FBCHDT:FBCHDT,1:FBADMIT)
 S FBTODT=$S(FBTODT>FBENDDT:FBENDDT,1:FBTODT)
 D DAYS I FBTODT'=FBENDDT S FBDAYS=FBDAYS-1
 I FBBED="00" S FBSDAY=FBSDAY+FBDAYS I FBDED=2!(FBDED=3) S SDED=SDED+1 K FBDED
 I FBBED=10 S FBMDAY=FBMDAY+FBDAYS I FBDED=2!(FBDED=3) S MDED=MDED+1 K FBDED
 I FBBED=86 S FBPDAY=FBPDAY+FBDAYS I FBDED=2!(FBDED=3) S PDED=PDED+1 K FBDED
 S FBBED="" Q
GETBED S FB(1)=$O(^FBAAA("AG",J_";FB7078(",0)) Q:FB(1)=""  S FB=$O(^FBAAA("AG",J_";FB7078(",FB(1),0)) Q:FB=""  I $D(^FBAAA(FB(1),1,FB,0)) S FBBED=$P(^(0),"^",18),FBDED=$P(^(0),"^",15)
 Q
