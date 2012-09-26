RMPRM ;PHX/DWL-INFORMATION MESSAGES / PURCHASING FUNCTIONS ; 5/22/00 4:16pm
 ;;3.0;PROSTHETICS;**3,49**;Feb 09, 1996
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;THE FIRST THREE LINES DISPLAY MESSAGES FOR THE USER FROM PURCHASING
M1 W !,$C(7),$C(7),"This Transaction has been Closed!" Q
M2 ;ENTRY POINT TO DISPLAY Canceled TRANSACTION MESSAGE
 W !,$C(7),$C(7),"This Transaction has already been Canceled!" Q
M3 W !,$C(7),$C(7),"An X in the Item column is an error and must be reported to your Application Coordinator!" Q
 ;RETURNS PSC AMT IN RMPRAMT FROM SITE PARAMATER FILE
EN2520 ;ENTRY POINT FOR 2520 FORM TO SELECT PSC ITEM CATEGORY
 W !,"Enter 'W' for WHEELCHAIR, 'O' for BRACE, 'B' for BLIND AIDS, 'A' for ART. LIMBS"
 R !,"Select PSC ITEM CATEGORY: ",RMPRPSC:DTIME G:('$T)!(RMPRPSC["^") EXIT G:(RMPRPSC="") HPSC G:(RMPRPSC?."W")!(RMPRPSC?."B")!(RMPRPSC?."A")!(RMPRPSC?."O") PSCAMT G HPSC
PSCAMT ;CHECKS FOR DOLLAR LIMITATIONS IN SITE PARAMETER FILE-
 ;FOR PSC PURCHASE BY CATEGORY
 S RMPRAMT=$S(RMPRPSC["B":$P(^RMPR(669.9,RMPRSITE,2),U,10),RMPRPSC["O":$P(^RMPR(669.9,RMPRSITE,2),U,9),RMPRPSC["W":$P(^RMPR(669.9,RMPRSITE,2),U,8),RMPRPSC["A":$P(^RMPR(669.9,RMPRSITE,2),U,7),1:0) I $D(RMPRF),RMPRF="E" Q
 W !,"You will not be able to exceed an item repair cost of more than $",$J(RMPRAMT,0,2),"."
 Q
HPSC W !,$C(7),$C(7),"??",!,"CHOOSE FROM:",!?5,"W",?15,"WHEELCHAIR",!?5,"O",?15,"BRACE",!?5,"B",?15,"BLIND AID",!?5,"A",?15,"ARTIFICIAL LIMB" G EN2520
EXIT K RMPRPSC,RMPRF Q
POST2 ;1358
 S (R1,RMPR("AMT"),AMT)=0
 I $D(^RMPR(664,RMPRA,2)),$P(^(2),U,6) S DCT=$P(^(2),U,6),DCT=DCT/100 F RI=0:0 S RI=$O(^RMPR(664,RMPRA,1,RI)) Q:RI'>0  D
 .S RMX=^RMPR(664,RMPRA,1,RI,0) S $P(^(0),U,7)=$S($P(RMX,U,7):$P(RMX,U,7)-$J($P(RMX,U,7)*DCT,0,2),1:$P(RMX,U,3)-$J($P(RMX,U,3)*DCT,0,2))
 S RMPRCC=""
 F  S R1=$O(^RMPR(664,RMPRA,1,R1)) Q:R1'>0  D
 .S R2=^RMPR(664,RMPRA,1,R1,0)
 .;remarks in RMPRCC from all items at this point
 .S RMPRCC=$S($P(^RMPR(664,RMPRA,1,R1,0),U,8)'="":RMPRCC_" "_$P(^RMPR(664,RMPRA,1,R1,0),U,8),1:"")
 .I $P(R2,U,7)'="" S AMT=$P(R2,U,7)
 .E  S AMT=$P(R2,U,3)
 .;S AMT=$S($P(R2,U,7):$P(R2,U,7),1:$P(R2,U,3))
 .S RMPR("AMT")=RMPR("AMT")+$J((AMT*$P(R2,U,4)),0,2)
 .I '$D(RMPRCONT),$P(^(0),U,14)'="" S RMPRCONT=$P(^(0),U,14)
 S RMPRTO=RMPR("AMT") D CHECK^RMPRCT
 I '$D(RMPRTO) G EXIT^RMPRE21
 D NOW^%DTC S RMPR("DDT")=%
 S $P(^RMPR(664,RMPRA,0),U,8)=RMPR("DDT")
 S B2=^RMPR(664,RMPRA,0)
 K DIC S DIC=424,DIC(0)="MZ",X=$P(B2,U,7) D ^DIC
 S RMPR("DRN")=+Y
 S B2=^RMPR(664,RMPRA,0)
 S RMPRSH=$S($P(B2,U,11)'="":+$P(B2,U,11),$P(B2,U,10):+$P(B2,U,10),1:"")
 S DIE="^RMPR(664,",DA=RMPRA,DR="8.1" D ^DIE
 ;close-out remarks added to item remarks, stored as one comment
 S RMPRCC=RMPRCC_" "_$P($G(^RMPR(664,RMPRA,2)),U,3)
 ;strip all leading spaces in remarks before calling IFCAP
 N STOP,CC
 S STOP="",CC=""
 F CC=0:1:$L(RMPRCC) D  Q:STOP
 .I $E(RMPRCC,1,1)'=" " S STOP=1
 .I $E(RMPRCC,1,1)=" " S RMPRCC=$E(RMPRCC,2,$L(RMPRCC))
 I RMPRF=10 K DIE S DIE="^RMPR(660,",DA=RMPR660,DR=9 I $D(RMPRSR) S RO=0 I $O(RMPRSR(RO)) S RO=$O(RMPRSR(RO)) D
 .S DR="9//^S X=RMPRSR(RO)"
 .D ^DIE S RMPRSER=$P(^RMPR(660,RMPR660,0),U,11)
 D NOW^%DTC
 S PRCSX=RMPR("DRN")_U_%_U_$J(RMPR("AMT")+RMPRSH,0,2)_U_RMPRCC_U_1
 D ^PRCS58CC
 K RMPRCC
 I +Y'>0 S $P(^RMPR(664,RMPRA,0),U,8)="",$P(^(0),U,11)="" W !,$C(7),$C(7),"Transaction NOT Closed-out, IFCAP Failed to Post for the Following Reason.",!,$P(Y,U,2)
 I  S R1=0 G EXIT^RMPRE21
 S RMPRWO=$P(^RMPR(664,RMPRA,0),U,15)
 I RMPRWO,$D(^RMPR(664.2,+RMPRWO,0)) S DA(1)=RMPRWO F DA=0:0 S DA=$O(^RMPR(664.2,RMPRWO,1,"AC",RMPRA,DA)) Q:DA'>0  S DIK="^RMPR(664.2,"_RMPRWO_",1,",DA(1)=RMPRWO D ^DIK
 G POST1^RMPRE21
