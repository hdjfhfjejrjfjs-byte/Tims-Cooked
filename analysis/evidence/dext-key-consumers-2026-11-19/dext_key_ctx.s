0xfffffe000b300240  900240f9 ldr      x16, [x20]
0xfffffe000b300244  1019c1da autda    x16, x8
0xfffffe000b300248  088e42f8 ldr      x8, [x16, #0x28]!
0xfffffe000b30024c  e00314aa mov      x0, x20
0xfffffe000b300250  f050e7f2 movk     x16, #0x3a87, lsl #48
0xfffffe000b300254  10093fd7 blraa    x8, x16
0xfffffe000b300258  140080d2 mov      x20, #0
0xfffffe000b30025c  f70313aa mov      x23, x19
0xfffffe000b300260  37b4f9f2 movk     x23, #0xcda1, lsl #48
0xfffffe000b300264  a82a00d0 adrp     x8, #0xfffffe000b856000; page 0xfffffe000b856000
0xfffffe000b300268  142503f9 str      x20, [x8, #0x648]
0xfffffe000b30026c  40eefdb0 adrp     x0, #0xfffffe00070c9000; page 0xfffffe00070c9000
0xfffffe000b300270  003c1a91 add      x0, x0, #0x68f; 0xfffffe00070c968f STR "IOUserClientEntitlements"
0xfffffe000b300274  db93fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b300278  882500d0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b30027c  001502f9 str      x0, [x8, #0x428]
0xfffffe000b300280  00eefdb0 adrp     x0, #0xfffffe00070c1000; page 0xfffffe00070c1000
0xfffffe000b300284  00440c91 add      x0, x0, #0x311; 0xfffffe00070c1311 STR "IOServiceDEXTEntitlements"
0xfffffe000b300288  d693fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b30028c  882500d0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b300290  008904f9 str      x0, [x8, #0x910]
0xfffffe000b300294  00eefdb0 adrp     x0, #0xfffffe00070c1000; page 0xfffffe00070c1000
0xfffffe000b300298  00ac0c91 add      x0, x0, #0x32b; 0xfffffe00070c132b STR "com.apple.developer.driverkit"
0xfffffe000b30029c  d193fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b3002a0  882500d0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b3002a4  00ad03f9 str      x0, [x8, #0x758]
0xfffffe000b3002a8  00eefdb0 adrp     x0, #0xfffffe00070c1000; page 0xfffffe00070c1000
0xfffffe000b3002ac  00240d91 add      x0, x0, #0x349; 0xfffffe00070c1349 STR "com.apple.developer.driverkit.userclient-access"
0xfffffe000b3002b0  cc93fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
0xfffffe000b3002b4  882500d0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b3002b8  00d103f9 str      x0, [x8, #0x7a0]
0xfffffe000b3002bc  882500d0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b3002c0  1fcd03f9 str      xzr, [x8, #0x798]
0xfffffe000b3002c4  00eefdb0 adrp     x0, #0xfffffe00070c1000; page 0xfffffe00070c1000
0xfffffe000b3002c8  00e40d91 add      x0, x0, #0x379; 0xfffffe00070c1379 STR "com.apple.private.driverkit.driver-access"
0xfffffe000b3002cc  c593fe97 bl       #0xfffffe000b2a51e0; CALL 0xfffffe000b2a51e0 sz=0x180 'amcc_rorgn_common.c'
