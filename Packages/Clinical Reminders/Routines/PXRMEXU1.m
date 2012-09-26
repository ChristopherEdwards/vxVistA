PXRMEXU1 ; SLC/PKR/PJH - Reminder exchange repository utilities, #1.;08/16/2007
 ;;2.0;CLINICAL REMINDERS;**6**;Feb 04, 2005;Build 123
 ;=====================================================
CLIST(IEN) ;Build the list of components for the repository
 ;entry IEN. EXTYPE is the type of Exchange entry. The default is
 ;reminder.
 N COMIND,COMORDR,CSTART,CSUM,END,FILENAME,FILENUM
 N IND,INDEXAT,JND,LINE,NCMPNT,NCTYPE,NITEMS,NLINES,NUMCMPNT
 N PT01,START,TEMP,TAG,TYPE,UCOM,VERSN
 S LINE=^PXD(811.8,IEN,100,1,0)
 ;Make sure it is XML version 1.
 I LINE'["<?xml version=""1.0""" D  Q
 . W !,"Exchange file entry not in proper format!"
 . S IEN=-1
 . H 2
 S LINE=^PXD(811.8,IEN,100,2,0)
 I LINE'="<REMINDER_EXCHANGE_FILE_ENTRY>" D  Q
 . W !,"Not an Exchange File entry!"
 . S IEN=-1
 . H 2
 S LINE=^PXD(811.8,IEN,100,3,0)
 S VERSN=$$GETTAGV^PXRMEXU3(LINE,"<PACKAGE_VERSION>")
 S LINE=^PXD(811.8,IEN,100,4,0)
 S INDEXAT=+$P(LINE,"<INDEX_AT>",2)
 S LINE=^PXD(811.8,IEN,100,INDEXAT,0)
 I LINE'="<INDEX>" D  Q
 . W !,"Index missing, cannot continue!"
 . S IEN=-1
 . H 2
 S JND=INDEXAT+1
 S LINE=^PXD(811.8,IEN,100,JND,0)
 S NCMPNT=+$$GETTAGV^PXRMEXU3(LINE,"<NUMBER_OF_COMPONENTS>")
 K ^TMP($J,"CMPNT")
 F IND=1:1:NCMPNT D
 . K END,START
 . F  S JND=JND+1,LINE=^PXD(811.8,IEN,100,JND,0) Q:LINE="</COMPONENT>"  D
 .. S TAG=$$GETTAG^PXRMEXU3(LINE)
 .. I TAG["START" S START(TAG)=+$$GETTAGV^PXRMEXU3(LINE,TAG)
 .. I TAG["END" S END(TAG)=+$$GETTAGV^PXRMEXU3(LINE,TAG)
 . I $D(START("<M_ROUTINE_START>")) D
 .. S CSTART=START("<M_ROUTINE_START>")
 .. S ^TMP($J,"CMPNT",IND,"TYPE")="ROUTINE"
 .. S LINE=^PXD(811.8,IEN,100,CSTART+1,0)
 .. S ^TMP($J,"CMPNT",IND,"NAME")=$$GETTAGV^PXRMEXU3(LINE,"<ROUTINE_NAME>")
 .. S ^TMP($J,"CMPNT",IND,"FILENUM")=0
 ..;Save the actual start and end of the code.
 .. S ^TMP($J,"CMPNT",IND,"START")=START("<ROUTINE_CODE_START>")
 .. S ^TMP($J,"CMPNT",IND,"END")=END("<ROUTINE_CODE_END>")
 . I $D(START("<FILE_START>")) D
 .. S CSTART=START("<FILE_START>")
 .. S LINE=^PXD(811.8,IEN,100,CSTART+1,0)
 .. S (^TMP($J,"CMPNT",IND,"TYPE"),^TMP($J,"CMPNT",IND,"FILENAME"))=$$GETTAGV^PXRMEXU3(LINE,"<FILE_NAME>",1)
 .. S LINE=^PXD(811.8,IEN,100,CSTART+2,0)
 .. S ^TMP($J,"CMPNT",IND,"FILENUM")=$$GETTAGV^PXRMEXU3(LINE,"<FILE_NUMBER>")
 .. S LINE=^PXD(811.8,IEN,100,CSTART+3,0)
 .. S (^TMP($J,"CMPNT",IND,"NAME"),^TMP($J,"CMPNT",IND,"POINT_01"))=$$GETTAGV^PXRMEXU3(LINE,"<POINT_01>",1)
 ..;Save the actual start and end of the FileMan FDA.
 .. S ^TMP($J,"CMPNT",IND,"FDA_START")=START("<FDA_START>")
 .. S ^TMP($J,"CMPNT",IND,"FDA_END")=END("<FDA_END>")
 .. S ^TMP($J,"CMPNT",IND,"IEN_ROOT_START")=$G(START("<IEN_ROOT_START>"))
 .. S ^TMP($J,"CMPNT",IND,"IEN_ROOT_END")=$G(END("<IEN_ROOT_END>"))
 ;Build some indexes to order the component list.
 F IND=1:1:NCMPNT D
 . S TYPE=^TMP($J,"CMPNT",IND,"TYPE")
 . S COMIND(TYPE,IND)=""
 . S UCOM(TYPE)=""
 ;Build the component order for display and install.
 D CORDER^PXRMEXCO(IEN,.UCOM,.NUMCMPNT,.COMORDR)
 ;Set the 0 node.
 S ^PXD(811.8,IEN,120,0)=U_"811.802A"_U_NCMPNT_U_NCMPNT
 S NCTYPE=0
 S NITEMS=0
 F NCTYPE=1:1:NUMCMPNT D
 . S TYPE=$O(COMORDR(NCTYPE,""))
 . S NITEMS=0
 . S IND=""
 . F  S IND=$O(COMIND(TYPE,IND)) Q:IND=""  D
 .. S NITEMS=NITEMS+1
 .. I NITEMS=1 S FILENUM=^TMP($J,"CMPNT",IND,"FILENUM")
 .. I TYPE="ROUTINE" S TEMP=^TMP($J,"CMPNT",IND,"NAME")_U_^TMP($J,"CMPNT",IND,"START")_U_^TMP($J,"CMPNT",IND,"END")
 .. E  S TEMP=^TMP($J,"CMPNT",IND,"NAME")_U_^TMP($J,"CMPNT",IND,"FDA_START")_U_^TMP($J,"CMPNT",IND,"FDA_END")_U_$G(^TMP($J,"CMPNT",IND,"IEN_ROOT_START"))_U_$G(^TMP($J,"CMPNT",IND,"IEN_ROOT_END"))
 .. S ^PXD(811.8,IEN,120,NCTYPE,1,NITEMS,0)=TEMP
 . S ^PXD(811.8,IEN,120,NCTYPE,0)=TYPE_U_FILENUM_U_NITEMS
 . S ^PXD(811.8,IEN,120,NCTYPE,1,0)=U_"811.8021A"_U_NITEMS_U_NITEMS
 ;
 ;Save the number of component types.
 S ^PXD(811.8,IEN,119)=NCTYPE
 K ^TMP($J,"CMPNT")
 Q
 ;
 ;=====================================================
DELETE(LIST) ;Delete the repository entries in LIST.
 N DA,DIK
 S DIK="^PXD(811.8,"
 S DA=""
 F  S DA=$O(LIST(DA)) Q:+DA=0  D ^DIK
 Q
 ;
 ;=====================================================
DELHIST(RIEN,IHIEN) ;Delete install history IHIEN in repository entry RIEN.
 N DA,DIK
 S DA=IHIEN,DA(1)=RIEN
 S DIK="^PXD(811.8,"_DA(1)_",130,"
 D ^DIK
 Q
 ;
 ;=====================================================
DESC(RIEN,DESL,DESC,KEYWORD) ;Build the description.
 N JND,LC,NKEYW
 S LC=1
 S ^PXD(811.8,RIEN,110,LC,0)="Reminder:    "_DESL("RNAME")
 S LC=LC+1
 S ^PXD(811.8,RIEN,110,LC,0)="Source:      "_DESL("SOURCE")
 S LC=LC+1
 S ^PXD(811.8,RIEN,110,LC,0)="Date Packed: "_DESL("DATEP")
 S LC=LC+1
 S ^PXD(811.8,RIEN,110,LC,0)="Package Version: "_DESL("VRSN")
 S LC=LC+1
 S ^PXD(811.8,RIEN,110,LC,0)=""
 ;Add the user's description.
 S LC=LC+1
 S ^PXD(811.8,RIEN,110,LC,0)="Description:"
 F JND=1:1:+$P($G(@DESC@(1,0)),U,4) D
 . S LC=LC+1
 . S ^PXD(811.8,RIEN,110,LC,0)=@DESC@(1,JND,0)
 S LC=LC+1
 S ^PXD(811.8,RIEN,110,LC,0)=""
 ;Add the keywords.
 S LC=LC+1
 S ^PXD(811.8,RIEN,110,LC,0)="Keywords:"
 S NKEYW=+$P($G(@KEYWORD@(1,0)),U,4)
 I NKEYW=0 D
 . S LC=LC+1
 . S ^PXD(811.8,RIEN,110,LC,0)="No keywords given"
 F JND=1:1:NKEYW D
 . S LC=LC+1
 . S ^PXD(811.8,RIEN,110,LC,0)=@KEYWORD@(1,JND,0)
 S LC=LC+1
 S ^PXD(811.8,RIEN,110,LC,0)=""
 S LC=LC+1
 S ^PXD(811.8,RIEN,110,LC,0)="Components:"
 S ^PXD(811.8,RIEN,110,0)=U_811.804_U_LC_U_LC
 Q
 ;
 ;=====================================================
RIEN(LIEN) ;Given the list ien return the repository ien.
 N RIEN
 S RIEN=$G(^TMP("PXRMEXLR",$J,"SEL",LIEN))
 Q RIEN
 ;
 ;=====================================================
SAVHIST ;Save the installation history in the repository.
 N ACTION,DATE,CMPNT,FTYPE,IND,INDEX,ITEM,JND,NEWNAME
 N SUB,TEMP,TOTAL,TYPE,USER
 ;Find the first open spot in the Installation History node.
 S (IND,JND)=0
 F  S IND=+$O(^PXD(811.8,PXRMRIEN,130,IND)) S JND=JND+1 Q:(IND=0)!(IND>JND)
 S IND=JND
 S JND=0
 F SUB="PXRMEXIA","PXRMEXIAD" D
 . S INDEX=0
 . F  S INDEX=$O(^TMP(SUB,$J,INDEX)) Q:+INDEX=0  D
 .. S JND=JND+1
 .. S CMPNT=$O(^TMP(SUB,$J,INDEX,""))
 .. S ITEM=$O(^TMP(SUB,$J,INDEX,CMPNT,""))
 .. S ACTION=$O(^TMP(SUB,$J,INDEX,CMPNT,ITEM,""))
 .. S NEWNAME=$G(^TMP(SUB,$J,INDEX,CMPNT,ITEM,ACTION))
 .. S ^PXD(811.8,PXRMRIEN,130,IND,1,JND,0)=INDEX_U_CMPNT_U_ITEM_U_ACTION_U_NEWNAME
 ..;Set the 0 node.
 .. S ^PXD(811.8,PXRMRIEN,130,IND,1,0)=U_"811.8031A"_U_JND_U_JND
 ..;Check for finding item changes and save them.
 .. S FTYPE=""
 .. I CMPNT["DEFINITION" S FTYPE="DEFF"
 .. I CMPNT["DIALOG" S FTYPE="DIAF"
 .. I CMPNT["TERM" S FTYPE="TRMF"
 .. I (FTYPE'=""),($D(^TMP(SUB,$J,FTYPE))) D
 ... N FI,FINDING,KND,OFINDING
 ... S KND=2
 ... S FI=""
 ... F  S FI=$O(^TMP(SUB,$J,FTYPE,FI)) Q:FI=""  D
 .... S OFINDING=$O(^TMP(SUB,$J,FTYPE,FI,""))
 .... S FINDING=^TMP(SUB,$J,FTYPE,FI,OFINDING)
 .... I OFINDING=FINDING Q
 .... S KND=KND+1
 .... S TEMP=$E(OFINDING,1,33)
 .... S ^PXD(811.8,PXRMRIEN,130,IND,1,JND,1,KND,0)="    "_TEMP_$$INSCHR^PXRMEXLC((35-$L(TEMP))," ")_FINDING
 ... S ^PXD(811.8,PXRMRIEN,130,IND,1,JND,1,0)=U_"811.80315A"_U_KND_U_KND
 ... I KND>2 D
 .... S ^PXD(811.8,PXRMRIEN,130,IND,1,JND,1,1,0)="   Finding Changes"
 .... S ^PXD(811.8,PXRMRIEN,130,IND,1,JND,1,2,0)="     Original"_$$INSCHR^PXRMEXLC(27," ")_"New"
 ..;
 ..;Check for TIU template replacements and save them.
 .. I CMPNT["DIALOG" S FTYPE="DIATIU"
 .. E  S FTYPE=""
 .. I (FTYPE'=""),($D(^TMP(SUB,$J,FTYPE))) D
 ... N KND,OTIUT,TIUT,TYPE
 ... S TYPE=""
 ... S KND=2
 ... F  S TYPE=$O(^TMP(SUB,$J,FTYPE,TYPE)) Q:TYPE=""  D
 .... S OTIUT=""
 .... F  S OTIUT=$O(^TMP(SUB,$J,FTYPE,TYPE,OTIUT)) Q:OTIUT=""  D
 ..... S TIUT=$G(^TMP(SUB,$J,FTYPE,TYPE,OTIUT))
 ..... I OTIUT=TIUT Q
 ..... I '$D(^TMP(SUB,$J,FTYPE,TYPE,OTIUT,ITEM)) Q
 ..... S KND=KND+1
 ..... S TEMP=$E(OTIUT,1,33)
 ..... S ^PXD(811.8,PXRMRIEN,130,IND,1,JND,1,KND,0)="    "_TEMP_$$INSCHR^PXRMEXLC((35-$L(TEMP))," ")_TIUT
 .... S ^PXD(811.8,PXRMRIEN,130,IND,1,JND,1,0)=U_"811.80315A"_U_KND_U_KND
 .... I KND>2 D
 ..... S ^PXD(811.8,PXRMRIEN,130,IND,1,JND,1,1,0)="   "_TYPE
 ..... S ^PXD(811.8,PXRMRIEN,130,IND,1,JND,1,2,0)="     Original"_$$INSCHR^PXRMEXLC(27," ")_"New"
 ;If JND is still 0 then there was nothing to save.
 I JND>0 D
 .;Save the header information.
 . S DATE=^TMP("PXRMEXIA",$J,"DT")
 . S TYPE=^TMP("PXRMEXIA",$J,"TYPE")
 . S USER=$$GET1^DIQ(200,DUZ,.01,"")
 . S ^PXD(811.8,PXRMRIEN,130,IND,0)=DATE_U_USER_U_TYPE
 . S ^PXD(811.8,PXRMRIEN,130,"B",DATE,IND)=""
 .;Set the 0 node.
 . S (KND,TOTAL)=0
 . F  S KND=+$O(^PXD(811.8,PXRMRIEN,130,KND)) Q:KND=0  S TOTAL=TOTAL+1
 . S ^PXD(811.8,PXRMRIEN,130,0)=U_"811.803DA"_U_IND_U_TOTAL
 K ^TMP("PXRMEXIA",$J)
 K ^TMP("PXRMEXIAD",$J)
 Q
 ;
