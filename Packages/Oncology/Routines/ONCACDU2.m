ONCACDU2 ;Hines OIFO/GWB - UTILITY ROUTINE #1 ;09/20/2000
 ;;2.11;Oncology;**12,18,20,21,22,24,26,27,29,30,31,32,34,36,37,38,39,41,46,47**;Mar 07, 1995;Build 19
 ;
HOSP1(PROC,IEN) ;Check to see if the site is breast or prostate
 ;Inputs: PROC = Process Number to be processed
 ;         IEN = Record within File 160.16
 ;Output; X data for field.
 ;
 N PTR,X,SITE
 S X=0
 S SITE=$$GET1^DIQ(165.5,IEN,.01,"I")
 S SITE=$$GET1^DIQ(164.2,SITE,.01,"I")
 I SITE="BREAST" D
 .I PROC=1 S PTR=$$GET1^DIQ(165.5,IEN,141,"I") S:PTR'="" X=$P($G(^ONCO(164,67500,"BP5",PTR,0)),U,2) Q
 .I PROC=2 S PTR=$$GET1^DIQ(165.5,IEN,142,"I") S:PTR'="" X=$P($G(^ONCO(164,67500,"GU5",PTR,0)),U,2) Q
 .I PROC=3 S X=$$GET1^DIQ(165.5,IEN,143,"I") Q
 .I PROC=4 S X=$$GET1^DIQ(165.5,IEN,144,"I")
 ;
 I SITE="PROSTATE" D
 .I PROC=1 S PTR=$$GET1^DIQ(165.5,IEN,141,"I") S:PTR'="" X=$P($G(^ONCO(164,67619,"BP5",PTR,0)),U,2) Q
 .I PROC=2 S PTR=$$GET1^DIQ(165.5,IEN,142,"I") S:PTR'="" X=$P($G(^ONCO(164,67619,"GU5",PTR,0)),U,2) Q
 .I PROC=3 S X=$$GET1^DIQ(165.5,IEN,145,"I") Q
 .I PROC=4 S X=$$GET1^DIQ(165.5,IEN,146,"I")
 Q X
 ;
VAFLD(ACDANS) ;Convert data to valid external format
 ;Input: ACDANS
 ;       Y=1
 ;       N=0
 ;       U=9
 I ACDANS="N" S ACDANS=0
 I ACDANS="Y" S ACDANS=1
 I ACDANS="U" S ACDANS=9
 Q ACDANS
 ;
VASIT() ;VISN 1452-1453
 ;Output: X = VISN
 N X
 S OSPIEN=$O(^ONCO(160.1,0))
 S X=$P($G(^ONCO(160.1,OSPIEN,1)),U,7)
 K OSPIEN
 Q X
 ;
COCO(IEN) ;COC Coding Sys--Original [2150] 1202-1203
 N X
 S DATEDX=$$GET1^DIQ(165.5,IEN,3,"I")
 S X=$S(DATEDX>3021231:"08",DATEDX>2951231:"07",1:"05")
 Q X
 ;
VENDOR() ;Vendor Name [2170] 1204-1213
 N X,VERSION,EXTR,SUFFIX
 S EXTR=$G(^ONCO(160.16,EXTRACT,0))
 S SUFFIX=$S(EXTR["VACCR":"A",EXTR["STATE":"B",1:"")
 S VERSION=$P($G(^ONCO(160.16,EXTRACT,0))," ",3)
 S X="VA"_VERSION_$E($T(LOGO+3^ONCODIS),62,64)_SUFFIX
 Q X
 ;
BDATE(ACD160) ;Birth Date [240] 122-129
 N D0,X
 S D0=ACD160
 D DOB^ONCOES
 S X=$G(X)
 Q X
 ;
WORD(IEN,NODE,LEN) ;Get word processing data
 N X
 S X=""
 I $D(^ONCO(165.5,IEN,NODE,0)) D
 .N CNT,LINE
 .S CNT=0
 .S LINE=""
 .F  S CNT=$O(^ONCO(165.5,IEN,NODE,CNT)) Q:CNT<1  D  Q:($L(LINE)>LEN)
 ..Q:'$D(^ONCO(165.5,IEN,NODE,CNT,0))
 ..S LINE=LINE_^ONCO(165.5,IEN,NODE,CNT,0)_" "
 .S X=LINE
 Q X
 ;
STAGE(IEN,TYPE) ;TNM Descriptors
 ;TNM Path Descriptor [910] 571-571
 ;TNM Clin Descriptor [980] 581-581
 N LOC,X
 S X=""
 S LOC=$S(TYPE="P":89.1,TYPE="C":37,1:"")
 I TYPE'="" D
 .N STRING
 .S STRING=$$GET1^DIQ(165.5,IEN,LOC,"E")
 .I ($P(STRING," ")["m")&($P(STRING," ")["y") S X=6 Q
 .I $P(STRING," ")["m" S X=3 Q
 .I $P(STRING," ")["y" S X=4 Q
 Q X
 ;
CCOUNTY(ACD160) ;County--Current
 N ZIP,X
 S X=""
 S ZIP=$$GET1^DIQ(160,ACD160,.116,"E")
 I ZIP'="" D
 .N ZIP1,CODE,COUNTY
 .S ZIP1=$P($P(ZIP,",",2)," ",3) S:$L(ZIP1)>5 ZIP1=$E(ZIP1,1,5)
 .Q:$L(ZIP1)<5
 .S CODE=$O(^VIC(5.11,"C",ZIP1,""))
 .Q:CODE<1
 .S COUNTY=$$GET1^DIQ(5.11,CODE,2,"I")
 .Q:COUNTY=""
 .S X=$$GET1^DIQ(5.1,COUNTY,2,"I")
 Q X
 ;
SUB(IEN,CNT,FIELD) ;
 ;Subsq RX 2nd Course Date [1660] 988-995
 N X
 S CNT=CNT-1
 S X=""
 I $O(^ONCO(165.5,IEN,4,0)) D
 .N IENS,SUB,SUBFLD,ENTRY,SUBIEN
 .S SUBIEN=0 F I=1:1 S SUBIEN=$O(^ONCO(165.5,IEN,4,SUBIEN)) Q:(I=CNT)!(SUBIEN'>0)
 .I SUBIEN="" S X="" Q
 .S IENS=SUBIEN_","_IEN
 .S ENTRY=$$GET1^DIQ(165.51,IENS,FIELD,"I") I ENTRY="",FIELD'=".07",FIELD'=".08" S X="" Q
 .S HEMA=""
 .S HEMAPT=$$GET1^DIQ(165.51,IENS,.02,"I")
 .S:HEMAPT'="" HEMA=$P($G(^ONCO(167,HEMAPT,0)),U,1)
 .I $S(FIELD=".01":1,FIELD=".05":1,FIELD=".06":1,FIELD=".07":1,FIELD=".08":1,FIELD=".09":1,FIELD="37":1,1:0) D  Q
 ..I FIELD=".06" S X=$S(ENTRY="01":1,ENTRY="02":2,ENTRY="03":3,$E(ENTRY,1)=8:0,1:ENTRY) Q
 ..I FIELD=".07" S X=$S(ENTRY="00":0,ENTRY="01":1,$E(ENTRY,1)=8:0,ENTRY=99:9,1:"") Q:X'=""  S X=$S(HEMA=30:2,HEMA=40:2,1:"") Q
 ..I FIELD=".08" S X=$S(ENTRY="01":1,ENTRY=87:7,ENTRY=88:8,$E(ENTRY,1)=8:0,ENTRY=99:9,1:ENTRY) Q:X'=""  S X=$S(HEMA=10:4,HEMA=11:2,HEMA=12:3,HEMA=20:5,1:"") Q
 ..S X=ENTRY
 .I $$GET1^DIQ(165.5,IEN,3,"I")<2980000 S X=ENTRY Q
 .S SUBFLD=$S(FIELD=33:"RR5",FIELD=35:"SC5",FIELD=36:"SO5",FIELD=.04:"SPS",1:"") I SUBFLD="" S X="" Q
 .S X=$$SUB164^ONCACDU2(IEN,SUBFLD,ENTRY)
 I FIELD=.04,$L(X)=1 S X="0"_X
 Q X
 ;
SUB164(IEN,SUBFLD,ENTRY) ;ICDO TOPOGRAPHY (164)
 N X,TOP1,TOP2
 S X=""
 S TOP1=$$GET1^DIQ(165.5,IEN,20,"I") D:TOP1'=""
 .S TOP2=$$GET1^DIQ(164,TOP1,107,"I")
 .I (TOP1=67420)!(TOP1=67421)!(TOP1=67423)!(TOP1=67424)!($E(TOP1,3,4)=76)!(TOP1=67809),($G(FIELD)=58.6)!($G(FIELD)=58.7) S TOP2=67420
 .I ($G(FIELD)=58.2)!($G(FIELD)=50.2)!($G(FIELD)=138)!($G(FIELD)=138.1)!($G(FIELD)=139)!($G(FIELD)=139.1)!($G(FIELD)=74)!($G(FIELD)=23),($E(TOP1,3,4)=76)!(TOP1=67809)!(TOP1=67420)!(TOP1=67421)!(TOP1=67423)!(TOP1=67424) S TOP2=67141
 .I ($G(FIELD)=58.2)!($G(FIELD)=50.2),TOP1=67422 S TOP2=67770
 .I $G(SUBFLD)="SUA",($E(TOP1,3,4)=77) S TOP2=67141
 .D:TOP2'=""
 ..S X=$P($G(^ONCO(164,TOP2,SUBFLD,ENTRY,0)),U,2)
 Q X
 ;
RXPRI(IEN,FIELD,SUBFLD) ;
 ;RX Hosp--Surg Prim Site    [670] 457-458
 ;RX Hosp--Surg Site 98-02   [746] 478-479
 ;RX Hosp--Scope Reg 98-02   [747] 480-480
 ;RX Hosp--Surg Oth 98-02    [748] 481-481
 ;RX Summ--Surg Prim Site   [1290] 859-860
 ;RX Summ--Surgical Approch [1310] 865-865
 ;RX Summ--Reconstruct 1st  [1330] 867-867
 ;RX Summ--Surg Site 98-02  [1646] 939-940
 ;RX Summ--Scope Reg 98-02  [1647] 941-941
 ;RX Summ--Surg Oth 98-02   [1648] 942-942
 N X,ENTRY
 S X=""
 S TOP1=$$GET1^DIQ(165.5,IEN,20,"I")
 S ENTRY=$$GET1^DIQ(165.5,IEN,FIELD,"I") D:ENTRY'=""
 .I (TOP1=67420)!(TOP1=67421)!(TOP1=67423)!(TOP1=67424)!($E(TOP1,3,4)=76)!(TOP1=67809),($G(FIELD)=58.6)!($G(FIELD)=58.7) S X=$$SUB164^ONCACDU2(IEN,SUBFLD,ENTRY) Q
 .I $$GET1^DIQ(165.5,IEN,3,"I")<2980000,(FIELD=23)!(FIELD=74)!(FIELD=50.2)!(FIELD=58.2)!(FIELD=58.6)!(FIELD=58.7) S X=$S(FIELD=23:$$GET1^DIQ(160.4,ENTRY,.01,"I"),FIELD=74:$$GET1^DIQ(160.6,ENTRY,.01,"I"),1:ENTRY) Q
 .S X=$$SUB164^ONCACDU2(IEN,SUBFLD,ENTRY)
 Q X
 ;
LAST(ACD160) ;Get last DATE OF LAST CONTACT OR DEATH (160.04,.01)
 S X="",DLC=0
 S DLC=$O(^ONCO(160,ACD160,"F","AA",DLC))
 S:DLC'="" X=$O(^ONCO(160,ACD160,"F","AA",DLC,0))
 I X'>0 S X=""
 Q X
 ;
FNODE(ACD160,FIELD) ;
 ;Date of Last Contact     [1750] 1294-1301
 ;Vital Status             [1760] 1302-1302
 ;Quality of Survival      [1780] 1304-1304
 ;Follow-Up Source         [1790] 1305-1305
 ;Next Follow-Up Source    [1800] 1306-1306
 ;Unusual Follow-Up Method [1850] 1341-1341
 ;Following Registry       [2440] 2475-2484
 N FNODE,X
 S FNODE=$$LAST(ACD160),X=""
 I FNODE'="" D
 .N IENS
 .S IENS=FNODE_","_ACD160_","
 .S X=$$GET1^DIQ(160.04,IENS,FIELD,"I")
 Q X
 ;
CS(IEN) ;Cancer Status [1770] 1303-1303
 N X,Z,FNODE
 S FNODE=0
 S X=""
 S FNODE=$O(^ONCO(165.5,IEN,"TS",FNODE))
 I FNODE>0 D
 .N IENS,PT
 .S FNODE=$O(^ONCO(165.5,IEN,"TS"," "),-1)
 .Q:FNODE<1
 .S IENS=FNODE_","_IEN_","
 .S PT=$$GET1^DIQ(165.573,IENS,.02,"I")
 .Q:PT<1
 .S X=$$GET1^DIQ(164.42,PT,1,"I")
 Q X
 ;
CCTST(ACD160) ;
 ;Addr Current--City      [1810] 1307-1326
 ;Follow-Up Contact--City [1842] 1357-1376
 N X,D0,ONCOX1,OIEN,INCOM,ONCON,ONCOX
 S X=""
 S D0=ACD160
 I $D(^ONCO(160,D0,0)) D SETUP1^ONCOES
 I $D(ONCOX1) S X=$S($D(@ONCOX1):$P(@ONCOX1,U,4),1:"")
 S X=$$STRIP^XLFSTR(X,"!""""#$%&'()*+,-./:;<=>?[>]^_\{|}~`")
 Q X
 ;
CSTST(ACD160) ;
 ;Addr Current--State      [1820] 1327-1328
 ;Follow-Up Contact--State [1844] 1377-1378
 N X,D0,ONCOX1,ONCON,ONCOX
 S X=""
 S D0=ACD160
 I $D(^ONCO(160,D0,0)) D SETUP1^ONCOES
 I $D(ONCOX1) S X=$S($D(@ONCOX1):$P(@ONCOX1,U,5),1:"")
 S:X'="" X=$$GET1^DIQ(5,X,1,"I")
 S X=$S(X="CANAD":"CD",X="EU":"YY",X="MX":"XX",X="NF":"NL",X="PH":"XX",X="UN":"ZZ",1:X)
 Q X
 ;
ICD(ICD) ;ICD Code
 N X
 S ICD=$S(ICD'="":$P($G(^ICD9(ICD,0)),U),1:"0000")
 I ICD["." S ICD=$P(ICD,".")_$P(ICD,".",2)
 S:$L(ICD)=3 ICD=ICD_9
 S:$L(ICD)<4 ICD=$E("0000",1,4-$L(ICD))_ICD
 S:$L(ICD)>4 ICD=$E(ICD,1,4)
 I $E(ICD,4)="X"!($E(ICD,4)="-") S ICD=$E(ICD,1,3)_9
 Q ICD
 ;
ICDR(ICD) ;ICD Revision Number [1920] 1392-1392
 N ICDR
 S ICD=$$ICD(ICD)
 S ICDR=$S(ICD="    ":0,1:$$GET1^DIQ(160,ACD160,20,"I"))
 S:ICDR="" ICDR=0
 Q ICDR
 ;
LINK(ACD160) ;Linkage Name
 N NAME,X
 S DFN=ACD160 D DEM^VADPT
 S NAME=VADM(1)
 D KVAR^VADPT
 S X=($A($E(NAME,1)))+($A($E(NAME,2)))
 S X=X-128 I X<1 S X=""
 Q X
 ;
PPAY(IEN) ;PRIMARY PAYER AT DX (165.5,18)
 N X
 S X=$$GET1^DIQ(165.5,IEN,18,"I")
 S X=$$GET1^DIQ(160.3,$S(X'="":X,1:99),.01,"I")
 S X=$S(X<42:X,X>47:X,1:X-1)
 Q X
 ;
DS(IEN) ;RX Date--Surgery [1200] 755-762
 N X
 S X=$$GET1^DIQ(165.5,IEN,50,"I") I X'="" S SURGDT(X)=""
 S X=$$GET1^DIQ(165.5,IEN,138.2,"I") I X'="" S SURGDT(X)=""
 S X=$$GET1^DIQ(165.5,IEN,139.2,"I") I X'="" S SURGDT(X)=""
 S SURGDT=$O(SURGDT(0))
 S X=$$DATE^ONCACDU1(SURGDT)
 K SURGDT
 Q X