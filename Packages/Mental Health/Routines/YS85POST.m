YS85POST ;ALB/ASF-YS 501 PATCH 85 POST ; 7/27/07 2:11pm
 ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 48
 ; LOADS AND INDEXES DD'S
 ;
 K DIF,DIK,D,DDF,DDT,DTO,D0,DLAYGO,DIC,DIDUZ,DIR,DA,DFR,DTN,DIX,DZ D DT^DICRW S %=1,U="^",DSEC=1
 D DT^DICRW K ^UTILITY(U,$J),^UTILITY("DIK",$J)
 S DIFQ(601.751)=1,DIFQR(601.751)=1,NO=""
 S DN="^YTQQI" F R=1:1:20 D @(DN_$$B36(R)) W "."
 S YSIEN=0 F  S YSIEN=$O(^UTILITY(U,$J,601.751,YSIEN)) Q:YSIEN'>0  S ^YTT(601.751,YSIEN,0)=^UTILITY(U,$J,601.751,YSIEN,0)
 S DIK="^YTT(601.751," D IXALL^DIK
 S YSN=$O(^YTT(601,"B","DOM80",0))
 S ^YTT(601,YSN,"S",0)="^601.01AI^1^1"
 S ^YTT(601,YSN,"S",1,0)="1^Total"
 S ^YTT(601,YSN,"S","B",1,1)=""
 S ^YTT(601,YSN,"S","C","Total",1)=""
 K YSN
HL7 S DIC=771,X="YS MHA",DIC(0)="M" D ^DIC Q:Y'>0
 S DA=+Y,DIE=771,DR="3///"_$$KSP^XUPARAM("INST") D ^DIE
 Q
B36(X) Q $$N(X\(36*36)#36+1)_$$N(X\36#36+1)_$$N(X#36+1)
N(%) Q $E("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",%)
