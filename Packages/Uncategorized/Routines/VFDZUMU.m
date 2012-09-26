VFDZUMU ;DSS/SGM - TIED ROUTINE FOR MULTIPLE NAMESPACES;02 Nov 2009 14:53
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;This routine can be used in Intersystems' Cache environment for the
 ;purpose of prompting the user to select a namespace to go to.  Once
 ;in that namespace then invoke the VistA security routine ^ZU.  So,
 ;the user must have an authorized NEW PERSON account in that
 ;namespace.  The program will halt when the user is finished working
 ;in the namespace that they swapped to.
 ;
 Q:$ZV'["Cache"
 N I,T,X,Y,Z,CNT,HOME,NMSP,ZUCHK
 U $I:("":"-B") ;No break
 D INIT
 S NMSP=$$DSP I NMSP="" HALT
 I NMSP="USER" G USER
 G NMSP
 ;
NMSP W # S:NMSP'=HOME X=$ZU(5,NMSP) D ^ZU Q
 ;
USER S X=$ZU(5,"USER") D ^%PMODE U $I:(:"+B+C+R") S $ZT="",$ET="" Q
 ;
 ;-----------------------  private subroutines  -----------------------
DSP() ; display and prompt for namespace
 ; return namespace name or <null>
D W # S Y=$O(T(0," "),-1) F I=1:1:Y-1 Q:'$D(T(0,I))  W T(0,I),!
 W T(0,Y) R X:60 E  D ERR(1) Q ""
 S Y=0,CNT=CNT+1 I X?.E1L.E S X=$$UP(X)
 I X="USER^" Q "USER"
 I X?1.U,$D(T(X)) X ZUCHK Q:Y>0 X S Y=3
 I 'Y,X>0,$D(T(X)) Q T(X)
 D ERR($S(Y=3:3,1:2))
 I CNT=3 HALT
 G D
 ;
ERR(A) ;
 N T W !
 I A=1 W !?3,"Timed out"
 I A=2 W !?3,"'"_X_"' is not a valid choice"
 I  W !?3,"Answer must be a number or the full namespace name"
 I A=3 W !?3,"Valid security routine not found in "_X
 W "  " R *Y:10
 Q
 ;
INIT ; initialize certain variables
 ;;S Z=$ZU(5,X),Y=$L(+1^ZU),Z=$ZU(5,HOME)
 N I,X,Y,Z
 S U="^",HOME=$ZU(5)
 S CNT=0,ZUCHK=$P($T(INIT+1),";",3)
 D TSET
 Q
 ;
LIST(NM) ; Get Cache namespaces
 ; return NM=total number of namespace
 ;        NM(namespace)=""
 N I,N,X,Y,Z,VER
 S VER=$$VERSION
 S N=$ZU(90,0),NM=N Q:'N
 I VER'>5 F I=1:1:N S X=$ZU(90,2,0,I),NM(X)=""
 E  D List^%SYS.NAMESPACE(.NM)
 D LISTEX(.NM) I NM=0 HALT
 Q
 ;
LISTEX(NM) ; exclude certain namespaces from the list
 ;;%SYS^DOCBOOK^SAMPLES^USER
 N I,X,Y
 S X=$P($T(LISTEX+1),";",3)
 F I=1:1 S Y=$P(X,U,I) Q:Y=""  K NM(Y)
 S X=0 F  S X=$O(NM(X)) Q:X=""  I $E(X,1,5)="CACHE" K NM(X)
 S (I,X)=0 F  S X=$O(NM(X)) Q:X=""  S I=I+1
 S NM=I
 Q
 ;
UP(X) Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;
VERSION() ; return cache version number only
 Q $TR($P($P($ZV,")",2),"(")," ")
 ;
TSET ; create the T() array
 N C,I,J,K,L,R,X,Y,Z,SP
 K T S $P(SP," ",31)=""
 S X="  Current Namespace: "_HOME_"  "
 S I=80-$L(X)\2,$P(Y,"-",I+1)=""
 S T=0 D TA(Y_X_Y)
 ; get header descriptions first
 S Z=0 F I=1:1 S X=$P($T(T+I),";",3) Q:X=""  D  Q:Z=2
 .I X["*****" S Z=Z+1 D TA("") Q
 .D TA("   "_X)
 .Q
 S X="   You need ACCESS/VERIFY codes for the account that you select"
 D TA(X) S Y="",$P(Y,"-",81)="" D TA(Y),TA("")
 ; now get the actual list of namespaces into an array
 K Z I X'="" F  S I=I+1,X=$P($T(T+I),";",3) Q:X=""  D
 .F J=1:1:$L(X,U) S Y=$P(X,U,J) S:Y'="" Z(Y)=""
 .Q
 I '$D(Z) K T Q
 S (L,X)=0
 F K=1:1 S X=$O(Z(X)) Q:X=""  S T(K)=X,T(X)=""
 S K=K-1,L=K\5+(K#5>0) ; K=# namespaces  L=# of 5-column rows
 K Z S R=0 F I=1:1:K D
 .S R=R+1 S:R>L R=1 I '$D(Z(R)) S Z(R)="   "
 .S Z(R)=Z(R)_$J(I,2)_". "_$E(T(I)_SP,1,9)
 .Q
 F I=1:1:L D TA(Z(I))
 D TA(""),TA("   Select Namespace: ")
 Q
 ;
TA(M) S T=T+1,T(0,T)=M Q
 ;
T ; list of namespace and description
 ;;***** place descriptions below this line *****
 ;;NMSPA - brief description for the purpose of this account
 ;;NMSPB - bried description for the purpose of this account
 ;;***** place the name of the namespaces delimited by ^ *****
 ;;NMSPA^NMSPB
 ;;
