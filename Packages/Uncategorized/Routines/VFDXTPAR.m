VFDXTPAR ;DSS/LM - Parameter Initialization ; 7/16/08 1:14pm
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ;  POST-INSTALL PARAMETER INITIALIZATION API
 ;  Word-processing data type is not supported.
 ;
 ;
 ;  The following code is adapted from routine MULT^VFDREGP
 ;
EN(VFDATA,VFDOWHAT) ;;[Public] Initialize parameters
 ; VFDATA=[Required] ENTRYREF specifying location of DATA,
 ;        i.e. Literal or expression atom that evaluates to TAG^ROUTINE
 ;        
 ; The entry reference specified by VFDATA has the following structure:
 ; 
 ; All lines begin: <Line start>;;
 ; 
 ; The first line has PARAMETER^ENTITY^DELETE FLAG
 ; 
 ;                  PARAMETER is required.
 ;                  ENTITY defaults to "SYS"
 ;                     ... If not "SYS" include value, e.g. PREFIX.ENTRY NAME 
 ;                  DELETE FLAG deletes all instances.
 ;                     Default is no delete; 1=Delete
 ;                  
 ; The following lines have INSTANCE^VALUE^OVERRIDE ACTION, one per line
 ; 
 ;                  INSTANCE defaults to '1'
 ;                  VALUE defaults to the null string
 ;                  OVERRIDE ACTION defaults to NO instance-specific override
 ;                  
 ; One blank line (;;) denotes END OF PARAMETER^ENTITY specification
 ; Two blank lines denote END OF INITIALIZATION (this call)
 ; 
 ; No data may contain the "~" character!  (meaningful to ADD^VFDCXPR)
 ; 
 ; For example:
 ; 
 ; DATA ;;
 ;      ;;MYPARAMETER
 ;      ;;^VALUE OF DEFAULT INSTANCE
 ;      ;;
 ;      ;;ANOTHER PARAMETER^LOC.MY CLINIC
 ;      ;;STATUS^OK TO FILE
 ;      ;;FILTERS^NONE
 ;      ;;
 ;      ;;
 ;
 ; VFDOWHAT=[Optional] Action to take.  Default is "ADD"
 ;          Supported actions: ADD, CHG, DEL
 ;          
 I $L($P($G(VFDATA),U,2)) S VFDOWHAT=$G(VFDOWHAT,"ADD")
 E  Q  ;Data ENTRY REFERENCE must include ROUTINE
 ;
 N VFDACT,VFDI,VFDPARM,VFDEL,VFDENT,VFDINST,VFDNM,VFDVAL,VFDQUIT,VFDX
 S (VFDPARM,VFDQUIT)=""
 F VFDI=1:1 S VFDX=$P($T(@($P(VFDATA,U)_"+"_VFDI_U_$P(VFDATA,U,2))),";",3,99) D  Q:VFDQUIT
 .I VFDPARM="",VFDX="" S VFDQUIT=1 Q  ;All parameters done
 .I VFDPARM=""!(VFDX="") D  Q
 ..S VFDPARM=$P(VFDX,U),VFDENT=$P(VFDX,U,2),VFDEL=$P(VFDX,U,3)
 ..S:VFDENT="" VFDENT="SYS" ;Default entity
 ..I VFDEL=1 D NDEL^XPAR(VFDENT,VFDPARM)
 ..Q
 .; Read ;Instance value pair + optional override action
 .S VFDINST=$P(VFDX,U),VFDVAL=$P(VFDX,U,2),VFDACT=$P(VFDX,U,3)
 .S:VFDINST="" VFDINST=1 ;Default INSTANCE
 .S:VFDACT="" VFDACT=VFDOWHAT
 .I VFDACT="ADD" D  Q
 ..D ADD^VFDCXPR(,VFDENT_"~"_VFDPARM_"~"_VFDINST_"~"_VFDVAL)
 ..Q
 .I VFDACT="CHG" D  Q
 ..D CHG^VFDCXPR(,VFDENT_"~"_VFDPARM_"~"_VFDINST_"~"_VFDVAL)
 ..Q
 .I VFDACT="DEL" D  Q
 ..D DEL^VFDCXPR(,VFDENT_"~"_VFDPARM_"~"_VFDINST_"~"_VFDVAL)
 ..Q
 .Q
 Q
