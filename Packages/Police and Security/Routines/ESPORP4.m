ESPORP4 ;DALISC/CKA - PRINT OFFENSE REPORT CONT. ;10/92
 ;;1.0;POLICE & SECURITY;**14,17**;Mar 31, 1994
EN ;CONTINUED FROME ESPORP3
HELD ;PRINT PROPERTY HELD
 G:END EXIT
 G:'$D(^ESP(912,ESPID,100)) CIP
 F ESPN=0:0 S ESPN=$O(^ESP(912,ESPID,100,ESPN)) Q:ESPN'>0  D  G:END EXIT
 .  D MIN^ESPORP(5) Q:END
 .  S DIC="^ESP(912,"_ESPID_",100,",DA=ESPN,DR=".01:.03",DIQ(0)="E" D EN^DIQ1 Q:'$D(^UTILITY("DIQ1",$J,912.02,DA))
 .  D LINES^ESPORP(2) Q:END  F I=1:1:16 W "* "
 .  W "PROPERTY HELD" F I=1:1:17 W " *"
 .  D LINES^ESPORP(2) Q:END  W "ITEM #: ",$G(^UTILITY("DIQ1",$J,912.02,DA,.01,"E"))
 .  D LINES^ESPORP(1) Q:END  W "QUANTITY: ",$G(^UTILITY("DIQ1",$J,912.02,DA,.02,"E"))
 .  D LINES^ESPORP(1) Q:END  W "PURPOSE: ",$G(^UTILITY("DIQ1",$J,912.02,DA,.03,"E"))
 .  K ^UTILITY($J,"W") S DIWL=10,DIWR=70,DIWF="W"
 .  D LINES^ESPORP() Q:END  W "DESCRIPTION:" D LINES^ESPORP() Q:END
 .  F ESPN1=0:0 S ESPN1=$O(^ESP(912,ESPID,100,ESPN,10,ESPN1)) Q:ESPN1'>0  S X=^(ESPN1,0) D  Q:END
 .  .  D MIN^ESPORP(2) Q:END
 .  .  D ^DIWP
 .  Q:END
 .  D ^DIWW
 .  D LINES^ESPORP() Q:END
CIP ;PRINT CIP WEAPON AND BATON USED
 D MIN^ESPORP(4) G:END EXIT
 D LINES^ESPORP(2) Q:END
 S DIC="^ESP(912,",DA=ESPID,DR="1.01:1.02",DIQ(0)="E" D EN^DIQ1
 D LINES^ESPORP() Q:END  W "WAS CIP WEAPON USED? ",$G(^UTILITY("DIQ1",$J,912,DA,1.01,"E"))
 D LINES^ESPORP() Q:END  W "WAS POLICE BATON USED? ",$G(^UTILITY("DIQ1",$J,912,DA,1.02,"E"))
OTH ;PRINT OTHER AGENCY DATA
 D MIN^ESPORP(10) G:END EXIT
 D LINES^ESPORP(2) Q:END  W "OTHER AGENCY NOTIFIED" D LINES^ESPORP() Q:END
 G:'$D(^ESP(912,ESPID,110)) ATTY
 F ESPN=0:0 S ESPN=$O(^ESP(912,ESPID,110,ESPN))  Q:ESPN'>0  D  G:END EXIT
 .  D MIN^ESPORP(5) Q:END
 .  S DIC="^ESP(912,"_ESPID_",110,",DA=ESPN,DR=".01;.02;.03",DIQ(0)="E" D EN^DIQ1 Q:'$D(^UTILITY("DIQ1",$J,912.14,DA,.01,"E"))
 .  D LINES^ESPORP() Q:END  W "DATE/TIME NOTIFIED: ",$G(^UTILITY("DIQ1",$J,912.14,DA,.01,"E"))
 .  D LINES^ESPORP() Q:END  W "CONTACT PERSON: ",$G(^UTILITY("DIQ1",$J,912.14,DA,.02,"E"))
 .  D LINES^ESPORP() Q:END  W "AGENCY: ",$G(^UTILITY("DIQ1",$J,912.14,DA,.03,"E"))
ATTY ;PRINT U.S. ATTY DATA
 D MIN^ESPORP(10) G:END EXIT
 D LINES^ESPORP(2) Q:END  W "U.S. ATTORNEY NOTIFIED" D LINES^ESPORP() Q:END
 G:'$D(^ESP(912,ESPID,120)) CONT
 F ESPN=0:0 S ESPN=$O(^ESP(912,ESPID,120,ESPN))  Q:ESPN'>0  D  G:END EXIT
 .  D MIN^ESPORP(5) Q:END
 .  S DIC="^ESP(912,"_ESPID_",120,",DA=ESPN,DR=".01",DIQ(0)="E" D EN^DIQ1 Q:'$D(^UTILITY("DIQ1",$J,912.15,DA,.01,"E"))
 .  D LINES^ESPORP() Q:END  W "DATE/TIME NOTIFIED: ",$G(^UTILITY("DIQ1",$J,912.15,DA,.01,"E"))
 .  D LINES^ESPORP() Q:END  W "INSTRUCTIONS RECEIVED:" D LINES^ESPORP(2) Q:END
 .  K ^UTILITY($J,"W") S DIWL=3,DIWR=78,DIWF="W",IEN=0
 .  F ESPN1=1:1 S IEN=$O(^ESP(912,ESPID,120,DA,10,IEN)) Q:IEN'>0  S X=^(IEN,0) D  Q:END
 .  .  D MIN^ESPORP(2) Q:END
 .  .  D ^DIWP
 .  D ^DIWW
CONT G ^ESPORP5
EXIT D ^%ZISC
 K CL,DA,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,ESPDOB,ESPDOBP,DR,DTOUT,DUOUT,END,ESPDTR,ESPID,ESPFN,ESPN,ESPN1,ESPOFF,IEN,PAGE,SSN,X,Y
 K ^UTILITY("DIQ1",$J)
 QUIT
