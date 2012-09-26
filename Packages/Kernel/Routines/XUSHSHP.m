XUSHSHP ;SF/STAFF - HASHING ROUTINE FOR SIG BLOCK IN FILE 200 ;4/24/89  15:26 ; 10/10/06 3:21pm
 ;;8.0;KERNEL;;Jul 10, 1995
 ;;DSS Version: 1.0
 ;
 ;DSS/LM - Entire routine modified to support MD5 encryption (Blowfish hooks)
 ;
HASH ;;Primary entry point
 Q:'$D(X)
 D ^XUSHSH Q  ;Use AV-code one-way hash for ES, replacing EN1 (per SMP)
 ;D EN1
 Q
 ;;
EN ; [Encrypt] Called by various
 D X^VFDXTX("ENCRYPT STRING")
 Q
 ;;
DE ; [Decrypt] Called by various
 D X^VFDXTX("DECRYPT STRING")
 Q
EN1 ;
EN2 ;
EN3 Q
