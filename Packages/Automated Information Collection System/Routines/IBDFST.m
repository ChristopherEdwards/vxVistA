IBDFST ;ALB/MAF - FORMS TRACKING STATISTICS - JUL 6 1995
 ;;3.0;AUTOMATED INFO COLLECTION SYS;;APR 24, 1997
 ;
 ;
EN ; -- main entry point for IBDF FT STATS
 D EN^VALM("IBDF FT STATS")
 Q
 ;
HDR ; -- header code
 S IBDFX=$P($$FMTE^XLFDT(IBDFBG),"@")
 S IBDFY=$P($$FMTE^XLFDT(IBDFEND),"@")
 S VALMHDR(1)="Statistical data for the date range of "_IBDFX_" to "_IBDFY
 Q
 ;
 ;
INIT ; -- init variables and list array
 N IBDFDV,IBDFCL,IBDFNODE,IBDCNT,IBDCNT1
 S (IBDFDV,IBDFCL,IBDCNT,IBDCNT1,VALMCNT)=0
 K IBDF,^TMP("STATS",$J),^TMP("STAIDX",$J)
 F IBDFDIV=0:0 S IBDFDV=$O(^TMP("CNT",$J,IBDFDV)) Q:IBDFDV']""  F IBDFCLI=0:0 S IBDFCL=$O(^TMP("CNT",$J,IBDFDV,IBDFCL)) Q:IBDFCL']""  S IBDFNODE=^TMP("CNT",$J,IBDFDV,IBDFCL) D:'$D(IBDF(IBDFDV)) HEADER D SETARR
 Q
 ;
 ;
SETARR ;  -- Set up Listman array
 S IBDCNT1=IBDCNT1+1
 S IBDCNT=IBDCNT+1,VALMCNT=VALMCNT+1
 S X=""
 S IBDFVAL=$$LOWER^VALM1(IBDFCL)
 S X=$$SETSTR^VALM1(IBDFVAL,X,1,20)
 S IBDFVAL=$J($P(IBDFNODE,"^",1),6)
 S X=$$SETSTR^VALM1(IBDFVAL,X,22,6)
 S IBDFVAL=$J($P(IBDFNODE,"^",2),5)
 S X=$$SETSTR^VALM1(IBDFVAL,X,30,5)
 S IBDFVAL=$J($S($P(IBDFNODE,"^",1)>0:($P(IBDFNODE,"^",2)/$P(IBDFNODE,"^",1))*100,1:0),6) I IBDFVAL>0 S IBDFVAL=$J($P(IBDFVAL,".",1)_"."_$E($P(IBDFVAL,".",2),1,2),6)
 S X=$$SETSTR^VALM1(IBDFVAL,X,37,6)
 S IBDFVAL=$J($S($P(IBDFNODE,"^",5)]"":$P(IBDFNODE,"^",5),1:0),5)
 S X=$$SETSTR^VALM1(IBDFVAL,X,45,5)
 I $P(IBDFNODE,"^",7) S IBDFVAL=$P(IBDFNODE,"^",1)-$P(IBDFNODE,"^",7)
 S IBDFVAL=$J($S(+$P(IBDFNODE,"^",7)>0&(IBDFVAL>0):(+$P(IBDFNODE,"^",5)/IBDFVAL)*100,+$P(IBDFNODE,"^",7)'>0:(+$P(IBDFNODE,"^",5)/$P(IBDFNODE,"^",1))*100,1:0),6) I IBDFVAL>0 S IBDFVAL=$J($P(IBDFVAL,".",1)_"."_$E($P(IBDFVAL,".",2),1,2),6)
 S X=$$SETSTR^VALM1(IBDFVAL,X,52,6)
 S IBDFVAL=$J($P(IBDFNODE,"^",3),5)
 S X=$$SETSTR^VALM1(IBDFVAL,X,60,5)
 I $P(IBDFNODE,"^",7) S IBDFVAL=$P(IBDFNODE,"^",1)-$P(IBDFNODE,"^",7)
 S IBDFVAL=$J($S(+$P(IBDFNODE,"^",7)>0&(IBDFVAL>0):($P(IBDFNODE,"^",3)/IBDFVAL)*100,+$P(IBDFNODE,"^",7)'>0:(+$P(IBDFNODE,"^",3)/$P(IBDFNODE,"^",1))*100,1:0),6) I IBDFVAL>0 S IBDFVAL=$J($P(IBDFVAL,".",1)_"."_$E($P(IBDFVAL,".",2),1,2),6)
 S X=$$SETSTR^VALM1(IBDFVAL,X,67,6)
 S IBDFVAL=$J($S($P(IBDFNODE,"^",6)]"":$P(IBDFNODE,"^",6),1:0),5)
 S X=$$SETSTR^VALM1(IBDFVAL,X,75,5)
 I $P(IBDFNODE,"^",7) S IBDFVAL=$P(IBDFNODE,"^",1)-$P(IBDFNODE,"^",7)
 S IBDFVAL=$J($S(+$P(IBDFNODE,"^",7)>0&(IBDFVAL>0):($P(IBDFNODE,"^",6)/IBDFVAL)*100,+$P(IBDFNODE,"^",7)'>0:($P(IBDFNODE,"^",6)/$P(IBDFNODE,"^",1))*100,1:0),6) I IBDFVAL>0 S IBDFVAL=$J($P(IBDFVAL,".",1)_"."_$E($P(IBDFVAL,".",2),1,2),6)
 S X=$$SETSTR^VALM1(IBDFVAL,X,82,6)
 I $P(IBDFNODE,"^",7) S IBDFVAL=$P(IBDFNODE,"^",1)-$P(IBDFNODE,"^",7)
 S IBDFVAL=$J($S(+$P(IBDFNODE,"^",7)>0&(IBDFVAL>0):($P(IBDFNODE,"^",4)/IBDFVAL),+$P(IBDFNODE,"^",7)'>0:($P(IBDFNODE,"^",4)/$P(IBDFNODE,"^",1)),1:0),13) I IBDFVAL>0 S IBDFVAL=$J($P(IBDFVAL,".",1)_"."_$E($P(IBDFVAL,".",2),1,2),13)
 S X=$$SETSTR^VALM1(IBDFVAL,X,90,13)
 ;
 ;
TMP ; -- Set up TMP Array
 S ^TMP("STATS",$J,IBDCNT,0)=X,^TMP("STATS",$J,"IDX",VALMCNT,IBDCNT1)=""
 S ^TMP("STAIDX",$J,IBDCNT1)=VALMCNT
 Q
 ;
 ;
HEADER ;  -- Set up header line for the display
 S IBDCNT1=IBDCNT1+1
 S IBDCNT=IBDCNT+1,VALMCNT=VALMCNT+1
 S X=""
 S IBDF(IBDFDV)=IBDCNT
 S X=$$SETSTR^VALM1(" ",X,1,3) D TMP
 S X="",IBDCNT=IBDCNT+1,VALMCNT=VALMCNT+1
 S IBDVAL=IBDFDV
 S X=$$SETSTR^VALM1(IBDVAL,X,1,25) D TMP,CNTRL^VALM10(VALMCNT,1,80,IOINHI,IOINORM,0)
 S X="",IBDCNT=IBDCNT+1,VALMCNT=VALMCNT+1
 S X=$$SETSTR^VALM1(" ",X,1,3) D TMP
 S IBDCNT1=IBDCNT1-1
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
 ;
EXIT ; -- exit code
 K IBDF,IBDFX,IBDFY,^TMP("STATS",$J),^TMP("STAIDX",$J)
 Q
 ;
 ;
EXPND ; -- expand code
 Q
 ;
