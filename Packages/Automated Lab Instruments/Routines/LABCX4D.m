LABCX4D ;SLC/DLG - BECKMAN CX4 AND CX5 BUILD DOWNLOAD FILE. ;8/16/90  10:33 ;
 ;;5.2;AUTOMATED LAB INSTRUMENTS;;Sep 27, 1994
 ;Call with LRLL = load list to build
 ;Call with LRINST = Auto Instrument pointer
A S:$D(ZTQUEUED) ZTREQ="@"
 S:'$D(T) T=LRINST D:'$D(^LA(LRINST,"O")) SETO^LAB I $D(^LA(LRINST,"C")),^("C")=^("C",0) K ^LA(LRINST,"C")
 D:'$D(^LA(LRINST,"C")) SETC S LREND=""
 S F=$O(^LAB(61,"B","CSF",0)),X=^LAB(69.9,1,1),LRFLUID=$P(X,"^",3)_"^"_F_"^"_$P(X,"^",2)
 S LRURG="" F I="ROUTINE","STAT" S J=$O(^LAB(61.26,"B",I,0)) S:J $P(LRURG,"^",J)=$E(I,1,2)
 F I=0:0 S I=$O(^LAB(62.4,T,3,I)) Q:I'>0  S X=^(I,0),TEST(+X)=$P(X,U,6)
 Q:'$D(^LRO(68.2,LRLL,1,LRTRAY1))
 S LRECORD=$C(4,1) D SEN S LRECORD="[00,400,07,0]",FL=1 D SUM S LRECORD=$C(4) D SEN
 F LRTRAY=LRTRAY1:0 Q:LRTRAY'>0  S LRECORD=$C(4,1) D SEN S LRECORD="[00,401,03,1,"_$E(100+LRTRAY,2,3)_"]",FL=1 D SUM S LRECORD=$C(4) D SEN S LRTRAY=$O(^LRO(68.2,LRLL,1,LRTRAY))
 F LRTRAY=LRTRAY1:0 D:$D(^LRO(68.2,LRLL,1,LRTRAY)) TRAY S LRTRAY=$O(^LRO(68.2,LRLL,1,LRTRAY)) Q:LRTRAY'>0  S LRCUP1=1
 K C,CNT,DOB,FL,I,II,J,LRAA,LRAN,LRCUP,LRDC,LRDPF,LRECORD,LRPMD,LRPRE,LRSI,LRSP,SSN,LRSUM,LRWRD,PNM,Q,SEX,SSN,AGE,DOB Q
TRAY F LRCUP=LRCUP1-1:0 S LRCUP=$O(^LRO(68.2,LRLL,1,LRTRAY,1,LRCUP)) Q:LRCUP'>0  S LRECORD=$C(4,1) D SEN S LRECORD="[00,401,01,1,"_$E(100+LRTRAY,2,3)_","_$E(100+LRCUP,2,3)_"," D SAMPLE S LRECORD=$C(4) D SEN
 Q
SAMPLE S (AGE,SEX,SSN,DOB,LRWRD,LRDC)=""
 S LRL=^LRO(68.2,LRLL,1,LRTRAY,1,LRCUP,0),LRAA=+LRL,LRAD=$P(LRL,"^",2) S LRAN=$P(LRL,"^",3) D PNM Q:LRDPF=62.3
 S F=$P(LRL,"^",5),F=$S($P(LRFLUID,"^",1)=F:"SE",$P(LRFLUID,"^",2)=F:"SF",$P(LRFLUID,"^",3)=F:"UR",1:"SE")
 S LRECORD=LRECORD_"  ,"_F_","
 S LRECORD=LRECORD_$E(100000000000+LRAN,2,12)_","_$J(" ",25)_","_$J(" ",25)_","
 S LRECORD=LRECORD_$E(PNM,1,30)_",",SSN=$S(SSN:$E(1000000000000+SSN,2,13),1:$J(" ",12)),LRECORD=LRECORD_SSN_","
 S X=^LRO(68,LRAA,1,LRAD,1,LRAN,3),Y=$P(^(0),"^",8) D DD^LRX S LRDOC=Y
 I LRDOC]"" F II=0:0 S LRDOC=$P(LRDOC,",",1)_"/"_$P(LRDOC,",",2,99) Q:$F(LRDOC,",")<1
 S LRDOC=LRDOC_$J(" ",15) S LRECORD=LRECORD_$E(LRDOC,1,15)_","
 S Y=+X D DD^LRX S LRDC=$P(Y," ",1),LRTM=$P(Y," ",2),LRDC=$S(LRDC]"":$E(1,2)_$E(LRDC,4,5)_$E(LRDC,7,8),1:"      "),LRTM=$E(10000+LRTM,2,5) S:+LRTM=0 LRTM="    "
 S LRECORD=LRECORD_LRDC_","_LRTM_","_$E(LRWRD_"     ",1,5)_","_$S(AGE:$E(10000+AGE,2,5),1:"0000")_"," S DOB=$E(DOB,6,7)_$E(DOB,4,5)_$E(DOB,2,3),DOB=$S(DOB="":$J(" ",6),1:DOB),LRECORD=LRECORD_DOB_","_$E(SEX_" ",1)_","_$J(" ",60)_","
 D TEST S LRECORD=LRECORD_$E(100+J,2,3)_",",$P(LRECORD,",",7)=$S($D(PNM):URG,1:"CO"),FL=1 D SUM
 S FL=0,LRECORD="" F II=1:1:J S LRECORD=LRECORD_$E(TEST($P(X,"^",II))_"    ",1,4)_",0"_$S(II<J:",",1:"]") I $L(LRECORD)+7>255 D SUM S LRECORD=""
 D:$L(LRECORD) SUM Q
TEST ;
 S J=0,X="" F LRTEST=0:0 S LRTEST=$O(^LRO(68.2,LRLL,1,LRTRAY,1,LRCUP,1,LRTEST)) Q:LRTEST'>0  S URG=$P(^(LRTEST,0),"^",2),URG=$S(URG:$P(LRURG,"^",URG),1:""),URG=$S($L(URG):URG,1:"RO") D T2
 Q
T2 Q:'$D(^TMP($J,LRTEST))  F I=0:0 S I=$O(^TMP($J,LRTEST,I)) Q:I'>0  I $D(TEST(I)) S:X'[I J=J+1,X=X_$S(X="":I,1:"^"_I) ;DON'T REPEATE TESTS
 Q
PNM ;Get patient name and SSN from an accession.
 K PNM,SSN,SSN S X=^LRO(68,LRAA,1,LRAD,1,LRAN,0),X=^LR(+X,0),PNM="",LRDPF=$P(X,"^",2) I LRDPF]"" S DFN=$P(X,"^",3) D PT^LRX
 I $D(PNM) F II=0:0 S PNM=$P(PNM,",",1)_"/"_$P(PNM,",",2,99) Q:$F(PNM,",")<1
 S PNM=$S($D(PNM):PNM_$J(" ",30),1:$J(" ",30))
 S:$D(SSN) SSN=$E(SSN,1,3)_$E(SSN,5,6)_$E(SSN,8,11)
 S (LRS,LRADIA,LRPMD,LRADAT)="" Q
SUM I FL S LRSUM=0 F I=1:1:$L(LRECORD) S LRSUM=LRSUM+$A(LRECORD,I)
 I 'FL F I=1:1:$L(LRECORD) S LRSUM=LRSUM+$A(LRECORD,I)
 I LRECORD["]" S LRSUM=256-(LRSUM#256),LRSUM=$E("0123456789ABCDEF",(LRSUM\16+1))_$E("0123456789ABCDEF",(LRSUM#16+1)),LRECORD=LRECORD_$S(LRSUM=0:"00",1:LRSUM),LRSUM=0
SEN S CNT=^LA(LRINST,"C")+1,^("C")=CNT,^("C",CNT)=LRECORD Q
SETC Q:$D(^LA(T,"C"))  S ^LA(T,"C")=0,^("C",0)=0 Q
