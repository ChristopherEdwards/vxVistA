VFDCDUZ1 ;DSS/SGM - COMMON NEW PERSON FILE RPCS ;01/04/2007 06:48
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;DO NOT INVOKE THIS ROUTINE DIRECTLY, SEE VFDCDUZ ROUTINE
 ;
ACT() ; Validate that DUZ is an active user
 N X,Y,Z,VFD,VFDX
 S X=$$CK($G(XDUZ)) I X<0 Q X
 S X=$$ACTIVE^XUSER(XDUZ) I X="" Q $$ERR(3)
 I X=0 Q $$ERR(4)
 I X="0^DISUSER" Q $$ERR(5)
 I +X=0 S Y=X Q $$ERR(6)
 S X=$$SCR
 Q $S(X'=1:X,1:XDUZ)
 ;
CK(XDUZ) ; basic check for valid DUZ
 I $G(XDUZ)="" Q $$ERR(1)
 I +XDUZ'=XDUZ Q $$ERR(2)
 I XDUZ<.5 Q $$ERR(2)
 I $G(^VA(200,XDUZ,0))="" Q $$ERR(3)
 Q 1
 ;
DIV() ; Return default division for user
 N A,I,X,Y,VFD,VFDCX
 S XDUZ=$G(XDUZ) S:XDUZ="" XDUZ=DUZ
 S X=$$DIV4^XUSER(.VFDCX,XDUZ)
 I 'X,'$G(SITE) Q $$ERR(8)
 I 'X Q $$SITE^VASITE
 S (A,I,X)=0
 F  S I=$O(VFDCX(I)) Q:'I  Q:VFDCX(I)  S A=A+1 S:VFDCX(I)="" X=I
 S Y=$S(I:I,A=1&X:X,1:0) I Y Q Y_U_$$NS^XUAF4(Y)
 I $G(SITE) Q $$SITE^VASITE
 Q $$ERR(9)
 ;
ID ; return a list of IDs
 N A,B,C,I,X,Y,Z,DIERR,VFD,VFDA,VFDER,VFDX,FLD,FLDS,IENS
 S FLDS="" S:$G(XDUZ)="" XDUZ=DUZ
 S X=$$CK^VFDCDUZ(XDUZ) I X<1 S VFDC=X Q
 S FLAGS=$G(FLAGS) S:FLAGS="" FLAGS="ADNSTVv"
 I FLAGS["A",FLAGS["a" S FLAGS=$TR(FLAGS,"a")
 ; map flags to field numbers
 F I=1:1:$L(FLAGS) S X=$E(FLAGS,I) D
 .Q:"AaDNSTVv"'[X  N FLD
 .I "Aa"[X S FLD=21600,FLAGS(FLD)="OAI"
 .I X="D" S FLD=53.2,FLAGS(FLD)="DEA"
 .I X="N" S FLD=41.99,FLAGS(FLD)="NPI"
 .I X="S" S FLD=9,FLAGS(FLD)="SSN"
 .I X="T" S FLD=53.92,FLAGS(FLD)="TAX"
 .I X="V" S FLD=9000,FLAGS(FLD)="VPID"
 .I X="v" S FLD=53.3,FLAGS(FLD)="VA"
 .; verify parent field exists in file 200
 .Q:'$D(FLD)  Q:$$VFIELD^VFDCFM(,200,FLD,1)<1
 .S FLDS=FLDS_FLD_$S(FLD=21600:"*",1:"")_";"
 .Q
 I FLDS="" S VFDC=$$ERR(15) Q
 S IENS=XDUZ_","
 D GETS^DIQ(200,IENS,FLDS,"N","VFD","VFDER")
 I $D(DIERR) S VFDC="-1^"_$$MSG^VFDCFM("VE",,,,"VFDER") Q
 S (A,B,C,I)=0
 F  S I=$O(VFD(200,IENS,I)) Q:'I  I $D(FLAGS(I)) D
 .S B=B+1,VFDX(B)=FLAGS(I)_U_$G(VFD(200,IENS,I))
 .Q
 I FLAGS(21600) S I=0 F  S I=$O(VFD(200.0216,I)) Q:I=""  D
 .K Z M Z=VFD(200.0216,I)
 .S X="OAI^",Y=$G(Z(.02)) Q:Y=""  S X=X_Y
 .S X=X_U_$G(Z(.01))_U_$G(Z(.04))
 .S A=A+1,VFDA(A)=X
 .S $P(C,U)=1+C I FLAGS["a",+$G(Z(.04)) S $P(C,U,2)=A
 .Q
 I FLAGS["a",A S Y=$P(C,U,2) D  I VFDC'="" Q
 .I Y S X=VFDA(Y) K VFDA S VFDA(1)=X Q
 .I A>1 S VFDC=$$ERR(17)
 .Q
 S Z=0 I B F I=1:1:B S Z=Z+1,VFDC(Z)=VFDX(I)
 I A F I=1:1:A S Z=Z+1,VFDC(Z)=VFDA(I)
 I '$D(VFDC) S VFDC(1)=$$ERR(16)
 I $G(FUN) S VFDC="" F I=1:1 Q:'$D(VFDC(I))  S VFDC=VFDC_VFDC(I)_";"
 Q
 ;
LIST ; Return a list of active users only for a lookup value
 N I,X,Y,Z,VFD,VFDCNT,VFDCX,VFDLIST,VFDRET,VFDSCR,VFDX,ERR,INPUT
 S VFDRET=$NA(^TMP("VFDC",$J)) K @VFDRET
 S VFDLIST=$NA(^TMP("VFDCDUZ",$J)) K @VFDLIST
 I $G(VAL)="" S @VFDRET@(1)=$$ERR(10) G LOUT
 S Z=0 I $D(SCR) D  I $D(ERR) S @VFDRET@(1)=ERR G LOUT
 .S X=$G(SCR) I X'="" D OK Q
 .S I="" F  S I=$O(SCR(I)) Q:I=""  S X=SCR(I) D OK
 .Q
 S INPUT(1)="FILE^200"
 S INPUT(2)="FIELDS^.01;20.2;20.3;1;8;29"
 S INPUT(3)="VAL^"_VAL
 S INPUT(4)="SCREEN^I $$ACT^VFDCDUZ(,+Y,.VFDSCR,1)>0"
 D FIND^VFDCFM05(.VFDLIST,.INPUT)
 S (VFD,VFDCNT)=0
 I $D(@VFDLIST) F  S VFD=$O(@VFDLIST@(VFD)) Q:'VFD  D
 .S X=$G(@VFDLIST@(VFD,0)) Q:+X'>0  S X=$P(X,U,2),X=$$NAMEFMT^XLFNAME(X)
 .S Y=@VFDLIST@(VFD,0),Z=$P(Y,U,1,4),$P(Z,U,5)=X_U_$P(Y,U,5,7)
 .S VFDX=Z
 .S X=$$DIV^VFDCDUZ(,+VFDX,1,1) I X>0 S $P(VFDX,U,9)=$P(X,U,2)
 .S VFDCNT=VFDCNT+1,@VFDRET@(VFDCNT,0)=VFDX
 .Q
 I '$D(@VFDRET) S @VFDRET@(1)=$$ERR(11)
LOUT S VFDC=VFDRET K @VFDLIST
 Q
 ;
PER() ; Return a user's current active person classification for PCE
 N X
 S X=$$CK(USER) I X<1 Q X
 S:'$G(DATE) DATE=DT
 S X=$$GET^XUA4A72(USER,DATE)
 I X<1 S DATE=$$FMTE^XLFDT(DATE),X=$$ERR(13)
 Q X
 ;
PROV() ; Determine is active cprs provider
 N X,Y,Z,ACC,KEY,VISITOR
 S X=$$CK(XDUZ) I X<1 Q X
 S RDV=+$G(RDV),RDV=(RDV'=0)
 S KEY=$D(^XUSEC("XUORES",XDUZ))
 S ACC=($P(^VA(200,XDUZ,0),U,3)'="")
 S VISITOR=$D(^VA(200,"BB","VISITOR",XDUZ))
 S Y=$$PROVIDER^XUSER(XDUZ,RDV)
 I ACC,Y=1 Q 3
 I Y["0^TERMINATED" Q $$ERR(6)
 I KEY Q 2
 I VISITOR Q RDV=1
 Q $$ERR(14)
 ;
 ; --------------------  subroutines  ----------------------
ERR(A) ; return error message
 I A=1 S A="No user DUZ value received"
 I A=2 S A="Invalid user DUZ value received: "_XDUZ
 I A=3 S A="NEW PERSON record "_XDUZ_" does not exist"
 I A=4 S A="User cannot sign-on"
 I A=5 S A="User cannot sign on, Disuser set"
 I A=6 S A="User terminated on "_$$FMTE^XLFDT($P(Y,U,3))
 I A=7 S A="User does not own security key "_Y
 I A=8 S A="User has no divisions defined"
 I A=9 S A="User has division(s), none marked as default"
 I A=10 S A="No lookup value received"
 I A=11 S A="No matches found"
 I A=12 S A="Invalid screen type received"
 I A=13 S A="Person does not have an active Person Class for "_DATE
 I A=14 S A="User is not a provider"
 I A=15 S A="Either invalid flags received, or file 200 fields do not exist"
 I A=16 S A="No data found for this record"
 I A=17 S A="More than one alternate ID found with none indicated as default"
 Q "-1^"_A
 ;
OK ;  validate SCR from LIST
 S Y=$P(X,U)
 I Y?.E1L.E S Y=$$UP^XLFSTR(Y)
 I Y="KEY"!(Y="M")!(Y="PARM") S Z=1+Z,VFDSCR(Z)=X
 E  I '$D(ERR) S ERR=$$ERR(12)
 Q
 ;
SCR() ;  dic screen for users
 I '$D(VFDSCR) Q 1
 N X,Y,Z,VFD,VFDRET,VFDX
 S VFD="",VFDRET=1
 F  S VFD=$O(VFDSCR(VFD)) Q:VFD=""  D  Q:$D(VFDRET)
 .S X=$P(VFDSCR(VFD),U),Y=$P(VFDSCR(VFD),U,2),Z=$P(VFDSCR(VFD),U,3)
 .I X="KEY" S:'$D(^XUSEC(Y,XDUZ)) VFDRET=$$ERR(7) Q
 .I X="PARM" D  Q
 ..S VFDX="USR~"_Y_"~"_Z,X=$$GET1^VFDCXPR(,VFDX,1)
 ..I +X=-1 S VFDRET=X
 ..Q
 .S VFDX="-1^"_$S(Y'="":Y,1:"Input screen failed")
 .I X="M" X "N VFDX X $P(VFDSCR(VFD),U,3,99)" E  S VFDRET=VFDX Q
 .Q
 Q VFDRET
