YSXRAT2 ; COMPILED XREF FOR FILE #618.418 ; 10/15/04
 ; 
 S DA(1)=DA S DA=0
A1 ;
 I $D(DIKILL) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^YSG("INP",DA(1),5,DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^YSG("INP",DA(1),5,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^YSG("INP",DA(1),"AB",9999999-X,DA)
 G:'$D(DIKLM) A Q:$D(DIKILL)
END G ^YSXRAT3
