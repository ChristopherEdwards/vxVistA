IBDFN5 ;ALB/CJM - ENCOUNTER FORM - (entry points for used to print Health Summaries);6/16/93
 ;;3.0;AUTOMATED INFO COLLECTION SYS;;APR 24, 1997
 ;
PRNTSMRY(GMTSTYP) ;prints the health summary
 ;INPUTS:
 ;DFN 
 ;GMTSTYP is a ptr to the HEALTH SUMMARY TYPE file
 ;
 ;
 ;check that required variables are defined
 Q:'$G(GMTSTYP)!'$G(DFN)
 I '$L($T(ENX^GMTSDVR)),$L($T(SELTYP1^GMTS)),$L($T(EN^GMTS1)) D
 .;protect stuff that might be killed
 .N S1,S2,S2,GMI,GMTSEG,GMTSEGI,GMI,GMTSTITL,GMTSCVD,GMTSICF,GMTSCKP,GMW,GMTSEGC
 .N GMTSNPG,GMTSPG,GMTSQIT,GMTSHDR,GMTSHD2,GMTSBRK,GMTSLCMP,GMTSDTC,GMTSEGN,GMTSE,GMTSEGR,GMTSEQ,GMTSEGH,GMTSEGL,GMTSDLM,GMTSDLS,GMTSNDM,GMTSN,GMTSQ,GMTSQIT,ZTSK,GMTSDLS,GMTSN,GMTSDLM
 .N %T,DIC,GMTS,GMTSLO,GMTSPNM,GMTSRB,GMTSWARD,GMTSDOB,X,Y,VA,VAIN,VAINDT,VADM,VAEL,VAPA,VAERR,GMTSSN,GMTS0,GMTS1,GMTS2
 .N GMTSAGE,GMTSTIM,GMTSEGH,GMTSEGL,GMTSHDR,GMTSNPG,GMTSPG,GMTSX,ENTRY,Z1,GMTSDTM,GMTSLOCK,GMTSLPG,SEX,POP,C,GMTSTOF
 .S GMTSTITL=$G(^GMT(142,GMTSTYP,"T")) S:GMTSTITL="" GMTSTITL=$P($G(^GMT(142,GMTSTYP,0)),"^")
 .D SELTYP1^GMTS
 .D EN^GMTS1
 I $L($T(ENX^GMTSDVR)) D ENX^GMTSDVR(DFN,GMTSTYP)
 Q
