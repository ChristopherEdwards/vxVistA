LBRYPG0 ;ISC2/DJM-SERIALS PURGE OPTION ;[ 05/23/97  12:13 PM ]
 ;;2.5;Library;**2**;Mar 11, 1996
CHECK ;
FORWARD S E=0 G:$L(X)>1 FWD S:$D(A(E1+1)) (E0,E1)=E1+1 G FWD1
FWD S X1=+$E(X,2,99) Q:X1'>0!'($D(A(X1)))  Q:$E(X,1)="B"&(X1'<E0)  Q:$E(X,1)="F"&(X1'>E0)  S E0=$S($D(A(X1)):X1,$D(A(E1+1)):E1+1,1:E0) S:X1>0&($D(A(X1))) E1=X1
FWD1 F I=1:1:4 Q:'$D(A(E1+1))  S E1=E1+1
 Q
BACKUP S E=0 G:$L(X)>1 FWD I $D(A(E0-5)) S (E0,E1)=E0-5 G FWD1
BACKUP1 F I=1:1:5 Q:'$D(A(E0-1))  S E0=E0-1
 S E1=E0 G FWD1
ALL K ALL S CNT=$P($G(^LBRY(680,LBRYLOC,7)),U),(QTY,IT)=0
 F  S IT=$O(^LBRY(681,"AC",LBRYLOC,IT)) Q:IT=""  S QTY=QTY+1
 I QTY<CNT S ALL=1
 Q
