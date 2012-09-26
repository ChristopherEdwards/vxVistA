XMHIG ;ISC-SF/GMB-Mail Group Info ;12/05/2002  10:39
 ;;8.0;MailMan;**10**;Jun 28, 2002
 ; Replaces ENTQ^XMA5,GHELP^XMA7G (ISC-WASH/THM/CAP/RJ)
 ;
 ; Entry points used by MailMan options (not covered by DBIA):
 ; HELP      XMHELPGROUP - Get info on a group
HELP ; Group Info
 N DIC,Y
 D CHECK^XMVVITAE
 S DIC="^XMB(3.8,",DIC(0)="AEQMZ"
 ; Screen:  Group is public OR user is organizer OR user is member
 S DIC("S")="I $P(^(0),U,2)=""PU""!($G(^(3))=XMDUZ)!($D(^(1,""B"",XMDUZ)))"
 F  W ! D ^DIC Q:Y<0  D
 . D DISPLAY(+Y)
 Q
DISPLAY(XMGIEN) ;
 N XMABORT
 S XMABORT=0
 W @IOF
 D FIELDS(XMGIEN)
 D AUTHSEND(XMGIEN,.XMABORT) Q:XMABORT
 D MEMBERS(XMGIEN,.XMABORT) Q:XMABORT
 D GROUP(XMGIEN,.XMABORT) Q:XMABORT
 D REMOTE(XMGIEN,.XMABORT) Q:XMABORT
 D DISTR(XMGIEN,.XMABORT) Q:XMABORT
 D FAXMEMBR(XMGIEN,.XMABORT) Q:XMABORT
 D FAXGROUP(XMGIEN,.XMABORT) Q:XMABORT
 D MEMBEROF(XMGIEN,.XMABORT) Q:XMABORT
 Q
FIELDS(DA) ;
 N DIC,DR
 S DIC="^XMB(3.8,"
 F DR=0,2,3 D EN^DIQ
 Q
AUTHSEND(XMGIEN,XMABORT) ;
 Q:'$O(^XMB(3.8,XMGIEN,4,0))
 N XMI,XMMIEN
 S XMI=0
 F  S XMI=$O(^XMB(3.8,XMGIEN,4,XMI)) Q:XMI'>0  D  Q:XMABORT
 . I $Y+3>IOSL D PAGE(.XMABORT) Q:XMABORT
 . S XMMIEN=$P(^XMB(3.8,XMGIEN,4,XMI,0),U)
 . I '$D(^VA(200,XMMIEN,0)) D DELETE(XMGIEN,4,XMI) Q
 . W !,$$EZBLD^DIALOG(39089),$$NAME^XMXUTIL(XMMIEN) ;Authorized Sender:
 Q
MEMBERS(XMGIEN,XMABORT) ;
 Q:'$O(^XMB(3.8,XMGIEN,1,0))
 N XMI,XMMIEN,XMNAME,XMTITLE,XMREC,XMINST,XMTYPE
 I $Y+5>IOSL D  Q:XMABORT
 . D PAGE(.XMABORT)
 E  W !!
 D HEADER
 S XMI=0
 F  S XMI=$O(^XMB(3.8,XMGIEN,1,XMI)) Q:XMI'>0  D  Q:XMABORT
 . I $Y+3>IOSL D PAGE(.XMABORT,1) Q:XMABORT
 . S XMREC=^XMB(3.8,XMGIEN,1,XMI,0)
 . S XMMIEN=$P(XMREC,U)
 . S XMTYPE=$P(XMREC,U,2)
 . I '$D(^VA(200,XMMIEN,0)) D DELETE(XMGIEN,1,XMI) Q
 . S XMNAME=$$NAME^XMXUTIL(XMMIEN,1)
 . I XMTYPE'="" S XMNAME=XMTYPE_":"_XMNAME
 . W !,$E(XMNAME,1,IOM-36),?IOM-35,$S($D(^XMB(3.7,XMMIEN,"L")):$E($P(^("L"),U),1,35),1:$$EZBLD^DIALOG(38007)) ;Never Used MailMan
 Q
DELETE(XMGIEN,XMNODE,DA) ;
 N DIK
 L +^XMB(3.8,XMGIEN,XMNODE):1
 S DA(1)=XMGIEN
 S DIK="^XMB(3.8,"_DA(1)_","_XMNODE_","
 D ^DIK
 L -^XMB(3.8,XMGIEN,XMNODE)
 Q
GROUP(XMGIEN,XMABORT) ; Member Groups
 Q:'$O(^XMB(3.8,XMGIEN,5,0))
 N XMI,XMMIEN,XMNAME,XMREC
 W !
 S XMI=0
 F  S XMI=$O(^XMB(3.8,XMGIEN,5,XMI)) Q:XMI'>0  D  Q:XMABORT
 . I $Y+3>IOSL D PAGE(.XMABORT) Q:XMABORT
 . S XMREC=^XMB(3.8,XMGIEN,5,XMI,0)
 . S XMMIEN=$P(XMREC,U)
 . S XMTYPE=$P(XMREC,U,2)
 . S XMNAME=$P($G(^XMB(3.8,XMMIEN,0)),U)
 . I XMNAME="" D DELETE(XMGIEN,5,XMI) Q
 . I XMTYPE'="" S XMNAME=XMTYPE_":"_XMNAME
 . W !,$$EZBLD^DIALOG(39090),XMNAME ;Member Group:
 Q
REMOTE(XMGIEN,XMABORT) ; Remote Members
 Q:'$O(^XMB(3.8,XMGIEN,6,0))
 N XMI,XMNAME
 W !
 S XMI=0
 F  S XMI=$O(^XMB(3.8,XMGIEN,6,XMI)) Q:XMI'>0  D  Q:XMABORT
 . I $Y+3>IOSL D PAGE(.XMABORT) Q:XMABORT
 . S XMNAME=$P(^XMB(3.8,XMGIEN,6,XMI,0),U)
 . W !,$$EZBLD^DIALOG(39085),XMNAME ;Remote Member:
 Q
DISTR(XMGIEN,XMABORT) ; Distribution list
 Q:'$O(^XMB(3.8,XMGIEN,7,0))
 N XMI,XMMIEN,XMNAME
 W !
 S XMI=0
 F  S XMI=$O(^XMB(3.8,XMGIEN,7,XMI)) Q:XMI'>0  D  Q:XMABORT
 . I $Y+3>IOSL D PAGE(.XMABORT) Q:XMABORT
 . S XMMIEN=$P(^XMB(3.8,XMGIEN,7,XMI,0),U)
 . S XMNAME=$P($G(^XMB(3.816,XMMIEN,0)),U)
 . I XMNAME="" D DELETE(XMGIEN,7,XMI) Q
 . W !,$$EZBLD^DIALOG(39080),XMNAME ;Distribution List:
 . W:$D(^XMB(3.816,XMMIEN,1,0)) $$EZBLD^DIALOG(39092,$P(^(0),U,4)) ; (To |1| Domains)
 Q
FAXGROUP(XMGIEN,XMABORT) ; Fax Groups
 Q:'$O(^XMB(3.8,XMGIEN,9,0))
 N XMI,XMMIEN,XMNAME
 W !
 S XMI=0
 F  S XMI=$O(^XMB(3.8,XMGIEN,9,XMI)) Q:XMI'>0  D  Q:XMABORT
 . I $Y+3>IOSL D PAGE(.XMABORT) Q:XMABORT
 . S XMMIEN=$P(^XMB(3.8,XMGIEN,9,XMI,0),U)
 . S XMNAME=$P($G(^AKF("FAXG",XMMIEN,0)),U)
 . I XMNAME="" D DELETE(XMGIEN,9,XMI) Q
 . W !,$$EZBLD^DIALOG(39081),XMNAME ;Fax Group:
 Q
FAXMEMBR(XMGIEN,XMABORT) ; Fax Members
 Q:'$O(^XMB(3.8,XMGIEN,8,0))
 N XMI,XMMIEN,XMNAME
 W !
 S XMI=0
 F  S XMI=$O(^XMB(3.8,XMGIEN,8,XMI)) Q:XMI'>0  D  Q:XMABORT
 . I $Y+3>IOSL D PAGE(.XMABORT) Q:XMABORT
 . S XMMIEN=$P(^XMB(3.8,XMGIEN,8,XMI,0),U)
 . S XMNAME=$P($G(^AKF("FAXR",XMMIEN,0)),U)
 . I XMNAME="" D DELETE(XMGIEN,8,XMI) Q
 . W !,$$EZBLD^DIALOG(39082),XMNAME ;Fax Recipient:
 Q
MEMBEROF(XMGIEN,XMABORT) ; This group is a member of what other Groups
 Q:'$D(^XMB(3.8,"AD",XMGIEN))
 N XMMIEN,XMNAME
 W !
 S XMMIEN=0
 F  S XMMIEN=$O(^XMB(3.8,"AD",XMGIEN,XMMIEN)) Q:'XMMIEN  D  Q:XMABORT
 . I $Y+3>IOSL D PAGE(.XMABORT) Q:XMABORT
 . S XMNAME=$P($G(^XMB(3.8,XMMIEN,0)),U)
 . I XMNAME="" D  Q
 . . N XMI
 . . S XMI=$O(^XMB(3.8,"AD",XMGIEN,XMMIEN,0))
 . . I XMI D DELETE(XMMIEN,5,XMI) Q
 . . K ^XMB(3.8,"AD",XMGIEN,XMMIEN)
 . W !,$$EZBLD^DIALOG(39093),XMNAME ; member of group:
 Q
GSCREEN ; This routine is a screen [DIC("S")] for a fileman lookup
 ; The naked reference is set to ^XMB(3.8,Y,0)
 I $P(^(0),U,2)="PU" Q        ; Group is public
 I $G(^(3))=XMDUZ Q           ; User is organizer of the group
 I $D(^(1,"B",XMDUZ)) Q       ; User is a member of the group
 ; *** But this doesn't handle the case in which a user might not be
 ; *** a member of this group, but is a member of a member group.
 Q
PAGE(XMABORT,XMHDR) ;
 D PAGE^XMXUTIL(.XMABORT) Q:XMABORT
 W @IOF
 D:$G(XMHDR) HEADER
 Q
HEADER ;
 W $$EZBLD^DIALOG(39091) ;Member           Last Used MailMan
 Q
