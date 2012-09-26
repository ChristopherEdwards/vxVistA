PXRMXQUE ; SLC/PJH - Reminder reports general queuing routine.;03/23/2007
 ;;2.0;CLINICAL REMINDERS;**4,6**;Feb 04, 2005;Build 123
 ;
 ;Determine whether the report should be queued.
JOB ;
 N %ZIS S %ZIS="Q"
 W !
 D ^%ZIS
 I POP G EXIT^PXRMXD
 S PXRMIOD=ION_";"_IOST_";"_IOM_";"_IOSL
 S PXRMQUE=$G(IO("Q"))
 ;
 I PXRMQUE D  Q
 . ;Queue the report.
 . N DESC,PXRMIOV,ROUTINE,TASK,ZTDTH
 . S DESC="Reminder Due Report - sort"
 . S PXRMIOV=""
 . S ROUTINE="^PXRMXSE1"
 . M ^TMP("PXRM-MESS",$J)=^TMP("XM-MESS",$J)
 . S TASK=$$QUE^PXRMXQUE(DESC,PXRMIOV,ROUTINE,"SAVE^PXRMXQUE") Q:TASK=""
 . S ^XTMP(PXRMXTMP,"SORTZTSK")=TASK
 . M ^TMP("XM-MESS",$J)=^TMP("PXRM-MESS",$J)
 . K ^TMP("PXRM-MESS",$J)
 .;
 . S DESC="Reminder Due Report - print"
 . S PXRMIOV=PXRMIOD
 . S ROUTINE="^PXRMXPR"
 . S ZTDTH="@"
 . S ^XTMP(PXRMXTMP,"PRZTSK")=$$QUE^PXRMXQUE(DESC,PXRMIOV,ROUTINE,"SAVE^PXRMXQUE")
 I 'PXRMQUE D ^PXRMXSE1
 Q
 ;
QUE(DESC,PXRMIOV,ROUTINE,SAVE) ;Queue a task.
 N ZTDESC,ZTIO,ZTRTN,ZTSAVE
 D @SAVE
 S ZTDESC=DESC
 S ZTIO=PXRMIOV
 S ZTRTN=ROUTINE
 D ^%ZTLOAD
 I $D(ZTSK)=0 W !!,DESC," cancelled"
 E  W !!,DESC," has been queued, task number ",ZTSK
 Q $G(ZTSK)
 ;
DEVICE(RTN,DESC,SAVE,%ZIS,RETZTSK) ;
 ;Pass RETZTSK as number such as 1 if you want to get ZTSK.
 N ZTSK
 W !
 D EN^XUTMDEVQ(RTN,DESC,.SAVE,.%ZIS,RETZTSK)
 I $D(ZTSK) W !!,DESC," has been queued, task number "_ZTSK H 2
 Q $G(ZTSK)
 ;
 ;=======================================================================
REQUE(DESC,ROUTINE,TASK) ;Reque a task.
 N ZTDTH,ZTRTN,ZTIO,ZTDESC,ZTSK
 S ZTDESC=DESC
 S ZTRTN=ROUTINE
 S ZTSK=TASK
 S ZTDTH=$$NOW^XLFDT
 D REQ^%ZTLOAD
 I ZTSK(0)=1 Q
 ;There was a problem, send an error message.
 K ZTSK S ZTSK=TASK
 D ISQED^%ZTLOAD
 N LC,SUB
 K ^TMP("PXRMXMZ",$J)
 S ^TMP("PXRMXMZ",$J,1,0)="Could not start the print task, task information:"
 S ^TMP("PXRMXMZ",$J,2,0)=" Task number "_TASK
 S LC=2,SUB=""
 F  S SUB=$O(ZTSK(SUB)) Q:SUB=""  D
 . S LC=LC+1
 . S ^TMP("PXRMXMZ",$J,LC,0)=" ZTSK("_SUB_")="_ZTSK(SUB)
 S LC=LC+1,^TMP("PXRMXMZ",$J,LC,0)=" Print start time="_ZTDTH
 S LC=LC+1,^TMP("PXRMXMZ",$J,LC,0)=" Submit time="_$P(PXRMXTMP,"PXRMX",2)
 S LC=LC+1,^TMP("PXRMXMZ",$J,LC,0)="PXRMXTMP="_$G(PXRMXTMP)
 D SEND^PXRMMSG("REMINDER REPORT ERROR",DUZ)
 Q
 ;
 ;=======================================================================
SAVE ;Save the variables for queing.
 S ZTSAVE("PXRMBDT")="",ZTSAVE("PXRMEDT")="",ZTSAVE("PXRMSDT")=""
 S ZTSAVE("PXRMCS(")="",ZTSAVE("NCS")=""
 S ZTSAVE("PXRMCGRP(")="",ZTSAVE("NCGRP")=""
 S ZTSAVE("PXRMFAC(")="",ZTSAVE("NFAC")=""
 S ZTSAVE("PXRMFACN(")=""
 S ZTSAVE("PXRMFCMB")=""
 S ZTSAVE("PXRMFUT")="",ZTSAVE("PXRMDLOC")=""
 S ZTSAVE("PXRMFD")=""
 S ZTSAVE("PXRMINP")=""
 S ZTSAVE("PXRMIOD")=""
 S ZTSAVE("PXRMLCHL(")="",ZTSAVE("NHL")=""
 S ZTSAVE("PXRMLCMB")=""
 S ZTSAVE("PXRMLCSC")=""
 S ZTSAVE("PXRMPRIM")=""
 S ZTSAVE("PXRMQUE")=""
 S ZTSAVE("PXRMREP")=""
 S ZTSAVE("PXRMRT")=""
 S ZTSAVE("PXRMSCAT")="",ZTSAVE("PXRMSCAT(")=""
 S ZTSAVE("PXRMSEL")=""
 S ZTSAVE("PXRMSRT")=""
 S ZTSAVE("PXRMSSN")=""
 S ZTSAVE("PXRMTABC")=""
 S ZTSAVE("PXRMTABS")=""
 S ZTSAVE("PXRMTCMB")=""
 S ZTSAVE("PXRMTMP")=""
 S ZTSAVE("PXRMTOT")=""
 S ZTSAVE("PXRMXTMP")=""
 ; Time initiated
 S ZTSAVE("PXRMXST")=""
 ; New selection criteria
 S ZTSAVE("PXRMOTM(")="",ZTSAVE("NOTM")=""
 S ZTSAVE("PXRMPRV(")="",ZTSAVE("NPRV")=""
 S ZTSAVE("PXRMPAT(")="",ZTSAVE("NPAT")=""
 S ZTSAVE("PXRMPCM(")="",ZTSAVE("NPCM")=""
 S ZTSAVE("PXRMREM(")="",ZTSAVE("NREM")=""
 S ZTSAVE("PXRMRCAT(")="",ZTSAVE("NCAT")=""
 S ZTSAVE("PXRMUSER")=""
 ;Reminder list
 S ZTSAVE("REMINDER(")=""
 ; Arrays by IEN
 S ZTSAVE("PXRMLOCN(")=""
 S ZTSAVE("PXRMCSN(")=""
 S ZTSAVE("PXRMCGRN(")=""
 ;Patient List
 S ZTSAVE("PATCREAT")=""
 S ZTSAVE("PATLST")=""
 S ZTSAVE("PXRMLIST(")=""
 S ZTSAVE("PXRMLIS1")=""
 S ZTSAVE("PLISTPUG")=""
 ;User DUZ
 S ZTSAVE("DBDUZ")=""
 S ZTSAVE("DBERR")=""
 S ZTSAVE("PXRMRERR(")=""
 ;Dubug information
 S ZTSAVE("PXRMDBUG")=""
 S ZTSAVE("PXRMDBUS")=""
 ;Patient Information
 S ZTSAVE("PXRMTPAT")=""
 S ZTSAVE("PXRMDPAT")=""
 I +$G(PXRMIDOD)>0 S ZTSAVE("PXRMIDOD")=""
 S ZTSAVE("PXRMPML")=""
 Q
