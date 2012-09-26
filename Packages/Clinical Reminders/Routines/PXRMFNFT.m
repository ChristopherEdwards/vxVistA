PXRMFNFT ; SLC/PKR - Process found/not found text. ;10/05/2005
 ;;2.0;CLINICAL REMINDERS;**4**;Feb 04, 2005;Build 21
 ;
 ;===================================================
AGE(DFN,DEFARR,FIEVAL,NTXT) ;Output the age match/no match
 ;text.
 N CTIUO,FI,IC,LC,NIN,NLINES,TEXT,TEXTIN
 I '$D(FIEVAL("AGE")) Q
 S NLINES=0
 S IC=""
 F  S IC=$O(FIEVAL("AGE",IC)) Q:IC=""  D
 . S FI=$S(FIEVAL("AGE",IC):1,1:2)
 . S NIN=$P(DEFARR(7,IC,3),U,FI)
 . I +NIN=0 Q
 . K TEXTIN
 .;If CTIUO is true the text contains a TIU object.
 . S CTIUO=$S(NIN["T":1,1:0)
 . I CTIUO D
 .. N VSTR S VSTR=""
 ..;TIU expansion expects the trailing 0, i.e. TEXTIN(N,0).
 .. F LC=1:1:+NIN S TEXTIN(LC,0)=^PXD(811.9,PXRMITEM,7,IC,FI,LC,0)
 .. S NIN=NIN+1,TEXTIN(NIN,0)="\\"
 .. D FNFTXTO(1,DFN,"TEXTIN",VSTR,.NLINES,.TEXT)
 . I 'CTIUO D
 .. F LC=1:1:NIN S TEXTIN(LC)=^PXD(811.9,PXRMITEM,7,IC,FI,LC,0)
 .. S NIN=NIN+1,TEXTIN(NIN)="\\"
 .. D FNFTXTR(1,NIN,.TEXTIN,.NLINES,.TEXT)
 D COPYTXT^PXRMOUTU(.NTXT,NLINES,.TEXT)
 Q
 ;
 ;===================================================
FINDING(INDENT,DFN,FINDING,IFIEVAL,NLINES,TEXT) ;Output the finding found/not
 ;found text.
 N CTIUO,FI,LC,NIN,NODE,TEMP,TEXTIN
 S FI=$S(IFIEVAL:1,1:2)
 S NODE=$S(FINDING["FF":25,1:20)
 S TEMP=$G(DEFARR(NODE,FINDING,6))
 S NIN=$P(TEMP,U,FI)
 I +NIN=0 Q
 I FINDING["FF" S FINDING=$P(FINDING,"FF",2)
 S CTIUO=$S(NIN["T":1,1:0)
 I CTIUO D
 . S NIN=+NIN
 . N VSTR
 .;TIU expansion expects the trailing 0, i.e. TEXTIN(N,0).
 . F LC=1:1:+NIN S TEXTIN(LC,0)=^PXD(811.9,PXRMITEM,NODE,FINDING,FI,LC,0)
 . I $D(IFIEVAL("VISIT")) D
 .. N TEMP,VDATE,VLOC,VSC
 .. S TEMP=^AUPNVSIT(IFIEVAL("VISIT"),0)
 .. S VDATE=$P(TEMP,U,1)
 .. S VLOC=$P(TEMP,U,22)
 .. S VSC=$P(TEMP,U,7)
 .. S VSTR=VLOC_";"_VDATE_";"_VSC
 . E  S VSTR=""
 . S NIN=NIN+1,TEXTIN(NIN,0)="\\"
 . D FNFTXTO(INDENT,DFN,"TEXTIN",VSTR,.NLINES,.TEXT)
 I 'CTIUO D
 . F LC=1:1:NIN S TEXTIN(LC)=^PXD(811.9,PXRMITEM,NODE,FINDING,FI,LC,0)
 . S NIN=NIN+1,TEXTIN(NIN)="\\"
 . D FNFTXTR(INDENT,NIN,.TEXTIN,.NLINES,.TEXT)
 Q
 ;
 ;===================================================
FNFTXTO(INDENT,DFN,FNFGBL,VSTR,NLINES,TEXT) ;Load found/not found text
 ;that contains TIU objects.
 N OBJECT,LC,NUML,TA
 ;Make sure this works if it is being called a part of an object.
 I $D(^TMP("TIUBOIL",$J)) D
 . K ^TMP("PXRMTIUBOIL",$J)
 . M ^TMP("PXRMTIUBOIL",$J)=^TMP("TIUBOIL",$J)
 . S OBJECT=1
 E  S OBJECT=0
 K ^TMP("TIUBOIL",$J)
 D BLRPLT^TIUSRVD(.TA,"",DFN,VSTR,FNFGBL)
 S NUML=$P(^TMP("TIUBOIL",$J,0),U,3)
 I NUML=0 D  Q
 . K ^TMP("TIUBOIL",$J)
 . I OBJECT M ^TMP("TIUBOIL",$J)=^TMP("PXRMTIUBOIL",$J)
 . K ^TMP("PXRMTIUBOIL",$J)
 N NOUT,TEXTIN,TEXTOUT
 F LC=1:1:NUML S TEXTIN(LC)=^TMP("TIUBOIL",$J,LC,0)
 D FORMAT^PXRMTEXT(INDENT,PXRMRM,NUML,.TEXTIN,.NOUT,.TEXTOUT)
 F LC=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(LC)
 K ^TMP("TIUBOIL",$J)
 I OBJECT M ^TMP("TIUBOIL",$J)=^TMP("PXRMTIUBOIL",$J) K ^TMP("PXRMTIUBOIL",$J)
 Q
 ;
 ;===================================================
FNFTXTR(INDENT,NIN,TEXTIN,NLINES,TEXT) ;Load regular found/not found text
 ;that does not contain TIU objects.
 N JND,NOUT,TEXTOUT
 D FORMAT^PXRMTEXT(INDENT,PXRMRM,NIN,.TEXTIN,.NOUT,.TEXTOUT)
 F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
 Q
 ;
 ;===================================================
LOGIC(DFN,LOGSTR,LOGTYPE,TTYPE,DEFARR,NTXT) ;Output the detailed
 ;logic found/not found text.
 I LOGSTR="" Q
 N CTIUO,FI,LC,NIN,NLINES,SUB,TEXT,TEXTIN
 I TTYPE="S" S NIN=$S(LOGTYPE="PCL":DEFARR(72),LOGTYPE="RES":DEFARR(77),1:0)
 E  S NIN=$S(LOGTYPE="PCL":DEFARR(62),LOGTYPE="RES":DEFARR(67),1:0)
 I NIN="" Q
 S FI=$P(LOGSTR,U,1)
 S NIN=$S(FI=1:$P(NIN,U,1),FI=0:$P(NIN,U,2),1:0)
 I +NIN=0 Q
 I TTYPE="S" D
 . I LOGTYPE="PCL",FI=1 S SUB=70
 . I LOGTYPE="PCL",FI=0 S SUB=71
 . I LOGTYPE="RES",FI=1 S SUB=75
 . I LOGTYPE="RES",FI=0 S SUB=76
 E  D
 . I LOGTYPE="PCL",FI=1 S SUB=60
 . I LOGTYPE="PCL",FI=0 S SUB=61
 . I LOGTYPE="RES",FI=1 S SUB=65
 . I LOGTYPE="RES",FI=0 S SUB=66
 S NLINES=0
 S CTIUO=$S(NIN["T":1,1:0)
 I CTIUO D
 . N VSTR S VSTR=""
 .;TIU expansion expects the trailing 0, i.e. TEXTIN(N,0).
 . F LC=1:1:+NIN S TEXTIN(LC,0)=^PXD(811.9,PXRMITEM,SUB,LC,0)
 . S NIN=NIN+1,TEXTIN(NIN,0)="\\"
 . D FNFTXTO(1,DFN,"TEXTIN",VSTR,.NLINES,.TEXT)
 I 'CTIUO D
 . F LC=1:1:NIN S TEXTIN(LC)=^PXD(811.9,PXRMITEM,SUB,LC,0)
 . S NIN=NIN+1,TEXTIN(NIN)="\\"
 . D FNFTXTR(1,NIN,.TEXTIN,.NLINES,.TEXT)
 D COPYTXT^PXRMOUTU(.NTXT,NLINES,.TEXT)
 Q
 ;
 ;===================================================
SNMLA(RIEN) ;Set the number of match lines for the age match text.
 N IND,JND,LC,MATCHLC,NBAR,RES
 S IND=0
 F  S IND=+$O(^PXD(811.9,RIEN,7,IND)) Q:IND=0  D
 .;Age match text
 . S (JND,LC,NBAR)=0
 . F  S JND=$O(^PXD(811.9,RIEN,7,IND,1,JND)) Q:JND=""  D
 .. S NBAR=NBAR+$L(^PXD(811.9,RIEN,7,IND,1,JND,0),"|")-1
 .. S LC=LC+1
 .. I NBAR>1 S LC=LC_"T"
 . S MATCHLC=LC
 .;Age no match text
 . S (JND,LC,NBAR)=0
 . F  S JND=$O(^PXD(811.9,RIEN,7,IND,2,JND)) Q:JND=""  D
 .. S NBAR=NBAR+$L(^PXD(811.9,RIEN,7,IND,2,JND,0),"|")-1
 .. S LC=LC+1
 .. I NBAR>1 S LC=LC_"T"
 . S ^PXD(811.9,RIEN,7,IND,3)=MATCHLC_U_LC
 Q
 ;
 ;===================================================
SNMLF(RIEN,NODE) ;Set the number of found lines for the found text.
 ;For regular and functional findings.
 N FI,IND,JND,LC,NBAR,RES
 S IND=0
 F  S IND=+$O(^PXD(811.9,RIEN,NODE,IND)) Q:IND=0  D
 .;Found text
 . S (JND,LC,NBAR)=0
 . F  S JND=$O(^PXD(811.9,RIEN,NODE,IND,1,JND)) Q:JND=""  D
 .. S NBAR=NBAR+$L(^PXD(811.9,RIEN,NODE,IND,1,JND,0),"|")-1
 .. S LC=LC+1
 .. I NBAR>1 S LC=LC_"T"
 . S FI=LC
 .;Not found text
 . S (JND,LC,NBAR)=0
 . F  S JND=$O(^PXD(811.9,RIEN,NODE,IND,2,JND)) Q:JND=""  D
 .. S NBAR=NBAR+$L(^PXD(811.9,RIEN,NODE,IND,2,JND,0),"|")-1
 .. S LC=LC+1
 .. I NBAR>1 S LC=LC_"T"
 . S ^PXD(811.9,RIEN,NODE,IND,6)=FI_U_LC
 Q
 ;
 ;===================================================
SNMLL(RIEN) ;Set the number of lines for the logic found/not found
 ;text. Append a "T" to the number of lines if the text contains
 ;a TIU object.
 N CSTR,IND,LC,NBAR,RES,SUB
 ;SUB=60 General cohort found text
 ;SUB=61 General cohort not found text
 ;SUB=65 General resolution found text
 ;SUB=66 General resolution not found text
 ;SUB=70 Summary cohort found text
 ;SUB=71 Summary cohort not found text
 ;SUB=75 Summary resolution found text
 ;SUB=76 Summary resolution not found text
 F SUB=60,61,65,66,70,71,75,76 D
 . S (IND,LC,NBAR)=0
 . F  S IND=$O(^PXD(811.9,RIEN,SUB,IND)) Q:IND=""  D
 .. S NBAR=NBAR+$L(^PXD(811.9,RIEN,SUB,IND,0),"|")-1
 .. S LC=LC+1
 . I NBAR>1 S LC=LC_"T"
 . I SUB=60 S CSTR=LC
 . I SUB=61 S ^PXD(811.9,RIEN,62)=CSTR_U_LC
 . I SUB=65 S CSTR=LC
 . I SUB=66 S ^PXD(811.9,RIEN,67)=CSTR_U_LC
 . I SUB=70 S CSTR=LC
 . I SUB=71 S ^PXD(811.9,RIEN,72)=CSTR_U_LC
 . I SUB=75 S CSTR=LC
 . I SUB=76 S ^PXD(811.9,RIEN,77)=CSTR_U_LC
 Q
 ;
