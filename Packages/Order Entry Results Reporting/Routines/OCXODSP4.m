OCXODSP4 ;SLC/RJS,CLA -  Rule Display (Display a MetaDictionary Link) ;10/29/98  12:37
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
EN(OCXLINK,OCXTAB,OCXRM,OCXCON) ;
 ;
 N OCXD0,OCXD1,OCXD,OCXRD,OCXE,OCXSUB,OCXPAR,OCXSP,OCXMAX
 ;
 I '$L(OCXLINK) W !! D FIELD("Metadictionary Link:"," ** ERROR ** Link not found ",OCXTAB,OCXRM)
 ;
 S OCXD0=$O(^OCXS(863.3,"B",OCXLINK,0))
 I 'OCXD0 W !! D FIELD("Metadictionary Link:"," '"_OCXLINK_"' ** ERROR ** Link not found ",OCXTAB,OCXRM)
 S OCXTAB=+$G(OCXTAB)
 ;
 S OCXRD="" D DIQ("^OCXS(863.3,",OCXD0,.OCXRD)
 F OCXSUB="PAR" S OCXD1=0 F  S OCXD1=$O(^OCXS(863.3,OCXD0,OCXSUB,OCXD1)) Q:'OCXD1  D
 .S OCXD(0)=OCXD0,OCXD=OCXD1 D DIQ("^OCXS(863.3,"_OCXD0_","""_OCXSUB_""",",.OCXD,.OCXRD)
 ;
 W !
 W ! D FIELD("Metadictionary Link:",OCXRD(863.3,OCXD0,.01,"E"),OCXTAB,OCXRM)
 W ! D FIELD("          Attribute:",OCXRD(863.3,OCXD0,.05,"E"),OCXTAB,OCXRM)
 W ! D FIELD("          Data Type:",$$DTYP(OCXRD(863.3,OCXD0,.05,"I")),OCXTAB,OCXRM)
 ;
 S (OCXMAX,OCXD1)=0 F  S OCXD1=$O(OCXRD(863.32,OCXD1)) Q:'OCXD1  D
 .I $D(OCXRD(863.32,OCXD1,.01,"E")),$D(OCXRD(863.32,OCXD1,1,"E")) D
 ..N PARNAME S PARNAME=OCXRD(863.32,OCXD1,.01,"E") S:($L(PARNAME)>OCXMAX) OCXMAX=$L(PARNAME)+2
 ;
 S OCXSP="",$P(OCXSP," ",OCXMAX+10)=" ",OCXD1=0 F  S OCXD1=$O(OCXRD(863.32,OCXD1)) Q:'OCXD1  D
 .I $D(OCXRD(863.32,OCXD1,.01,"E")),$D(OCXRD(863.32,OCXD1,1,"E")) D
 ..N PARNAME,PARVAL S PARNAME=OCXRD(863.32,OCXD1,.01,"E"),PARVAL=OCXRD(863.32,OCXD1,1,"E")
 ..S PARNAME=$E(OCXSP,$L(PARNAME),OCXMAX)_PARNAME W ! D FIELD(PARNAME_":",PARVAL,OCXTAB,OCXRM)
 ;
 Q
 ;
DTYP(ATTR) ;
 ;
 N OCXDTYP,PARNUM
 Q:'ATTR " ** ATTRIBUTE NOT DEFINED ** "
 Q:'$D(^OCXS(863.4,ATTR,0)) " ** ATTRIBUTE '"_ATTR_"' NOT DEFINED ** "
 S OCXDTYP=$O(^OCXS(863.8,"B","DATA TYPE",0)) Q:'OCXDTYP " ** NOT IN PARAMETER FILE **"
 S PARNUM=$O(^OCXS(863.4,ATTR,"PAR","B",OCXDTYP,0)) Q:'PARNUM " ** DATA TYPE NOT SPECIFIED **"
 S OCXDTYP=$G(^OCXS(863.4,ATTR,"PAR",PARNUM,"VAL")) Q:'$L(OCXDTYP) " ** DATA TYPE NOT SPECIFIED **"
 Q OCXDTYP
 ;
PARNUM(OCXOPER) ;
 ;
 N OCXPF,OCXPFN
 S OCXPF=$O(^OCXS(863.9,+OCXOPER,"PAR","B","OCXO GENERATE CODE FUNCTION",0)) Q:'OCXPF 0
 S OCXPF=$G(^OCXS(863.9,+OCXOPER,"PAR",+OCXPF,"VAL"))
 Q:'$L(OCXPF) 0
 I OCXPF S OCXPFN=OCXPF
 E  S OCXPFN=0 F  S OCXPFN=$O(^OCXS(863.7,"B",$E(OCXPF,1,30),OCXPFN)) Q:'OCXPFN  Q:($P($G(^OCXS(863.7,+OCXPFN,0)),U,1)=OCXPF)
 Q:'OCXPFN 0 Q +$O(^OCXS(863.7,+OCXPFN,"PAR",999),-1)
 ;
FIELD(TITLE,STRING,TAB,MARGIN) ;
 ;
 W ?TAB,TITLE
 ;
 N PTR,SUBSTR,STRLEN
 ;
 S STRLEN=MARGIN-($L(TITLE)+TAB)-5
 S SUBSTR="" F PTR=1:1:$L(STRING," ") D
 .I ($L(SUBSTR)>STRLEN) W ?(TAB+$L(TITLE)+1),SUBSTR W:$L($P(STRING," ",PTR+1)) ! S SUBSTR=""
 .S:$L(SUBSTR) SUBSTR=SUBSTR_" " S SUBSTR=SUBSTR_$P(STRING," ",PTR)
 W:$L(SUBSTR) ?(TAB+$L(TITLE)+1),SUBSTR
 Q
 ;
DIC(OCXDIC,OCXDIC0,OCXDICA,OCXX,OCXDICS,OCXDR) ;
 ;
 N DIC,X,Y
 S DIC=$G(OCXDIC) Q:'$L(DIC) -1
 S DIC(0)=$G(OCXDIC0) S:$L($G(OCXX)) X=OCXX
 S:$L($G(OCXDICS)) DIC("S")=OCXDICS
 S:$L($G(OCXDICA)) DIC("A")=OCXDICA
 S:$L($G(OCXDR)) DIC("DR")=OCXDR
 D ^DIC Q:(Y<1) 0 Q Y
 ;
 ;
DIQ(DIC,DA,OCXARY) ;
 ;
 N DR,DIQ S DR=".01:99999",DIQ="OCXARY(",DIQ(0)="IEN" D EN^DIQ1
 Q
 ;
MULT(OCXD0,OCXTAB,OCXRM) ;
 ;
 Q
 ;
