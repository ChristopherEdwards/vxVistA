LEXXFI4 ; ISL/KER - File Info - Record Counts (2)      ; 07/28/2004
 ;;2.0;LEXICON UTILITY;**32**;Sep 23, 1996
 Q
 ;                    
 ; Global Variables
 ;   ^TMP("LEXCNT",$J   SACC 2.3.2.5.1  
 ;              
 ; External References
 ;   DBIA 10103  $$FMDIFF^XLFDT
 ;                    
DSP ; Display Results
 N LEXFP,LEXCT,LEXFI,LEXGTOT,LEXHSF,LEXJOB,LEXMD,LEXX,LEXLVL,LEXML
 N LEXNCFI,LEXNFI,LEXNPAR,LEXOPAR,LEXO,LEXPAR,LEXTAB,LEXTXT
 S (LEXCT,LEXGTOT,LEXML)=0,LEXOPAR=""
 S LEXJOB=$J S:+($G(LEXMD))>0 LEXJOB=+($G(LEXMD))
 K:$D(LEXMD) LEXMD S LEXFP="" S LEXFP=""
 F  S LEXFP=$O(^TMP("LEXCNT",LEXJOB,"ORDER",LEXFP)) Q:LEXFP=""  D
 . S LEXO=""
 . F  S LEXO=$O(^TMP("LEXCNT",LEXJOB,"ORDER",LEXFP,LEXO)) Q:LEXO=""  D
 . . N LEXFI,LEXPAR,LEXLVL,LEXTAB,LEXTXT,LEXHSF,LEXX
 . . S LEXTAB="",LEXHSF=0
 . . S LEXPAR=$G(^TMP("LEXCNT",LEXJOB,"ORDER",LEXFP,LEXO))
 . . S LEXFI=+($P(LEXPAR,"^",2)),LEXLVL=+($P(LEXPAR,"^",3))
 . . S LEXPAR=+($P(LEXPAR,"^",1)) Q:LEXPAR=0
 . . S LEXNFI=$O(^TMP("LEXCNT",LEXJOB,LEXPAR,LEXPAR))
 . . S:LEXNFI>0&(LEXNFI'=LEXPAR) LEXHSF=1
 . . S LEXX=$G(^TMP("LEXCNT",LEXJOB,LEXPAR,LEXFI)),LEXCT=LEXCT+1
 . . S LEXNPAR=$O(^TMP("LEXCNT",LEXJOB,"ORDER",LEXFP,LEXO))
 . . S LEXNPAR=$P(LEXNPAR,";",1)
 . . S LEXNCFI=$O(^TMP("LEXCNT",LEXJOB,"ORDER",LEXFP))
 . . I '$L(LEXNPAR),$L(LEXNCFI) S LEXML=1
 . . I LEXCT=1 D TTL,HDR
 . . I +LEXFI>0 D TSF
 . . I +LEXFI'>0,+($G(LEXHSF))>0 D GTSF
 D GT,CK
 Q
TSF ;   Total for a Single File/Sub-File
 N LEXNM,LEXTAB,LEXTOT,LEXTXT,LEXTYP
 S LEXX=$G(LEXX),LEXTOT=+LEXX,LEXNM=$P(LEXX,"^",2)
 S LEXTYP=$P(LEXX,"^",3),LEXTAB=""
 Q:+LEXTOT'>0  Q:'$L(LEXNM)  Q:'$L(LEXTYP)
 S $P(LEXTAB," ",(+($G(LEXLVL))*2))=""
 S LEXTXT="  "_LEXTAB_LEXNM_" ("_LEXTYP_")"
 S LEXTXT=LEXTXT_$J("",(60-$L(LEXTXT)))_$J(LEXTOT,9)
 S LEXGTOT=+($G(LEXGTOT))+LEXTOT D TL^LEXXFI8(LEXTXT)
 Q
GTSF ;   Grand Total for a Single File
 N LEXLVL,LEXNM,LEXTAB,LEXTOT,LEXTXT,LEXTYP,LEXX
 S LEXX=$G(^TMP("LEXCNT",LEXJOB,LEXPAR,LEXPAR)),LEXLVL=+($$ML)+2
 S LEXNM=$P(LEXX,"^",2),LEXTYP=$P(LEXX,"^",3) Q:'$L(LEXNM)  Q:'$L(LEXTYP)
 S LEXTAB="",LEXX=$G(^TMP("LEXCNT",LEXJOB,LEXPAR,0))
 S LEXTOT=+LEXX,$P(LEXTAB," ",(LEXLVL*2))=""
 S LEXTXT="  "_LEXTAB_" - Total Records for "_LEXTYP
 S LEXTXT=LEXTXT_$J("",(60-$L(LEXTXT)))_$J(LEXTOT,9)
 D TL^LEXXFI8(LEXTXT)
 Q
GT ;   Grand Totals for Multiple Files
 N LEXCT,LEXFI,LEXTXT S LEXCT=0,LEXFI="" I +($G(LEXGTOT))>0,+($G(LEXML))>0 D
 . D BL^LEXXFI8 S LEXTXT="   GRAND TOTAL (ALL FILES) "
 . S LEXTXT=LEXTXT_$J("",(50-$L(LEXTXT)))_$J(LEXGTOT,19) D TL^LEXXFI8(LEXTXT)
 Q
TTL ; Record Count Title
 D:+($G(LEXMUL))>0 TT^LEXXFI8("","Record Counts")
 D:+($G(LEXMUL))'>0 TT^LEXXFI8($G(LEXFI),"Record Count")
 D BL^LEXXFI8
 Q
HDR ; Record Count Header
 N LEXTXT S LEXTXT="   Name (File Number)"
 S LEXTXT=LEXTXT_$J("",(60-$L(LEXTXT)))_$J("Entries",9) D TL^LEXXFI8(LEXTXT)
 S LEXTXT="   -------------------------------------------------"
 S LEXTXT=LEXTXT_$J("",(60-$L(LEXTXT)))_$J("-------",9) D TL^LEXXFI8(LEXTXT)
 Q
CK ; Records Checked
 N LEXF,LEXS,LEXFT,LEXST,LEXJ S LEXJ=$S(+($G(LEXJOB))>0:+($G(LEXJOB)),1:$J)
 S LEXF=+($G(^TMP("LEXCNT",LEXJ,"CNT")))
 S LEXFT=$S(LEXF=1:"1 File",LEXF>1:(LEXF_" Files"),1:"")
 S LEXS=+($G(^TMP("LEXCNT",LEXJ,"SUB")))
 S LEXST=$S(LEXS=1:"1 Sub-File",LEXS>1:(LEXS_" Sub-Files"),1:"")
 I (LEXF+LEXS)>1 D
 . S LEXTXT="   " S:$L(LEXFT) LEXTXT=LEXTXT_LEXFT
 . S:$L(LEXFT)&($L(LEXST)) LEXTXT=LEXTXT_" and "_LEXST
 . S:'$L(LEXFT)&($L(LEXST)) LEXTXT=LEXTXT_LEXST
 . I $L(LEXFT)!($L(LEXST)) S LEXTXT=LEXTXT_" Checked" D
 . . D BL^LEXXFI8,TL^LEXXFI8(LEXTXT)
 Q
ML(X) ; Maximum Level
 N LEXJ S LEXJ=$S(+($G(LEXJOB))>0:+($G(LEXJOB)),1:$J)
 S X=+($G(^TMP("LEXCNT",LEXJ,"LVL"))) S:+X'>0 X=1
 Q X
NF(X) ; Number of Files
 N LEXJ S LEXJ=$S(+($G(LEXJOB))>0:+($G(LEXJOB)),1:$J)
 S X=+($G(^TMP("LEXCNT",LEXJ,"CNT")))
 Q X
NS(X) ; Number of Sub-Files
 N LEXJ S LEXJ=$S(+($G(LEXJOB))>0:+($G(LEXJOB)),1:$J)
 S X=+($G(^TMP("LEXCNT",LEXJ,"SUB")))
 Q X
ST ; Show TMP Array
 N NN,NC S NN="^TMP(""LEXCNT"")",NC="^TMP(""LEXCNT"","
 F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  D
 . W !,NN,"=",@NN
 Q
EP(X,Y) ;   Elapsed Time (Begin, End)
 N LEXTIM,LEXBEG,LEXEND
 S LEXBEG=$G(X),LEXEND=$G(Y) Q:+LEXBEG'>0 ""  Q:+LEXEND'>0 ""
 S LEXTIM=$$FMDIFF^XLFDT(LEXEND,LEXBEG,2) Q:+LEXTIM'>0 "00:00:00"
 S LEXTIM=$$TIM(LEXTIM)
 Q LEXTIM
TIM(X) ;   Format Time Elapsed
 N LEXD,LEXH,LEXM,LEXS,LEXT,LEXV S X=+($G(X)) Q:X'>0 "00:00:00"
 S LEXD=X\86400 S LEXV=LEXD*86400 S:+LEXV>0&(LEXV<X) X=X-LEXV
 S LEXH=X\3600 S LEXV=LEXH*3600 S:+LEXV>0&(LEXV<X) X=X-LEXV
 S:$L(LEXH)<2 LEXH="0"_LEXH S:$L(LEXH)<2 LEXH="0"_LEXH
 S LEXM=X\60 S LEXV=LEXM*60 S:+LEXV>0&(LEXV<X) X=X-LEXV
 S:$L(LEXM)<2 LEXM="0"_LEXM S:$L(LEXM)<2 LEXM="0"_LEXM
 S LEXS=X S:$L(LEXS)<2 LEXS="0"_LEXS S:$L(LEXS)<2 LEXS="0"_LEXS
 S LEXT="" S:+LEXD>0 LEXT=+LEXD_" day"_$S(+LEXD>1:"s",1:"")_" "
 S LEXT=LEXT_LEXH_":"_LEXM_":"_LEXS,X=LEXT
 Q X
