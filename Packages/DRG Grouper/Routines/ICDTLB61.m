ICDTLB61 ;SSI/ALA-GROUPER UTILITY FUNCTIONS [ 10/9/03  6:28 PM ] ; 10/23/00 11:50am
 ;;18.0;DRG Grouper;**10,22**;Oct 20, 2000
DRG412 ;
 I $D(ICDDX(1))&(ICDOPCT=0) D  Q:ICDRG=409
 .I ICDDX(1)=$O(^ICD9("AB","V58.0 ",0)) S ICDRG=409 Q
 .I ICDDX(1)=$O(^ICD9("AB","V67.1 ",0)) S ICDRG=409 Q
 .Q
 I $D(ICDDX(1))&(ICDOPCT=0) D  Q:"410^492"[ICDRG
 .I ICDDX(1)=$O(^ICD9("AB","V58.11 ",0)) S ICDRG=$S(ICDSD["2":492,1:410) Q
 .I ICDDX(1)=$O(^ICD9("AB","V58.12 ",0)) S ICDRG=$S(ICDSD["2":492,1:410) Q
 .I ICDDX(1)=$O(^ICD9("AB","V67.2 ",0)) S ICDRG=$S(ICDSD["2":492,1:410) Q
 I ICDPD["L" D DRG539^ICDTLB6 Q
 I ICDOR["N"&($D(ICDPDRG(412))) S ICDRG=412 Q
 I $D(ICDPDRG(412))&(ICDPD'["L") S ICDRG=411 Q
 I ICDCC S ICDRG=413 Q
 S ICDRG=414
 ;I $O(ICDPDRG(0))<ICDRG S ICDRG=$O(ICDPDRG(0)) D DODRG^ICDDRG0
 Q
