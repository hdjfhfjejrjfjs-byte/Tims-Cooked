0xfffffe000b2fff68  00c80591 add      x0, x0, #0x172
0xfffffe000b2fff6c  9d94fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b2fff70  882500f0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b2fff74  008107f9 str      x0, [x8, #0xf00]
0xfffffe000b2fff78  00eefdd0 adrp     x0, #0xfffffe00070c1000; page 0xfffffe00070c1000
0xfffffe000b2fff7c  00280691 add      x0, x0, #0x18a; 0xfffffe00070c118a STR "IOPriorityPowerStateInterest"
0xfffffe000b2fff80  9894fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b2fff84  882500f0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b2fff88  002507f9 str      x0, [x8, #0xe48]
0xfffffe000b2fff8c  00eefdd0 adrp     x0, #0xfffffe00070c1000; page 0xfffffe00070c1000
0xfffffe000b2fff90  009c0691 add      x0, x0, #0x1a7; 0xfffffe00070c11a7 STR "IOConsoleSecurityInterest"
0xfffffe000b2fff94  9394fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b2fff98  882500d0 adrp     x8, #0xfffffe000b7b1000; page 0xfffffe000b7b1000
0xfffffe000b2fff9c  005500f9 str      x0, [x8, #0xa8]
0xfffffe000b2fffa0  40eefdb0 adrp     x0, #0xfffffe00070c8000; page 0xfffffe00070c8000
0xfffffe000b2fffa4  00843691 add      x0, x0, #0xda1; 0xfffffe00070c8da1 STR "IOBSD"
0xfffffe000b2fffa8  8e94fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b2fffac  882500f0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b2fffb0  009d04f9 str      x0, [x8, #0x938]
0xfffffe000b2fffb4  40eefdb0 adrp     x0, #0xfffffe00070c8000; page 0xfffffe00070c8000
0xfffffe000b2fffb8  009c3691 add      x0, x0, #0xda7; 0xfffffe00070c8da7 STR "BSD Name"
0xfffffe000b2fffbc  8994fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b2fffc0  882500d0 adrp     x8, #0xfffffe000b7b1000; page 0xfffffe000b7b1000
0xfffffe000b2fffc4  005900f9 str      x0, [x8, #0xb0]
0xfffffe000b2fffc8  40eefdd0 adrp     x0, #0xfffffe00070c9000; page 0xfffffe00070c9000
0xfffffe000b2fffcc  00c00e91 add      x0, x0, #0x3b0; 0xfffffe00070c93b0 STR "BSD Major"
0xfffffe000b2fffd0  8494fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b2fffd4  882500d0 adrp     x8, #0xfffffe000b7b1000; page 0xfffffe000b7b1000
0xfffffe000b2fffd8  005d00f9 str      x0, [x8, #0xb8]
0xfffffe000b2fffdc  40eefdd0 adrp     x0, #0xfffffe00070c9000; page 0xfffffe00070c9000
0xfffffe000b2fffe0  00e80e91 add      x0, x0, #0x3ba; 0xfffffe00070c93ba STR "BSD Minor"
0xfffffe000b2fffe4  7f94fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b2fffe8  882500d0 adrp     x8, #0xfffffe000b7b1000; page 0xfffffe000b7b1000
0xfffffe000b2fffec  006100f9 str      x0, [x8, #0xc0]
0xfffffe000b2ffff0  20eefdb0 adrp     x0, #0xfffffe00070c4000; page 0xfffffe00070c4000
0xfffffe000b2ffff4  00183491 add      x0, x0, #0xd06; 0xfffffe00070c4d06 STR "BSD Unit"
0xfffffe000b2ffff8  7a94fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b2ffffc  882500d0 adrp     x8, #0xfffffe000b7b1000; page 0xfffffe000b7b1000
0xfffffe000b300000  006500f9 str      x0, [x8, #0xc8]
0xfffffe000b300004  93250090 adrp     x19, #0xfffffe000b7b0000; page 0xfffffe000b7b0000
0xfffffe000b300008  73420891 add      x19, x19, #0x210; 0xfffffe000b7b0210 ?
0xfffffe000b30000c  700240f9 ldr      x16, [x19]; [0xfffffe000b7b0210] ?
0xfffffe000b300010  f10313aa mov      x17, x19
0xfffffe000b300014  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b300018  301ac1da autda    x16, x17
0xfffffe000b30001c  088e46f8 ldr      x8, [x16, #0x68]!
0xfffffe000b300020  e00313aa mov      x0, x19
0xfffffe000b300024  30c0e2f2 movk     x16, #0x1601, lsl #48
0xfffffe000b300028  10093fd7 blraa    x8, x16
0xfffffe000b30002c  f40300aa mov      x20, x0
0xfffffe000b300030  800200b4 cbz      x0, #0xfffffe000b300080
0xfffffe000b300034  900240f9 ldr      x16, [x20]
0xfffffe000b300038  f10314aa mov      x17, x20
0xfffffe000b30003c  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b300040  301ac1da autda    x16, x17
0xfffffe000b300044  080e4df8 ldr      x8, [x16, #0xd0]!
0xfffffe000b300048  e00314aa mov      x0, x20
0xfffffe000b30004c  21008052 mov      w1, #1
0xfffffe000b300050  5080f3f2 movk     x16, #0x9c02, lsl #48
0xfffffe000b300054  10093fd7 blraa    x8, x16
0xfffffe000b300058  40010037 tbnz     w0, #0, #0xfffffe000b300080
0xfffffe000b30005c  e80314aa mov      x8, x20
0xfffffe000b300060  28b4f9f2 movk     x8, #0xcda1, lsl #48
0xfffffe000b300064  900240f9 ldr      x16, [x20]
0xfffffe000b300068  1019c1da autda    x16, x8
0xfffffe000b30006c  088e42f8 ldr      x8, [x16, #0x28]!
0xfffffe000b300070  e00314aa mov      x0, x20
0xfffffe000b300074  f050e7f2 movk     x16, #0x3a87, lsl #48
0xfffffe000b300078  10093fd7 blraa    x8, x16
0xfffffe000b30007c  140080d2 mov      x20, #0
0xfffffe000b300080  a82a00d0 adrp     x8, #0xfffffe000b856000; page 0xfffffe000b856000
0xfffffe000b300084  141d03f9 str      x20, [x8, #0x638]
