MCBPFTP3 ;WISC/TJK,ALG-PFT BRIEF REPORT-FLOWS ;6/24/99  08:58
 ;;2.3;Medicine;**17,25**;09/13/1996
FLOW G ABG:'$D(^MCAR(700,MCARGDA,4)),ABG:'$O(^(4,0)) S MCX=0
 I '$D(HEAD1) S HEAD1="FLOWS" D HEAD1^MCBPFTP2,HEAD2^MCBPFTP2
 E  S HEAD1="FLOWS" D HEAD2^MCBPFTP2
 Q:$D(MCOUT)
 I MC17'="" S MC17A=$P(MC17,U,2) W ?3,"MACHINE: ",$S(MC17A="F":"FLOW TURBINE",MC17A="P":"PNEUMOTACH",MC17A="A":"ANEMOMETER",MC17A="DS":"DRY WATER SEAL",MC17A="WS":"WATER SEAL",MC17A="W":"WEDGE",1:"") X MCFF K MC17A Q:$D(MCOUT)
FLOW1 S MCX=$O(^MCAR(700,MCARGDA,4,MCX)) G ABG:MCX'?1N.N S MCREC=^(MCX,0),TYPE=$P(MCREC,U)
 W !! X MCFF Q:$D(MCOUT)
 S ND="AF",ND1=4 D PRETEST^MCBPFTP2
 W ?5,$S(TYPE="S":"STANDARD STUDY",TYPE="B":"AFTER BRONCHODILATOR",TYPE="I":"AFTER INHALATION CHALLENGE",1:"AFTER EXERCISE") X MCFF Q:$D(MCOUT)  D PREVDATE^MCBPFTP2
 I $P(MCREC,U,6)'="" W !,?5,"(NOTES): ",$P(MCREC,U,6) X MCFF Q:$D(MCOUT)
 S ACT=$P(MCREC,U,2) I ACT S MEAS="FVC",UNITS="L",PRED=FVC X:$D(MCRC1) MCRC1 S PC=2,CI95=$S(PRED:PRED-CFVC,1:"") D PRTLINE S:TYPE="S" MCIFA=ACT,MCIFL=CI95 Q:$D(MCOUT)
 S ACT=$P(MCREC,U,3) I ACT S MEAS="FEV1",UNITS="L",PRED=FEV1 X:$D(MCRC1) MCRC1 S PC=3,CI95=$S(PRED:PRED-CFEV1,1:"") D PRTLINE S:TYPE="S" MCIFE=ACT Q:$D(MCOUT)
 S MCDL=2,MCLNG=5,ACT=$P(MCREC,U,7) I ACT S MEAS="MVV",UNITS="L/MIN",PRED=MVV X:$D(MCRC5) MCRC5 S PC=7,CI95=$S(PRED:PRED-CMVV,1:"") S:TYPE="S" MCMVVN=ACT D PRTLINE Q:$D(MCOUT)
 ;write out actual FEV1/FVC*100 from elements in MCREC 
 I $P(MCREC,U,2),$P(MCREC,U,3) W !,?5,"FEV1/FVC",?17,"%" S ACT=$P(MCREC,U,3)/$P(MCREC,U,2) W ?35,$J(ACT*100,5,0) S:TYPE="S" MCIFV=ACT X MCFF Q:$D(MCOUT)
 G FLOW1
ABG G ^MCBPFTP4
PRTLINE S MCP1=$G(MCP1),MCP2=$G(MCP2)
 W !,?5,MEAS,?15,UNITS,?25,$S(PRED:$J(PRED,MCLNG,MCDL),1:""),?35,$J(ACT,MCLNG,MCDL),?45,$S(PRED:$J(ACT/PRED*100,5,1),1:"") W:$P(MCP1,U,PC) ?55,$J($P(MCP1,U,PC),MCLNG,MCDL) W:$P(MCP2,U,PC) ?65,$J($P(MCP2,U,PC),MCLNG,MCDL)
 W:(CI95)&(CI95'=PRED) ?72,$J(CI95,6,2) X MCFF Q
