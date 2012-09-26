XTVGC1 ;ISC-SF/JLI - RECORD GLOBAL NODES FOR PACKAGE BEFORE MODIFICATION ;12/16/93  14:06 ; 01/16/89
 ;;7.3;TOOLKIT;;Apr 25, 1995
 W !!,"Record Current Global Nodes for Package for Future Comparison",!!
ASK K DIC S DIC=8991.2,DIC(0)="AEQLM",DLAYGO=8991.2 D ^DIC Q:Y'>0  S XTVPT=+Y
 S %DT("A")="Date current status is to be recorded as: ",%DT("B")="T",%DT="AEQXP" D ^%DT G:Y'>0 ASK S XTVDT=Y
ASK1 R !,"Current Version Number (optional): ",X:DTIME Q:'$T!(X[U)  S XTVVN=X I X'="",X'>0 W !!,$C(7),"Enter a version number (beginning with a number at least) or RETURN",! G ASK1
 S ZTRTN="DQ^XTVGC1",ZTDESC="Package Globals Record",ZTIO="",ZTSAVE("XTVPT")="",ZTSAVE("XTVDT")="",ZTSAVE("XTVVN")="" D ^%ZTLOAD
 K DIC,XTVPT,XTVDT,XTVVN,%DT,ZTRTN,ZTIO,ZTDESC,ZTSAVE
 Q
 ;
DQ ;
 K ^TMP($J),X
 S XTVPK=+^XTV(8991.2,XTVPT,0)
 S:'$D(^XTV(8991.2,XTVPT,1,0)) ^(0)="^8991.21^" S DIC="^XTV(8991.2,XTVPT,1,",DA(1)=XTVPT,DIC(0)="ML",DLAYGO=8991.2,DIC("P")=8991.21,X=XTVDT D ^DIC Q:Y'>0  S XTVD=+Y
 S:XTVVN'="" ^(0)=^XTV(8991.2,XTVPT,1,XTVD,0)_U_XTVVN
 F I=0:0 S I=$O(^XTV(8991.19,XTVPK,1,I)) Q:I'>0  S GLBN=+^(I,0) I '$D(^TMP($J,GLBN)) S ^(GLBN)=GLBN,^TMP($J,"A",GLBN)="" K X D CHK
 S XTVNF=0 F I=0:0 S I=$O(^TMP($J,"A",I)) Q:I'>0  S XTVNM=$O(^DD(I,0,"NM",0)),XTVNM=$S(XTVNM'="":XTVNM,1:I),^XTV(8991.2,XTVPT,1,XTVD,1,I,0)=XTVNM,^XTV(8991.2,XTVPT,1,XTVD,1,"B",XTVNM,I)="" D GETFIL S XTVNF=XTVNF+1,XTVNL=I
 I XTVNF>0 S ^XTV(8991.2,XTVPT,1,XTVD,1,0)="^^"_XTVNL_U_XTVNF
 D ^XTVGC1A
 K A,DA,DIC,DLAYGO,GLBN,I,IX,J,K,L,M,X,X1,XTBAS1,XTBAS2,XTCNA,XTCNL,XTCNT,XTNOD,XTNS,XTNS1,XTNSI,XTNSL,XTNUM,XTTY,XTTYI,XTTYJ,XTVA,XTVAL,XTVAB,XTVB,XTVB1,XTVD,XTVF,XTVNAM,XTVNF,XTVNL,XTVNM,XTVPK,XTVPT,XTVTY,XTVVN,XTXNUM,Y
 Q
 ;
CHK S L=0 F J=0:0 S J=$O(^DD(GLBN,"SB",J)) Q:J'>0  S X(L,J)=""
 F L=0:1 Q:'$D(X(L))  S M=L+1 F K=0:0 S K=$O(X(L,K)) Q:K'>0  F J=0:0 S J=$O(^DD(K,"SB",J)) Q:J'>0  S X(M,J)=""
 F L=-1:0 S L=$O(X(L)) Q:L=""  F J=0:0 S J=$O(X(L,J)) Q:J'>0  S:'$D(^TMP($J,J)) ^(J)=GLBN,^TMP($J,"A",GLBN,J)=""
 Q
 ;
GETFIL S XTVF=I D DD,DIC ;,DIE,DIBT,DIPT
 Q
DD S XTVTY="D",XTVA="^XTV(8991.2,XTVPT,1,XTVD,1,I,""D"",0)",XTVAB="^XTV(8991.2,XTVPT,1,XTVD,1,I,""D"",""B"",",XTVB1="^XTV(8991.2,XTVPT,1,XTVD,1,I,""D"",J,0)",XTVB="^XTV(8991.2,XTVPT,1,XTVD,1,I,""D"",J,1,"
 S (XTVF,J)=I S X="^DD("_XTVF_")",X1="^DD("_XTVF_",",XTVNAM=$S($O(^DD(I,0,"NM",0))'="":$O(^(0)),1:I),@XTVB1=XTVNAM,@(XTVAB_""""_XTVNAM_""","_J_")")="",XTCNA=1,XTCNL=I,XTCNT=0 D XPND
 F J=0:0 S J=$O(^TMP($J,"A",I,J)) Q:J'>0  S XTCNT=0,X="^DD("_J_")",X1="^DD("_J_",",XTVNAM=$S($O(^DD(J,0,"NM",0))'="":$O(^(0)),1:J),@XTVB1=XTVNAM,@(XTVAB_""""_XTVNAM_""","_J_")")="" D XPND S XTCNA=XTCNA+1,XTCNL=J
 I XTCNA>0 S @XTVA="^^"_XTCNL_U_XTCNA
 Q
 ;
DIC S XTVTY="C",XTVF=I,X="^DIC("_I_")",X1="^DIC("_I_",0",XTVB="^XTV(8991.2,XTVPT,1,XTVD,1,I,""C"",",XTCNT=0 D XPND
 I XTCNT>0 S @(XTVB_"0)")="^^"_XTCNT_U_XTCNT
 Q
 ;
DIE ;
 S XTVA="^XTV(8991.2,XTVPT,1,XTVD,1,I,""E"",0)",XTVAB="^XTV(8991.2,XTVPT,1,XTVD,1,I,""E"",""B"",",XTVB1="^XTV(8991.2,XTVPT,1,XTVD,1,I,""E"",J,0)",XTVB="^XTV(8991.2,XTVPT,1,XTVD,1,I,""E"",J,1,"
 S (XTVF,J)="F"_I,A="",XTCNA=0,XTVTY="E"
 F K=0:0 S A=$O(^DIE(XTVF,A)) Q:A=""  F J=0:0 S J=$O(^DIE(XTVF,A,J)) Q:J'>0  S X="^DIE("_J_")",X1="^DIE("_J_",",XTVNAM=A,@XTVB1=XTVNAM,@(XTVAB_""""_XTVNAM_""","_J_")")="",XTCNA=XTCNA+1,XTCNL=J,XTCNT=0 D XPND
 I XTCNA>0 S @XTVA="^^"_XTCNL_U_XTCNA
 Q
 ;
DIPT ;
 S XTVA="^XTV(8991.2,XTVPT,1,XTVD,1,I,""P"",0)",XTVAB="^XTV(8991.2,XTVPT,1,XTVD,1,I,""P"",""B"",",XTVB1="^XTV(8991.2,XTVPT,1,XTVD,1,I,""P"",J,0)",XTVB="^XTV(8991.2,XTVPT,1,XTVD,1,I,""P"",J,1,"
 S (XTVF,J)="F"_I,A="",XTCNA=0,XTVTY="P"
 F K=0:0 S A=$O(^DIPT(XTVF,A)) Q:A=""  F J=0:0 S J=$O(^DIPT(XTVF,A,J)) Q:J'>0  S X="^DIPT("_J_")",X1="^DIPT("_J_",",XTVNAM=A,@XTVB1=XTVNAM,@(XTVAB_""""_XTVNAM_""","_J_")")="",XTCNA=XTCNA+1,XTCNL=J,XTCNT=0 D XPND
 I XTCNA>0 S @XTVA="^^"_XTCNL_U_XTCNA
 Q
 ;
DIBT ;
 S XTVA="^XTV(8991.2,XTVPT,1,XTVD,1,I,""S"",0)",XTVAB="^XTV(8991.2,XTVPT,1,XTVD,1,I,""S"",""B"",",XTVB1="^XTV(8991.2,XTVPT,1,XTVD,1,I,""S"",J,0)",XTVB="^XTV(8991.2,XTVPT,1,XTVD,1,I,""S"",J,1,"
 S (XTVF,J)="F"_I,A="",XTCNA=0,XTVTY="S"
 F K=0:0 S A=$O(^DIBT(XTVF,A)) Q:A=""  F J=0:0 S J=$O(^DIBT(XTVF,A,J)) Q:J'>0  S X="^DIBT("_J_")",X1="^DIBT("_J_",",XTVNAM=A,@XTVB1=XTVNAM,@(XTVAB_""""_XTVNAM_""","_J_")")="",XTCNA=XTCNA+1,XTCNL=J,XTCNT=0 D XPND
 I XTCNA>0 S @XTVA="^^"_XTCNL_U_XTCNA
 Q
 ;
XPND ;
 F IX=0:0 S X=$Q(@X) S X=$S($E(X,1,2)="^|":U_$P(X,"|",3,99),$E(X,1,2)="^[":U_$P(X,"]",2,99),1:X) Q:X'[X1  I XTVTY'="E"!($P(X,",",2)'="""AB""") S XTCNT=XTCNT+1,@(XTVB_XTCNT_",0)")=$P(X,U,2,99),@(XTVB_XTCNT_",1)")=@X
 I XTCNT>0 S @(XTVB_"0)")="^^"_XTCNT_U_XTCNT
 Q
