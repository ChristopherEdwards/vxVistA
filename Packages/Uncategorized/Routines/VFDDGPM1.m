VFDDGPM1 ;DSS/LM - Implements patient movement events for PAMS ; August 15, 2009
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ; ICR#  Supported Description
 ; ----  ---------------------
 ; 1609  Lexicon setup search parameters
 ; 3990  ICD code API
 ; 
 Q
ADMITDX() ;Called from modified [DGPM ADMIT] input template,
 ; Return pointer to File 80 ICD DIAGNOSIS (coded admit diagnosis)
 ; 
 N DIC,X,Y
 D CONFIG^LEXSET("ICD",,$G(DT,$$DT^XLFDT))
 S DIC="^LEX(757.01,",DIC(0)="EQM",DIC("A")="DIAGNOSIS [ICD]: "
 D ^DIC
 Q $S($G(Y(1))>0:+$$ICDDX^ICDCODE($G(Y(1)),$G(DT,$$DT^XLFDT)),1:"")
 ;
