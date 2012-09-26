VFDXTPT ;DSS/LM - Pointer Tools ; 8/14/2008
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;This routine extends Paul's ^VFDPTBAK routine
 Q
LMA ;[Public]
 ;
 W !,"This option classifies actual pointers-in to a file."
 W !,"It produces a cross-listing of entries in the original file,"
 W !,"and entries or sub-entries that point to the given entries.",!
 I '($T(XALL^SISFIND)]"") D  Q
 .W !!,"This procedure requires routine ^SISFIND, tag XALL (not found)."
 .Q
 N DIC,X,Y S DIC=1,DIC(0)="AEQMZ" D ^DIC Q:Y<0
 N VFDA,VFDFILE,VFDXFILE,VFDFGL,VFDPFIL,VFDPFLD,VFDPSUM,VFDG,VFDS,VFDP,VFDP4
 N VFDX,VFDFLST,VFDIGLST,VFDNCHK
 N VFDRSLT S VFDRSLT=$NA(^TMP("VFDXTPT","LMA",$J)) K @VFDRSLT
 S VFDFILE=+Y,VFDXFILE=$P(Y,U,2),VFDFGL=$$ROOT^DILFD(VFDFILE,,1)
 D IGNORE($NA(VFDIGLST)) ;Construct 'ignore' list
 ;
 N %ZIS,POP
 S %ZIS="Q",%ZIS("A")="(queuing recommended) Select DEVICE: ",%ZIS("B")=""
 D ^%ZIS Q:POP
 I $G(IO("Q")) N ZTDESC,ZTRTN,ZTSAVE,ZTSK D  Q  ;If queued
 .S ZTDESC="VFD Pointers Analysis",ZTSAVE("VFD*")="",ZTRTN="DQ^VFDXTPT"
 .D ^%ZTLOAD K IO("Q") D HOME^%ZIS
 .Q
 ;
 ; Fall through to DQ, if not queued
 D WAIT^DICD W !
 ;
DQ ;[Private] From LMA
 U IO S VFDA=0
 F  S VFDA=$O(@VFDFGL@(VFDA)) Q:'VFDA  D LMA1(VFDFILE,VFDA) ;Classify one entry
 ; Classification complete
 D LMADSP(VFDRSLT)
 Q
IGNORE(LIST) ;[Private] Populate list of files or subfiles to ignore
 ; LIST=[Required] $NAME of return list
 ; 
 S:'$L($G(LIST)) LIST=$NA(VFDLIST) ;Default
 N DIR,Y S DIR("A")="DD#",DIR(0)="NO^::9"
 W !!,"Ignore the following files or sub-files that point to "_$P(VFDFILE,U,2)_": "
 W !,"Enter file or subfile number, or press <ENTER> to quit.",!
 F  D ^DIR Q:$D(DIRUT)  S:Y>0 @LIST@(Y)=""
 W !
 Q
LMA1(VFDFILE,VFDA) ;[Public] - Process one entry in target file
 ; Normally called by LMA, however, can be invoked independently
 ; 
 ; VFDFILE=[Required] Target file number (pointed-to file)
 ; VFDA=[Required] Entry (IEN) in file VFDFILE
 ;
 I '($T(XALL^SISFIND)]"") D  Q
 .W !!,"This procedure requires routine ^SISFIND, tag XALL (not found)."
 .Q
 I $G(VFDFILE),$G(VFDA) S (VFDPFIL,VFDPSUM)=0
 E  Q
 I '$L($G(VFDRSLT)) S VFDRSLT=$NA(^TMP("VFDXTPT","LMA1",$J)) ;Do not kill
 F  S VFDPFIL=$O(^DD(VFDFILE,0,"PT",VFDPFIL)) Q:'VFDPFIL  D
 .Q:$D(VFDIGLST(VFDPFIL))  ;Ignore
 .S VFDPFLD=0 F  S VFDPFLD=$O(^DD(VFDFILE,0,"PT",VFDPFIL,VFDPFLD)) Q:'VFDPFLD  D LMA1P
 .W:'$D(ZTQUEUED)&'$G(VFDNODOT) "."
 .Q
 Q
LMA1P ;[Private] Called by LMA1 - Process one pointer
 ;
 S VFDP4=$P($G(^DD(VFDPFIL,VFDPFLD,0)),U,4)
 S VFDS=$P(VFDP4,";"),VFDP=$P(VFDP4,";",2) Q:'$L(VFDS)!'VFDP
 N VFDCMD
 S VFDCMD="S:$P($G(^(SIS(SISN),VFDS)),U,VFDP)=VFDA @VFDRSLT@(VFDFILE,VFDA,VFDPFIL,VFDPFLD,$$CIENS^SISFIND(SISIENS))="""""
 D XALL^SISFIND(,VFDPFIL,.VFDCMD)
 Q
LMADSP(VFDRSLT) ;[Private] Display results - Called by LMA
 ; VFDRSLT=[Required] $NAME of results array to be displayed
 ; 
 N VFDA,VFDFILE,VFDIENS,VFDPFIL,VFDPFLD,VFDX
 S VFDFILE=0 F  S VFDFILE=$O(@VFDRSLT@(VFDFILE)) Q:'VFDFILE  D
 .W !!,"File# "_VFDFILE_"  "_$P($G(^DIC(VFDFILE,0)),U)
 .W !,$TR($J("",$G(IOM,80))," ","-")
 .S VFDA=0 F  S VFDA=$O(@VFDRSLT@(VFDFILE,VFDA)) Q:'VFDA  D
 ..W !?8,"Entry# "_VFDA_"  "_$$GET1^DIQ(VFDFILE,VFDA,.01),!
 ..S VFDPFIL=0 F  S VFDPFIL=$O(@VFDRSLT@(VFDFILE,VFDA,VFDPFIL)) Q:'VFDPFIL  D
 ...W !?12,"Pointed-to from DD# "_VFDPFIL_"  "_$$DDNAME(VFDPFIL)
 ...S VFDPFLD=0 F  S VFDPFLD=$O(@VFDRSLT@(VFDFILE,VFDA,VFDPFIL,VFDPFLD)) Q:'VFDPFLD  D
 ....W !?16,"Field# "_VFDPFLD_"  "_$P($G(^DD(VFDPFIL,VFDPFLD,0)),U)
 ....S VFDIENS=0 F  S VFDIENS=$O(@VFDRSLT@(VFDFILE,VFDA,VFDPFIL,VFDPFLD,VFDIENS)) Q:VFDIENS=""  D
 .....W !?20,"IENS="""_VFDIENS_""""
 .....Q
 ...Q
 ..W !,$TR($J("",$G(IOM,80))," ","-")
 ..Q
 .Q
 Q
DDNAME(VFDD) ;[Public] Name of File or Field
 ; VFDD=[Required] File or Field#
 ; 
 Q:'$G(VFDD) ""
 I $G(^DIC(VFDD,0))]"" Q $P(^DIC(VFDD,0),U)
 I $G(^DD(VFDD,0))]"" Q $P(^DD(VFDD,0),U)
 Q ""
LMB ;[Public]
 ;
 W !,"This option classifies actual pointers-in to a selected file entry."
 W !,"It produces a listing of entries or sub-entries that point to the given entry.",!
 I '($T(XALL^SISFIND)]"") D  Q
 .W !!,"This procedure requires routine ^SISFIND, tag XALL (not found)."
 .Q
 ; Select File
 N DIC,X,Y S DIC=1,DIC(0)="AEQMZ" D ^DIC Q:Y<0
 N VFDA,VFDFILE,VFDXFILE,VFDFGL,VFDPFIL,VFDPFLD,VFDPSUM,VFDG,VFDS,VFDP,VFDP4
 N VFDX,VFDFLST,VFDNCHK
 N VFDRSLT S VFDRSLT=$NA(^TMP("VFDXTPT","LMA",$J)) K @VFDRSLT
 S VFDFILE=+Y,VFDXFILE=$P(Y,U,2),VFDFGL=$$ROOT^DILFD(VFDFILE,,1)
 ; Select Entry
 S DIC=VFDFILE,DIC(0)="AEQMZ" D ^DIC Q:Y<0
 W ! D WAIT^DICD W !!
 D LMA1(VFDFILE,+Y) ;Process the selected entry
 D LMADSP(VFDRSLT)
 Q
LMC ;[Public]
 ; Output in ^TMP("VFDXTPT","LMC",$J,"UNREFERENCED)
 ; 
 W !,"This option identifies file entries that have NO pointers in."
 I '($T(XALL^SISFIND)]"") D  Q
 .W !!,"This procedure requires routine ^SISFIND, tag XALL (not found)."
 .Q
 ; Select File
 N DIC,X,Y S DIC=1,DIC(0)="AEQMZ" D ^DIC Q:Y<0
 N VFDA,VFDFILE,VFDXFILE,VFDFGL,VFDPFIL,VFDPFLD,VFDPSUM,VFDG,VFDS,VFDP,VFDP4
 N VFDX,VFDFLST,VFDNCHK
 N VFDRSLT S VFDRSLT=$NA(^TMP("VFDXTPT","LMC",$J)) K @VFDRSLT
 S VFDFILE=+Y,VFDXFILE=$P(Y,U,2),VFDFGL=$$ROOT^DILFD(VFDFILE,,1)
 ;
 N %ZIS,POP
 S %ZIS="Q",%ZIS("A")="(queuing recommended) Select DEVICE: ",%ZIS("B")=""
 D ^%ZIS Q:POP
 I $G(IO("Q")) N ZTDESC,ZTRTN,ZTSAVE,ZTSK D  Q  ;If queued
 .S ZTDESC="VFD Pointers Analysis",ZTSAVE("VFD*")="",ZTRTN="DQC^VFDXTPT"
 .D ^%ZTLOAD K IO("Q") D HOME^%ZIS
 .Q
 ;
 ; Fall through to DQC, if not queued
 D WAIT^DICD W !
 ;
DQC ;[Private] From LMC
 U IO S VFDA=0
 F  S VFDA=$O(@VFDFGL@(VFDA)) Q:'VFDA  D LMC1(VFDFILE,VFDA) ;Classify one entry
 ; Classification complete
 Q
LMC1(VFDFILE,VFDA) ;[Private] From DQC - Process one entry in target file
 ; Normally called by LMA, however, can be invoked independently
 ; 
 ; VFDFILE=[Required] Target file number (pointed-to file)
 ; VFDA=[Required] Entry (IEN) in file VFDFILE
 ;
 I $G(VFDFILE),$G(VFDA) S (VFDPFIL,VFDPSUM)=0
 E  Q
 N VFDFAIL S VFDFAIL=0 W:'$D(ZTQUEUED) "+"
 I '$L($G(VFDRSLT)) S VFDRSLT=$NA(^TMP("VFDXTPT","LMC1",$J)) ;Do not kill
 F  S VFDPFIL=$O(^DD(VFDFILE,0,"PT",VFDPFIL)) Q:'VFDPFIL!VFDFAIL  D
 .S VFDPFLD=0 F  S VFDPFLD=$O(^DD(VFDFILE,0,"PT",VFDPFIL,VFDPFLD)) Q:'VFDPFLD  D LMC1P
 .W:'$D(ZTQUEUED)&'$G(VFDNODOT) "."
 .Q
 S:'VFDFAIL @VFDRSLT@("UNREFERENCED",VFDA)=""
 I 'VFDFAIL W:'$D(ZTQUEUED) ! W "Entry IEN="_VFDA_" '"_$$GET1^DIQ(VFDFILE,VFDA,.01),"' has no pointers-in.",!
 Q
LMC1P ;[Private] Called by LMC1 - Process one pointer
 ;
 S VFDP4=$P($G(^DD(VFDPFIL,VFDPFLD,0)),U,4)
 S VFDS=$P(VFDP4,";"),VFDP=$P(VFDP4,";",2) Q:'$L(VFDS)!'VFDP
 N VFDCMD
 S VFDCMD="S:$P($G(^(SIS(SISN),VFDS)),U,VFDP)=VFDA VFDFAIL=1"
 D XALL^SISFIND(,VFDPFIL,.VFDCMD)
 Q
