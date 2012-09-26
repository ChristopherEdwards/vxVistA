VFDXTR ;DSS/SGM - ROUTINE UTILITY MAIN DRIVER;22 Mar 2008 22:40
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;This routine is the main OPTION driver for all routine utilities.
 ;Each line tag is invoked via a MenuMan OPTION.
 ;
 Q
 ;
DEL ; option: VFD IT ROUTINE DELETE
 ;delete selected routines
 D DEL^VFDXTR01 Q
 ;
NUM ; option: VFD IT ROUTINE UPDATE
 ;updated version of VA XTVNUM utility
 ;Date stamp 1st line, update version#, update patch list
 ;insert copyright statement
 D ^VFDXTNUM Q
 ;
SIZE ; option: VFD IT ROUTINE SIZE
 ;display routine size per March 2007 VA Programming SAC
 ;20K total size, 15K executable code size, 5K comments
 ;Any line with a label or starts with " ;;" is counted as executable
 D ^VFDXTRSZ Q
 ;
SVRES ; option: VFD IT ROUTINE SAVE/RESTORE
 ;save routines to indiviudual HFS files
 ;restored routines from individual HFS files previously saved by this
 D ^VFDXTRS Q
