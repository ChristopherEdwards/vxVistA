YSXRAJ1 ; COMPILED XREF FOR FILE #615 ; 10/15/04
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^YS(615,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^YS(615,"B",$E(X,1,30),DA)
END G ^YSXRAJ2
