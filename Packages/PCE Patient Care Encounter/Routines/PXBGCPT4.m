PXBGCPT4 ;ISL/JVS,ESW - DOUBLE ?? GATHERING OF FORM PROCEDURES ; 5/7/03 3:35pm
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**11,73,43,108,121**;Aug 12, 1996
 ;
 ;
 ;
 W !,"THIS IS NOT AN ENTRY POINT" Q
 ;  
 ;
DOUBLE1(FROM) ;--Entry point
 ;
NEW ;
 ;
 N FILE,FIELD,TITLE,HEADING,SUB,NAME,START,SCREEN,OK,INDEX,CYCLE
 N TOTAL,PRV,CNT,PXBPMT,CODE,SUB2,SUBM,MODSTR,CNUM,MNUM,CONT,QT,PXMDIEN
 ;---SETUP VARIABLES
 S BACK="",INDEX=""
 S START=DATA,(CONT,SUB,SUB2,SUBM)=0
 ;
START1 ;--RECYCLE POINT
 S TITLE="- - F O R M    P R O C E D U R E S - -"
 ;
 D GETLST^IBDF18A(CLINIC,$P($T(CPT^PXBAICS),";;",2),"PXBPMT",,,1,IDATE)
 ;
 S TOTAL=PXBPMT(0)
 I PXBPMT(0)>0 D
 .S (SUB,CNT)=""
 .F  S SUB=$O(PXBPMT(SUB)) Q:SUB=""  D
 ..S CODE=$P(PXBPMT(SUB),U)
 ..I '(CODE?5N!(CODE?1A4N)!(CODE?4N1A)) Q  ;PX*1.0*108
 ..;I $P($G(^ICPT($O(^ICPT("B",CODE,0)),0)),U,4) Q
 ..I '$P($$CPT^ICPTCOD(CODE,IDATE),U,7) Q
 ..S NAME=$P(PXBPMT(SUB),U,2)
 ..S CNT=CNT+1
 ..S ^TMP("PXBTOTAL",$J,"DILIST","ID",CNT,.01)=CODE
 ..S ^TMP("PXBTOTAL",$J,"DILIST","ID",CNT,2)=NAME
 ..S SUBM=0
 ..F  S SUBM=$O(PXBPMT(SUB,"MODIFIER",SUBM)) Q:SUBM=""  D
 ...S PXMDIEN=+$$MODP^ICPTMOD(CODE,PXBPMT(SUB,"MODIFIER",SUBM),"E",IDATE)
 ...S MODSTR=$$MOD^ICPTMOD(PXMDIEN,"I",IDATE)
 ...I +MODSTR>0,$P(MODSTR,U,7) D
 ....S ^TMP("PXBTOTAL",$J,"DILIST","ID",CNT,"MODIFIER",SUBM)=$P(MODSTR,U,2)_U_$P(MODSTR,U,3)
 I $D(CNT) S TOTAL=CNT
 ;
 ;--DISPLAY IF NO MATCH FOUND
 I TOTAL=0 W IOCUU,IOCUU,!,IOELEOL D
 .;D LOC,HEAD
 .D LOC W !
 .S RESULTS="NO PROCEDURE BLOCKS EXIST FOR AN ENCOUNTER FORM"
 .W !!!,?(IOM-$L(RESULTS))\2,RESULTS
 .D HELP1^PXBUTL1("CON")
 .R OK:DTIME
 I TOTAL=0 S TOTAL="^C" Q TOTAL
 ;
 ;
 ;----DISPLAY LIST TO THE SCREEN
 S HEADING="W !,""ITEM"",?6,""CODE"",?13,""DESCRIPTION   "",IOINHI,TOTAL,"" ENTRIES"",IOINLOW"
 ;
LIST ;-DISPLAY LIST TO THE SCREEN
 ;D LOC,HEAD
 D LOC W !
 X HEADING
 S SUB=$P(CONT,U)-1
 S (QT,CNUM,MNUM)=0
 F  S SUB=$O(^TMP("PXBTOTAL",$J,"DILIST","ID",SUB)) Q:SUB'>0  S SUB2=SUB2+1 D  Q:QT
 .S CNUM=CNUM+1
 .I CNUM+MNUM=11 S CONT=SUB_U_0,QT=1 Q
 .S CODE=$G(^TMP("PXBTOTAL",$J,"DILIST","ID",SUB,.01))
 .S NAME=$G(^TMP("PXBTOTAL",$J,"DILIST","ID",SUB,2))
 .W !,SUB,?6,CODE,?13,NAME
 .S SUBM=$P(CONT,U,2)-1
 .S:$P(CONT,U,2)>0 $P(CONT,U,2)=0
 .F  S SUBM=$O(^TMP("PXBTOTAL",$J,"DILIST","ID",SUB,"MODIFIER",SUBM)) Q:SUBM=""  D  Q:QT
 ..S MNUM=MNUM+1
 ..I MNUM+CNUM=11 S CONT=SUB_U_SUBM,QT=1 Q
 ..S MODSTR=^TMP("PXBTOTAL",$J,"DILIST","ID",SUB,"MODIFIER",SUBM)
 ..W !?6,"CPT Modifier:",?21,$P(MODSTR,U),?25,$P(MODSTR,U,2)
 ;
 ;----If There is only one selection go to proper prompting
 I TOTAL=1 G PRMPT2
 ;
PRMPT ;---WRITE PROMPT HERE
 D WIN17^PXBCC(PXBCNT)
 D LOC^PXBCC(15,1)
 W !
 I SUB>0 W !,"Enter '^' to quit"
 E  I TOTAL>10 W !,"               END OF LIST"
 I SUB>0 S DIR("A")="Select a single 'ITEM NUMBER' or 'RETURN' to continue: "
 E  S DIR("A")="Select a single 'ITEM NUMBER' or 'RETURN' to exit: "
 S DIR("?")="Enter ITEM 'No' to select , '^' to quit"
 S DIR(0)="N,A,O^0:"_SUB2_":0^I X'?.1""^"".N K X"
 D ^DIR
 I X="",SUB>0 G LIST
 I X="",SUB'>0 S X="^"
 I $G(DIRUT) K DIRUT S VAL="^C" G EXITNEW
VAL ;-----Set the VAL equal to the value
 S VAL=$G(^TMP("PXBTOTAL",$J,"DILIST","ID",X,2))_"^"_$G(^TMP("PXBTOTAL",$J,"DILIST","ID",X,.01))
 S (MODSTR,SUBM)=""
 F  S SUBM=$O(^TMP("PXBTOTAL",$J,"DILIST","ID",X,"MODIFIER",SUBM)) Q:SUBM=""  D
 .S MODSTR=MODSTR_$S(MODSTR]"":",",1:"")_$P(^TMP("PXBTOTAL",$J,"DILIST","ID",X,"MODIFIER",SUBM),U)
EXITNEW ;--EXIT
 K DIR,^TMP("PXBTANA",$J),^TMP("PXBTOTAL",$J)
 K TANA,TOTAL
 Q VAL_U_$G(MODSTR)
 ;
 ;-----------------SUBROUTINES--------------
BACK ;
 S START=$G(^TMP("PXBTANA",$J,"DILIST",1,1))
 S START("IEN")=$G(^TMP("PXBTANA",$J,"DILIST",2,1))
 Q
FORWARD ;
 S START=$G(^TMP("PXBTANA",$J,"DILIST",1,10))
 S START("IEN")=$G(^TMP("PXBTANA",$J,"DILIST",2,10))
 Q
LOC ;--LOCATE CURSOR
 D LOC^PXBCC(3,1) ;--LOCATE THE CURSOR
 W IOEDEOP ;--CLEAR THE PAGE
 Q
HEAD ;--HEAD
 W !,IOCUU,IOBON,"HELP SCREEN",IOSGR0
 W ?(IOM-$L(TITLE))\2,IOINHI,TITLE,IOINLOW,IOELEOL
 Q
SUB ;--DISPLAY LIST TO THE SCREEN
 I $P(^TMP("PXBTANA",$J,"DILIST",0),"^",1)=0 W !!,"     E N D  O F  L I S T" Q
 X HEADING
 S SUB=0,CNT=0
 F  S SUB=$O(^TMP("PXBTANA",$J,"DILIST","ID",SUB)) Q:SUB'>0  S CNT=CNT+1 D
 .S NAME=$G(^TMP("PXBTANA",$J,"DILIST","ID",SUB,.01))
 .W !,SUB,?6,NAME
 Q
SETUP ;-SETP VARIABLES
 S FILE=200,FIELD=.01
 S HEADING="W !,""ITEM"",?6,""NAME"""
 Q
PRMPT2 ;-----Yes and No prompt if only one choice
 D WIN17^PXBCC(PXBCNT)
 D LOC^PXBCC(15,1)
 S DIR("A")="Is this the correct entry "
 S DIR("B")="YES"
 S DIR(0)="Y"
 D ^DIR
 I Y=0 S X="^"
 I Y=1 S X=1
 G VAL
 ;
