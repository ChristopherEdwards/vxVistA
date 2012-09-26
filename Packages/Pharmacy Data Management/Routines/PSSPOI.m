PSSPOI ;BIR/RLW-CREATE PHARMACY ORDERABLE ITEMS ; 09/01/98 7:10
 ;;1.0;PHARMACY DATA MANAGEMENT;**15**;9/30/97
EN ;
 ; variable prefixes:  ADD=iv additive file     SOL=iv solution file
 ;                     PD=primary drug file     DD=dispense drug file
 ;                     NDF=national drug file   DF=NDF dosage form
 ;                     SPD=pharmacy orderable item file  SYN=synonym
 ;
LIVE ; populate PHARMACY ORDERABLE ITEM file, tie dispense drug to it
 ; loop thru ^TMP global to build 50.7
 N J,ADDIEN,ADDNAME,DDIEN,DDNAME,PDIEN,PDNAME,PDNAMEDF,NDF,NDFVA,DF,DFNAME,SPDNAME,X,PSMATCH,SOLIEN,SOLNAME,SPD,SPDFN,SYNIEN,SYNONYM
 S PDNAMEDF="" F  S PDNAMEDF=$O(^TMP("PSSD",$J,PDNAMEDF)) Q:PDNAMEDF=""  S DFNAME=$P(PDNAMEDF,"~",2),PDNAME=$P(PDNAMEDF,"~") Q:DFNAME=""  S (DF,DDNAME,SPDNAME)="",DF=$O(^PS(50.606,"B",DFNAME,DF)) D 
 .F I=$L(PDNAME):-1:1 Q:$E(PDNAME,I)'=" "
 .S SPDNAME=$E(PDNAME,1,I)
 .S Y=-1,SPDIEN="" I '$D(^PS(50.7,"ADF",SPDNAME,DF)) S DIC="^PS(50.7,",DIC(0)="L",DIC("DR")=".02////"_DF,X=SPDNAME K DD,DO D FILE^DICN K DIC S:+Y>0 SPDIEN=+Y
 .S:'SPDIEN SPDIEN=$O(^PS(50.7,"ADF",SPDNAME,DF,SPDIEN))
 .S SYNIEN=0,PDIEN="",PDIEN=$O(^PS(50.3,"B",PDNAME,PDIEN)) Q:PDIEN=""  D
 ..S Y=0,Y=$O(^PS(50.3,PDIEN,1,"B","U",Y)) S:Y Y=$G(^PS(50.3,PDIEN,1,Y,0)),$P(^PS(50.7,SPDIEN,0),"^",5,8)=$P(Y,"^",5,8)
 ..S SYNIEN=$O(^PS(50.3,PDIEN,2,SYNIEN)) Q:'SYNIEN  I '$D(^PS(50.7,SPDIEN,2,0)) S ^(0)="^50.72^1^1",SYNONYM=$G(^PS(50.3,PDIEN,2,SYNIEN,0)),^PS(50.7,SPDIEN,2,1,0)=SYNONYM,J=1,^PS(50.7,SPDIEN,2,"B",SYNONYM,J)=""
 ..I SYNIEN F  S SYNIEN=$O(^PS(50.3,PDIEN,2,SYNIEN)) Q:'SYNIEN  S J=J+1,SYNONYM=$G(^PS(50.3,PDIEN,2,SYNIEN,0)),^PS(50.7,SPDIEN,2,J,0)=SYNONYM,^PS(50.7,SPDIEN,2,"B",SYNONYM,J)="" F I=3,4 S $P(^PS(50.7,SPDIEN,2,0),"^",3,4)=J_"^"_J
 .I SPDIEN F  S DDNAME=$O(^TMP("PSSD",$J,PDNAMEDF,DDNAME)) Q:DDNAME=""  S DDIEN="",DDIEN=$O(^PSDRUG("B",DDNAME,DDIEN)) Q:'DDIEN  S DIE="^PSDRUG(",DA=DDIEN,DR="2.1////"_SPDIEN D ^DIE K DIE
 .Q
 ;
IVADD ; populate IV Additives, Solutions
 S X1=DT,X2=-365 D C^%DTC S PIND=X K X1,X2
 ;***********DON'T EVEN USE TMP GLOBAL ************
 F ADDIEN=0:0 S ADDIEN=$O(^PS(52.6,ADDIEN)) Q:'ADDIEN  S DDIEN=+$P($G(^PS(52.6,ADDIEN,0)),"^",2) I DDIEN,$D(^PSDRUG(DDIEN,0)) D
 .S NDND=$G(^PSDRUG(DDIEN,"ND")) Q:'$P(NDND,"^")!('$P(NDND,"^",3))
 .S DA=$P(NDND,"^",1),K=$P(NDND,"^",3),X=$$PSJDF^PSNAPIS(DA,K) Q:'X
 .S DFPTR=+$P(X,"^") Q:'DFPTR!('$D(^PS(50.606,+DFPTR,0)))
 .S ADDNAME=$P($G(^PS(52.6,ADDIEN,0)),"^") Q:ADDNAME=""
 .S PDT=+$P($G(^PS(52.6,ADDIEN,"I")),"^") I PDT,PDT<PIND Q
 .S AAAFLAG=0 F AAA=0:0 S AAA=$O(^PS(50.7,"ADF",ADDNAME,DFPTR,AAA)) Q:'AAA!(AAAFLAG)  S:$P($G(^PS(50.7,AAA,0)),"^",3) AAAFLAG=1
 .Q:AAAFLAG
 .S DIC="^PS(50.7,",X=ADDNAME,DIC(0)="L",DIC("DR")=".02////"_DFPTR_";.03////1" K DD,DO D FILE^DICN K DIC S SPDIEN=+Y
 .Q:'SPDIEN
 .K DIE S DIE="^PS(52.6,",DA=ADDIEN,DR="15////"_SPDIEN D ^DIE K DIE
 .;NOW, LOOP THRU 3 NODE FOR SYNONYM
 .S AAACT=0 F AAA=0:0 S AAA=$O(^PS(52.6,ADDIEN,3,AAA)) Q:'AAA  S SYNONYM=$P($G(^(AAA,0)),"^") I SYNONYM'="" S AAACT=AAACT+1 D
 ..S ^PS(50.7,SPDIEN,2,AAACT,0)=SYNONYM,^PS(50.7,SPDIEN,2,"B",SYNONYM,AAACT)=""
 .I AAACT S ^PS(50.7,SPDIEN,2,0)="^50.72^"_AAACT_"^"_AAACT
 K PIND,PDT
 ;
IVSOL ;
 ;****************DON'T EVEN USE TMP GLOBAL **********
 ;DO SAME AS ADDITIVES, BUT IF DATAISIN ADF WITH A ONE, MATCH AND DO SYN, IF NOT CREATE,MATCH AND DO SYN
 F SOLIEN=0:0 S SOLIEN=$O(^PS(52.7,SOLIEN)) Q:'SOLIEN  S DDIEN=+$P($G(^PS(52.7,SOLIEN,0)),"^",2)  I DDIEN,$D(^PSDRUG(DDIEN,0)) D
 .S NDND=$G(^PSDRUG(DDIEN,"ND")) Q:'$P(NDND,"^")!('$P(NDND,"^",3))
 .S DA=$P(NDND,"^",1),K=$P(NDND,"^",3),X=$$PSJDF^PSNAPIS(DA,K) Q:'X
 .S DFPTR=+$P(X,"^") Q:'DFPTR!('$D(^PS(50.606,+DFPTR,0)))
 .S SOLNAME=$P($G(^PS(52.7,SOLIEN,0)),"^") Q:SOLNAME=""
 .S (AAAFLAG,AAAMATCH)=0 F AAA=0:0 S AAA=$O(^PS(50.7,"ADF",SOLNAME,DFPTR,AAA)) Q:'AAA!(AAAFLAG)  I $P($G(^PS(50.7,AAA,0)),"^",3) S AAAFLAG=1,AAAMATCH=AAA
 .I AAAFLAG D
 ..K DIE S DIE="^PS(52.7,",DA=SOLIEN,DR="9////"_AAAMATCH D ^DIE K DIE
 ..F AAA=0:0 S AAA=$O(^PS(52.7,SOLIEN,3,AAA)) Q:'AAA  S SYNONYM=$P($G(^(AAA,0)),"^") I SYNONYM'="",'$O(^PS(50.7,AAAMATCH,2,"B",SYNONYM,0)) D
 ...S AAACT=0 F SYCT=0:0 S SYCT=$O(^PS(50.7,AAAMATCH,2,SYCT)) Q:'SYCT  S AAACT=SYCT
 ...S AAACT=AAACT+1,^PS(50.7,AAAMATCH,2,AAACT,0)=SYNONYM,^PS(50.7,AAAMATCH,2,"B",SYNONYM,AAACT)=""
 .I AAAFLAG S ATOTAL=0 F AAACT=0:0 S AAACT=$O(^PS(50.7,AAAMATCH,2,AAACT)) Q:'AAACT  S ATOTAL=ATOTAL+1
 .I AAAFLAG,ATOTAL S ^PS(50.7,AAAMATCH,2,0)="^50.72^"_ATOTAL_"^"_ATOTAL
 .I 'AAAFLAG D
 ..K DIC S DIC="^PS(50.7,",X=SOLNAME,DIC(0)="L",DIC("DR")=".02////"_DFPTR_";.03////1" K DD,DO D FILE^DICN K DIC S SPDIEN=+Y
 ..Q:'SPDIEN
 ..K DIE S DIE="^PS(52.7,",DA=SOLIEN,DR="9////"_SPDIEN D ^DIE K DIE
 ..S AAACT=0 F AAA=0:0 S AAA=$O(^PS(52.7,SOLIEN,3,AAA)) Q:'AAA  S SYNONYM=$P($G(^(AAA,0)),"^") I SYNONYM'="" S AAACT=AAACT+1 D
 ...S ^PS(50.7,SPDIEN,2,AAACT,0)=SYNONYM,^PS(50.7,SPDIEN,2,"B",SYNONYM,AAACT)=""
 ..I AAACT S ^PS(50.7,SPDIEN,2,0)="^50.72^"_AAACT_"^"_AAACT
 ;FOR SYN, CHECK FOR NOT ALREADY EXISTING!!
 ;
XREF ; do next line to xref whole file after looping thru ^TMP to populate
 ;******************DON'T EVEN DO THIS *******************
 ;I $D(PSLOAD) S DIK="^PS(50.7," D IXALL^DIK K DIK
 Q
 ;
DUPL ; see if there's already an orderable item with the same name and dosage form
 N OLDDF S SPDIEN="" F  S SPDIEN=$O(^PS(50.7,"B",SOLNAME,SPDIEN)) Q:SPDIEN=""  S OLDDF=$P(^PS(50.7,SPDIEN,0),"^",2) I OLDDF=DF S ^PS(50.7,"AIV",1,SOLIEN)="" Q
 Q
