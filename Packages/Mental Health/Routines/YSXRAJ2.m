YSXRAJ2 ; COMPILED XREF FOR FILE #615.01 ; 10/15/04
 ; 
 S DA(1)=DA S DA=0
A1 ;
 I $D(DIKILL) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^YS(615,DA(1),"PL",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^YS(615,DA(1),"PL",DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^YS(615,"C",$E(X,1,30),DA(1),DA)
 G:'$D(DIKLM) A Q:$D(DIKILL)
END Q
