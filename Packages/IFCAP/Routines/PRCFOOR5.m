PRCFOOR5 ;SF-ISC/KSS,AKS-CALCULATE FOR 850 RECONCILIATION REPORT ; 11/24/93  2:21 PM
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;PRCFCT,PRCFAT,PRCFOT MUST BE SET IN MENU ACTION, AND KILLED IN EXIT.
 S (PRCFS1,PRCFS2,PRCFO1,PRCFO2,PRCFA1,PRCFA2,PRCFU1,PRCFU2)=0
 S PRCFCT=PRCFCT+1,PRCFCS=PRCFCS+1
 I $D(^PRC(442,D0,0)) S PRCFX=^(0),PRCFS1=$P(PRCFX,U,6),PRCFO1=$P(PRCFX,U,7),PRCFS2=$P(PRCFX,U,8),PRCFO2=$P(PRCFX,U,9),PRCFOT=PRCFOT+PRCFO1+PRCFO2,PRCFOS=PRCFOS+PRCFO1+PRCFO2
 F PRCFJ=0:0 S PRCFJ=$O(^PRC(442,D0,11,PRCFJ)) Q:PRCFJ'>0  I $D(^(PRCFJ,0)) D A
 I PRCFS1 S PRCFU1=PRCFO1-PRCFA1 W ?64,+PRCFS1,?71,$J(PRCFO1,12,2),?85,$J(PRCFA1,12,2),?100,$J(PRCFU1,12,2) S PRCFAT=PRCFAT+PRCFA1,PRCFAS=PRCFAS+PRCFA1
 I PRCFS2 S PRCFU2=PRCFO2-PRCFA2 W !,?64,+PRCFS2,?71,$J(PRCFO2,12,2),?85,$J(PRCFA2,12,2),?100,$J(PRCFU2,12,2) S PRCFAT=PRCFAT+PRCFA2,PRCFAS=PRCFAS+PRCFA2
END K PRCFA,PRCFJ,PRCFS,PRCFX,PRCFS1,PRCFS2,PRCFO1,PRCFO2,PRCFA1,PRCFA2,PRCFU1,PRCFU2 Q
A I $P(^PRC(442,D0,11,PRCFJ,0),U,2) S PRCFS=$P(^(0),U,2),PRCFA=$P(^(0),U,3) S:PRCFS=PRCFS1 PRCFA1=PRCFA1+PRCFA S:PRCFS=PRCFS2 PRCFA2=PRCFA2+PRCFA
 I $P(^PRC(442,D0,11,PRCFJ,0),U,4) S PRCFS=$P(^(0),U,4),PRCFA=$P(^(0),U,5) S:PRCFS=PRCFS1 PRCFA1=PRCFA1+PRCFA S:PRCFS=PRCFS2 PRCFA2=PRCFA2+PRCFA
 Q
B S PRCFB=1 D SUB W !!,?14,"TOTAL NUMBER RECORDS    ",PRCFCT,?58,"TOTALS  $",?71,$J(PRCFOT,12,2),?85,$J(PRCFAT,12,2),?100,$J(PRCFOT-PRCFAT,12,2)
 K PRCFAP,PRCFCAP,PRCFB,PRCFAS,PRCFOS,PRCFUS,PRCFCS,PRCFAT,PRCFCT,PRCFOT Q
SUB ;I 'PRCFCT W !!,"850 UNDELIVERED ORDERS RECONCILIATION FOR STATION "_PRCFSITE_" FROM "_PRCFBEGX_" TO "_PRCFENDX,!!
 S PRCFUS=PRCFOS-PRCFAS W ?71,"------------",?85,"------------",?100,"------------",!,?20,"NUMBER RECORDS    ",PRCFCS,?55,"SUBTOTALS  $",?71,$J(PRCFOS,12,2),?85,$J(PRCFAS,12,2),?100,$J(PRCFUS,12,2)
 ;W:'$D(PRCFB) !!,?11,"APPROPRIATION: ",PRCFCAP
 S (PRCFCS,PRCFOS,PRCFAS)=0 K PRCOSTAT W !
 Q
C S (PRCFA1,PRCFA2,PRCFU1,PRCFU2)=0
 F PRCFJ=0:0 S PRCFJ=$O(^PRC(442,D0,11,PRCFJ)) Q:PRCFJ'>0  I $D(^(PRCFJ,0)) D
 . I $P(^PRC(442,D0,11,PRCFJ,0),U,2) S PRCFS=$P(^(0),U,2),PRCFA=$P(^(0),U,3) S:PRCFS=PRCFS1 PRCFA1=PRCFA1+PRCFA S:PRCFS=PRCFS2 PRCFA2=PRCFA2+PRCFA
 . I $P(^PRC(442,D0,11,PRCFJ,0),U,4) S PRCFS=$P(^(0),U,4),PRCFA=$P(^(0),U,5) S:PRCFS=PRCFS1 PRCFA1=PRCFA1+PRCFA S:PRCFS=PRCFS2 PRCFA2=PRCFA2+PRCFA
 . Q
