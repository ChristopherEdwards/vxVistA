QACOPEN ;WCIOFO/VAD-Open Status ;12/08/98
 ;;2.0;Patient Representative;**9,17**;07/25/1995
 ;
MAIN ;
 S QAQPOP=0
 D DATDIV^QACUTL0 G:QAQPOP EXIT
 K DIC,FLDS,L,BY,FR,TO,DHD
 S L=0,DIC="^QA(745.1,"
 S FLDS="[QAC STATUS]",DHD="[QAC STATUS HEADER]"
 ;
 I +$G(QACDV)=1 D
 . S BY="37;S3;C25,'1,@27"
 . S FR(1)="@",TO(1)=""
 . I +$G(QAC1DIV) D
 . . S QACDVNAM=""
 . . D INST^QACUTL0(QAC1DIV,.QACDVNAM)
 . . S (FR(1),TO(1))=QACDVNAM
 . S FR(2)=QAQNBEG,TO(2)=QAQNEND
 . S (FR(3),TO(3))="O"
 D EN1^DIP
EXIT ;
 K DIC,FLDS,L,BY,FR,TO,DHD,DIP,QACDV,QAC1DIV,QAQPOP,QACDVNAM
 K QAQNBEG,QAQNEND
 D K^QAQDATE
 Q
