XDRERR ;IHS/OHPRD/JCM -    [ 08/13/92  09:50 AM ]
 ;;7.3;TOOLKIT;;Apr 25, 1995
START ;
 ;
 K XMB
 S XMB(1)="TEST ROUTINE MISSING"
 D NOW^%DTC S Y=X X ^DD("DD") S XMB(2)=Y
 S XMB="XDR DUP CHECK FAILURE"
 ;S XDRDUZ=DUZ,DUZ=.5 D ^XMB S DUZ=XDRDUZ
 K XMB,XDRDUZ
 Q
EOJ ;
 Q
