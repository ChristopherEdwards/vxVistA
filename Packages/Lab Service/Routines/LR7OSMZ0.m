LR7OSMZ0 ;slc/dcm - Silent Micro rpt ;8/11/97
 ;;5.2;LAB SERVICE;**121,244**;Sep 27, 1994
EN1 ;from 
 S LRLLT=^LR(LRDFN,"MI",LRIDT,0),LRACC=$P(LRLLT,U,6),LRAD=$E(LRLLT)_$P(LRACC," ",2)_"0000",X=$P(LRACC," "),DIC=68,DIC(0)="M"
 I $L(X) D ^DIC S LRAA=+Y,LRAN=+$P(LRACC," ",3),LRCMNT=$S($D(^LR(LRDFN,"MI",LRIDT,99)):^(99),1:""),LRPG=0 D EN^LR7OSMZ1 Q:LREND
 Q
EN(DFN) ;Process Microbiology entries listed in ^TMP("LRRR",$J,DFN,"MI",LRIDT,1)
 ;Return formated report in ^TMP("LRC",$J)
 Q:'$D(^TMP("LRRR",$J,+$G(DFN),"MI"))
 N LBL,LCNT,LRAA,LRACC,LRAD,LRAN,LRCMNT,LRDFN,LRDPF,LRIDT,LRJ02,LRLLT,LRPG,LRSB
 N LRONESPC,LREND,LRONETST,GCNT,GIOM,LREND,CCNT,CT1,COUNT,LRIN,SEX
 K ^TMP("LRC",$J)
 S (LRONETST,LRONESPC)="",CCNT=1,(LREND,GCNT)=0,GIOSL=999999,GIOM=80
 Q:'$G(DFN)
 S LRDFN=$$LRDFN^LR7OR1(DFN)
 Q:'LRDFN
 S LRDPF="2^DPT(",SEX=$P($G(@("^"_$P(LRDPF,"^",2)_+LRDFN_",0)")),"^",2),LRIDT=0
 F  S LRIDT=$O(^TMP("LRRR",$J,DFN,"MI",LRIDT)) Q:LRIDT<1  D
 . N DFN
 . D EN1
 Q
