QANRPT1 ;HISC/GJC-SUMMARY OF INCIDENTS/WARD ;5/6/91
 ;;2.0;Incident Reporting;**26,29**;08/07/1992
 ;
 N QANINFLG,QANLCFLG
 F  W !,"Do you wish to produce a report by Incident Location" S %=1 D YN^DICN Q:"-112"[%  W !,$C(7),"Enter ""Y""es to issue a report by Incident Location,",!,"""N""o to issue a report by Patient's Ward."
 I %=-1 K % Q
 S:%=2 QANCHOS="W" S:%=1 QANCHOS="I"
 D DIV
DATE ;
 D ^QAQDATE I QAQQUIT W !!,$C(7),"Invalid date range, no report will be produced." D KILL Q
 S (PAGE,QANTYPE)=0
 I $D(QAQNBEG) S Y=QAQNBEG D DD^%DT S QANDATE(0)=Y
 S:$D(QAQNBEG) QAQNBEG=QAQNBEG-.00000001
 S:$D(QAQNEND) QAQNEND=QAQNEND_".99999999"
 S QANHEAD(0)="QUALITY MANAGEMENT INCIDENT REPORT",QANHEAD(1)="SUMMARY OF INCIDENTS BY INCIDENT LOCATION",QANHEAD(2)="SUMMARY OF INCIDENTS BY PATIENT WARD"
 S Y=$P(QAQNEND,".") D DD^%DT S QANDATE(1)=Y
 S QANHEAD(3)="FOR THE PERIOD "_QANDATE(0)_" TO "_QANDATE(1)
 D INCD^QANUTL4 I QANY D KILL Q
 D:QANCHOS="I" QANLOC^QANUTL4 D:QANCHOS="W" WARD^QANUTL4 I QANY D KILL Q
LOOP ;
 N QANCC,QANEE
 S QANEE=QAQNBEG
 F  S QANEE=$O(^QA(742.4,"BDT",QANEE)) Q:QANEE'>0!(QANEE>QAQNEND)  D
 . S QANCC=0
 . F  S QANCC=$O(^QA(742.4,"BDT",QANEE,QANCC)) Q:QANCC'>0  D
 . . S QANDD=0
 . . F  S QANDD=$O(^QA(742,"BCS",QANCC,QANDD)) Q:QANDD'>0  D
 . . . S QAN7424=^QA(742.4,QANCC,0) Q:$G(QAN7424)']""
 . . . S QAN742=^QA(742,QANDD,0) Q:$G(QAN742)']""
 . . . I $P(QAN7424,U,8)=2 Q
 . . . S QANINC=$P(QAN7424,U,2) I $G(QANINC)']"" Q
 . . . I $G(QANINFLG)'=1 I $G(^TMP("QANRPT1",$J,"INC",QANINC))']"" Q
 . . . I $P(QAN742,U,5)'=1 Q
 . . . S QANLCN=$S($G(QANCHOS)="I":$P(QAN7424,U,4),1:$P(QAN742,U,6)) Q:'$G(QANLCN)
 . . . I $G(QANCHOS)="I" S QANLOC=$P(^QA(742.5,QANLCN,0),U)
 . . . I $G(QANCHOS)="W" S QANLOC=$P(^SC($P(QAN742,U,6),0),U)
 . . . I $G(QANLOC)']"" Q
 . . . I $G(QANLCFLG)'=1 I $G(^TMP("QANRPT1",$J,"LOC",QANLCN))']"" Q
 . . . S QANDIV=$P(QAN7424,U,22) I $G(QANDIV)']"" S QANDIV=0
 . . . I $G(QAN1DIV)]"" Q:QAN1DIV'=QANDIV
 . . . I '$D(^QA(740,1,"QAN2","B",QANDIV)) S QANDIV=0
 . . . I $P($G(^QA(740,1,"QAN")),U,5)'=1 S QANDIV=0
 . . . S QANINC=$P(^QA(742.1,QANINC,0),U)
 . . . S QANINC=$TR(QANINC,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 . . . S ^TMP("QANRPT1",$J,"QAN",QANDIV,QANLOC,QANINC,QANCC,QANDD)=""
 I '$D(^TMP("QANRPT1",$J)) W !!,$C(7),"No records found for the selected date range." D KILL Q
 S QANWORD=$S($G(QANCHOS)="I":"Incident",1:"Ward")
 I '$G(QANLCFLG),('$D(^TMP("QANRPT1",$J,"LOC"))) W !!,$C(7),QANWORD," location(s) not found, exiting the report." D KILL Q
 I '$G(QANINFLG),('$D(^TMP("QANRPT1",$J,"INC"))) W !!,$C(7),"Incident(s) not found, exiting the report." D KILL Q
 D TOTAL
TASK S Y=DT X ^DD("DD") S TODAY=Y,$P(BNDRY,"-",$S(IOM=132:133,1:81))="",QANFIN=""
 ;*** Choose device ***
 K IOP,%ZIS S %ZIS("A")="Print on device: ",%ZIS="MQ" W ! D ^%ZIS W !!
 G:POP KILL
 I $D(IO("Q")) S ZTRTN="STRT^QANRPT1",ZTDESC="Generate Incident reports for incidents by type." D QLOOP^QANRPT2,^%ZTLOAD W !,$S($D(ZTSK):"Request queued!",1:"Request cancelled!"),! G EXIT
STRT U IO
 D:QANFIN'["^" PRINT
EXIT W ! D ^%ZISC,HOME^%ZIS
KILL ;Kill and quit.
 D K^QAQDATE
 K QAQNBEG,QAQNEND
 K QAN742,QAN7424,QANAA,QANBB,QANCC,QANDD,QANEE,QANFF,QANXX,QANYY,QANZZ
 K BNDRY,COUNT,LOOP,PAGE,TODAY,X,Y,%
 K QANCDNT,QANCHOS,QANCNT,QANDAT1,QANDAT2,QANDATA1,QANDATA2,QANDATE
 K QANDIV,QANDV,QANDVFLG,QANDVN,QANDVSN,QANFLG,QANFIN,QANINC,QANINFLG
 K QANHEAD,QANINC,QANINCID,QAN,QANLCFLG,QANLOC,QANLOCA
 K QANNODE,QANNUM,QANTYPE,QANY
 K ^TMP("QANRPT1"),LP,LP0,LP1,LP2,QA,C
 K DIROUT,DIRUT,DTOUT,DUOUT,D
 Q
FINAL ;Final data summation.
 D:$Y>(IOSL-4) HDH,HDR^QANAUX1 Q:QANFIN["^"
 I $G(COUNT("TOT"))'>0 W !!,"No incidents found, exiting the report." Q
 S QANFF=""
 F  S QANFF=$O(COUNT("LOC",QANAA,QANFF)) Q:QANFF']""  D
 . S QANLOCA=QANFF
 . W !,"Total number of incidents for "_$S(QANCHOS="W":"ward ",1:"incident location ")_QANLOCA_": "_COUNT("LOC",QANAA,QANFF)
 I $G(QANDVFLG)=1 W !!,"Total number of Incidents for division "_QANDV_": "_COUNT("DIV",QANAA)
 W !!,"Total number of incidents this reporting period: "_COUNT("TOT")
 D HDH
 Q
TOTAL ;
 N QANAA,QANBB,QANCC,QANDD
 S QANAA=""
 F  S QANAA=$O(^TMP("QANRPT1",$J,"QAN",QANAA)) Q:QANAA']""  D
 . S QANBB=""
 . F  S QANBB=$O(^TMP("QANRPT1",$J,"QAN",QANAA,QANBB)) Q:QANBB']""  D
 . . S QANCC=""
 . . F  S QANCC=$O(^TMP("QANRPT1",$J,"QAN",QANAA,QANBB,QANCC)) Q:QANCC']""  D
 . . . S QANDD=0
 . . . F  S QANDD=$O(^TMP("QANRPT1",$J,"QAN",QANAA,QANBB,QANCC,QANDD)) Q:QANDD'>0  D
 . . . . S COUNT("INC",QANAA,QANBB,QANCC)=$G(COUNT("INC",QANAA,QANBB,QANCC))+1
 . . . . S COUNT("TOT")=$G(COUNT("TOT"))+1
 . . . . S COUNT("DIV",QANAA)=$G(COUNT("DIV",QANAA))+1
 . . . . S COUNT("LOC",QANAA,QANBB)=$G(COUNT("LOC",QANAA,QANBB))+1
 Q
HDH ;
 I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR K DIR S:+Y=0 QANFIN="^"
 Q
WARD ;
 N QANCNT,QANDD
 S QANDD=0
 S QANCNT=1
 F  S QANDD=$O(^QA(742,"BCS",QANIEN,QANDD)) Q:QANDD'>0  D
 . Q:'$P($G(^QA(742,QANDD,0)),U,6)
 . S QANLOC(QANCNT)=$P(^QA(742,QANDD,0),U,6)
 . S QANCNT=QANCNT+1
 Q
INST(QANIEN,QANDV) ;api for getting division name
 N DIC
 K QANDV
 S DIC="^DIC(4,"
 S DIC(0)="NZX"
 S DIC("S")="I $D(^QA(740,1,""QAN2"",""B"",X))"
 S X=QANIEN
 D ^DIC K DIC
 I Y<0 S QANDV="Unknown" Q
 S QANDV=Y(0,0)
 Q
PRINT ;print or display data
 I '$D(COUNT) G FINAL
 S QANAA=""
 F  S QANAA=$O(COUNT("INC",QANAA)) Q:QANAA']""  D
 . D INST(QANAA,.QANDV)
 . I $G(QANDVFLG)=1 S QANHEAD(4)="REPORT FOR DIVISION: "_QANDV
 . D HDR^QANAUX1
 . S QANBB=""
 . F  S QANBB=$O(COUNT("INC",QANAA,QANBB)) Q:QANBB']""  D
 . . D:$Y>(IOSL-6) HDH,HDR^QANAUX1 Q:QANFIN["^"  W !!,$E(QANBB,1,32)
 . . S QANCC=""
 . . F  S QANCC=$O(COUNT("INC",QANAA,QANBB,QANCC)) Q:QANCC']""  D
 . . . S QANDD=$O(^TMP("QANRPT1",$J,"QAN",QANAA,QANBB,QANCC,0)) Q:QANDD'>0
 . . . S QANINCID=$P(^QA(742.1,$P(^QA(742.4,QANDD,0),U,2),0),U)
 . . . S QANNUM=COUNT("INC",QANAA,QANBB,QANCC)
 . . . D:$Y>(IOSL-4) HDH,HDR^QANAUX1 W ?35,$E(QANINCID,1,35),?72,QANNUM,!
 . D FINAL
 Q
DIV ;
 K QANDVFLG,QAN1DIV
 S QANDVFLG=$P($G(^QA(740,1,"QAN")),U,5)
 Q:$G(QANDVFLG)'=1
 N DIR,DIRUT,DTOUT,DUOUT
 S DIR(0)="YA"
 S DIR("A")="Select ALL Divisions? "
 S DIR("B")="YES"
 D ^DIR K DIR I $D(DIRUT) S QANPOP=1 Q
 I Y S QAN1DIV="" Q
 N DIC
 S DIC="^QA(740,1,""QAN2"","
 S DIC(0)="AEMZQ"
 S DIC("A")="Enter Division: "
 S QANDVSN=$O(^QA(740,1,"QAN2",0)) Q:$G(QANDVSN)'>0
 D INST($G(^QA(740,1,"QAN2",QANDVSN,0)),.QANDVN)
 S DIC("B")=$G(QANDVN)
 D ^DIC K DIC
 I +Y>0 S QAN1DIV=Y(0)
 Q
