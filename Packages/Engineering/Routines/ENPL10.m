ENPL10 ;(WASH ISC)/LKG-VAF 10-1193 FORM ;6/23/93  14:42
 ;;7.0;ENGINEERING;;Aug 17, 1993
A S DIC="^ENG(""PROJ"",",DIC(0)="AEMQZ",DIC("A")="Select PROJECT NUMBER: "
 D ^DIC K DIC
 I Y<1!$D(DTOUT)!$D(DUOUT) G EX
 S ENDA=+Y,ENPC=$P(Y(0),U,6) K Y
 L +^ENG("PROJ",ENDA):5 E  W *7,!,"File is use, Please try later!" G A
B S %ZIS="PQ" D ^%ZIS I POP L -^ENG("PROJ",ENDA) G EX
 I IOM<132 K IO("Q") D:IO'=IO(0) ^%ZISC W *7,!,"Must Support 132 Character Display" G B
 I $D(IO("Q")) S ZTRTN="IN^ENPL10",ZTDESC="Printing VAF 10-1193",ZTSAVE("ENDA")="",ZTSAVE("ENPC")="",ZTSAVE("DUZ")="" D ^%ZTLOAD,HOME^%ZIS L -^ENG("PROJ",ENDA) K IO("Q"),ZTSK,ZTRTN,ZTDESC,ZTSAVE,ENDA,ENPC G A
IN I $D(ZTQUEUED) L +^ENG("PROJ",ENDA)
 D:'$D(DT) DT^DICRW U IO
 K DXS,D0 S D0=ENDA D ^ENPLPB K DXS,D0
 I $E(IOST,1,2)="C-",'$D(ZTQUEUED) R !,"Hit <RETURN> to Continue; '^' to Quit",ENX:DTIME
 I $G(ENX)["^"!$D(DTOUT)!$D(DUOUT) G CL
 W @IOF
 S D0=ENDA D @$S(ENPC="NR":"^ENPLPA",1:"^ENPLPD") K DXS,D0
 I $E(IOST,1,2)="C-",'$D(ZTQUEUED) R !,"Hit <RETURN> to Continue",ENX:DTIME W @IOF
CL L -^ENG("PROJ",ENDA)
 K DIC,ENDA,ENPC,ENX,DTOUT,DUOUT,D,D0,D1,DIWL,DIWR,DIXX,DN,Y
 D ^%ZISC
 I $D(ZTQUEUED) S ZTREQ="@" Q
 G A
EX K DTOUT,DUOUT,ENDA,ENPC,Y
 Q
