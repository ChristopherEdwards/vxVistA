PPPPSL1 ; List Template Exporter ; 13-MAR-1995
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 W !,"'PPP UNRESOLVED DOM' List Template..."
 S DA=$O(^SD(409.61,"B","PPP UNRESOLVED DOM",0)),DIK="^SD(409.61," D ^DIK:DA
 K DO,DD S DIC(0)="L",DIC="^SD(409.61,",X="PPP UNRESOLVED DOM" D FILE^DICN S VALM=+Y
 I VALM>0 D
 .S ^SD(409.61,VALM,0)="PPP UNRESOLVED DOM^1^^^6^16^1^1^Domains^PPP (MENU) DOM^Edit Domain Entries^1"
 .S ^SD(409.61,VALM,1)="^VALM HIDDEN ACTIONS"
 .S ^SD(409.61,VALM,"ARRAY")=" ^TMP(""PPPL4"",$J)"
 .S ^SD(409.61,VALM,"COL",0)="^409.621^4^4"
 .S ^SD(409.61,VALM,"COL",1,0)="PATNAME^9^20^Patient Name"
 .S ^SD(409.61,VALM,"COL",2,0)="INSTITUTION^31^20^Institution"
 .S ^SD(409.61,VALM,"COL",3,0)="DOMAIN^52^27^Domain"
 .S ^SD(409.61,VALM,"COL",4,0)="ENTRY^1^6^ Entry"
 .S ^SD(409.61,VALM,"FNL")="D FNL^PPPEDT21"
 .S ^SD(409.61,VALM,"HDR")="D HDR^PPPEDT21"
 .S ^SD(409.61,VALM,"HLP")="S X=""?"" D DISP^XQORM1 W !!"
 .S ^SD(409.61,VALM,"INIT")="D INIT^PPPEDT21"
 .S DA=VALM,DIK="^SD(409.61," D IX1^DIK K DA,DIK
 .W "Filed."
 ;
 W !,"'PPP VISITS' List Template..."
 S DA=$O(^SD(409.61,"B","PPP VISITS",0)),DIK="^SD(409.61," D ^DIK:DA
 K DO,DD S DIC(0)="L",DIC="^SD(409.61,",X="PPP VISITS" D FILE^DICN S VALM=+Y
 I VALM>0 D
 .S ^SD(409.61,VALM,0)="PPP VISITS^1^^^6^16^1^1^Facilities^PPP (MENU) VISITS^Other Facilities Visited^1"
 .S ^SD(409.61,VALM,1)="^VALM HIDDEN ACTIONS"
 .S ^SD(409.61,VALM,"ARRAY")=" ^TMP(""PPPL3"",$J)"
 .S ^SD(409.61,VALM,"COL",0)="^409.621^6^4"
 .S ^SD(409.61,VALM,"COL",1,0)="PHDATA^60^20^Pharmacy Data"
 .S ^SD(409.61,VALM,"COL",2,0)="LASTPDX^21^12^Last PDX"
 .S ^SD(409.61,VALM,"COL",3,0)="STATUS^33^27^PDX Status"
 .S ^SD(409.61,VALM,"COL",6,0)="STATION^2^20^Station"
 .S ^SD(409.61,VALM,"FNL")="D FNL^PPPDSP4"
 .S ^SD(409.61,VALM,"HDR")="D HDR^PPPDSP4"
 .S ^SD(409.61,VALM,"HLP")="S X=""?"" D DISP^XQORM1 W !!"
 .S ^SD(409.61,VALM,"INIT")="D INIT^PPPDSP4"
 .S DA=VALM,DIK="^SD(409.61," D IX1^DIK K DA,DIK
 .W "Filed."
 ;
 W !,"'PPP XREF EDIT' List Template..."
 S DA=$O(^SD(409.61,"B","PPP XREF EDIT",0)),DIK="^SD(409.61," D ^DIK:DA
 K DO,DD S DIC(0)="L",DIC="^SD(409.61,",X="PPP XREF EDIT" D FILE^DICN S VALM=+Y
 I VALM>0 D
 .S ^SD(409.61,VALM,0)="PPP XREF EDIT^1^^^6^16^1^1^Entry^PPP (MENU) FF XREF^PPP V1.0 Add/Edit DATA^1"
 .S ^SD(409.61,VALM,1)="^VALM HIDDEN ACTIONS"
 .S ^SD(409.61,VALM,"ARRAY")=" ^TMP(""PPPL1"",$J)"
 .S ^SD(409.61,VALM,"COL",0)="^409.621^4^4"
 .S ^SD(409.61,VALM,"COL",1,0)="ENTRY^2^5^Entry"
 .S ^SD(409.61,VALM,"COL",2,0)="INST^8^25^Institution"
 .S ^SD(409.61,VALM,"COL",3,0)="DOMAIN^35^25^Domain"
 .S ^SD(409.61,VALM,"COL",4,0)="LDATE^61^15^Last Visit"
 .S ^SD(409.61,VALM,"EXP")="D EXPAND^PPPEDT13"
 .S ^SD(409.61,VALM,"FNL")="D FNL^PPPEDT12"
 .S ^SD(409.61,VALM,"HDR")="D HDR^PPPEDT12"
 .S ^SD(409.61,VALM,"HLP")="S X=""?"" D DISP^XQORM1 W !!"
 .S ^SD(409.61,VALM,"INIT")="D INIT^PPPEDT12"
 .S DA=VALM,DIK="^SD(409.61," D IX1^DIK K DA,DIK
 .W "Filed."
 ;
 K DIC,DIK,VALM,X,DA Q
