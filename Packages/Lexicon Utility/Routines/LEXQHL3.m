LEXQHL3 ;ISL/KER - Query History - CPT/HCPCS Extract ;10/30/2008
 ;;2.0;LEXICON UTILITY;**62**;Sep 23, 1996;Build 16
 ;;
 ;               
 ; Global Variables
 ;    ^ICPT(              ICR   4489
 ;    ^TMP("LEXQHL")      SACC 2.3.2.5.1
 ;               
 ; External References
 ;    $$CPT^ICPTCOD       ICR   1995
 ;    $$UP^XLFSTR         ICR  10104
 ;               
 Q
EN(X,Y) ; CPT/HCPCS Procedure File
 N LEXIEN,LEXDISP,LEXIA,LEXEF,LEXCT,LEXC S LEXIEN=$G(X),LEXDISP=$G(Y),LEXIA="" Q:+LEXIEN'>0  Q:'$D(^ICPT(+LEXIEN,0))  S LEXC=$P($G(^ICPT(+LEXIEN,0)),U,1)
 K ^TMP("LEXQHL",$J) S ^TMP("LEXQHL",$J,"IEN")=LEXIEN,^TMP("LEXQHL",$J,"CODE")=LEXC,^TMP("LEXQHL",$J,"NAME")=$P($$CPT^ICPTCOD(LEXC),U,3)
 S:'$L(LEXDISP) LEXDISP="SB" D ST,NM,DS,CP^LEXQHL5(LEXC) D:$L($G(LEXDISP)) DP K ^TMP("LEXQHL",$J)
 Q
ST ;   1  Status
 N LEXCT,LEXD,LEXE,LEXEF,LEXH,LEXMS,LEXN,LEXS,LEXT
 S LEXCT=0,LEXEF="" F  S LEXEF=$O(^ICPT(+LEXIEN,60,"B",LEXEF)) Q:'$L(LEXEF)  D
 . N LEXH S LEXH=0 F  S LEXH=$O(^ICPT(+LEXIEN,60,"B",LEXEF,LEXH)) Q:+LEXH'>0  D
 . . N LEXN,LEXS,LEXE,LEXT,LEXD,LEXMS S LEXN=$G(^ICPT(+LEXIEN,60,+LEXH,0)),LEXE=$P(LEXN,U,1),LEXS=$P(LEXN,U,2)
 . . Q:+LEXS'>0&(LEXCT'>0)  S LEXCT=LEXCT+1,LEXMS=$$MS^LEXQHLM(LEXE,1),LEXT=$S(+LEXS>0:"Activation",1:"Inactivation")
 . . S:+LEXS>0&(LEXCT=1) LEXT="Initial Activation"_LEXMS,LEXIA=LEXE
 . . S:$O(^ICPT(+LEXIEN,60,"B",LEXEF))=""&(LEXCT>1) LEXT=LEXT_" (final status change)"
 . . S LEXD=$$SD^LEXQHLM(LEXE) S ^TMP("LEXQHL",$J,LEXEF,1,1)=LEXD_U_LEXT
 Q
NM ;   2  Procedure Name
 N LEX,LEXC,LEXCT,LEXD,LEXE,LEXEF,LEXH,LEXI,LEXN,LEXS,LEXT
 S LEXCT=0,LEXEF="" F  S LEXEF=$O(^ICPT(+LEXIEN,61,"B",LEXEF)) Q:'$L(LEXEF)  D
 . N LEXH S LEXH=0 F  S LEXH=$O(^ICPT(+LEXIEN,61,"B",LEXEF,LEXH)) Q:+LEXH'>0  D
 . . N LEXN,LEXS,LEXE,LEXT,LEXD,LEX,LEXI S LEXN=$G(^ICPT(+LEXIEN,61,+LEXH,0)),LEXE=$P(LEXN,U,1),LEXT=$$UP^XLFSTR($P(LEXN,U,2))
 . . S LEXCT=LEXCT+1,LEX(1)=LEXT D PR^LEXQHLM(.LEX,63)
 . . S LEXS=$S(+LEXCT=1:"Initial Procedure Name",+LEXCT>1:"Updated Procedure Name",1:"Procedure Name")
 . . S:$O(^ICPT(+LEXIEN,61,"B",LEXEF))=""&(LEXCT>1) LEXS=LEXS_" (final change)"
 . . S LEXD=$$SD^LEXQHLM(LEXE) S ^TMP("LEXQHL",$J,LEXEF,2,1)=LEXD_U_LEXS
 . . S LEXI=0 F  S LEXI=$O(LEX(LEXI)) Q:+LEXI'>0  D
 . . . N LEXC S LEXT=$G(LEX(LEXI)) Q:'$L(LEXT)  S LEXC=$O(^TMP("LEXQHL",$J,LEXEF,2," "),-1)+1
 . . . S ^TMP("LEXQHL",$J,LEXEF,2,LEXC)=U_LEXT
 Q
DS ;   3  Description
 N LEX,LEXC,LEXCT,LEXD,LEXE,LEXEF,LEXH,LEXI,LEXN,LEXS,LEXT
 S LEXCT=0,LEXEF="" F  S LEXEF=$O(^ICPT(+LEXIEN,62,"B",LEXEF)) Q:'$L(LEXEF)  D
 . N LEXH S LEXH=0 F  S LEXH=$O(^ICPT(+LEXIEN,62,"B",LEXEF,LEXH)) Q:+LEXH'>0  D
 . . N LEXC,LEXN,LEXS,LEXE,LEXT,LEXD,LEX,LEXI S LEXN=$G(^ICPT(+LEXIEN,62,+LEXH,0))
 . . S LEXE=$P(LEXN,U,1) S (LEXC,LEXI)=0 F  S LEXI=$O(^ICPT(+LEXIEN,62,+LEXH,1,LEXI)) Q:+LEXI'>0  D
 . . . S LEXT=$$TM^LEXQHLM($$UP^XLFSTR($G(^ICPT(+LEXIEN,62,+LEXH,1,LEXI,0)))) Q:'$L(LEXT)  S LEXC=LEXC+1,LEX(LEXC)=LEXT
 . . S LEXCT=LEXCT+1 D PR^LEXQHLM(.LEX,63)
 . . S LEXS=$S(+LEXCT=1:"Initial Description",+LEXCT>1:"Updated Description",1:"Description")
 . . S:$O(^ICPT(+LEXIEN,62,"B",LEXEF))=""&(LEXCT>1) LEXS=LEXS_" (final change)"
 . . S LEXD=$$SD^LEXQHLM(LEXE) S ^TMP("LEXQHL",$J,LEXEF,3,1)=LEXD_U_LEXS
 . . S LEXI=0 F  S LEXI=$O(LEX(LEXI)) Q:+LEXI'>0  D
 . . . N LEXC S LEXT=$G(LEX(LEXI)) Q:'$L(LEXT)  S LEXC=$O(^TMP("LEXQHL",$J,LEXEF,3," "),-1)+1
 . . . S ^TMP("LEXQHL",$J,LEXEF,3,LEXC)=U_LEXT
 Q
 ;     
DP ; Display
 S LEXDISP=$G(LEXDISP) Q:$L(LEXDISP)>8  Q:$L(LEXDISP)<2  Q:LEXDISP["^"  N LEXL S LEXL=$T(@LEXDISP+0) Q:'$L(LEXL)
 D @LEXDISP
 Q
SB ;   Subjective
 N LEX1,LEX2,LEX3,LEXC,LEXCT,LEXD,LEXE,LEXEC,LEXG,LEXHDR,LEXI,LEXID,LEXM,LEXN,LEXN1,LEXN2,LEXN3,LEXO1,LEXO2,LEXO3,LEXP,LEXS,LEXT
 S LEXC=$G(^TMP("LEXQHL",$J,"CODE")),LEXI=$G(^TMP("LEXQHL",$J,"IEN")),LEXN=$G(^TMP("LEXQHL",$J,"NAME"))
 S LEXT="Code:  "_LEXC,LEXT=LEXT_$J(" ",(16-$L(LEXT)))_LEXN D TL^LEXQHLM(LEXT) S LEXT="",LEXT=LEXT_$J(" ",(16-$L(LEXT)))_"IEN:  "_LEXI D TL^LEXQHLM(LEXT)
 F LEXID=1:1:4 D
 . N LEXHDR,LEXCT,LEXEC S (LEXEC,LEXCT)=0,LEXHDR=$$HD(LEXID) Q:'$L(LEXHDR)  S LEXP="",LEX1=0 F  S LEX1=$O(^TMP("LEXQHL",$J,LEX1)) Q:+LEX1'>0  D
 . . S LEXEC=LEXEC+1 I LEXID=1 D  Q
 . . . S LEXN=$G(^TMP("LEXQHL",$J,LEX1,LEXID,1)) Q:'$L(LEXN)  S LEXE=$P(LEXN,U,1),LEXS=$P(LEXN,U,2) Q:'$L(LEXE)  Q:'$L(LEXS)  S LEXCT=LEXCT+1
 . . . D:LEXCT=1 BL^LEXQHLM,TL^LEXQHLM((" "_LEXHDR)) S LEXT=LEXE,LEXT=LEXT_$J(" ",(11-$L(LEXT)))_"  "_LEXS,LEXT="   "_LEXT D TL^LEXQHLM(LEXT)
 . . N LEX2 S LEX2=0,LEXE="" F  S LEX2=$O(^TMP("LEXQHL",$J,LEX1,LEXID,LEX2)) Q:+LEX2'>0  D
 . . . S LEXN=$G(^TMP("LEXQHL",$J,LEX1,LEXID,LEX2)) S:LEX2=1 LEXE=$P(LEXN,U,1) Q:LEX2=1  Q:'$L(LEXE)
 . . . I LEX2=2 D  Q
 . . . . S LEXCT=LEXCT+1,LEXT=$G(LEXE),LEXS=$P(LEXN,U,2),LEXT=LEXT_$J(" ",(11-$L(LEXT)))_"  "_LEXS,LEXT="   "_LEXT
 . . . . D:LEXCT=1 BL^LEXQHLM,TL^LEXQHLM((" "_LEXHDR)) D TL^LEXQHLM(LEXT)
 . . . I LEX2>2 D  Q
 . . . . S LEXCT=LEXCT+1,LEXT="",LEXS=$P(LEXN,U,2),LEXT=LEXT_$J(" ",(11-$L(LEXT)))_"  "_LEXS,LEXT="   "_LEXT
 . . . . D:LEXCT=1 BL^LEXQHLM,TL^LEXQHLM((" "_LEXHDR)) D TL^LEXQHLM(LEXT)
 Q
CH ;   Chronological
 N LEX1,LEX2,LEX3,LEXC,LEXD,LEXDC,LEXI,LEXL1,LEXL2,LEXL3,LEXN,LEXP,LEXS,LEXT,LEXT1,LEXT2,LEXT3
 S LEXC=$G(^TMP("LEXQHL",$J,"CODE")),LEXI=$G(^TMP("LEXQHL",$J,"IEN")),LEXN=$G(^TMP("LEXQHL",$J,"NAME"))
 S LEXT="Code:  "_LEXC,LEXT=LEXT_$J(" ",(16-$L(LEXT)))_LEXN D TL^LEXQHLM(LEXT) S LEXT="",LEXT=LEXT_$J(" ",(16-$L(LEXT)))_"IEN:  "_LEXI D TL^LEXQHLM(LEXT)
 S LEXP="",LEX1=0 F  S LEX1=$O(^TMP("LEXQHL",$J,LEX1)) Q:+LEX1'>0  D
 . D BL^LEXQHLM N LEX2,LEXDC S (LEXDC,LEX2)=0 F  S LEX2=$O(^TMP("LEXQHL",$J,LEX1,LEX2)) Q:+LEX2'>0  D
 . . N LEX3 S LEX3=0 F  S LEX3=$O(^TMP("LEXQHL",$J,LEX1,LEX2,LEX3)) Q:+LEX3'>0  D
 . . . N LEXN,LEXD,LEXS S LEXN=$G(^TMP("LEXQHL",$J,LEX1,LEX2,LEX3)),LEXD=$P(LEXN,U,1),LEXS=$P(LEXN,U,2)
 . . . S LEXT=$S(LEXD'=LEXP:LEXD,1:""),LEXT=LEXT_$J(" ",(11-$L(LEXT)))_$S($L(LEXD):"- ",1:"  ")_LEXS S LEXT="   "_LEXT D TL^LEXQHLM(LEXT)
 . . . S:LEXD'="" LEXP=LEXD
 Q
 ; 
 ; Miscellaneous
IA(X) ;   Initial Activation
 N LEXEF,LEXH,LEXN,LEXS,LEXE,LEXIEN S LEXIEN=+($G(X)),LEXE="" Q:+LEXIEN'>0 ""  Q:'$D(^ICPT(+LEXIEN,60,0)) ""  S LEXEF="" F  S LEXEF=$O(^ICPT(+LEXIEN,60,"B",LEXEF)) Q:'$L(LEXEF)  D  Q:$G(LEXE)?7N
 . S LEXH=0 F  S LEXH=$O(^ICPT(+LEXIEN,60,"B",LEXEF,LEXH)) Q:+LEXH'>0  S LEXN=$G(^ICPT(+LEXIEN,60,+LEXH,0)) S:+($P(LEXN,U,2))>0 LEXE=$P(LEXN,U,1) Q:$G(LEXE)?7N
 S X="" S:$G(LEXE)?7N X=$G(LEXE)
 Q X
HD(X) ;   Header
 Q:+($G(X))=1 "Status"  Q:+($G(X))=2 "Procedure Name"  Q:+($G(X))=3 "Description"  Q:+($G(X))=4 "Lexicon Expression"
 Q ""
