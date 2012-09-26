SPNCTOUA ;WDE/SD OUTPATIENT MAIN STARTING POINT ;6/27/02  05:15
 ;;2.0;Spinal Cord Dysfunction;**19,20**;01/02/1997
 ;
 ; 
OUT ;Starting point called from the option
 ;patient is asked and then spnct is set to 2
 ;  the patient's dfn is passed back in SPNFDFN
 D ZAP^SPNCTINA  ;make sure all is clean before we start
 D KILL^SPNCTINA
 D PAT1541^SPNFMENU
 S SPNNEW=""
 Q:SPNFEXIT=1
 Q:$D(SPNFDFN)=""
RESTART ;
 S SPNFEXIT=0,SPNEXIT=0
 I $D(SPNDFN)=0 S SPNDFN=SPNFDFN
 I $D(SPNDFN)=0 D ZAP^SPNCTINA Q
 S SPNNEW=""
 S SPNCT=2  ;outpatient
 D EN^SPNCTBLD(SPNCT,SPNDFN)  ;build utility with in patient 
 D CUR^SPNCTCUR(SPNCT,SPNDFN)  ;build tmp with current
 S SPNHDR="Current OUTPATIENT Episode of Care"
 D EN^SPNCTSHW(SPNDFN)
 ;
 S SPNA=$P($G(^TMP($J,0)),U,2)  ;no episodes on file
 I SPNA=0 D ADD^SPNCTOUB D ZAP Q  ;start a new episode of care
 I SPNSEL="P" S SPNHDR="Previous OUTPATIENT Episode(s) of Care" D EN^SPNCTPAA(SPNCT,SPNDFN) D ZAP Q
 I SPNSEL="C" D ADD^SPNCTOUB D ZAP Q  ;episodes on file but closed
 I SPNSEL="A" D ADD
 I SPNEXIT=1 D ZAP Q
 ;I $G(SPNCLOSE)'="" I SPNCLOSE=1 D CLOSE^SPNCTCLS S SPNXMIT=1  ;close group
 I SPNEXIT'=1 I $D(SPNFD0) I $D(SPNFTYPE)  D EDIT^SPNFEDT0
 ;
 D ZAP S SPNFDFN=SPNDFN G RESTART
 Q
ZAP ;
 K ^UTILITY($J),^TMP($J)
 K SPNA,SPNB,SPNC,SPNRTN,SPNSEL,SPNFTYPE,SPNFD0,SPNIEN,SPNSCOR,DIR,DA,DIE,SPNFEXIT,SPNSET,SPNDATA
 K SPNCEDT,SPNFIEN,SPNTST
 K SPNCTYP,SPNW,SPNX,SPNY,SPNZ,SPNCNT,SPNXMIT,SPNFIEN,SPNDATE,DIC,DR,SPNLINE,SPNCNT,SPNOUT,SPNOTNE
 Q
ADD ; *** Add a record to the OUTCOMES file (#154.1)
 I $G(SPNFDFN)="" I +$G(SPNDFN) S SPNFDFN=SPNDFN
 I SPNFDFN="" D ZAP^SPNOGRDA Q
 D REPT^SPNFEDT0(SPNFDFN)
 I $G(SPNFFIM)=0 D ZAP Q
 D OUT^SPNCTAA  ;prompt for the score type for the new outcome
 I SPNEXIT=1 D ZAP Q
 ;above is the new order for score type and record type
 ;D OUT^SPNCTAA  ;prompt for the score type for the new outcome
 ;I SPNEXIT=1 D ZAP Q
 ;D REPT^SPNFEDT0(SPNFDFN)
 ;I $G(SPNFFIM)=0 D ZAP Q
 I SPNFTYPE="" D ZAP Q  ;no fim record type selected
 I SPNEXIT=1 D ZAP Q
 I '+SPNSCOR D ZAP Q
 K DIR S DIR("A")="Enter a New Record Date: "
 D DATES  ;Date range set up of dir(0) set above as saftey
 D ^DIR
 I '+Y K DIR,Y S SPNFEXIT=1 Q
 S SPNDATE=Y
 K DD,DIC,DINUM,DO
 S SPNFD0=-1
 S DIC="^SPNL(154.1,",DIC(0)="L"
 S DLAYGO=154.1,X=SPNFDFN
 D FILE^DICN W ! S SPNFD0=+Y
 K DA,DIE,DR
 I $G(SPNSCOR)="" S SPNSCOR=""
 S DIE="^SPNL(154.1,",DA=SPNFD0
 S SPNCDT=$P($G(^TMP($J,0)),U,2)
 I SPNCDT="" W !,"No care start date is on file for this patient !" D ZAP Q
 S DR=".02///^S X="_SPNFTYPE_";.04///"_SPNDATE_";.021///"_SPNSCOR_";.023///"_$$EN^SPNMAIN(DUZ)_";1001///"_SPNCDT_";1002///"_$P($G(^TMP($J,0)),U,3)_";1003////2"
 I SPNSCOR=10 D CHK^SPNCTCLS
 I SPNEXIT=1 D ZAP Q  ;^ OUT OF THE CLOSE QUESTION
 D ^DIE
 S SPNNEW="YES"
 ;
 Q
DATES ;set up upper and lower boundaries for the new record
 ;     If there is a care stop date that will be the upper
 ;     If there is a care start date that will be the lower
 ;     Note that TMP is 2nd and 3rd piece is the care start
 ;                      and endates
 ;           So if they are adding a outcome to a closed episode
 ;           piece 2 and 3 will be present.
 S (SPNX,SPNY)="",DIR(0)=""
 S SPNX=$P($G(^TMP($J,0)),U,2)
 S SPNY=$P($G(^TMP($J,0)),U,3)
 I SPNY'=""  S DIR(0)="DAO^"_SPNX_":"_SPNY_":EX" Q
 ;spny = close date
 I SPNSCOR'=5 I SPNY="" S DIR(0)="DAO^"_SPNX_":"_DT_":EX" Q
 I SPNSCOR=5 I SPNY="" D
 .S SPNB=""
 .S SPNA=0 F  S SPNA=$O(^TMP($J,SPNA)) Q:SPNA=""  S SPNB="" S SPNB=$O(^TMP($J,SPNA,SPNB)) Q:SPNB=""
 .I $G(SPNB)'="" S DIR(0)="DAO^"_SPNB_":"_DT_":EX" Q
 .Q
 Q
