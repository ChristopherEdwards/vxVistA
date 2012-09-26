PSSPO129 ;BIR/RTR-POST INIT FOR PATCH PSS*1*129 ;06/14/07
 ;;1.0;PHARMACY DATA MANAGEMENT;**129**;9/30/97;Build 67
 ;
 N PSSFACC,PSSFACCX
 K PSSFACC,PSSFACCX
 S PSSFACC("RD")="Pp" D FILESEC^DDMOD(51.23,.PSSFACC,"PSSFACCX") K PSSFACC,PSSFACCX
 S PSSFACC("RD")="Pp" D FILESEC^DDMOD(51.24,.PSSFACC,"PSSFACCX") K PSSFACC,PSSFACCX
 I $T(GETIEN^HDISVF09)]"",$T(EN^HDISVCMR)]"" D BMES^XPDUTL("Initializing standardization of Standard Medication Routes....") D ST D BMES^XPDUTL("Standardization Initialization complete.")
 D BMES^XPDUTL("Rebuilding Pharmacy Data Managent Menus....") D BLD D BMES^XPDUTL("Rebuilding menus complete.")
 D BMES^XPDUTL("Importing Dosage Form File Data....") D DS D BMES^XPDUTL("Importing data complete.")
 D BMES^XPDUTL("Mapping Local Medication Routes....") D MEDRT D BMES^XPDUTL("Mapping Medication Routes complete.")
 D BMES^XPDUTL("Mapping Local Possible Dosages....") D EN^PSSDSPOP D BMES^XPDUTL("Mapping Local Possible Dosages complete.")
 D BMES^XPDUTL("Generating Mail Message....") D MAIL D BMES^XPDUTL("Mail message sent.")
 Q
 ;
 ;
MAIL ;Find IV Solutions with Print Name 2 and Use in IV Fluid Order Entrt, and send mail message
 ;N PSSFVNMX,PSSFVNMZ,PSSFDFLG,PSSFDPRI,PSSFDUSE,PSSFDS,PSSFDCNT,PSSFDSOL,PSSFDNAM,XMTEXT,XMY,XMSUB,XMDUZ,XMMG,XMSTRIP,XMROU,XMDUN,XMYBLOB,XMZ
 N PSSFDS,XMTEXT,XMY,XMSUB,XMDUZ,XMMG,XMSTRIP,XMROU,XMYBLOB,XMZ
 K ^TMP($J,"PSSFDSXX")
 ;S ^TMP($J,"PSSFDSXX",1,0)="The following entries in the IV SOLUTIONS (#52.7) File have"
 ;S ^TMP($J,"PSSFDSXX",2,0)="data in the PRINT NAME {2} (#.02) Field and also have the USED"
 ;S ^TMP($J,"PSSFDSXX",3,0)="IN IV FLUID ORDER ENTRY (#17) Field set to 'YES'. This can"
 ;S ^TMP($J,"PSSFDSXX",4,0)="potentially cause confusion, please review and correct."
 ;S ^TMP($J,"PSSFDSXX",5,0)=" "
 ;S PSSFDCNT=6
 ;S PSSFDFLG=0
 ;S PSSFDNAM="" F  S PSSFDNAM=$O(^PS(52.7,"B",PSSFDNAM)) Q:PSSFDNAM=""  F PSSFDSOL=0:0 S PSSFDSOL=$O(^PS(52.7,"B",PSSFDNAM,PSSFDSOL)) Q:'PSSFDSOL  D
 ;.S PSSFDPRI=$P($G(^PS(52.7,PSSFDSOL,0)),"^",4),PSSFDUSE=$P($G(^PS(52.7,PSSFDSOL,0)),"^",13)
 ;.I PSSFDPRI'="",$G(PSSFDUSE) D
 ;..S PSSFDFLG=1
 ;..S PSSFVNMX=$L($P($G(^PS(52.7,PSSFDSOL,0)),"^")) K PSSFVNMZ S $P(PSSFVNMZ," ",(34-PSSFVNMX))=""
 ;..S ^TMP($J,"PSSFDSXX",PSSFDCNT,0)=$P($G(^PS(52.7,PSSFDSOL,0)),"^")_PSSFVNMZ_"Volume: "_$P($G(^PS(52.7,PSSFDSOL,0)),"^",3)
 ;..S PSSFDCNT=PSSFDCNT+1
 ;I 'PSSFDFLG S ^TMP($J,"PSSFDSXX",PSSFDCNT,0)="No IV Solutions found."
 ;S PSSFDCNT=PSSFDCNT+1
 ;S ^TMP($J,"PSSFDSXX",PSSFDCNT,0)=" "
 ;S PSSFDCNT=PSSFDCNT+1
 ;S ^TMP($J,"PSSFDSXX",PSSFDCNT,0)="The Installation of patch PSS*1.0*129 is complete."
 S ^TMP($J,"PSSFDSXX",1,0)="The Installation of patch PSS*1.0*129 is complete."
 S XMSUB="PSS*1*129 Installation Complete"
 S XMDUZ="PSS*1*129 Install"
 S XMTEXT="^TMP($J,""PSSFDSXX"","
 F PSSFDS=0:0 S PSSFDS=$O(@XPDGREF@("PSSVJARX",PSSFDS)) Q:'PSSFDS  S XMY(PSSFDS)=""
 N DIFROM D ^XMD
 K ^TMP($J,"PSSFDSXX")
 Q
 ;
 ;
ST ;Seed VUID data In Standard Medication Routes File (#51.23)
 N PSSDOM,PSSDOMX
 S PSSDOMX=$$GETIEN^HDISVF09("PHARMACY DATA MANAGEMENT",.PSSDOM)
 I PSSDOMX D EN^HDISVCMR(PSSDOM,51.23)
 Q
 ;
 ;
BLD ;Remove menu items from PSS MGR that were placed under other sub-menus
 N PSSREMOV,PSSREMRS
 F PSSREMOV="PSS MEDICATION ROUTES EDIT","PSS ORDERABLE ITEM REPORT","PSS EDIT TEXT","PSS DRUG TEXT FILE REPORT","PSS SCHEDULE EDIT","PSSJU MI" D
 .S PSSREMRS=$$DELETE^XPDMENU("PSS MGR",PSSREMOV)
 Q
 ;
 ;
DS ;Import Exclude From Dosage Checks field in Dosage Form File
 N PSSFDD,PSSFDX
 F PSSFDD=0:0 S PSSFDD=$O(@XPDGREF@("PSSVJDD",PSSFDD)) Q:'PSSFDD  S $P(^PS(50.606,PSSFDD,1),"^")=@XPDGREF@("PSSVJDD",PSSFDD)
 Q
 ;
 ;
MEDRT ;Populate FirstDataBank Med Route in File 51.2
 ;Will XTID screen work, right after the HD calls. (are the HD calls real-time?)
 N PSSRTIEN,PSSRTNAM,PSSRTSTS,PSSRTIX
 S PSSRTIX="" F  S PSSRTIX=$O(^PS(51.2,"B",PSSRTIX)) Q:PSSRTIX=""  D
 .F PSSRTIEN=0:0 S PSSRTIEN=$O(^PS(51.2,"B",PSSRTIX,PSSRTIEN)) Q:'PSSRTIEN  D
 ..I '$D(^PS(51.2,PSSRTIEN,0)) Q
 ..I '$P($G(^PS(51.2,PSSRTIEN,0)),"^",4) Q
 ..I $P($G(^PS(51.2,PSSRTIEN,1)),"^") Q
 ..L +^PS(51.2,PSSRTIEN):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I '$T Q
 ..K PSSRTNAM,PSSRTSTS
 ..S PSSRTNAM=$P($G(^PS(51.2,PSSRTIEN,0)),"^") S PSSRTNAM=$$UP^XLFSTR(PSSRTNAM)
 ..S PSSRTSTS=$O(^PS(51.23,"B",PSSRTNAM,0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
 ..K PSSRTSTS S PSSRTSTS=$O(^PS(51.23,"C",PSSRTNAM,0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
 ..K PSSRTSTS I PSSRTNAM[" EAR" S PSSRTSTS=$O(^PS(51.23,"B","OTIC",0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
 ..K PSSRTSTS I PSSRTNAM[" EYE" S PSSRTSTS=$O(^PS(51.23,"B","OPHTHALMIC",0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
 ..K PSSRTSTS I PSSRTNAM="G TUBE"!(PSSRTNAM="G-TUBE")!(PSSRTNAM="J TUBE")!(PSSRTNAM="J-TUBE")!(PSSRTNAM="NG TUBE")!(PSSRTNAM="NG-TUBE")!(PSSRTNAM="BY MOUTH") D  I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
 ...S PSSRTSTS=$O(^PS(51.23,"B","ORAL",0))
 ..K PSSRTSTS I PSSRTNAM["NOSE"!(PSSRTNAM["NASAL")!(PSSRTNAM["NOSTRIL") S PSSRTSTS=$O(^PS(51.23,"B","NASAL",0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
 ..K PSSRTSTS I PSSRTNAM="IVPB"!(PSSRTNAM="IV PUSH")!(PSSRTNAM="IV PIGGYBACK") S PSSRTSTS=$O(^PS(51.23,"B","INTRAVENOUS",0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
 ..D UN
 Q
 ;
 ;
UN ;Unlock Med Route
 L -^PS(51.2,PSSRTIEN)
 Q
 ;
 ;
SET ;Set Data, leaving USER as null, so the installer is not recorded as the user
 N %,PSSHASHP,X,%H,%I
 K PSSHASHP
 S $P(^PS(51.2,PSSRTIEN,1),"^")=PSSRTSTS
 D NOW^%DTC S PSSHASHP(51.27,"+1,"_PSSRTIEN_",",.01)=%
 S PSSHASHP(51.27,"+1,"_PSSRTIEN_",",1)=""
 S PSSHASHP(51.27,"+1,"_PSSRTIEN_",",2)=""
 S PSSHASHP(51.27,"+1,"_PSSRTIEN_",",3)=PSSRTSTS
 D UPDATE^DIE("","PSSHASHP")
 Q
