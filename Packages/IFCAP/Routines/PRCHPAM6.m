PRCHPAM6 ;WISC/DJM-PRINT AMENDMENT,ROUTINE #5 ;6/29/00  12:21
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
E33 ;PROMPT PAYMENT Edit PRINT
 ;
 ;N CHANGE,CHANGES,FIELD,OLD,PAY,LCNT,DATA,PCT,PCT1,PCT2,DAYS,DAYS1,DAYS2,TERMS,NPCT,NDAYS1
 S FIELD=0 K PAY D LCNT^PRCHPAM5(.LCNT)
 F  S FIELD=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,FIELD)) Q:FIELD'>0  D
 .S CHANGE=0 F  S CHANGE=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,FIELD,CHANGE)) Q:CHANGE'>0  D
 ..S CHANGES=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,0),OLD=$G(^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0))
 ..S:FIELD=.01 PCT2=OLD S:FIELD=1 DAYS2=OLD
 ..S PAY=$P(CHANGES,U,4) Q:$D(PAY(PAY))  S PAY(PAY)=1
 ..I FIELD'=1 S DAYS=0 F  S DAYS=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",33,1,DAYS)) Q:DAYS'>0  S DAYS1=$P(^PRC(443.6,PRCHPO,6,PRCHAM,3,DAYS,0),U,4) I DAYS1=PAY D  Q
 ...S DAYS2=^PRC(443.6,PRCHPO,6,PRCHAM,3,DAYS,1,1,0) Q
 ..I FIELD'=.01 S PCT=0 F  S PCT=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",33,.01,PCT)) Q:PCT'>0  S PCT1=$P(^PRC(443.6,PRCHPO,6,PRCHAM,3,PCT,0),U,4) I PCT1=PAY D  Q
 ...S PCT2=^PRC(443.6,PRCHPO,6,PRCHAM,3,PCT,1,1,0) Q
 ..S TERMS=$G(^PRC(443.6,PRCHPO,5,PAY,0)) Q:TERMS=""
 ..S NPCT=$P(TERMS,U),NDAYS1=$P(TERMS,U,2)
 ..D LINE^PRCHPAM5(.LCNT,2)
 ..S DAYS2=$G(DAYS2),PCT2=$G(PCT2)
 ..I DAYS2'=0,PCT2'=0 S DATA="Prompt Payment "_PCT2_$S(PCT2=+PCT2:"%",1:"")_"/"_DAYS2_$S(DAYS2=+DAYS2:" days",1:"") D
 ...S DATA=DATA_" has been changed to "_NPCT_$S(NPCT=+NPCT:"%",1:"")_"/"_NDAYS1_$S(NDAYS1=+NDAYS1:" days",1:"")
 ...D DATA^PRCHPAM5(.LCNT,DATA) Q
 ..I DAYS2=0,PCT2=0 S DATA="  *ADDED THROUGH AMENDMENT*" D DATA^PRCHPAM5(.LCNT,DATA) D
 ...S DATA="Prompt Payment "_NPCT_$S(NPCT=+NPCT:"%",1:"")_"/"_NDAYS1_$S(NDAYS1=+NDAYS1:" days",1:"")_" has been added"
 ...D DATA^PRCHPAM5(.LCNT,DATA) Q
 ..Q
 .Q
 D LCNT1^PRCHPAM5(LCNT)
 Q
 ;
E34 ;AUTHORITY Edit PRINT
 ;N CHANGE,OLD,NEW,LCNT,DATA,DT2,I
 S CHANGE=0 D LCNT^PRCHPAM5(.LCNT)
 F  S CHANGE=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,3,CHANGE)) Q:CHANGE'>0  D
 .S CHANGES=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,0),OLD=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0)
 .S NEW=$P(^PRC(443.6,PRCHPO,6,PRCHAM,0),U,4)
 .D LINE^PRCHPAM5(.LCNT,2)
 .I OLD=0 S DATA=" *ADDED THROUGH AMENDMENT*" D DATA^PRCHPAM5(.LCNT,DATA) D
 ..S DATA="Authority Edit is",DT2=$P(^PRCD(442.2,NEW,0),U,2) D  D DATA^PRCHPAM5(.LCNT,DATA)
 ...I $L(DATA)+$L(DT2)>239 S DATA=DATA_":" D DATA^PRCHPAM5(.LCNT,DATA) S DATA=DT2 Q
 ...S DATA=DATA_" "_DT2
 .I OLD>0 S DATA="Authority Edit " D  D DATA^PRCHPAM5(.LCNT,DATA)
 ..F I=1:1:3 S DT2=$S(I=1:$P(^PRCD(442.2,OLD,0),U,2),I=2:" has been changed to ",I=3:$P(^PRCD(442.2,NEW,0),U,2)) D CHK(.DATA,DT2)
 .D LCNT1^PRCHPAM5(LCNT)
 .Q
 Q
CHK(DATA,DT2) ;
 I $L(DATA)+$L(DT2)<241 S DATA=DATA_DT2 Q
 D DATA^PRCHPAM5(.LCNT,DATA) S DATA=DT2
 Q
E35 ;F.O.B. Point PRINT
 Q
 ;N CHANGE,OLD,NEW
 S CHANGE=0 D LCNT^PRCHPAM5(.LCNT)
 F  S CHANGE=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,6.4,CHANGE)) Q:CHANGE'>0  D
 .S OLD=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0),NEW=$P($G(^PRC(443.6,PRCHPO,1)),U,6)
 .D LINE^PRCHPAM5(.LCNT,2)
 .S DATA="F.O.B. Point "_OLD_" has been changed to "_NEW D DATA^PRCHPAM5(.LCNT,DATA)
 .D LCNT1^PRCHPAM5(LCNT)
 .Q
 Q
