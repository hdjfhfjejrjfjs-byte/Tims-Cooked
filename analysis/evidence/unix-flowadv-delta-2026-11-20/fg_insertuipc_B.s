0xfffffe000b1d6f1c  7f2303d5 pacibsp  
0xfffffe000b1d6f20  ff0305d1 sub      sp, sp, #0x140
0xfffffe000b1d6f24  fc6f0ea9 stp      x28, x27, [sp, #0xe0]
0xfffffe000b1d6f28  fa670fa9 stp      x26, x25, [sp, #0xf0]
0xfffffe000b1d6f2c  f85f10a9 stp      x24, x23, [sp, #0x100]
0xfffffe000b1d6f30  f65711a9 stp      x22, x21, [sp, #0x110]
0xfffffe000b1d6f34  f44f12a9 stp      x20, x19, [sp, #0x120]
0xfffffe000b1d6f38  fd7b13a9 stp      x29, x30, [sp, #0x130]
0xfffffe000b1d6f3c  fdc30491 add      x29, sp, #0x130
0xfffffe000b1d6f40  f50304aa mov      x21, x4
0xfffffe000b1d6f44  f60302aa mov      x22, x2
0xfffffe000b1d6f48  c82d00d0 adrp     x8, #0xfffffe000b790000; page 0xfffffe000b790000
0xfffffe000b1d6f4c  08010091 add      x8, x8, #0; 0xfffffe000b790000 ?
0xfffffe000b1d6f50  080140f9 ldr      x8, [x8]; [0xfffffe000b790000] ?
0xfffffe000b1d6f54  a8031af8 stur     x8, [x29, #-0x60]
0xfffffe000b1d6f58  ff8f00b9 str      wzr, [sp, #0x8c]
0xfffffe000b1d6f5c  1a0c40f9 ldr      x26, [x0, #0x18]
0xfffffe000b1d6f60  9a0200b4 cbz      x26, #0xfffffe000b1d6fb0
0xfffffe000b1d6f64  a1020037 tbnz     w1, #0, #0xfffffe000b1d6fb8
0xfffffe000b1d6f68  f30300aa mov      x19, x0
0xfffffe000b1d6f6c  e90316aa mov      x9, x22
0xfffffe000b1d6f70  db6240b9 ldr      w27, [x22, #0x60]
0xfffffe000b1d6f74  e00315aa mov      x0, x21
0xfffffe000b1d6f78  d53d00b4 cbz      x21, #0xfffffe000b1d7730
0xfffffe000b1d6f7c  e54300f9 str      x5, [sp, #0x80]
0xfffffe000b1d6f80  e32f00f9 str      x3, [sp, #0x58]
0xfffffe000b1d6f84  e15700b9 str      w1, [sp, #0x54]
0xfffffe000b1d6f88  e00313aa mov      x0, x19
0xfffffe000b1d6f8c  01008052 mov      w1, #0
0xfffffe000b1d6f90  2c98ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b1d6f94  e80315aa mov      x8, x21
0xfffffe000b1d6f98  a93e4079 ldrh     w9, [x21, #0x1e]
0xfffffe000b1d6f9c  fb6b04a9 stp      x27, x26, [sp, #0x40]
0xfffffe000b1d6fa0  a9010037 tbnz     w9, #0, #0xfffffe000b1d6fd4
0xfffffe000b1d6fa4  0c810391 add      x12, x8, #0xe0; 0xfffffe000b7900e0 ?
0xfffffe000b1d6fa8  0d010891 add      x13, x8, #0x200; 0xfffffe000b790200 ?
0xfffffe000b1d6fac  0d000014 b        #0xfffffe000b1d6fe0; -> 0xfffffe000b1d6fe0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d6fb0  c8028052 mov      w8, #0x16
0xfffffe000b1d6fb4  02000014 b        #0xfffffe000b1d6fbc; -> 0xfffffe000b1d6fbc FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d6fb8  c80c8052 mov      w8, #0x66
0xfffffe000b1d6fbc  e00315aa mov      x0, x21
0xfffffe000b1d6fc0  e90316aa mov      x9, x22
0xfffffe000b1d6fc4  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b1d6fc8  d55d00b5 cbnz     x21, #0xfffffe000b1d7b80
0xfffffe000b1d6fcc  495e00b5 cbnz     x9, #0xfffffe000b1d7b94
0xfffffe000b1d6fd0  f4020014 b        #0xfffffe000b1d7ba0; -> 0xfffffe000b1d7ba0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d6fd4  093140b9 ldr      w9, [x8, #0x30]; [0xfffffe000b790030] ?
0xfffffe000b1d6fd8  0c1140f9 ldr      x12, [x8, #0x20]; [0xfffffe000b790020] ?
0xfffffe000b1d6fdc  8d01098b add      x13, x12, x9; 0xfffffe000b7901c3 ?
0xfffffe000b1d6fe0  1c0940f9 ldr      x28, [x8, #0x10]; [0xfffffe000b790010] ?
0xfffffe000b1d6fe4  9f011ceb cmp      x12, x28
0xfffffe000b1d6fe8  08610054 b.hi     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d6fec  98330091 add      x24, x28, #0xc
0xfffffe000b1d6ff0  1f030deb cmp      x24, x13
0xfffffe000b1d6ff4  a8600054 b.hi     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d6ff8  890b40b9 ldr      w9, [x28, #8]
0xfffffe000b1d6ffc  3f050071 cmp      w9, #1
0xfffffe000b1d7000  210a0054 b.ne     #0xfffffe000b1d7144; -> 0xfffffe000b1d7144 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7004  890740b9 ldr      w9, [x28, #4]
0xfffffe000b1d7008  eaff9f52 mov      w10, #0xffff
0xfffffe000b1d700c  3f010a6b cmp      w9, w10
0xfffffe000b1d7010  a1090054 b.ne     #0xfffffe000b1d7144; -> 0xfffffe000b1d7144 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7014  890340b9 ldr      w9, [x28]
0xfffffe000b1d7018  081940b9 ldr      w8, [x8, #0x18]; [0xfffffe000b790018] ?
0xfffffe000b1d701c  3f01086b cmp      w9, w8
0xfffffe000b1d7020  21090054 b.ne     #0xfffffe000b1d7144; -> 0xfffffe000b1d7144 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7024  080080d2 mov      x8, #0
0xfffffe000b1d7028  ea4770b2 mov      x10, #0x3ffff0000
0xfffffe000b1d702c  8afe9ff2 movk     x10, #0xfff4
0xfffffe000b1d7030  37010a8b add      x23, x9, x10
0xfffffe000b1d7034  f4fe42d3 lsr      x20, x23, #2
0xfffffe000b1d7038  00e4006f movi     v0.2d, #0000000000000000
0xfffffe000b1d703c  e08305ad stp      q0, q0, [sp, #0xb0]
0xfffffe000b1d7040  e08304ad stp      q0, q0, [sp, #0x90]
0xfffffe000b1d7044  81d038d5 mrs      x1, tpidr_el1
0xfffffe000b1d7048  29f844b9 ldr      w9, [x1, #0x4f8]
0xfffffe000b1d704c  eb4340f9 ldr      x11, [sp, #0x80]
0xfffffe000b1d7050  6a610391 add      x10, x11, #0xd8
0xfffffe000b1d7054  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1d7058  1f0100f1 cmp      x8, #0
0xfffffe000b1d705c  edb306a9 stp      x13, x12, [sp, #0x68]
0xfffffe000b1d7060  e13f00f9 str      x1, [sp, #0x78]
0xfffffe000b1d7064  c1320054 b.ne     #0xfffffe000b1d76bc; -> 0xfffffe000b1d76bc FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7068  9f060071 cmp      w20, #1
0xfffffe000b1d706c  ab330054 b.lt     #0xfffffe000b1d76e0; -> 0xfffffe000b1d76e0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7070  e8430291 add      x8, sp, #0x90
0xfffffe000b1d7074  08010191 add      x8, x8, #0x40; 0xfffffe000b790040 ?
0xfffffe000b1d7078  fca302a9 stp      x28, x8, [sp, #0x28]
0xfffffe000b1d707c  fb8242d3 ubfx     x27, x23, #2, #0x1f
0xfffffe000b1d7080  37008052 mov      w23, #1
0xfffffe000b1d7084  d9498052 mov      w25, #0x24e
0xfffffe000b1d7088  fb3300f9 str      x27, [sp, #0x60]
0xfffffe000b1d708c  fa0318aa mov      x26, x24
0xfffffe000b1d7090  5f030deb cmp      x26, x13
0xfffffe000b1d7094  a25b0054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7098  5f030ceb cmp      x26, x12
0xfffffe000b1d709c  635b0054 b.lo     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d70a0  410340b9 ldr      w1, [x26]
0xfffffe000b1d70a4  e04340f9 ldr      x0, [sp, #0x80]
0xfffffe000b1d70a8  fc0300aa mov      x28, x0
0xfffffe000b1d70ac  36e9fc97 bl       #0xfffffe000b111584; CALL 0xfffffe000b111584 sz=0xc4 
0xfffffe000b1d70b0  801500b4 cbz      x0, #0xfffffe000b1d7360
0xfffffe000b1d70b4  e20300aa mov      x2, x0
0xfffffe000b1d70b8  f10300aa mov      x17, x0
0xfffffe000b1d70bc  300e41f8 ldr      x16, [x17, #0x10]!
0xfffffe000b1d70c0  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b1d70c4  b00000b4 cbz      x16, #0xfffffe000b1d70d8
0xfffffe000b1d70c8  b18ee1f2 movk     x17, #0xc75, lsl #48
0xfffffe000b1d70cc  301ac1da autda    x16, x17
0xfffffe000b1d70d0  e80310aa mov      x8, x16
0xfffffe000b1d70d4  02000014 b        #0xfffffe000b1d70dc; -> 0xfffffe000b1d70dc FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d70d8  080080d2 mov      x8, #0
0xfffffe000b1d70dc  eb031caa mov      x11, x28
0xfffffe000b1d70e0  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b1d70e4  f10308aa mov      x17, x8
0xfffffe000b1d70e8  308e42f8 ldr      x16, [x17, #0x28]!
0xfffffe000b1d70ec  91a7f0f2 movk     x17, #0x853c, lsl #48
0xfffffe000b1d70f0  301ac1da autda    x16, x17
0xfffffe000b1d70f4  090240b9 ldr      w9, [x16]
0xfffffe000b1d70f8  3f250071 cmp      w9, #9
0xfffffe000b1d70fc  e922c91a lsl      w9, w23, w9
0xfffffe000b1d7100  2901190a and      w9, w9, w25
0xfffffe000b1d7104  2499407a ccmp     w9, #0, #4, ls
0xfffffe000b1d7108  80120054 b.eq     #0xfffffe000b1d7358; -> 0xfffffe000b1d7358 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d710c  08754039 ldrb     w8, [x8, #0x1d]; [0xfffffe000b79005d] ?
0xfffffe000b1d7110  48120837 tbnz     w8, #1, #0xfffffe000b1d7358
0xfffffe000b1d7114  48800091 add      x8, x2, #0x20
0xfffffe000b1d7118  5f0008eb cmp      x2, x8
0xfffffe000b1d711c  62570054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7120  48144079 ldrh     w8, [x2, #0xa]
0xfffffe000b1d7124  68121037 tbnz     w8, #2, #0xfffffe000b1d7370
0xfffffe000b1d7128  5a130091 add      x26, x26, #4
0xfffffe000b1d712c  7b0700f1 subs     x27, x27, #1
0xfffffe000b1d7130  01fbff54 b.ne     #0xfffffe000b1d7090; -> 0xfffffe000b1d7090 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7134  f43340f9 ldr      x20, [sp, #0x60]
0xfffffe000b1d7138  99f6fdb0 adrp     x25, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1d713c  395f3191 add      x25, x25, #0xc57; 0xfffffe00070a8c57 STR "fg_insertuipc"
0xfffffe000b1d7140  0d000014 b        #0xfffffe000b1d7174; -> 0xfffffe000b1d7174 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7144  c8028052 mov      w8, #0x16
0xfffffe000b1d7148  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b1d714c  e00313aa mov      x0, x19
0xfffffe000b1d7150  01008052 mov      w1, #0
0xfffffe000b1d7154  7ea4ff97 bl       #0xfffffe000b1c034c; CALL 0xfffffe000b1c034c sz=0xdc 
0xfffffe000b1d7158  e00315aa mov      x0, x21
0xfffffe000b1d715c  e90316aa mov      x9, x22
0xfffffe000b1d7160  88020014 b        #0xfffffe000b1d7b80; -> 0xfffffe000b1d7b80 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7164  100100f9 str      x16, [x8]
0xfffffe000b1d7168  e81f40f9 ldr      x8, [sp, #0x38]
0xfffffe000b1d716c  1f0500f1 cmp      x8, #1
0xfffffe000b1d7170  29110054 b.ls     #0xfffffe000b1d7394; -> 0xfffffe000b1d7394 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7174  f41f00f9 str      x20, [sp, #0x38]
0xfffffe000b1d7178  940600d1 sub      x20, x20, #1
0xfffffe000b1d717c  080b148b add      x8, x24, x20, lsl #2
0xfffffe000b1d7180  1f010deb cmp      x8, x13
0xfffffe000b1d7184  00314cfa ccmp     x8, x12, #0, lo
0xfffffe000b1d7188  03540054 b.lo     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d718c  010140b9 ldr      w1, [x8]; [0xfffffe000b790040] ?
0xfffffe000b1d7190  e04340f9 ldr      x0, [sp, #0x80]
0xfffffe000b1d7194  fce8fc97 bl       #0xfffffe000b111584; CALL 0xfffffe000b111584 sz=0xc4 
0xfffffe000b1d7198  fa0300aa mov      x26, x0
0xfffffe000b1d719c  500f41f8 ldr      x16, [x26, #0x10]!
0xfffffe000b1d71a0  f7031aaa mov      x23, x26
0xfffffe000b1d71a4  b78ee1f2 movk     x23, #0xc75, lsl #48
0xfffffe000b1d71a8  b00000b4 cbz      x16, #0xfffffe000b1d71bc
0xfffffe000b1d71ac  f10317aa mov      x17, x23
0xfffffe000b1d71b0  301ac1da autda    x16, x17
0xfffffe000b1d71b4  fb0310aa mov      x27, x16
0xfffffe000b1d71b8  02000014 b        #0xfffffe000b1d71c0; -> 0xfffffe000b1d71c0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d71bc  1b0080d2 mov      x27, #0
0xfffffe000b1d71c0  eb3f40f9 ldr      x11, [sp, #0x78]
0xfffffe000b1d71c4  080080d2 mov      x8, #0
0xfffffe000b1d71c8  69f944b9 ldr      w9, [x11, #0x4f8]
0xfffffe000b1d71cc  6ac141b9 ldr      w10, [x11, #0x1c0]
0xfffffe000b1d71d0  4a050011 add      w10, w10, #1
0xfffffe000b1d71d4  6ac101b9 str      w10, [x11, #0x1c0]
0xfffffe000b1d71d8  290564b2 orr      x9, x9, #0x30000000
0xfffffe000b1d71dc  6a430191 add      x10, x27, #0x50
0xfffffe000b1d71e0  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1d71e4  1f0100f1 cmp      x8, #0
0xfffffe000b1d71e8  010a0054 b.ne     #0xfffffe000b1d7328; -> 0xfffffe000b1d7328 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d71ec  fc031baa mov      x28, x27
0xfffffe000b1d71f0  88cf41b8 ldr      w8, [x28, #0x1c]!
0xfffffe000b1d71f4  08021836 tbz      w8, #3, #0xfffffe000b1d7234
0xfffffe000b1d71f8  60230191 add      x0, x27, #0x48
0xfffffe000b1d71fc  e638e997 bl       #0xfffffe000ac25594; CALL 0xfffffe000ac25594 sz=0x74 
0xfffffe000b1d7200  880340b9 ldr      w8, [x28]
0xfffffe000b1d7204  08011c32 orr      w8, w8, #0x10
0xfffffe000b1d7208  880300b9 str      w8, [x28]
0xfffffe000b1d720c  65230191 add      x5, x27, #0x48
0xfffffe000b1d7210  e0031caa mov      x0, x28
0xfffffe000b1d7214  01008052 mov      w1, #0
0xfffffe000b1d7218  e20319aa mov      x2, x25
0xfffffe000b1d721c  030080d2 mov      x3, #0
0xfffffe000b1d7220  040080d2 mov      x4, #0
0xfffffe000b1d7224  b92bfe97 bl       #0xfffffe000b162108; CALL 0xfffffe000b162108 sz=0x40c 'unknown'
0xfffffe000b1d7228  880340b9 ldr      w8, [x28]
0xfffffe000b1d722c  68fe1f37 tbnz     w8, #3, #0xfffffe000b1d71f8
0xfffffe000b1d7230  eb3f40f9 ldr      x11, [sp, #0x78]
0xfffffe000b1d7234  60530091 add      x0, x27, #0x14
0xfffffe000b1d7238  29008052 mov      w9, #1
0xfffffe000b1d723c  090029b8 ldadd    w9, w9, [x0]
0xfffffe000b1d7240  ea130432 mov      w10, #-0xfffffff
0xfffffe000b1d7244  29010a0b add      w9, w9, w10
0xfffffe000b1d7248  3f010a6b cmp      w9, w10
0xfffffe000b1d724c  fc1740f9 ldr      x28, [sp, #0x28]
0xfffffe000b1d7250  29220054 b.ls     #0xfffffe000b1d7694; -> 0xfffffe000b1d7694 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7254  691b40b9 ldr      w9, [x27, #0x18]
0xfffffe000b1d7258  2a050011 add      w10, w9, #1
0xfffffe000b1d725c  6a1b00b9 str      w10, [x27, #0x18]
0xfffffe000b1d7260  c9010034 cbz      w9, #0xfffffe000b1d7298
0xfffffe000b1d7264  68f944b9 ldr      w8, [x11, #0x4f8]
0xfffffe000b1d7268  69430191 add      x9, x27, #0x50
0xfffffe000b1d726c  e20308aa mov      x2, x8
0xfffffe000b1d7270  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1d7274  5f00086b cmp      w2, w8
0xfffffe000b1d7278  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b1d727c  e0030054 b.eq     #0xfffffe000b1d72f8; -> 0xfffffe000b1d72f8 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7280  60230191 add      x0, x27, #0x48
0xfffffe000b1d7284  e1030baa mov      x1, x11
0xfffffe000b1d7288  3938e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1d728c  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b1d7290  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1d7294  19000014 b        #0xfffffe000b1d72f8; -> 0xfffffe000b1d72f8 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7298  08011f32 orr      w8, w8, #2
0xfffffe000b1d729c  681f00b9 str      w8, [x27, #0x1c]
0xfffffe000b1d72a0  68f944b9 ldr      w8, [x11, #0x4f8]
0xfffffe000b1d72a4  69430191 add      x9, x27, #0x50
0xfffffe000b1d72a8  e20308aa mov      x2, x8
0xfffffe000b1d72ac  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1d72b0  5f00086b cmp      w2, w8
0xfffffe000b1d72b4  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b1d72b8  41040054 b.ne     #0xfffffe000b1d7340; -> 0xfffffe000b1d7340 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d72bc  887e0353 lsr      w8, w20, #3
0xfffffe000b1d72c0  e9430291 add      x9, sp, #0x90
0xfffffe000b1d72c4  2801088b add      x8, x9, x8
0xfffffe000b1d72c8  1f0109eb cmp      x8, x9
0xfffffe000b1d72cc  e9379f1a cset     w9, hs
0xfffffe000b1d72d0  ea1b40f9 ldr      x10, [sp, #0x30]
0xfffffe000b1d72d4  1f010aeb cmp      x8, x10
0xfffffe000b1d72d8  82490054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d72dc  69490034 cbz      w9, #0xfffffe000b1d7c08
0xfffffe000b1d72e0  890a4092 and      x9, x20, #7
0xfffffe000b1d72e4  0a108052 mov      w10, #0x80
0xfffffe000b1d72e8  4925c91a lsr      w9, w10, w9
0xfffffe000b1d72ec  0a014039 ldrb     w10, [x8]; [0xfffffe000b790040] ?
0xfffffe000b1d72f0  4901092a orr      w9, w10, w9
0xfffffe000b1d72f4  09010039 strb     w9, [x8]
0xfffffe000b1d72f8  080f148b add      x8, x24, x20, lsl #3
0xfffffe000b1d72fc  1f010deb cmp      x8, x13
0xfffffe000b1d7300  42480054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7304  1f010ceb cmp      x8, x12
0xfffffe000b1d7308  03480054 b.lo     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d730c  500340f9 ldr      x16, [x26]
0xfffffe000b1d7310  b0f2ffb4 cbz      x16, #0xfffffe000b1d7164
0xfffffe000b1d7314  f10308aa mov      x17, x8
0xfffffe000b1d7318  f01ac1da autda    x16, x23
0xfffffe000b1d731c  1193fdf2 movk     x17, #0xec98, lsl #48
0xfffffe000b1d7320  300ac1da pacda    x16, x17
0xfffffe000b1d7324  90ffff17 b        #0xfffffe000b1d7164; -> 0xfffffe000b1d7164 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7328  60230191 add      x0, x27, #0x48
0xfffffe000b1d732c  e1030baa mov      x1, x11
0xfffffe000b1d7330  22008052 mov      w2, #1
0xfffffe000b1d7334  1535e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1d7338  eb3f40f9 ldr      x11, [sp, #0x78]
0xfffffe000b1d733c  acffff17 b        #0xfffffe000b1d71ec; -> 0xfffffe000b1d71ec FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7340  60230191 add      x0, x27, #0x48
0xfffffe000b1d7344  e1030baa mov      x1, x11
0xfffffe000b1d7348  0938e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1d734c  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b1d7350  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1d7354  daffff17 b        #0xfffffe000b1d72bc; -> 0xfffffe000b1d72bc FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7358  d7028052 mov      w23, #0x16
0xfffffe000b1d735c  e2000014 b        #0xfffffe000b1d76e4; -> 0xfffffe000b1d76e4 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7360  37018052 mov      w23, #9
0xfffffe000b1d7364  eb031caa mov      x11, x28
0xfffffe000b1d7368  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b1d736c  de000014 b        #0xfffffe000b1d76e4; -> 0xfffffe000b1d76e4 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7370  410340b9 ldr      w1, [x26]
0xfffffe000b1d7374  f74340f9 ldr      x23, [sp, #0x80]
0xfffffe000b1d7378  e00317aa mov      x0, x23
0xfffffe000b1d737c  03018052 mov      w3, #8
0xfffffe000b1d7380  4f0dfd97 bl       #0xfffffe000b11a8bc; CALL 0xfffffe000b11a8bc sz=0x6c 
0xfffffe000b1d7384  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b1d7388  eb0317aa mov      x11, x23
0xfffffe000b1d738c  37008052 mov      w23, #1
0xfffffe000b1d7390  d5000014 b        #0xfffffe000b1d76e4; -> 0xfffffe000b1d76e4 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7394  68f944b9 ldr      w8, [x11, #0x4f8]
0xfffffe000b1d7398  e94340f9 ldr      x9, [sp, #0x80]
0xfffffe000b1d739c  29610391 add      x9, x9, #0xd8
0xfffffe000b1d73a0  e20308aa mov      x2, x8
0xfffffe000b1d73a4  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1d73a8  5f00086b cmp      w2, w8
0xfffffe000b1d73ac  01430054 b.ne     #0xfffffe000b1d7c0c; -> 0xfffffe000b1d7c0c FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d73b0  140080d2 mov      x20, #0
0xfffffe000b1d73b4  99330091 add      x25, x28, #0xc
0xfffffe000b1d73b8  f7430291 add      x23, sp, #0x90
0xfffffe000b1d73bc  ae3600b0 adrp     x14, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d73c0  ce212991 add      x14, x14, #0xa48; 0xfffffe000b8aca48 ?
0xfffffe000b1d73c4  2f008052 mov      w15, #1
0xfffffe000b1d73c8  bc3600b0 adrp     x28, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d73cc  9c032991 add      x28, x28, #0xa40; 0xfffffe000b8aca40 ?
0xfffffe000b1d73d0  a03600b0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d73d4  ba3600b0 adrp     x26, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d73d8  5a032a91 add      x26, x26, #0xa80; 0xfffffe000b8aca80 ?
0xfffffe000b1d73dc  0f000014 b        #0xfffffe000b1d7418; -> 0xfffffe000b1d7418 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d73e0  68f944b9 ldr      w8, [x11, #0x4f8]
0xfffffe000b1d73e4  69430191 add      x9, x27, #0x50
0xfffffe000b1d73e8  e20308aa mov      x2, x8
0xfffffe000b1d73ec  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1d73f0  5f00086b cmp      w2, w8
0xfffffe000b1d73f4  210f0054 b.ne     #0xfffffe000b1d75d8; -> 0xfffffe000b1d75d8 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d73f8  c8012fb8 ldadd    w15, w8, [x14]
0xfffffe000b1d73fc  94060091 add      x20, x20, #1
0xfffffe000b1d7400  18230091 add      x24, x24, #8
0xfffffe000b1d7404  39230091 add      x25, x25, #8; 0xfffffe00070a8c5f ?
0xfffffe000b1d7408  e83340f9 ldr      x8, [sp, #0x60]
0xfffffe000b1d740c  080500f1 subs     x8, x8, #1
0xfffffe000b1d7410  e83300f9 str      x8, [sp, #0x60]
0xfffffe000b1d7414  a0120054 b.eq     #0xfffffe000b1d7668; -> 0xfffffe000b1d7668 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7418  887e0353 lsr      w8, w20, #3
0xfffffe000b1d741c  e802088b add      x8, x23, x8
0xfffffe000b1d7420  1f0117eb cmp      x8, x23
0xfffffe000b1d7424  e9379f1a cset     w9, hs
0xfffffe000b1d7428  ea1b40f9 ldr      x10, [sp, #0x30]
0xfffffe000b1d742c  1f010aeb cmp      x8, x10
0xfffffe000b1d7430  2439407a ccmp     w9, #0, #4, lo
0xfffffe000b1d7434  a03e0054 b.eq     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7438  08014039 ldrb     w8, [x8]; [0xfffffe000b790040] ?
0xfffffe000b1d743c  890a0012 and      w9, w20, #7
0xfffffe000b1d7440  0821c91a lsl      w8, w8, w9
0xfffffe000b1d7444  a8fd3f36 tbz      w8, #7, #0xfffffe000b1d73f8
0xfffffe000b1d7448  1f030deb cmp      x24, x13
0xfffffe000b1d744c  e23d0054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7450  1f030ceb cmp      x24, x12
0xfffffe000b1d7454  a33d0054 b.lo     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7458  100340f9 ldr      x16, [x24]
0xfffffe000b1d745c  f10319aa mov      x17, x25
0xfffffe000b1d7460  1193fdf2 movk     x17, #0xec98, lsl #48
0xfffffe000b1d7464  301ac1da autda    x16, x17
0xfffffe000b1d7468  e10310aa mov      x1, x16
0xfffffe000b1d746c  28cc4138 ldrb     w8, [x1, #0x1c]!
0xfffffe000b1d7470  48110836 tbz      w8, #1, #0xfffffe000b1d7698
0xfffffe000b1d7474  fb0310aa mov      x27, x16
0xfffffe000b1d7478  080080d2 mov      x8, #0
0xfffffe000b1d747c  69f944b9 ldr      w9, [x11, #0x4f8]
0xfffffe000b1d7480  897fe8c8 casa     x8, x9, [x28]
0xfffffe000b1d7484  1f0100f1 cmp      x8, #0
0xfffffe000b1d7488  41010054 b.ne     #0xfffffe000b1d74b0; -> 0xfffffe000b1d74b0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d748c  084045f9 ldr      x8, [x0, #0xa80]; [0xfffffe000b8aca80] ?
0xfffffe000b1d7490  e80200b4 cbz      x8, #0xfffffe000b1d74ec
0xfffffe000b1d7494  090540f9 ldr      x9, [x8, #8]; [0xfffffe000b790048] ?
0xfffffe000b1d7498  3f011aeb cmp      x9, x26
0xfffffe000b1d749c  a1100054 b.ne     #0xfffffe000b1d76b0; -> 0xfffffe000b1d76b0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d74a0  680300f9 str      x8, [x27]
0xfffffe000b1d74a4  084045f9 ldr      x8, [x0, #0xa80]; [0xfffffe000b8aca80] ?
0xfffffe000b1d74a8  1b0500f9 str      x27, [x8, #8]
0xfffffe000b1d74ac  11000014 b        #0xfffffe000b1d74f0; -> 0xfffffe000b1d74f0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d74b0  a03600b0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d74b4  00e02891 add      x0, x0, #0xa38; 0xfffffe000b8aca38 ?
0xfffffe000b1d74b8  e11f00f9 str      x1, [sp, #0x38]
0xfffffe000b1d74bc  e1030baa mov      x1, x11
0xfffffe000b1d74c0  02008052 mov      w2, #0
0xfffffe000b1d74c4  b134e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1d74c8  a03600b0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d74cc  2f008052 mov      w15, #1
0xfffffe000b1d74d0  ae3600b0 adrp     x14, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d74d4  ce212991 add      x14, x14, #0xa48; 0xfffffe000b8aca48 ?
0xfffffe000b1d74d8  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b1d74dc  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1d74e0  e11f40f9 ldr      x1, [sp, #0x38]
0xfffffe000b1d74e4  084045f9 ldr      x8, [x0, #0xa80]; [0xfffffe000b8aca80] ?
0xfffffe000b1d74e8  68fdffb5 cbnz     x8, #0xfffffe000b1d7494
0xfffffe000b1d74ec  7f0300f9 str      xzr, [x27]
0xfffffe000b1d74f0  5b0300f9 str      x27, [x26]
0xfffffe000b1d74f4  7a0700f9 str      x26, [x27, #8]
0xfffffe000b1d74f8  68f944b9 ldr      w8, [x11, #0x4f8]
0xfffffe000b1d74fc  e20308aa mov      x2, x8
0xfffffe000b1d7500  9fffa288 casl     w2, wzr, [x28]
0xfffffe000b1d7504  5f00086b cmp      w2, w8
0xfffffe000b1d7508  c1070054 b.ne     #0xfffffe000b1d7600; -> 0xfffffe000b1d7600 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d750c  080080d2 mov      x8, #0
0xfffffe000b1d7510  69f944b9 ldr      w9, [x11, #0x4f8]
0xfffffe000b1d7514  6a430191 add      x10, x27, #0x50
0xfffffe000b1d7518  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1d751c  1f0100f1 cmp      x8, #0
0xfffffe000b1d7520  a1080054 b.ne     #0xfffffe000b1d7634; -> 0xfffffe000b1d7634 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7524  280040b9 ldr      w8, [x1]
0xfffffe000b1d7528  09791e12 and      w9, w8, #0xfffffffd
0xfffffe000b1d752c  290000b9 str      w9, [x1]
0xfffffe000b1d7530  88f51736 tbz      w8, #2, #0xfffffe000b1d73e0
0xfffffe000b1d7534  08751d12 and      w8, w8, #0xfffffff9
0xfffffe000b1d7538  280000b9 str      w8, [x1]
0xfffffe000b1d753c  280c48b2 orr      x8, x1, #0xf00000000000000
0xfffffe000b1d7540  0961fef0 adrp     x9, #0xfffffe0007dfa000; page 0xfffffe0007dfa000
0xfffffe000b1d7544  297540f9 ldr      x9, [x9, #0xe8]; [0xfffffe0007dfa0e8] ?
0xfffffe000b1d7548  087d48ca eor      x8, x8, x8, lsr #31
0xfffffe000b1d754c  aa3094d2 mov      x10, #0xa185
0xfffffe000b1d7550  ca51aef2 movk     x10, #0x728e, lsl #16
0xfffffe000b1d7554  2a65daf2 movk     x10, #0xd329, lsl #32
0xfffffe000b1d7558  aaf6eff2 movk     x10, #0x7fb5, lsl #48
0xfffffe000b1d755c  087d0a9b mul      x8, x8, x10
0xfffffe000b1d7560  086d48ca eor      x8, x8, x8, lsr #27
0xfffffe000b1d7564  aa899ad2 mov      x10, #0xd44d
0xfffffe000b1d7568  aa85b7f2 movk     x10, #0xbc2d, lsl #16
0xfffffe000b1d756c  8adedbf2 movk     x10, #0xdef4, lsl #32
0xfffffe000b1d7570  4a3bf0f2 movk     x10, #0x81da, lsl #48
0xfffffe000b1d7574  087d0a9b mul      x8, x8, x10
0xfffffe000b1d7578  0afd61d3 lsr      x10, x8, #0x21
0xfffffe000b1d757c  4801084a eor      w8, w10, w8
0xfffffe000b1d7580  0a61fef0 adrp     x10, #0xfffffe0007dfa000; page 0xfffffe0007dfa000
0xfffffe000b1d7584  4af140b9 ldr      w10, [x10, #0xf0]; [0xfffffe0007dfa0f0] ?
0xfffffe000b1d7588  4a050051 sub      w10, w10, #1
0xfffffe000b1d758c  4801080a and      w8, w10, w8
0xfffffe000b1d7590  0a038052 mov      w10, #0x18
0xfffffe000b1d7594  087daa9b umull    x8, w8, w10
0xfffffe000b1d7598  1fc128eb cmp      x8, w8, sxtw
0xfffffe000b1d759c  20c1288b add      x0, x9, w8, sxtw; 0xfffffe0007dfa0c3 ?
0xfffffe000b1d75a0  3001088b add      x16, x9, x8; 0xfffffe0007dfa0e2 ?
0xfffffe000b1d75a4  b075e5f2 movk     x16, #0x2bad, lsl #48
0xfffffe000b1d75a8  0000909a csel     x0, x0, x16, eq
0xfffffe000b1d75ac  02008052 mov      w2, #0
0xfffffe000b1d75b0  03008052 mov      w3, #0
0xfffffe000b1d75b4  04008012 mov      w4, #-1
0xfffffe000b1d75b8  acd6ea97 bl       #0xfffffe000ac8d068; CALL 0xfffffe000ac8d068 sz=0x178 '%s: debug exceptions enabled in kernel mode @%s:%d'; 'ml_set_interrupts_enabled_with_debug'; 'machine_routines_common.c'
0xfffffe000b1d75bc  a03600b0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d75c0  2f008052 mov      w15, #1
0xfffffe000b1d75c4  ae3600b0 adrp     x14, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d75c8  ce212991 add      x14, x14, #0xa48; 0xfffffe000b8aca48 ?
0xfffffe000b1d75cc  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b1d75d0  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1d75d4  83ffff17 b        #0xfffffe000b1d73e0; -> 0xfffffe000b1d73e0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d75d8  60230191 add      x0, x27, #0x48
0xfffffe000b1d75dc  e1030baa mov      x1, x11
0xfffffe000b1d75e0  6337e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1d75e4  a03600b0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d75e8  2f008052 mov      w15, #1
0xfffffe000b1d75ec  ae3600b0 adrp     x14, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d75f0  ce212991 add      x14, x14, #0xa48; 0xfffffe000b8aca48 ?
0xfffffe000b1d75f4  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b1d75f8  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1d75fc  7fffff17 b        #0xfffffe000b1d73f8; -> 0xfffffe000b1d73f8 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7600  a03600b0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d7604  00e02891 add      x0, x0, #0xa38; 0xfffffe000b8aca38 ?
0xfffffe000b1d7608  e11f00f9 str      x1, [sp, #0x38]
0xfffffe000b1d760c  e1030baa mov      x1, x11
0xfffffe000b1d7610  5737e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1d7614  a03600b0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d7618  2f008052 mov      w15, #1
0xfffffe000b1d761c  ae3600b0 adrp     x14, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d7620  ce212991 add      x14, x14, #0xa48; 0xfffffe000b8aca48 ?
0xfffffe000b1d7624  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b1d7628  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1d762c  e11f40f9 ldr      x1, [sp, #0x38]
0xfffffe000b1d7630  b7ffff17 b        #0xfffffe000b1d750c; -> 0xfffffe000b1d750c FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7634  60230191 add      x0, x27, #0x48
0xfffffe000b1d7638  e11f00f9 str      x1, [sp, #0x38]
0xfffffe000b1d763c  e1030baa mov      x1, x11
0xfffffe000b1d7640  02008052 mov      w2, #0
0xfffffe000b1d7644  5134e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1d7648  a03600b0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d764c  2f008052 mov      w15, #1
0xfffffe000b1d7650  ae3600b0 adrp     x14, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d7654  ce212991 add      x14, x14, #0xa48; 0xfffffe000b8aca48 ?
0xfffffe000b1d7658  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b1d765c  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1d7660  e11f40f9 ldr      x1, [sp, #0x38]
0xfffffe000b1d7664  b0ffff17 b        #0xfffffe000b1d7524; -> 0xfffffe000b1d7524 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7668  ff8f00b9 str      wzr, [sp, #0x8c]
0xfffffe000b1d766c  e00313aa mov      x0, x19
0xfffffe000b1d7670  01008052 mov      w1, #0
0xfffffe000b1d7674  36a3ff97 bl       #0xfffffe000b1c034c; CALL 0xfffffe000b1c034c sz=0xdc 
0xfffffe000b1d7678  e00315aa mov      x0, x21
0xfffffe000b1d767c  e15740b9 ldr      w1, [sp, #0x54]
0xfffffe000b1d7680  e90316aa mov      x9, x22
0xfffffe000b1d7684  e32f40f9 ldr      x3, [sp, #0x58]
0xfffffe000b1d7688  fb6b44a9 ldp      x27, x26, [sp, #0x40]
0xfffffe000b1d768c  e54340f9 ldr      x5, [sp, #0x80]
0xfffffe000b1d7690  28000014 b        #0xfffffe000b1d7730; -> 0xfffffe000b1d7730 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7694  25eb0a94 bl       #0xfffffe000b492328; CALL 0xfffffe000b492328 sz=0x44 'refcnt.c'
0xfffffe000b1d7698  80f6fdb0 adrp     x0, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1d769c  00e43091 add      x0, x0, #0xc39; 0xfffffe00070a8c39 STR "rp[i]->fg_lflags & FG_INSMSGQ"
0xfffffe000b1d76a0  81f6fdb0 adrp     x1, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1d76a4  213c2391 add      x1, x1, #0x8cf; 0xfffffe00070a88cf STR "/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_usrreq.c"
0xfffffe000b1d76a8  c2408152 mov      w2, #0xa06
0xfffffe000b1d76ac  c9d90a94 bl       #0xfffffe000b48ddd0; CALL 0xfffffe000b48ddd0 sz=0x34 'uipc_socket.c'
0xfffffe000b1d76b0  a83600b0 adrp     x8, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1d76b4  08012a91 add      x8, x8, #0xa80; 0xfffffe000b8aca80 ?
0xfffffe000b1d76b8  a0ff37d4 brk      #0xbffd; -> 0xbffd ?
0xfffffe000b1d76bc  60410391 add      x0, x11, #0xd0
0xfffffe000b1d76c0  02008052 mov      w2, #0
0xfffffe000b1d76c4  f9030baa mov      x25, x11
0xfffffe000b1d76c8  3034e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1d76cc  ec0747a9 ldp      x12, x1, [sp, #0x70]
0xfffffe000b1d76d0  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1d76d4  eb0319aa mov      x11, x25
0xfffffe000b1d76d8  9f060071 cmp      w20, #1
0xfffffe000b1d76dc  aaccff54 b.ge     #0xfffffe000b1d7070; -> 0xfffffe000b1d7070 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d76e0  17008052 mov      w23, #0
0xfffffe000b1d76e4  28f844b9 ldr      w8, [x1, #0x4f8]; [0xfffffe00070a8dc7] ?
0xfffffe000b1d76e8  f8030baa mov      x24, x11
0xfffffe000b1d76ec  69610391 add      x9, x11, #0xd8
0xfffffe000b1d76f0  e20308aa mov      x2, x8
0xfffffe000b1d76f4  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1d76f8  5f00086b cmp      w2, w8
0xfffffe000b1d76fc  fb6b44a9 ldp      x27, x26, [sp, #0x40]
0xfffffe000b1d7700  e1270054 b.ne     #0xfffffe000b1d7bfc; -> 0xfffffe000b1d7bfc FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7704  f78f00b9 str      w23, [sp, #0x8c]
0xfffffe000b1d7708  e00313aa mov      x0, x19
0xfffffe000b1d770c  01008052 mov      w1, #0
0xfffffe000b1d7710  0fa3ff97 bl       #0xfffffe000b1c034c; CALL 0xfffffe000b1c034c sz=0xdc 
0xfffffe000b1d7714  9f020071 cmp      w20, #0
0xfffffe000b1d7718  e00315aa mov      x0, x21
0xfffffe000b1d771c  e15740b9 ldr      w1, [sp, #0x54]
0xfffffe000b1d7720  e90316aa mov      x9, x22
0xfffffe000b1d7724  e32f40f9 ldr      x3, [sp, #0x58]
0xfffffe000b1d7728  e50318aa mov      x5, x24
0xfffffe000b1d772c  8c220054 b.gt     #0xfffffe000b1d7b7c; -> 0xfffffe000b1d7b7c FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7730  59230391 add      x25, x26, #0xc8; 0xfffffe000b8acb48 ?
0xfffffe000b1d7734  680a4079 ldrh     w8, [x19, #4]
0xfffffe000b1d7738  1f050071 cmp      w8, #1
0xfffffe000b1d773c  20010054 b.eq     #0xfffffe000b1d7760; -> 0xfffffe000b1d7760 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7740  1f090071 cmp      w8, #2
0xfffffe000b1d7744  41270054 b.ne     #0xfffffe000b1d7c2c; -> 0xfffffe000b1d7c2c FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7748  481740f9 ldr      x8, [x26, #0x28]; [0xfffffe000b8acaa8] ?
0xfffffe000b1d774c  630700b4 cbz      x3, #0xfffffe000b1d7838
0xfffffe000b1d7750  480800b4 cbz      x8, #0xfffffe000b1d7858
0xfffffe000b1d7754  08078052 mov      w8, #0x38
0xfffffe000b1d7758  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b1d775c  d3000014 b        #0xfffffe000b1d7aa8; -> 0xfffffe000b1d7aa8 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7760  682e4079 ldrh     w8, [x19, #0x16]
0xfffffe000b1d7764  c8010837 tbnz     w8, #1, #0xfffffe000b1d779c
0xfffffe000b1d7768  c30600b4 cbz      x3, #0xfffffe000b1d7840
0xfffffe000b1d776c  f70305aa mov      x23, x5
0xfffffe000b1d7770  f40301aa mov      x20, x1
0xfffffe000b1d7774  e00313aa mov      x0, x19
0xfffffe000b1d7778  e10303aa mov      x1, x3
0xfffffe000b1d777c  3f010094 bl       #0xfffffe000b1d7c78; CALL 0xfffffe000b1d7c78 sz=0x738 'iled to get data address @%s:%d'; "Can't create Tracker GC thread"; 'reason.c'
0xfffffe000b1d7780  e08f00b9 str      w0, [sp, #0x8c]
0xfffffe000b1d7784  682e4079 ldrh     w8, [x19, #0x16]
0xfffffe000b1d7788  80070035 cbnz     w0, #0xfffffe000b1d7878
0xfffffe000b1d778c  e00315aa mov      x0, x21
0xfffffe000b1d7790  e10314aa mov      x1, x20
0xfffffe000b1d7794  e90316aa mov      x9, x22
0xfffffe000b1d7798  e50317aa mov      x5, x23
0xfffffe000b1d779c  88052037 tbnz     w8, #4, #0xfffffe000b1d784c
0xfffffe000b1d77a0  481740f9 ldr      x8, [x26, #0x28]; [0xfffffe000b8acaa8] ?
0xfffffe000b1d77a4  282500b4 cbz      x8, #0xfffffe000b1d7c48
0xfffffe000b1d77a8  180940f9 ldr      x24, [x8, #0x10]; [0xfffffe000b8aca90] ?
0xfffffe000b1d77ac  7f0218eb cmp      x19, x24
0xfffffe000b1d77b0  60010054 b.eq     #0xfffffe000b1d77dc; -> 0xfffffe000b1d77dc FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d77b4  e00313aa mov      x0, x19
0xfffffe000b1d77b8  f40301aa mov      x20, x1
0xfffffe000b1d77bc  e10318aa mov      x1, x24
0xfffffe000b1d77c0  f70305aa mov      x23, x5
0xfffffe000b1d77c4  5efdff97 bl       #0xfffffe000b1d6d3c; CALL 0xfffffe000b1d6d3c sz=0x14c 
0xfffffe000b1d77c8  e50317aa mov      x5, x23
0xfffffe000b1d77cc  e10314aa mov      x1, x20
0xfffffe000b1d77d0  e00315aa mov      x0, x21
0xfffffe000b1d77d4  682e4079 ldrh     w8, [x19, #0x16]
0xfffffe000b1d77d8  a8052037 tbnz     w8, #4, #0xfffffe000b1d788c
0xfffffe000b1d77dc  48874139 ldrb     w8, [x26, #0x61]; [0xfffffe000b8acae1] ?
0xfffffe000b1d77e0  c80e2036 tbz      w8, #4, #0xfffffe000b1d79b8
0xfffffe000b1d77e4  f70305aa mov      x23, x5
0xfffffe000b1d77e8  f40301aa mov      x20, x1
0xfffffe000b1d77ec  ff7f09a9 stp      xzr, xzr, [sp, #0x90]
0xfffffe000b1d77f0  ffab00b9 str      wzr, [sp, #0xa8]
0xfffffe000b1d77f4  ff5300f9 str      xzr, [sp, #0xa0]
0xfffffe000b1d77f8  e3430291 add      x3, sp, #0x90
0xfffffe000b1d77fc  e00316aa mov      x0, x22
0xfffffe000b1d7800  010080d2 mov      x1, #0
0xfffffe000b1d7804  82038052 mov      w2, #0x1c
0xfffffe000b1d7808  a5abfe97 bl       #0xfffffe000b18269c; CALL 0xfffffe000b18269c sz=0x1d4 
0xfffffe000b1d780c  200d0035 cbnz     w0, #0xfffffe000b1d79b0
0xfffffe000b1d7810  e89340b9 ldr      w8, [sp, #0x90]
0xfffffe000b1d7814  0920a052 mov      w9, #0x1000000
0xfffffe000b1d7818  1f01096b cmp      w8, w9
0xfffffe000b1d781c  a10c0054 b.ne     #0xfffffe000b1d79b0; -> 0xfffffe000b1d79b0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7820  8869feb0 adrp     x8, #0xfffffe0007f08000; page 0xfffffe0007f08000
0xfffffe000b1d7824  08d547f9 ldr      x8, [x8, #0xfa8]; [0xfffffe0007f08fa8] ?
0xfffffe000b1d7828  ff0208eb cmp      x23, x8
0xfffffe000b1d782c  200a0054 b.eq     #0xfffffe000b1d7970; -> 0xfffffe000b1d7970 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7830  e86240b9 ldr      w8, [x23, #0x60]
0xfffffe000b1d7834  50000014 b        #0xfffffe000b1d7974; -> 0xfffffe000b1d7974 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7838  f80303aa mov      x24, x3
0xfffffe000b1d783c  e80300b5 cbnz     x8, #0xfffffe000b1d78b8
0xfffffe000b1d7840  28078052 mov      w8, #0x39
0xfffffe000b1d7844  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b1d7848  98000014 b        #0xfffffe000b1d7aa8; -> 0xfffffe000b1d7aa8 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d784c  08048052 mov      w8, #0x20
0xfffffe000b1d7850  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b1d7854  95000014 b        #0xfffffe000b1d7aa8; -> 0xfffffe000b1d7aa8 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7858  f40301aa mov      x20, x1
0xfffffe000b1d785c  e00313aa mov      x0, x19
0xfffffe000b1d7860  f80303aa mov      x24, x3
0xfffffe000b1d7864  e10303aa mov      x1, x3
0xfffffe000b1d7868  04010094 bl       #0xfffffe000b1d7c78; CALL 0xfffffe000b1d7c78 sz=0x738 'iled to get data address @%s:%d'; "Can't create Tracker GC thread"; 'reason.c'
0xfffffe000b1d786c  e08f00b9 str      w0, [sp, #0x8c]
0xfffffe000b1d7870  00020034 cbz      w0, #0xfffffe000b1d78b0
0xfffffe000b1d7874  682e4079 ldrh     w8, [x19, #0x16]
0xfffffe000b1d7878  08791d12 and      w8, w8, #0xfffffffb
0xfffffe000b1d787c  682e0079 strh     w8, [x19, #0x16]
0xfffffe000b1d7880  e00315aa mov      x0, x21
0xfffffe000b1d7884  e10314aa mov      x1, x20
0xfffffe000b1d7888  08000014 b        #0xfffffe000b1d78a8; -> 0xfffffe000b1d78a8 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d788c  08048052 mov      w8, #0x20
0xfffffe000b1d7890  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b1d7894  e00318aa mov      x0, x24
0xfffffe000b1d7898  21008052 mov      w1, #1
0xfffffe000b1d789c  e995ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b1d78a0  e10314aa mov      x1, x20
0xfffffe000b1d78a4  e00315aa mov      x0, x21
0xfffffe000b1d78a8  e90316aa mov      x9, x22
0xfffffe000b1d78ac  7f000014 b        #0xfffffe000b1d7aa8; -> 0xfffffe000b1d7aa8 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d78b0  481740f9 ldr      x8, [x26, #0x28]; [0xfffffe000b8acaa8] ?
0xfffffe000b1d78b4  e10314aa mov      x1, x20
0xfffffe000b1d78b8  f40301aa mov      x20, x1
0xfffffe000b1d78bc  170940f9 ldr      x23, [x8, #0x10]; [0xfffffe0007f08010] ?
0xfffffe000b1d78c0  7f0217eb cmp      x19, x23
0xfffffe000b1d78c4  80000054 b.eq     #0xfffffe000b1d78d4; -> 0xfffffe000b1d78d4 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d78c8  e00313aa mov      x0, x19
0xfffffe000b1d78cc  e10317aa mov      x1, x23
0xfffffe000b1d78d0  1bfdff97 bl       #0xfffffe000b1d6d3c; CALL 0xfffffe000b1d6d3c sz=0x14c 
0xfffffe000b1d78d4  482740f9 ldr      x8, [x26, #0x48]; [0xfffffe000b8acac8] ?
0xfffffe000b1d78d8  092d00b0 adrp     x9, #0xfffffe000b778000; page 0xfffffe000b778000
0xfffffe000b1d78dc  29a11491 add      x9, x9, #0x528; 0xfffffe000b778528 ?
0xfffffe000b1d78e0  1f0100f1 cmp      x8, #0
0xfffffe000b1d78e4  2101889a csel     x1, x9, x8, eq
0xfffffe000b1d78e8  e0c20191 add      x0, x23, #0x70
0xfffffe000b1d78ec  e4330291 add      x4, sp, #0x8c
0xfffffe000b1d78f0  e20316aa mov      x2, x22
0xfffffe000b1d78f4  e30315aa mov      x3, x21
0xfffffe000b1d78f8  90e1ff97 bl       #0xfffffe000b1cff38; CALL 0xfffffe000b1cff38 sz=0x2fc 'sbappendadddr 1'; 'uipc_socket2.c'; 'sbappendaddr'
0xfffffe000b1d78fc  c0020034 cbz      w0, #0xfffffe000b1d7954
0xfffffe000b1d7900  e80e41b9 ldr      w8, [x23, #0x10c]
0xfffffe000b1d7904  88000035 cbnz     w8, #0xfffffe000b1d7914
0xfffffe000b1d7908  e8c24339 ldrb     w8, [x23, #0xf0]
0xfffffe000b1d790c  1f0d1d72 tst      w8, #0x78
0xfffffe000b1d7910  a0000054 b.eq     #0xfffffe000b1d7924; -> 0xfffffe000b1d7924 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7914  e1c20191 add      x1, x23, #0x70
0xfffffe000b1d7918  e00317aa mov      x0, x23
0xfffffe000b1d791c  e20313aa mov      x2, x19
0xfffffe000b1d7920  1dd3ff97 bl       #0xfffffe000b1cc594; CALL 0xfffffe000b1cc594 sz=0x424 
0xfffffe000b1d7924  150080d2 mov      x21, #0
0xfffffe000b1d7928  7f0217eb cmp      x19, x23
0xfffffe000b1d792c  80000054 b.eq     #0xfffffe000b1d793c; -> 0xfffffe000b1d793c FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7930  e00317aa mov      x0, x23
0xfffffe000b1d7934  21008052 mov      w1, #1
0xfffffe000b1d7938  c295ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b1d793c  180b00b4 cbz      x24, #0xfffffe000b1d7a9c
0xfffffe000b1d7940  5f0319eb cmp      x26, x25
0xfffffe000b1d7944  22160054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7948  e0031aaa mov      x0, x26
0xfffffe000b1d794c  99020094 bl       #0xfffffe000b1d83b0; CALL 0xfffffe000b1d83b0 sz=0x5b0 'iled to get data address @%s:%d'; 'on failed to allocate @%s:%d'; 'unpdisconnect'
0xfffffe000b1d7950  53000014 b        #0xfffffe000b1d7a9c; -> 0xfffffe000b1d7a9c FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7954  e88f40b9 ldr      w8, [sp, #0x8c]
0xfffffe000b1d7958  1f010071 cmp      w8, #0
0xfffffe000b1d795c  a40a40fa ccmp     x21, #0, #4, eq
0xfffffe000b1d7960  f513959a csel     x21, xzr, x21, ne
0xfffffe000b1d7964  7f0217eb cmp      x19, x23
0xfffffe000b1d7968  41feff54 b.ne     #0xfffffe000b1d7930; -> 0xfffffe000b1d7930 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d796c  f4ffff17 b        #0xfffffe000b1d793c; -> 0xfffffe000b1d793c FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7970  08008052 mov      w8, #0
0xfffffe000b1d7974  e9721591 add      x9, x23, #0x55c
0xfffffe000b1d7978  ea9f40b9 ldr      w10, [sp, #0x9c]
0xfffffe000b1d797c  4a09c05a rev      w10, w10
0xfffffe000b1d7980  e92b01a9 stp      x9, x10, [sp, #0x10]
0xfffffe000b1d7984  89f6fdb0 adrp     x9, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1d7988  29353091 add      x9, x9, #0xc0d; 0xfffffe00070a8c0d STR "uipc_send"
0xfffffe000b1d798c  e92300a9 stp      x9, x8, [sp]
0xfffffe000b1d7990  a0f1fdb0 adrp     x0, #0xfffffe000700c000; page 0xfffffe000700c000
0xfffffe000b1d7994  00000091 add      x0, x0, #0; 0xfffffe000700c000 ?
0xfffffe000b1d7998  a1310090 adrp     x1, #0xfffffe000b80b000; page 0xfffffe000b80b000
0xfffffe000b1d799c  21000b91 add      x1, x1, #0x2c0; 0xfffffe000b80b2c0 ?
0xfffffe000b1d79a0  43f9fdb0 adrp     x3, #0xfffffe0007100000; page 0xfffffe0007100000
0xfffffe000b1d79a4  63800191 add      x3, x3, #0x60; 0xfffffe0007100060 STR "%s[mDNSResponder] pid=%d (%s): op=0x%x"
0xfffffe000b1d79a8  02008052 mov      w2, #0
0xfffffe000b1d79ac  b5bb0494 bl       #0xfffffe000b306880; CALL 0xfffffe000b306880 sz=0x54 
0xfffffe000b1d79b0  e00315aa mov      x0, x21
0xfffffe000b1d79b4  e10314aa mov      x1, x20
0xfffffe000b1d79b8  f40301aa mov      x20, x1
0xfffffe000b1d79bc  17030f91 add      x23, x24, #0x3c0
0xfffffe000b1d79c0  e00000b4 cbz      x0, #0xfffffe000b1d79dc
0xfffffe000b1d79c4  00c30191 add      x0, x24, #0x70
0xfffffe000b1d79c8  e3330291 add      x3, sp, #0x8c
0xfffffe000b1d79cc  e10316aa mov      x1, x22
0xfffffe000b1d79d0  e20315aa mov      x2, x21
0xfffffe000b1d79d4  18e2ff97 bl       #0xfffffe000b1d0234; CALL 0xfffffe000b1d0234 sz=0x450 'cess.enhanced-security-version'; 'fd_vn_data}{?=[2Q]}}20'; 'sbappendcontrol 1'
0xfffffe000b1d79d8  07000014 b        #0xfffffe000b1d79f4; -> 0xfffffe000b1d79f4 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d79dc  1f0317eb cmp      x24, x23
0xfffffe000b1d79e0  42110054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d79e4  00c30191 add      x0, x24, #0x70
0xfffffe000b1d79e8  e10316aa mov      x1, x22
0xfffffe000b1d79ec  02008052 mov      w2, #0
0xfffffe000b1d79f0  76dbff97 bl       #0xfffffe000b1ce7c8; CALL 0xfffffe000b1ce7c8 sz=0x25c 'sbappend 1'; 'sbappend 2'; 'ernal'
0xfffffe000b1d79f4  087b40b9 ldr      w8, [x24, #0x78]
0xfffffe000b1d79f8  491740f9 ldr      x9, [x26, #0x28]; [0xfffffe000b8acaa8] ?
0xfffffe000b1d79fc  295d40b9 ldr      w9, [x9, #0x5c]; [0xfffffe00070a8c69] ?
0xfffffe000b1d7a00  6a3e41b9 ldr      w10, [x19, #0x13c]
0xfffffe000b1d7a04  2801084b sub      w8, w9, w8
0xfffffe000b1d7a08  08010a0b add      w8, w8, w10
0xfffffe000b1d7a0c  683e01b9 str      w8, [x19, #0x13c]
0xfffffe000b1d7a10  087b40b9 ldr      w8, [x24, #0x78]
0xfffffe000b1d7a14  491740f9 ldr      x9, [x26, #0x28]; [0xfffffe000b8acaa8] ?
0xfffffe000b1d7a18  285d00b9 str      w8, [x9, #0x5c]
0xfffffe000b1d7a1c  e10318aa mov      x1, x24
0xfffffe000b1d7a20  280c47b8 ldr      w8, [x1, #0x70]!; [0xfffffe000b80b330] ?
0xfffffe000b1d7a24  693641b9 ldr      w9, [x19, #0x134]
0xfffffe000b1d7a28  4a1740f9 ldr      x10, [x26, #0x28]; [0xfffffe000b8acaa8] ?
0xfffffe000b1d7a2c  4a5940b9 ldr      w10, [x10, #0x58]; [0xfffffe0007dfa058] ?
0xfffffe000b1d7a30  08010a4b sub      w8, w8, w10
0xfffffe000b1d7a34  2801086b subs     w8, w9, w8
0xfffffe000b1d7a38  e8b3881a csel     w8, wzr, w8, lt
0xfffffe000b1d7a3c  683601b9 str      w8, [x19, #0x134]
0xfffffe000b1d7a40  280040b9 ldr      w8, [x1]; [0xfffffe000b80b2c0] ?
0xfffffe000b1d7a44  491740f9 ldr      x9, [x26, #0x28]; [0xfffffe000b8acaa8] ?
0xfffffe000b1d7a48  285900b9 str      w8, [x9, #0x58]
0xfffffe000b1d7a4c  800c0034 cbz      w0, #0xfffffe000b1d7bdc
0xfffffe000b1d7a50  1f0317eb cmp      x24, x23
0xfffffe000b1d7a54  a20d0054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7a58  080f41b9 ldr      w8, [x24, #0x10c]
0xfffffe000b1d7a5c  88000035 cbnz     w8, #0xfffffe000b1d7a6c
0xfffffe000b1d7a60  08c34339 ldrb     w8, [x24, #0xf0]
0xfffffe000b1d7a64  1f0d1d72 tst      w8, #0x78
0xfffffe000b1d7a68  80000054 b.eq     #0xfffffe000b1d7a78; -> 0xfffffe000b1d7a78 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7a6c  e00318aa mov      x0, x24
0xfffffe000b1d7a70  e20313aa mov      x2, x19
0xfffffe000b1d7a74  c8d2ff97 bl       #0xfffffe000b1cc594; CALL 0xfffffe000b1cc594 sz=0x424 
0xfffffe000b1d7a78  000080d2 mov      x0, #0
0xfffffe000b1d7a7c  7f0218eb cmp      x19, x24
0xfffffe000b1d7a80  a00b0054 b.eq     #0xfffffe000b1d7bf4; -> 0xfffffe000b1d7bf4 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7a84  1f0317eb cmp      x24, x23
0xfffffe000b1d7a88  020c0054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7a8c  f50300aa mov      x21, x0
0xfffffe000b1d7a90  e00318aa mov      x0, x24
0xfffffe000b1d7a94  21008052 mov      w1, #1
0xfffffe000b1d7a98  6a95ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b1d7a9c  090080d2 mov      x9, #0
0xfffffe000b1d7aa0  e00315aa mov      x0, x21
0xfffffe000b1d7aa4  e10314aa mov      x1, x20
0xfffffe000b1d7aa8  60aec03d ldr      q0, [x19, #0x2b0]
0xfffffe000b1d7aac  28008052 mov      w8, #1
0xfffffe000b1d7ab0  010d084e dup      v1.2d, x8
0xfffffe000b1d7ab4  611f184e mov      v1.d[1], x27
0xfffffe000b1d7ab8  0084e14e add      v0.2d, v0.2d, v1.2d
0xfffffe000b1d7abc  60ae803d str      q0, [x19, #0x2b0]
0xfffffe000b1d7ac0  e1030836 tbz      w1, #1, #0xfffffe000b1d7b3c
0xfffffe000b1d7ac4  f50309aa mov      x21, x9
0xfffffe000b1d7ac8  f60300aa mov      x22, x0
0xfffffe000b1d7acc  e00313aa mov      x0, x19
0xfffffe000b1d7ad0  39daff97 bl       #0xfffffe000b1ce3b4; CALL 0xfffffe000b1ce3b4 sz=0xbc 
0xfffffe000b1d7ad4  5f0319eb cmp      x26, x25
0xfffffe000b1d7ad8  82090054 b.hs     #0xfffffe000b1d7c08; -> 0xfffffe000b1d7c08 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7adc  480b40f9 ldr      x8, [x26, #0x10]; [0xfffffe000b8aca90] ?
0xfffffe000b1d7ae0  09094079 ldrh     w9, [x8, #4]; [0xfffffe0007f08004] ?
0xfffffe000b1d7ae4  3f050071 cmp      w9, #1
0xfffffe000b1d7ae8  e00316aa mov      x0, x22
0xfffffe000b1d7aec  e90315aa mov      x9, x21
0xfffffe000b1d7af0  61020054 b.ne     #0xfffffe000b1d7b3c; -> 0xfffffe000b1d7b3c FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7af4  4a1740f9 ldr      x10, [x26, #0x28]; [0xfffffe000b8acaa8] ?
0xfffffe000b1d7af8  2a0200b4 cbz      x10, #0xfffffe000b1d7b3c
0xfffffe000b1d7afc  540940f9 ldr      x20, [x10, #0x10]; [0xfffffe0007dfa010] ?
0xfffffe000b1d7b00  1f0114eb cmp      x8, x20
0xfffffe000b1d7b04  40010054 b.eq     #0xfffffe000b1d7b2c; -> 0xfffffe000b1d7b2c FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7b08  e00308aa mov      x0, x8
0xfffffe000b1d7b0c  e10314aa mov      x1, x20
0xfffffe000b1d7b10  8bfcff97 bl       #0xfffffe000b1d6d3c; CALL 0xfffffe000b1d6d3c sz=0x14c 
0xfffffe000b1d7b14  e00314aa mov      x0, x20
0xfffffe000b1d7b18  56daff97 bl       #0xfffffe000b1ce470; CALL 0xfffffe000b1ce470 sz=0xbc 
0xfffffe000b1d7b1c  e00314aa mov      x0, x20
0xfffffe000b1d7b20  21008052 mov      w1, #1
0xfffffe000b1d7b24  4795ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b1d7b28  03000014 b        #0xfffffe000b1d7b34; -> 0xfffffe000b1d7b34 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7b2c  e00314aa mov      x0, x20
0xfffffe000b1d7b30  50daff97 bl       #0xfffffe000b1ce470; CALL 0xfffffe000b1ce470 sz=0xbc 
0xfffffe000b1d7b34  e00316aa mov      x0, x22
0xfffffe000b1d7b38  e90315aa mov      x9, x21
0xfffffe000b1d7b3c  000200b4 cbz      x0, #0xfffffe000b1d7b7c
0xfffffe000b1d7b40  e88f40b9 ldr      w8, [sp, #0x8c]
0xfffffe000b1d7b44  c8010034 cbz      w8, #0xfffffe000b1d7b7c
0xfffffe000b1d7b48  f40300aa mov      x20, x0
0xfffffe000b1d7b4c  f50309aa mov      x21, x9
0xfffffe000b1d7b50  e00313aa mov      x0, x19
0xfffffe000b1d7b54  01008052 mov      w1, #0
0xfffffe000b1d7b58  3a95ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b1d7b5c  e00314aa mov      x0, x20
0xfffffe000b1d7b60  80030094 bl       #0xfffffe000b1d8960; CALL 0xfffffe000b1d8960 sz=0x134 
0xfffffe000b1d7b64  e00313aa mov      x0, x19
0xfffffe000b1d7b68  01008052 mov      w1, #0
0xfffffe000b1d7b6c  f8a1ff97 bl       #0xfffffe000b1c034c; CALL 0xfffffe000b1c034c sz=0xdc 
0xfffffe000b1d7b70  e90315aa mov      x9, x21
0xfffffe000b1d7b74  e00314aa mov      x0, x20
0xfffffe000b1d7b78  02000014 b        #0xfffffe000b1d7b80; -> 0xfffffe000b1d7b80 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7b7c  80a2ffb4 cbz      x0, #0xfffffe000b1d6fcc
0xfffffe000b1d7b80  f30309aa mov      x19, x9
0xfffffe000b1d7b84  d46cff97 bl       #0xfffffe000b1b2ed4; CALL 0xfffffe000b1b2ed4 sz=0x4a4 '/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_m'; 'rfa->minref == rfa->refcnt'; 'sid %lld proc %s:%d @%s:%d'
0xfffffe000b1d7b88  e0ffffb5 cbnz     x0, #0xfffffe000b1d7b84
0xfffffe000b1d7b8c  e90313aa mov      x9, x19
0xfffffe000b1d7b90  890000b4 cbz      x9, #0xfffffe000b1d7ba0
0xfffffe000b1d7b94  e00309aa mov      x0, x9
0xfffffe000b1d7b98  cf6cff97 bl       #0xfffffe000b1b2ed4; CALL 0xfffffe000b1b2ed4 sz=0x4a4 '/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_m'; 'rfa->minref == rfa->refcnt'; 'sid %lld proc %s:%d @%s:%d'
0xfffffe000b1d7b9c  e0ffffb5 cbnz     x0, #0xfffffe000b1d7b98
0xfffffe000b1d7ba0  e08f40b9 ldr      w0, [sp, #0x8c]
0xfffffe000b1d7ba4  a8035af8 ldur     x8, [x29, #-0x60]
0xfffffe000b1d7ba8  c92d00b0 adrp     x9, #0xfffffe000b790000; page 0xfffffe000b790000
0xfffffe000b1d7bac  29010091 add      x9, x9, #0; 0xfffffe000b790000 ?
0xfffffe000b1d7bb0  290140f9 ldr      x9, [x9]; [0xfffffe000b790000] ?
0xfffffe000b1d7bb4  3f0108eb cmp      x9, x8
0xfffffe000b1d7bb8  81030054 b.ne     #0xfffffe000b1d7c28; -> 0xfffffe000b1d7c28 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7bbc  fd7b53a9 ldp      x29, x30, [sp, #0x130]
0xfffffe000b1d7bc0  f44f52a9 ldp      x20, x19, [sp, #0x120]
0xfffffe000b1d7bc4  f65751a9 ldp      x22, x21, [sp, #0x110]
0xfffffe000b1d7bc8  f85f50a9 ldp      x24, x23, [sp, #0x100]
0xfffffe000b1d7bcc  fa674fa9 ldp      x26, x25, [sp, #0xf0]
0xfffffe000b1d7bd0  fc6f4ea9 ldp      x28, x27, [sp, #0xe0]
0xfffffe000b1d7bd4  ff030591 add      sp, sp, #0x140
0xfffffe000b1d7bd8  ff0f5fd6 retab    
0xfffffe000b1d7bdc  e88f40b9 ldr      w8, [sp, #0x8c]
0xfffffe000b1d7be0  1f010071 cmp      w8, #0
0xfffffe000b1d7be4  a40a40fa ccmp     x21, #0, #4, eq
0xfffffe000b1d7be8  e013959a csel     x0, xzr, x21, ne
0xfffffe000b1d7bec  7f0218eb cmp      x19, x24
0xfffffe000b1d7bf0  a1f4ff54 b.ne     #0xfffffe000b1d7a84; -> 0xfffffe000b1d7a84 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7bf4  090080d2 mov      x9, #0
0xfffffe000b1d7bf8  abffff17 b        #0xfffffe000b1d7aa4; -> 0xfffffe000b1d7aa4 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7bfc  00430391 add      x0, x24, #0xd0
0xfffffe000b1d7c00  db35e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1d7c04  c0feff17 b        #0xfffffe000b1d7704; -> 0xfffffe000b1d7704 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7c08  20a32ad4 brk      #0x5519; -> 0x5519 ?
0xfffffe000b1d7c0c  e84340f9 ldr      x8, [sp, #0x80]
0xfffffe000b1d7c10  00410391 add      x0, x8, #0xd0; 0xfffffe0007f080d0 ?
0xfffffe000b1d7c14  e1030baa mov      x1, x11
0xfffffe000b1d7c18  d535e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1d7c1c  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b1d7c20  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1d7c24  e3fdff17 b        #0xfffffe000b1d73b0; -> 0xfffffe000b1d73b0 FUNC 0xfffffe000b1d6f1c
0xfffffe000b1d7c28  1d8d0a94 bl       #0xfffffe000b47b09c; CALL 0xfffffe000b47b09c sz=0x2c 'stack_protector.c'
0xfffffe000b1d7c2c  88f6fdb0 adrp     x8, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1d7c30  08652291 add      x8, x8, #0x899; 0xfffffe00070a8899 STR "uipc_usrreq.c"
0xfffffe000b1d7c34  29578052 mov      w9, #0x2b9
0xfffffe000b1d7c38  e82700a9 stp      x8, x9, [sp]
0xfffffe000b1d7c3c  80f6fdb0 adrp     x0, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1d7c40  005c3091 add      x0, x0, #0xc17; 0xfffffe00070a8c17 STR "uipc_send unknown socktype @%s:%d"
0xfffffe000b1d7c44  f78f0a94 bl       #0xfffffe000b47bc20; CALL 0xfffffe000b47bc20 sz=0x3c 
0xfffffe000b1d7c48  682e8079 ldrsh    x8, [x19, #0x16]
0xfffffe000b1d7c4c  693242b9 ldr      w9, [x19, #0x230]
0xfffffe000b1d7c50  6a3642b9 ldr      w10, [x19, #0x234]
0xfffffe000b1d7c54  2b4e8052 mov      w11, #0x271
0xfffffe000b1d7c58  eb1300f9 str      x11, [sp, #0x20]
0xfffffe000b1d7c5c  8bf6fdb0 adrp     x11, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1d7c60  6b652291 add      x11, x11, #0x899; 0xfffffe00070a8899 STR "uipc_usrreq.c"
0xfffffe000b1d7c64  ea2f01a9 stp      x10, x11, [sp, #0x10]
0xfffffe000b1d7c68  e82700a9 stp      x8, x9, [sp]
0xfffffe000b1d7c6c  80f6fdb0 adrp     x0, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1d7c70  00a82e91 add      x0, x0, #0xbaa; 0xfffffe00070a8baa STR "uipc_send connected but no connection? socket state: %x socket flags: %x socket flags1: %x. @%s:%d"
0xfffffe000b1d7c74  eb8f0a94 bl       #0xfffffe000b47bc20; CALL 0xfffffe000b47bc20 sz=0x3c 
