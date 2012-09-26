XDRMADD ;SF-IRMFO/IHS/OHPRD/JCM,JLI,REM -  USER CREATED VERIFIED DUPLICATE PAIR ENTRY ;4/6/98  09:24
 ;;7.3;TOOLKIT;**23**;Apr 25, 1995
 ;;
 N XDRFL,XDRCNTR
 S XDRCNTR=0
START ;
 N XDRADFLG
 K DIC
 S (XDRQFLG,XDRADFLG)=0
 I '$D(XDRFL) S DIC("A")="Add entries from which File: " D FILE^XDRDQUE
 G:XDRQFLG END
 S XDRDTYPE=$P(XDRD(0),U,5)
 I XDRDTYPE="" D  ;REM -8/20/96 when XDRDTYPE is null set it to basic.
 .S $P(^VA(15.1,XDRFL,0),U,5)="b",XDRDTYPE="b"
 S XDRGL=^DIC(XDRFL,0,"GL")
 D:XDRCNTR>0  G:XDRQFLG END
 .W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to ADD another pair (Y/N)"
 .D ^DIR K DIR S:$D(DIRUT)!('Y) XDRQFLG=1
 S XDRCNTR=XDRCNTR+1
 D BYPASS G:XDRQFLG END
 D LKUP G:XDRQFLG END
 D CHECK G:XDRQFLG<0 START
 D ^XDRDSCOR S:XDRADFLG XDRDSCOR("PDT%")=0 ;REM -8/23/96 to bypass PDT%
 S XDRD("NOADD")="" D ^XDRDUP
 K XDRDTYPE
 D SCORE
 I XDRMADD("DUPSCORE%")<XDRDSCOR("PDT%") D  G START ; JLI 4/11/96
 . W !!,$C(7),"This pair of patients has a duplicate percentage of only ",XDRMADD("DUPSCORE%"),"% which"
 . W !,"is less than the minimal percentage for potential duplicates (",XDRDSCOR("PDT%"),"%)."
 . W !!?30,"Patients not added!!!",!!
 S XDRDA=+XDRDFLG I XDRDA'>0 D ADD
 G:XDRQFLG START
 D SHOW^XDRDPICK ; D MERGE ; CHANGED TO CURRENT VERIF METHOD, NOT MERGE 4/11/96  JLI
 G START ; ADDED 4/11/96 JLI
END D EOJ
 Q
 ;
LKUP ;Looks up the records to add.
 K XDRCD,XDRCD2
 S DIC=XDRGL,DIC(0)="QEAM"
 S DIC("S")="I '$D(^VA(15,""AFR"",$P(XDRGL,U,2),Y))"
 S DIC("A")="Select "_$P(^DIC(XDRFL,0),U,1)_": "
 D ^DIC K DIC,DA
 I $D(DIRUT)!(Y=-1) S XDRQFLG=1 G LKUPX
 S XDRCD=+Y
LKUP2 S DIC=XDRGL,DIC(0)="QEAM"
 S DIC("S")="I '$D(^VA(15,""AFR"",$P(XDRGL,U,2),Y))"
 S DIC("A")="    Another  "_$P(^DIC(XDRFL,0),U,1)_": "
 D ^DIC K DIC,DA
 G:$D(DIRUT)!(Y=-1) LKUP
 S XDRCD2=+Y
 I XDRCD=XDRCD2 W !!,"Please do not try and merge the same patients together.",!! K XDRCD2 G LKUP2
 S XDRMADD("REC1")=$S(XDRCD<XDRCD2:XDRCD,1:XDRCD2)
 S XDRMADD("REC2")=$S(XDRMADD("REC1")=XDRCD:XDRCD2,1:XDRCD)
 S XDRCD=XDRMADD("REC1"),XDRCD2=XDRMADD("REC2")
 W !!,"You will be adding the following pair of records to the duplicate record file:",!
 W !?5,"RECORD1:  ",$P(@(XDRGL_XDRCD_",0)"),U)
 W !?5,"RECORD2:  ",$P(@(XDRGL_XDRCD2_",0)"),U)
 W !! K DIR S DIR(0)="E" D ^DIR K DIR I $D(DIRUT) S XDRQFLG=1 Q
 W "  Ok, continuing, hold on ...",!
 ;W !!,"Hit return to continue " R XDRMADD("ANS"):DTIME W "  Okay, continuing, hold on ...",!
LKUPX Q
 ;
CHECK ;
 S XDRDFLG=0 F XDRDI="APOT","ANOT","AVDUP" I $D(^VA(15,XDRDI,$P(XDRGL,U,2),XDRCD_U_XDRCD2))!($D(^VA(15,XDRDI,$P(XDRGL,U,2),XDRCD2_U_XDRCD))) S XDRDFLG=-1 I XDRDI="APOT" D
 . I $D(^VA(15,XDRDI,$P(XDRGL,U,2),XDRCD_U_XDRCD2)) S XDRDFLG=$O(^(XDRCD_U_XDRCD2,0)) Q
 . S XDRDFLG=$O(^VA(15,XDRDI,$P(XDRGL,U,2),XDRCD2_U_XDRCD,0))
 I XDRDFLG W !!,"They are already entered in Duplicate Record file.",!!
 K XDRDI
 Q
 ;
SCORE ;
 S XDRMADD("DUPSCORE%")=$S($G(XDRDSCOR("MAX"))=0:0,1:(XDRD("DUPSCORE")/XDRDSCOR("MAX")))
 S XDRMADD("DUPSCORE%")=$J(XDRMADD("DUPSCORE%"),1,2)
 S XDRMADD("DUPSCORE%")=$S(XDRMADD("DUPSCORE%")<0:0,XDRMADD("DUPSCORE%")<1:$E(XDRMADD("DUPSCORE%"),3,4),1:100)
 S XDRDFR=$S(XDRCD<XDRCD2:XDRCD,1:XDRCD2)
 S XDRDTO=$S(XDRDFR=XDRCD:XDRCD2,1:XDRCD)
 S XDRMADD("STATUS")="X"
 Q
 ;
ADD ;
 ;ADD TO DUPLICATE RECORD FILE
 S XDRMAINI="MERGE" D ^XDRMAINI ;LAB/OHPRD ADDED THIS
 S DIC="^VA(15,",DIC(0)="L",X=XDRDFR_";"_$P(XDRGL,U,2),DLAYGO=15
 S XDRMADDX=XDRDTO_";"_$P(XDRGL,U,2)
 S DIC("DR")=".02////^S X=XDRMADDX"_";.03////"_XDRMADD("STATUS")
 ;S DIC("DR")=DIC("DR")_";.04//2" ;REM -10/2/96 this will be asked in XDRRMRG!
 S DIC("DR")=DIC("DR")_";.03///P"_";.06////"_DT_";.09////"_DUZ
 S DIC("DR")=DIC("DR")_";.15////"_XDRDSCOR("MAX")_";.17////"_XDRDSCOR("PDT%")_";.18////"_XDRD("DUPSCORE")_";.19////"_XDRMADD("DUPSCORE%")
 S:$D(XDRDSCOR("VDT%")) DIC("DR")=DIC("DR")_";.16////"_XDRDSCOR("VDT%")
 D
 . N I,X1,X2,X3
 . S X1=X_U_XDRMADDX,X2=XDRMADDX_U_X
 . F I=0:0 S I=$O(^VA(15,"B",X,I)) Q:I'>0  S X3=$P($G(^VA(15,I,0)),U,1,2) I X3=X1!(X3=X2) K X Q
 S Y=-1 I $D(X) D FILE^DICN
 K DIC,DR,X,DLAYGO
 I Y'>0 S XDRQFLG=1 K XDRCD,XDRCD2 G ADDX
 S DIE="^VA(15,",(XDRDA,XDRMPDA,DA)=+Y ; ADDED XDRDA TO LIST 4/11/96 JLI
 F XDRMORD=0:0 S XDRMORD=$O(XDRDTEST(XDRMORD)) Q:'XDRMORD  S DR="2101///"_$P(XDRDTEST(XDRMORD),U,1),DR(2,15.02101)=".02////"_XDRDUP("TEST SCORE",XDRMORD) D ^DIE K DR
ADDX K DIE,DR,DA,XDRMORD,XDRMADDX,XDRDUP("TEST SCORE")
 Q
 ;
MERGE Q  ;
 S XDRMPAIR=XDRDFR_"^"_XDRDTO,XDRM("NOVERIFY")=""
 D EN^XDRMAIN
MERGEX K XDRM
 Q
 ;
BYPASS ;REM -8/20/96 Add record directly into file 15, bypass threshold.
 N X,XDRKEY
 S (X,XDRKEY)=0 F  S X=$O(^VA(200,DUZ,51,"B",X)) Q:X'>0!(XDRKEY)  D
 .I $$GET1^DIQ(19.1,X,.01)="XDRMGR" S XDRKEY=1 Q
 Q:'XDRKEY
 S DIR(0)="Y",DIR("A")="Do you want to bypass the potential duplicate threshold % check (Y/N)"
 S DIR("??")="^W !!,""This will add the pair of records to the Duplicate Record file without checking the potential duplicate threshold %."""
 D ^DIR K DIR S XDRADFLG=Y I $D(DTOUT)!($D(DUOUT)) S XDRQFLG=1 Q
 I 'XDRADFLG W !!,*7,"Potential duplicate threshold % will NOT be bypassed!",!
 I XDRADFLG D
 .W !!,"This will add the pair of records directly into the Duplicate Record file."
 .S DIR(0)="YO",DIR("A")="Are you sure you want to continue",DIR("B")="NO"
 .D ^DIR K DIR S XDRADFLG=Y W ! I $D(DIRUT) S XDRQFLG=1 Q
 .I 'XDRADFLG W *7,!!,"Potential duplicate threshold % will NOT be bypassed!",!
 Q
 ;
EOJ ;
 K XDRMADD,XDRMORD,XDRDFR,XDRDTO,X,Y,XDRCD,XDRCD2,XDRD,XDRFL,XDRGL
 K XDRFL,XDRMPAIR,XDRMPDA,XDRQFLG,XDRDSCOR,XDRDTEST
 Q
