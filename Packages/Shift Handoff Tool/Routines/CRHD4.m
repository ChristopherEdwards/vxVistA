CRHD4 ; CAIRO/CLC - GET USERS PARAMETERS ;4/22/08  12:52
 ;;1.0;CRHD;****;Jan 28, 2008;Build 19
 ;=================================================================
GETALLP(CRHDRTN,CRHDUSR,CRHDDIV,CRHDPLEV) ;get all of the users parameters
 N X,X1,X2,CRHDCT,CRHDDOFG,CRHDMN,CRHDP,CRHDRSL,I,CRHDAX
 N CRHDL,CRHDVPTR,CRHDPN
 K CRHDRTN
 S CRHDVPTR("USR")=";VA(200,"      ;NEW PERSON
 S CRHDVPTR("OTL")=";OR(100.21,"   ;OE/RR TEAM
 S CRHDVPTR("SRV")=";DIC(49,"      ;SERVICE/SERVICE
 S CRHDVPTR("DIV")=";DIC(4,"       ;INSTITUTION
 S CRHDVPTR("TS")=";DIC(45.7,"     ;TREATING SPECIALTY
 S CRHDVPTR("LOC")=";SC("          ;HOSPITAL LOCATION
 S CRHDVPTR("SD")=";SCTM(404.51,"  ;SD TEAM
 S CRHDAX=+$G(CRHDPLEV)
 S CRHDL=$L($G(CRHDPLEV),"^")
 I CRHDAX D
 .S CRHDAX=CRHDAX_$G(CRHDVPTR($P(CRHDPLEV,"^",CRHDL)))
 .S CRHDDOFG=$O(^CRHD(183,"B",CRHDAX,0))
 I $G(CRHDPLEV)="" S CRHDDOFG=$$GETPLEV(CRHDUSR,CRHDDIV,0)
 I CRHDDOFG>0 D
 .I CRHDDOFG["VA(200" D USRSET(.CRHDRSL,CRHDDOFG)
 .I $D(CRHDRSL) S CRHDDOFG=$$GETPLEV(CRHDUSR,CRHDDIV,1)
 .S CRHDMN=+CRHDDOFG
 .S (CRHDP,CRHDCT)=0
 .F  S CRHDP=$O(^CRHD(183,CRHDMN,1,CRHDP)) Q:'CRHDP  D
 ..S CRHDCT=CRHDCT+1
 ..I $P($G(^CRHD(183,CRHDMN,1,CRHDP,0)),"^",2)="" D
 ...S X2=0 F  S X2=$O(^CRHD(183,CRHDMN,1,CRHDP,1,X2)) Q:'X2  D
 ....I $D(CRHDRSL($P($G(^CRHD(183,CRHDMN,1,CRHDP,0)),"^",1))) Q
 ....;I $D(CRHDRSL("STUDENT")) Q
 ....S CRHDRTN(CRHDCT)=$P($G(^CRHD(183,CRHDMN,1,CRHDP,0)),"^",1)_"^"_$G(^CRHD(183,CRHDMN,1,CRHDP,1,X2,0))
 ....S CRHDCT=CRHDCT+1
 ..E  S CRHDRTN(CRHDCT)=$G(^CRHD(183,CRHDMN,1,CRHDP,0))
 I $D(CRHDRSL) D
 .S CRHDPN=""
 .F  S CRHDPN=$O(CRHDRSL(CRHDPN)) Q:CRHDPN=""  D
 ..S CRHDX=0
 ..F  S CRHDX=$O(CRHDRSL(CRHDPN,CRHDX)) Q:'CRHDX  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDRSL(CRHDPN,CRHDX)
 Q
USRSET(CRHDLST,CRHDDA) ;
 N CRHDFG,CRHDX,CRHDP0,CRHDCT,CRHDX1
 S (CRHDX,CRHDFG,CRHDCT)=0
 F  S CRHDX=$O(^CRHD(183,+CRHDDA,1,CRHDX)) Q:'CRHDX  D
 .S CRHDP0=$G(^CRHD(183,+CRHDDA,1,CRHDX,0))
 .I $P(CRHDP0,"^",2)="" D
 ..S CRHDX1=0
 ..F  S CRHDX1=$O(^CRHD(183,+CRHDDA,1,CRHDX,1,CRHDX1)) Q:'CRHDX1  S CRHDCT=CRHDCT+1,CRHDLST(CRHDP0,CRHDCT)=$P(CRHDP0,"^",1)_"^"_$G(^CRHD(183,+CRHDDA,1,CRHDX,1,CRHDX1,0))
 .E  S CRHDCT=CRHDCT+1,CRHDLST($P(CRHDP0,"^",1),CRHDCT)=CRHDP0
 Q
GETONEP(CRHDRTN,CRHDE,PNAME) ;Get one parameter from file 183
 N CRHDPAR,Y,X,CRHDCT,CRHDMN,CRHDP,CRHDE1,CRHDE2,CRHDE3,CRHDE4
 N CRHDX2,CRHDRSL,CRHDL,CRHDXCT,CRHDTRSL,CRHDEX,CRHDEE
 S Y=-1
 S CRHDE1=+CRHDE                          ;internal entry number to file
 S CRHDE2=$P(CRHDE,"^",2)                 ;name
 S CRHDE3=$P($P(CRHDE,"^",3),"-",1)       ;types
 ;                                      USR - New Person
 ;                                      OTL - OE/RR Team
 ;                                      SRV - Service/Section
 ;                                      DIV-Institution;
 ;
 S CRHDCT=0
 S CRHDL=$L(CRHDE,"^")
 S CRHDE4="DIV.`"_$P($P(CRHDE,"^",CRHDL),"-",2)                  ;User Sign in Division
 I $P(CRHDE4,"`",2)="" D USERDIV^CRHD5(.CRHDEE,DUZ) S CRHDE4="DIV.`"_$G(CRHDEE(1))
 S CRHDPAR=CRHDE3_".`"_CRHDE1
 I CRHDPAR'="" D LOOKUP^XPAREDIT(CRHDPAR,183)
 I Y>-1 D
 .S CRHDMN=+Y
 .S CRHDP=$O(^CRHD(183,CRHDMN,1,"B",PNAME,0))
 .Q:'CRHDP
 .I $P($G(^CRHD(183,CRHDMN,1,+CRHDP,0)),"^",2)="" D
 ..S CRHDX2=0 F  S CRHDX2=$O(^CRHD(183,CRHDMN,1,+CRHDP,1,CRHDX2)) Q:'CRHDX2  D
 ...S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=$G(^CRHD(183,CRHDMN,1,+CRHDP,1,CRHDX2,0))
 .E  S CRHDRTN(1)=$P($G(^CRHD(183,CRHDMN,1,+CRHDP,0)),"^",2)
 Q
GETDNRT(CRHDRTN,CRHDUSR,CRHDDIV) ;get DNR Titles
 K CRHDRTN
 N CRHDDNR,CRHDX
 D DNRPARM^CRHDDNR(.CRHDDNR,DUZ,CRHDDIV)
 I $D(CRHDDNR) D
 .S CRHDX=0 F  S CRHDX=$O(CRHDDNR(CRHDX)) Q:'CRHDX  S CRHDRTN(CRHDX)=$P(CRHDDNR(CRHDX),"^",2)
 Q
SAVEPARM(CRHDRTN,CRHDLEV,CRHDPAR,CRHDVAL,CRHDTXT) ;save parameters
 N Y,CRHDFN,CRHDFDA,CRHDERR,CRHDOUT,CRHDFILE,CRHDXX,CRHDUPY,CRHDUPZ
 N CRHDIENS,CRHDFLAG,CRHDANS,CRHDVPTR,CRHDL,DIE,DR,DA,CRHDAX
 S CRHDVPTR("USR")=";VA(200,"      ;NEW PERSON
 S CRHDVPTR("OTL")=";OR(100.21,"   ;OE/RR TEAM
 S CRHDVPTR("SRV")=";DIC(49,"      ;SERVICE/SERVICE
 S CRHDVPTR("DIV")=";DIC(4,"       ;INSTITUTION
 ;S CRHDVPTR("TS")=";DIC(45.7,"     ;TREATING SPECIALTY
 ;S CRHDVPTR("LOC")=";SC("          ;HOSPITAL LOCATION
 ;S CRHDVPTR("SD")=";SCTM(404.51,"  ;SD TEAM
 S CRHDFN=183  ;CRHD PARAMETER FILE NUMBER
B K CRHDRTN
 S CRHDRTN(0)="0^NO DATA STORED"
 I $D(CRHDTXT)&((CRHDPAR="")&(CRHDVAL="")) D SAVELIST(.CRHDRTN,.CRHDLEV,.CRHDTXT) Q
 I CRHDPAR="" S CRHDRTN(0)="0^PARAMETER NAME MISSING" Q
 S CRHDUPY=$$CHK(CRHDLEV)
 S CRHDUPZ=$P(CRHDUPY,"^",2)
 S CRHDAX=$P(CRHDUPY,"^",3)
 S CRHDL=$L(CRHDLEV,"^")
 I CRHDAX<1 S CRHDAX=+CRHDLEV_$G(CRHDVPTR($P(CRHDLEV,"^",CRHDL)))
 I +CRHDAX S CRHDFDA(CRHDFN,CRHDUPZ,.01)=CRHDAX
 I CRHDUPZ="+1," D
 .D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
 .I '$D(CRHDERR) S CRHDUPZ=CRHDOUT(1)_",",CRHDRTN(0)=1
 .K CRHDFDA,CRHDOUT,CRHDERR
 .S CRHDFDA(CRHDFN,CRHDUPZ,.01)=CRHDAX
 I $D(CRHDFDA) D
 .S CRHDFDA(CRHDFN_".01","?+2,"_CRHDUPZ,.01)=CRHDPAR
 .S:CRHDVAL'="" CRHDFDA(CRHDFN_".01","?+2,"_CRHDUPZ,1)=CRHDVAL
 .D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
 .I '$D(CRHDERR) S CRHDMX=$G(CRHDOUT(2)),CRHDRTN(0)=1
 .I $D(CRHDTXT) D
 .S CRHDXX=0 F  S CRHDXX=$O(^CRHD(CRHDFN,+CRHDUPZ,1,CRHDMX,1,CRHDXX)) Q:'CRHDXX  D
 ..S DIE="^CRHD("_CRHDFN_","_CRHDUPZ_"1,"_CRHDMX_",1,",DA=CRHDXX,DR=".01///@"
 ..S DA(2)=+CRHDUPZ,DA(1)=CRHDMX
 ..D ^DIE
 .S CRHDX=0
 .F  S CRHDX=$O(CRHDTXT(CRHDX)) Q:'CRHDX  D
 ..S CRHDFDA(CRHDFN_.12,"?+"_(CRHDX+1)_","_CRHDMX_","_CRHDUPZ_"",.01)=$S($D(CRHDTXT(CRHDX,0)):CRHDTXT(CRHDX,0),1:CRHDTXT(CRHDX))
 .D:$D(CRHDFDA) UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
 .I '$D(CRHDERR) S CRHDRTN(0)=1
 .E  S CRHDRTN(0)="0^ERROR ENCOUNTERED STORING DATA"
 K CRHDFDA,CRHDOUT,CRHDERR
 Q
SAVELIST(CRHDRTN,CRHDLEV,CRHDTXT) ;process list of parameters
 ;list in the format:PARAMETER:VALUE
 N CRHDI,CRHDPAR,CRHDVAL,CRHDFDA,CRHDUPY,CRHDUPZ,CRHDAX,CRHDL
 K CRHDRTN
 S CRHDRTN(0)=0_"^DATA NOT STORED"
 S CRHDUPY=$$CHK(CRHDLEV)
 S CRHDUPZ=$P(CRHDUPY,"^",2)
 S CRHDAX=$P(CRHDUPY,"^",3)
 S CRHDL=$L(CRHDLEV,"^")
 I CRHDAX<1 S CRHDAX=+CRHDLEV_$G(CRHDVPTR($P(CRHDLEV,"^",CRHDL)))
 I +CRHDAX S CRHDFDA(CRHDFN,CRHDUPZ,.01)=CRHDAX
 I CRHDUPZ="+1," D
 .D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
 .I '$D(CRHDERR) S CRHDUPZ=CRHDOUT(1)_",",CRHDRTN(0)=1
 .K CRHDFDA,CRHDOUT,CRHDERR
 S CRHDFDA(CRHDFN,CRHDUPZ,.01)=CRHDAX
 S CRHDI=0
 F  S CRHDI=$O(CRHDTXT(CRHDI)) Q:'CRHDI  D
 .S CRHDPAR=$P(CRHDTXT(CRHDI),":",1)
 .S CRHDVAL=$P(CRHDTXT(CRHDI),":",2,10)
 .Q:CRHDPAR=""
 .I CRHDVAL="" D DELPAR(+CRHDUPZ,CRHDPAR) Q
 .I $D(CRHDFDA) D
 ..S CRHDFDA(CRHDFN_".01","?+"_CRHDI_","_CRHDUPZ,.01)=CRHDPAR
 ..S CRHDFDA(CRHDFN_".01","?+"_CRHDI_","_CRHDUPZ,1)=CRHDVAL
 D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
 I '$D(CRHDERR) S CRHDRTN(0)=1
 E  S CRHDRTN(0)="0^ERROR SETTING DATA"
 K CRHDFDA,CRHDOUT,CRHDERR
 Q
CHK(CRHDL) ;
 N CRHDFLG,Y,CRHDX  ;FLG = 1 if record already exist
 S CRHDFLG=0
 I $P(CRHDL,"^",2)'="" D LOOKUP^XPAREDIT($P(CRHDL,"^",2),183)
 I +Y>0 S CRHDX=+Y,CRHDFLG=1
 I CRHDFLG S CRHDFLG=CRHDFLG_"^"_CRHDX_","_"^"_$P(Y,"^",2)
 E  S CRHDFLG=CRHDFLG_"^"_"+1,"_"^"_$P(Y,"^",2)
 Q CRHDFLG
DELPAR(CRHDD1,CRHDDPAR) ;
 N DA,DIE,DR
 Q:'CRHDD1
 S DA=$O(^CRHD(183,+CRHDD1,1,"B",CRHDPAR,0))
 Q:'DA
 S DIE="^CRHD(183,"_CRHDD1_",1,"
 S DR=".01///@",DA(1)=CRHDD1
 D ^DIE
 Q
GETPLEV(CRHDDUZ,CRHDDIV,CRHDBYU) ;
 N CRHDPAR,CRHDTEAM,CRHDSRV,Y,X,CRHDDIVI
 S Y=-1
 S CRHDTEAM=$$GET^XPAR("USR.`"_CRHDDUZ,"ORLP DEFAULT TEAM",1,"I")
 S CRHDSRV=$$GET1^DIQ(200,CRHDDUZ_",",29,"E")
 S CRHDPAR="USR.`"_CRHDDUZ
 S:CRHDBYU CRHDPAR=""
 I CRHDPAR'="" D LOOKUP^XPAREDIT(CRHDPAR,183)
 I (Y<0)&($G(CRHDTEAM)>0) S CRHDPAR="OTL.`"_+CRHDTEAM D LOOKUP^XPAREDIT(CRHDPAR,183)
 I (Y<0)&($G(CRHDSRV)'="") S CRHDPAR="SRV."_CRHDSRV D LOOKUP^XPAREDIT(CRHDPAR,183)
 I '+$G(CRHDDIV) S CRHDDIV=+$$SITE^VASITE
 I (Y<0) S CRHDPAR="DIV.`"_+CRHDDIV D LOOKUP^XPAREDIT(CRHDPAR,183)
 I (Y<0) D
 .S CRHDDIVI=$O(^DIC(4,"D",CRHDDIV,0))
 .I CRHDDIVI S CRHDPAR="DIV.`"_CRHDDIVI D LOOKUP^XPAREDIT(CRHDPAR,183)
 Q Y
