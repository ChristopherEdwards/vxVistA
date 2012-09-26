PRCPCRPL ;WISC/RFJ/DWA-cc and ik preparation list ;01 Sep 93
 ;;5.1;IFCAP;**27,49**;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q
 ;
 ;
DQ ;  called from prcpopt to print preparation list on picking ticket
 ;  print cc from ^tmp($j,"prcpcrpl-cc",itemda)
 ;  print ik from ^tmp($j,"prcpcrpl-ik",itemda)
 N %,CCIKITEM,COMMENTS,DESCR,DFN,ITEMDATA,LOCATION,OPCODE,OPDATE,ORROOM,PATNAME,PATSSN,PRCPDATA,PRCPSDAT,PRCPFILE,PRCPINPT,PRCPPAT,PRCPSURG,SEQ,SURGEON,VADM,VAERR,X,Y
 D PAT
 D SURG
 D CART
 D IK
 D Q
 Q
 ;
Q ; clean up ^TMP
 K ^TMP("PRCPCRPL-CC"),^TMP("PRCPCRPL-IK"),^TMP("PRCPCRPL-KIT"),^TMP("PRCPCRPLSEQ"),^TMP("PRCPCRPLSEQ2")
 Q
 ;
PAT ; get patient data
 S PRCPPAT=+$P($G(^PRCP(445.3,ORDERDA,2)),"^"),PRCPSURG=+$P($G(^(2)),"^",2)
 S DFN=PRCPPAT I $$VERSION^XPDUTL("DG") D DEM^VADPT
 S PATNAME=$G(VADM(1)),PATSSN=$P($G(VADM(2)),"^")
 Q
 ;
SURG ;  get surgery data
 D SURGDATA(PRCPSURG,".02;.09;.14;.28;27")
 S ORROOM=$G(PRCPSDAT(130,PRCPSURG,.02,"E")),OPDATE=$G(PRCPSDAT(130,PRCPSURG,.09,"E")),SURGEON=$G(PRCPSDAT(130,PRCPSURG,.14,"E")),OPCODE=$G(PRCPSDAT(130,PRCPSURG,27,"I")),OPCODE=OPCODE_"  "_$P($$ICPT^PRCPCUT1(+OPCODE),"^",2)
 ;
 Q
 ;
CART ;  process case carts
 I $D(^TMP($J,"PRCPCRPL-CC")) D
 . S CCIKITEM=0,PRCPFILE=445.7
 . K ^TMP($J,"PRCPCRPL-KIT")
 . F  S CCIKITEM=$O(^TMP($J,"PRCPCRPL-CC",CCIKITEM)) Q:'CCIKITEM!($G(PRCPFLAG))  D
 . . D H
 . . S PRCPFILE=445.7
 . . D CCIKNAME Q:$G(PRCPFLAG)
 . . D CART2,CART3 Q:$G(PRCPFLAG)
 . . D COMMENTS Q:$G(PRCPFLAG)
 . . K ^TMP($J,"PRCPCRPLSEQ")
 . . D:SCREEN P^PRCPUREP Q:$G(PRCPFLAG)
 . . I $D(^TMP($J,"PRCPCRPL-KIT")) D KIT K ^TMP($J,"PRCPCRPL-KIT")
 I $G(PRCPFLAG) Q
 Q
CART2 ;  set up ^TMP($J,"PRCPCRPLSEQ", for print of carts
 Q:$G(PRCPFLAG)
 S ITEMDA=0
 F  S ITEMDA=$O(^PRCP(445.7,CCIKITEM,1,ITEMDA)) Q:'ITEMDA!($G(PRCPFLAG))  D
 . S SEQ=$$STORAGE^PRCPESTO(PRCPINPT,ITEMDA)
 . I SEQ="" S SEQ="?"
 . S ^TMP($J,"PRCPCRPLSEQ",SEQ,CCIKITEM,ITEMDA)=""
 . I $D(^PRCP(445.8,ITEMDA)) S ^TMP($J,"PRCPCRPL-KIT",CCIKITEM,ITEMDA)=""
 Q
 ;
CART3 ;  print out carts
 Q:$G(PRCPFLAG)
 S SEQ=""
 F  S SEQ=$O(^TMP($J,"PRCPCRPLSEQ",SEQ)) Q:SEQ=""!($G(PRCPFLAG))  D
 . S ITEMDA=""
 . F  S ITEMDA=$O(^TMP($J,"PRCPCRPLSEQ",SEQ,CCIKITEM,ITEMDA)) Q:'ITEMDA!($G(PRCPFLAG))  D
 . . S ITEMDATA=$G(^PRCP(445.7,CCIKITEM,1,ITEMDA,0))
 . . D WRITE
 . . Q:$G(PRCPFLAG)
 Q
 ;
IK ;  process freestanding instrument kits
 Q:$G(PRCPFLAG)
 I $D(^TMP($J,"PRCPCRPL-IK")) D
 . S CCIKITEM=0,PRCPFILE=445.8
 . F  S CCIKITEM=$O(^TMP($J,"PRCPCRPL-IK",CCIKITEM)) Q:'CCIKITEM!($G(PRCPFLAG))  D
 . . D H
 . . D CCIKNAME Q:$G(PRCPFLAG)
 . . D IK2,IK3 Q:$G(PRCPFLAG)
 . . D COMMENTS Q:$G(PRCPFLAG)
 . . K ^TMP($J,"PRCPCRPLSEQ")
 . . D:SCREEN P^PRCPUREP Q:$G(PRCPFLAG)
 I $G(PRCPFLAG) Q
 Q
IK2 ;  set up ^TMP($J,"PRCPCRPLSEQ", for print of kits
 Q:$G(PRCPFLAG)
 K ^TMP($J,"PRCPCRPLSEQ")
 S ITEMDA=0
 F  S ITEMDA=$O(^PRCP(445.8,CCIKITEM,1,ITEMDA)) Q:'ITEMDA!($G(PRCPFLAG))  D
 . S SEQ=$P(^PRCP(445.8,CCIKITEM,1,ITEMDA,0),"^",3)
 . I SEQ="" S SEQ=99.99
 . S ^TMP($J,"PRCPCRPLSEQ",SEQ,CCIKITEM,ITEMDA)=""
 Q
 ;
IK3 ;  print out kits
 Q:$G(PRCPFLAG)
 S SEQ=0
 F  S SEQ=$O(^TMP($J,"PRCPCRPLSEQ",SEQ)) Q:'SEQ!($G(PRCPFLAG))  D
 . S ITEMDA=0
 . F  S ITEMDA=$O(^TMP($J,"PRCPCRPLSEQ",SEQ,CCIKITEM,ITEMDA)) Q:'ITEMDA!($G(PRCPFLAG))  D
 . . S ITEMDATA=$G(^PRCP(445.8,CCIKITEM,1,ITEMDA,0))
 . . D WRITE
 . . Q:$G(PRCPFLAG)
 Q
 ;
KIT ;  process kits associated with cart
 Q:$G(PRCPFLAG)
 N CCITEM,CCIKITEM
 S PRCPFILE=445.8
 S CCITEM=0
 F  S CCITEM=$O(^TMP($J,"PRCPCRPL-KIT",CCITEM)) Q:'CCITEM!($G(PRCPFLAG))  D
 . S CCIKITEM=0
 . F  S CCIKITEM=$O(^TMP($J,"PRCPCRPL-KIT",CCITEM,CCIKITEM)) Q:'CCIKITEM!($G(PRCPFLAG))  D
 . . D H,CCIKNAME
 . . Q:$G(PRCPFLAG)
 . . D KIT2,KIT3 Q:$G(PRCPFLAG)
 . . D COMMENTS Q:$G(PRCPFLAG)
 . . K ^TMP($J,"PRCPCRPLSEQ2")
 . D:SCREEN P^PRCPUREP Q:$G(PRCPFLAG)
 Q
KIT2 ; set up ^TMP($J,"PRCPCRPLSEQ2", for print of kits
 Q:$G(PRCPFLAG)
 K ^TMP($J,"PRCPCRPLSEQ2")
 S ITEMDA=0
 F  S ITEMDA=$O(^PRCP(PRCPFILE,CCIKITEM,1,ITEMDA)) Q:'ITEMDA!($G(PRCPFLAG))  D
 . S ITEMDATA=$G(^PRCP(PRCPFILE,CCIKITEM,1,ITEMDA,0))
 . S SEQ=$P(ITEMDATA,"^",3)
 . I SEQ="" S SEQ=99.99
 . S ^TMP($J,"PRCPCRPLSEQ2",SEQ,CCIKITEM,ITEMDA)=""
 Q
KIT3 ; print out kits
 Q:$G(PRCPFLAG)
 S SEQ=0
 F  S SEQ=$O(^TMP($J,"PRCPCRPLSEQ2",SEQ)) Q:'SEQ!($G(PRCPFLAG))  D
 . S ITEMDA=0
 . F  S ITEMDA=$O(^TMP($J,"PRCPCRPLSEQ2",SEQ,CCIKITEM,ITEMDA)) Q:'ITEMDA!($G(PRCPFLAG))  D
 . . S ITEMDATA=$G(^PRCP(PRCPFILE,CCIKITEM,1,ITEMDA,0))
 . . D WRITE
 . . Q:$G(PRCPFLAG)
 Q
 ;
WRITE ;  write data
 I $Y>(IOSL-4) D:SCREEN P^PRCPUREP Q:$G(PRCPFLAG)  D H
 S LOCATION=$$STORAGE^PRCPESTO(PRCPINPT,ITEMDA)
 S DESCR=$E($$DESCR^PRCPUX1(PRCPINPT,ITEMDA),1,33)_" (#"_ITEMDA_")"
 W !?2,DESCR,?45,$J(+$P(ITEMDATA,"^",2),5),$J($P($$UNIT^PRCPUX1(PRCPINPT,ITEMDA,"^"),"^",2),4),"  ",$E(LOCATION,1,15),?72,"__ __ __"
 Q
 ;
 ;
CCIKNAME ;  write cc or ik name
 I $Y>(IOSL-8) D:SCREEN P^PRCPUREP Q:$D(PRCPFLAG)  D H
 S PRCPDATA=$G(^PRCP(PRCPFILE,CCIKITEM,0))
 S PRCPINPT=$P(PRCPDATA,"^",2)
 S LOCATION=$$STORAGE^PRCPESTO(PRCPINPT,CCIKITEM)
 S DESCR=$E($$DESCR^PRCPUX1(PRCPINPT,CCIKITEM),1,40)_" (#"_CCIKITEM_") .............................................................."
 W !!?22,"* * * * *  ",$S(PRCPFILE=445.7:"  CASE CART   ",1:"INSTRUMENT KIT"),"  * * * * *"
 W !,$E(DESCR,1,55),?56,$E(LOCATION,1,15),?72,"__ __ __"
 W !?10,"from: ",$$INVNAME^PRCPUX1(PRCPINPT)
 Q
 ;
 ;
COMMENTS ;  print comments
 I $Y>(IOSL-7) D:SCREEN P^PRCPUREP Q:$D(PRCPFLAG)  D H
 I PRCPFILE=445.8 D
 .   W !,"METHOD OF STERILIZATION     : ",$$STERILE^PRCPCRDK(CCIKITEM)
 .   W !,"METHOD OF WRAPPING/PACKAGING: ",$$WRAPPING^PRCPCRDK(CCIKITEM)
 W !,$S(PRCPFILE=445.7:"CASE CART",1:"INSTRUMENT KIT")," SPECIAL INSTRUCTIONS/REMARKS:"
 S X=0 F  S X=$O(^PRCP(PRCPFILE,CCIKITEM,2,X)) Q:'X!($G(PRCPFLAG))  S DATA=$G(^(X,0)) D
 .   I $Y>(IOSL-4) D:SCREEN P^PRCPUREP Q:$D(PRCPFLAG)  D H
 .   W !,DATA
 Q
 ;
 ;
H S %=NOW_"  PAGE "_PAGE,PAGE=PAGE+1 I PAGE'=2!(SCREEN) W @IOF
 W $C(13),"CASE CART OR INSTRUMENT KIT PREPARATION LIST  ",?(80-$L(%)),%
 S %="",$P(%,"-",81)=""
 W !?1,"PATIENT: ",$E(PATNAME,1,28),?40,"SSN: ",PATSSN,?63,"RETURNED BY ____."
 W !?1,"DATE OF OPERATION: ",OPDATE,?32,"OR ROOM: ",$E(ORROOM,1,18),?60,"RECEIVED BY ____.  |"
 W !?1,"PRINCIPAL OPERATION CODE: ",OPCODE,?59,"PICKED BY ____.  |  |"
 W !?1,"SURGEON: ",SURGEON,?73,"|  |  |"
 W !?73,"V  V  V"
 W !,"DESCRIPTION (#MI)",?45,$J("QTY",5),$J("UI",4),?56,"LOCATION",?72,"CK CK CK",!,%
 W !?1,"COMMENTS:"
 S %=0 F  S %=$O(COMMENTS(%)) Q:'%  W !,COMMENTS(%)
 W !
 Q
 ;
 ;
SURGDATA(DA,DR)       ;  get surgery data
 N D0,DIC,DIQ,QPQPQ
 K PRCPSDAT
 S QPQPQ=1 ;  to prevent executing field 27 opcode transform
 S DIC="^SRF(",DIQ="PRCPSDAT",DIQ(0)="IEN" D EN^DIQ1
 Q