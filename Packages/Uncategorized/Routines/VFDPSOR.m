VFDPSOR ;DSS/WLC; Driver routine for finishing and releasing a prescription in VxVista ; 1/4/07 1:17pm
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
     ;;
     ;; This routine is called to finish and release an ordered prescription without the use of backdoor O/P Pharmacy.
     ;; The result of this routine is to create a ^XTMP global with pertinent information from the prescription to be used
     ;; by the VFDPOAE routine to generate a printed prescription to be given to the patient upon leaving.
     ;; 
     ;; [DSS/LM] - New remote procedure VFD PS LABELS BY ORDER LIST does not use data saved in ^XTMP by this routine.
     ;;            Old remote procedure VFD PS PT OUTLABEL is no longer supported and should be removed.
     ;;            Therefore, ^XTMP will no longer be used for storage of prescription data for subsequent use by RPC.
     ;;            [^XTMP sets removed 11/2/2006]
     ;; 
     ;; Direct sets to the Prescription global are used in order to get around inconsistencies with the global and FILEMAN.
     ;; Specifically, an error occurs when trying to add a record through the database calls because a previous field is using 
     ;; a subsequently set field as part of a MUMPS style cross-reference.  Since the latter field has not been added to the file
     ;; yet, the cross-reference errors out.  In addition, there are some inconsistencies with required identifiers in the file.
     ;; This program does use some FILEMAN database calls to do updates once the record is created.
     ;; 
     ;; DBIA:
     ;; 
     ;; PEN^PSO5241                                      DBIA 4821
     ;; FILEMAN                                          Add, edits, and delete to file #52 and 52.41 have NO DBIA's
     ;;
     Q
     ;
     ;  DSS/LM 9/21/2006 - Per Steve, remove references to ^XTMP.
     ;                     I.e. Do not save PSOIEN list in ^XTMP.
     ;                     RPC will furnish [placer] orders list.
     ;                     RPC code will use File 52 "RPL" x-ref.
     ;
RELEASE ;
     ; Finish and Release the order from PS(52.41 & OR(100)
     N I,II,PSORSTAT,PSOCOM,PSODFN,PSOL,PSOM,PSORX,PSOREC0,PSODRUG
     N PSOSITE,PSOY,SIGOK,SITE,FDAX,PSORET
     N DIE,DR,DA,%,DIK,DOSE,DOSE1,OR0,ORVP,PSOANSQ,PSOCOU,PSOCOUU,PSONEW
     N PSOSCP,PTRF,ROUTE,UNITS,REC
     N PSOTN,PSODRG,PSOPEN,PSODATE,PSODAT,PSOCS,PSOIEN,PSORXN
     N X,X1,X2,ERR,PEND
     S VFDMSG=""
     ; DSS/LM: Replace ^XMB(1.1) with reference with patient location specific
     ;         OUTPATIENT SITE computation.
     I $G(VFDORD) S PSOSITE=$$SITE^VFDPSUTL(VFDORD)
     I '$G(PSOSITE) S SITE=$P($G(^XMB(1,1,"XUS")),U,17) S:SITE PSOSITE=$O(^PS(59,"C",SITE,""))
     I '$G(PSOSITE) S VFDMSG="-1^Could not identify OUTPATIENT SITE" Q
     ; DSS/LM: End substitution
     I $G(VFDORD)="" S VFDMSG="-1^No Order number sent" Q
     I $G(VFDORD)="" S VFDMSG="-1^Invalid Order number" Q
     S VFDORD=+VFDORD
     I $G(^OR(100,VFDORD,0))="" S VFDMSG="-1^Cannot find Order file entry" Q
     K FDAX
     S PSODFN=+$$GET1^DIQ(100,VFDORD_",",.02,"I")  ; patient DFN
     S PSOCOM=$O(^VA(200,"B","COMMERCIAL,PHARMACY",""))  I PSOCOM="" S VFDMSG="-1^COMMERCIAL,PHARMACY not setup in NEW PERSON (#200) File." Q
     ; DSS/LM: Comment-out PSOSITE set here
     ;         PSOSITE has been defined in $$SITE^VFDPSUTL call above
     K PEND,ERR
     S PSOPEN=$O(^PS(52.41,"B",VFDORD,""))
     D GETS^DIQ(52.41,PSOPEN_",","**","I","PEND","ERR") I $D(ERR) S VFDMSG="-1^Error retrieving Pending Order" Q
     S PSODRG=+PEND(52.41,PSOPEN_",",11,"I")
     I 'PSODRG S VFDMSG="-1^Unidentified DRUG" Q  ;DSS/LM
     S PSODRUG("IEN")=PSODRG,PSODRUG("DEA")=$$GET1^DIQ(50,PSODRG_",",3)
     D AUTO^PSONRXN S PSORXN=PSONEW("RX #") ; auto-numbering of prescription
     ;
     S PSODATE=$$NOW^XLFDT,PSODAT=$P(PSODATE,".",1)
     ; DSS/LM - Per Steve, revise PSOIEN computation and lock 0-node
     S PSOIEN=$$PSRXIEN^VFDPSUTL Q:'PSOIEN  L +^PSRX(PSOIEN):2 E  Q
     S $P(^PSRX(PSOIEN,0),U,1)=PSORXN                                                            ; RX #
     S $P(^PSRX(PSOIEN,"STA"),U,1)=0                                                             ; STATUS
     S $P(^PSRX(PSOIEN,0),U,13)=PSODAT                                                           ; ISSUE DATE
     S $P(^PSRX(PSOIEN,0),U,2)=PSODFN                                                            ; PATIENT
     S $P(^PSRX(PSOIEN,0),U,3)=20                                                                ; PATIENT STATUS = NON-VA
     S $P(^PSRX(PSOIEN,0),U,4)=PEND(52.41,PSOPEN_",",5,"I")                                      ; PROVIDER
     S $P(^PSRX(PSOIEN,0),U,5)=PEND(52.41,PSOPEN_",",1.1,"I")                                    ; CLINIC
     S $P(^PSRX(PSOIEN,0),U,6)=PSODRG                                                            ; DRUG
     S $P(^PSRX(PSOIEN,0),U,7)=PEND(52.41,PSOPEN_",",12,"I")                                     ; QTY
     S $P(^PSRX(PSOIEN,0),U,8)=PEND(52.41,PSOPEN_",",101,"I")                                    ; DAYS SUPPLY
     S $P(^PSRX(PSOIEN,0),U,9)=PEND(52.41,PSOPEN_",",13,"I")                                     ; NUM OF REFILLS
     S $P(^PSRX(PSOIEN,0),U,11)="W"                                                              ; MAIL/WINDOW
     S $P(^PSRX(PSOIEN,0),U,16)=+DUZ                                                             ; ENTERED BY
     S $P(^PSRX(PSOIEN,0),U,17)=$$GET1^DIQ(50,PSODRG_",",404)                                    ; UNIT PRICE OF DRUG
     S $P(^PSRX(PSOIEN,0),U,18)=1                                                                ; COPIES
     S $P(^PSRX(PSOIEN,2),U,1)=PSODATE                                                           ; LOGIN DATE
     S $P(^PSRX(PSOIEN,2),U,2)=PSODATE                                                           ; FILL DATE
     S $P(^PSRX(PSOIEN,2),U,3)=PSOCOM                                                            ; PHARMACIST
     S X1=PSODAT,X2=PEND(52.41,PSOPEN_",",101,"I")*(PEND(52.41,PSOPEN_",",13,"I")+1)\1 S:X2=0 X2=PEND(52.41,PSOPEN_",",101,"I")
     S $P(^PSRX(PSOIEN,2),U,6)=$$FMADD^XLFDT(X1,X2) K X1,X2                                      ; STOP DATE
     S $P(^PSRX(PSOIEN,2),U,9)=PSOSITE ;VFDP*1.0*4                                               ; DIVISION (added in patch)
     S $P(^PSRX(PSOIEN,2),U,13)=PSODATE                                                          ; RELEASED DATE/TIME
     S $P(^PSRX(PSOIEN,3),U,1)=PSODATE                                                           ; LAST DISPENSED DATE
     ; SIG
     S PSOM=+$P($G(^PS(52.41,+PSOPEN,"SIG",0)),U,4)
     I +PSOM>0 D
     . F PSOL=1:1:PSOM D
     . . N X,Y,Z
     . . S Y=PEND(52.4124,PSOL_","_PSOPEN_",",.01,"I"),Z=Y
     . . S X=$F(Y,"BY BY") I X>0 S Z=$E(Y,1,X-4)_$E(Y,X,99)
     . . S ^PSRX(PSOIEN,"SIG1",PSOL,0)=Z
     . S $P(^PSRX(PSOIEN,"SIG1",0),U,3,4)=PSOM
     ;
     ; PROVIDER COMMENTS
     S PSOM=+$P($G(^PS(52.41,PSOPEN,"INS1",0)),U,4)
     I +PSOM>0 D
     . F PSOL=1:1:PSOM D
     . . N X,Y,Z
     . . S Y=$G(^PS(52.41,PSOPEN,"INS1",PSOL,0)) Q:Y=""
     . . S Z=Y
     . . S X=$F(Y,"BY BY") I X>0 S Z=$E(Y,1,X-4)_$E(Y,X,99)
     . . S ^PSRX(PSOIEN,"INS1",PSOL,0)=Z
     . S $P(^PSRX(PSOIEN,"INS1",0),U,3,4)=PSOM
     ;
     ; SCHEDULE/ROUTE
     ; 
     F PSOL=1:1 Q:'$D(^PS(52.41,PSOPEN,1,PSOL,0))  D
     . N PSARR,PS1,PS2 S PSARR=$NA(^PSRX(PSOIEN,6,PSOL,0))
     . S PS1=$G(^PS(52.41,PSOPEN,1,PSOL,1)),PS2=$G(^PS(52.41,PSOPEN,1,PSOL,2))
     . S $P(@PSARR,U,1)=$P(PS2,U,1),$P(@PSARR,U,2)=$P(PS2,U,2),$P(@PSARR,U,3)=$P(PS1,U,9),$P(@PSARR,U,4)=$P(PS1,U,5),$P(@PSARR,U,5)=$P(PS1,U,2)
     . S $P(@PSARR,U,6)=$P(PS1,U,6),$P(@PSARR,U,7)=$P(PS1,U,8),$P(@PSARR,U,8)=$P(PS1,U,10)
     . S ^PSRX(PSOIEN,6,0)="^52.0113^"_PSOL_U_PSOL
     ;
     F PSOL=1:1 Q:'$D(^PS(52.41,PSOPEN,3,PSOL,0))  S ^PSRX(PSOIEN,"PI",PSOL,0)=^PS(52.41,PSOPEN,3,PSOL,0),^PSRX(PSOIEN,"PI",0)="^52.02^"_PSOL_U_PSOL
     F PSOL=1:1 Q:'$D(^PS(52.41,PSOPEN,2,PSOL,0))  S ^PSRX(PSOIEN,"PRC",PSOL,0)=^PS(52.41,PSOPEN,2,PSOL,0),^PSRX(PSOIEN,"PRC",0)="^52.039^"_PSOL_U_PSOL
     ; DSS/LM - Next is moved to before re-index entry, for placer order index
     S $P(^PSRX(PSOIEN,"OR1"),U,2)=VFDORD,$P(^PSRX(PSOIEN,"OR1"),U,5,6)=$P(^PSRX(PSOIEN,0),U,4)  ; store placer number and pharmacist
     K ^PS(55,PSODFN,"P","A",$P(^PSRX(PSOIEN,2),U,6),PSOIEN)  ; kill extra node for active orders
     L -^PSRX(PSOIEN),-^PSRX("B",PSORXN) ;DSS/LM
     S DA=PSOIEN,DIK="^PSRX(" D IX1^DIK  ; re-index this entry
     ; update finishing, filling person, and checking pharmacist
     N I,VFDFDA ;Remove VFDMSG from NEW list (debug)
     K VFDFDA,VFDMSG
     S VFDFDA(52,PSOIEN_",",31)=$$NOW^XLFDT
     ; LM 1/24/2007 - Replace next: Constant 38 should have been variable I
     ;F I=38:.1:38.2,104,30,23,4 S VFDFDA(52,PSOIEN_",",38)=PSOCOM
     F I=38:.1:38.2,104,23 S VFDFDA(52,PSOIEN_",",I)=PSOCOM
     ; LM 1/31/2007 - Remove field 4 and 30 (provider fields)
     ;S VFDFDA(52,PSOIEN_",",30)="COMMERCIAL,PHARMACY"
     S VFDFDA(52,PSOIEN_",",10.1)=1 ;OERR SIG
     ; End change 1/24/2007
     D FILE^DIE("","VFDFDA","VFDMSG")
     D PS55 ;LM 3/17/2007 - Add PRESCRIPTION PROFILE VFDP_REV_MAR07_1p0-T1.KID
     ;
     ;; ***** End Prescription file updates *****
     D EN^PSOHLSN1(PSOIEN,"ZD")
     ;
     ; ORDER (#100) FILE updates
     ; update status of order
     S PSORSTAT=$S($O(^ORD(100.01,"B","WRITTEN",""))>0:$O(^ORD(100.01,"B","WRITTEN","")),1:6)
     S ORVP=$$GET1^DIQ(100,VFDORD_",",.02)
     ; DSS/LM - Remove set of ^PSRX(0) in next -- Already set
     S X=$G(^PSRX(0)),Y=$P(X,U,3)+1,Z=$P(X,U,4)+1,$P(X,U,3)=Y,$P(X,U,4)=Z ;^PSRX(0)=X  ; update FILEMAN counters
     D STATUS^ORCSAVE2(VFDORD,PSORSTAT)
     D RELEASE^ORCSAVE2(VFDORD,1,,$P(^PSRX(PSOIEN,0),U,4),9)  ; mark order as released
     ;
     K VFDFDA,VFDMSG S VFDFDA(100,VFDORD_",",21)=$P(^PSRX(PSOIEN,2),U,2),VFDFDA(100,VFDORD_",",22)=$P(^PSRX(PSOIEN,2),U,6),VFDFDA(100,VFDORD_",",1)=PSOCOM,VFDFDA(100.008,"1,"_VFDORD_",",17)=PSOCOM
     S VFDFDA(100,VFDORD_",",33)=PSOIEN ;LM
     S VFDFDA(100,VFDORD_",",66)=$$NOW^XLFDT,VFDFDA(100,VFDORD_",",67)=PSOCOM
     S VFDFDA(100.008,"1,"_VFDORD_",",16)=$$NOW^XLFDT D FILE^DIE("","VFDFDA","VFDMSG") ; update start and stop dates in ORDERS file
     ;; ************************ End Order file updates ****************************
     ;
     S VFDMSG="1"_U_PSOIEN_U_"PS"
     ; DSS/LM - Set ^XTMP(...) removed
EX   Q:'$G(PSOPEN)  S DA=+PSOPEN,DIK="^PS(52.41," D ^DIK
     Q
PS55 ;; DSS/LM - Wrap call to PS55^PSON52
 ; to set PRESCRIPTION PROFILE entry in File 55
 ; 
 Q:'$G(PSODFN)!'$G(PSOIEN)  N PSOX S PSOX("IRXN")=+PSOIEN
 N PSONEW S PSONEW("STOP DATE")=$P(^PSRX(PSOIEN,2),U,6)
 D PS55^PSON52
 Q
