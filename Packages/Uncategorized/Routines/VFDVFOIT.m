VFDVFOIT ;DSS/GFT- SETUP VA FOIA CACHE.DAT ;9SEP2009
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 Q
 ;
D10GFT ;DEVICES
 N VFDEV,I,J,N,VFDEVKIL,DA,DIK,DIE,VFDV,DR,DIC
LIST F I="BROWSER","XDRBROWSER1","HFS","SSH","TRM","TELNET","NULL","MESSAGE P-MESSAGE-HFS","VIC CARD","OR WORKSTATION","IMAGING WORKSTATION" S VFDEV(I)=""
 F VFDEV=0:0 S VFDEV=$O(^%ZIS(1,VFDEV)) Q:'VFDEV  D
 .S N=$P($G(^(VFDEV,0)),U) Q:N["RESOURCE"  Q:$G(^("TYPE"))="RES"  ;PACKAGE-SPECIFIC RESOURCE DEVICES REMAIN
 .I $$CACHE^VFDVFOIA,N["DSM"!(N["MSM")!(N["GTM") G KILL ;KILL DEVICES FOR NON-CACHE SYSTEMS
 .S J=0,I="" F  S I=$O(VFDEV(I)) Q:I=""  I N[I S VFDEV(I,VFDEV)="",J=1  ;REMEMBER WE FOUND THIS NAME
 .Q:J
KILL .S VFDEVKIL(VFDEV)=1
 ;
 F VFDEV=0:0 S VFDEV=$O(VFDEVKIL(VFDEV)) Q:'VFDEV  S DA=VFDEV,DIK="^%ZIS(1," D ^DIK ;KILL 'EM OFF
 ;
ADD ;NOW WE HAVE A LIST OF DEVICES TO ADD OR EDIT
 D TERM^VFDVFOI3
 S VFDEV="" F  S VFDEV=$O(VFDEV(VFDEV)) Q:VFDEV=""  D
 .I $D(VFDEV(VFDEV))=1 D  ;ADD IF NECESSARY
 ..N D0,DIC S X=VFDEV,DIC(0)="",DIC="^%ZIS(1," D ^DICN I Y>0 S VFDEV(VFDEV,+Y)=""
 .F DA=0:0 S DA=$O(VFDEV(VFDEV,DA)) Q:'DA  D
 ..K DR S DIE=3.5,DR=""
TELNET ..I VFDEV="TELNET" S DR="1////|TNT|;.02///TELNET;1.95////1;2///VTRM;4///1;5///1;1.9///@;3///"_$G(VFDV("C-VT320")) ;CHANGE THE $I,ETC FROM WHAT VA HAD
SSH ..I VFDEV="SSH" S DR="1////CON;.02///SSH;1.95////1;2///VTRM;4///1;5///1;1.9///@;3///"_$G(VFDV("C-VT320"))
NULL ..I VFDEV="NULL" S DR="1////^S X=""//.nul"";.02///NT SYSTEM;1.95////1;2///TRM;4///1;5///1;3///"_$G(VFDV("C-VT320"))
HFS ..I VFDEV="HFS" S DR="19////""WNS"";.02///Host File Server;1.95///0;2///HFS;4///1;5.1///1;3///"_$G(VFDV("P-OTHER"))_";1////"_$$HFSI($P(^%ZIS(1,DA,0),U,2))
BROWSER ..I VFDEV["BROWSER" S X=$$HFSI($P(^%ZIS(1,DA,0),U,2)) S:X]"" DR="1////"_X
 ..I DR]"" D ^DIE
 Q
 ;
 ;
HFSI(X) ;MAKE A $I FOR AN HFS OR BROWSER DEVICE -- TURNS 'USER$:[TEMP]XDRBR.TXT' INTO 'C:\R\XDRBR.TXT'
 N Y,N
 S Y=$G(VFDV("DEFDIR")) I Y="" S Y=$P($G(^XTV(8989.3,1,"DEV")),U) ;$I FOR HFS SHOULD START WITH 'PRIMARY HFS DIRECTORY' (formerly 'DEFAULT DIRECTORY FOR HFS')
 I Y="" Q Y
 S:X="" X="tmp.dat"
 S N=0 F I=$L(X):-1:1 S J=$E(X,I) D
 .I J="." S N=1 Q
 .I J?1P S X=$E(X,I+1,999),I=0
 Q Y_X
 ;
 ;
 ;
 ;
D21AUDIT ;Audit many important files
 D LOTS("3.1,3.2,3.5,3.8,4-4.2,4.3-9.4,10-13,14.5-14.7,19-19.8,21-25,30-37,39.1-39.3,40.5-40.9,42-44,45.7,47-51.7,53.66,56,59-61.6,62.5,64.5,65.8,101")
 Q
 ;
LOTS(VFDVLIST) N VFDV,VFDVP,VFDVL F VFDV=1:1:$L(VFDVLIST,",") S VFDVP=$P(VFDVLIST,",",VFDV) I VFDVP D
 .D T(+VFDVP) I +VFDVP=VFDVP Q
 .S VFDVL=$P(VFDVP,"-",2) F  S VFDVP=$O(^DIC(+VFDVP)) Q:VFDVP>VFDVL!'VFDVP  D T(VFDVP)
 Q
T(I) Q:'$D(^DIC(I,0))  ;turn on auditing for FILE 'I'
 D TURNON^DIAUTL(I,"*") I $D(^DD(I,.001)) D TURNON^DIAUTL(I,.001,"n")
 Q
 ;
 ;
 ;
 ;
 ;
D23 ;STATION NUMBER -- check that station number is in needed files
 ;from STA^VFDVFOIZ
 N STA,INST,A,I,J,X,Y,Z,DIERR,VFDA,VFDER,VIEN S STA=$G(VFDV("INSTNUMB")),INST=$G(VFDV("INST",0)) I 'STA!'INST Q
 ; check if station number and institution in file 40.8
DIVISION S Y=$O(^DG(40.8,"C",STA,0)),Z=$O(^DG(40.8,"AD",+INST,0))
 I Y,Y=Z Q
 I 'Y,'Z S VIEN="+1," D
 .S A(.01)="OUTPATIENT CLINIC"
 .S A(.07)=+INST
 .S A(1)=STA
 .S A(3)=1
 .Q
 I 'Y S:Z VIEN=Z_"," S A(1)=STA
 I 'Z S:Y VIEN=Y_"," S A(.07)=+INST
 I Y,Z Q  ;NUMBER DOESN'T MATCH INSTITUTION
 M VFDA(40.8,VIEN)=A
 I $E(VIEN)="+" D UPDATE^DIE(,"VFDA",,"VFDER")
 I $E(VIEN)'="+" D FILE^DIE(,"VFDA","VFDER")
 ;
 D 49,IBE
 ;
STATION S X=$P(^VA(389.9,0),U,1,2) K ^(0) S ^(0)=X
 N DLAYGO,VACNT,VADIV,VAPRIM,VASITE
 S DLAYGO=389.9 D ^VASITE1
 I $$MPI
 Q
MPI() S X=$G(^MPIF(984.1,1,0)) I $P(X,U)=STA Q 0
 S X=$P(^MPIF(984.1,0),U,1,2) K ^(0) S ^(0)=X
 G SETUP^MPIFAPI
 ;
 ;
 ;
IBE S DA=1,DIE=350.9,DR=".01///1;1.14////14;1.25////1;.02////"_$G(VFDV("INST",0)) D ^DIE
 S VFDV="PSO" F  S VFDV=$O(^IBE(350.1,"B",VFDV)) Q:VFDV'?1"PSO".E  S DA=$O(^(VFDV,0)),DIE=350.1,DR=".04////22" D ^DIE
 Q
 ;
49 F VFDVDA=37:-1:1 S VFDVT=$T(@VFDVDA) D  ;BUILD SERVICE/SECTIONS
 .S VFDVDR="",X=$P(VFDVT,U,2) I X]"" S VFDVDR=VFDVDR_"1////"_X,X=$P(VFDVT,U,3) I X]"" S VFDVDR=VFDVDR_";1.6///"_X
 .S X=$P($P(VFDVT,U),";;",2),DA=VFDVDA I $D(^DIC(49,DA,0)) S DIE=49,DR=".01////"_X_";"_VFDVDR D ^DIE Q
 .S (DIC,DLAYGO)=49,DIC("DR")=VFDVDR,DIC(0)="L",DINUM=DA D ^DIC K DINUM,DIC
 Q
1 ;;INFORMATION TECHNOLOGY^IT
2 ;;ACCOUNTS RECEIVABLE^AR
3 ;;AMBULATORY CARE
4 ;;ANESTHESIOLOGY
5 ;;AUDIOLOGY AND SPEECH PATHOLOGY
6 ;;CHAPLAIN
7 ;;DENTAL
8 ;;DIETETICS
9 ;;ENGINEERING
10 ;;FISCAL
11 ;;LABORATORY
12 ;;LIBRARY
14 ;;MEDICAL ADMINISTRATION^MAS
15 ;;MEDICINE
16 ;;NEUROLOGY
17 ;;NUCLEAR MEDICINE
18 ;;NURSING
19 ;;NURSING HOME
20 ;;PERSONAL PROPERTY MANAGEMENT^PPM^SUPPLY
21 ;;PERSONNEL
22 ;;PHARMACY
23 ;;PROSTHETICS AND SENSORY AIDS
24 ;;PSYCHIATRY
25 ;;PSYCHOLOGY
26 ;;PURCHASING & CONTRACTING^P&C^SUPPLY
27 ;;RADIOLOGY
28 ;;RECREATION
30 ;;REHABILITATION MEDICINE
31 ;;RESEARCH
32 ;;SECURITY
33 ;;SOCIAL WORK
34 ;;SPINAL CORD INJURY^SCI
35 ;;SUPPLY
36 ;;SURGERY
37 ;;VOLUNTARY
 ;
 ;
 ;
 ;
SCHEDOPT ;
 ;;HLO SYSTEM STARTUP^S^^
 ;;ORMTIME RUN^^Dec 11, 2007@19:00^
 ;;ORMTIME RUN CHECK^^Dec 11, 2007@19:30^
 ;;VFDSD APPOINTMENT PURGE^S^Oct 17, 2008@20:00^
 ;;XMAUTOPURGE^^Dec 11, 2007@19:30^
 ;;XMMGR-IN-BASKET-PURGE^^Dec 11, 2007@20:00^
 ;;XMMGR-PURGE-AI-XREF^^Dec 11, 2007@19:30^
 ;;XMMGR-START-BACKGROUND-FILER^S^^
 ;;XOBV LISTENER STARTUP^S^^
 ;;XQ XUTL $J NODES^^Dec 11, 2007@19:00^
 ;;XQALERT DELETE OLD^^Dec 11, 2007@19:00^30
 ;;XQBUILDTREEQUE^^Dec 11, 2007@19:00^
 ;;XTRMONITOR^^Dec 11, 2007@19:00^
 ;;XUERTRP AUTO CLEAN^^Dec 11, 2007@19:30^
 ;;XUSER-CLEAR-ALL^S^^
 ;;XUSERAOLD^^Dec 11, 2007@19:00^
 ;;XUTM QCLEAN^^Dec 11, 2007@19:30^
 ;;XWB LISTENER STARTER^S^^
 ;
 F VFDV=1:1 S X=$P($P($T(SCHEDOPT+VFDV),";;",2),U) Q:X=""  S X=$O(^DIC(19,"B",X,0)) I X D
 .