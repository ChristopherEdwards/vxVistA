PXRMBMI ; SLC/PKR - National BMI computed finding. ;08/31/2004
 ;;2.0;CLINICAL REMINDERS;;Feb 04, 2005
 ;
 ;=========================================================
BMI(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return the BMI.
 N HDAS,HDATE,HT,HTEMP,WDAS,WDATE,WT,WTEMP
 ;Get the most recent height measurement
 S HDATE="",HT=0
 F  Q:HT>0  S HDATE=$O(^PXRMINDX(120.5,"PI",DFN,8,HDATE),-1) Q:HDATE=""  D
 . S HDAS=$O(^PXRMINDX(120.5,"PI",DFN,8,HDATE,""))
 . K HTEMP
 . D GETDATA^PXRMVITL(HDAS,.HTEMP)
 . S HT=(HTEMP("RATE")*2.54)/100
 I HT=0 S TEST=0,(VALUE,TEXT)="" Q
 ;Get the most recent weight measurement.
 S WDATE="",WT=0
 F  Q:WT>0  S WDATE=$O(^PXRMINDX(120.5,"PI",DFN,9,WDATE),-1) Q:WDATE=""  D
 . S WDAS=$O(^PXRMINDX(120.5,"PI",DFN,9,WDATE,""))
 . K WTEMP
 . D GETDATA^PXRMVITL(WDAS,.WTEMP)
 . S WT=WTEMP("RATE")/2.203
 I WT=0 S TEST=0,(VALUE,TEXT)="" Q
 S VALUE=WT/(HT*HT)
 S VALUE=$FN(VALUE,"",1)
 ;Use date of the weight measurement.
 S DATE=WDATE,TEST=1,TEXT=""
 Q
 ;
