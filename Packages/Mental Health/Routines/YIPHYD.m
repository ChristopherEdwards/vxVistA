YIPHYD ;SLC/DKG-INTERVIEW PHYSICAL PROBLEMS ; 10/18/88  13:41 ;
 ;;5.01;MENTAL HEALTH;;Dec 30, 1994
 S X=^YTD(601.2,YSDFN,1,YSET,1,YSED,1) D HDR^YIHIST W !!?18,^YTT(601,YSTEST,"G",1,1,1,0),!!!?22,^YTT(601,YSTEST,"G",2,1,1,0),!
 S K=2,YSLC=$Y F I=1,4,6,7,9,10,13,16,19,22,24,28,33,34,37 S K=K+1 W:$E(X,I)="Y" !,^YTT(601,YSTEST,"G",K,1,1,0)
 W:YSLC=$Y !,"NONE INDICATED"
 I IOST?1"C-".E D WAIT^YSUTL G:YSLFT END
 W:IOST?1"P".E !!! W ?22,^YTT(601,YSTEST,"G",18,1,1,0),!
 S YSSY="21^50^80^111^171^140^150^201^230^252^291^311^351^381"
 S K=18 F YSKK=1:1:14 S K=K+1 D YSSYM
END ;
 W ! K A,B,I,K,YSKK,YSLC,YSSY,X Q
YSSYM ;
 S A=$P(YSSY,U,YSKK),B=A#10,A=A\10 G:A=15 B3
 Q:$E(X,A)'="Y"  W !,^YTT(601,YSTEST,"G",K,1,1,0) Q:B=0  G B1:B=1,B2
B2 ;
 S A=+$E(X,26) W !,^YTT(601,YSTEST,"G",43+A,1,1,0) S A=26
B1 ;
 S A=+$E(X,A+1) W !,^YTT(601,YSTEST,"G",33+A,1,1,0) Q
B3 ;
 I $E(X,14)="N",$E(X,17)="N" W !,^YTT(601,YSTEST,"G",K,1,1,0)
 W !,^YTT(601,YSTEST,"G",$E(X,15)+36,1,1,0) Q
