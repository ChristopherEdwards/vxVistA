VFDCDPT2 ;DSS/SGM - PATIENT INPATIENT DATA ;03/07/2006 00:36
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;As of 3/1/2006 this routine should not be directly invoked.
 ;See routine VFDCDPT
 ;
IN(VFDC,DFN,DATE,LODGE) ;Return info about patient's inpatient stay
 ;RETURN:
 ;VFDC(1) = current admission data
 ;   p1 = boolen flag 1 if inpatient, 0 if not
 ;   p2 = admission movement pointer (#405)
 ;   p3 = current ward pointer (#42)
 ;   p4 = current ward name
 ;   p5 = current admission Fileman date.time
 ;   p6 = current addmision external date.time
 ;   p7 = ptf specialty code for current ward (ien to 42.4)
 ;   p8 = ptf specialty name for current ward
 ;   p9 = ptf specialty service for current ward
 ;  p10 = pointer to PTF record for this admission
 ;  p11 = DUZ for the attending physician
 ;  p12 = name of attending physician
 ;VFDC(2) = data related to the movement associated with DATE
 ;   p1 = ien to movement file (#405)
 ;   p2 = Fileman date.time of movement
 ;   p3 = external date.time of movement
 ;   p4 = internal WARD
 ;   p5 = external WARD
 ;   p6 = internal TRANSACTION TYPE
 ;   p7 = external TRANSACTION TYPE
 ;   p8 = internal TYPE OF MOVEMENT
 ;   p9 = external TYPE OF MOVEMENT
 ;  p10 = internal PRIMARY CARE PHYSICIAN
 ;  p11 = external PRIMARY CARE PHYSICIAN
 ;  p12 = internal FACILITY TREATING SPECIALITY
 ;  p13 = external FACILITY TREATING SPECIALITY
 ;  p14 = internal ROOM-BED
 ;  p15 = external ROOM-BED
 ;VFDC(3) = data for associated admit movement for VFDC(2)
 ;  p1-p13 same as above except it is for admit movement
 ;  p14 - pointer to PTF record for this admission
 ;VFDC(4) = data for associated discharge movement
 ;  p1-p13 same as above except it is for discharge movement
 ;RETURN: VFDC(1) = -1^message   if problems
 ;        VFDC(2),VFDC(3),VFDC(4) may be <null>
 ; If DATE falls in range of current admission and patient has
 ; not been discharged, then VFDC(4) will be <null>
 ;
 N I,X,Y,Z,FROM,TO,VAIP,WARD
 I '$G(DFN) S VFDC(1)=$$ERR(1) Q
 I $G(DATE),DATE'?7N.E S VFDC(1)=$$ERR(2) Q
 I $G(LODGE) S VAIP("L")=""
 S VFDC(1)=$$CUR
 I $G(DATE) D KVA^VADPT D
 .S VAIP("D")=$E(DATE,1,7) S:$G(LODGE) VAIP("L")="" D IN5^VADPT
 .Q
 ;  set up movement for date
 S VFDC(2)=VAIP(1) I VAIP(1) S Y=0 D
 .F I=3,5,2,4,7,8,6 S Y=Y+2 S:VAIP(I)[U $P(VFDC(2),U,Y)=VAIP(I)
 .Q
 ;  set up admission movement
 S VFDC(3)=VAIP(13) I VAIP(13) S Y=0 D
 .F I=1,4,2,3,5,6 S Y=Y+2 S:VAIP(13,I)[U $P(VFDC(3),U,Y)=VAIP(13,I)
 .S $P(VFDC(3),U,14)=VAIP(12)
 .Q
 ;  set up discharge movement
 S VFDC(4)=VAIP(17) I VAIP(17) S Y=0 D
 .F I=1,4,2,3,5,6 S Y=Y+2 S:VAIP(17,I)[U $P(VFDC(4),U,Y)=VAIP(17,I)
 .Q
 D KVA^VADPT
 Q
 ;
INQ(VFDC,DFN,FLAG,LODGE,FUN) ;
 ;Return specific information about the current admission
 ;FLAG - opt - set of codes determining which movement data to return
 ;  default to MDWFPpAa^MD^MD
 ;  FLAG consists of p1^p2^p3:
 ;    p1=current   p2=admission   p3=discharge
 ;    The position of a code in the FLAG string determines the
 ;    '^'-piece that value will have in the return string
 ;    FLAG  Description
 ;    ----  -----------------------------------------------------
 ;      M   pointer to movement (#405)
 ;      D   external movement date.time
 ;      d   internal (Fileman movement date.time)
 ;      W   external ward location
 ;      P   name of Primary Care Physician
 ;      p   DUZ of Primary Care Physician
 ;    Following only applicable to current movement
 ;      F   pointer to PTF record (#45)
 ;      R   external room-bed
 ;      A   name of ATTENDING PHYSICIAN
 ;      a   DUZ of ATTENDING PHYSICIAN
 ;      S   external FACILITY TREATING SPECIALTY (#42.4)
 ;      s   internal FACILITY TREATING SPECIALTY (#42.4)
 ;
 ;RETURN: -1^message if not an inpatient or problems encountered
 ;       p1^p2^p3^p4^p5^...  depending upon the codes in FLAG
 ;       For the default FLAG value:
 ;       p1 = M (current)        p7 = A (current)
 ;       p2 = D (current)        p8 = a (current)
 ;       p3 = W (current)        p9 = M (admission)
 ;       p4 = F (current)       p10 = D (admission)
 ;       p5 = P (current)       p11 = M (discharge)
 ;       p6 = p (current)       p12 = D (discharge)
 N I,J,X,Y,Z,CUR,DENTX,VAIP
 I '$G(DFN) S VFDC=$$ERR(1) G OUT
 I $G(LODGE) S VAIP("L")=""
 S FLAG=$G(FLAG) S:FLAG="" FLAG="MDWFPpAa^MD^MD"
 S X=$$CNVT^VFDCUTL(FLAG,"MDdWPpFRAaSs^") S:X'="" FLAG=X
 I X="" S VFDC=$$ERR(3) G OUT
 S CUR=$$CUR
 I CUR<1 S VFDC="-1^"_$P(CUR,U,2) G OUT
 S VFDC=""
 F I=1:1:3 S Z=$P(FLAG,U,I) I Z'="" F J=1:1:$L(Z) D  Q:+VFDC=-1
 .S X="",Y=$E(Z,J)
 .I Y="M" S X=$S(I=1:VAIP(1),I=2:VAIP(13,1),1:VAIP(17,1))
 .I Y="D" S X=$P($S(I=1:VAIP(3),I=2:VAIP(13,1),1:VAIP(17,1)),U,2)
 .I Y="d" S X=$P($S(I=1:VAIP(3),I=2:VAIP(13,1),1:VAIP(17,1)),U)
 .I Y="W" S X=$P($S(I=1:VAIP(5),I=2:VAIP(13,4),1:VAIP(17,4)),U,2)
 .I Y="P" S X=$P($S(I=1:VAIP(7),I=2:VAIP(13,5),1:VAIP(17,5)),U,2)
 .I Y="p" S X=$P($S(I=1:VAIP(7),I=2:VAIP(13,5),1:VAIP(17,5)),U)
 .I I=1 D
 ..I Y="F" S X=VAIP(12)
 ..I Y="R" S X=VAIP(6)
 ..I Y="A" S X=$P(VAIP(18),U,2)
 ..I Y="a" S X=$P(VAIP(18),U)
 ..I Y="S" S X=$P(CUR,U,8)
 ..I Y="s" S X=$P(CUR,U,7)
 ..Q
 .S Y=$L(VFDC)+$L(X)+1
 .I Y>511 S VFDC=$$ERR(4) Q
 .S VFDC=VFDC_X_U
 .Q
 ;
OUT Q:$G(FUN) VFDC Q
 ;
 ;-------------------  subroutines  --------------------
CUR() ;  called from above
 ;  DO IN5^VADPT for NOW
 ;    do not kill off VAIP() or call KVA^VADPT upon exiting CUR
 ;  RETURN:
 ;   string as defined above for VFDC(1)
 ;   if not an inpatient return 0^message
 ;   if problems return -1^message
 N I,X,Y,Z,RET,WARD
 I '$D(DFN) Q $$ERR(1)
 I $G(LODGE) S VAIP("L")=""
 D KVA^VADPT,IN5^VADPT
 I VAERR Q $$ERR(5)
 I VAIP(13,1)="" Q $$ERR(6)
 S RET=1_U_VAIP(13)_U_VAIP(13,4),$P(RET,U,5)=VAIP(1)
 S WARD=$P(VAIP(5),U)
 I WARD S X=$$SPEC^VFDCDGW(,WARD,1) S:X>0 $P(RET,U,7)=X
 S $P(RET,U,10)=VAIP(12)_U_VAIP(18)
 Q RET
 ;
ERR(X) ;
 I X=1 S X="No patient DFN received"
 I X=2 S X="Invalid Fileman date received: "_DATE
 I X=3 S X="'"_FLAG_"' is not a valid FLAG parameter"
 I X=4 S X="Requested data exceed max string length"
 I X=5 S X="Problems encountered"
 I X=6 S X="0^Patient is not currently an inpatient"
 I $E(X)'="0" S X="-1^"_X
 Q X
