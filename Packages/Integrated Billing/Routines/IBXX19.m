IBXX19 ; COMPILED XREF FOR FILE #399.0222 ; 04/29/09
 ; 
 S DA(1)=DA S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^DGCR(399,DA(1),"PRV",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^DGCR(399,DA(1),"PRV",DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^DGCR(399,DA(1),"PRV","B",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,1)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(0)=X S X=Y(0),X=X S X=X'=1 I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"PRV",D1,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(399.0222,.01,1,2,1.4)
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^DGCR(399,DA(1),"PRV","C",$E($$EXTERNAL^DILFD(399.0222,.01,,X),1,30),DA)=""
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^DGCR(399,DA(1),"PRV","C",$$LOW^XLFSTR($E($$EXTERNAL^DILFD(399.0222,.01,,X),1,30)),DA)=""
 S DIKZ(0)=$G(^DGCR(399,DA(1),"PRV",DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399.0222,.02,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"PRV",D1,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(399.0222,.02,1,1,1.4)
 S X=$P(DIKZ(0),U,2)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399.0222,.02,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"PRV",D1,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X=DIV S X=$$EXTCR^IBCEU5(X) X ^DD(399.0222,.02,1,2,1.4)
 S X=$P(DIKZ(0),U,2)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399.0222,.02,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"PRV",D1,0)):^(0),1:"") S X=$P(Y(1),U,8),X=X S DIU=X K Y S X=DIV S X=$$SPEC^IBCEU(X,$P($G(^DGCR(399,D0,"U")),U)) X ^DD(399.0222,.02,1,3,1.4)
 S X=$P(DIKZ(0),U,2)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGCR(399,D0,"PRV",D1,0)):^(0),1:"") S X=$P(Y(1),U,15),X=X S DIU=X K Y S X=DIV S X=$P($$GETTAX^IBCEF73A(X),U,2) X ^DD(399.0222,.02,1,7,1.4)
 S DIKZ(0)=$G(^DGCR(399,DA(1),"PRV",DA,0))
 S X=$P(DIKZ(0),U,5)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(0)=X S X=Y(0)="SLF000" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"PRV",D1,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399.0222,.05,1,1,1.4)
 S X=$P(DIKZ(0),U,5)
 I X'="" D ATTREND^IBCU1(DA(1),DA,.05)
 S DIKZ(0)=$G(^DGCR(399,DA(1),"PRV",DA,0))
 S X=$P(DIKZ(0),U,6)
 I X'="" D ATTREND^IBCU1(DA(1),DA,.06)
 S X=$P(DIKZ(0),U,7)
 I X'="" D ATTREND^IBCU1(DA(1),DA,.07)
 S X=$P(DIKZ(0),U,12)
 I X'="" D ATTREND^IBCU1(DA(1),DA,.12)
 S X=$P(DIKZ(0),U,13)
 I X'="" D ATTREND^IBCU1(DA(1),DA,.13)
 S X=$P(DIKZ(0),U,14)
 I X'="" D ATTREND^IBCU1(DA(1),DA,.14)
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^IBXX20