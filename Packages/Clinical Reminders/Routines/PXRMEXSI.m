PXRMEXSI ; SLC/PKR/PJH - Silent repository entry install. ;09/28/2007
 ;;2.0;CLINICAL REMINDERS;**6**;Feb 04, 2005;Build 123
 ;
 ;===================================================
INITMPG ;Initialize ^TMP arrays.
 K ^TMP("PXRMEXFND",$J)
 K ^TMP("PXRMEXIA",$J)
 K ^TMP("PXRMEXIAD",$J)
 K ^TMP("PXRMEXLC",$J)
 K ^TMP("PXRMEXLD",$J)
 K ^TMP("PXRMEXTMP",$J)
 Q
 ;
 ;===================================================
INSCOM(PXRMRIEN,ACTION,IND,TEMP,REMNAME,HISTSUB) ;Install component IND
 ;of PXRMRIEN.
 N ATTR,END,EXISTS,FILENUM,IND120,JND120,NAME
 N PT01,RTN,SAME,START,TEXT
 S FILENUM=$P(TEMP,U,1),EXISTS=$P(TEMP,U,4)
 S IND120=$P(TEMP,U,2),JND120=$P(TEMP,U,3)
 I (IND120="")!(JND120="") Q
 S TEMP=^PXD(811.8,PXRMRIEN,120,IND120,1,JND120,0)
 ;If the component does not exist then the action has to be "I".
 ;If the component exists and the action is "I" change it to "O".
 ;If the component exists and the action is "M" leave it "M".
 ;If the component exists and the action is "O" leave it "O".
 S ACTION=$S('EXISTS:"I",ACTION="I":"O",1:ACTION)
 S SAME=0
 S START=$P(TEMP,U,2)
 S END=$P(TEMP,U,3)
 I FILENUM=0 D
 . D RTNLD^PXRMEXIC(PXRMRIEN,START,END,.ATTR,.RTN)
 . I EXISTS D
 .. D CHECKSUM^PXRMEXCS(.ATTR,START,END)
 .. S CSUM=$$RTNCS^PXRMEXCS(ATTR("NAME"))
 .. I ATTR("CHECKSUM")=CSUM S SAME=1,ACTION="S"
 . S ^TMP("PXRMEXIA",$J,IND,"ROUTINE",ATTR("NAME"),ACTION)=""
 E  D 
 . S TEMP=^PXD(811.8,PXRMRIEN,100,START,0)
 . S PT01=$P(TEMP,"~",2)
 .;Save reminder name for dialog install.
 . I FILENUM=811.9 S REMNAME=PT01
 . D SETATTR^PXRMEXFI(.ATTR,FILENUM,PT01)
 . I EXISTS D
 .. D CHECKSUM^PXRMEXCS(.ATTR,START,END)
 .. S CSUM=$$FILE^PXRMEXCS(ATTR("FILE NUMBER"),EXISTS)
 .. I ATTR("CHECKSUM")=CSUM S SAME=1,ACTION="S"
 .;Save what was done for the installation summary.
 . S ^TMP(HISTSUB,$J,IND,ATTR("FILE NAME"),PT01,ACTION)=""
 ;If the packed component and the installed component are the same
 ;there is nothing to do.
 I SAME Q
 ;Install this component.
 I FILENUM=0 D RTNSAVE^PXRMEXIC(.RTN,ATTR("NAME"))
 E  D FILE^PXRMEXIC(PXRMRIEN,EXISTS,IND120,JND120,ACTION,.ATTR,.PXRMNMCH)
 Q
 ;
 ;===================================================
INSDLG(PXRMRIEN,ACTION) ;Install dialog components directly
 ;from the "SEL" array.
 N IND,FILENUM,ITEMP,NAME,REMNAME,TEMP
 ;Build the selection array in ^TMP("PXRMEXLD",$J,"SEL"). For dialogs
 ;the selection array is: 
 ;file no.^FDA start^FDA end^EXISTS^IND120^JND120^NAME
 D BLDDISP^PXRMEXD1(0)
 ;Work through the selection array installing the dialog parts
 ;in reverse order.
 S IND=""
 F  S IND=$O(^TMP("PXRMEXLD",$J,"SEL",IND),-1) Q:(IND="")!(PXRMDONE)  D
 . S TEMP=^TMP("PXRMEXLD",$J,"SEL",IND)
 . S FILENUM=$P(TEMP,U,1),NAME=$P(TEMP,U,7)
 .;Dialog elements may be used more than once in a dialog so make sure
 .;the element has not already been installed.
 . S ITEMP=$P(TEMP,U,1)_U_$P(TEMP,U,5,6)_U_$$EXISTS^PXRMEXIU(FILENUM,NAME)
 . D INSCOM(PXRMRIEN,ACTION,IND,ITEMP,.REMNAME,"PXRMEXIAD")
 Q
 ;
 ;===================================================
INSTALL(PXRMRIEN,ACTION,NOR) ;Install all components in a repository entry.
 ;If NOR is true do not install routines.
 N DNAME,FILENUM,IND,PXRMDONE,PXRMNMCH,REMNAME,TEMP
 S PXRMDONE=0
 S NOR=$G(NOR)
 ;Initialize ^TMP globals.
 D INITMPG
 ;Build the component list.
 K ^PXD(811.8,PXRMRIEN,100,"B")
 K ^PXD(811.8,PXRMRIEN,120)
 D CLIST^PXRMEXU1(.PXRMRIEN)
 I PXRMRIEN=-1 Q
 ;Build the selectable list.
 D CDISP^PXRMEXLC(PXRMRIEN)
 ;Set the install date and time and type.
 S ^TMP("PXRMEXIA",$J,"DT")=$$NOW^XLFDT
 S ^TMP("PXRMEXIA",$J,"TYPE")="SILENT"
 ;Initialize the name change storage.
 K PXRMNMCH
 S IND=0
 F  S IND=$O(^TMP("PXRMEXLC",$J,"SEL",IND)) Q:(IND="")!(PXRMDONE)  D
 . S TEMP=^TMP("PXRMEXLC",$J,"SEL",IND)
 . S FILENUM=$P(TEMP,U,1)
 .;If NOR is true do not install routines.
 . I FILENUM=0,NOR Q
 . ;Install dialog components
 . I FILENUM=801.41 N PXRMDONE S PXRMDONE=0 D INSDLG(PXRMRIEN,ACTION) Q
 . ;Install component
 . E  D INSCOM(PXRMRIEN,ACTION,IND,TEMP,.REMNAME,"PXRMEXIA")
 ;
 ;Get the dialog name
 S DNAME=$G(^TMP("PXRMEXTMP",$J,"PXRMDNAM"))
 ;Link the dialog if it exists
 I DNAME'="" D
 . N DIEN,RIEN
 .;Get the dialog ien
 . S DIEN=$$EXISTS^PXRMEXIU(801.41,DNAME) Q:'DIEN
 .;Get the reminder ien
 . S RIEN=+$$EXISTS^PXRMEXIU(811.9,$G(REMNAME)) Q:'RIEN
 . I RIEN>0 D
 .. N DA,DIE,DIK,DR
 ..;Set reminder to dialog pointer
 .. S DR="51///^S X=DNAME",DIE="^PXD(811.9,",DA=RIEN
 .. D ^DIE
 ;
 ;Save the install history.
 D SAVHIST^PXRMEXU1
 ;If any components were skipped send the message.
 I $D(^TMP("PXRMEXNI",$J)) D
 . N NE,XMSUB
 . S NE=$O(^TMP("PXRMEXNI",$J,""),-1)+1
 . S ^TMP("PXRMEXNI",$J,NE,0)="Please review and make changes as necessary."
 . K ^TMP("PXRMXMZ",$J)
 . M ^TMP("PXRMXMZ",$J)=^TMP("PXRMEXNI",$J)
 . S XMSUB="COMPONENTS SKIPPED DURING SILENT MODE INSTALL"
 . D SEND^PXRMMSG(XMSUB)
 ;Cleanup TMP globals.
 D INITMPG
 Q
 ;
