LEXQCM ;ISL/KER - Query - CPT Modifiers - Extract ;10/30/2008
 ;;2.0;LEXICON UTILITY;**62**;Sep 23, 1996;Build 16
 ;               
 ; Global Variables
 ;    ^DIC(81.3,          ICR   4492
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    $$GET1^DIQ          ICR   2056
 ;    GETS^DIQ            ICR   2056
 ;    HIST^ICPTAPIU       ICR   1997
 ;    $$MOD^ICPTMOD       ICR   1996
 ;    MODD^ICPTMOD        ICR   1996
 ;    $$DT^XLFDT          ICR  10103
 ;    $$UP^XLFSTR         ICR  10104
 ;               
EN ; Main Entry Point
 N LEXENV S LEXENV=$$EV Q:+LEXENV'>0
 N LEXAD,LEXEDT,LEXCDT,LEXEXIT,LEXTEST S LEXEXIT=0,LEXCDT=""
 F  S LEXCDT=$$AD^LEXQM,LEXAD=LEXCDT Q:'$L(LEXCDT)  S LEXEDT=$P(LEXCDT,"^",1),LEXCDT=$P(LEXCDT,"^",2) Q:LEXCDT'?7N  D LOOK Q:LEXCDT'?7N  Q:+LEXEXIT>0
 Q
LOOK ; CPT Modifier Lookup Loop
 S LEXCDT=$G(LEXCDT),LEXEDT=$$ED^LEXQM(LEXCDT) I LEXCDT'?7N S LEXCDT="" Q
 N LEXMOD,LEXMODC S LEXLEN=62
 F  S LEXMOD=$$MOD^LEXQCMA S:LEXMOD="^^" LEXEXIT=1 Q:LEXMOD="^"!(LEXMOD="^^")  D  Q:LEXMOD="^"!(LEXMOD="^^")
 . K LEXGET,LEXST,LEXSD,LEXLD,LEXMD,LEXRAN,LEXLX,LEXWN N LEXIEN,LEXLDT,LEXELDT,LEXINC,LEXINCI,LEXINCF S (LEXINC,LEXINCI,LEXINCF)=0
 . S LEXIEN=+($G(LEXMOD)),LEXLDT=+($G(LEXCDT)) Q:+LEXIEN'>0  Q:LEXLDT'?7N  S LEXELDT=$$SD^LEXQM(LEXLDT) Q:'$L(LEXELDT)
 . S LEXINC=$$INC^LEXQCMA Q:LEXINC["^"  S:+LEXINC>0 LEXINCI=$$INCI^LEXQCMA S:+LEXINC>0 LEXINCF=$$INCF^LEXQCMA
 . D CSV,EN^LEXQCM2
 Q
CSV ; Code Set Versioning Display
 ; Needs LEXCDT Date 
 ;       LEXMOD CPT Modifier Internal Entry Number
 N LEXEDT,LEXIEN,LEXIENS,LEXLTXT,LEXSO,LEXSTA
 S LEXCDT=$G(LEXCDT),LEXEDT=$$ED^LEXQM(LEXCDT) I LEXCDT'?7N S (LEXMOD,LEXCDT)="" Q
 S LEXINC=+($G(LEXINC)),LEXINCI=+($G(LEXINCI)),LEXIEN=+($G(LEXMOD)),LEXSO=$P($G(LEXMOD),"^",2),LEXLTXT=$P($G(LEXMOD),"^",3)
 Q:+LEXIEN'>0  Q:'$L(LEXSO)
 ;
 ; Get the "Unversioned" Fields
 ;   Modifier                    Field .01
 S LEXIENS=LEXIEN_"," D GETS^DIQ(81.3,LEXIENS,".01","IE","LEXGET","LEXMSG")
 ; Get the "Versioned" Fields
 ;   Effective Date and Status   Sub-File 81.33   (60)
 S LEXST=$$EF(+($G(LEXIEN)),+LEXCDT),LEXSTA=+($P(LEXST,"^",2))
 ;   Modifier Name               Sub-File 81.361  (61)
 D SDS(+($G(LEXIEN)),+LEXCDT,.LEXSD,62,LEXSTA)
 ;   Description                 Sub-File 81.362  (62)
 D LDS(+($G(LEXIEN)),+LEXCDT,.LEXLD,62)
 D WN(+LEXCDT,.LEXWN,62)
 D:+($G(LEXINC))>0 CCR^LEXQCM2(+($G(LEXIEN)),+LEXCDT,.LEXRAN,62,+($G(LEXINCI)),+($G(LEXINCF)))
 Q
 ;            
EF(X,LEXCDT) ; Effective Dates
 N LEX,LEXAD,LEXBRD,LEXBRW,LEXEE,LEXEF,LEXES,LEXFA,LEXH,LEXI,LEXID,LEXIEN,LEXLS,LEXPE,LEXPH,LEXPI,LEXP0,LEXPS,LEXSO,LEXST
 S LEXIEN=+($G(X)),LEXCDT=+($G(LEXCDT)),LEXBRD=2890101,LEXBRW=""
 Q:+LEXIEN'>0 "^^"  Q:'$L($G(^DIC(81.3,+LEXIEN,0))) "^^"  Q:LEXCDT'?7N "^^"  S LEXSO=$P($G(^DIC(81.3,+LEXIEN,0)),"^",1)
 S LEXFA=$$FA(+LEXIEN),LEXPI=$O(^DIC(81.3,+LEXIEN,60,"B",(LEXCDT+.999999)),-1),LEXPH=$O(^DIC(81.3,+LEXIEN,60,"B",+LEXPI," "),-1)
 S LEXP0=$G(^DIC(81.3,+LEXIEN,60,+LEXPH,0)),LEXPS=$P(LEXP0,"^",2),LEXPE=$P(LEXP0,"^",1)
 S:LEXCDT<LEXBRD&(+LEXFA=LEXBRD) LEXBRW="Warning:  The 'Based on Date' provided precedes the initial Code Set Business Rule date of "_$$SD^LEXQM(LEXBRD)_", the Effective date may be inaccurate."
 S:LEXFA?7N&('$L(LEXPE))&('$L(LEXPS))&(LEXFA=LEXBRD) LEXPE=LEXFA,LEXPS=1
 I '$L(LEXPE),'$L(LEXPS) D  Q X
 . N LEXFA S LEXFA=$$FA(+LEXIEN)
 . S LEXST="",LEXEF="",LEXES="Not Applicable",LEXLS=-1
 . S LEXEE="" S:LEXFA?7N LEXEE="(future activation of "_$$SD^LEXQM(LEXFA)_")"
 . S X=LEXLS_"^"_LEXST_"^"_LEXEF_"^"_LEXES_"^"_LEXEE S:$L(LEXBRW) $P(X,"^",6)=LEXBRW
 S (LEXLS,LEXST)=LEXPS,LEXEF=LEXPE,LEXES=$S(+LEXST>0:"Active",1:"Inactive"),LEXEE=$$SD^LEXQM(LEXEF)
 S X=LEXLS_"^"_LEXST_"^"_LEXEF_"^"_LEXES_"^"_LEXEE S:$L(LEXBRW) $P(X,"^",6)=LEXBRW
 Q X
 ;            
SDS(X,LEXVDT,LEX,LEXLEN,LEXSTA) ; Modifier Name (short description)
 ;            
 ; LEX=# of Lines
 ; LEX(0)=External Date of Modifier Name
 ; LEX(#)=Modifier Name
 ;            
 N LEXD,LEXBRD,LEXBRW,LEXDDT,LEXE,LEXEE,LEXEFF,LEXFA,LEXHIS,LEXI,LEXIA,LEXIEN,LEXL,LEXLAST,LEXLEF,LEXLHI,LEXM,LEXR,LEXSDT,LEXSO,LEXLSD,LEXT
 S LEXIEN=$G(X) Q:+LEXIEN'>0  Q:'$D(^DIC(81.3,+LEXIEN,61))  S LEXVDT=+($G(LEXVDT)) S:LEXVDT'?7N LEXVDT=$$DT^XLFDT S LEXSTA=+($G(LEXSTA))
 S LEXSO=$P($G(^DIC(81.3,+LEXIEN,0)),"^",1),LEXLAST=$$MOD^ICPTMOD(+LEXIEN,"I",LEXVDT),LEXLSD=$P(LEXLAST,"^",3),LEXBRD=2890101
 S:$D(LEXGET)&($L(LEXLSD)) LEXGET(81.3,(+LEXIEN_","),"B")=LEXLSD
 S LEXLEN=+($G(LEXLEN)) S:+LEXLEN'>0 LEXLEN=62 S LEXFA=$$FA(+LEXIEN),LEXM=""
 S LEXM="" S:+LEXVDT<LEXFA&(LEXFA'=LEXBRD) LEXM="CPT Modifier Short Name is not available.  The date provided precedes the initial activation of the code"
 I $L(LEXM) D  Q
 . K LEX N LEXT,LEXI S LEXT(1)=LEXM D PR^LEXQM(.LEXT,(LEXLEN-7))
 . S LEXI=0 F  S LEXI=$O(LEXT(LEXI)) Q:+LEXI'>0  S LEXT=$G(LEXT(LEXI)) S LEX(LEXI)=LEXT
 . S:$D(LEX(1)) LEX(0)="--/--/----" S LEX=+($O(LEX(" "),-1))
 S LEXM="" S LEXEFF=$O(^DIC(81.3,LEXIEN,61,"B",(LEXVDT+.001)),-1),LEXHIS=$O(^DIC(81.3,LEXIEN,61,"B",+LEXEFF," "),-1),LEXSDT=$P($G(^DIC(81.3,+LEXIEN,61,+LEXHIS,0)),"^",2)
 S LEXLEF=$O(^DIC(81.3,LEXIEN,61,"B",(9999999+.001)),-1),LEXLHI=$O(^DIC(81.3,LEXIEN,61,"B",+LEXLEF," "),-1),LEXDDT=$P($G(^DIC(81.3,+LEXIEN,61,+LEXLHI,0)),"^",2)
 S (LEXD,LEXE,LEXR)="" S:$L(LEXSDT)&(LEXEFF?7N) LEXD=LEXSDT,LEXE=LEXEFF
 S:$L(LEXDDT)&(LEXLEF?7N)&('$L(LEXD))&('$L(LEXE)) LEXD=LEXDDT,LEXE=LEXLEF,LEXR="No Text Available for Date Provided"
 K LEX S LEX(1)=LEXD S:$L(LEXD) LEXGET(81.3,(+LEXIEN_","),"B")=LEXD S LEXEE=$$SD^LEXQM(LEXE)
 S:$D(LEXTEST)&(+($G(LEXSTA))'>0) LEXEE="--/--/----" S:$L(LEX(1)) LEX(0)=LEXEE
 S LEX=+($O(LEX(" "),-1))
 Q
LDS(X,LEXVDT,LEX,LEXLEN,LEXSTA) ; Long Description
 ;            
 ; LEX=# of Lines
 ; LEX(0)=External Date of Description
 ; LEX(#)=Description
 ; LEX(#)=Description continued
 ;            
 N LEXC,LEXBRD,LEXDDT,LEXEVDT,LEXFA,LEXI,LEXIEN,LEXL,LEXLT,LEXLN,LEXM,LEXT,LEXSO,LEXTL,LEXTMP S LEXIEN=$G(X) Q:+LEXIEN'>0  Q:'$D(^DIC(81.3,+LEXIEN,62))
 S LEXVDT=+($G(LEXVDT)) S:LEXVDT'?7N LEXVDT=$$DT^XLFDT S LEXEVDT=$$SD^LEXQM(LEXVDT),LEXLEN=+($G(LEXLEN)) S:+LEXLEN'>0 LEXLEN=62
 S LEXSO=$P($G(^DIC(81.3,+LEXIEN,0)),"^",1) S LEXFA=$$FA(+LEXIEN),LEXM=""  S LEXSTA=+($G(LEXSTA)),LEXBRD=2890101
 S LEXM="" S:+LEXVDT<LEXFA&(LEXFA'=LEXBRD) LEXM=" Modifier description is not available.  The date provided precedes the initial activation of the code" I $L(LEXM) D  Q
 . K LEX N LEXT,LEXI S LEXT(1)=LEXM D PR^LEXQM(.LEXT,(LEXLEN-7)) S LEXI=0 F  S LEXI=$O(LEXT(LEXI)) Q:+LEXI'>0  S LEXT=$G(LEXT(LEXI)) S LEX(LEXI)=LEXT
 . S:$D(LEX(1)) LEX(0)="--/--/----" S LEX=+($O(LEX(" "),-1))
 K LEXTMP S LEXLT=$$MODD^ICPTMOD(LEXIEN,"LEXTMP",,LEXVDT) S LEXL=+($O(LEXTMP(" "),-1)),LEXLN=$G(LEXTMP(+LEXL))
 S LEXM="" K:LEXL>0&(LEXLN["CODE TEXT MAY BE INACCURATE") LEXTMP(+LEXL)
 F LEXI=1:1:2 S LEXL=+($O(LEXTMP(" "),-1)),LEXLN=$$TM^LEXQM($G(LEXTMP(+LEXL))) K:LEXL>0&('$L(LEXLN)) LEXTMP(+LEXL)
 S LEXDDT=$O(^DIC(81.3,+LEXIEN,62,"B",(LEXVDT+.999999)),-1) S:LEXDDT'?7N LEXDDT=$O(^DIC(81.3,+LEXIEN,62,"B",0)) S:LEXDDT?7N LEXEVDT=$$SD^LEXQM(LEXDDT)
 D PR^LEXQM(.LEXTMP,LEXLEN) K LEX F LEXI=1:1:13 D
 . Q:'$D(LEXTMP(LEXI))  S LEXT=$$TM^LEXQM($G(LEXTMP(LEXI))),LEX(LEXI)=$$UP^XLFSTR(LEXT)
 I $L(LEXM) D
 . N LEXT,LEXI,LEXL,LEXC S LEXL=+($O(LEX(" "),-1)),LEXC=0 S LEXT(1)=LEXM D PR^LEXQM(.LEXT,(LEXLEN-7))
 . S LEXI=0 F  S LEXI=$O(LEXT(LEXI)) Q:+LEXI'>0  D
 . . S LEXT=$G(LEXT(LEXI)) S:$L(LEXT) LEXC=LEXC+1 S LEXL=LEXL+1,LEX(LEXL)=LEXT
 S:$D(LEXTEST)&(+($G(LEXSTA))'>0) LEXEVDT="--/--/----" S:$D(LEX(1)) LEX(0)=LEXEVDT S LEX=+($O(LEX(" "),-1))
 Q
WN(X,LEX,LEXLEN) ;   Warning
 ;            
 ; LEX=# of Lines
 ; LEX(0)=External Date
 ; LEX(#)=Warning
 ;            
 N LEXVDT,LEXIA,LEXTMP K LEX S LEXVDT=$G(X) Q:LEXVDT'?7N  S LEXIA=$$IA(LEXVDT) Q:+LEXIA'>0  S LEXLEN=+$G(LEXLEN) S:+LEXLEN>62 LEXLEN=62
 S LEXTMP(1)="Warning:  The 'Based on Date' provided precedes Code Set Versioning.  The Modifier Name and Description may be inaccurate for "_$$SD^LEXQM(LEXVDT)
 D PR^LEXQM(.LEXTMP,LEXLEN) K LEX S LEXI=0 F  S LEXI=$O(LEXTMP(LEXI)) Q:+LEXI'>0  S LEX(LEXI)=$G(LEXTMP(LEXI))
 S LEX=$O(LEX(" "),-1),LEX(0)=$$SD^LEXQM(LEXVDT)
 Q
 ; Miscellaneous
FA(X) ;   First Activation
 N LEXFA,LEXH,LEXI,LEXIEN,LEXSO S LEXIEN=+($G(X)) S X="",LEXSO=$P($G(^DIC(81.3,+LEXIEN,0)),"^",1) D HIST^ICPTAPIU(LEXSO,.LEXH) S LEXFA="",LEXI=0
 F  S LEXI=$O(LEXH(LEXI)) Q:+LEXI'>0!($L(LEXFA))  S:+($G(LEXH(LEXI)))>0&(LEXI?7N) LEXFA=LEXI Q:$L(LEXFA)
 S X=LEXFA
 Q X
IA(X) ;   Inaccurate
 N LEXBRD,LEXVDT,LEXSYS S LEXVDT=+($G(X)),LEXSYS=1,LEXVDT=$S($G(LEXVDT)="":$$DT^XLFDT,1:$$DBR(LEXVDT)),LEXBRD=3021001,X=$S(LEXVDT<LEXBRD:1,1:0)
 Q X
DBR(X) ;   Date Business Rules
 N LEXVDT S LEXVDT=$G(X) Q:'$G(LEXVDT)!($P(LEXVDT,".")'?7N) $$DT^XLFDT
 S:LEXVDT#10000=0 LEXVDT=LEXVDT+101 S:LEXVDT#100=0 LEXVDT=LEXVDT+1 S X=$S(LEXVDT<2890101:2890101,1:LEXVDT)
 Q X
EV(X) ;   Check environment
 N LEX S DT=$$DT^XLFDT D HOME^%ZIS S U="^" I +($G(DUZ))=0 W !!,?5,"DUZ not defined" Q 0
 S LEX=$$GET1^DIQ(200,(DUZ_","),.01) I '$L(LEX) W !!,?5,"DUZ not valid" Q 0
 Q 1
