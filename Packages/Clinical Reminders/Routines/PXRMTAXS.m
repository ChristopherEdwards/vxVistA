PXRMTAXS ; SLC/PKR - Set taxonomy search variables. ;04/07/2005
 ;;2.0;CLINICAL REMINDERS;**4**;Feb 04, 2005;Build 21
 ;
 ;=====================================================
SETVAR(TAXARR,ENS,INS,NICD0,NICD9,NCPT,NRCPT,PLS,RAS) ;
 N ALL,TEMP
 ;Initialize the taxonomy search variables.
 S TEMP=$G(TAXARR(0))
 S NICD0=+$P(TEMP,U,3)
 S NICD9=+$P(TEMP,U,5)
 S NCPT=+$P(TEMP,U,7)
 S NRCPT=+$P(TEMP,U,9)
 ;Setup the Patient Data Source control variables.
 S TEMP=$P(TAXARR(811.2,0),U,4)
 ;The default is to search all locations.
 S ALL=$S(TEMP="":1,TEMP="ALL":1,1:0)
 I ALL S (ENS,INS,PLS,RAS)=1 Q
 S ENS=$S(TEMP["EN":1,1:0)
 S INS=$S(TEMP["IN":1,1:0)
 S PLS=$S(TEMP["PL":1,1:0)
 S RAS=$S(TEMP["RA":1,1:0)
 Q
 ;
