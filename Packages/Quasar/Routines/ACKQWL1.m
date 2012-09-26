ACKQWL1 ;AUG/JLTP-Compile A&SP Capitation Data - CONTINUED ; [ 12/05/95  12:03 PM ]
 ;;3.0;QUASAR;;Feb 11, 2000
 ;Per VHA Directive 10-93-142, this routine SHOULD NOT be modified.
 N CPT,DFN,DIE,DR,I,ICD,VAPA,VAERR
 K ^TMP("ACKQWL",$J) D FYSTATS,MONTH,STUFF
 Q
FYSTATS ;Gather uniques from begin of FY to now to screen against.
 F ACKD=ACKBFY:0 S ACKD=$O(^ACK(509850.6,"B",ACKD)) Q:'ACKD!(ACKD>ACKM)  D
 .S ACKV=0 F  S ACKV=$O(^ACK(509850.6,"B",ACKD,ACKV)) Q:'ACKV  D
 ..S ACKV(0)=$G(^ACK(509850.6,ACKV,0)) Q:ACKV(0)=""
 ..S DFN=$P(ACKV(0),U,2) Q:'DFN  S ACKSTOP=$P($G(^ACK(509850.6,ACKV,2)),U) Q:ACKSTOP=""
 ..D ADD^VADPT S ACKZIP=$S(VAPA(6):VAPA(6),1:0)
 ..S ^TMP("ACKQWL",$J,"PRE",3,ACKSTOP,ACKZIP,DFN)="" ;UNIQUE VISITS THIS FY PRE THIS MONTH
 ..S ICD="" F  S ICD=$O(^ACK(509850.6,ACKV,1,"B",ICD)) Q:ICD=""  D
 ...S ^TMP("ACKQWL",$J,"PRE",1,ACKSTOP,ACKZIP,ICD,DFN)="" ;UNIQUE PTS W/ICD FY PRE THIS MO
 ..S CPT="" F  S CPT=$O(^ACK(509850.6,ACKV,3,"B",CPT)) Q:CPT=""  D
 ...S ^TMP("ACKQWL",$J,"PRE",2,ACKSTOP,ACKZIP,CPT,DFN)="" ;UNIQUE PTS W/CPT FY PRE THIS MO
 Q
MONTH ;Gather stats from selected month.
 F ACKD=ACKM:0 S ACKD=$O(^ACK(509850.6,"B",ACKD)) Q:'ACKD!(ACKD>ACKEM)  D
 .S ACKV=0 F  S ACKV=$O(^ACK(509850.6,"B",ACKD,ACKV)) Q:'ACKV  D
 ..S ACKV(0)=$G(^ACK(509850.6,ACKV,0)) Q:ACKV(0)=""
 ..S DFN=$P(ACKV(0),U,2) Q:'DFN  S ACKSTOP=$P($G(^ACK(509850.6,ACKV,2)),U) Q:ACKSTOP=""
 ..D ADD^VADPT S ACKZIP=$S(VAPA(6):VAPA(6),1:0)
 ..S ^TMP("ACKQWL",$J,3,ACKSTOP,ACKZIP)=$G(^TMP("ACKQWL",$J,3,ACKSTOP,ACKZIP))+1
 ..S:$P(ACKV(0),U,5) ^TMP("ACKQWL",$J,4,ACKSTOP,ACKZIP)=$G(^TMP("ACKQWL",$J,4,ACKSTOP,ACKZIP))+1
 ..S:$P(ACKV(0),U,5) $P(^TMP("ACKQWL",$J,3,ACKSTOP,ACKZIP),U,2)=$P(^TMP("ACKQWL",$J,3,ACKSTOP,ACKZIP),U,2)+1
 ..S:'$D(^TMP("ACKQWL",$J,"PRE",3,ACKSTOP,ACKZIP,DFN)) ^TMP("ACKQWL",$J,"U",3,ACKSTOP,ACKZIP,DFN)=""
 ..S ICD="" F  S ICD=$O(^ACK(509850.6,ACKV,1,"B",ICD)) Q:ICD=""  D
 ...S ^TMP("ACKQWL",$J,1,ACKSTOP,ACKZIP,ICD)=$G(^TMP("ACKQWL",$J,1,ACKSTOP,ACKZIP,ICD))+1
 ...S:'$D(^TMP("ACKQWL",$J,"PRE",1,ACKSTOP,ACKZIP,ICD,DFN)) ^TMP("ACKQWL",$J,"U",1,ACKSTOP,ACKZIP,ICD,DFN)=""
 ..S CPT="" F  S CPT=$O(^ACK(509850.6,ACKV,3,"B",CPT)) Q:CPT=""  D
 ...S ^TMP("ACKQWL",$J,2,ACKSTOP,ACKZIP,CPT)=$G(^TMP("ACKQWL",$J,2,ACKSTOP,ACKZIP,CPT))+1
 ...S:'$D(^TMP("ACKQWL",$J,"PRE",2,ACKSTOP,ACKZIP,CPT,DFN)) ^TMP("ACKQWL",$J,"U",2,ACKSTOP,ACKZIP,CPT,DFN)=""
 Q
STUFF ;Stuff data into A&SP WORKLOAD file (#509850.7).
 ;First by visit only.
 F ACKSTOP="A","S" S ACKZIP=-1 F  S ACKZIP=$O(^TMP("ACKQWL",$J,3,ACKSTOP,ACKZIP)) Q:ACKZIP=""  D
 .S ACKNV=^TMP("ACKQWL",$J,3,ACKSTOP,ACKZIP)
 .S (ACKNU,I)=0 F  S I=$O(^TMP("ACKQWL",$J,"U",3,ACKSTOP,ACKZIP,I)) Q:'I  S ACKNU=ACKNU+1
 .S ACKCP=+$G(^TMP("ACKQWL",$J,4,ACKSTOP,ACKZIP))
 .S DIE="^ACK(509850.7,",DA=ACKDA,DR="3///"""_ACKZIP_""""
 .S DR(2,509850.73)=".01///"_ACKZIP_";.02////"_ACKCP_";.03////"_ACKNV_";.04////"_ACKNU_";.05////^S X=$S(ACKSTOP=""A"":203,1:204)"
 .D ^DIE K DIE,DA,DR
 ;Then by ICD.
 F ACKSTOP="A","S" S ACKZIP=-1 F  S ACKZIP=$O(^TMP("ACKQWL",$J,1,ACKSTOP,ACKZIP)) Q:ACKZIP=""  D
 .S ACKICP=0 F  S ACKICP=$O(^TMP("ACKQWL",$J,1,ACKSTOP,ACKZIP,ACKICP)) Q:'ACKICP  D
 ..S ACKICD=$P($G(^ICD9(ACKICP,0)),U)
 ..S ACKNV=^TMP("ACKQWL",$J,1,ACKSTOP,ACKZIP,ACKICP)
 ..S (ACKNU,I)=0 F  S I=$O(^TMP("ACKQWL",$J,"U",1,ACKSTOP,ACKZIP,ACKICP,I)) Q:'I  S ACKNU=ACKNU+1
 ..S DIE="^ACK(509850.7,",DA=ACKDA,DR="1///"""_ACKICD_""""
 ..S DR(2,509850.71)=".01///"_ACKICD_";.02////"_ACKNV_";.03////"_ACKNU_";.04////^S X=$S(ACKSTOP=""A"":203,1:204);.05///"_ACKZIP
 ..D ^DIE K DIE,DA,DR
 ;Then by CPT.
 F ACKSTOP="A","S" S ACKZIP=-1 F  S ACKZIP=$O(^TMP("ACKQWL",$J,2,ACKSTOP,ACKZIP)) Q:ACKZIP=""  D
 .S ACKCPP=0 F  S ACKCPP=$O(^TMP("ACKQWL",$J,2,ACKSTOP,ACKZIP,ACKCPP)) Q:'ACKCPP  D
 ..S ACKCPT=$P($G(^ICPT(ACKCPP,0)),U)
 ..S ACKNV=^TMP("ACKQWL",$J,2,ACKSTOP,ACKZIP,ACKCPP)
 ..S (ACKNU,I)=0 F  S I=$O(^TMP("ACKQWL",$J,"U",2,ACKSTOP,ACKZIP,ACKCPP,I)) Q:'I  S ACKNU=ACKNU+1
 ..S DIE="^ACK(509850.7,",DA=ACKDA,DR="2///"""_ACKCPT_""""
 ..S DR(2,509850.72)=".01///"_ACKCPT_";.02////"_ACKNV_";.03////"_ACKNU_";.04////^S X=$S(ACKSTOP=""A"":203,1:204);.05///"_ACKZIP
 ..D ^DIE K DIE,DA,DR
