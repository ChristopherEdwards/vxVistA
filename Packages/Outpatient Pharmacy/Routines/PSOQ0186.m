PSOQ0186 ;HINES/RMS - MEDICATION WORKSHEET HEALTH SUMMARY ; 30 Nov 2007  7:51 AM
 ;;7.0;OUTPATIENT PHARMACY;**294**;DEC 1997;Build 13
 ;
TASK2 ;NEW ENTRY POINT FOR REVISIONS WITH PENDING MEDS
 N PSOSITE,ARLPAT
 S ARLPAT=+DFN,PSOQHS=1
 S PSOSITE=$O(^PS(59,"D",+$$SITE^VASITE,0))
 I PSOSITE']"" S PSOSITE=$O(^PS(59,0))
 D EN^PSOQMCAL
 K PSOQHS
 Q
