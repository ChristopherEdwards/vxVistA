XBDHD2 ; IHS/ADC/GTH - SPECIAL CHOICES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
NEW ;
 NEW XBDHFROM,XBDHI,XBDHTEMP,XBDHTO
 ; 
START ;
 I $D(XBDHECHN) S XBDHCHN=XBDHECHN,XBDHX=^TMP("XBDH",$J,"HEADER",XBDHCHN),XBDHHDR=$P(XBDHX,V,3),XBDHHDW=$P(XBDHX,V,4)
 W "EDITING HEADER LINE SEGMENT """,$C(64+XBDHCHN),"""     FIELD = """,$P(^TMP("XBDH",$J,"HEADER",XBDHCHN),V,2),"""",!
 F XBDHI=1:1:7 W $E($T(TEXT+XBDHI),4,99),!
 W !
CNEXT ;
 S DIR(0)="NO^1:8:",DIR("A")="Your choice",DIR("?")="Enter the number of the editing function or <CR> to go on"
 D ^DIR
 KILL DIR
 S XBDHX=Y
 I "^"[XBDHX KILL XBDHECHN Q
 G @("C"_XBDHX)
 ; 
C1 ;
 S $P(^TMP("XBDH",$J,"HEADER",XBDHCHN),V,5)=(XBDHHDW-$L(XBDHHDR))\2
 D ^XBDHD1
 G START
 ; 
C2 ;
 S $P(^TMP("XBDH",$J,"HEADER",XBDHCHN),V,5)=0
 D ^XBDHD1
 G START
 ; 
C3 ;
 W !!
C31 ;
 S DIR(0)="NO^"_$L(XBDHHDR)_":"_(XBDHNSL+XBDHHDW)_":",DIR("A")="New field width"
 D ^DIR
 KILL DIR
 S XBDHX=Y
 I "^"[XBDHX G START
 I XBDHX'=+XBDHX W *13,$J("",IOM),*13,*7,*7 G C31
 I (XBDHX<$L(XBDHHDR))!(XBDHX>(XBDHNSL+XBDHHDW)) W *7,*7,*13,$J("",IOM),*13 G C31
 S XBDHHDW=XBDHX,$P(^TMP("XBDH",$J,"HEADER",XBDHCHN),V,4)=XBDHX G:$E($P(^(XBDHCHN),V,5)) C1
 D ^XBDHD1
 G START
 ; 
C4 ;
 W !!
 S DIR(0)="FO^1:"_XBDHHDW_"",DIR("A")="New header name"
 D ^DIR
 KILL DIR
 S XBDHX=Y
 I XBDHX="" G C8
 I XBDHX=U G START
 I $P(^TMP("XBDH",$J,"HEADER",XBDHCHN),V,5) S $P(^TMP("XBDH",$J,"HEADER",XBDHCHN),V,3)=XBDHX,XBDHHDR=XBDHX G C1
 S $P(^TMP("XBDH",$J,"HEADER",XBDHCHN),V,3)=XBDHX
 D ^XBDHD1
 G START
 ; 
C5 ;
 S $P(^TMP("XBDH",$J,"HEADER",XBDHCHN),V,6)="+"
 W !!,"ENTRIES RIGHT JUSTIFIED TO A WIDTH OF ",XBDHHDW," COLUMNS"
 H 2
 D ^XBDHD1
 G START
 ; 
C6 ;
 S $P(^TMP("XBDH",$J,"HEADER",XBDHCHN),V,7)="+"
 W !!,"ENTRIES WILL BE WORD WRAPPED TO A WIDTH OF ",XBDHHDW," COLUMNS"
 H 2
 D ^XBDHD1
 G START
 ; 
C7 ;
 I '$D(XBDHECHN) KILL ^TMP("XBDH",$J,"HEADER",XBDHCHN) D ^XBDHD1 Q
 S X=""
 F L=0:0 S X=$O(^TMP("XBDH",$J,"HEADER",X)) Q:X=""  S ^TMP("XBDH",$J,"HT",X)=^TMP("XBDH",$J,"HEADER",X) W "."
 S XBDHTEMP=^TMP("XBDH",$J,"HEADER")
 KILL ^TMP("XBDH",$J,"HT",XBDHECHN),^TMP("XBDH",$J,"HEADER")
 S X=""
 F I=1:1 S X=$O(^TMP("XBDH",$J,"HT",X)) Q:X=""  S ^TMP("XBDH",$J,"HEADER",I)=^TMP("XBDH",$J,"HT",X) W "."
 S ^TMP("XBDH",$J,"HEADER")=XBDHTEMP
 KILL ^TMP("XBDH",$J,"HT"),XBDHTEMP
 KILL XBDHECHN
 D ^XBDHD1
 Q
 ; 
C8 ;
 S XBDHFROM=$S($D(XBDHECHN):XBDHECHN,1:XBDHCHN),XBDHFROM=$C(64+XBDHFROM)
 S X=""
 F XBDHTCHN=0:1 S X=$O(^TMP("XBDH",$J,"HEADER",X)) Q:X=""  S ^TMP("XBDH",$J,"HT",X)=^(X) W "." S Y="" F L=0:0 S Y=$O(^TMP("XBDH",$J,"HEADER",X,Y)) Q:Y=""  S ^TMP("XBDH",$J,"HT",X,Y)=^(Y)
 I XBDHCHN<2 W *7,*13,$J("",IOM),*13 G CNEXT
 W *13,$J("",IOM),*13
 ; 
MOVE ;
 S DIR(0)="FO^",DIR("A")="Where do you want to move this header (A - "_$C(64+XBDHTCHN)_")",DIR("?")="Enter a letter which corresponds to a header line field"
 D ^DIR
 KILL DIR
 S XBDHTO=Y
 I "^"[XBDHTO W ! G START
 I XBDHTO'?1U W *7,*7,*13,$J("",IOM),*13 G MOVE
 I XBDHTO]$C(64+XBDHCHN) W *7,*7,*13,$J("",IOM),*13 G MOVE
 I XBDHFROM=XBDHTO W *7,*13,$J("",IOM),*13 G MOVE
 S XBDHFROM=$A(XBDHFROM)-64,XBDHTO=$A(XBDHTO)-64
 S XBDHX=XBDHTO+.1
 S:(XBDHFROM>XBDHTO) XBDHX=XBDHTO-.1
 S ^TMP("XBDH",$J,"HT",XBDHX)=^TMP("XBDH",$J,"HEADER",XBDHFROM)
 S Y=""
 F L=0:0 S Y=$O(^TMP("XBDH",$J,"HEADER",XBDHFROM,Y)) Q:Y=""  S ^TMP("XBDH",$J,"HT",XBDHX,Y)=^TMP("XBDH",$J,"HEADER",XBDHFROM,Y)
 S XBDHTEMP=^TMP("XBDH",$J,"HEADER")
 KILL ^TMP("XBDH",$J,"HT",XBDHFROM),^TMP("XBDH",$J,"HEADER")
 S X=""
 F I=1:1 S X=$O(^TMP("XBDH",$J,"HT",X)) Q:X=""  S ^TMP("XBDH",$J,"HEADER",I)=^TMP("XBDH",$J,"HT",X) S Y="" F L=0:0 S Y=$O(^TMP("XBDH",$J,"HT",X,Y)) Q:Y=""  S ^TMP("XBDH",$J,"HEADER",I,Y)=^TMP("XBDH",$J,"HT",X,Y)
 S ^TMP("XBDH",$J,"HEADER")=XBDHTEMP
 KILL ^TMP("XBDH",$J,"HT"),XBDHTEMP,XBDHECHN
 D ^XBDHD1
 G START
 ; 
TEXT ; 
 ;;DO YOU WANT TO MAKE ANY OTHER CHANGES TO THIS HEADER OR ITS FIELD?
 ;;
 ;;  <CR> ACCEPT HEADER AS IS            
 ;;  1) CENTER HEADER WITHIN FIELD       5) RIGHT JUSTIFY ENTRIES
 ;;  2) UNCENTER HEADER                  6) WORD WRAP ENTRIES
 ;;  3) CHANGE FIELD WIDTH               7) REMOVE THIS HEADER
 ;;  4) CHANGE HEADER NAME               8) MOVE THIS HEADER
 ; 
NOTES ; 
 ; MAKES SECONDARY EDITING CHANGES AFTER EACH FIELD IS ENTERED
 ; INPUT = XBDHCHN OR XBDHECHN (XBDHECHN IS THE .A OR .B CHN),^TMP("XBDH",$J,"HEADER",CHN),XBDHTHLW
 ; OUTPUT = RESET ^TMP("XBDH",$J,"HEADER",CHN)
 ; TO INSERT A NEW FIELD SIMPLY APPEND IT TO THE END OF THE LINE AND THE MOVE IT
