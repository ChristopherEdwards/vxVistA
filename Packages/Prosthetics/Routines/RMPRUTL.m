RMPRUTL ;HINES OI/AAC-UTILITY PROGRAM FOR PROSTHETICS ;05/05/2004
 ;;3.0;PROSTHETICS;**84**;MAY 5,2004
LKPHCPC ;
 ; Patch 84 HCPCS Update 2004 - AAC 04/16/04
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
KILLXRF ; KILL XREF E AND DD ENTRY
 ; Patch 84 HCPCS Update 2004 - AAC 05/28/04
 K ^RMPR(661.1,"E") S DA(1)=661.1
 S DIK="^DD(661.1,",DA=2 D ^DIK
 Q
 ;
 ;END
