DVBAXA3 ; ;06/08/01
 S X=DE(9),DIC=DIE
 ;
 S X=DE(9),DIC=DIE
 ;
 S X=DE(9),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DE(9),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".301;" D AVAFC^VAFCDD01(DA)
 S X=DE(9),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(9),DIIX=2_U_DIFLD D AUDIT^DIET