OCXDI001 ;SLC/RJS,CLA - OCX PACKAGE DIAGNOSTIC ROUTINES ;SEP 7,1999 at 10:29
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^OCXDIAG
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXDIAG",$J,$O(^TMP("OCXDIAG",$J,"A"),-1)+1)=TEXT
 ;
 G ^OCXDI002
 ;
 Q
 ;
DATA ;
 ;
 ;;RSTRT
 ;;RTN^OCXBDT^8/04/98  13:21
 ;;RSUM^150.21^324.31^17096.221^35127.331^58062.411^338615.1031^8688.171^8714.171^150.21^57808.351^150.21^29759.271^150.21^56000.361^150.21^174533.641^150.21^168593.631^150.21^168681.631^150.21^168769.631
 ;;RSUM^150.21^168857.631^150.21^168945.631^150.21^169033.631^150.21^45534.371^150.21^76370.441^150.21^194.21^150.21^24345.271^41556.331^9601.181^6555.141^25920.291^25984.291^17250.251^1992.71^70433.471^646.41
 ;;RSUM^150.21^86079.541^150.21
 ;;RND^OCXBDT^8/04/98  13:21
 ;;RTN^OCXBDT1^8/04/98  13:21
 ;;RSUM^150.21^324.31^150.21^150.21^6833.131^19171.231^99135.581^150.21^105886.581^150.21^188848.781^150.21^92443.571^150.21^194.21^150.21^46651.401^150.21^7062.151^150.21^70243.441^150.21^59244.371^140487.571
 ;;RSUM^44114.381^150.21^27158.311^212422.791^92855.551^150.21^91686.541^29303.291^94971.541^290568.951^56308.421^150.21^202162.801^211388.791^150.21^10106.191^150.21^200150.771^150.21^8516.161^150.21^82320.501
 ;;RSUM^150.21^2531.91^150.21^203644.731^7969.161^18693.201^150.21
 ;;RND^OCXBDT1^8/04/98  13:21
 ;;RTN^OCXBDT2^8/04/98  13:21
 ;;RSUM^150.21^324.31^150.21^150.21^17017.221^150.21^65540.461^199809.801^65120.461^198249.801^150.21^87109.591^12120.201^85758.541^229963.871^65765.471^70984.481^10252.171^212306.881^251531.851^66015.461
 ;;RSUM^9442.181^106286.581^274260.971^107382.621^66697.451^41617.361^85456.511^150.21^194.21^150.21^39303.381^150.21^18233.241^150.21^20607.281^5711.131^25460.291^15551.231^150.21^101871.581^131336.661^20314.261
 ;;RSUM^150.21^259609.971^59758.441^159348.721^150.21^194.21^150.21^28308.321^150.21^13339.201^11821.191^90522.541^150.21^44834.391^52529.431^77856.511^695142.1541^7539.141^77828.481^69542.451^75662.481^91402.541
 ;;RSUM^77454.501^73034.521^27198.261^31198.321^22973.271^21702.271^98723.581^48489.391^498.41^390828.1161^349919.1111^498.41^541090.1341^350433.1111^498.41^150.21^194.21^13270.201^150.21^3932.101^73507.471
 ;;RSUM^60715.431^18147.261^29321.321^28074.311^26392.301^26426.301^10962.201^24466.291^24490.291^24513.291^24367.291^24531.291^23094.281^23385.281^26184.301^24411.291^24435.291^24483.291^482.41^150.21
 ;;RND^OCXBDT2^8/04/98  13:21
 ;;RTN^OCXBDT3^8/04/98  13:21
 ;;RSUM^150.21^1023.61^150.21^38997.321^112066.631^251782.891^80453.501^198839.781^68339.461^286250.941^153084.691^150.21^4033.101^150.21^10987.181^150.21^16017.211^10424.171^51194.431^46107.401^45483.401
 ;;RSUM^43332.391^62635.461^11347.181^1182.61^9347.171^34644.301^7171.141^112066.631^1439.61^150.21^1467.71^3446.101^66277.451^56688.451^646.41^150.21^8671.161^150.21^33268.301^5255.121^12678.201^35262.331
 ;;RSUM^146271.681^150.21^361982.1091^150.21^24786.281^150.21^194.21^150.21^212769.821^150.21^100028.591^150.21^2605.91^110935.621^40274.391^642.41^150.21^1336.61^151058.641^6319.121^6330.121^750.51^1173.61
 ;;RSUM^750.51^10902.171^750.51^750.51^29813.291^204549.821^114493.621^750.51^5499.111^750.51^860.51^750.51^2670.91^533.41^150.21
 ;;RND^OCXBDT3^8/04/98  13:21
 ;;RTN^OCXBDT4^8/04/98  13:21
 ;;RSUM^150.21^1023.61^150.21^26864.271^55149.391^429260.1171^150.21^24786.281^150.21^98106.571^200703.791^150.21^1439.61^150.21^1336.61^180645.701^6319.121^6330.121^750.51^1173.61^750.51^860.51^750.51^6657.141
 ;;RSUM^750.51^10902.171^750.51^128020.601^750.51^38865.361^351159.1071^5234.131^750.51^233093.771^750.51^225901.861^166909.721^140662.661^122968.641^750.51^12198.211^750.51^89133.471^750.51^1388.71^750.51
 ;;RSUM^19519.241^750.51^10227.171^750.51^26114.271^750.51^53047.451^41281.371^750.51^101579.541^750.51^38845.371^4004.131^750.51^74134.491^10503.201^184705.751^27435.301^54509.411^750.51^2298.91^750.51^12086.191
 ;;RSUM^750.51^92175.531^750.51^4085.111^750.51^65232.411^144088.651^8984.161^17908.241^363590.1071^860.51^750.51^26785.281^750.51^12638.211^43958.351^153498.721^112491.571^341428.1081^12068.181^325417.971
 ;;RSUM^100996.571^157867.731^54186.401^3796.101^750.51^34593.321^750.51^57917.411^35084.321^213320.801^619508.1321^418943.1121^378837.1071^6498.151^16212.221^152992.691^336207.1061^750.51^2781.91^750.51^24827.271
 ;;RSUM^750.51^180987.801^1912.81^750.51^14718.211^64014.471^60074.431^195967.831^474778.1251^373535.1101^7276.161^117520.641^3300.101^750.51^23174.271^750.51^25263.311^8378.161^30803.321^19769.261^750.51
 ;1;
 ;
