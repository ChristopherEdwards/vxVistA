GMRYSE2 ;HIRMFO/YH-ITEMIZED PATIENT I/O REPORT BY SHIFT PART 3 ;3/11/97
 ;;4.0;Intake/Output;**2**;Apr 25, 1997
SUM ;
 S (GSAVEH,GCURDT,GDATE)=0 F II=0:0 S GDATE=$O(^TMP($J,"GMRY",GDATE)) D:GDATE'>0 SDATE Q:GMROUT!(GDATE'>0)  D:GCURDT'=GDATE SDATE Q:GMROUT  D SHIFT Q:GMROUT
 K GHOLD Q
SHIFT ;
 S (GCSFT,GSFT)="" F II=0:0 S GSFT=$O(^TMP($J,"GMRY",GDATE,GSFT)) D:GCSFT'=GSFT WSHIFT Q:GSFT=""!(GMROUT)  D CHKHD Q:GMROUT  S GSHIFT=$S(GSFT="SH-1":"NIGHT",GSFT="SH-2":"DAY",GSFT="SH-3":"EVENING",1:"   ") W ?2,GSHIFT_":",! D IOSUM Q:GMROUT
 Q
IOSUM ;
 S GIO="",(GPRT(1),GPRT(2),GPRT(3))=0 F II=0:0 S GIO=$O(^TMP($J,"GMRY",GDATE,GSFT,GIO)) Q:GIO=""!(GMROUT)  W ?4,"ITEMIZED "_$S(GIO="IV":"IV INTAKE",GIO="IN":"NON-IV INTAKE",GIO="OUT":"OUTPUT",1:""),! S GHOLD=0 D IOTIME Q:GMROUT
 Q
IOTIME ;
 S GHR=0 F II=0:0 S GHR=$O(^TMP($J,"GMRY",GDATE,GSFT,GIO,GHR)) Q:GHR'>0!(GMROUT)  S GOPT=$S(GIO="IN"!(GIO="OUT"):"IOTYPE",GIO="IV":"SUMIV",1:"") Q:GOPT=""  D @GOPT Q:GMROUT
 Q
IOTYPE ;
 S GTYPE="" F  S GTYPE=$O(^TMP($J,"GMRY",GDATE,GSFT,GIO,GHR,GTYPE)) Q:GTYPE=""!(GMROUT)  S GSUB=0 F  S GSUB=$O(^TMP($J,"GMRY",GDATE,GSFT,GIO,GHR,GTYPE,GSUB)) Q:GSUB'>0!(GMROUT)  D ADD Q:GMROUT
 Q
ADD ;
 I GIO="IN",$D(GTYPI(GTYPE)) D  Q
 . S GIN=GTYPI(GTYPE),GDATA=^TMP($J,"GMRY",GDATE,GSFT,GIO,GHR,GTYPE,GSUB),GAMOUNT=$P(GDATA,"^"),GIN(GIN)=GIN(GIN)+GAMOUNT,GTOTIN(GIN)=GTOTIN(GIN)+GAMOUNT
 . I GAMOUNT'>0,GAMOUNT'="0" S (GSIP(GIN),GDIP(GIN),GRNDIP)="+"
 . D NPOS^GMRYSE1 Q
 I GIO="OUT",$D(GOUT(GTYPE)) D  Q
 . S GDATA=^TMP($J,"GMRY",GDATE,GSFT,GIO,GHR,GTYPE,GSUB),GAMOUNT=$P(GDATA,"^"),GOUT(GTYPE)=GOUT(GTYPE)+GAMOUNT,GTOTOUT(GTYPE)=GTOTOUT(GTYPE)+GAMOUNT
 . I GAMOUNT'>0,GAMOUNT'="0" S (GSOP(GTYPE),GDOP(GTYPE),GRNDOP)="+"
 . D NPOS^GMRYSE1 Q
 I GIO="IV" D  Q
 . S GAMOUNT=GAMT Q:GAMOUNT>2000000  S GIN(GIN)=GIN(GIN)+GAMOUNT,GTOTIN(GIN)=GTOTIN(GIN)+GAMOUNT
 . I $P(GDATA,"^",6)="*" S (GSIP(GIN),GDIP(GIN),GRNDIP)="+"
 Q
SUMIV ;
 S GIVDT=0 F II=0:0 S GIVDT=$O(^TMP($J,"GMRY",GDATE,GSFT,GIO,GHR,GIVDT)) Q:GIVDT'>0!(GMROUT)  D IVLINE Q:GMROUT
 Q
IVLINE ;
 S GIVTYP="" F  S GIVTYP=$O(^TMP($J,"GMRY",GDATE,GSFT,GIO,GHR,GIVDT,GIVTYP)) Q:GIVTYP=""!(GMROUT)  S GSUB=0 F  S GSUB=$O(^TMP($J,"GMRY",GDATE,GSFT,GIO,GHR,GIVDT,GIVTYP,GSUB)) Q:GSUB'>0!GMROUT  D WIVINF^GMRYSE3 Q:GMROUT
 Q
WSHIFT ;
 D CHKHD Q:GMROUT
 I GCSFT="" S GCSFT=GSFT Q
 D CHKHD Q:GMROUT  W !,?2,"*** ",GSHIFT," shift total: ",! D CHKHD Q:GMROUT
 W ?6,"Intake:",! F II=1:1:GN(1) Q:GMROUT  D
 . I GIN(II)>0!(GSIP(II)="+") D CHKHD Q:GMROUT  D ILABEL^GMRYSE1 W ?8,GLAB," ",$E(GMRDOT,1,18-$L(GLAB)),?25," ",$S(GIN(II)=0&(GSIP(II)="+"):GSIP(II),1:GIN(II)_GSIP(II))_" mls",!
 Q:GMROUT
 D CHKHD Q:GMROUT  W ?6,"Output:",! F II=1:1:GN(2) D  G:GMROUT Q2
 . I GOUT(II)>0!(GSOP(II)="+") D CHKHD Q:GMROUT  D OLABEL^GMRYSE1 W ?8,GLAB," ",$E(GMRDOT,1,18-$L(GLAB)),?25," ",$S(GOUT(II)=0&(GSOP(II)="+"):GSOP(II),1:GOUT(II)_GSOP(II))_" mls",!
 S:GSFT'="" GCSFT=GSFT D INISHFT^GMRYRP3,SHFTP^GMRYSE1
Q2 Q
SDATE ;
 I GCURDT=0 S GCURDT=GDATE S GY=$E(GCURDT,4,5)_"/"_$E(GCURDT,6,7)_"/"_$E(GCURDT,2,3) W GY,! Q
 D DAYTOT Q:GDATE'>0!(GMROUT)  S GCURDT=GDATE,GY=$E(GCURDT,4,5)_"/"_$E(GCURDT,6,7)_"/"_$E(GCURDT,2,3) D CHKHD Q:GMROUT  W GMRX,!,GY,!
 Q
DAYTOT ;
 D CHKHD Q:GMROUT  W $E(GMRX,1,21),!,"Summary for: ",GY,! D CHKHD Q:GMROUT  W ?2,"Intake:",! S GTOTLI=0 F II=1:1:GN(1) Q:GMROUT  I GTOTIN(II)>0!(GDIP(II)="+") D CHKHD Q:GMROUT  D ILABEL^GMRYSE1,WRITEI
 Q:GMROUT  I GRPT<9 D CHKHD Q:GMROUT  W ?2,"Output:",! S GTOTLO=0 F II=1:1:GN(2) I GTOTOUT(II)>0!(GDOP(II)="+") D CHKHD G:GMROUT Q3 D OLABEL^GMRYSE1 D
 . W ?4,GLAB," ",$E(GMRDOT,1,18-$L(GLAB)),?25," ",$S(GTOTOUT(II)=0&(GDOP(II)="+"):GDOP(II),1:GTOTOUT(II)_GDOP(II))_" mls",! S GTOTLO=GTOTLO+GTOTOUT(II)
 D CHKHD Q:GMROUT  W ?2,"Total intake measured: ",$S(GTOTLI=0&(GRNDIP="+"):GRNDIP,1:GTOTLI_GRNDIP)_" mls",! D:GRPT<9 CHKHD Q:GMROUT  W:GRPT<9 ?2,"Total output measured: ",$S(GTOTLO=0&(GRNDOP="+"):GRNDOP,1:GTOTLO_GRNDOP)_" mls",!
 D INITOT^GMRYRP3,DAYP^GMRYSE1 S (GRNDIP,GRNDOP)=""
Q3 Q
CHKHD ;
 I ($Y+10)>IOSL D HEADER2^GMRYSE1
 Q
WRITEI W ?4,GLAB," ",$E(GMRDOT,1,18-$L(GLAB)),?25," ",$S(GTOTIN(II)=0&(GDIP(II)="+"):GDIP(II),1:GTOTIN(II)_GDIP(II))_" mls",! S GTOTLI=GTOTLI+GTOTIN(II) Q
