VFDGMVI ;DSS/LM - vxVistA Vitals RPCs ;January 24, 2008
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 Q
GET(VFDRSLT,VFDFN,VFDVDA,VFDQDA,VFDRNG) ;VFD GET VITALS MEASUREMENTS
 ; 
 ; VFDFN=[Required] Patient IEN
 ; VFDVDA=[Required] Vital Type IEN
 ; VFDQDA=[Optional] Qualifier IEN(s)
 ; VFDRNG=[Optional] Begin^End date (inclusive)
 ; 
 ; VFDRSLT=Results array, subscripted 1, 2, 3, ...
 ;         VFDRSLT(I)=Date/time vitals taken (FM internal)^internal^external
 ;         Excludes results entered in error
 ; 
 I $G(VFDFN)>0 S VFDFN=+VFDFN
 E  S VFDRSLT(1)="-1^Missing or invalid DFN" Q
 I $G(VFDVDA)>0 S VFDVDA=+VFDVDA,VFDQDA=$G(VFDQDA),VFDRNG=$G(VFDRNG)
 E  S VFDRSLT(1)="-1^Missing or invalid vital type IEN" Q
 I $L($G(VFDQDA)) N VFD,VFDA,VFDEND,VFDI,VFDK,VFDMLST,VFDT,VFDQI,VFDQQ,VFDQX,VFDZ
 F VFDI=1:1 S VFD=$P(VFDQDA,U,VFDI) Q:VFD=""  D
 .S VFDQX(VFD)=VFDI ;Cross-reference qualifiers
 .Q
 S VFDEND=$P(VFDRNG,U,2) S:VFDEND&'(VFDEND[".") VFDEND=VFDEND_".24"
 S VFDT="",VFDK=0
 F  S VFDT=$O(^GMR(120.5,"AA",VFDFN,VFDVDA,VFDT)) Q:VFDT=""!(9999999-VFDT<VFDRNG)!(VFDK&'VFDRNG)  D
 .I VFDEND,9999999-VFDT>VFDEND Q  ;Exclude if after specified end date
 .S VFDA=$O(^(VFDT,0)) S VFDZ=$G(^GMR(120.5,VFDA,0))
 .Q:'($P(VFDZ,U,3)=VFDVDA)  ;Match to Vital Type
 .Q:$P($G(^GMR(120.5,VFDA,2)),U)  ;Exclude if "entered in error"
 .S (VFDQI,VFDQQ)=0 F  Q:VFDQQ  S VFDQI=$O(VFDQX(VFDQI)) Q:'VFDQI  D  ;Qualifiers
 ..Q:$D(^GMR(120.5,VFDA,5,"B",VFDQI))  S VFDQQ=1
 ..Q
 .Q:VFDQQ  ;Failure to match ALL specified qualifiers
 .S VFDK=VFDK+1,VFDRSLT(VFDK)=VFDA_U_$P(VFDZ,U)_U_$P(VFDZ,U,8) ;T1 - Add VFDA
 .S VFDRSLT(VFDK)=VFDRSLT(VFDK)_U_$$QUAL(VFDA) ; T1 - Add qualifiers list
 .Q
 S:'$D(VFDRSLT(1)) VFDRSLT(1)="-1^No qualifying measurements found"
 Q
QUAL(VFDA) ;[Private] List of qualifiers associated with GMRV VITAL MEASUREMENT
 ; VFDA=[Required] File 120.5 entry
 ; 
 I $G(VFDA)>0,VFDA?1.N N VFDJ,VFDX,VFDY S (VFDJ,VFDX,VFDY)=""
 E  Q ""
 F  S VFDJ=$O(^GMR(120.5,VFDA,5,"B",VFDJ)) Q:VFDJ=""  D
 .S VFDX=$P($G(^GMRD(120.52,VFDJ,0)),U) Q:'$L(VFDX)
 .S:$L(VFDY) VFDY=VFDY_"," S VFDY=VFDY_VFDX
 .Q
 Q VFDY
 ;
