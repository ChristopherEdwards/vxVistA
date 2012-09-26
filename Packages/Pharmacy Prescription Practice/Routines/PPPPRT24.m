PPPPRT24 ;ALB/JFP - FFX PRINT ROUTINES ; 3/16/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
DATASUM ;
 ;
 N PPPMRT,PRTFFXST,PRTFFXND
 N STANUM,VISITS,STARS,PPPARRY,TMP,I,DR,DIR,TPATS,TVIS,TSTA,PATFILE
 N NUMVIS,ENDING,NUMPATS,NUMVISIT
 N HDRCNT,DROOT,HROOT,X,BLINE,JOIN
 ;
 S PPPMRT="DATASUM_PPPPRT24"
 S PRTFFXST=1017
 S PRTFFXND=1018
 S (VALMCNT,HDRCNT)=0
 ;
 S DROOT="^TMP(""PPPL6"",$J)"
 S HROOT="^TMP(""PPPL6"",$J,""HDR"")"
 S PPPARRY="^TMP(""PPP"",$J,""HIST"")"
 ;
 S TMP=$$LOGEVNT^PPPMSC1(PRTFFXST,PPPMRT,"STATION HISTOGRAMS")
 D VISHISTA(PPPARRY)
 ;
 D HEADING1
 D ORDER3
 S X=$$SETSTR^VALM1(" ","",1,79) D TMP
 S X=$$SETSTR^VALM1("Listing Complete.","",1,79) D TMP
 K @PPPARRY
 S TMP=$$LOGEVNT^PPPMSC1(PRTFFXND,PPPMRT)
 Q
 ;
HEADING1 ; Write the page heading, Pause if a crt.
 S BLINE=$$SETSTR^VALM1(" ","",1,80)
 ;
 S X=BLINE D HDRTMP
 S X=$$CENTER^PPPUTL1(BLINE,"Pharmacy Prescription Practices")
 D HDRTMP
 S X=$$CENTER^PPPUTL1(BLINE,"Data Summary")
 D HDRTMP
 S X=$$CENTER^PPPUTL1(BLINE,"As Of --> "_$$I2EDT^PPPCNV1(DT))
 D HDRTMP
 Q
 ;
ORDER3 ;
 ;
 S PATFILE=$P($G(^DPT(0)),"^",4)
 S X=$$SETSTR^VALM1("Total Number Of Patients In Patient File........................"_PATFILE,"",1,79)
 D TMP
 S X=$$SETSTR^VALM1("Total Patients In Other Facility Xref File......................"_TPATS,"",1,79)
 D TMP
 S X=$$SETSTR^VALM1("Total Number Of Stations Visited................................"_TSTA,"",1,79)
 D TMP
 S X=$$SETSTR^VALM1("Total Number Of Entries In Other Facility Xref File............."_TVIS,"",1,79)
 D TMP
 S X=$$SETSTR^VALM1(" ","",1,79) D TMP
 F NUMVIS=0:0 D  Q:NUMVIS'>0
 .S NUMVIS=$O(@PPPARRY@(NUMVIS)) Q:NUMVIS'>0
 .S NUMPATS=@PPPARRY@(NUMVIS)
 .S ENDING=$E(NUMVIS_" Other Station"_$S(NUMVIS>1:"s",1:"")_"............",1,24)
 .S JOIN=ENDING_NUMPATS
 .S X=$$SETSTR^VALM1("Total Number Of Patients With Visits To "_JOIN,"",1,68)
 .S X=$$SETSTR^VALM1(" ("_$FN(((NUMPATS/PATFILE)*100),"",2)_"%)",X,69,11)
 .D TMP
 Q
 ;
VISHISTA(TMPARY) ;
 ;
 N STAPTR,STANUM,PATDFN
 ;
 S (TPATS,TVIS,TSTA)=0
 F PATDFN=0:0 D  Q:PATDFN=""
 .S PATDFN=$O(^PPP(1020.2,"APOV",PATDFN)) Q:PATDFN=""
 .S NUMVISIT=0
 .S TPATS=TPATS+1
 .F STAPTR=0:0 D  Q:STAPTR=""
 ..S STAPTR=$O(^PPP(1020.2,"APOV",PATDFN,STAPTR)) Q:STAPTR=""
 ..S NUMVISIT=NUMVISIT+1
 ..S TVIS=TVIS+1
 ..I '$D(@TMPARY@("STA",STAPTR)) D
 ...S @TMPARY@("STA",STAPTR)=""
 ...S TSTA=TSTA+1
 .S @TMPARY@(NUMVISIT)=+$G(@TMPARY@(NUMVISIT))+1
 Q
 ;
TMP ; -- Sets up data display array
 S VALMCNT=VALMCNT+1
 S @DROOT@(VALMCNT,0)=$E(X,1,79)
 QUIT
 ;
HDRTMP ; -- Sets up header display array
 S HDRCNT=HDRCNT+1
 S @HROOT@(HDRCNT)=$E(X,1,79)
 QUIT
 ;