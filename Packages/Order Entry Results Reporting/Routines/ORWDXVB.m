ORWDXVB ;slc/dcm - Order dialog utilities for Blood Bank ;12/7/05  17:11
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,243**;Dec 17 1997;Build 242
 ;
 ; DBIA 2503   RR^LR7OR1   ^TMP("LRRR",$J)
 ; 
GETPAT(ORX,DFN,ORL)     ;Get Patient data from VBECS
 ;Needs patient DFN and Location (ORL)
 N ORSTN,DIV
 S DIV=+$P($G(^SC(+$G(ORL),0)),U,15),ORSTN=$P($$SITE^VASITE(DT,DIV),U,3)
 D OEAPI^VBECA3(.ORX,DFN,ORSTN)
 Q
PTINFO(OROOT,ORX)       ;Format patient BB info
 Q:'$D(ORX)
 D PTINFO^ORWDXVB1
 Q
RESULTS(OROOT,DFN,ORX)  ;Get test results
 Q:'$O(ORX(0))  ;ORX contains a list of tests to retrieve results for
 N ORCOM,ORT,ORTST,ORTDT,ORTMP,GCNT,CCNT,GIOSL,GIOM,I,ORZ
 S GCNT=0,CCNT=1,GIOSL=999999,GIOM=80
 S OROOT=$NA(^TMP("ORVBEC",$J))
 K ^TMP("ORVBEC",$J)
 D LN
 S ^TMP("ORVBEC",$J,GCNT,0)=$$S^ORU4(1,CCNT,"RECENT LAB RESULTS:",.CCNT)
 D LN
 S ^TMP("ORVBEC",$J,GCNT,0)=$$S^ORU4(1,CCNT,"Test    Result    Units      Range     Collected       Accession     Sts",.CCNT)
 D LN
 S ^TMP("ORVBEC",$J,GCNT,0)=$$S^ORU4(1,CCNT,"----    ------    -----      -----     ---------       ---------     ---",.CCNT)
 S ORT=0 F  S ORT=$O(ORX(ORT)) Q:'ORT  S ORTST=$P(ORX(ORT),"^",1) D
 . K ^TMP("LRRR",$J) D RR^LR7OR1(DFN,,,,,ORTST,,1)  ;DBIA 2503
 . S ORTMP="^TMP(""LRRR"",$J,DFN)",ORTMP=$Q(@ORTMP)
 . Q:$P(ORTMP,",",1,3)'=("^TMP(""LRRR"","_$J_","_DFN)
 . S ORTDT=9999999-+$P(ORTMP,",",5),ORZ=@ORTMP
 . D LN
 . S ^TMP("ORVBEC",$J,GCNT,0)=$$S^ORU4(1,CCNT,$P(ORZ,"^",15),.CCNT)_$$S^ORU4(8,CCNT,$J($P(ORZ,"^",2),7),.CCNT)_$$S^ORU4(16,CCNT,$P(ORZ,"^",3),.CCNT)_$$S^ORU4(19,CCNT,$P(ORZ,"^",4),.CCNT)_$$S^ORU4(30,CCNT,$P(ORZ,"^",5),.CCNT)
 . S ^(0)=^TMP("ORVBEC",$J,GCNT,0)_$$S^ORU4(40,CCNT,$$DATETIME^ORCHTAB(ORTDT),.CCNT)_$$S^ORU4(56,CCNT,$P(ORZ,"^",16),.CCNT)_$$S^ORU4(71,CCNT,$P(ORZ,"^",6),.CCNT)
 . S ORCOM=$P(ORTMP,",",1,5)_",""N""" ;check for comments
 . F  S ORTMP=$Q(@ORTMP) Q:$P(ORTMP,",",1,6)'=ORCOM  D
 .. D LN
 .. S ^TMP("ORVBEC",$J,GCNT,0)=$$S^ORU4(1,CCNT,@ORTMP,.CCNT)
 K ^TMP("LRRR",$J)
 Q
RAW(OROOT,DFN,ORX)  ;Get RAW test results
 Q:'$O(ORX(0))  ;ORX contains a list of tests to retrieve results for
 N ORCOM,ORT,ORTST,ORTDT,ORTMP,GCNT,CCNT,GIOSL,GIOM,I
 S GCNT=0,CCNT=1,GIOSL=999999,GIOM=80
 S OROOT=$NA(^TMP("ORVBEC",$J))
 K ^TMP("ORVBEC",$J)
 S ORT=0 F  S ORT=$O(ORX(ORT)) Q:'ORT  S ORTST=$P(ORX(ORT),"^",1) D
 . K ^TMP("LRRR",$J) D RR^LR7OR1(DFN,,,,,ORTST,,1)
 . S ORTMP="^TMP(""LRRR"",$J,DFN)",ORTMP=$Q(@ORTMP)
 . Q:$P(ORTMP,",",1,3)'=("^TMP(""LRRR"","_$J_","_DFN)
 . S ORTDT=9999999-+$P(ORTMP,",",5),ORZ=@ORTMP
 . D LN
 . S ^TMP("ORVBEC",$J,GCNT,0)=$P(ORZ,"^",1,6)_"^"_ORTDT
 K ^TMP("LRRR",$J)
 Q
SURG(OROOT,ORX) ;Get list of surgeries
 N I,CNT,X
 S (I,CNT)=0
 F  S I=$O(ORX("SURGERY",I)) Q:'I  S X=$G(ORX("SURGERY",I)) D
 . S CNT=CNT+1,OROOT(CNT)=X_U_X
 Q
LN ;Increment counts
 S GCNT=GCNT+1,CCNT=1
 Q
PATINFO(OROOT,DFN,LOC)   ;Test ^TMP global output
 N ORX
 D GETPAT(.ORX,DFN,LOC)
 I $L($G(ORX("SPECIMEN"))) S:$P(ORX("SPECIMEN"),"^") $P(ORX("SPECIMEN"),"^")=$$HL7TFM^XLFDT($P(ORX("SPECIMEN"),"^"))
 D PTINFO(.OROOT,.ORX)
 ;S I=0 F  S I=$O(@OROOT@(I)) Q:'I  W !,^(I,0)
 ;K @OROOT
 Q
GETALL(OROOT,DFN,LOC) ;Get all data in one call and let the GUI divide it up
 N ORX,INFO,CNT,I,J,K
 S OROOT=$NA(^TMP("ORVBECINFO",$J)),CNT=1
 D GETPAT(.ORX,DFN,LOC)
 ;S ^TMP("ORVBECINFO",$J,CNT)="~RAWDATA",I=0
 ;F  S I=$O(ORX(I)) Q:'I  S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)=ORX(I)
 I $L($G(ORX("SPECIMEN"))) S:$P(ORX("SPECIMEN"),"^") $P(ORX("SPECIMEN"),"^")=$$HL7TFM^XLFDT($P(ORX("SPECIMEN"),"^")) S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~SPECIMEN",CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_ORX("SPECIMEN")
 I $L($G(ORX("ABORH"))) S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~ABORH",CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_ORX("ABORH")
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~TYPE AND SCREEN",CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_$O(^ORD(101.43,"ID","1;99VBC",0))
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~OTHER",CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_$O(^ORD(101.43,"ID","6;99VBC",0))
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~SPECIMENS",I=0
 F  S I=$O(ORX(I)) Q:'I  S J="" F  S J=$O(ORX(I,J)) Q:J=""  I J="SPECIMEN" S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_I_"^"_ORX(I,J)
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~TESTS",I=0
 F  S I=$O(ORX(I)) Q:'I  S J="" F  S J=$O(ORX(I,J)) Q:J=""  I J="TEST" S K=0 F  S K=$O(ORX(I,J,K)) Q:'K  S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_I_"^"_K_"^"_ORX(I,J,K)
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~MSBOS",I=0
 F  S I=$O(ORX(I)) Q:'I  S J="" F  S J=$O(ORX(I,J)) Q:J=""  I J="MSBOS" S K=0 F  S K=$O(ORX(I,J,K)) Q:'K  S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_I_"^"_K_"^"_ORX(I,J,K),$P(^(CNT),"^",4)=+$P(ORX(I,J,K),"^",2)
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~SURGERIES",I=0
 F  S I=$O(ORX("SURGERY",I)) Q:'I  S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_I_"^"_ORX("SURGERY",I)
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~URGENCIES",I=""
 F  S I=$O(^ORD(101.42,"S.VBEC",I)) Q:I=""  S J=0 F  S J=$O(^ORD(101.42,"S.VBEC",I,J)) Q:'J  S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_J_"^"_I
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~MODIFIERS",I=""
 N ORMODS D GETLST^XPAR(.ORMODS,"ALL","OR VBECS MODIFIERS","I")
 F  S I=$O(ORMODS(I)) Q:'I  S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_ORMODS(I)
 ;F I="W^Washed","I^Irradiated","L^Leuko Reduced","V^Volume Reduced","D^Divided","E^Leuko Reduced/Irradiated" S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_I
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~REASONS",I=""
 N ORMODS D GETLST^XPAR(.ORMODS,"ALL","OR VBECS REASON FOR REQUEST","I")
 F  S I=$O(ORMODS(I)) Q:'I  S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_ORMODS(I)
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~INFO"
 D PTINFO(.INFO,.ORX)
 S I=0 F  S I=$O(^TMP("ORVBEC",$J,I)) Q:'I  S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_^TMP("ORVBEC",$J,I,0)
 S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="~TNS ORDERS"
 N ORMODS D PULL^ORWDXVB2(.ORMODS,DFN)
 S I=0 F  S I=$O(ORMODS(I)) Q:'I  S CNT=CNT+1,^TMP("ORVBECINFO",$J,CNT)="i"_ORMODS(I)
 K ^TMP("ORVBEC",$J)
 Q
STATALOW(OROOT,DFN) ;Allow stat for ORES ORELSE users
 S OROOT=$D(^XUSEC("ORES",DUZ))!($D(^XUSEC("ORELSE",DUZ)))
 Q
NURSADMN(OROOT) ;Suppress Nursing Adiminstration Order Prompt
 S OROOT=+$$GET^XPAR("DIV^SYS^PKG","OR VBECS SUPPRESS NURS ADMIN")
 Q
VBTNS(RETURN) ;RPC to get Days back to check for Type & Screen order
 S RETURN=$$GET^XPAR("ALL","ORWDXVB VBECS TNS CHECK",1,"I")
 Q
COMPORD(OROOT) ;Get sequence order of Blood Components
 N ORLIST,I,X
 D GETLST^XPAR(.ORLIST,"ALL","OR VBECS COMPONENT ORDER")
 S I=0 F  S I=$O(ORLIST(I)) Q:'I  S X=ORLIST(I) I $D(^ORD(101.43,$P(X,"^",2),0)) S OROOT(I)=$P(X,"^",2)_"^"_$P(^(0),"^",1)_"^"_$P(^(0),"^",1)
 Q
SUBCHK(OROOT,TSTNM) ;Check to see if selected test is a Blood Component or a Diagnostic Test
 S OROOT=""
 Q:'$L($G(TSTNM))
 I $O(^ORD(101.43,"S.VBT",TSTNM,0)) S OROOT="t"
 I $O(^ORD(101.43,"S.VBC",TSTNM,0)) S OROOT="c"
 Q
TESTR ;Test results call
 N ORX
 S ORX(3)="3" ;HGB
 S ORX(4)="4" ;HCT
 S ORX(1)="1" ;WBC
 S ORX(113)="113" ;FERRITIN
 D RESULTS(.OROOT,66,.ORX)
 S I=0 F  S I=$O(@OROOT@(I)) Q:'I  W !,^(I,0)
 K @OROOT
 Q
