PRSDEU07 ;HISC/GWB-PAID EDIT AND UPDATE DOWNLOAD RECORD 7 LAYOUT ;08/13/01
 ;;4.0;PAID;**34,69**;Sep 21, 1995
 F CC=1:1 S GRP=$T(@CC) Q:GRP=""  S GRPVAL=$P(RCD,":",CC) I GRPVAL'="" S GNUM=$P(GRP,";",4),LTH=$P(GRP,";",5),PIC=$P(GRP,";",6) D:PIC=9 PIC9^PRSDUTIL F EE=1:1:GNUM S FLD=$T(@CC+EE) D EPTSET^PRSDSET
 Q
RECORD ;;Record 7;10
 ;;
1 ;;Group 1;2;7;X
 ;;MDOTFZC1;OTHER TAX FROZEN CODE-1;1;1;OTHER;13;;;;312
 ;;MDOTGSA1;OTHER TAX GSA CODE-1;2;7;OTHER;17;;;;316
 ;;
2 ;;Group 2;1;9;9
 ;;MDOTGSS1;OTHER TAX GROSS PAY YTD-1;1;9;OTHER;15;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;314
 ;;
3 ;;Group 3;2;7;X
 ;;MDOTFZC2;OTHER TAX FROZEN CODE-2;1;1;OTHER;14;;;;313
 ;;MDOTGSA2;OTHER TAX GSA CODE-2;2;7;OTHER;18;;;;317
 ;;
4 ;;Group 4;1;9;9
 ;;MDOTGSS2;OTHER TAX GROSS PAY YTD-2;1;9;OTHER;16;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;315
 ;;
5 ;;Group 5;2;12;9
 ;;MDFDAMEX;FTL EXEMPTED AMT EPPD;1;5;FED;10;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;221
 ;;MDFDBAL;FTL DEBT BALANCE;6;12;FED;9;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;220
 ;;
6 ;;Group 6;1;1;X
 ;;MDOPT-DEDUCTION-IND;OCC PRIV TAX DEDUCTION IND;1;1;OTHER;6;;;;305
 ;;
7 ;;Group 7;9;51;X
 ;;MEEXLWOP;EXTENDED LWOP IND;1;1;LWOP;1;;;;515
 ;;MELWOPCT;LWOP CONTROL UNITS LYTD;2;4;LWOP;4;D SIGN^PRSDUTIL S DATA=+DATA;;;518
 ;;MELWPAYR;LWOP WG/PW PYTD;5;9;LWOP;10;D SIGN^PRSDUTIL S DATA=+DATA;;;524
 ;;MELWOPYR;LWOP LYTD;10;16;LWOP;6;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;520
 ;;MELWPCAL;LWOP CCY;17;23;LWOP;3;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;517
 ;;MELWPSTP;LWOP THIS STEP;24;30;LWOP;9;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;523
 ;;MELWPPRB;LWOP PROB PD;31;37;LWOP;7;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;521
 ;;MELWPPRO;LWOP SINCE PROM;38;44;LWOP;8;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;522
 ;;MEPTIHRS;PART TIME/INTERMIT HRS TOTAL;45;51;1;23;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;70
 ;;
8 ;;Group 8;12;48;X
 ;;MECRCALY;INTMT EMP DAYS WORKED YTD;1;5;MISC4;15;D SIGN^PRSDUTIL,D^PRSDUTIL;;;454
 ;;MECRISTP;INTMT EMP DAYS WORKED STEP;6;10;MISC4;14;D SIGN^PRSDUTIL,D^PRSDUTIL;;;453
 ;;MECRPRB;INTMT EMP DAYS WORKED PROB PD;11;15;MISC4;13;D SIGN^PRSDUTIL,D^PRSDUTIL;;;452
 ;;MEANNLVP;PAYABLE ANNUAL LEAVE;16;18;T38;19;D SIGN^PRSDUTIL S DATA=+DATA;;;137
 ;;MEANRYR1;RESTORED ANNUAL LEAVE YEAR-1;19;19;ANNUAL;12;;;;471
 ;;MEANRLV1;RESTORED ANNUAL LEAVE BAL-1;20;24;ANNUAL;10;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;469
 ;;MEANRYR2;RESTORED ANNUAL LEAVE YEAR-2;25;25;ANNUAL;13;;;;472
 ;;MEANRLV2;RESTORED ANNUAL LEAVE BAL-2;26;30;ANNUAL;11;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;470
 ;;MENPANNL;NON-PAYABLE ANNUAL LEAVE;31;33;T38;18;D SIGN^PRSDUTIL S DATA=+DATA;;;136
 ;;MEBPAYRT;BASE PAY AMT PRIOR TO RET COV;34;42;PAY;1;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;534
 ;;MEINDMIL;MILITARY LEAVE ELIGIBILITY IND;43;43;MILITARY;2;S:DATA=0 DATA="";;;507
 ;;MEMILLEV;MILITARY LEAVE BALANCE;44;48;MILITARY;1;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;506
 ;;
9 ;;Group 9;13;63;X
 ;;MFCNTLNO;ACSB CONTROL NUMBER-1;1;5;ACSB;9;;;;244
 ;;MFACIND;ACSB CODE-1;6;6;ACSB;7;;;;242
 ;;MFPERFAC;ACSB FED/STATE PCT FACTOR-1;7;11;ACSB;13;D SIGN^PRSDUTIL,DDDD^PRSDUTIL;;;248
 ;;MFCURDED;ACSB CURRENT ALLOTMENT-1;12;18;ACSB;11;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;246
 ;;MFBPBAL;ACSB BACK PAY BALANCE-1;19;25;ACSB;2;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;237
 ;;MFBPDED;ACSB BACK PAY DEDUCTION-1;26;30;ACSB;4;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;239
 ;;MFODCOD1;OTHER DEDUCTION CODE-1;31;33;OTHER;11;;;;310
 ;;MFODBID1;OTHER DEDUCTION BIWEEKLY AMT-1;34;38;OTHER;9;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;308
 ;;MFODBAL1;OTHER DEDUCTION BALANCE-1;39;45;OTHER;7;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;306
 ;;MFODCOD2;OTHER DEDUCTION CODE-2;46;48;OTHER;12;;;;311
 ;;MFODBID2;OTHER DEDUCTION BIWEEKLY AMT-2;49;53;OTHER;10;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;309
 ;;MFODBAL2;OTHER DEDUCTION BALANCE-2;54;60;OTHER;8;D SIGN^PRSDUTIL,DD^PRSDUTIL;;;307
 ;;MFCOLAPC;COLA;61;63;COLA;3;D SIGN^PRSDUTIL,DDD^PRSDUTIL;;;529
10 ;;Group 10;4;16;X
 ;;MDSTAFFD;STAFFING DIFFERENTIAL PCT;1;5;MISC;10;D SIGN^PRSDUTIL,DDDD^PRSDUTIL;;;606
 ;;MDSUPDIF;SUPERVISORY DIFFERENTIAL;6;10;MISC;11;D SIGN^PRSDUTIL;;;607
 ;;MDRETALLOW;RETENTION ALLOWANCE PCT;11;15;MISC;12;D SIGN^PRSDUTIL,DDDD^PRSDUTIL;;;608
 ;;MDJOBSHR;JOB SHARE;16;16;MISC;13;;;;609
