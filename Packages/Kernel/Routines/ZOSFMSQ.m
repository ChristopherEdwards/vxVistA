ZOSFMSQ ;SFISC/AC - SETS UP ^%ZOSF FOR VAX M/SQL ;8/1/94  11:19
 ;;8.0;KERNEL;;JUL 03, 1995
 S %Y=1 K ^%ZOSF("MASTER"),^%ZOSF("SIGNOFF")
 K ZO F I="MGR","PROD","VOL" S:$D(^%ZOSF(I)) ZO(I)=^%ZOSF(I)
 F I=1:2 S Z=$P($T(Z+I),";;",2) Q:Z=""  S X=$P($T(Z+1+I),";;",2,99) S ^%ZOSF(Z)=$S($D(ZO(Z)):ZO(Z),1:X)
MGR W !,"NAME OF MANAGER'S UCI,DIRECTORY SET: "_^%ZOSF("MGR")_"// " R X:$S($G(DTIME):DTIME,1:9999) I X]"" X ^("UCICHECK") G MGR:Y="" S ^%ZOSF("MGR")=X
PROD W !,"PRODUCTION (SIGN-ON) UCI,DIRECTORY SET: "_^%ZOSF("PROD")_"// " R X:$S($G(DTIME):DTIME,1:9999) I X]"" X ^("UCICHECK") G PROD:Y="" S ^%ZOSF("PROD")=Y
VOL W !,"NAME OF THIS DIRECTORY SET: "_^%ZOSF("VOL")_"//" R X:$S($G(DTIME):DTIME,1:9999) I X]"" S:X?1.10UP ^%ZOSF("VOL")=X I X'?1.10UP W "MUST BE 1-10 characters." G VOL
OS S $P(^%ZOSF("OS"),"^",1)="M/SQL" S:'$P(^%ZOSF("OS"),"^",2) $P(^%ZOSF("OS"),"^",2)=7
 W !!,"ALL SET UP",!! Q
Z ;;
 ;;ACTJ
 ;;S Y=$$ACTJ^%ZOSV()
 ;;AVJ
 ;;S Y=$$AVJ^%ZOSV()
 ;;BRK
 ;;B 1
 ;;DEL
 ;;X "ZR  ZS @X" K ^UTILITY("ROU",X)
 ;;EOFF
 ;;S Y=$S($D(^XUTL("ZISPARAM",$I)):^($I),1:"") S:Y'["S" Y=Y_"S" U $I:("":Y:$C(13,27)) S ^($I)=Y
 ;;EON
 ;;S Y=$S($D(^XUTL("ZISPARAM",$I)):^($I),1:""),Y=$TR(Y,"S","") U $I:("":Y:$C(13,27)) S ^($I)=Y
 ;;EOT
 ;;S Y=$ZA\1024#2
 ;;ERRTN
 ;;^%ZTER
 ;;ETRP
 ;;Q
 ;;GD
 ;;D ^%GD
 ;;JOBPARAM
 ;;D JOBPAR^%ZOSV
 ;;LABOFF
 ;;S Y=$S($D(^XUTL("ZISPARAM",$I)):^($I),1:"") S:Y'["S" Y=Y_"S" U IO:("":Y:$C(13,27)) S ^($I)=Y
 ;;LOAD
 ;;S %N=0 X "ZL @X F XCNP=XCNP+1:1 S %N=%N+1,%=$T(+%N) Q:$L(%)=0  S @(DIF_XCNP_"",0)"")=%"
 ;;LPC
 ;;S Y=$ZC(X)
 ;;MAXSIZ
 ;;S $ZS=X+X
 ;;MGR
 ;;DRA0:[MVX]
 ;;MAGTAPE
 ;;S %MT("BS")="*-1",%MT("FS")="*-2",%MT("WTM")="*-3",%MT("WB")="*-4",%MT("REW")="*-5",%MT("RB")="*-6",%MT("REL")="*-7",%MT("WHL")="*-8",%MT("WEL")="*-9"
 ;;MTBOT
 ;;S Y=$ZA\32#2
 ;;MTERR;;MAGTAPE ERROR; FROM TABLE 9.3
 ;;S Y=$ZA\8#2
 ;;MTONLINE
 ;;S Y=$ZA\64#2
 ;;MTWPROT
 ;;S Y=$ZA\4#2
 ;;MTERR;;MAGTAPE ERROR
 ;;S Y=$ZA\32768#2
 ;;NBRK
 ;;B 0
 ;;NO-PASSALL
 ;;S Y=$S($D(^XUTL("ZISPARAM",$I)):^($I),1:""),Y=$TR(Y,"IT","") U $I:("":Y:$C(13,27)) S ^($I)=Y
 ;;NO-TYPE-AHEAD
 ;;S Y=$S($D(^XUTL("ZISPARAM",$I)):^($I),1:"") S:Y'["F" Y=Y_"F" U $I:("":Y:$C(13,27)) S ^($I)=Y
 ;;PASSALL
 ;;S Y=$S($D(^XUTL("ZISPARAM",$I)):^($I),1:""),Y=$TR(Y,"IT",""),Y=Y_"I" U $I:("":Y) S ^($I)=Y
 ;;PRIINQ;; Priority in current queue
 ;;S Y=8
 ;;PRIORITY;;set priority to X (1=low, 10=high)
 ;;D @($S(X>7:"HIGH",X>3:"NORMAL",1:"LOW")_"^%PRIO")
 ;;PROGMODE
 ;;S Y=$ZJ#2
 ;;PROD
 ;;DRA0:[EXPORT]
 ;;RD
 ;;D ^%RD
 ;;RM
 ;;U $I:X
 ;;RSEL;;ROUTINE SELECT
 ;;K ^UTILITY($J) S %JO=$J D ^%RSET K %ST
 ;;RSUM
 ;;ZL @X S Y=0 F %=1,3:1 S %1=$T(+%),%3=$F(%1," ") Q:'%3  S %3=$S($E(%1,%3)'=";":$L(%1),$E(%1,%3+1)=";":$L(%1),1:%3-2) F %2=1:1:%3 S Y=$A(%1,%2)*%2+Y
 ;;SS
 ;;D ^%SS
 ;;SAVE
 ;;S XCS="F XCM=1:1 S XCN=$O(@(DIE_XCN_"")"")) Q:+XCN'=XCN  S %=^(XCN,0) Q:$E(%,1)=""$""  I $E(%,1)'="";"" ZI %" X "ZR  X XCS ZS @X" S ^UTILITY("ROU",X)="" K XCS
 ;;SIZE
 ;;S Y=0 F I=1:1 S %=$T(+I) Q:%=""  S Y=Y+$L(%)+2
 ;;TEST
 ;;I $D(^ROUTINE(X))>1
 ;;TMK;;MAGTAPE MARK
 ;;S Y=$ZA\4#2
 ;;TRAP;;S X="^%ET",@^%ZOSF("TRAP") TO SET ERROR TRAP
 ;;$ZT=X
 ;;TRMOFF
 ;;S Y=$S($D(^XUTL("ZISPARAM",$I)):^($I),1:""),Y=$TR(Y,"IT","") U $I:("":Y:$C(13,27)) S ^($I)=Y
 ;;TRMON
 ;;S Y=$S($D(^XUTL("ZISPARAM",$I)):^($I),1:""),Y=$TR(Y,"IT",""),Y=Y_"IT" U $I:("":Y) S ^($I)=Y
 ;;TRMRD
 ;;S Y=$A($ZB)
 ;;TYPE-AHEAD
 ;;S Y=$S($D(^XUTL("ZISPARAM",$I)):^($I),1:"") S:Y["F" Y=$TR(Y,"F","") U $I:("":Y:$C(13,27)) S ^($I)=Y
 ;;UCI
 ;;D UCI^%ZOSV
 ;;UCICHECK
 ;;S Y=$$UCICHECK^%ZOSV(X)
 ;;UPPERCASE
 ;;S Y=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;;XY
 ;;S $X=DX,$Y=DY
 ;;VOL;;VOLUME SET NAME
 ;;DRA0:[EXPORT]
 ;;ZD
 ;;S Y=$ZD(X)
