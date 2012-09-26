XMXMSGS ;ISC-SF/GMB-Message APIs ;08/06/2002  06:45
 ;;8.0;MailMan;;Jun 28, 2002
DELMSG(XMDUZ,XMK,XMKZA,XMMSG) ; Delete msgs in mailbox
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 D ACTMSG("XDEL^XMXMSGS2",34302) ;,XMDUZ,XMK,.XMKZA,"",.XMMSG)
 Q
FLTRMSG(XMDUZ,XMK,XMKZA,XMMSG) ; Filter msgs
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 N XMKN,XMKTO,XMKNTO
 I $G(XMK)'=.5,'$G(XMK),'$D(^XMB(3.7,XMDUZ,15,"AF")) D ERRSET^XMXUTIL(37204.1) Q  ; You have no message filters defined.
 I $G(XMK) S XMKN=$P(^XMB(3.7,XMDUZ,2,XMK,0),U,1)
 D ACTMSG("XFLTR^XMXMSGS2",34306) ;,XMDUZ,XMK,XMKN,.XMKZA,"",.XMMSG)
 Q
FWDMSG(XMDUZ,XMK,XMKZA,XMTO,XMINSTR,XMMSG) ; Forward msgs
 ; XMINSTR("SHARE DATE")  delete date if SHARED,MAIL is recipient
 ; XMINSTR("SHARE BSKT")  basket if SHARED,MAIL is recipient
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 N XMRTN
 I $$ONEMSG(.XMKZA) D
 . S XMRTN="XFWDONE^XMXMSGS1" ; just one msg
 E  D
 . S XMRTN="XFWD^XMXMSGS1"
 . I $G(XMINSTR("ADDR FLAGS"))'["I" D INIT^XMXADDR
 . D CHKADDR^XMXADDR(XMDUZ,.XMTO,.XMINSTR)
 D ACTMSG(XMRTN,34309) ;,XMDUZ,XMK,.XMKZA,.XMINSTR,.XMMSG)
 D CLEANUP^XMXADDR
 Q
ONEMSG(XMKZA) ; Function decides if just one message
 N XMONE,XMMSGS
 I $G(XMKZA)]"" D  Q XMONE
 . I $O(XMKZA(""))="",+XMKZA=XMKZA S XMONE=1 Q
 . S XMONE=0
 S XMMSGS=$O(XMKZA(""))
 I $O(XMKZA(XMMSGS))'="" Q 0
 I +XMMSGS=XMMSGS Q 1
 Q 0
LATERMSG(XMDUZ,XMK,XMKZA,XMINSTR,XMMSG) ; Later msgs
 ; XMINSTR("LATER")  FM date/time when msg should be made new.
 K XMERR,^TMP("XMERR",$J)
 Q:'$$LATER^XMXSEC(XMDUZ)
 N XMWHEN
 S XMWHEN=$G(XMINSTR("LATER"),$G(XMINSTR))
 D ACTMSG("XLATER^XMXMSGS2",34312) ;,XMDUZ,XMK,.XMKZA,.XMINSTR,.XMMSG)
 Q
MOVEMSG(XMDUZ,XMK,XMKZA,XMKTO,XMMSG) ; Move msgs to a basket
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 Q:$G(XMK)=XMKTO
 D ACTMSG("XMOVE^XMXMSGS2",34324) ;,XMDUZ,XMK,.XMKZA,XMKTO,.XMMSG)
 Q
NTOGLMSG(XMDUZ,XMK,XMKZA,XMMSG) ; New toggle msgs
 K XMERR,^TMP("XMERR",$J)
 Q:'$$LATER^XMXSEC(XMDUZ)
 N XMKN,XMKTO,XMKNTO
 S:XMK XMKN=$P(^XMB(3.7,XMDUZ,2,XMK,0),U,1)
 D ACTMSG("XNTOGL^XMXMSGS2",34315) ;,XMDUZ,XMK,XMKN,.XMKZA,"",.XMMSG)
 Q
PRTMSG(XMDUZ,XMK,XMKZA,XMPRTTO,XMINSTR,XMMSG,XMTASK,XMSUBJ,XMTO) ; Print msgs
 K XMERR,^TMP("XMERR",$J),^TMP("XM",$J,"XMZ")
 D ACTMSG("XPRT^XMXMSGS1",34320) ;,XMDUZ,XMK,.XMKZA,.XMINSTR,.XMMSG)
 Q:+XMMSG=0
 I +XMMSG=1 D
 . D PRINT1^XMXPRT(XMDUZ,$O(^TMP("XM",$J,"XMZ","")),XMPRTTO,.XMINSTR,.XMTASK,.XMSUBJ,.XMTO)
 E  D
 . D PRINTM^XMXPRT(XMDUZ,XMPRTTO,.XMINSTR,.XMTASK,.XMSUBJ,.XMTO)
 K ^TMP("XM",$J,"XMZ")
 Q:$D(XMTASK)
 S XMMSG=$$EZBLD^DIALOG(34321) ; 0 messages sent to printer.  TaskMan Problem.
 D ERRSET^XMXUTIL(34311) ; Task creation not successful.
 Q
TERMMSG(XMDUZ,XMK,XMKZA,XMMSG) ; Terminate msgs
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 D ACTMSG("XTERM^XMXMSGS2",34329) ;,XMDUZ,XMK,.XMKZA,"",.XMMSG)
 Q
VAPORMSG(XMDUZ,XMK,XMKZA,XMINSTR,XMMSG) ; Set vaporize dates for msgs in mailbox
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 N XMWHEN
 S XMWHEN=$G(XMINSTR("VAPOR"),$G(XMINSTR))
 D ACTMSG("XVAPOR^XMXMSGS2",$S(XMWHEN="@":34337.2,1:34337)) ;,XMDUZ,XMK,.XMKZA,XMWHEN,.XMMSG)
 Q
XPMSG(XMDUZ,XMK,XMKZA,XMINSTR,XMMSG) ; Postmaster transmit priority toggle
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 I XMDUZ'=.5!(XMK'>999) D ERRSET^XMXUTIL(37219.5) Q  ;Transmission Priority toggle valid only for Postmaster Transmission Queues.
 N XMTPRI
 S XMTPRI=$G(XMINSTR("XMIT PRI"),$G(XMINSTR))
 D ACTMSG("XXP^XMXMSGS1",34334) ;,XMDUZ,XMK,.XMKZA,XMTPRI,.XMMSG)
 Q
ACTMSG(XMRTN,XMSUM) ;,XMDUZ,XMK,XMKZA,XMKTO,XMMSG)
 ; XMKZA    Array of msg numbers  DEL("1-3,7,11-15")
 ; XMKZL    List of msg numbers   1-3,7,11-15
 ;          (It is OK if the list ends with a comma)
 ; XMKZR    Range of msg numbers  1-3
 ; XMKZ1    First number in range 1
 ; XMKZN    Last number in range  3
 ; XMKZ     Message number
 N XMCNT,XMI,XMZ,XMPIECES
 S XMCNT=0
 I $G(XMK) D
 . N XMKZ,XMKZL,XMKZR,XMKZ1,XMKZN
 . ; is this an array or a variable?
 . I $G(XMKZA)]"",$O(XMKZA(""))="" S XMKZA(XMKZA)=""
 . S XMKZL=""
 . F  S XMKZL=$O(XMKZA(XMKZL)) Q:XMKZL=""  D
 . . S XMPIECES=$L(XMKZL,",")
 . . S:$P(XMKZL,",",XMPIECES)="" XMPIECES=XMPIECES-1
 . . F XMI=1:1:XMPIECES D
 . . . S XMKZR=$P(XMKZL,",",XMI)
 . . . I XMKZR["-" D
 . . . . ; deal with a range of msg #s
 . . . . S XMKZ1=$P(XMKZR,"-",1)
 . . . . S XMKZN=$P(XMKZR,"-",2)
 . . . . I XMKZ1>XMKZN D  Q
 . . . . . N XMPARM
 . . . . . S XMPARM(1)=XMKZ1,XMPARM(2)=XMKZN
 . . . . . D ERRSET^XMXUTIL(34350,.XMPARM) ; Range '_XMKZ1_-_XMKZN_' invalid.
 . . . . S XMKZ=XMKZ1-.1
 . . . . F  S XMKZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ)) Q:'XMKZ!(XMKZ>XMKZN)  D
 . . . . . S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ,""))
 . . . . . I 'XMZ D  Q
 . . . . . . N XMPARM
 . . . . . . S XMPARM(1)=XMKZ,XMPARM(2)=XMK
 . . . . . . D ERRSET^XMXUTIL(34351,.XMPARM) ; Message _XMKZ_ in basket _XMK_ does not exist.
 . . . . . I '$D(^XMB(3.9,XMZ,0)) D  Q
 . . . . . . N XMPARM
 . . . . . . S XMPARM(1)=XMZ,XMPARM(2)=XMKZ,XMPARM(3)=XMK
 . . . . . . D ERRSET^XMXUTIL(34352,.XMPARM) ; Message '_XMZ_' (message _XMKZ_ in basket _XMK_) does not exist.
 . . . . . D @XMRTN ;(XMDUZ,XMK,XMZ)
 . . . E  D
 . . . . S XMKZ=XMKZR
 . . . . S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ,""))
 . . . . I 'XMZ D  Q
 . . . . . N XMPARM
 . . . . . S XMPARM(1)=XMKZ,XMPARM(2)=XMK
 . . . . . D ERRSET^XMXUTIL(34351,.XMPARM) ; Message _XMKZ_ in basket _XMK_ does not exist.
 . . . . I '$D(^XMB(3.9,XMZ,0)) D  Q
 . . . . . N XMPARM
 . . . . . S XMPARM(1)=XMZ,XMPARM(2)=XMKZ,XMPARM(3)=XMK
 . . . . . D ERRSET^XMXUTIL(34352,.XMPARM) ; Message '_XMZ_' (message _XMKZ_ in basket _XMK_) does not exist.
 . . . . D @XMRTN ;(XMDUZ,XMK,XMZ)
 E  D
 . N XMZL,XMZREC
 . ; is this an array or a variable?
 . I $G(XMKZA)]"",$O(XMKZA(""))="" S XMKZA(XMKZA)=""
 . S XMZL=""
 . F  S XMZL=$O(XMKZA(XMZL)) Q:XMZL=""  D
 . . I XMZL["-" D ERRSET^XMXUTIL(34353) Q  ; XMZ message ranges are not allowed.
 . . S XMPIECES=$L(XMZL,",")
 . . S:'$P(XMZL,",",XMPIECES) XMPIECES=XMPIECES-1
 . . F XMI=1:1:XMPIECES D
 . . . N XMK
 . . . S XMZ=$P(XMZL,",",XMI)
 . . . I '$D(^XMB(3.9,XMZ,0)) D ERRSET^XMXUTIL(34354,XMZ) Q  ; Message '_XMZ_' does not exist."
 . . . S XMZREC=$G(^XMB(3.9,XMZ,0))
 . . . Q:'$$ACCESS^XMXSEC(XMDUZ,XMZ,XMZREC)
 . . . D @XMRTN ;(XMDUZ,XMK,XMZ)
 S XMMSG=$$EZBLD^DIALOG($S(XMCNT=1:XMSUM+.1,1:XMSUM),XMCNT)
 D INCRDECR(XMDUZ,.XMCNT)
 Q
INCRDECR(XMDUZ,XMCNT) ; Update the "new messages" counts.
 N XMK
 S XMK=0
 F  S XMK=$O(XMCNT(XMK)) Q:'XMK  D
 . S XMCNT=$G(XMCNT(XMK,"INCR"))-$G(XMCNT(XMK,"DECR"))
 . Q:'XMCNT
 . I XMCNT<0 D DECRNEW^XMXUTIL(XMDUZ,XMK,-XMCNT) Q
 . D INCRNEW^XMXUTIL(XMDUZ,XMK,XMCNT)
 Q
