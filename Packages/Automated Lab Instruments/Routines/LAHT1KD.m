LAHT1KD ;SLC/DLG - HITATCHI 736 WITH JT1000 BUILD DOWNLOAD FILE. ;8/16/90  10:31 ;
 ;;5.2;AUTOMATED LAB INSTRUMENTS;;Sep 27, 1994
 ;Call with LRLL = load list to build
 ;Call with LRTRAY1 = Starting tray number
 ;Call with LRLL = Auto Instrument pointer
 ;Call with LRFORCE=1 if send tray and cup.
 S:$D(ZTQUEUED) ZTREQ="@" I '$D(^LA(LRINST,"O")) S T=LRINST D SETO^LAB
A F LRTRAY=LRTRAY1:0 D:$D(^LRO(68.2,LRLL,1,LRTRAY)) TRAY S LRTRAY=$O(^LRO(68.2,LRLL,1,LRTRAY)),LRCUP1=1 Q:LRTRAY'>0
 S LREND=0 L ^LA(LRINST,"O"),^LA("Q") S:^LA(LRINST,"O")=^("I",0) ^(0)=^(0)+1 S Q=^LA("Q")+1,^("Q")=Q,^("Q",Q)=LRINST L
 I '$D(^LA("LOCK",LRINST)),$D(^LAB(62.4,LRINST,1)) S T=LRINST X ^(1)
 Q
TRAY F LRCUP=(LRCUP1-1):0 S LRCUP=$O(^LRO(68.2,LRLL,1,LRTRAY,1,LRCUP)) Q:LRCUP'>0  D SAMPLE S LRECORD=""
 Q
SAMPLE S LRL=^LRO(68.2,LRLL,1,LRTRAY,1,LRCUP,0),LRAA=+LRL,LRAD=$P(LRL,"^",2),LRAN=$P(LRL,"^",3) D TEST
 S LRECORD=$E(1000000000+LRAN,2,10)_X D CKSUM S LRECORD="["_LRECORD_CKSUM_"]" D SEND Q
TEST D ZERO F LRTEST=0:0 S LRTEST=$O(^LRO(68.2,LRLL,1,LRTRAY,1,LRCUP,1,LRTEST)) Q:LRTEST'>0  D T2
 Q
T2 Q:'$D(^TMP($J,LRTEST))  F I=0:0 S I=$O(^TMP($J,LRTEST,I)) Q:I'>0  S Y=^(I) S X=$E(X,1,(Y-1))_"1"_$E(X,(Y+1),35)
 Q
ZERO S X="" F I=1:1:35 S X=X_"0"
 Q
SEND I '$D(^LA(LRINST,"O")) S T=LRINST D SETO^LAB
 S (C,^LA(LRINST,"O"))=^LA(LRINST,"O")+1,^("O",C)=LRECORD Q
CKSUM S CKSUM=0 F I=1:1:$L(LRECORD) S CKSUM=CKSUM+$A(LRECORD,I)#256
 S CKSUM=$E("0123456789ABCDEF",(CKSUM\16+1))_$E("0123456789ABCDEF",(CKSUM#16+1)) Q
CHECK ;ENTRY FOR HANDSHAKE RESPONSE FIELD OF AUTOINSTRUMENT FILE
 G OUT:IN="$",AGN:IN="?",OUT:IN="%"
 S:'$D(ERR) ERR=0 S LRECORD=$E(IN,2,($L(IN)-3)),CK=$E(IN,($L(IN)-2),($L(IN)-1))
 D CKSUM S OUT=$S(CK=CKSUM:"$",1:"?"),ERR=$S(OUT="?":ERR+1,1:0) S:ERR=6 OUT="$",ERR=0,^LA(T,"I")=^LA(T,"I")-1 S T=T-BASE Q
OUT S CNT=^LA(T,"O",0)+1 I $D(^(CNT))#2 S ^(0)=CNT,OUT=^(CNT),T=T-BASE
 Q
AGN S CNT=^LA(T,"O",0),OUT=^(CNT),T=T-BASE Q
