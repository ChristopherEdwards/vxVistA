DGRPX71 ; ;05/20/09
 S X=DE(11),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(11),DIC=DIE
 X ^DD(2,.304,1,2,2.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.3)):^(.3),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X="" S DIH=$G(^DPT(DIV(0),.3)),DIV=X S $P(^(.3),U,13)=DIV,DIH=2,DIG=.3013 D ^DICR
