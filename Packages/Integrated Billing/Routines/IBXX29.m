IBXX29 ; COMPILED XREF FOR FILE #399.077 ; 04/29/09
 ; 
 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^DGCR(399,DA(1),"TXC",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^DGCR(399,DA(1),"TXC",DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^DGCR(399,DA(1),"TXC","B",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,1)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGCR(399,D0,"TXC",D1,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399.077,.01,1,2,1.4)
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^IBXX30
