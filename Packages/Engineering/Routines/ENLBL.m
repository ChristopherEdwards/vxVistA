ENLBL ;(WASH ISC)/DH-Bar Code Label Print Driver ;3-26-92
V ;;7.0;ENGINEERING;;Aug 17, 1993
 D:'$D(DT) DT^DICRW S U="^",S=";",O=$T(OPT) I $D(^DOPT($P(O,S,5),"VERSION")),($P($T(V),S,3)=^DOPT($P(O,S,5),"VERSION")) G IN
 K ^DOPT($P(O,S,5))
 F I=1:1 Q:$T(OPT+I)=""  S ^DOPT($P(O,S,5),I,0)=$P($T(OPT+I),S,3),^DOPT($P(O,S,5),"B",$P($P($T(OPT+I),S,3),"^",1),I)=""
 S K=I-1,^DOPT($P(O,S,5),0)=$P(O,S,4)_U_1_U_K_U_K K I,K,X S ^DOPT($P(O,S,5),"VERSION")=$P($T(V),S,3)
IN I $P(O,S,6)'="" D @($P(O,S,6))
PR S O=$T(OPT),S=";" S IOP="HOME" D ^%ZIS W:IOST'["PK-" @IOF K IOP
 D HDR F J=1:1 Q:'$D(^DOPT($P(O,S,5),J,0))  W !,?15,J,". ",$P(^DOPT($P(O,S,5),J,0),U,1)
RE W ! S DIC("A")="Select "_$P($T(OPT),S,4)_": EXIT// ",DIC="^DOPT("_""""_$P($T(OPT),S,5)_""""_",",DIC(0)="AEQMN" D ^DIC G:X=""!(X=U) EXIT G:Y<0 RE K DIC,J,O D @($P($T(OPT+Y),S,4)) G PR
HDR W @IOF,!!,"BARCODE LABEL MODULE (Equipment)",!,$P($T(V),S,3),! Q
INIT S:'$D(DTIME) DTIME=600 S ENERR=0,IOP="HOME",U="^" D ^%ZIS K IOP Q
EXIT K DIC,ENERR,I,J,K,O,S,X,Y
OPT ;;BARCODE LABEL MODULE (Equipment);BARCODE LABEL PRINTING MENU;ENEQLBL
 ;;LOCATION LABELS;^ENLBL1
 ;;EQUIPMENT LABELS;^ENLBL2
