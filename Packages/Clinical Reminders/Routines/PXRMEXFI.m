PXRMEXFI ; SLC/PKR/PJH - Exchange utilities for file entries.;07/05/2007
 ;;2.0;CLINICAL REMINDERS;**6**;Feb 04, 2005;Build 123
 ;==============================================
DELALL(FILENUM,NAME) ;Delete all file entries named NAME.
 N IEN,IND,LIST,MSG
 D FIND^DIC(FILENUM,"","@","K",NAME,"*","","","","LIST","MSG")
 I $P(LIST("DILIST",0),U,1)=0 Q
 S IND=0
 F  S IND=$O(LIST("DILIST",2,IND)) Q:IND=""  D
 . S IEN=LIST("DILIST",2,IND)
 . D DELETE(FILENUM,IEN)
 Q
 ;
 ;==============================================
DELETE(FILENUM,DA) ;Delete a file entry.
 N DIK
 S DIK=$$ROOT^DILFD(FILENUM)
 D ^DIK
 Q
 ;
 ;==============================================
FEIMSG(SAME,ATTR) ;Output the general file exits install message.
 N IND,NOUT,TEXT,TEXTO
 S TEXT(1)=ATTR("FILE NAME")_" entry named "_ATTR("NAME")_" already exists"
 I SAME D
 . S TEXT(2)="and the packed component is identical, skipping."
 . S TEXT(3)=" "
 . D FORMAT^PXRMTEXT(1,70,3,.TEXT,.NOUT,.TEXTO)
 . F IND=1:1:NOUT W !,TEXTO(IND)
 . H 2
 I 'SAME D
 . S TEXT(2)="but the packed component is different, what do you want to do?"
 . D FORMAT^PXRMTEXT(1,70,2,.TEXT,.NOUT,.TEXTO)
 . F IND=1:1:NOUT W !,TEXTO(IND)
 Q
 ;
 ;==============================================
FOKTI(FILENUM) ;Check if it is ok to install/transport this FILE.
 ;
 ;Drugs not allowed.
 I FILENUM=50 Q 0
 ;
 ;VA Generic not allowed.
 I FILENUM=50.6 Q 0
 ;
 ;VA Drug Class not allowed.
 I FILENUM=50.605 Q 0
 ;
 ;Lab tests not allowed.
 I FILENUM=60 Q 0
 ;
 ;Radiology procedures not allowed.
 I FILENUM=71 Q 0
 ;
 ;ICD9 (used in Dialogs) not allowed.
 I FILENUM=80 Q 0
 ;
 ;ICD0 not allowed.
 I FILENUM=80.1 Q 0
 ;
 ;CPT (used in Dialogs) not allowed.
 I FILENUM=81 Q 0
 ;
 ;Order Dialogs not allowed.
 I FILENUM=101.41 Q 0
 ;
 ;Orderable Items not allowed.
 I FILENUM=101.43 Q 0
 ;
 ;Sites cannot create entries in GMRV VITAL TYPE.
 I FILENUM=120.51 Q 0
 ;
 ;Mental Health Instruments not allowed.
 I FILENUM=601 Q 0
 I FILENUM=601.71 Q 0
 ;
 I FILENUM=790.404 Q 0
 ;
 ;If control gets to here then it is an allowed file type.
 Q 1
 ;
 ;==============================================
GETFACT(PT01,ATTR,NEWPT01,NAMECHG,IEN) ;Get the action for a file.
 N ACTION,CHOICES,CSUM,DIR,FILENUM,MSG,RESULT
 N SAME,X,Y
 ;See if this entry is already defined.
CHK ;
 S NEWPT01=""
 S FILENUM=ATTR("FILE NUMBER")
 I IEN="" S IEN=$$EXISTS^PXRMEXIU(FILENUM,PT01)
 I IEN D
 .;If the entry already exists compare the existing entry checksum
 .;with the packed entry checksum.
 . S CSUM=$$FILE^PXRMEXCS(ATTR("FILE NUMBER"),IEN)
 . S SAME=$S(ATTR("CHECKSUM")=CSUM:1,1:0)
 . D FEIMSG(SAME,.ATTR)
 . I SAME S ACTION="S"
 . I 'SAME D
 .. S CHOICES=$S(FILENUM=801.41:"CMOQS",FILENUM=811.5:"CMOQS",1:"COQS")
 .. S DIR("B")="O"
 .. S ACTION=$$GETACT^PXRMEXIU(CHOICES,.DIR)
 E  D
 . W !!,ATTR("FILE NAME")," entry ",PT01," is NEW,"
 . W !,"what do you want to do?"
 . S CHOICES="CIQS"
 . S DIR("B")="I"
 . S ACTION=$$GETACT^PXRMEXIU(CHOICES,.DIR)
 ;
 I ACTION="Q" Q ACTION
 I ACTION="C" D
 . S NEWPT01=$$GETUNAME^PXRMEXIU(.ATTR)
 .;Make sure the NEW .01 passes any input transforms.
 . I NEWPT01="" S ACTION="S"
 . E  D CHK^DIE(ATTR("FILE NUMBER"),.01,"",NEWPT01,.RESULT,"MSG")
 I $G(RESULT)="^" D  G CHK
 . D AWRITE^PXRMUTIL("MSG")
 . K RESULT
 ;
 I ACTION="O" D
 .;If the action is overwrite double check that is what the user
 .;really wants to do.
 . N DIROUT,DIRUT,DTOUT,DUOUT
 . K DIR
 . S DIR(0)="Y"_U_"A"
 . S DIR("A")="Are you sure you want to overwrite"
 . S DIR("B")="N"
 . D ^DIR
 . I $D(DIROUT)!$D(DIRUT) S Y=0
 . I $D(DTOUT)!$D(DUOUT) S Y=0
 . S ACTION=$S(Y:"O",1:"S")
 ;
 I ACTION="P" D
 . N DIC,Y
 . S DIC=ATTR("FILE NUMBER")
 . S DIC(0)="AEMQ"
 . D ^DIC
 . I Y=-1 S ACTION="S"
 . E  S NEWPT01=$P(Y,U,2)
 ;
 I NEWPT01'="" S NAMECHG(ATTR("FILE NUMBER"),PT01)=NEWPT01
 Q ACTION
 ;
 ;==============================================
SETATTR(ATTR,FILE,PT01) ;Set the file attributes for the file FILE.
 N MSG
 S ATTR("FILE NUMBER")=FILE
 S ATTR("FILE NAME")=$$GET1^DID(FILE,"","","NAME","","MSG")
 ;This call gets the field length.
 D FIELD^DID(FILE,.01,"","FIELD LENGTH","ATTR","MSG")
 S ATTR("MIN FIELD LENGTH")=3
 S (ATTR("NAME"),ATTR("PT01"))=PT01
 Q
 ;
