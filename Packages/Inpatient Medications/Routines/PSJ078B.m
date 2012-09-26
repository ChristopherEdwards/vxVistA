PSJ078B ;BIR/JLC - Check for stop date problems ;08-MAY-02 / 10:34 AM  
 ;;5.0; INPATIENT MEDICATIONS ;**78**;16 DEC 97
 ;
 ;Reference to ^PS(55 is supported by DBIA# 2191.
 ;
XREFS ;
 N PSJXD,PSJSTP
 S PSJXD=0 F  S PSJXD=$O(^PS(55,"AUDS",PSJXD)) Q:'PSJXD  D
 . S PSJPDFN=0
 . F  S PSJPDFN=$O(^PS(55,"AUDS",PSJXD,PSJPDFN)) Q:'PSJPDFN  D
 .. S PSJORD=0
 .. F  S PSJORD=$O(^PS(55,"AUDS",PSJXD,PSJPDFN,PSJORD)) Q:'PSJORD  D
 ... K XREF S XREF="AUDS" D CHKREF(XREF)
 S PSJPDFN=0 F  S PSJPDFN=$O(^PS(55,PSJPDFN)) Q:'PSJPDFN  D
 . S PSJXD=0
 . F  S PSJXD=$O(^PS(55,PSJPDFN,5,"AUS",PSJXD)) Q:'PSJXD  D
 .. S PSJORD=0
 .. F  S PSJORD=$O(^PS(55,PSJPDFN,5,"AUS",PSJXD,PSJORD)) Q:'PSJORD  D
 ... K XREF S XREF="AUS" D CHKREF(XREF)
 S PSJPDFN=0 F  S PSJPDFN=$O(^PS(55,PSJPDFN)) Q:'PSJPDFN  D
 . S PSJST="" F  S PSJST=$O(^PS(55,PSJPDFN,5,"AU",PSJST)) Q:PSJST=""  D
 .. S PSJXD=0
 .. F  S PSJXD=$O(^PS(55,PSJPDFN,5,"AU",PSJST,PSJXD)) Q:'PSJXD  D
 ... S PSJORD=0 F  S PSJORD=$O(^PS(55,PSJPDFN,5,"AU",PSJST,PSJXD,PSJORD)) Q:'PSJORD  D
 .... K XREF S XREF="AU" D CHKREF(XREF)
 S PSJXD=0 F  S PSJXD=$O(^PS(55,"AUD",PSJXD)) Q:'PSJXD  D
 . S PSJPDFN=0
 . S PSJPDFN=$O(^PS(55,"AUD",PSJXD,PSJPDFN)) Q:'PSJPDFN  D
 .. S PSJORD=0
 .. F  S PSJORD=$O(^PS(55,"AUD",PSJXD,PSJPDFN,PSJORD)) Q:'PSJORD  D
 ... K XREF S XREF="AUD" D CHKREF(XREF)
 S PSJXD=0 F  S PSJXD=$O(^PS(55,"AIVS",PSJXD)) Q:'PSJXD  D
 . S PSJPDFN=0
 . F  S PSJPDFN=$O(^PS(55,"AIVS",PSJXD,PSJPDFN)) Q:'PSJPDFN  D
 .. S PSJORD=0
 .. F  S PSJORD=$O(^PS(55,"AIVS",PSJXD,PSJPDFN,PSJORD)) Q:'PSJORD  D
 ... K XREF S XREF="AIVS" D CHKREF(XREF)
 S PSJPDFN=0 F  S PSJPDFN=$O(^PS(55,PSJPDFN)) Q:'PSJPDFN  D
 . S PSJXD=0
 . F  S PSJXD=$O(^PS(55,PSJPDFN,"IV","AIS",PSJXD)) Q:'PSJXD  D
 .. S PSJORD=0
 .. F  S PSJORD=$O(^PS(55,PSJPDFN,"IV","AIS",PSJXD,PSJORD)) Q:'PSJORD  D
 ... K XREF S XREF="AIS" D CHKREF(XREF)
 S PSJPDFN=0 F  S PSJPDFN=$O(^PS(55,PSJPDFN)) Q:'PSJPDFN  D
 . S PSJST=""
 . F  S PSJST=$O(^PS(55,PSJPDFN,"IV","AIT",PSJST)) Q:PSJST=""  D
 .. S PSJXD=0
 .. F  S PSJXD=$O(^PS(55,PSJPDFN,"IV","AIT",PSJST,PSJXD)) Q:'PSJXD  D
 ... S PSJORD=0
 ... F  S PSJORD=$O(^PS(55,PSJPDFN,"IV","AIT",PSJST,PSJXD,PSJORD)) Q:'PSJORD  D
 .... K XREF S XREF="AIT" D CHKREF(XREF)
 S PSJXD=0 F  S PSJXD=$O(^PS(55,"AIV",PSJXD)) Q:'PSJXD  D
 . S PSJPDFN=0
 . F  S PSJPDFN=$O(^PS(55,"AIV",PSJXD,PSJPDFN)) Q:'PSJPDFN  D
 .. S PSJORD=0
 .. S PSJORD=$O(^PS(55,"AIV",PSJXD,PSJPDFN,PSJORD)) Q:'PSJORD  D
 ... K XREF S XREF="AIV" D CHKREF(XREF)
 D XCLEAN
 Q
 ;
CHKREF(REF) ;Check cross references
 ; UD cross refs
 N PSJST,DATES
 I REF["AU" D  Q
 . S PSJND0=$G(^PS(55,PSJPDFN,5,PSJORD,0)),PSJST=$P(PSJND0,"^",7)
 . S PSJND2=$G(^PS(55,PSJPDFN,5,PSJORD,2))
 . S START=$P(PSJND2,"^",2),STOP=$P(PSJND2,"^",4)
 . I REF="AUDS" D  Q
 .. I START,(START'=PSJXD) D
 ... S DATES=START_"^"_STOP_"^"_PSJXD_"^^"_PSJST
 ... S ^XTMP("PSJ XREF",REF,PSJPDFN,PSJORD,PSJXD)=DATES
 . I STOP,(STOP'=PSJXD) S DATES=START_"^"_STOP_"^^"_PSJXD_"^"_PSJST D
 .. S ^XTMP("PSJ XREF",REF,PSJPDFN,PSJORD,PSJXD)=DATES
 ; IV cross refs
 Q:REF'["AI"
 S PSJND0=$G(^PS(55,PSJPDFN,"IV",PSJORD,0))
 S PSJND2=$G(^PS(55,PSJPDFN,"IV",PSJORD,2))
 S START=$P(PSJND0,"^",2),STOP=$P(PSJND0,"^",3),PSJST=$P(PSJND0,"^",4)
 I REF="AIVS" D  Q
 . I START,(START'=PSJXD) S DATES=START_"^"_STOP_"^"_PSJXD_"^^"_PSJST D
 .. S ^XTMP("PSJ XREF",REF,PSJPDFN,PSJORD,PSJXD)=DATES
 I STOP,(STOP'=PSJXD) S DATES=START_"^"_STOP_"^^"_PSJXD_"^"_PSJST D
 . S ^XTMP("PSJ XREF",REF,PSJPDFN,PSJORD,PSJXD)=DATES
 Q
 ;
XCLEAN ;
 N PSJPDFN,PSJORD,PSJSTP,PSJSTRT,OPSJSTRT,OPSJSTP,DATES
 S REF="" F  S REF=$O(^XTMP("PSJ XREF",REF)) Q:REF=""  D
 . S PSJPDFN=0
 . F  S PSJPDFN=$O(^XTMP("PSJ XREF",REF,PSJPDFN)) Q:'PSJPDFN  D
 .. S PSJORD=0
 .. F  S PSJORD=$O(^XTMP("PSJ XREF",REF,PSJPDFN,PSJORD)) Q:'PSJORD  D
 ... S PSJXD=0
 ... F  S PSJXD=$O(^XTMP("PSJ XREF",REF,PSJPDFN,PSJORD,PSJXD)) Q:'PSJXD  D
 .... S DATES=^(PSJXD),PSJSTRT=$P(DATES,"^"),PSJSTP=$P(DATES,"^",2)
 .... S OPSJSTRT=$P(DATES,"^",3),OPSJSTP=$P(DATES,"^",4)
 .... S PSJST=$P(DATES,"^",5)
 .... D @REF
 Q
 ;
UDSTART ; UD Start Date/Time Xrefs ("AUDS")
 Q:'PSJSTRT!($L(PSJSTRT)<5)
 S $P(^PS(55,PSJPDFN,5,PSJORD,2),"^",2)=+PSJSTRT
AUDS ;
 S ^PS(55,"AUDS",+PSJSTRT,PSJPDFN,PSJORD)=""
 Q:'$G(OPSJSTRT)
 K ^PS(55,"AUDS",OPSJSTRT,PSJPDFN,PSJORD)
 Q
UDSTOP ; UD Stop Date/Time Xrefs ("AU","AUS","AUD")
 Q:'PSJSTP!($L(PSJSTP)<5)
 S $P(^PS(55,PSJPDFN,5,PSJORD,2),"^",4)=+PSJSTP
AU ;         
AUS ;
AUD I PSJST?1.2U S ^PS(55,PSJPDFN,5,"AU",PSJST,+PSJSTP,PSJORD)=""
 S ^PS(55,PSJPDFN,5,"AUS",+PSJSTP,PSJORD)=""
 S ^PS(55,"AUD",+PSJSTP,PSJPDFN,PSJORD)=""
 Q:$G(OPSJSTP)=""
 I PSJST?1.2U K ^PS(55,PSJPDFN,5,"AU",PSJST,OPSJSTP,PSJORD)
 K ^PS(55,PSJPDFN,5,"AUS",OPSJSTP,PSJORD)
 K ^PS(55,"AUD",OPSJSTP,PSJPDFN,PSJORD)
UDNVDT ;
 S:$G(PSJNVDT)]"" $P(^PS(55,PSJPDFN,5,PSJORD,4),"^",2)=+$G(PSJNVDT)
 Q
IVSTART ; IV Start Date/Time Xrefs ("AIVS")
 Q:'PSJSTRT!($L(PSJSTP)<5)
 S $P(^PS(55,PSJPDFN,"IV",PSJORD,0),"^",2)=+PSJSTRT
AIVS ;
 S ^PS(55,"AIVS",+PSJSTRT,PSJPDFN,PSJORD)=""
 Q:$G(OPSJSTRT)=""
 K ^PS(55,"AIVS",OPSJSTRT,PSJPDFN,PSJORD)
 Q
IVSTOP ; IV Stop Date/Time Xrefs ("AIS","AIT","AIV")
 Q:'PSJSTP!($L(PSJSTP)<5)
 S $P(^PS(55,PSJPDFN,"IV",PSJORD,0),"^",3)=+PSJSTP
AIT ;
AIS ;
AIV I PSJST?1.2U S ^PS(55,PSJPDFN,"IV","AIT",PSJST,+PSJSTP,PSJORD)=""
 S ^PS(55,PSJPDFN,"IV","AIS",+PSJSTP,PSJORD)=""
 S ^PS(55,"AIV",+PSJSTP,PSJPDFN,PSJORD)=""
 I PSJST?1.2U S ^PS(55,PSJPDFN,"IV","AIT",PSJST,+PSJSTP,PSJORD)=""
 Q:$G(OPSJSTP)=""
 I PSJST?1.2U K ^PS(55,PSJPDFN,"IV","AIT",PSJST,OPSJSTP,PSJORD)
 K ^PS(55,PSJPDFN,"IV","AIS",OPSJSTP,PSJORD)
 K ^PS(55,"AIV",OPSJSTP,PSJPDFN,PSJORD)
IVNVDT ;
 S:$G(PSJNVDT)]"" $P(^PS(55,PSJPDFN,"IV",PSJORD,4),"^",2)=+$G(PSJNVDT)
 Q
