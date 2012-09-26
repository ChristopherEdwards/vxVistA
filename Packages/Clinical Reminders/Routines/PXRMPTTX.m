PXRMPTTX ; SLC/PKR - Routines for taxonomy print templates ;04/09/2003
 ;;2.0;CLINICAL REMINDERS;;Feb 04, 2005
 ;References to ICDAPIU DBIA #3991.
 ;References to ICPTAPIU DBIA #1997.
 ;=======================================================
ICD0LIST ;Print expanded list of ICD0 codes.
 N ACTDATE,CODE,DATA,INADATE,LOW,HIGH,TEMP,TEXT
 S TEMP=^PXD(811.2,D0,80.1,D1,0)
 S (ACTDATE,INADATE)=$$FMTE^XLFDT(DT,"5Z")
 S LOW=$P(TEMP,U,1)
 S HIGH=$P(TEMP,U,2)
 I HIGH="" S HIGH=LOW
 W !!,?2,"Code",?10,"ICD Operation/Procedure",?42,"Activation",?54,"Inactivation"
 W !,?2,"----",?10,"-----------------------",?42,"----------",?54,"------------"
 S CODE=LOW
 F  Q:(CODE]HIGH)!(CODE="")  D
 . K DATA
 . D PERIOD^ICDAPIU(CODE,.DATA)
 . S ACTDATE=0
 . F  S ACTDATE=$O(DATA(ACTDATE)) Q:ACTDATE=""  D
 .. S INADATE=$P(DATA(ACTDATE),U,1)
 .. S TEXT=$P(DATA(ACTDATE),U,2)
 .. S TEXT=$E(TEXT,1,30)
 .. W !,?2,CODE,?10,TEXT,?42,$$FMTE^XLFDT(ACTDATE,"5Z"),?54,$$FMTE^XLFDT(INADATE,"5Z")
 . S CODE=$$NEXT^ICDAPIU(CODE)
 Q
 ;
 ;=======================================================
ICD9LIST ;Print expanded list of ICD9 codes.
 N ACTDATE,CODE,DATA,IEN,INADATE,LOW,HIGH,SEL,TEMP,TEXT
 S TEMP=^PXD(811.2,D0,80,D1,0)
 S LOW=$P(TEMP,U,1)
 S HIGH=$P(TEMP,U,2)
 I HIGH="" S HIGH=LOW
 W !!,?2,"Code",?10,"ICD Diagnosis",?42,"Activation",?54,"Inactivation",?67,"Selectable"
 W !,?2,"----",?10,"--------------",?42,"----------",?54,"------------",?67,"----------"
 S CODE=LOW
 F  Q:(CODE]HIGH)!(CODE="")  D
 . K DATA
 . D PERIOD^ICDAPIU(CODE,.DATA)
 . S IEN=$P(DATA(0),U,1)
 . S SEL=$S($D(^PXD(811.2,D0,"SDX","B",IEN)):"X",1:"")
 . S ACTDATE=0
 . F  S ACTDATE=$O(DATA(ACTDATE)) Q:ACTDATE=""  D
 .. S INADATE=$P(DATA(ACTDATE),U,1)
 .. S TEXT=$P(DATA(ACTDATE),U,2)
 .. W !,?2,CODE,?10,TEXT,?42,$$FMTE^XLFDT(ACTDATE,"5Z"),?54,$$FMTE^XLFDT(INADATE,"5Z"),?71,SEL
 . S CODE=$$NEXT^ICDAPIU(CODE)
 Q
 ;
 ;=======================================================
ICPTLIST ;Print expanded list of CPT codes.
 N ACTDATE,CODE,DATA,IEN,INADATE,LOW,HIGH,SEL,TEMP,TEXT
 S TEMP=^PXD(811.2,D0,81,D1,0)
 S LOW=$P(TEMP,U,1)
 S HIGH=$P(TEMP,U,2)
 I HIGH="" S HIGH=LOW
 W !!,?2,"Code",?10,"CPT Short Name",?42,"Activation",?54,"Inactivation",?67,"Selectable"
 W !,?2,"----",?10,"--------------",?42,"----------",?54,"------------",?67,"----------"
 S CODE=LOW
 F  Q:(CODE]HIGH)!(CODE="")  D
 . K DATA
 . D PERIOD^ICPTAPIU(CODE,.DATA)
 . S IEN=$P(DATA(0),U,1)
 . S SEL=$S($D(^PXD(811.2,D0,"SPR","B",IEN)):"X",1:"")
 . S ACTDATE=0
 . F  S ACTDATE=$O(DATA(ACTDATE)) Q:ACTDATE=""  D
 .. S INADATE=$P(DATA(ACTDATE),U,1)
 .. S TEXT=$P(DATA(ACTDATE),U,2)
 .. W !,?2,CODE,?10,TEXT,?42,$$FMTE^XLFDT(ACTDATE,"5Z"),?54,$$FMTE^XLFDT(INADATE,"5Z"),?71,SEL
 . S CODE=$$NEXT^ICPTAPIU(CODE)
 Q
 ;
 ;=======================================================
TAXLIST ;Taxonomy list.
 N CODES,CPT,CPTLIST,IC,ICD0,ICD0LIST,ICD9,ICD9LIST,IND,NCODES
 S (IC,IND)=0
 F  S IND=+$O(^PXD(811.2,D0,80,IND)) Q:IND=0  D
 . S IC=IC+1
 . S CODES=^PXD(811.2,D0,80,IND,0)
 . S ICD9LIST(IC)=CODES
 S NCODES=IC
 ;
 S (IC,IND)=0
 F  S IND=+$O(^PXD(811.2,D0,80.1,IND)) Q:IND=0  D
 . S IC=IC+1
 . S CODES=^PXD(811.2,D0,80.1,IND,0)
 . S ICD0LIST(IC)=CODES
 S NCODES=$$MAX^XLFMTH(NCODES,IC)
 ;
 S (IC,IND)=0
 F  S IND=+$O(^PXD(811.2,D0,81,IND)) Q:IND=0  D
 . S IC=IC+1
 . S CODES=^PXD(811.2,D0,81,IND,0)
 . S CPTLIST(IC)=CODES
 S NCODES=$$MAX^XLFMTH(NCODES,IC)
 ;Print the list.
 F IC=1:1:NCODES D
 . S ICD9=$G(ICD9LIST(IC))
 . S ICD0=$G(ICD0LIST(IC))
 . S CPT=$G(CPTLIST(IC))
 . W !,?9,$P(ICD9,U,1),?19,$P(ICD9,U,2)
 . W ?29,$P(ICD0,U,1),?39,$P(ICD0,U,2)
 . W ?49,$P(CPT,U,1),?59,$P(CPT,U,2)
 Q
 ;
