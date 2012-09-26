PRCAMRG ;SF-IRMFO/JLI,REM,TJK - ROUTINE TO MERGE ENTRIES IN AR DEBTOR FILE FOR PATIENT MERGE ;3/9/98  13:35
 ;;4.5;Accounts Receivable;**132**;Mar 20, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;;
 ;;
EN(ARRAY) ; Entry point called with NAME of array containing from, and to entries.
 ;
 N XARRAY,RCDIC,FROMX,TO,FROMX1,TO1,FROM,FRX,TOX
 S XARRAY=$NA(^TMP($J,"PRCAMRG"))
 K @XARRAY
 S FROM=XARRAY
 S RCDIC=$G(^DIC(340,0,"GL"))
 I RCDIC="" Q
 F FROMX=0:0 S FROMX=$O(@ARRAY@(FROMX)) Q:FROMX'>0  D
 . S TO=$O(@ARRAY@(FROMX,0))
 . S FROMX1=$O(@(RCDIC_"""B"",FROMX_"";DPT("",0)"))
 . S TO1=$O(@(RCDIC_"""B"",TO_"";DPT("",0)"))
 . I TO1="",FROMX1="" Q
 . S TO1=$S(TO1>0:TO1,1:0),FROMX1=$S(FROMX1>0:FROMX1,1:0)
 . S FRX=$O(@ARRAY@(FROMX,TO,"")),TOX=$O(@ARRAY@(FROMX,TO,FRX,""))
 . S @XARRAY@(FROMX1,TO1,FRX,TOX)="",^TMP($J,"RCPOINT",FROMX1,TO1)=""
 . I TO1=0 D  Q
 . . D SAVEMERG^XDRMERGB(340,FROMX1,TO1)
 . . K @XARRAY@(FROMX1,TO1)
 . . N RCDXXX
 . . S RCDXXX(340,(FROMX1_","),.01)=TO_";DPT("
 . . D UPDATE^DIE("","RCDXXX")
 I '$D(@XARRAY) Q
 D EN^XDRMERG(340,XARRAY)
REPNT D
    .S FROM=0
    .F  S FROM=$O(^TMP($J,"RCPOINT",FROM)) Q:'FROM  S TO=$O(^(FROM,0)) D
       ..S BILL=0
       ..F  S BILL=$O(^PRCA(430,"C",FROM,BILL)) Q:'BILL  S DIE="^PRCA(430,",DA=BILL,DR="9////"_TO D ^DIE
       ..Q
    .Q
 S RCDIC=$G(^DIC(340,0,"GL"))
 Q
