RAFLM3 ;HISC/FPT-Film Usage Workload Rpt (cont.) ;4/17/96  09:32
 ;;5.0;Radiology/Nuclear Medicine;;Mar 16, 1998
DIVTOT ; print division totals
 Q:RAITCNT(RADIV)=1  ;quit if only one imaging type selected for division
 K ^TMP($J,"RADIVFLD")
 D DIVHDR Q:RAEOS
 S RATMPNDE=^TMP($J,"RA",RADIV),RADEXAM=$P(RATMPNDE,U,1),RADFILM=$P(RATMPNDE,U,2)
 S RAITHLD=""
 F  S RAITHLD=$O(^TMP($J,"RA",RADIV,RAITHLD)) Q:RAITHLD=""  S RAITFLD="" F  S RAITFLD=$O(^TMP($J,"RA",RADIV,RAITHLD,RAITFLD)) Q:RAITFLD=""  D
 .S RAITEXAM=$P(^TMP($J,"RA",RADIV,RAITHLD,RAITFLD),U,1)
 .S RAITFILM=$P(^TMP($J,"RA",RADIV,RAITHLD,RAITFLD),U,2)
 .S:'$D(^TMP($J,"RADIVFLD",RAITFLD)) ^TMP($J,"RADIVFLD",RAITFLD)="0^0"
 .I $P(^TMP($J,"RA",RADIV,RAITHLD,RAITFLD),U,4)=1 S $P(^TMP($J,"RADIVFLD",RAITFLD),U,4)=1
 .S $P(^TMP($J,"RADIVFLD",RAITFLD),U,1)=$P(^TMP($J,"RADIVFLD",RAITFLD),U,1)+RAITEXAM
 .S $P(^TMP($J,"RADIVFLD",RAITFLD),U,2)=$P(^TMP($J,"RADIVFLD",RAITFLD),U,2)+RAITFILM
 S RAITFLD=""
 F  S RAITFLD=$O(^TMP($J,"RADIVFLD",RAITFLD)) Q:RAEOS!(RAITFLD="")  D
 .S RAITNDE=$G(^TMP($J,"RADIVFLD",RAITFLD))
 .S RAITEXAM=$P(RAITNDE,U,1)
 .S RAITFILM=$P(RAITNDE,U,2)
 .S RAITPCT=$S(RADFILM:(100*RAITFILM)/RADFILM,1:0)
 .S RAITRATO=$S(RAITEXAM:RAITFILM/RAITEXAM,1:0)
 .W !?2,RAITFLD,?40,$J(RAITFILM,5),?50,$J(RAITEXAM,5),?60,$J(RAITRATO,5,1) Q:$P(RAITNDE,U,4)  W ?70,$J(RAITPCT,5,1)
 .I ($Y+6)>IOSL S RAEOS=$$EOS^RAUTL5() Q:RAEOS  D DIVHDR
 Q:RAEOS
 S RADRATIO=$S(RADEXAM:RADFILM/RADEXAM,1:0)
 W !,RA80DASH,!!?2,"Division Total",?40,$J(RADFILM,5),?50,$J(RADEXAM,5),?60,$J(RADRATIO,5,1)
 W !!!,"* Cine data not included in division totals.",!?2,"Percentages calculated on film data only."
 I ($Y+(RAITCNT(RADIV)\2)+3)>IOSL S RAEOS=$$EOS^RAUTL5 Q:RAEOS   D DIVHDR Q:RAEOS
 W !!?2,"Imaging Type(s): "
 S RAITHLD=""
 F  S RAITHLD=$O(^TMP($J,"RA",RADIV,RAITHLD)) Q:RAEOS!(RAITHLD="")  W:$X>(80-25) !?($X+$L("Imaging Type(s):")+3) D
 .I ($Y+4)>IOSL S RAEOS=$$EOS^RAUTL5 Q:RAEOS  D DIVHDR Q:RAEOS  W !?19
 .W $S($D(^RA(79.2,+$P(RAITHLD,"-",2),0)):$P(^(0),U,1),1:"UNKNOWN"),?($X+3)
 Q:RAEOS
 W !!?3,"# of Films selected: "_$S(RAINPUT=1:"ALL",1:$G(RAFLDCNT))
 K ^TMP($J,"RADIVFLD"),RADEXAM,RADFILM,RADRATIO,RAITEXAM,RAITFILM,RAITFLD,RAITHLD,RAITNDE,RAITPCT,RAITRATO,RATMPNDE
 I $O(^TMP($J,"RA",RADIV))]"" S RAEOS=$$EOS^RAUTL5()
 Q
DIVHDR W:$Y>0 @IOF
 W !?5,">>>>> Film Usage Report <<<<<"
 S PAGE=PAGE+1 W ?70,"Page: ",PAGE
 W !!?1,"Division: ",$S($D(^DIC(4,+RADIV,0)):$P(^(0),U,1),1:"UNKNOWN"),?52,"For period: ",?64,BEGDATE,?76,"to"
 W !?1,"Run Date: ",RARUNDTE,?64,ENDDATE
 W !!?40,"Number",?50,"Number",?60,"Films",?70,"Percentage"
 W !?40,"  of  ",?50,"  of  ",?60,"  per ",?70," Films"
 W !?2,"Film Size",?40,"Films*",?50,"Exams",?60," Exam",?70," Used"
 W !,RA80DASH
 W !?10,"(Division Summary)"
 I $D(ZTQUEUED) D STOPCHK^RAUTL9 S:$G(ZTSTOP)=1 RAEOS=1
 Q
