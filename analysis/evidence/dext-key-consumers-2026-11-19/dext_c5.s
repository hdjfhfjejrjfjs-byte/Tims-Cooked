0xfffffe000b3aedcc  7f2303d5 pacibsp  
0xfffffe000b3aedd0  f85fbca9 stp      x24, x23, [sp, #-0x40]!
0xfffffe000b3aedd4  f65701a9 stp      x22, x21, [sp, #0x10]
0xfffffe000b3aedd8  f44f02a9 stp      x20, x19, [sp, #0x20]
0xfffffe000b3aeddc  fd7b03a9 stp      x29, x30, [sp, #0x30]
0xfffffe000b3aede0  fdc30091 add      x29, sp, #0x30
0xfffffe000b3aede4  f30301aa mov      x19, x1
0xfffffe000b3aede8  f40300aa mov      x20, x0
0xfffffe000b3aedec  300040f9 ldr      x16, [x1]
0xfffffe000b3aedf0  f60301aa mov      x22, x1
0xfffffe000b3aedf4  36b4f9f2 movk     x22, #0xcda1, lsl #48
0xfffffe000b3aedf8  f10301aa mov      x17, x1
0xfffffe000b3aedfc  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b3aee00  301ac1da autda    x16, x17
0xfffffe000b3aee04  112780d2 mov      x17, #0x138
0xfffffe000b3aee08  1002118b add      x16, x16, x17
0xfffffe000b3aee0c  080240f9 ldr      x8, [x16]
0xfffffe000b3aee10  c1e8fdd0 adrp     x1, #0xfffffe00070c8000; page 0xfffffe00070c8000
0xfffffe000b3aee14  21cc3191 add      x1, x1, #0xc73; 0xfffffe00070c8c73 STR "IOProviderMergeProperties"
0xfffffe000b3aee18  e00313aa mov      x0, x19
0xfffffe000b3aee1c  70c7e5f2 movk     x16, #0x2e3b, lsl #48
0xfffffe000b3aee20  10093fd7 blraa    x8, x16
0xfffffe000b3aee24  f50300aa mov      x21, x0
0xfffffe000b3aee28  172000d0 adrp     x23, #0xfffffe000b7b0000; page 0xfffffe000b7b0000
0xfffffe000b3aee2c  f7420891 add      x23, x23, #0x210; 0xfffffe000b7b0210 ?
0xfffffe000b3aee30  c00100b4 cbz      x0, #0xfffffe000b3aee68
0xfffffe000b3aee34  b00240f9 ldr      x16, [x21]
0xfffffe000b3aee38  f10315aa mov      x17, x21
0xfffffe000b3aee3c  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b3aee40  301ac1da autda    x16, x17
0xfffffe000b3aee44  088e43f8 ldr      x8, [x16, #0x38]!
0xfffffe000b3aee48  e00315aa mov      x0, x21
0xfffffe000b3aee4c  90fffff2 movk     x16, #0xfffc, lsl #48
0xfffffe000b3aee50  10093fd7 blraa    x8, x16
0xfffffe000b3aee54  1f0017eb cmp      x0, x23
0xfffffe000b3aee58  80000054 b.eq     #0xfffffe000b3aee68; -> 0xfffffe000b3aee68 FUNC 0xfffffe000b3aedcc
0xfffffe000b3aee5c  000840f9 ldr      x0, [x0, #0x10]
0xfffffe000b3aee60  a0ffffb5 cbnz     x0, #0xfffffe000b3aee54
0xfffffe000b3aee64  150080d2 mov      x21, #0
0xfffffe000b3aee68  700240f9 ldr      x16, [x19]
0xfffffe000b3aee6c  d01ac1da autda    x16, x22
0xfffffe000b3aee70  112780d2 mov      x17, #0x138
0xfffffe000b3aee74  1002118b add      x16, x16, x17
0xfffffe000b3aee78  080240f9 ldr      x8, [x16]
0xfffffe000b3aee7c  c1e8fdd0 adrp     x1, #0xfffffe00070c8000; page 0xfffffe00070c8000
0xfffffe000b3aee80  21343291 add      x1, x1, #0xc8d; 0xfffffe00070c8c8d STR "IOProviderParentMergeProperties"
0xfffffe000b3aee84  e00313aa mov      x0, x19
0xfffffe000b3aee88  70c7e5f2 movk     x16, #0x2e3b, lsl #48
0xfffffe000b3aee8c  10093fd7 blraa    x8, x16
0xfffffe000b3aee90  f60300aa mov      x22, x0
0xfffffe000b3aee94  c00100b4 cbz      x0, #0xfffffe000b3aeecc
0xfffffe000b3aee98  d00240f9 ldr      x16, [x22]
0xfffffe000b3aee9c  f10316aa mov      x17, x22
0xfffffe000b3aeea0  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b3aeea4  301ac1da autda    x16, x17
0xfffffe000b3aeea8  088e43f8 ldr      x8, [x16, #0x38]!
0xfffffe000b3aeeac  e00316aa mov      x0, x22
0xfffffe000b3aeeb0  90fffff2 movk     x16, #0xfffc, lsl #48
0xfffffe000b3aeeb4  10093fd7 blraa    x8, x16
0xfffffe000b3aeeb8  1f0017eb cmp      x0, x23
0xfffffe000b3aeebc  80000054 b.eq     #0xfffffe000b3aeecc; -> 0xfffffe000b3aeecc FUNC 0xfffffe000b3aedcc
0xfffffe000b3aeec0  000840f9 ldr      x0, [x0, #0x10]
0xfffffe000b3aeec4  a0ffffb5 cbnz     x0, #0xfffffe000b3aeeb8
0xfffffe000b3aeec8  160080d2 mov      x22, #0
0xfffffe000b3aeecc  37200090 adrp     x23, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b3aeed0  950100b4 cbz      x21, #0xfffffe000b3aef00
0xfffffe000b3aeed4  e18a44f9 ldr      x1, [x23, #0x910]; [0xfffffe000b7b2910] ?
0xfffffe000b3aeed8  b00240f9 ldr      x16, [x21]
0xfffffe000b3aeedc  f10315aa mov      x17, x21
0xfffffe000b3aeee0  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b3aeee4  301ac1da autda    x16, x17
0xfffffe000b3aeee8  112180d2 mov      x17, #0x108
0xfffffe000b3aeeec  1002118b add      x16, x16, x17
0xfffffe000b3aeef0  080240f9 ldr      x8, [x16]
0xfffffe000b3aeef4  e00315aa mov      x0, x21
0xfffffe000b3aeef8  9048f3f2 movk     x16, #0x9a44, lsl #48
0xfffffe000b3aeefc  10093fd7 blraa    x8, x16
0xfffffe000b3aef00  960100b4 cbz      x22, #0xfffffe000b3aef30
0xfffffe000b3aef04  e18a44f9 ldr      x1, [x23, #0x910]; [0xfffffe000b7b2910] ?
0xfffffe000b3aef08  d00240f9 ldr      x16, [x22]
0xfffffe000b3aef0c  f10316aa mov      x17, x22
0xfffffe000b3aef10  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b3aef14  301ac1da autda    x16, x17
0xfffffe000b3aef18  112180d2 mov      x17, #0x108
0xfffffe000b3aef1c  1002118b add      x16, x16, x17
0xfffffe000b3aef20  080240f9 ldr      x8, [x16]
0xfffffe000b3aef24  e00316aa mov      x0, x22
0xfffffe000b3aef28  9048f3f2 movk     x16, #0x9a44, lsl #48
0xfffffe000b3aef2c  10093fd7 blraa    x8, x16
0xfffffe000b3aef30  e00314aa mov      x0, x20
0xfffffe000b3aef34  e10313aa mov      x1, x19
0xfffffe000b3aef38  fd7b43a9 ldp      x29, x30, [sp, #0x30]
0xfffffe000b3aef3c  f44f42a9 ldp      x20, x19, [sp, #0x20]
0xfffffe000b3aef40  f65741a9 ldp      x22, x21, [sp, #0x10]
0xfffffe000b3aef44  f85fc4a8 ldp      x24, x23, [sp], #0x40
0xfffffe000b3aef48  ff2303d5 autibsp  
0xfffffe000b3aef4c  b824fd17 b        #0xfffffe000b2f822c; -> 0xfffffe000b2f822c FUNC 0xfffffe000b2f822c
