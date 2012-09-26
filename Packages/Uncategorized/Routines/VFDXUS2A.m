VFDXUS2A ;DSS/SGM - SITE/CUSTOMER SPECIFIC PATTERN MATCHING;13 Aug 2009 14:50 ; 8/25/09 7:54am
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;Line tag references above PRIVATE SUBROUTINES can be called by other
 ;VFDXUS* routines or XUS* or implementation specific sign-on related
 ;routines.
 ;
 ; CHECKAV is only invoked to validate access and/or verify codes
 ; Pattern Match specific modules for editing A/V codes
 ;   These are invoked via X^VFDXTX and not invoked directly
 ;   Line tags: CKFOIA and CKCCHIT  [extrinsic functions]
 ;     T - req - 1:pattern match only for access code
 ;               2:check access code for uniqueness only
 ;               3:pattern match verify code and check for prior use
 ;     S - req - unencrypted code
 ;    EC - opt - encrypted code
 ;     Return value 0:okay, else #^message
 ;
CHECKAV(X1) ;Check A/V code return DUZ or Zero. (Called from XUSRB)
 ; From CHECKAV^XUS - Quits with value
 N %,%1,X,Y,IEN,DA,DIK
 S IEN=0
 ;Start CCOW
 I $E(X1,1,7)="~~TOK~~" D  Q:IEN>0 IEN
 . I $E(X1,8,9)="~1" S IEN=$$CHKASH^XUSRB4($E(X1,8,255))
 . I $E(X1,8,9)="~2" S IEN=$$CHKCCOW^XUSRB4($E(X1,8,255))
 . D RESETLIC ;Cache License Sharing
 . Q
 ;End CCOW
 ;Modify next line for case-sensitive verify code
 ;S X1=$$UP(X1) S:X1[":" XUTT=1,X1=$TR(X1,":")
 S Y=$$GET^XPAR("ALL","VFD CASE-SENSITIVE VERIFY CODE")
 I 'Y S X1=$$CONVERT(X1,1)
 I Y S $P(X1,";")=$$CONVERT($P(X1,";"),1)
 S:X1[":" XUTT=1,X1=$TR(X1,":")
 ;
 S X=$P(X1,";") Q:X="^" -1 S:XUF %1="Access: "_X
 Q:X'?1.20ANP 0
 S X=$$CONVERT(X,,1) I '$D(^VA(200,"A",X)) D LBAV^XUS Q 0
 S %1="",IEN=$O(^VA(200,"A",X,0)),XUF(.3)=IEN D USER^XUS(IEN)
 D AUTH ;External authentication
 S X=$P(X1,";",2) S:XUF %1="Verify: "_X S X=$$CONVERT(X,,1)
 I $P(XUSER(1),"^",2)'=X D LBAV^XUS Q 0
 I $G(XUFAC(1)) S DIK="^XUSEC(4,",DA=XUFAC(1) D ^DIK
 D RESETLIC ;Cache License Sharing
 Q IEN
 ;
CONVERT(X,UP,HASH) ;
 ;    X - req - string to be manipulated
 ;   UP - opt - Boolean value, 1:upper case X
 ; HASH - opt - Boolean value, 1:encrypt X
 N I,Y,Z S X=$G(X)
 I +$G(UP),X?.E1L.E S X=$$UP^XLFSTR(X)
 I +$G(HASH) S X=$$EN^XUSHSH(X)
 Q X
 ;
GETXPAR(PAR,ENT,INST,N) ; get parameter value
 ;;ALL;VFD CASE-SENSITIVE VERIFY CODE
 ;;ALL;VFD VERIFY CODE PATTERN
 I +$G(N) N Y,Z S Z=$T(GETXPAR+N),ENT=$P(Z,";",3),PAR=$P(Z,";",4)
 I $G(PAR)="" Q ""
 I $G(ENT)="" Q ""
 I $G(INST)="" Q $$GET^XPAR(ENT,PAR)
 Q $$GET^XPAR(ENT,PAR,INST)
 ;
T(T) ;
 ;;Use your assigned access code / username
 ;;This is your current vxVistA access code
 ;;This code is already in use by another user
 ;;Enter a mix of characters, 8-20 characters in length
 ;;VERIFY CODE must have at least 1 uppercase, 1 lowercase, and 1 number
 ;;VERIFY CODE may not start or end with a number
 ;;This code is the same as the current one.
 ;;This has been used previously as the VERIFY CODE.
 ;;VERIFY CODE must be different than the ACCESS CODE.
 ;;VERIFY CODE must be a mix of alpha and numerics and punctuation.
 ;;Name cannot be part of code.
 ;;VERIFY CODE must contain both upper and lowercase letters
 ;;Enter * characters mixed alphanumeric and punctuation (except '^', ';', ':').
 ;;ACCESS CODE cannot be all alphabetic or all numeric.
 ;;ACCESS CODE cannot be all numeric.
 ;;Unexpected problem encountered
 ;;Only the following non-alphanumeric characters allowed
 ;;This has been used previously as an ACCESS CODE
 Q T_U_$P($T(T+T),";",3)
 ;
 ;-----------------------  PRIVATE SUBROUTINES  -----------------------
CKFOIA(T,S,EC) ; see comments at top of routine
 ; Updated per VHA directive 6210 Strong Passwords
 N Z,NA,PUNC
 S Z=$$CKSET I +Z Q Z
 I Z="A" Q $$CKAC(3)
 ; checking for verify code only at this point
 Q $$CKVC("f")
 ;
CKCCHIT(T,S,EC) ; see comments at top of routine
 N Z,NA,PUNC
 S Z=$$CKSET I +Z Q $$T(Z)
 I Z="A" Q $$CKAC(3)
 ; checking for verify code only at this point
 I S'?.E1.U.E!(S'?.E1.L.E) Q "12^"_$$T(12)
 ; Next is based on FOIA, except permitting mixed case -
 ; LM: .UNP changed to .ANP in next to work with CCHIT mixed case rule
 Q $$CKVC("c")
 ;
CKSET() ; QA input variables
 S T=$G(T),S=$G(S),EC=$G(EC)
 S PUNC=$$PUNC
 D GETNAME(.NA)
 I EC="",S'="" S EC=$$CONVERT(S,,1)
 I T<1!($G(DA)<.5) Q 16
 I $S(T=1:0,T=2:0,T=3:0,T=12:0,T=21:0,1:1) Q 16
 Q $S(T=3:"V",1:"A")
 ;
CKAC(MIN) ; check for valid access code
 N Z
 I T[1 S Z=$$CKACP(X,$G(MIN)) I +Z Q $$T(Z)
 I T[2 S Z=$$CKACU(S,EC) I +Z Q $$T(Z)
 Q 0
 ;
CKACP(X,MIN,MAX) ;Generic access-code pattern match check (FOIA)
 ;   X - req - unencrypted access code
 ; MIN - opt - minimal length, default to 6
 ; MAX - opt - maximum length, default to 20
 ;access code case insensitive as it is stored as encrypted all uc
 N Z S Z=13
 S MIN=$G(MIN) S:'MIN MIN=6 S MAX=$G(MAX) S:'MAX MAX=20
 S Z=$P(Z,"*")_MIN_"-"_MAX_$P(Z,"*",2),X=$$CONVERT(X,1)
 I X[$C(34)!(X[";")!(X["^")!(X[":")!(X="MAIL-BOX") Q Z
 I $L(X)>MAX!($L(X)<MIN) Q Z
 I X'?.UNP Q Z
 ; allow for all alphabetic access code (e.g., network usernames)
 I 'XUAUTO,X?.N Q 15
 Q 0
 ;
CKACU(S,EC) ; generic access code uniqueness check (FOIA)
 ; S - opt - unencrypted access code
 ;EC - opt - encrypted access code
 ; must pass one or the other, if both EC used
 ; extrinsic funtion returns 0:access code not currently in use
 ;                          16:some other problem
 ;                          17:access code previously used
 ;                           2:access code is user's current code
 ;                           3:access code currenly used by another
 N Y,Z
 S Z=$G(EC)
 I Z="",$G(S)'="" S Z=$$CONVERT(S,1,1)
 I Z=""!($G(DA)'>0) Q 16
 S Y=$O(^VA(200,"A",Z,0)) I Y Q $S(Y=DA:2,1:3)
 I $D(^VA(200,"AOLD",Z)) Q 17
 Q 0
 ;
CKVC(TYPE) ; common pattern checks for verify code
 ; type - req - f:foia,  c:cchit - c is default
 ; expects S, EC, ECU
 N ECU
 S TYPE=$G(TYPE) S:TYPE="" TYPE="c"
 S ECU=$S(S'="":$$CONVERT(S,1,1),1:EC)
 I ($L(S)<8)!($L(S)>20)!(S[";")!(S["^")!(S[":") Q $$T(4)
 I '$S(TYPE="f":S?.UNP,1:S?.ANP) Q $T(4)
 ; if cchit require mixed case
 I TYPE="c",S'?.E1U.E!(S'?.E1L.E) Q $$T(12)
 I TYPE'="c",(S?8.20A)!(S?8.20N)!(S?8.20P)!(S?8.20AN)!(S?8.20AP)!(S?8.20NP) Q $$T(10) ;If not CCHIT
 I $D(^VA(200,DA,.1)),EC=$P(^(.1),U,2) Q $$T(7)
 I $D(^VA(200,DA,"VOLD",EC)) Q $$T(8)
 I ECU=$P(^VA(200,DA,0),U,3) Q $$T(9)
 I S[$P(NA,"^")!(S[$P(NA,"^",2)) Q $$T(11)
 ; if allow only certain punctuation chars then check here
 ;N Y S Y=$TR(S,PUNC) I Y?.E1P.E Q $$T(17)_"< "_PUNC_" >"
 Q 0
 ;
GETNAME(NA) ; get name components
 N X,Y,Z
 S NA("FILE")=200,NA("FIELD")=.01,NA("IENS")=DA_",",NA=$$HLNAME^XLFNAME(.NA)
 Q
 ;
PUNC() Q "~`!@#$%&*()_-+=|\{}[]'<>,.?/"
 ;
RESETLIC ; Cache reset license
 I $$GET^XPAR("SYS","VFD CLS ENABLE"),$T(^VFDVMOS)]"",IEN>0 D RESETLIC^VFDVMOS(IEN)
 Q
 ;
AUTH ;External authentication
 I $T(EN^VFDXAUTH)]"" D EN^VFDXAUTH
 Q
