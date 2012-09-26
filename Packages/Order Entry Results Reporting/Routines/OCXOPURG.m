OCXOPURG ;SLC/RJS,CLA - Purge old Log and Patient Data ;4/02/02  08:38
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,143**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
EN ;
 ;
 N OCXE0,OCXE1,OCXE2,OCXS,OCXDFN,OCXCNT,OCXDATE,OCXRUL,OCXKEEP,OCXFILE
 N OCXFIRST,OCXLAST,OCXOVER
 ;
 ;   Purge OCX namespaced entries in ^TMP that have expired.
 ;
 S OCXS="OCX" F  S OCXS=$O(^TMP(OCXS)) Q:'$L(OCXS)  Q:'($E(OCXS,1,3)="OCX")  D
 .S OCXE0=0 F  S OCXE0=$O(^TMP(OCXS,OCXE0)) Q:'$L(OCXE0)  D
 ..K:($G(^TMP(OCXS,OCXE0))<($P($H,",",2)+($H*86400))) ^TMP(OCXS,OCXE0)
 ;
 D PURGE^OCXCACHE
 ;
 S OCXDATE=0 F  S OCXDATE=$O(^OCXD(860.7,"AT",OCXDATE)) Q:'OCXDATE  I (OCXDATE<($H-5)) D
 .S OCXDFN=0 F  S OCXDFN=$O(^OCXD(860.7,"AT",OCXDATE,OCXDFN)) Q:'OCXDFN  D
 ..S OCXRUL=0 F  S OCXRUL=$O(^OCXD(860.7,"AT",OCXDATE,OCXDFN,OCXRUL)) Q:'OCXRUL  D
 ...N OCXNODE
 ...S OCXNODE=$G(^OCXD(860.7,OCXDFN,1,OCXRUL,0))
 ...I ($P(OCXNODE,U,2)=OCXDATE) D
 ....K ^OCXD(860.7,OCXDFN,1,OCXRUL)
 ....K ^OCXD(860.7,OCXDFN,"B",OCXRUL,OCXRUL)
 ....I '$O(^OCXD(860.7,OCXDFN,1,0)) D
 .....K ^OCXD(860.7,OCXDFN)
 .....K ^OCXD(860.7,"B",OCXDFN,OCXDFN)
 ...K ^OCXD(860.7,"AT",OCXDATE,OCXDFN,OCXRUL)
 ;
 I '($P($G(^OCXD(861,1,0)),U,1)="SITE PREFERENCES") K ^OCXD(861,1) S ^OCXD(861,1,0)="SITE PREFERENCES"
 ;
 I '($P($G(^OCXD(861,1,0)),U,2)=(+$H)) D
 .I $L($T(LOG^OCXOZ01)),$$LOG^OCXOZ01 S OCXKEEP=$$DT("TODAY-"_(+$$LOG^OCXOZ01)) I 1
 .E  S OCXKEEP=$$DT("TODAY-3")
 .K ^OCXD(861,"B")
 .S OCXE1=0,OCXE0=1 F  S OCXE0=$O(^OCXD(861,OCXE0)) Q:'OCXE0  D
 ..S OCXDATE=+$G(^OCXD(861,OCXE0,0))
 ..I 'OCXDATE K ^OCXD(861,OCXE0) Q
 ..I (OCXDATE<OCXKEEP) K ^OCXD(861,OCXE0) Q
 ..S ^OCXD(861,"B",OCXDATE,OCXE0)="",OCXE1=$G(OCXE1)+1
 .S $P(^OCXD(861,1,0),U,2)=(+$H)
 ;
 S OCXFIRST=$O(^OCXD(861,1))
 S OCXLAST=$O(^OCXD(861," "),-1)
 S OCXOVER=((OCXLAST-OCXFIRST)-200000)
 ;
 I (OCXOVER>0) D
 .S OCXE0=1 F OCXE1=1:1:OCXOVER S OCXE0=$O(^OCXD(861,OCXE0)) Q:'OCXE0  D
 ..S OCXDATE=$G(^OCXD(861,OCXE0,0))
 ..K ^OCXD(861,OCXE0)
 ..K ^OCXD(861,"B",OCXDATE,OCXE0)
 ;
 F OCXFILE=860.7,861 I $L($G(^OCXD(OCXFILE,0))) D
 .S OCXE0=0 F OCXCNT=0:1 S OCXE1=OCXE0,OCXE0=$O(^OCXD(OCXFILE,OCXE0)) Q:'OCXE0
 .S ^OCXD(OCXFILE,0)=$P(^OCXD(OCXFILE,0),U,1,2)_U_OCXE1_U_OCXCNT
 ;
 I '$O(^OCXD(860.7,0)) S ^OCXD(860.7,0)=$P(^OCXD(860.7,0),U,1,2)
 I '$O(^OCXD(861,0)) S ^OCXD(861,0)=$P(^OCXD(861,0),U,1,2)
 I $G(OCXE1),$O(^OCXD(861,0)) S ^OCXD(861,0)=$P(^OCXD(861,0),U,1,2)_U_$O(^OCXD(861," "),-1)_U_OCXE1
 ;
 Q
 ;
DATE() ;
 ;
 N X,Y,%DT
 S X="N",%DT="T" D ^%DT X ^DD("DD") S:(Y["@") Y=$P(Y,"@",1)_" at "_$P(Y,"@",2)
 Q Y
 ;
DT(X) N Y,%DT S %DT="" D ^%DT Q Y+17000000
 ;
