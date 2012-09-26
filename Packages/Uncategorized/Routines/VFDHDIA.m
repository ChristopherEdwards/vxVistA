VFDHDIA ; DSS/WLC - Add entry to Standardized file
 ;;2009.2;DSS,INC VXVISTA OPEN SOURCE;;01 Dec 2009
 ;Copyright 1995-2009,Document Storage Systems Inc. All Rights Reserved
 ;
 ; Routine adds value to existing file that has been standardized.
EN(VFOK,FILE,IEN,LIST) ;  RPC:  VFD ADD STD FIELD
 ; INPUT:
 ;    FILE = file number
 ;    IEN = Internal Entry number in file (default = +1,)
 ;          Send "+1," to add entry to file.
 ;    LIST = Array of values to add, with field number (fld #^Value)
 ;         i.e.:  LIST(1)=".01^Adding description to file"
 ; OUTPUT:
 ;     VFOK = -1^Error, or, 1 for success
 ;
 N I,X,ENTRY,VFDFDA,FIELD,VFDERRM,HLPM,XUMF
 S VFOK=0,XUMF=1
 S FILE=$G(FILE),IEN=$G(IEN,"+1,")
 S X=$$VFILE^DILFD(FILE) I 'X S VFOK="-1^File #"_FILE_" is not valid." Q
 I '$D(LIST) S VFOK="-1^No field data defined" Q
 K VFDFDA,VFDERRM
 S I="" F  S I=$O(LIST(I)) Q:'I  D  Q:+VFOK<0
 . S FIELD=$P(LIST(I),U),ENTRY=$P(LIST(I),U,2)
 . S X=$$VFIELD^DILFD(FILE,FIELD) I 'X S VFOK="-1^Field #"_FIELD_" does not exist in File #"_FILE Q
 . D VAL^DIE(FILE,IEN,FIELD,"H",ENTRY,,"VFDERRM")
 . I $G(ERRM)="^" S VFOK="-1^"_ERRM("DIERR",1,"TEXT",1) Q
 . S VFDFDA(FILE,IEN,FIELD)=ENTRY
 Q:+VFOK<0
 I IEN["+1" D UPDATE^DIE(,"VFDFDA",,"VFDERRM") G EN1
 D FILE^DIE(,"VFDFDA","VFDERRM")
EN1 ;
 I $D(VFDERRM) S VFOK="-1^"_VFDERRM("DIERR",1,"TEXT",1) Q
 S VFOK=1
 Q
 ;
 ;
VUIDG(FILE,FLG) ; Generate VUID for Standardized files
 ; INPUT:
 ;    FILE = file number to standardize
 ;    FLG = set to indicate National Standard VUID (DSS; site = 100)
 N I,CNT,J,LAST,PASS,ROOT,VUID,RES,SEED,ST
 S CNT=1,FLG=$G(FLG,0) S:$D(VFDXUMF)#2 FLG=+VFDXUMF
 S J=$$SITE^VASITE() I J<1 Q -1
 S SEED=$S(FLG:1000000,1:J*10000)
 K RES D ROOT^VFDCFM(.RES,FILE,,1)
 S LAST=$O(@RES@("AVUID",""),-1) S PASS=$S(LAST'?1N.N:SEED+1,1:LAST+1)
 Q PASS
  
