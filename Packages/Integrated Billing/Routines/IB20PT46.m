IB20PT46 ;ALB/CPM - List Template Exporter ; 21-MAR-1994
 ;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
 W !,"'IBDF VIEW TOOL KIT BLOCK' List Template..."
 S DA=$O(^SD(409.61,"B","IBDF VIEW TOOL KIT BLOCK",0)),DIK="^SD(409.61," D ^DIK:DA
 K DO,DD S DIC(0)="L",DIC="^SD(409.61,",X="IBDF VIEW TOOL KIT BLOCK" D FILE^DICN S VALM=+Y
 I VALM>0 D
 .S ^SD(409.61,VALM,0)="IBDF VIEW TOOL KIT BLOCK^2^^200^5^20^1^1^TOOL KIT BLOCK^^VIEW TOOL KIT BLOCK^1"
 .S ^SD(409.61,VALM,1)="^VALM HIDDEN ACTIONS"
 .S ^SD(409.61,VALM,"ARRAY")=" ^TMP(""IB"",$J,""TOOL KIT BLOCK"")"
 .S ^SD(409.61,VALM,"COL",0)="^409.621^3^3"
 .S ^SD(409.61,VALM,"COL",1,0)="ROW^1^3^^^1"
 .S ^SD(409.61,VALM,"COL",2,0)="BLOCK LEFT SIDE^5^80^123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789"
 .S ^SD(409.61,VALM,"COL",3,0)="BLOCK RIGHT SIDE^85^80^123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789"
 .S ^SD(409.61,VALM,"COL","AIDENT",1,1)=""
 .S ^SD(409.61,VALM,"FNL")="D EXIT^IBDF8"
 .S ^SD(409.61,VALM,"HDR")="D HDR^IBDF8"
 .S ^SD(409.61,VALM,"HLP")="W """""
 .S ^SD(409.61,VALM,"INIT")="D INIT^IBDF8"
 .S DA=VALM,DIK="^SD(409.61," D IX1^DIK K DA,DIK
 .W "Filed."
 ;
 W !,"'IBT APPEAL/DENIAL EDITOR' List Template..."
 S DA=$O(^SD(409.61,"B","IBT APPEAL/DENIAL EDITOR",0)),DIK="^SD(409.61," D ^DIK:DA
 K DO,DD S DIC(0)="L",DIC="^SD(409.61,",X="IBT APPEAL/DENIAL EDITOR" D FILE^DICN S VALM=+Y
 I VALM>0 D
 .S ^SD(409.61,VALM,0)="IBT APPEAL/DENIAL EDITOR^1^^180^5^17^1^1^Appeal/Denial^IBTRD  MENU^Appeal and Denial Tracking^1^^1"
 .S ^SD(409.61,VALM,1)="^VALM HIDDEN ACTIONS"
 .S ^SD(409.61,VALM,"ARRAY")=" ^TMP(""IBTRD"",$J)"
 .S ^SD(409.61,VALM,"COL",0)="^409.621^13^13"
 .S ^SD(409.61,VALM,"COL",1,0)="NUMBER^1^4"
 .S ^SD(409.61,VALM,"COL",2,0)="INS CO^5^15^Ins. Co."
 .S ^SD(409.61,VALM,"COL",3,0)="POLICY^22^10^Group^^1"
 .S ^SD(409.61,VALM,"COL",4,0)="DATE^35^8^Date"
 .S ^SD(409.61,VALM,"COL",5,0)="ACTION^45^11^Action"
 .S ^SD(409.61,VALM,"COL",6,0)="EVENT^56^8^Visit"
 .S ^SD(409.61,VALM,"COL",7,0)="EV DATE^65^15^Visit Date"
 .S ^SD(409.61,VALM,"COL",8,0)="ROI^81^10^ROI"
 .S ^SD(409.61,VALM,"COL",9,0)="DAYS^92^5^Days"
 .S ^SD(409.61,VALM,"COL",10,0)="CONTACT^98^17^Contact"
 .S ^SD(409.61,VALM,"COL",11,0)="PHONE^116^15^Phone"
 .S ^SD(409.61,VALM,"COL",12,0)="REF NO^132^15^Reference No"
 .S ^SD(409.61,VALM,"COL",13,0)="TYPE^149^20^Type"
 .S ^SD(409.61,VALM,"COL","AIDENT",1,3)=""
 .S ^SD(409.61,VALM,"FNL")="D EXIT^IBTRD"
 .S ^SD(409.61,VALM,"HDR")="D HDR^IBTRD"
 .S ^SD(409.61,VALM,"HLP")="D HELP^IBTRD"
 .S ^SD(409.61,VALM,"INIT")="D INIT^IBTRD"
 .S DA=VALM,DIK="^SD(409.61," D IX1^DIK K DA,DIK
 .W "Filed."
 ;
 W !,"'IBT APPEAL/DENIAL INS EDITOR' List Template..."
 S DA=$O(^SD(409.61,"B","IBT APPEAL/DENIAL INS EDITOR",0)),DIK="^SD(409.61," D ^DIK:DA
 K DO,DD S DIC(0)="L",DIC="^SD(409.61,",X="IBT APPEAL/DENIAL INS EDITOR" D FILE^DICN S VALM=+Y
 I VALM>0 D
 .S ^SD(409.61,VALM,0)="IBT APPEAL/DENIAL INS EDITOR^1^^180^5^17^1^1^Appeal/Denial^IBTRD  MENU^Appeal and Denial Tracking^1^^1"
 .S ^SD(409.61,VALM,1)="^VALM HIDDEN ACTIONS"
 .S ^SD(409.61,VALM,"ARRAY")=" ^TMP(""IBTRD"",$J)"
 .S ^SD(409.61,VALM,"COL",0)="^409.621^14^13"
 .S ^SD(409.61,VALM,"COL",1,0)="NUMBER^1^4"
 .S ^SD(409.61,VALM,"COL",2,0)="PATIENT^5^15^Patient"
 .S ^SD(409.61,VALM,"COL",3,0)="ID^25^5^Pt ID^^1"
 .S ^SD(409.61,VALM,"COL",5,0)="DATE^35^8^Date"
 .S ^SD(409.61,VALM,"COL",6,0)="ACTION^45^11^Action"
 .S ^SD(409.61,VALM,"COL",7,0)="EVENT^56^8^Visit"
 .S ^SD(409.61,VALM,"COL",8,0)="EV DATE^65^15^Visit Date"
 .S ^SD(409.61,VALM,"COL",9,0)="ROI^81^10^ROI"
 .S ^SD(409.61,VALM,"COL",10,0)="DAYS^92^5^Days"
 .S ^SD(409.61,VALM,"COL",11,0)="CONTACT^98^17^Contact"
 .S ^SD(409.61,VALM,"COL",12,0)="PHONE^116^15^Phone"
 .S ^SD(409.61,VALM,"COL",13,0)="REF NO^132^15^Reference No"
 .S ^SD(409.61,VALM,"COL",14,0)="TYPE^149^20^Type"
 .S ^SD(409.61,VALM,"COL","AIDENT",1,3)=""
 .S ^SD(409.61,VALM,"FNL")="D EXIT^IBTRD"
 .S ^SD(409.61,VALM,"HDR")="D HDR^IBTRD"
 .S ^SD(409.61,VALM,"HLP")="D HELP^IBTRD"
 .S ^SD(409.61,VALM,"INIT")="D INIT^IBTRD"
 .S DA=VALM,DIK="^SD(409.61," D IX1^DIK K DA,DIK
 .W "Filed."
 ;
 G ^IB20PT47