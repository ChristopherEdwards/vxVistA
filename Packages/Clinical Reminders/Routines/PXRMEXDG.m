PXRMEXDG ;SLC/PJH - Reminder Dialog Exchange index build ;05/16/2007
 ;;2.0;CLINICAL REMINDERS;**6**;Feb 04, 2005;Build 123
 ;
 ;=====================================================================
DIALOG(RIEN,DLIST,FLIST,OLIST,TLIST,SPONLIST) ;
 ;
 ;Routine to get dialog details for a given reminder
 ;
 ;Called as DIALOG^PXRMEXDG(RIEN,.DLIST,.FLIST)
 ;
 ;RIEN   - Reminder IEN
 ;DLIST  - List of dialogs (components first)
 ;FLIST  - Finding list used by PXRMEXPR
 ;OLIST  - List of embedded TIU objects
 ;TLIST  - List of embedded TIU templates
 ;
 ;Initialize
 K DLIST
 N DARRAY,DCNT,DIALOG,DIEN,FCNT,FINDING,OCNT,RCNT,RESULT,TEMP
 ;Check if reminder exists
 Q:'$D(^PXD(811.9,RIEN,0))
 ;Get dialog ien from reminder definition
 S DIEN=$P($G(^PXD(811.9,RIEN,51)),U) Q:'DIEN
 ;Check dialog pointer is valid
 Q:'$D(^PXRMD(801.41,DIEN))
 ;Dialog and Finding count
 S DCNT=0,FCNT=0,RCNT=0,TCNT=0
 ;Get details
 D GETSPON^PXRMEXPR(801.41,DIEN,.SPONLIST)
 D DGET(DIEN,.SPONLIST)
 ;
 ;Now build the dialog list (components first)
 S DCNT="",OCNT=0
 F  S DCNT=$O(DARRAY(DCNT),-1) Q:'DCNT  D
 .;Ignore dialogs previously encountered
 .S DIEN=DARRAY(DCNT) Q:$D(DIALOG(DIEN))
 .;Save dialog in output array
 .S OCNT=OCNT+1,DIALOG(DIEN)="",TEMP("DIALOG",OCNT)=DIEN
 ;
 ;Save the dialog and result details to DLIST
 N CNT,COUNT,DTYP
 S COUNT=0
 F DTYP="RESULT ELEMENT" D
 .S CNT=0 F  S CNT=$O(TEMP(DTYP,CNT)) Q:CNT'>0  D
 ..S DIEN=$G(TEMP(DTYP,CNT)) Q:DIEN'>0
 ..S COUNT=COUNT+1,DLIST("DIALOG",COUNT,DIEN)=""
 ;
 F DTYP="RESULT" D
 .S CNT=0 F  S CNT=$O(TEMP(DTYP,CNT)) Q:CNT'>0  D
 ..S DIEN=$G(TEMP(DTYP,CNT)) Q:DIEN'>0
 ..S COUNT=COUNT+1,DLIST("DIALOG",COUNT,DIEN)=""
 ;
 ;F DTYP="RESULT","DIALOG" D
 F DTYP="DIALOG" D
 .F CNT=1:1 S DIEN=$G(TEMP(DTYP,CNT)) Q:'DIEN  D
 ..S COUNT=COUNT+1,DLIST("DIALOG",COUNT,DIEN)=""
 ;
 I COUNT>0 S DLIST("DIALOG")=801.41
 ;
 ;Add Dialog Findings to FLIST if not aready present
 N DIC,DO,IEN,FNAME,FNUM,SUB
 S SUB=0
 F  S SUB=$O(TEMP("FINDING",SUB)) Q:'SUB  D
 .S IEN=$P(TEMP("FINDING",SUB),";"),DIC=U_$P(TEMP("FINDING",SUB),";",2)
 .K DO D DO^DIC1
 .S FNUM=+DO(2),FNAME=$P(DO,U) I ('FNUM)!(FNAME="") Q
 .;Check if present in FLIST
 .I $D(FLIST(FNAME,"F",IEN)) Q
 .;Otherwise add to list
 .S:'$D(FLIST(FNAME)) FLIST(FNAME)=FNUM S FLIST(FNAME,"F",IEN)=""
 .;Add the Health Factor category to FLIST
 .I FNAME="HEALTH FACTORS" D
 ..N HFCAT
 ..S HFCAT=$P($G(^AUTTHF(IEN,0)),U,3) S:HFCAT FLIST(FNAME,"C",HFCAT)=""
 ;
 ;Store any TIU components
 N GLOB,DIEN,CNT
 ;Set global for search
 S GLOB="^PXRMD(801.41,"
 ;Search through all component dialogs
 S CNT=0
 F  S CNT=$O(DLIST("DIALOG",CNT)) Q:'CNT  D
 .S DIEN=$O(DLIST("DIALOG",CNT,"")) Q:'DIEN
 .;Search Dialog Text for TIU Objects and Templates
 .D TIUSRCH(GLOB,DIEN,25,.OLIST,.TLIST)
 .;Search P/N Text for TIU Objects and Templates
 .D TIUSRCH(GLOB,DIEN,35,.OLIST,.TLIST)
 ;
 Q
 ;
 ;Get the dialog components
 ;-------------------------
DGET(D0,SPONLIST) ;Save dialog ien
 N D1
 I $G(D0)=83
 I $G(^PXRMD(801.41,D0,49))'="",$P(^PXRMD(801.41,D0,49),U,3)>0 D
 .S D1=$P($G(^PXRMD(801.41,D0,49)),U,3) D DGET1(D0,.SPONLIST) D DGET1(D1,.SPONLIST)
 E  D DGET1(D0,.SPONLIST)
 Q
DGET1(D0,SPONLIST) ;
 S DCNT=DCNT+1,DARRAY(DCNT)=D0
 ;And details (except for reminder dialog)
 I DCNT>1 D
 .D GETSPON^PXRMEXPR(801.41,D0,.SPONLIST)
 .;Finding items
 .D DFIND(D0)
 .;Additional Finding Items
 .D DFINDA(D0)
 .;Result groups
 .D DRESULT(D0)
 ;
 ;Dialog components
 N DCOMP,DCOMP1,DDATA,DSUB
 S DSUB=0
 F  S DSUB=$O(^PXRMD(801.41,D0,10,DSUB)) Q:'DSUB  D
 .;Get any component dialogs
 .S DCOMP=$P($G(^PXRMD(801.41,D0,10,DSUB,0)),U,2) Q:'DCOMP
 .;If component exists get sub-components
 .S DDATA=$G(^PXRMD(801.41,DCOMP,0)) Q:DDATA=""
 .;Exclude national PXRM prompts
 .I +$G(PXRMINST)=0,$E(DDATA,1,4)="PXRM",$P($G(^PXRMD(801.41,DCOMP,100)),U)="N" Q
 .;Sub-components
 .D DGET(DCOMP,.SPONLIST)
 .;I $G(DCOMP1)'="" D DGET(DCOMP1) S DCOMP1=""
 Q
 ;
 ;Build list of finding items
 ;---------------------------
DFIND(DIEN) ;
 N FIND,FIEN,FGLOB,FNAM
 ;Finding Item
 S FIND=$P($G(^PXRMD(801.41,DIEN,1)),U,5)
 ;If a finding item exists check and save
LOOP ;
 I FIND]"" D
 .;Finding item defined
 .S FIEN=$P(FIND,";"),FGLOB=$P(FIND,";",2) Q:'FIEN  Q:FGLOB=""
 .;And finding item exists
 .Q:'$D(@(U_FGLOB_FIEN_",0)"))
 .;Finding name
 .S FNAM=$P($G(@(U_FGLOB_FIEN_",0)")),U) S:FNAM="" FNAM="???"
 .;And not previously saved
 .I '$D(FINDING(FIND)) D
 ..S FCNT=FCNT+1,FINDING(FIND)="",TEMP("FINDING",FCNT)=FIND
 I $G(^PXRMD(801.41,DIEN,49))'="",$P(^PXRMD(801.41,DIEN,49),U)>0 D
 .S FIND=$P(^PXRMD(801.41,DIEN,49),U)
 .I $D(FLIST("REMINDER TERM","F",FIND)) Q
 .I '$D(FLIST("REMINDER TERM")) S FLIST("REMINDER TERM")="811.5"
 .S FLIST("REMINDER TERM","F",FIND)=""
 .D GETTFIND^PXRMEXPR(.FLIST)
 Q
 ;
 ;Build list of additional findings
 ;---------------------------------
DFINDA(DIEN) ;
 N FIND,FIEN,FGLOB,FNAM,FSUB
 S FSUB=0
 F  S FSUB=$O(^PXRMD(801.41,DIEN,3,FSUB)) Q:'FSUB  D
 .;Additional Finding Item
 .S FIND=$P($G(^PXRMD(801.41,DIEN,3,FSUB,0)),U)
 .;If a finding item exists check and save
 .I FIND]"" D
 ..;Finding item defined
 ..S FIEN=$P(FIND,";"),FGLOB=$P(FIND,";",2) Q:'FIEN  Q:FGLOB=""
 ..;And finding item exists
 ..Q:'$D(@(U_FGLOB_FIEN_",0)"))
 ..;Finding name
 ..S FNAM=$P($G(@(U_FGLOB_FIEN_",0)")),U) S:FNAM="" FNAM="???"
 ..;And not previously saved
 ..I '$D(FINDING(FIND)) D
 ...S FCNT=FCNT+1,FINDING(FIND)="",TEMP("FINDING",FCNT)=FIND
 Q
 ;
 ;Build list of result groups
 ;---------------------------
DRESULT(DIEN) ;
 N CNT,RIEN,RECNT,RGCNT
 ;Result Group/Element pointer
 S RECNT=$O(TEMP("RESULT ELEMENT",""),-1)
 S RGCNT=$O(TEMP("RESULT",""),-1)
 S CNT=0
 F  S CNT=$O(^PXRMD(801.41,DIEN,51,CNT)) Q:CNT'>0  D
 .S RIEN=$P($G(^PXRMD(801.41,DIEN,51,CNT,0)),U) Q:RIEN'>0
 .;S RIEN=$P($G(^PXRMD(801.41,DIEN,0)),U,15) Q:'RIEN  Q:$D(RESULT(RIEN))
 .;Result group compoments
 .N DSUB,REIEN
 .S DSUB=0
 .F  S DSUB=$O(^PXRMD(801.41,RIEN,10,DSUB)) Q:'DSUB  D
 ..;Get result element
 ..S REIEN=$P($G(^PXRMD(801.41,RIEN,10,DSUB,0)),U,2) Q:'REIEN
 ..Q:'$D(^PXRMD(801.41,REIEN,0))
 ..;If element exists get save it
 ..S RECNT=RECNT+1,TEMP("RESULT ELEMENT",RECNT)=REIEN
 ..;S RCNT=RCNT+1,OUTPUT("RESULT",RCNT)=REIEN
 .;
 .;Save result group
 .S RGCNT=RGCNT+1,TEMP("RESULT",RGCNT)=RIEN
 .;S RCNT=RCNT+1,RESULT(RIEN)="",TEMP("RESULT",RCNT)=RIEN
 Q
 ;
 ;Extract TIU Objects/Templates from any WP text
 ;----------------------------------------------
TIUSRCH(GLOB,IEN,NODE,OLIST,TLIST) ;
 N OCNT,TCNT,TEXT
 ;Add to existing arrays
 S OCNT=+$O(OLIST(""),-1),TCNT=+$O(TLIST(""),-1),SUB=0
 ;Scan WP fields
 F  S SUB=$O(@(GLOB_IEN_","_NODE_","_SUB_")")) Q:'SUB  D
 .;Get individual line
 .S TEXT=$G(@(GLOB_IEN_","_NODE_","_SUB_",0)")) Q:TEXT=""
 .;Most text lines will have no TIU link so ignore them
 .I (TEXT'["|")&(TEXT'["{FLD:") Q
 .;Templates are in format {FLD:fldname} (only applies to dialogs)
 .I GLOB[801.41 D TIUXTR("{FLD:","}",TEXT,.TLIST,.TCNT)
 .;Objects are in format |Objectname|
 .D TIUXTR("|","|",TEXT,.OLIST,.OCNT)
 Q
 ;
TIUXTR(SRCH,SRCH1,TEXT,OUTPUT,CNT) ;
 N EXIST,IC,TXT,ONAME
 S TXT=TEXT
 F  D  Q:TXT'[SRCH
 .S TXT=$E(TXT,$F(TXT,SRCH),$L(TXT)) Q:TXT'[SRCH1
 .S ONAME=$P(TXT,SRCH1) Q:ONAME=""
 .;Check if already selected
 .S EXIST=0,IC=0
 .F  S IC=$O(OUTPUT(IC)) Q:'IC  Q:EXIST  D
 ..I $G(OUTPUT(IC))=ONAME S EXIST=1
 .;Save array of object/template names
 .I 'EXIST S CNT=CNT+1,OUTPUT(CNT)=ONAME
 Q
