PXRMEXLC ; SLC/PKR/PJH - Routines to display repository entry components. ;08/03/2007
 ;;2.0;CLINICAL REMINDERS;**4,6**;Feb 04, 2005;Build 123
 ;======================================================
BLDLIST(FORCE) ;Build a list of all repository entries.
 ;If FORCE is true then force rebuilding of the list.
 I FORCE K ^TMP("PXRMEXLR",$J)
 I $D(^TMP("PXRMEXLR",$J,"VALMCNT")) S VALMCNT=^TMP("PXRMEXLR",$J,"VALMCNT")
 E  D
 . D REXL^PXRMLIST("PXRMEXLR")
 . S VALMCNT=^TMP("PXRMEXLR",$J,"VALMCNT")
 Q
 ;
 ;======================================================
CDISP(IEN) ;Format component list for display.
 N CAT,CMPNT,END,EOKTI,EXISTS,FILENUM,FOKTI,IND,INDEX,JND,JNDS,KND
 N MSG,NCMPNT,NDLINE,NDSEL,NITEMS,NLINE,NSEL,PT01,START,TEMP,TEMP0,TYPE
 K ^TMP("PXRMEXLC",$J),^TMP("PXRMEXLD",$J)
 S (NDLINE,NLINE)=0
 S (NDSEL,NSEL)=1
 ;Load the description.
 F IND=1:1:$P(^PXD(811.8,IEN,110,0),U,4) D
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXLC",$J,NLINE,0)=^PXD(811.8,IEN,110,IND,0)
 . S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 S NLINE=NLINE+1
 S ^TMP("PXRMEXLC",$J,NLINE,0)=" "
 S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 S NCMPNT=^PXD(811.8,IEN,119)
 ;Load the text for display.
 F IND=1:1:NCMPNT D
 . S NLINE=NLINE+1
 . S TEMP=^PXD(811.8,IEN,120,IND,0)
 . S ^TMP("PXRMEXLC",$J,NLINE,0)=$P(TEMP,U,1)
 . S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 . S FILENUM=$P(TEMP,U,2)
 . S FOKTI=$$FOKTI^PXRMEXFI(FILENUM)
 . S NITEMS=$P(TEMP,U,3)
 . I $P(TEMP,U,1)="REMINDER DIALOG" D
 ..;Save details of the dialog in ^TMP("PXRMEXTMP")
 .. S JNDS=NITEMS D DBUILD^PXRMEXLB(IND,NITEMS,FILENUM)
 . E  S JNDS=1
 . F JND=JNDS:1:NITEMS D
 .. S TEMP=^PXD(811.8,IEN,120,IND,1,JND,0)
 .. S EOKTI=FOKTI
 .. S PT01=$P(TEMP,U,1)
 .. S EXISTS=$S(FILENUM=0:$$EXISTS^PXRMEXCF(PT01),1:$$EXISTS^PXRMEXIU(FILENUM,PT01,"W"))
 ..;If this is an education topic and it starts with VA- it
 ..;cannot be transported because of PCE's screen.
 .. ;I (FILENUM=9999999.09)&(PT01["VA-") S EOKTI=0
 ..;If this is a health factor see if it is a category.
 .. S CAT=""
 .. I (FILENUM=9999999.64) D
 ... S TYPE=""
 ... S START=$P(TEMP,U,2)
 ... S END=$P(TEMP,U,3)
 ... F KND=START:1:END D
 .... S TEMP0=$P(^PXD(811.8,IEN,100,KND,0),";",3)
 .... I $P(TEMP0,"~",1)=.1 S TYPE=$P(TEMP0,"~",2)
 ... I TYPE="CATEGORY" S CAT="X"
 .. S NLINE=NLINE+1
 .. I IND=1,JND=1 S NSEL=1,INDEX=$S(EOKTI:NSEL,1:"")
 .. E  D
 ...;If entries in this file are ok to install add them to the
 ...;selectable list. Make sure the first selectable entry exists
 ...;before incrementing NSEL.
 ... I EOKTI S NSEL=$S($D(^TMP("PXRMEXLC",$J,"SEL",1)):NSEL+1,1:NSEL),INDEX=NSEL
 ... E  S INDEX=""
 .. S ^TMP("PXRMEXLC",$J,NLINE,0)=$$FMTDATA(INDEX,PT01,CAT,EXISTS)
 .. S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 ..;Store the file number, node 120 indexes and the ien if it exists.
 .. I INDEX=NSEL S ^TMP("PXRMEXLC",$J,"SEL",NSEL)=FILENUM_U_IND_U_JND_U_EXISTS
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXLC",$J,NLINE,0)=""
 . S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 Q
 ;
 ;======================================================
FMTDATA(NSEL,PT01,CAT,EXISTS) ;Format items for display.
 N NSTI,TEMP
 S TEMP=$$RJ^XLFSTR(NSEL,4," ")_"  "_$E(PT01,1,54)
 I CAT="X" D
 . S NSTI=63-$L(TEMP)
 . S TEMP=TEMP_$$INSCHR(NSTI," ")_"X"
 I EXISTS D
 . S NSTI=75-$L(TEMP)
 . S TEMP=TEMP_$$INSCHR(NSTI," ")_"X"
 Q TEMP
 ;
 ;======================================================
INSCHR(NUM,CHR) ;Return a string of NUM characters (CHR).
 N IND,TEMP
 S TEMP=""
 I NUM<1 Q TEMP
 F IND=1:1:NUM S TEMP=TEMP_CHR
 Q TEMP
 ;
 ;======================================================
ORDER(STRING,ORDER) ;Rebuild string in ascending or descending order.
 N ARRAY,ITEM,CNT
 F CNT=1:1 S ITEM=$P(STRING,",",CNT) Q:'ITEM  S ARRAY(ITEM)=""
 K STRING
 F CNT=1:1 S ITEM=$O(ARRAY(ITEM),ORDER) Q:'ITEM  D
 .S $P(STRING,",",CNT)=ITEM
 Q
 ;
