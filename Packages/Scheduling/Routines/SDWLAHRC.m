SDWLAHRC ;;IOFO BAY PINES/TEH - EWL REPORT - COMPILE;06/12/2002 ; 20 Aug 2002 2:10 PM
 ;;5.3;scheduling;**419**;AUG 13 1993;Build 16
 ;
 ;
 ;
 ;
 ;
 ;
 ;
 ;
 ;
 ;=====================================================================================
 ;                                         NOTES
 ;=====================================================================================
 ;
 ;
 ;
 ;
 ;
 Q
COM ;START OF COMPILE - GET FIRST SORT
 N %H,DA
 S (SDWL0,SDWL1,SDWL2,SDWL3,SDWL4)="" K SDWLST
 F  S SDWL0=$O(^XTMP("SDWLAHR",SDWLJOB,SDWL0)) Q:SDWL0<1  D
 .F  S SDWL1=$O(^XTMP("SDWLAHR",SDWLJOB,SDWL0,SDWL1)) Q:SDWL1=""  D
 ..S SDWLTY=""
 ..I SDWL1["DAT" S SDWLTY="DAT"
 ..I SDWL1["NUM" S SDWLTY="NUM"
 ..I SDWL1["FT" S SDWLTY="FT"
 ..I SDWL1["RS" S SDWLTY="RS"
 ..I SDWL1["PRT" S SDWLTY="PRT"
 ..I SDWL1["ANM" S SDWLTY="ANM"
 ..I SDWLTY="" S SDWLTY="ERR"
 ..F  S SDWL2=$O(^XTMP("SDWLAHR",SDWLJOB,SDWL0,SDWL1,SDWL2)) Q:SDWL2=""  D
 ...F  S SDWL3=$O(^XTMP("SDWLAHR",SDWLJOB,SDWL0,SDWL1,SDWL2,SDWL3)) Q:SDWL3=""  D
 ....S SDWLX=$G(^XTMP("SDWLAHR",SDWLJOB,SDWL0,SDWL1,SDWL2,SDWL3))
 ....I SDWLTY["FT" S SDWL4="" F  S SDWL4=$O(^XTMP("SDWLAHR",SDWLJOB,SDWL0,SDWL1,SDWL2,SDWL3,SDWL4)) Q:SDWL4=""  D
 .....S SDWLX=$G(^XTMP("SDWLAHR",SDWLJOB,SDWL0,SDWL1,SDWL2,SDWL3,SDWL4))
 ....S SDWLST(SDWL0,SDWL2,SDWLX,SDWL1)=""
 D CHK
 D PRT
 K PG,S,SDWL0,SDWL1,SDWL2,SDWL3,SDWL4,SDWLA,SDWLBDT,SDWLEDT,SDWLIEN,SDWLIENS,SDWLJOB,SDWLMN,SDWLMX,SDWLNM,SDWLOK
 K SDWLR,SDWLTY,X,Y
 Q
CHK ;GET SORT LOGICAL
 S SDWLIEN=0 F  S SDWLIEN=$O(^SDWL(409.3,SDWLIEN)) Q:SDWLIEN<1  D  D SET1
 .S (SDWL0,SDWL1,SDWL2,SDWL3)=""
 .F  S SDWL0=$O(SDWLST(SDWL0)) Q:SDWL0<1  D
 ..S SDWLOK(SDWL0)=0
 ..F  S SDWL1=$O(SDWLST(SDWL0,SDWL1)) Q:SDWL1=""  D
 ...F  S SDWL2=$O(SDWLST(SDWL0,SDWL1,SDWL2)) Q:SDWL2=""  D
 ....F  S SDWL3=$O(SDWLST(SDWL0,SDWL1,SDWL2,SDWL3)) Q:SDWL3=""  D
 .....S SDWLNM="ZZ",SDWLTY=$S(SDWL3["PRT":"PRT",SDWL3["DAT":"DAT",SDWL3["RS":"RS",SDWL3["FT":"FT",SDWL3["NUM":"NUM",SDWL3["ANM":"ANM",1:"") D CHK1
 Q
CHK1 ;CHECK EWL PATIENT FILE
 I $D(SDWLTY),SDWLTY="FT" D  Q
 .S SDWLIENS=SDWLIEN_",",X=$$GET1^DIQ(409.3,SDWLIENS,SDWL1,"I") D
 ..I X[SDWL2 S SDWLOK(SDWL0)=1
 I $D(SDWLTY),SDWLTY="NUM" D  Q
 .S SDWLNM=$P(SDWL2,U),SDWLMX=$P(SDWL2,U,2),SDWLIENS=SDWLIEN_",",X=$$GET1^DIQ(409.3,SDWLIENS,SDWL1,"I") D
 ..I X'<SDWLMN&(X'>SDWLMX) S SDWLOK(SDWL0)=1
 I $D(SDWLTY),SDWLTY="DAT" D  Q
 .S SDWLBDT=$P(SDWL2,U),SDWLEDT=$P(SDWL2,U,2),SDWLIENS=SDWLIEN_",",X=$$GET1^DIQ(409.3,SDWLIENS,SDWL1,"I") D
 ..I X'<SDWLBDT&(X'>SDWLEDT) S SDWLOK(SDWL0)=1
 I $D(SDWLTY),SDWLTY="RS" D  Q
 .S SDWLIENS=SDWLIEN_",",X=$$GET1^DIQ(409.3,SDWLIENS,SDWL1,"I") I SDWL2=X S SDWLOK(SDWL0)=1
 I $D(SDWLTY),SDWLTY="PRT" D  Q
 .S SDWLIENS=SDWLIEN_",",X=$$GET1^DIQ(409.3,SDWLIENS,SDWL1,"I") I SDWL2=X S SDWLOK(SDWL0)=1
 I $D(SDWLTY),SDWLTY="ANM" D  Q
 .S SDWLIENS=SDWLIEN_",",X=$$GET1^DIQ(409.3,SDWLIENS,SDWL1,"I"),SDWLNM=$$GET1^DIQ(2,X_",","NAME","I") S SDWLOK(SDWL0)=1
 Q
SET1 ;
 S SDWLR=0,SDWLOK=1 F  S SDWLR=$O(SDWLOK(SDWLR)) Q:SDWLR<1  D
 .S S=SDWLOK(SDWLR) I 'S S SDWLOK=0
 I SDWLOK S ^XTMP("SDWLAHR",SDWLJOB,"LIST",SDWLNM,SDWLIEN)="",SDWL4=SDWL4+1
 Q
PRT S PG=0 D HD
 S SDWLA=0,SDWLNM="" K SDWLSTOP
 F  S SDWLNM=$O(^XTMP("SDWLAHR",SDWLJOB,"LIST",SDWLNM)) G END:$$S^ZTLOAD Q:SDWLNM=""  D  I $D(SDWLSTOP),'SDWLSTOP G END
 .F  S SDWLA=$O(^XTMP("SDWLAHR",SDWLJOB,"LIST",SDWLNM,SDWLA)) G END:$$S^%ZTLOAD Q:SDWLA<1  D  I $D(SDWLSTOP),'SDWLSTOP G END
 ..S DIC="^SDWL(409.3,",DA=SDWLA,DR=":" D EN^DIQ
 ..I $Y>(IOSL-5) D:IOST["C-"
 ...S DIR(0)="Y",DIR("A")="Do You Wish to Continue",DIR("B")="YES" D ^DIR D  I Y D HD Q
 ...S SDWLSTOP=Y
 Q
HD W:$D(IOF) @IOF
 W !!,?80-$L("EWL CUSTOM AD HOC REPORT")\2,"EWL CUSTOM AD HOC REPORT",?65 S PG=PG+1 W "PAGE: ",PG,!
 S %H=+$H D YX^%DTC W ?80-$L(Y)\2,Y,!!
 Q
END ;
 K DIR,DIC,DR,DIE,SDWLERR,SDWLF,SDWLX,SDLFD,SDWLCTX,SDWLDAT,SDWLPROM,SDWLINST,SDWLI,SDWLTAG,SDWLY
 Q
