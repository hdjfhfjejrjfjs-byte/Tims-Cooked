0xfffffe000b3a3174  5f2403d5 bti      c
0xfffffe000b3a3178  08a440f9 ldr      x8, [x0, #0x148]
0xfffffe000b3a317c  080600b4 cbz      x8, #0xfffffe000b3a323c
0xfffffe000b3a3180  7f2303d5 pacibsp  
0xfffffe000b3a3184  ff0301d1 sub      sp, sp, #0x40
0xfffffe000b3a3188  f65701a9 stp      x22, x21, [sp, #0x10]
0xfffffe000b3a318c  f44f02a9 stp      x20, x19, [sp, #0x20]
0xfffffe000b3a3190  fd7b03a9 stp      x29, x30, [sp, #0x30]
0xfffffe000b3a3194  fdc30091 add      x29, sp, #0x30
0xfffffe000b3a3198  f30302aa mov      x19, x2
0xfffffe000b3a319c  f40300aa mov      x20, x0
0xfffffe000b3a31a0  762000f0 adrp     x22, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b3a31a4  c88a44f9 ldr      x8, [x22, #0x910]; [0xfffffe000b7b2910] ?
0xfffffe000b3a31a8  300040f9 ldr      x16, [x1]
0xfffffe000b3a31ac  f10301aa mov      x17, x1
0xfffffe000b3a31b0  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b3a31b4  301ac1da autda    x16, x17
0xfffffe000b3a31b8  112780d2 mov      x17, #0x138
0xfffffe000b3a31bc  1002118b add      x16, x16, x17
0xfffffe000b3a31c0  090240f9 ldr      x9, [x16]
0xfffffe000b3a31c4  e00301aa mov      x0, x1
0xfffffe000b3a31c8  f50301aa mov      x21, x1
0xfffffe000b3a31cc  e10308aa mov      x1, x8
0xfffffe000b3a31d0  d076f6f2 movk     x16, #0xb3b6, lsl #48
0xfffffe000b3a31d4  30093fd7 blraa    x9, x16
0xfffffe000b3a31d8  e10300aa mov      x1, x0
0xfffffe000b3a31dc  807640f9 ldr      x0, [x20, #0xe8]
0xfffffe000b3a31e0  e20315aa mov      x2, x21
0xfffffe000b3a31e4  e30313aa mov      x3, x19
0xfffffe000b3a31e8  20f1ff97 bl       #0xfffffe000b39f668; CALL 0xfffffe000b39f668 sz=0x22c 
0xfffffe000b3a31ec  c0020036 tbz      w0, #0, #0xfffffe000b3a3244
0xfffffe000b3a31f0  c18a44f9 ldr      x1, [x22, #0x910]; [0xfffffe000b7b2910] ?
0xfffffe000b3a31f4  700240f9 ldr      x16, [x19]
0xfffffe000b3a31f8  f10313aa mov      x17, x19
0xfffffe000b3a31fc  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b3a3200  301ac1da autda    x16, x17
0xfffffe000b3a3204  112780d2 mov      x17, #0x138
0xfffffe000b3a3208  1002118b add      x16, x16, x17
0xfffffe000b3a320c  080240f9 ldr      x8, [x16]
0xfffffe000b3a3210  e00313aa mov      x0, x19
0xfffffe000b3a3214  d076f6f2 movk     x16, #0xb3b6, lsl #48
0xfffffe000b3a3218  10093fd7 blraa    x8, x16
0xfffffe000b3a321c  e10300aa mov      x1, x0
0xfffffe000b3a3220  807640f9 ldr      x0, [x20, #0xe8]
0xfffffe000b3a3224  020080d2 mov      x2, #0
0xfffffe000b3a3228  030080d2 mov      x3, #0
0xfffffe000b3a322c  0ff1ff97 bl       #0xfffffe000b39f668; CALL 0xfffffe000b39f668 sz=0x22c 
0xfffffe000b3a3230  a0020036 tbz      w0, #0, #0xfffffe000b3a3284
0xfffffe000b3a3234  20008052 mov      w0, #1
0xfffffe000b3a3238  2d000014 b        #0xfffffe000b3a32ec; -> 0xfffffe000b3a32ec FUNC 0xfffffe000b3a3174
0xfffffe000b3a323c  00008052 mov      w0, #0
0xfffffe000b3a3240  c0035fd6 ret      
0xfffffe000b3a3244  530400b4 cbz      x19, #0xfffffe000b3a32cc
0xfffffe000b3a3248  700240f9 ldr      x16, [x19]
0xfffffe000b3a324c  f10313aa mov      x17, x19
0xfffffe000b3a3250  31b4f9f2 movk     x17, #0xcda1, lsl #48
0xfffffe000b3a3254  301ac1da autda    x16, x17
0xfffffe000b3a3258  113d80d2 mov      x17, #0x1e8
0xfffffe000b3a325c  1002118b add      x16, x16, x17
0xfffffe000b3a3260  080240f9 ldr      x8, [x16]
0xfffffe000b3a3264  e00313aa mov      x0, x19
0xfffffe000b3a3268  010080d2 mov      x1, #0
0xfffffe000b3a326c  9093e1f2 movk     x16, #0xc9c, lsl #48
0xfffffe000b3a3270  10093fd7 blraa    x8, x16
0xfffffe000b3a3274  680a40f9 ldr      x8, [x19, #0x10]
0xfffffe000b3a3278  080300b4 cbz      x8, #0xfffffe000b3a32d8
0xfffffe000b3a327c  080540f9 ldr      x8, [x8, #8]
0xfffffe000b3a3280  16000014 b        #0xfffffe000b3a32d8; -> 0xfffffe000b3a32d8 FUNC 0xfffffe000b3a3174
0xfffffe000b3a3284  e80313aa mov      x8, x19
0xfffffe000b3a3288  28b4f9f2 movk     x8, #0xcda1, lsl #48
0xfffffe000b3a328c  700240f9 ldr      x16, [x19]
0xfffffe000b3a3290  1019c1da autda    x16, x8
0xfffffe000b3a3294  113d80d2 mov      x17, #0x1e8
0xfffffe000b3a3298  1002118b add      x16, x16, x17
0xfffffe000b3a329c  080240f9 ldr      x8, [x16]
0xfffffe000b3a32a0  e00313aa mov      x0, x19
0xfffffe000b3a32a4  010080d2 mov      x1, #0
0xfffffe000b3a32a8  9093e1f2 movk     x16, #0xc9c, lsl #48
0xfffffe000b3a32ac  10093fd7 blraa    x8, x16
0xfffffe000b3a32b0  680a40f9 ldr      x8, [x19, #0x10]
0xfffffe000b3a32b4  480000b4 cbz      x8, #0xfffffe000b3a32bc
0xfffffe000b3a32b8  080540f9 ldr      x8, [x8, #8]
0xfffffe000b3a32bc  e02300a9 stp      x0, x8, [sp]
0xfffffe000b3a32c0  20e9fd90 adrp     x0, #0xfffffe00070c7000; page 0xfffffe00070c7000
0xfffffe000b3a32c4  00041c91 add      x0, x0, #0x701; 0xfffffe00070c7701 ?
0xfffffe000b3a32c8  07000014 b        #0xfffffe000b3a32e4; -> 0xfffffe000b3a32e4 FUNC 0xfffffe000b3a3174
0xfffffe000b3a32cc  08008092 mov      x8, #-1
0xfffffe000b3a32d0  20e9fd90 adrp     x0, #0xfffffe00070c7000; page 0xfffffe00070c7000
0xfffffe000b3a32d4  00600791 add      x0, x0, #0x1d8; 0xfffffe00070c71d8 STR "NO-NAME"
0xfffffe000b3a32d8  e02300a9 stp      x0, x8, [sp]
0xfffffe000b3a32dc  20e9fd90 adrp     x0, #0xfffffe00070c7000; page 0xfffffe00070c7000
0xfffffe000b3a32e0  003c1b91 add      x0, x0, #0x6cf; 0xfffffe00070c76cf ?
0xfffffe000b3a32e4  f1c4fc97 bl       #0xfffffe000b2d46a8; CALL 0xfffffe000b2d46a8 sz=0x118 
0xfffffe000b3a32e8  00008052 mov      w0, #0
0xfffffe000b3a32ec  fd7b43a9 ldp      x29, x30, [sp, #0x30]
0xfffffe000b3a32f0  f44f42a9 ldp      x20, x19, [sp, #0x20]
0xfffffe000b3a32f4  f65741a9 ldp      x22, x21, [sp, #0x10]
0xfffffe000b3a32f8  ff030191 add      sp, sp, #0x40
0xfffffe000b3a32fc  ff2303d5 autibsp  
0xfffffe000b3a3300  c0035fd6 ret      
