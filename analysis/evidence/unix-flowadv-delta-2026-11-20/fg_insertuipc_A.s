0xfffffe000b181118  7f2303d5 pacibsp  
0xfffffe000b18111c  ff0305d1 sub      sp, sp, #0x140
0xfffffe000b181120  fc6f0ea9 stp      x28, x27, [sp, #0xe0]
0xfffffe000b181124  fa670fa9 stp      x26, x25, [sp, #0xf0]
0xfffffe000b181128  f85f10a9 stp      x24, x23, [sp, #0x100]
0xfffffe000b18112c  f65711a9 stp      x22, x21, [sp, #0x110]
0xfffffe000b181130  f44f12a9 stp      x20, x19, [sp, #0x120]
0xfffffe000b181134  fd7b13a9 stp      x29, x30, [sp, #0x130]
0xfffffe000b181138  fdc30491 add      x29, sp, #0x130
0xfffffe000b18113c  f50304aa mov      x21, x4
0xfffffe000b181140  f60302aa mov      x22, x2
0xfffffe000b181144  a82d00f0 adrp     x8, #0xfffffe000b738000; page 0xfffffe000b738000
0xfffffe000b181148  08010091 add      x8, x8, #0; 0xfffffe000b738000 ?
0xfffffe000b18114c  080140f9 ldr      x8, [x8]; [0xfffffe000b738000] ?
0xfffffe000b181150  a8031af8 stur     x8, [x29, #-0x60]
0xfffffe000b181154  ff8f00b9 str      wzr, [sp, #0x8c]
0xfffffe000b181158  1a0c40f9 ldr      x26, [x0, #0x18]
0xfffffe000b18115c  9a0200b4 cbz      x26, #0xfffffe000b1811ac
0xfffffe000b181160  a1020037 tbnz     w1, #0, #0xfffffe000b1811b4
0xfffffe000b181164  f30300aa mov      x19, x0
0xfffffe000b181168  e90316aa mov      x9, x22
0xfffffe000b18116c  db6240b9 ldr      w27, [x22, #0x60]
0xfffffe000b181170  e00315aa mov      x0, x21
0xfffffe000b181174  553b00b4 cbz      x21, #0xfffffe000b1818dc
0xfffffe000b181178  e54300f9 str      x5, [sp, #0x80]
0xfffffe000b18117c  e32f00f9 str      x3, [sp, #0x58]
0xfffffe000b181180  e15700b9 str      w1, [sp, #0x54]
0xfffffe000b181184  e00313aa mov      x0, x19
0xfffffe000b181188  01008052 mov      w1, #0
0xfffffe000b18118c  2c98ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b181190  e80315aa mov      x8, x21
0xfffffe000b181194  a93e4079 ldrh     w9, [x21, #0x1e]
0xfffffe000b181198  fb6b04a9 stp      x27, x26, [sp, #0x40]
0xfffffe000b18119c  a9010037 tbnz     w9, #0, #0xfffffe000b1811d0
0xfffffe000b1811a0  0c810391 add      x12, x8, #0xe0; 0xfffffe000b7380e0 ?
0xfffffe000b1811a4  0d010891 add      x13, x8, #0x200; 0xfffffe000b738200 ?
0xfffffe000b1811a8  0d000014 b        #0xfffffe000b1811dc; -> 0xfffffe000b1811dc FUNC 0xfffffe000b181118
0xfffffe000b1811ac  c8028052 mov      w8, #0x16
0xfffffe000b1811b0  02000014 b        #0xfffffe000b1811b8; -> 0xfffffe000b1811b8 FUNC 0xfffffe000b181118
0xfffffe000b1811b4  c80c8052 mov      w8, #0x66
0xfffffe000b1811b8  e00315aa mov      x0, x21
0xfffffe000b1811bc  e90316aa mov      x9, x22
0xfffffe000b1811c0  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b1811c4  555b00b5 cbnz     x21, #0xfffffe000b181d2c
0xfffffe000b1811c8  c95b00b5 cbnz     x9, #0xfffffe000b181d40
0xfffffe000b1811cc  e0020014 b        #0xfffffe000b181d4c; -> 0xfffffe000b181d4c FUNC 0xfffffe000b181118
0xfffffe000b1811d0  093140b9 ldr      w9, [x8, #0x30]; [0xfffffe000b738030] ?
0xfffffe000b1811d4  0c1140f9 ldr      x12, [x8, #0x20]; [0xfffffe000b738020] ?
0xfffffe000b1811d8  8d01098b add      x13, x12, x9; 0xfffffe000b7381c3 ?
0xfffffe000b1811dc  090940f9 ldr      x9, [x8, #0x10]; [0xfffffe000b738010] ?
0xfffffe000b1811e0  9f0109eb cmp      x12, x9
0xfffffe000b1811e4  885e0054 b.hi     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b1811e8  37310091 add      x23, x9, #0xc
0xfffffe000b1811ec  ff020deb cmp      x23, x13
0xfffffe000b1811f0  285e0054 b.hi     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b1811f4  2a0940b9 ldr      w10, [x9, #8]
0xfffffe000b1811f8  5f050071 cmp      w10, #1
0xfffffe000b1811fc  c1180054 b.ne     #0xfffffe000b181514; -> 0xfffffe000b181514 FUNC 0xfffffe000b181118
0xfffffe000b181200  2a0540b9 ldr      w10, [x9, #4]
0xfffffe000b181204  ebff9f52 mov      w11, #0xffff
0xfffffe000b181208  5f010b6b cmp      w10, w11
0xfffffe000b18120c  41180054 b.ne     #0xfffffe000b181514; -> 0xfffffe000b181514 FUNC 0xfffffe000b181118
0xfffffe000b181210  290140b9 ldr      w9, [x9]
0xfffffe000b181214  081940b9 ldr      w8, [x8, #0x18]; [0xfffffe000b738018] ?
0xfffffe000b181218  3f01086b cmp      w9, w8
0xfffffe000b18121c  c1170054 b.ne     #0xfffffe000b181514; -> 0xfffffe000b181514 FUNC 0xfffffe000b181118
0xfffffe000b181220  080080d2 mov      x8, #0
0xfffffe000b181224  ea4770b2 mov      x10, #0x3ffff0000
0xfffffe000b181228  8afe9ff2 movk     x10, #0xfff4
0xfffffe000b18122c  38010a8b add      x24, x9, x10
0xfffffe000b181230  14ff42d3 lsr      x20, x24, #2
0xfffffe000b181234  00e4006f movi     v0.2d, #0000000000000000
0xfffffe000b181238  e08305ad stp      q0, q0, [sp, #0xb0]
0xfffffe000b18123c  e08304ad stp      q0, q0, [sp, #0x90]
0xfffffe000b181240  81d038d5 mrs      x1, tpidr_el1
0xfffffe000b181244  29f844b9 ldr      w9, [x1, #0x4f8]
0xfffffe000b181248  eb4340f9 ldr      x11, [sp, #0x80]
0xfffffe000b18124c  6a610391 add      x10, x11, #0xd8
0xfffffe000b181250  497de8c8 casa     x8, x9, [x10]
0xfffffe000b181254  1f0100f1 cmp      x8, #0
0xfffffe000b181258  edb306a9 stp      x13, x12, [sp, #0x68]
0xfffffe000b18125c  e13f00f9 str      x1, [sp, #0x78]
0xfffffe000b181260  41300054 b.ne     #0xfffffe000b181868; -> 0xfffffe000b181868 FUNC 0xfffffe000b181118
0xfffffe000b181264  9f060071 cmp      w20, #1
0xfffffe000b181268  2b310054 b.lt     #0xfffffe000b18188c; -> 0xfffffe000b18188c FUNC 0xfffffe000b181118
0xfffffe000b18126c  e8430291 add      x8, sp, #0x90
0xfffffe000b181270  08010191 add      x8, x8, #0x40; 0xfffffe000b738040 ?
0xfffffe000b181274  e81b00f9 str      x8, [sp, #0x30]
0xfffffe000b181278  1b8342d3 ubfx     x27, x24, #2, #0x1f
0xfffffe000b18127c  38008052 mov      w24, #1
0xfffffe000b181280  d9498052 mov      w25, #0x24e
0xfffffe000b181284  fb3300f9 str      x27, [sp, #0x60]
0xfffffe000b181288  fa0317aa mov      x26, x23
0xfffffe000b18128c  5f030deb cmp      x26, x13
0xfffffe000b181290  22590054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181294  5f030ceb cmp      x26, x12
0xfffffe000b181298  e3580054 b.lo     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b18129c  410340b9 ldr      w1, [x26]
0xfffffe000b1812a0  e04340f9 ldr      x0, [sp, #0x80]
0xfffffe000b1812a4  fc0300aa mov      x28, x0
0xfffffe000b1812a8  b8eafc97 bl       #0xfffffe000b0bbd88; CALL 0xfffffe000b0bbd88 sz=0xc4 
0xfffffe000b1812ac  801400b4 cbz      x0, #0xfffffe000b18153c
0xfffffe000b1812b0  e20300aa mov      x2, x0
0xfffffe000b1812b4  f10300aa mov      x17, x0
0xfffffe000b1812b8  300e41f8 ldr      x16, [x17, #0x10]!
0xfffffe000b1812bc  b00000b4 cbz      x16, #0xfffffe000b1812d0
0xfffffe000b1812c0  b18ee1f2 movk     x17, #0xc75, lsl #48
0xfffffe000b1812c4  301ac1da autda    x16, x17
0xfffffe000b1812c8  e80310aa mov      x8, x16
0xfffffe000b1812cc  02000014 b        #0xfffffe000b1812d4; -> 0xfffffe000b1812d4 FUNC 0xfffffe000b181118
0xfffffe000b1812d0  080080d2 mov      x8, #0
0xfffffe000b1812d4  eb031caa mov      x11, x28
0xfffffe000b1812d8  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b1812dc  f10308aa mov      x17, x8
0xfffffe000b1812e0  308e42f8 ldr      x16, [x17, #0x28]!
0xfffffe000b1812e4  91a7f0f2 movk     x17, #0x853c, lsl #48
0xfffffe000b1812e8  301ac1da autda    x16, x17
0xfffffe000b1812ec  090240b9 ldr      w9, [x16]
0xfffffe000b1812f0  3f250071 cmp      w9, #9
0xfffffe000b1812f4  0923c91a lsl      w9, w24, w9
0xfffffe000b1812f8  2901190a and      w9, w9, w25
0xfffffe000b1812fc  2499407a ccmp     w9, #0, #4, ls
0xfffffe000b181300  a0110054 b.eq     #0xfffffe000b181534; -> 0xfffffe000b181534 FUNC 0xfffffe000b181118
0xfffffe000b181304  08754039 ldrb     w8, [x8, #0x1d]; [0xfffffe000b73805d] ?
0xfffffe000b181308  68110837 tbnz     w8, #1, #0xfffffe000b181534
0xfffffe000b18130c  48800091 add      x8, x2, #0x20
0xfffffe000b181310  5f0008eb cmp      x2, x8
0xfffffe000b181314  02550054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181318  48144079 ldrh     w8, [x2, #0xa]
0xfffffe000b18131c  68111037 tbnz     w8, #2, #0xfffffe000b181548
0xfffffe000b181320  5a130091 add      x26, x26, #4
0xfffffe000b181324  7b0700f1 subs     x27, x27, #1
0xfffffe000b181328  21fbff54 b.ne     #0xfffffe000b18128c; -> 0xfffffe000b18128c FUNC 0xfffffe000b181118
0xfffffe000b18132c  f43340f9 ldr      x20, [sp, #0x60]
0xfffffe000b181330  39f9fdf0 adrp     x25, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b181334  39e70891 add      x25, x25, #0x239; 0xfffffe00070a8239 STR "fg_insertuipc"
0xfffffe000b181338  f41f00f9 str      x20, [sp, #0x38]
0xfffffe000b18133c  940600d1 sub      x20, x20, #1
0xfffffe000b181340  e80a148b add      x8, x23, x20, lsl #2
0xfffffe000b181344  1f010deb cmp      x8, x13
0xfffffe000b181348  00314cfa ccmp     x8, x12, #0, lo
0xfffffe000b18134c  43530054 b.lo     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181350  010140b9 ldr      w1, [x8]; [0xfffffe000b738040] ?
0xfffffe000b181354  e04340f9 ldr      x0, [sp, #0x80]
0xfffffe000b181358  8ceafc97 bl       #0xfffffe000b0bbd88; CALL 0xfffffe000b0bbd88 sz=0xc4 
0xfffffe000b18135c  fb0300aa mov      x27, x0
0xfffffe000b181360  700f41f8 ldr      x16, [x27, #0x10]!
0xfffffe000b181364  fa031baa mov      x26, x27
0xfffffe000b181368  ba8ee1f2 movk     x26, #0xc75, lsl #48
0xfffffe000b18136c  b00000b4 cbz      x16, #0xfffffe000b181380
0xfffffe000b181370  f1031aaa mov      x17, x26
0xfffffe000b181374  301ac1da autda    x16, x17
0xfffffe000b181378  f80310aa mov      x24, x16
0xfffffe000b18137c  02000014 b        #0xfffffe000b181384; -> 0xfffffe000b181384 FUNC 0xfffffe000b181118
0xfffffe000b181380  180080d2 mov      x24, #0
0xfffffe000b181384  080080d2 mov      x8, #0
0xfffffe000b181388  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b18138c  29f844b9 ldr      w9, [x1, #0x4f8]
0xfffffe000b181390  2ac041b9 ldr      w10, [x1, #0x1c0]
0xfffffe000b181394  4a050011 add      w10, w10, #1
0xfffffe000b181398  2ac001b9 str      w10, [x1, #0x1c0]
0xfffffe000b18139c  290564b2 orr      x9, x9, #0x30000000
0xfffffe000b1813a0  0a430191 add      x10, x24, #0x50
0xfffffe000b1813a4  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1813a8  1f0100f1 cmp      x8, #0
0xfffffe000b1813ac  010a0054 b.ne     #0xfffffe000b1814ec; -> 0xfffffe000b1814ec FUNC 0xfffffe000b181118
0xfffffe000b1813b0  fc0318aa mov      x28, x24
0xfffffe000b1813b4  88cf41b8 ldr      w8, [x28, #0x1c]!
0xfffffe000b1813b8  08021836 tbz      w8, #3, #0xfffffe000b1813f8
0xfffffe000b1813bc  00230191 add      x0, x24, #0x48
0xfffffe000b1813c0  824be997 bl       #0xfffffe000abd41c8; CALL 0xfffffe000abd41c8 sz=0x74 
0xfffffe000b1813c4  880340b9 ldr      w8, [x28]
0xfffffe000b1813c8  08011c32 orr      w8, w8, #0x10
0xfffffe000b1813cc  880300b9 str      w8, [x28]
0xfffffe000b1813d0  05230191 add      x5, x24, #0x48
0xfffffe000b1813d4  e0031caa mov      x0, x28
0xfffffe000b1813d8  01008052 mov      w1, #0
0xfffffe000b1813dc  e20319aa mov      x2, x25
0xfffffe000b1813e0  030080d2 mov      x3, #0
0xfffffe000b1813e4  040080d2 mov      x4, #0
0xfffffe000b1813e8  e52cfe97 bl       #0xfffffe000b10c77c; CALL 0xfffffe000b10c77c sz=0x40c 'unknown'
0xfffffe000b1813ec  880340b9 ldr      w8, [x28]
0xfffffe000b1813f0  68fe1f37 tbnz     w8, #3, #0xfffffe000b1813bc
0xfffffe000b1813f4  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b1813f8  00530091 add      x0, x24, #0x14
0xfffffe000b1813fc  29008052 mov      w9, #1
0xfffffe000b181400  090029b8 ldadd    w9, w9, [x0]
0xfffffe000b181404  ea130432 mov      w10, #-0xfffffff
0xfffffe000b181408  29010a0b add      w9, w9, w10
0xfffffe000b18140c  3f010a6b cmp      w9, w10
0xfffffe000b181410  89210054 b.ls     #0xfffffe000b181840; -> 0xfffffe000b181840 FUNC 0xfffffe000b181118
0xfffffe000b181414  091b40b9 ldr      w9, [x24, #0x18]
0xfffffe000b181418  2a050011 add      w10, w9, #1
0xfffffe000b18141c  0a1b00b9 str      w10, [x24, #0x18]
0xfffffe000b181420  a9010034 cbz      w9, #0xfffffe000b181454
0xfffffe000b181424  28f844b9 ldr      w8, [x1, #0x4f8]
0xfffffe000b181428  09430191 add      x9, x24, #0x50
0xfffffe000b18142c  e20308aa mov      x2, x8
0xfffffe000b181430  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b181434  5f00086b cmp      w2, w8
0xfffffe000b181438  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b18143c  c0030054 b.eq     #0xfffffe000b1814b4; -> 0xfffffe000b1814b4 FUNC 0xfffffe000b181118
0xfffffe000b181440  00230191 add      x0, x24, #0x48
0xfffffe000b181444  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b181448  d64ae997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b18144c  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b181450  19000014 b        #0xfffffe000b1814b4; -> 0xfffffe000b1814b4 FUNC 0xfffffe000b181118
0xfffffe000b181454  08011f32 orr      w8, w8, #2
0xfffffe000b181458  081f00b9 str      w8, [x24, #0x1c]
0xfffffe000b18145c  28f844b9 ldr      w8, [x1, #0x4f8]
0xfffffe000b181460  09430191 add      x9, x24, #0x50
0xfffffe000b181464  e20308aa mov      x2, x8
0xfffffe000b181468  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b18146c  5f00086b cmp      w2, w8
0xfffffe000b181470  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b181474  61040054 b.ne     #0xfffffe000b181500; -> 0xfffffe000b181500 FUNC 0xfffffe000b181118
0xfffffe000b181478  887e0353 lsr      w8, w20, #3
0xfffffe000b18147c  e9430291 add      x9, sp, #0x90
0xfffffe000b181480  2801088b add      x8, x9, x8
0xfffffe000b181484  1f0109eb cmp      x8, x9
0xfffffe000b181488  e9379f1a cset     w9, hs
0xfffffe000b18148c  ea1b40f9 ldr      x10, [sp, #0x30]
0xfffffe000b181490  1f010aeb cmp      x8, x10
0xfffffe000b181494  02490054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181498  e9480034 cbz      w9, #0xfffffe000b181db4
0xfffffe000b18149c  890a4092 and      x9, x20, #7
0xfffffe000b1814a0  0a108052 mov      w10, #0x80
0xfffffe000b1814a4  4925c91a lsr      w9, w10, w9
0xfffffe000b1814a8  0a014039 ldrb     w10, [x8]; [0xfffffe000b738040] ?
0xfffffe000b1814ac  4901092a orr      w9, w10, w9
0xfffffe000b1814b0  09010039 strb     w9, [x8]
0xfffffe000b1814b4  700340f9 ldr      x16, [x27]
0xfffffe000b1814b8  700000b4 cbz      x16, #0xfffffe000b1814c4
0xfffffe000b1814bc  f1031aaa mov      x17, x26
0xfffffe000b1814c0  301ac1da autda    x16, x17
0xfffffe000b1814c4  e80e148b add      x8, x23, x20, lsl #3
0xfffffe000b1814c8  1f010deb cmp      x8, x13
0xfffffe000b1814cc  42470054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b1814d0  1f010ceb cmp      x8, x12
0xfffffe000b1814d4  03470054 b.lo     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b1814d8  100100f9 str      x16, [x8]
0xfffffe000b1814dc  e81f40f9 ldr      x8, [sp, #0x38]
0xfffffe000b1814e0  1f0500f1 cmp      x8, #1
0xfffffe000b1814e4  a8f2ff54 b.hi     #0xfffffe000b181338; -> 0xfffffe000b181338 FUNC 0xfffffe000b181118
0xfffffe000b1814e8  21000014 b        #0xfffffe000b18156c; -> 0xfffffe000b18156c FUNC 0xfffffe000b181118
0xfffffe000b1814ec  00230191 add      x0, x24, #0x48
0xfffffe000b1814f0  22008052 mov      w2, #1
0xfffffe000b1814f4  b247e997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b1814f8  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b1814fc  adffff17 b        #0xfffffe000b1813b0; -> 0xfffffe000b1813b0 FUNC 0xfffffe000b181118
0xfffffe000b181500  00230191 add      x0, x24, #0x48
0xfffffe000b181504  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b181508  a64ae997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b18150c  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b181510  daffff17 b        #0xfffffe000b181478; -> 0xfffffe000b181478 FUNC 0xfffffe000b181118
0xfffffe000b181514  c8028052 mov      w8, #0x16
0xfffffe000b181518  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b18151c  e00313aa mov      x0, x19
0xfffffe000b181520  01008052 mov      w1, #0
0xfffffe000b181524  09a4ff97 bl       #0xfffffe000b16a548; CALL 0xfffffe000b16a548 sz=0xdc 
0xfffffe000b181528  e00315aa mov      x0, x21
0xfffffe000b18152c  e90316aa mov      x9, x22
0xfffffe000b181530  ff010014 b        #0xfffffe000b181d2c; -> 0xfffffe000b181d2c FUNC 0xfffffe000b181118
0xfffffe000b181534  d7028052 mov      w23, #0x16
0xfffffe000b181538  0b000014 b        #0xfffffe000b181564; -> 0xfffffe000b181564 FUNC 0xfffffe000b181118
0xfffffe000b18153c  37018052 mov      w23, #9
0xfffffe000b181540  eb031caa mov      x11, x28
0xfffffe000b181544  08000014 b        #0xfffffe000b181564; -> 0xfffffe000b181564 FUNC 0xfffffe000b181118
0xfffffe000b181548  410340b9 ldr      w1, [x26]
0xfffffe000b18154c  f74340f9 ldr      x23, [sp, #0x80]
0xfffffe000b181550  e00317aa mov      x0, x23
0xfffffe000b181554  03018052 mov      w3, #8
0xfffffe000b181558  da0efd97 bl       #0xfffffe000b0c50c0; CALL 0xfffffe000b0c50c0 sz=0x6c 
0xfffffe000b18155c  eb0317aa mov      x11, x23
0xfffffe000b181560  37008052 mov      w23, #1
0xfffffe000b181564  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b181568  ca000014 b        #0xfffffe000b181890; -> 0xfffffe000b181890 FUNC 0xfffffe000b181118
0xfffffe000b18156c  e8a747a9 ldp      x8, x9, [sp, #0x78]
0xfffffe000b181570  08f944b9 ldr      w8, [x8, #0x4f8]; [0xfffffe000b738538] ?
0xfffffe000b181574  29610391 add      x9, x9, #0xd8
0xfffffe000b181578  e20308aa mov      x2, x8
0xfffffe000b18157c  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b181580  5f00086b cmp      w2, w8
0xfffffe000b181584  a1410054 b.ne     #0xfffffe000b181db8; -> 0xfffffe000b181db8 FUNC 0xfffffe000b181118
0xfffffe000b181588  140080d2 mov      x20, #0
0xfffffe000b18158c  f8430291 add      x24, sp, #0x90
0xfffffe000b181590  8e3600f0 adrp     x14, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b181594  cea12191 add      x14, x14, #0x868; 0xfffffe000b854868 ?
0xfffffe000b181598  2f008052 mov      w15, #1
0xfffffe000b18159c  9c3600f0 adrp     x28, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b1815a0  9c832191 add      x28, x28, #0x860; 0xfffffe000b854860 ?
0xfffffe000b1815a4  993600f0 adrp     x25, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b1815a8  9a3600f0 adrp     x26, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b1815ac  5a832291 add      x26, x26, #0x8a0; 0xfffffe000b8548a0 ?
0xfffffe000b1815b0  0e000014 b        #0xfffffe000b1815e8; -> 0xfffffe000b1815e8 FUNC 0xfffffe000b181118
0xfffffe000b1815b4  68f944b9 ldr      w8, [x11, #0x4f8]
0xfffffe000b1815b8  69430191 add      x9, x27, #0x50
0xfffffe000b1815bc  e20308aa mov      x2, x8
0xfffffe000b1815c0  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1815c4  5f00086b cmp      w2, w8
0xfffffe000b1815c8  610e0054 b.ne     #0xfffffe000b181794; -> 0xfffffe000b181794 FUNC 0xfffffe000b181118
0xfffffe000b1815cc  c8012fb8 ldadd    w15, w8, [x14]
0xfffffe000b1815d0  94060091 add      x20, x20, #1
0xfffffe000b1815d4  f7220091 add      x23, x23, #8
0xfffffe000b1815d8  e83340f9 ldr      x8, [sp, #0x60]
0xfffffe000b1815dc  080500f1 subs     x8, x8, #1
0xfffffe000b1815e0  e83300f9 str      x8, [sp, #0x60]
0xfffffe000b1815e4  80110054 b.eq     #0xfffffe000b181814; -> 0xfffffe000b181814 FUNC 0xfffffe000b181118
0xfffffe000b1815e8  887e0353 lsr      w8, w20, #3
0xfffffe000b1815ec  0803088b add      x8, x24, x8
0xfffffe000b1815f0  1f0118eb cmp      x8, x24
0xfffffe000b1815f4  e9379f1a cset     w9, hs
0xfffffe000b1815f8  ea1b40f9 ldr      x10, [sp, #0x30]
0xfffffe000b1815fc  1f010aeb cmp      x8, x10
0xfffffe000b181600  2439407a ccmp     w9, #0, #4, lo
0xfffffe000b181604  803d0054 b.eq     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181608  08014039 ldrb     w8, [x8]; [0xfffffe000b738040] ?
0xfffffe000b18160c  890a0012 and      w9, w20, #7
0xfffffe000b181610  0821c91a lsl      w8, w8, w9
0xfffffe000b181614  c8fd3f36 tbz      w8, #7, #0xfffffe000b1815cc
0xfffffe000b181618  ff020deb cmp      x23, x13
0xfffffe000b18161c  c23c0054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181620  ff020ceb cmp      x23, x12
0xfffffe000b181624  833c0054 b.lo     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181628  fb0240f9 ldr      x27, [x23]
0xfffffe000b18162c  e1031baa mov      x1, x27
0xfffffe000b181630  28cc4138 ldrb     w8, [x1, #0x1c]!
0xfffffe000b181634  88100836 tbz      w8, #1, #0xfffffe000b181844
0xfffffe000b181638  080080d2 mov      x8, #0
0xfffffe000b18163c  eb3f40f9 ldr      x11, [sp, #0x78]
0xfffffe000b181640  69f944b9 ldr      w9, [x11, #0x4f8]
0xfffffe000b181644  897fe8c8 casa     x8, x9, [x28]
0xfffffe000b181648  1f0100f1 cmp      x8, #0
0xfffffe000b18164c  41010054 b.ne     #0xfffffe000b181674; -> 0xfffffe000b181674 FUNC 0xfffffe000b181118
0xfffffe000b181650  285344f9 ldr      x8, [x25, #0x8a0]; [0xfffffe000b8548a0] ?
0xfffffe000b181654  c80200b4 cbz      x8, #0xfffffe000b1816ac
0xfffffe000b181658  090540f9 ldr      x9, [x8, #8]; [0xfffffe000b738048] ?
0xfffffe000b18165c  3f011aeb cmp      x9, x26
0xfffffe000b181660  e10f0054 b.ne     #0xfffffe000b18185c; -> 0xfffffe000b18185c FUNC 0xfffffe000b181118
0xfffffe000b181664  680300f9 str      x8, [x27]
0xfffffe000b181668  285344f9 ldr      x8, [x25, #0x8a0]; [0xfffffe000b8548a0] ?
0xfffffe000b18166c  1b0500f9 str      x27, [x8, #8]
0xfffffe000b181670  10000014 b        #0xfffffe000b1816b0; -> 0xfffffe000b1816b0 FUNC 0xfffffe000b181118
0xfffffe000b181674  803600f0 adrp     x0, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b181678  00602191 add      x0, x0, #0x858; 0xfffffe000b854858 ?
0xfffffe000b18167c  e11f00f9 str      x1, [sp, #0x38]
0xfffffe000b181680  e1030baa mov      x1, x11
0xfffffe000b181684  02008052 mov      w2, #0
0xfffffe000b181688  4d47e997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b18168c  2f008052 mov      w15, #1
0xfffffe000b181690  8e3600f0 adrp     x14, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b181694  cea12191 add      x14, x14, #0x868; 0xfffffe000b854868 ?
0xfffffe000b181698  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b18169c  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1816a0  e11f40f9 ldr      x1, [sp, #0x38]
0xfffffe000b1816a4  285344f9 ldr      x8, [x25, #0x8a0]; [0xfffffe000b8548a0] ?
0xfffffe000b1816a8  88fdffb5 cbnz     x8, #0xfffffe000b181658
0xfffffe000b1816ac  7f0300f9 str      xzr, [x27]
0xfffffe000b1816b0  5b0300f9 str      x27, [x26]
0xfffffe000b1816b4  7a0700f9 str      x26, [x27, #8]
0xfffffe000b1816b8  68f944b9 ldr      w8, [x11, #0x4f8]
0xfffffe000b1816bc  e20308aa mov      x2, x8
0xfffffe000b1816c0  9fffa288 casl     w2, wzr, [x28]
0xfffffe000b1816c4  5f00086b cmp      w2, w8
0xfffffe000b1816c8  61070054 b.ne     #0xfffffe000b1817b4; -> 0xfffffe000b1817b4 FUNC 0xfffffe000b181118
0xfffffe000b1816cc  080080d2 mov      x8, #0
0xfffffe000b1816d0  69f944b9 ldr      w9, [x11, #0x4f8]
0xfffffe000b1816d4  6a430191 add      x10, x27, #0x50
0xfffffe000b1816d8  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1816dc  1f0100f1 cmp      x8, #0
0xfffffe000b1816e0  21080054 b.ne     #0xfffffe000b1817e4; -> 0xfffffe000b1817e4 FUNC 0xfffffe000b181118
0xfffffe000b1816e4  280040b9 ldr      w8, [x1]
0xfffffe000b1816e8  09791e12 and      w9, w8, #0xfffffffd
0xfffffe000b1816ec  290000b9 str      w9, [x1]
0xfffffe000b1816f0  28f61736 tbz      w8, #2, #0xfffffe000b1815b4
0xfffffe000b1816f4  08751d12 and      w8, w8, #0xfffffff9
0xfffffe000b1816f8  280000b9 str      w8, [x1]
0xfffffe000b1816fc  280c48b2 orr      x8, x1, #0xf00000000000000
0xfffffe000b181700  4963fe90 adrp     x9, #0xfffffe0007de9000; page 0xfffffe0007de9000
0xfffffe000b181704  294547f9 ldr      x9, [x9, #0xe88]; [0xfffffe0007de9e88] ?
0xfffffe000b181708  087d48ca eor      x8, x8, x8, lsr #31
0xfffffe000b18170c  aa3094d2 mov      x10, #0xa185
0xfffffe000b181710  ca51aef2 movk     x10, #0x728e, lsl #16
0xfffffe000b181714  2a65daf2 movk     x10, #0xd329, lsl #32
0xfffffe000b181718  aaf6eff2 movk     x10, #0x7fb5, lsl #48
0xfffffe000b18171c  087d0a9b mul      x8, x8, x10
0xfffffe000b181720  086d48ca eor      x8, x8, x8, lsr #27
0xfffffe000b181724  aa899ad2 mov      x10, #0xd44d
0xfffffe000b181728  aa85b7f2 movk     x10, #0xbc2d, lsl #16
0xfffffe000b18172c  8adedbf2 movk     x10, #0xdef4, lsl #32
0xfffffe000b181730  4a3bf0f2 movk     x10, #0x81da, lsl #48
0xfffffe000b181734  087d0a9b mul      x8, x8, x10
0xfffffe000b181738  0afd61d3 lsr      x10, x8, #0x21
0xfffffe000b18173c  4801084a eor      w8, w10, w8
0xfffffe000b181740  4a63fe90 adrp     x10, #0xfffffe0007de9000; page 0xfffffe0007de9000
0xfffffe000b181744  4a914eb9 ldr      w10, [x10, #0xe90]; [0xfffffe0007de9e90] ?
0xfffffe000b181748  4a050051 sub      w10, w10, #1
0xfffffe000b18174c  4801080a and      w8, w10, w8
0xfffffe000b181750  0a038052 mov      w10, #0x18
0xfffffe000b181754  087daa9b umull    x8, w8, w10
0xfffffe000b181758  1fc128eb cmp      x8, w8, sxtw
0xfffffe000b18175c  20c1288b add      x0, x9, w8, sxtw; 0xfffffe0007de90c3 ?
0xfffffe000b181760  3001088b add      x16, x9, x8; 0xfffffe0007de90e2 ?
0xfffffe000b181764  b075e5f2 movk     x16, #0x2bad, lsl #48
0xfffffe000b181768  0000909a csel     x0, x0, x16, eq
0xfffffe000b18176c  02008052 mov      w2, #0
0xfffffe000b181770  03008052 mov      w3, #0
0xfffffe000b181774  04008012 mov      w4, #-1
0xfffffe000b181778  f1e8ea97 bl       #0xfffffe000ac3bb3c; CALL 0xfffffe000ac3bb3c sz=0x178 '%s: debug exceptions enabled in kernel mode @%s:%d'; 'ml_set_interrupts_enabled_with_debug'; 'machine_routines_common.c'
0xfffffe000b18177c  2f008052 mov      w15, #1
0xfffffe000b181780  8e3600f0 adrp     x14, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b181784  cea12191 add      x14, x14, #0x868; 0xfffffe000b854868 ?
0xfffffe000b181788  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b18178c  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b181790  89ffff17 b        #0xfffffe000b1815b4; -> 0xfffffe000b1815b4 FUNC 0xfffffe000b181118
0xfffffe000b181794  60230191 add      x0, x27, #0x48
0xfffffe000b181798  e13f40f9 ldr      x1, [sp, #0x78]
0xfffffe000b18179c  014ae997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b1817a0  2f008052 mov      w15, #1
0xfffffe000b1817a4  8e3600f0 adrp     x14, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b1817a8  cea12191 add      x14, x14, #0x868; 0xfffffe000b854868 ?
0xfffffe000b1817ac  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b1817b0  87ffff17 b        #0xfffffe000b1815cc; -> 0xfffffe000b1815cc FUNC 0xfffffe000b181118
0xfffffe000b1817b4  803600f0 adrp     x0, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b1817b8  00602191 add      x0, x0, #0x858; 0xfffffe000b854858 ?
0xfffffe000b1817bc  e11f00f9 str      x1, [sp, #0x38]
0xfffffe000b1817c0  e1030baa mov      x1, x11
0xfffffe000b1817c4  f749e997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b1817c8  2f008052 mov      w15, #1
0xfffffe000b1817cc  8e3600f0 adrp     x14, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b1817d0  cea12191 add      x14, x14, #0x868; 0xfffffe000b854868 ?
0xfffffe000b1817d4  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b1817d8  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b1817dc  e11f40f9 ldr      x1, [sp, #0x38]
0xfffffe000b1817e0  bbffff17 b        #0xfffffe000b1816cc; -> 0xfffffe000b1816cc FUNC 0xfffffe000b181118
0xfffffe000b1817e4  60230191 add      x0, x27, #0x48
0xfffffe000b1817e8  e11f00f9 str      x1, [sp, #0x38]
0xfffffe000b1817ec  e1030baa mov      x1, x11
0xfffffe000b1817f0  02008052 mov      w2, #0
0xfffffe000b1817f4  f246e997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b1817f8  2f008052 mov      w15, #1
0xfffffe000b1817fc  8e3600f0 adrp     x14, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b181800  cea12191 add      x14, x14, #0x868; 0xfffffe000b854868 ?
0xfffffe000b181804  ec2f47a9 ldp      x12, x11, [sp, #0x70]
0xfffffe000b181808  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b18180c  e11f40f9 ldr      x1, [sp, #0x38]
0xfffffe000b181810  b5ffff17 b        #0xfffffe000b1816e4; -> 0xfffffe000b1816e4 FUNC 0xfffffe000b181118
0xfffffe000b181814  ff8f00b9 str      wzr, [sp, #0x8c]
0xfffffe000b181818  e00313aa mov      x0, x19
0xfffffe000b18181c  01008052 mov      w1, #0
0xfffffe000b181820  4aa3ff97 bl       #0xfffffe000b16a548; CALL 0xfffffe000b16a548 sz=0xdc 
0xfffffe000b181824  e00315aa mov      x0, x21
0xfffffe000b181828  e15740b9 ldr      w1, [sp, #0x54]
0xfffffe000b18182c  e90316aa mov      x9, x22
0xfffffe000b181830  e32f40f9 ldr      x3, [sp, #0x58]
0xfffffe000b181834  fb6b44a9 ldp      x27, x26, [sp, #0x40]
0xfffffe000b181838  e54340f9 ldr      x5, [sp, #0x80]
0xfffffe000b18183c  28000014 b        #0xfffffe000b1818dc; -> 0xfffffe000b1818dc FUNC 0xfffffe000b181118
0xfffffe000b181840  f1e50a94 bl       #0xfffffe000b43b004; CALL 0xfffffe000b43b004 sz=0x44 'refcnt.c'
0xfffffe000b181844  20f9fdf0 adrp     x0, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b181848  006c0891 add      x0, x0, #0x21b; 0xfffffe00070a821b STR "rp[i]->fg_lflags & FG_INSMSGQ"
0xfffffe000b18184c  21f9fdd0 adrp     x1, #0xfffffe00070a7000; page 0xfffffe00070a7000
0xfffffe000b181850  21c43a91 add      x1, x1, #0xeb1; 0xfffffe00070a7eb1 STR "/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_usrreq.c"
0xfffffe000b181854  e23f8152 mov      w2, #0x9ff
0xfffffe000b181858  95d40a94 bl       #0xfffffe000b436aac; CALL 0xfffffe000b436aac sz=0x34 'uipc_socket.c'
0xfffffe000b18185c  883600f0 adrp     x8, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b181860  08812291 add      x8, x8, #0x8a0; 0xfffffe000b8548a0 ?
0xfffffe000b181864  a0ff37d4 brk      #0xbffd; -> 0xbffd ?
0xfffffe000b181868  60410391 add      x0, x11, #0xd0
0xfffffe000b18186c  02008052 mov      w2, #0
0xfffffe000b181870  f9030baa mov      x25, x11
0xfffffe000b181874  d246e997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b181878  ec0747a9 ldp      x12, x1, [sp, #0x70]
0xfffffe000b18187c  ed3740f9 ldr      x13, [sp, #0x68]
0xfffffe000b181880  eb0319aa mov      x11, x25
0xfffffe000b181884  9f060071 cmp      w20, #1
0xfffffe000b181888  2acfff54 b.ge     #0xfffffe000b18126c; -> 0xfffffe000b18126c FUNC 0xfffffe000b181118
0xfffffe000b18188c  17008052 mov      w23, #0
0xfffffe000b181890  28f844b9 ldr      w8, [x1, #0x4f8]; [0xfffffe00070a83a9] ?
0xfffffe000b181894  f8030baa mov      x24, x11
0xfffffe000b181898  69610391 add      x9, x11, #0xd8
0xfffffe000b18189c  e20308aa mov      x2, x8
0xfffffe000b1818a0  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1818a4  5f00086b cmp      w2, w8
0xfffffe000b1818a8  fb6b44a9 ldp      x27, x26, [sp, #0x40]
0xfffffe000b1818ac  e1270054 b.ne     #0xfffffe000b181da8; -> 0xfffffe000b181da8 FUNC 0xfffffe000b181118
0xfffffe000b1818b0  f78f00b9 str      w23, [sp, #0x8c]
0xfffffe000b1818b4  e00313aa mov      x0, x19
0xfffffe000b1818b8  01008052 mov      w1, #0
0xfffffe000b1818bc  23a3ff97 bl       #0xfffffe000b16a548; CALL 0xfffffe000b16a548 sz=0xdc 
0xfffffe000b1818c0  9f020071 cmp      w20, #0
0xfffffe000b1818c4  e00315aa mov      x0, x21
0xfffffe000b1818c8  e15740b9 ldr      w1, [sp, #0x54]
0xfffffe000b1818cc  e90316aa mov      x9, x22
0xfffffe000b1818d0  e32f40f9 ldr      x3, [sp, #0x58]
0xfffffe000b1818d4  e50318aa mov      x5, x24
0xfffffe000b1818d8  8c220054 b.gt     #0xfffffe000b181d28; -> 0xfffffe000b181d28 FUNC 0xfffffe000b181118
0xfffffe000b1818dc  59230391 add      x25, x26, #0xc8; 0xfffffe000b854968 ?
0xfffffe000b1818e0  680a4079 ldrh     w8, [x19, #4]
0xfffffe000b1818e4  1f050071 cmp      w8, #1
0xfffffe000b1818e8  20010054 b.eq     #0xfffffe000b18190c; -> 0xfffffe000b18190c FUNC 0xfffffe000b181118
0xfffffe000b1818ec  1f090071 cmp      w8, #2
0xfffffe000b1818f0  01270054 b.ne     #0xfffffe000b181dd0; -> 0xfffffe000b181dd0 FUNC 0xfffffe000b181118
0xfffffe000b1818f4  481740f9 ldr      x8, [x26, #0x28]; [0xfffffe000b8548c8] ?
0xfffffe000b1818f8  630700b4 cbz      x3, #0xfffffe000b1819e4
0xfffffe000b1818fc  480800b4 cbz      x8, #0xfffffe000b181a04
0xfffffe000b181900  08078052 mov      w8, #0x38
0xfffffe000b181904  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b181908  d3000014 b        #0xfffffe000b181c54; -> 0xfffffe000b181c54 FUNC 0xfffffe000b181118
0xfffffe000b18190c  682e4079 ldrh     w8, [x19, #0x16]
0xfffffe000b181910  c8010837 tbnz     w8, #1, #0xfffffe000b181948
0xfffffe000b181914  c30600b4 cbz      x3, #0xfffffe000b1819ec
0xfffffe000b181918  f70305aa mov      x23, x5
0xfffffe000b18191c  f40301aa mov      x20, x1
0xfffffe000b181920  e00313aa mov      x0, x19
0xfffffe000b181924  e10303aa mov      x1, x3
0xfffffe000b181928  3d010094 bl       #0xfffffe000b181e1c; CALL 0xfffffe000b181e1c sz=0x738 'iled to get data address @%s:%d'; "Can't create Tracker GC thread"; 'reason.c'
0xfffffe000b18192c  e08f00b9 str      w0, [sp, #0x8c]
0xfffffe000b181930  682e4079 ldrh     w8, [x19, #0x16]
0xfffffe000b181934  80070035 cbnz     w0, #0xfffffe000b181a24
0xfffffe000b181938  e00315aa mov      x0, x21
0xfffffe000b18193c  e10314aa mov      x1, x20
0xfffffe000b181940  e90316aa mov      x9, x22
0xfffffe000b181944  e50317aa mov      x5, x23
0xfffffe000b181948  88052037 tbnz     w8, #4, #0xfffffe000b1819f8
0xfffffe000b18194c  481740f9 ldr      x8, [x26, #0x28]; [0xfffffe000b8548c8] ?
0xfffffe000b181950  e82400b4 cbz      x8, #0xfffffe000b181dec
0xfffffe000b181954  180940f9 ldr      x24, [x8, #0x10]; [0xfffffe000b8548b0] ?
0xfffffe000b181958  7f0218eb cmp      x19, x24
0xfffffe000b18195c  60010054 b.eq     #0xfffffe000b181988; -> 0xfffffe000b181988 FUNC 0xfffffe000b181118
0xfffffe000b181960  e00313aa mov      x0, x19
0xfffffe000b181964  f40301aa mov      x20, x1
0xfffffe000b181968  e10318aa mov      x1, x24
0xfffffe000b18196c  f70305aa mov      x23, x5
0xfffffe000b181970  72fdff97 bl       #0xfffffe000b180f38; CALL 0xfffffe000b180f38 sz=0x14c 
0xfffffe000b181974  e50317aa mov      x5, x23
0xfffffe000b181978  e10314aa mov      x1, x20
0xfffffe000b18197c  e00315aa mov      x0, x21
0xfffffe000b181980  682e4079 ldrh     w8, [x19, #0x16]
0xfffffe000b181984  a8052037 tbnz     w8, #4, #0xfffffe000b181a38
0xfffffe000b181988  48874139 ldrb     w8, [x26, #0x61]; [0xfffffe000b854901] ?
0xfffffe000b18198c  c80e2036 tbz      w8, #4, #0xfffffe000b181b64
0xfffffe000b181990  f70305aa mov      x23, x5
0xfffffe000b181994  f40301aa mov      x20, x1
0xfffffe000b181998  ff7f09a9 stp      xzr, xzr, [sp, #0x90]
0xfffffe000b18199c  ffab00b9 str      wzr, [sp, #0xa8]
0xfffffe000b1819a0  ff5300f9 str      xzr, [sp, #0xa0]
0xfffffe000b1819a4  e3430291 add      x3, sp, #0x90
0xfffffe000b1819a8  e00316aa mov      x0, x22
0xfffffe000b1819ac  010080d2 mov      x1, #0
0xfffffe000b1819b0  82038052 mov      w2, #0x1c
0xfffffe000b1819b4  b8acfe97 bl       #0xfffffe000b12cc94; CALL 0xfffffe000b12cc94 sz=0x1d4 
0xfffffe000b1819b8  200d0035 cbnz     w0, #0xfffffe000b181b5c
0xfffffe000b1819bc  e89340b9 ldr      w8, [sp, #0x90]
0xfffffe000b1819c0  0920a052 mov      w9, #0x1000000
0xfffffe000b1819c4  1f01096b cmp      w8, w9
0xfffffe000b1819c8  a10c0054 b.ne     #0xfffffe000b181b5c; -> 0xfffffe000b181b5c FUNC 0xfffffe000b181118
0xfffffe000b1819cc  a86bfef0 adrp     x8, #0xfffffe0007ef8000; page 0xfffffe0007ef8000
0xfffffe000b1819d0  085947f9 ldr      x8, [x8, #0xeb0]; [0xfffffe0007ef8eb0] ?
0xfffffe000b1819d4  ff0208eb cmp      x23, x8
0xfffffe000b1819d8  200a0054 b.eq     #0xfffffe000b181b1c; -> 0xfffffe000b181b1c FUNC 0xfffffe000b181118
0xfffffe000b1819dc  e86240b9 ldr      w8, [x23, #0x60]
0xfffffe000b1819e0  50000014 b        #0xfffffe000b181b20; -> 0xfffffe000b181b20 FUNC 0xfffffe000b181118
0xfffffe000b1819e4  f80303aa mov      x24, x3
0xfffffe000b1819e8  e80300b5 cbnz     x8, #0xfffffe000b181a64
0xfffffe000b1819ec  28078052 mov      w8, #0x39
0xfffffe000b1819f0  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b1819f4  98000014 b        #0xfffffe000b181c54; -> 0xfffffe000b181c54 FUNC 0xfffffe000b181118
0xfffffe000b1819f8  08048052 mov      w8, #0x20
0xfffffe000b1819fc  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b181a00  95000014 b        #0xfffffe000b181c54; -> 0xfffffe000b181c54 FUNC 0xfffffe000b181118
0xfffffe000b181a04  f40301aa mov      x20, x1
0xfffffe000b181a08  e00313aa mov      x0, x19
0xfffffe000b181a0c  f80303aa mov      x24, x3
0xfffffe000b181a10  e10303aa mov      x1, x3
0xfffffe000b181a14  02010094 bl       #0xfffffe000b181e1c; CALL 0xfffffe000b181e1c sz=0x738 'iled to get data address @%s:%d'; "Can't create Tracker GC thread"; 'reason.c'
0xfffffe000b181a18  e08f00b9 str      w0, [sp, #0x8c]
0xfffffe000b181a1c  00020034 cbz      w0, #0xfffffe000b181a5c
0xfffffe000b181a20  682e4079 ldrh     w8, [x19, #0x16]
0xfffffe000b181a24  08791d12 and      w8, w8, #0xfffffffb
0xfffffe000b181a28  682e0079 strh     w8, [x19, #0x16]
0xfffffe000b181a2c  e00315aa mov      x0, x21
0xfffffe000b181a30  e10314aa mov      x1, x20
0xfffffe000b181a34  08000014 b        #0xfffffe000b181a54; -> 0xfffffe000b181a54 FUNC 0xfffffe000b181118
0xfffffe000b181a38  08048052 mov      w8, #0x20
0xfffffe000b181a3c  e88f00b9 str      w8, [sp, #0x8c]
0xfffffe000b181a40  e00318aa mov      x0, x24
0xfffffe000b181a44  21008052 mov      w1, #1
0xfffffe000b181a48  fd95ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b181a4c  e10314aa mov      x1, x20
0xfffffe000b181a50  e00315aa mov      x0, x21
0xfffffe000b181a54  e90316aa mov      x9, x22
0xfffffe000b181a58  7f000014 b        #0xfffffe000b181c54; -> 0xfffffe000b181c54 FUNC 0xfffffe000b181118
0xfffffe000b181a5c  481740f9 ldr      x8, [x26, #0x28]; [0xfffffe000b8548c8] ?
0xfffffe000b181a60  e10314aa mov      x1, x20
0xfffffe000b181a64  f40301aa mov      x20, x1
0xfffffe000b181a68  170940f9 ldr      x23, [x8, #0x10]; [0xfffffe0007ef8010] ?
0xfffffe000b181a6c  7f0217eb cmp      x19, x23
0xfffffe000b181a70  80000054 b.eq     #0xfffffe000b181a80; -> 0xfffffe000b181a80 FUNC 0xfffffe000b181118
0xfffffe000b181a74  e00313aa mov      x0, x19
0xfffffe000b181a78  e10317aa mov      x1, x23
0xfffffe000b181a7c  2ffdff97 bl       #0xfffffe000b180f38; CALL 0xfffffe000b180f38 sz=0x14c 
0xfffffe000b181a80  482740f9 ldr      x8, [x26, #0x48]; [0xfffffe000b8548e8] ?
0xfffffe000b181a84  e92c00f0 adrp     x9, #0xfffffe000b720000; page 0xfffffe000b720000
0xfffffe000b181a88  29a11491 add      x9, x9, #0x528; 0xfffffe000b720528 ?
0xfffffe000b181a8c  1f0100f1 cmp      x8, #0
0xfffffe000b181a90  2101889a csel     x1, x9, x8, eq
0xfffffe000b181a94  e0c20191 add      x0, x23, #0x70
0xfffffe000b181a98  e4330291 add      x4, sp, #0x8c
0xfffffe000b181a9c  e20316aa mov      x2, x22
0xfffffe000b181aa0  e30315aa mov      x3, x21
0xfffffe000b181aa4  a4e1ff97 bl       #0xfffffe000b17a134; CALL 0xfffffe000b17a134 sz=0x2fc 'sbappendadddr 1'; 'uipc_socket2.c'; 'sbappendaddr'
0xfffffe000b181aa8  c0020034 cbz      w0, #0xfffffe000b181b00
0xfffffe000b181aac  e80e41b9 ldr      w8, [x23, #0x10c]
0xfffffe000b181ab0  88000035 cbnz     w8, #0xfffffe000b181ac0
0xfffffe000b181ab4  e8c24339 ldrb     w8, [x23, #0xf0]
0xfffffe000b181ab8  1f0d1d72 tst      w8, #0x78
0xfffffe000b181abc  a0000054 b.eq     #0xfffffe000b181ad0; -> 0xfffffe000b181ad0 FUNC 0xfffffe000b181118
0xfffffe000b181ac0  e1c20191 add      x1, x23, #0x70
0xfffffe000b181ac4  e00317aa mov      x0, x23
0xfffffe000b181ac8  e20313aa mov      x2, x19
0xfffffe000b181acc  31d3ff97 bl       #0xfffffe000b176790; CALL 0xfffffe000b176790 sz=0x424 
0xfffffe000b181ad0  150080d2 mov      x21, #0
0xfffffe000b181ad4  7f0217eb cmp      x19, x23
0xfffffe000b181ad8  80000054 b.eq     #0xfffffe000b181ae8; -> 0xfffffe000b181ae8 FUNC 0xfffffe000b181118
0xfffffe000b181adc  e00317aa mov      x0, x23
0xfffffe000b181ae0  21008052 mov      w1, #1
0xfffffe000b181ae4  d695ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b181ae8  180b00b4 cbz      x24, #0xfffffe000b181c48
0xfffffe000b181aec  5f0319eb cmp      x26, x25
0xfffffe000b181af0  22160054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181af4  e0031aaa mov      x0, x26
0xfffffe000b181af8  97020094 bl       #0xfffffe000b182554; CALL 0xfffffe000b182554 sz=0x5b0 'iled to get data address @%s:%d'; 'on failed to allocate @%s:%d'; 'unpdisconnect'
0xfffffe000b181afc  53000014 b        #0xfffffe000b181c48; -> 0xfffffe000b181c48 FUNC 0xfffffe000b181118
0xfffffe000b181b00  e88f40b9 ldr      w8, [sp, #0x8c]
0xfffffe000b181b04  1f010071 cmp      w8, #0
0xfffffe000b181b08  a40a40fa ccmp     x21, #0, #4, eq
0xfffffe000b181b0c  f513959a csel     x21, xzr, x21, ne
0xfffffe000b181b10  7f0217eb cmp      x19, x23
0xfffffe000b181b14  41feff54 b.ne     #0xfffffe000b181adc; -> 0xfffffe000b181adc FUNC 0xfffffe000b181118
0xfffffe000b181b18  f4ffff17 b        #0xfffffe000b181ae8; -> 0xfffffe000b181ae8 FUNC 0xfffffe000b181118
0xfffffe000b181b1c  08008052 mov      w8, #0
0xfffffe000b181b20  e9721591 add      x9, x23, #0x55c
0xfffffe000b181b24  ea9f40b9 ldr      w10, [sp, #0x9c]
0xfffffe000b181b28  4a09c05a rev      w10, w10
0xfffffe000b181b2c  e92b01a9 stp      x9, x10, [sp, #0x10]
0xfffffe000b181b30  29f9fdf0 adrp     x9, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b181b34  29bd0791 add      x9, x9, #0x1ef; 0xfffffe00070a81ef STR "uipc_send"
0xfffffe000b181b38  e92300a9 stp      x9, x8, [sp]
0xfffffe000b181b3c  40f4fdf0 adrp     x0, #0xfffffe000700c000; page 0xfffffe000700c000
0xfffffe000b181b40  00000091 add      x0, x0, #0; 0xfffffe000700c000 ?
0xfffffe000b181b44  813100d0 adrp     x1, #0xfffffe000b7b3000; page 0xfffffe000b7b3000
0xfffffe000b181b48  21000691 add      x1, x1, #0x180; 0xfffffe000b7b3180 ?
0xfffffe000b181b4c  e3fbfdd0 adrp     x3, #0xfffffe00070ff000; page 0xfffffe00070ff000
0xfffffe000b181b50  63a00791 add      x3, x3, #0x1e8; 0xfffffe00070ff1e8 STR "%s[mDNSResponder] pid=%d (%s): op=0x%x"
0xfffffe000b181b54  02008052 mov      w2, #0
0xfffffe000b181b58  09bb0494 bl       #0xfffffe000b2b077c; CALL 0xfffffe000b2b077c sz=0x54 
0xfffffe000b181b5c  e00315aa mov      x0, x21
0xfffffe000b181b60  e10314aa mov      x1, x20
0xfffffe000b181b64  f40301aa mov      x20, x1
0xfffffe000b181b68  17030f91 add      x23, x24, #0x3c0
0xfffffe000b181b6c  e00000b4 cbz      x0, #0xfffffe000b181b88
0xfffffe000b181b70  00c30191 add      x0, x24, #0x70
0xfffffe000b181b74  e3330291 add      x3, sp, #0x8c
0xfffffe000b181b78  e10316aa mov      x1, x22
0xfffffe000b181b7c  e20315aa mov      x2, x21
0xfffffe000b181b80  2ce2ff97 bl       #0xfffffe000b17a430; CALL 0xfffffe000b17a430 sz=0x450 'red}^{fileops}qQ^{fd_vn_data}{?=[2Q]}}20'; 'cess.enhanced-security-version'; 'fd_vn_data}{?=[2Q]}}20'
0xfffffe000b181b84  07000014 b        #0xfffffe000b181ba0; -> 0xfffffe000b181ba0 FUNC 0xfffffe000b181118
0xfffffe000b181b88  1f0317eb cmp      x24, x23
0xfffffe000b181b8c  42110054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181b90  00c30191 add      x0, x24, #0x70
0xfffffe000b181b94  e10316aa mov      x1, x22
0xfffffe000b181b98  02008052 mov      w2, #0
0xfffffe000b181b9c  8adbff97 bl       #0xfffffe000b1789c4; CALL 0xfffffe000b1789c4 sz=0x25c 'athinfo_internal'; 'sbappend 1'; 'ernal'
0xfffffe000b181ba0  087b40b9 ldr      w8, [x24, #0x78]
0xfffffe000b181ba4  491740f9 ldr      x9, [x26, #0x28]; [0xfffffe000b8548c8] ?
0xfffffe000b181ba8  295d40b9 ldr      w9, [x9, #0x5c]; [0xfffffe00070a824b] ?
0xfffffe000b181bac  6a3e41b9 ldr      w10, [x19, #0x13c]
0xfffffe000b181bb0  2801084b sub      w8, w9, w8
0xfffffe000b181bb4  08010a0b add      w8, w8, w10
0xfffffe000b181bb8  683e01b9 str      w8, [x19, #0x13c]
0xfffffe000b181bbc  087b40b9 ldr      w8, [x24, #0x78]
0xfffffe000b181bc0  491740f9 ldr      x9, [x26, #0x28]; [0xfffffe000b8548c8] ?
0xfffffe000b181bc4  285d00b9 str      w8, [x9, #0x5c]
0xfffffe000b181bc8  e10318aa mov      x1, x24
0xfffffe000b181bcc  280c47b8 ldr      w8, [x1, #0x70]!; [0xfffffe000b7b31f0] ?
0xfffffe000b181bd0  693641b9 ldr      w9, [x19, #0x134]
0xfffffe000b181bd4  4a1740f9 ldr      x10, [x26, #0x28]; [0xfffffe000b8548c8] ?
0xfffffe000b181bd8  4a5940b9 ldr      w10, [x10, #0x58]; [0xfffffe0007de9058] ?
0xfffffe000b181bdc  08010a4b sub      w8, w8, w10
0xfffffe000b181be0  2801086b subs     w8, w9, w8
0xfffffe000b181be4  e8b3881a csel     w8, wzr, w8, lt
0xfffffe000b181be8  683601b9 str      w8, [x19, #0x134]
0xfffffe000b181bec  280040b9 ldr      w8, [x1]; [0xfffffe000b7b3180] ?
0xfffffe000b181bf0  491740f9 ldr      x9, [x26, #0x28]; [0xfffffe000b8548c8] ?
0xfffffe000b181bf4  285900b9 str      w8, [x9, #0x58]
0xfffffe000b181bf8  800c0034 cbz      w0, #0xfffffe000b181d88
0xfffffe000b181bfc  1f0317eb cmp      x24, x23
0xfffffe000b181c00  a20d0054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181c04  080f41b9 ldr      w8, [x24, #0x10c]
0xfffffe000b181c08  88000035 cbnz     w8, #0xfffffe000b181c18
0xfffffe000b181c0c  08c34339 ldrb     w8, [x24, #0xf0]
0xfffffe000b181c10  1f0d1d72 tst      w8, #0x78
0xfffffe000b181c14  80000054 b.eq     #0xfffffe000b181c24; -> 0xfffffe000b181c24 FUNC 0xfffffe000b181118
0xfffffe000b181c18  e00318aa mov      x0, x24
0xfffffe000b181c1c  e20313aa mov      x2, x19
0xfffffe000b181c20  dcd2ff97 bl       #0xfffffe000b176790; CALL 0xfffffe000b176790 sz=0x424 
0xfffffe000b181c24  000080d2 mov      x0, #0
0xfffffe000b181c28  7f0218eb cmp      x19, x24
0xfffffe000b181c2c  a00b0054 b.eq     #0xfffffe000b181da0; -> 0xfffffe000b181da0 FUNC 0xfffffe000b181118
0xfffffe000b181c30  1f0317eb cmp      x24, x23
0xfffffe000b181c34  020c0054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181c38  f50300aa mov      x21, x0
0xfffffe000b181c3c  e00318aa mov      x0, x24
0xfffffe000b181c40  21008052 mov      w1, #1
0xfffffe000b181c44  7e95ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b181c48  090080d2 mov      x9, #0
0xfffffe000b181c4c  e00315aa mov      x0, x21
0xfffffe000b181c50  e10314aa mov      x1, x20
0xfffffe000b181c54  60aec03d ldr      q0, [x19, #0x2b0]
0xfffffe000b181c58  28008052 mov      w8, #1
0xfffffe000b181c5c  010d084e dup      v1.2d, x8
0xfffffe000b181c60  611f184e mov      v1.d[1], x27
0xfffffe000b181c64  0084e14e add      v0.2d, v0.2d, v1.2d
0xfffffe000b181c68  60ae803d str      q0, [x19, #0x2b0]
0xfffffe000b181c6c  e1030836 tbz      w1, #1, #0xfffffe000b181ce8
0xfffffe000b181c70  f50309aa mov      x21, x9
0xfffffe000b181c74  f60300aa mov      x22, x0
0xfffffe000b181c78  e00313aa mov      x0, x19
0xfffffe000b181c7c  4ddaff97 bl       #0xfffffe000b1785b0; CALL 0xfffffe000b1785b0 sz=0xbc 
0xfffffe000b181c80  5f0319eb cmp      x26, x25
0xfffffe000b181c84  82090054 b.hs     #0xfffffe000b181db4; -> 0xfffffe000b181db4 FUNC 0xfffffe000b181118
0xfffffe000b181c88  480b40f9 ldr      x8, [x26, #0x10]; [0xfffffe000b8548b0] ?
0xfffffe000b181c8c  09094079 ldrh     w9, [x8, #4]; [0xfffffe0007ef8004] ?
0xfffffe000b181c90  3f050071 cmp      w9, #1
0xfffffe000b181c94  e00316aa mov      x0, x22
0xfffffe000b181c98  e90315aa mov      x9, x21
0xfffffe000b181c9c  61020054 b.ne     #0xfffffe000b181ce8; -> 0xfffffe000b181ce8 FUNC 0xfffffe000b181118
0xfffffe000b181ca0  4a1740f9 ldr      x10, [x26, #0x28]; [0xfffffe000b8548c8] ?
0xfffffe000b181ca4  2a0200b4 cbz      x10, #0xfffffe000b181ce8
0xfffffe000b181ca8  540940f9 ldr      x20, [x10, #0x10]; [0xfffffe0007de9010] ?
0xfffffe000b181cac  1f0114eb cmp      x8, x20
0xfffffe000b181cb0  40010054 b.eq     #0xfffffe000b181cd8; -> 0xfffffe000b181cd8 FUNC 0xfffffe000b181118
0xfffffe000b181cb4  e00308aa mov      x0, x8
0xfffffe000b181cb8  e10314aa mov      x1, x20
0xfffffe000b181cbc  9ffcff97 bl       #0xfffffe000b180f38; CALL 0xfffffe000b180f38 sz=0x14c 
0xfffffe000b181cc0  e00314aa mov      x0, x20
0xfffffe000b181cc4  6adaff97 bl       #0xfffffe000b17866c; CALL 0xfffffe000b17866c sz=0xbc 
0xfffffe000b181cc8  e00314aa mov      x0, x20
0xfffffe000b181ccc  21008052 mov      w1, #1
0xfffffe000b181cd0  5b95ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b181cd4  03000014 b        #0xfffffe000b181ce0; -> 0xfffffe000b181ce0 FUNC 0xfffffe000b181118
0xfffffe000b181cd8  e00314aa mov      x0, x20
0xfffffe000b181cdc  64daff97 bl       #0xfffffe000b17866c; CALL 0xfffffe000b17866c sz=0xbc 
0xfffffe000b181ce0  e00316aa mov      x0, x22
0xfffffe000b181ce4  e90315aa mov      x9, x21
0xfffffe000b181ce8  000200b4 cbz      x0, #0xfffffe000b181d28
0xfffffe000b181cec  e88f40b9 ldr      w8, [sp, #0x8c]
0xfffffe000b181cf0  c8010034 cbz      w8, #0xfffffe000b181d28
0xfffffe000b181cf4  f40300aa mov      x20, x0
0xfffffe000b181cf8  f50309aa mov      x21, x9
0xfffffe000b181cfc  e00313aa mov      x0, x19
0xfffffe000b181d00  01008052 mov      w1, #0
0xfffffe000b181d04  4e95ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b181d08  e00314aa mov      x0, x20
0xfffffe000b181d0c  7e030094 bl       #0xfffffe000b182b04; CALL 0xfffffe000b182b04 sz=0x10c 
0xfffffe000b181d10  e00313aa mov      x0, x19
0xfffffe000b181d14  01008052 mov      w1, #0
0xfffffe000b181d18  0ca2ff97 bl       #0xfffffe000b16a548; CALL 0xfffffe000b16a548 sz=0xdc 
0xfffffe000b181d1c  e90315aa mov      x9, x21
0xfffffe000b181d20  e00314aa mov      x0, x20
0xfffffe000b181d24  02000014 b        #0xfffffe000b181d2c; -> 0xfffffe000b181d2c FUNC 0xfffffe000b181118
0xfffffe000b181d28  00a5ffb4 cbz      x0, #0xfffffe000b1811c8
0xfffffe000b181d2c  f30309aa mov      x19, x9
0xfffffe000b181d30  e66cff97 bl       #0xfffffe000b15d0c8; CALL 0xfffffe000b15d0c8 sz=0x4a4 '/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_m'; 'sid %lld proc %s:%d @%s:%d'; 'MEXT_REF(m) != 0'
0xfffffe000b181d34  e0ffffb5 cbnz     x0, #0xfffffe000b181d30
0xfffffe000b181d38  e90313aa mov      x9, x19
0xfffffe000b181d3c  890000b4 cbz      x9, #0xfffffe000b181d4c
0xfffffe000b181d40  e00309aa mov      x0, x9
0xfffffe000b181d44  e16cff97 bl       #0xfffffe000b15d0c8; CALL 0xfffffe000b15d0c8 sz=0x4a4 '/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_m'; 'sid %lld proc %s:%d @%s:%d'; 'MEXT_REF(m) != 0'
0xfffffe000b181d48  e0ffffb5 cbnz     x0, #0xfffffe000b181d44
0xfffffe000b181d4c  e08f40b9 ldr      w0, [sp, #0x8c]
0xfffffe000b181d50  a8035af8 ldur     x8, [x29, #-0x60]
0xfffffe000b181d54  a92d00f0 adrp     x9, #0xfffffe000b738000; page 0xfffffe000b738000
0xfffffe000b181d58  29010091 add      x9, x9, #0; 0xfffffe000b738000 ?
0xfffffe000b181d5c  290140f9 ldr      x9, [x9]; [0xfffffe000b738000] ?
0xfffffe000b181d60  3f0108eb cmp      x9, x8
0xfffffe000b181d64  41030054 b.ne     #0xfffffe000b181dcc; -> 0xfffffe000b181dcc FUNC 0xfffffe000b181118
0xfffffe000b181d68  fd7b53a9 ldp      x29, x30, [sp, #0x130]
0xfffffe000b181d6c  f44f52a9 ldp      x20, x19, [sp, #0x120]
0xfffffe000b181d70  f65751a9 ldp      x22, x21, [sp, #0x110]
0xfffffe000b181d74  f85f50a9 ldp      x24, x23, [sp, #0x100]
0xfffffe000b181d78  fa674fa9 ldp      x26, x25, [sp, #0xf0]
0xfffffe000b181d7c  fc6f4ea9 ldp      x28, x27, [sp, #0xe0]
0xfffffe000b181d80  ff030591 add      sp, sp, #0x140
0xfffffe000b181d84  ff0f5fd6 retab    
0xfffffe000b181d88  e88f40b9 ldr      w8, [sp, #0x8c]
0xfffffe000b181d8c  1f010071 cmp      w8, #0
0xfffffe000b181d90  a40a40fa ccmp     x21, #0, #4, eq
0xfffffe000b181d94  e013959a csel     x0, xzr, x21, ne
0xfffffe000b181d98  7f0218eb cmp      x19, x24
0xfffffe000b181d9c  a1f4ff54 b.ne     #0xfffffe000b181c30; -> 0xfffffe000b181c30 FUNC 0xfffffe000b181118
0xfffffe000b181da0  090080d2 mov      x9, #0
0xfffffe000b181da4  abffff17 b        #0xfffffe000b181c50; -> 0xfffffe000b181c50 FUNC 0xfffffe000b181118
0xfffffe000b181da8  00430391 add      x0, x24, #0xd0
0xfffffe000b181dac  7d48e997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b181db0  c0feff17 b        #0xfffffe000b1818b0; -> 0xfffffe000b1818b0 FUNC 0xfffffe000b181118
0xfffffe000b181db4  20a32ad4 brk      #0x5519; -> 0x5519 ?
0xfffffe000b181db8  e1a347a9 ldp      x1, x8, [sp, #0x78]
0xfffffe000b181dbc  00410391 add      x0, x8, #0xd0; 0xfffffe0007ef80d0 ?
0xfffffe000b181dc0  7848e997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b181dc4  edb346a9 ldp      x13, x12, [sp, #0x68]
0xfffffe000b181dc8  f0fdff17 b        #0xfffffe000b181588; -> 0xfffffe000b181588 FUNC 0xfffffe000b181118
0xfffffe000b181dcc  49880a94 bl       #0xfffffe000b423ef0; CALL 0xfffffe000b423ef0 sz=0x2c 'stack_protector.c'
0xfffffe000b181dd0  28f9fdd0 adrp     x8, #0xfffffe00070a7000; page 0xfffffe00070a7000
0xfffffe000b181dd4  08ed3991 add      x8, x8, #0xe7b; 0xfffffe00070a7e7b STR "uipc_usrreq.c"
0xfffffe000b181dd8  29578052 mov      w9, #0x2b9
0xfffffe000b181ddc  e82700a9 stp      x8, x9, [sp]
0xfffffe000b181de0  20f9fdf0 adrp     x0, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b181de4  00e40791 add      x0, x0, #0x1f9; 0xfffffe00070a81f9 STR "uipc_send unknown socktype @%s:%d"
0xfffffe000b181de8  238b0a94 bl       #0xfffffe000b424a74; CALL 0xfffffe000b424a74 sz=0x3c 
0xfffffe000b181dec  682e8079 ldrsh    x8, [x19, #0x16]
0xfffffe000b181df0  693242b9 ldr      w9, [x19, #0x230]
0xfffffe000b181df4  6a3642b9 ldr      w10, [x19, #0x234]
0xfffffe000b181df8  2b4e8052 mov      w11, #0x271
0xfffffe000b181dfc  eb1300f9 str      x11, [sp, #0x20]
0xfffffe000b181e00  2bf9fdd0 adrp     x11, #0xfffffe00070a7000; page 0xfffffe00070a7000
0xfffffe000b181e04  6bed3991 add      x11, x11, #0xe7b; 0xfffffe00070a7e7b STR "uipc_usrreq.c"
0xfffffe000b181e08  ea2f01a9 stp      x10, x11, [sp, #0x10]
0xfffffe000b181e0c  e82700a9 stp      x8, x9, [sp]
0xfffffe000b181e10  20f9fdf0 adrp     x0, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b181e14  00300691 add      x0, x0, #0x18c; 0xfffffe00070a818c STR "uipc_send connected but no connection? socket state: %x socket flags: %x socket flags1: %x. @%s:%d"
0xfffffe000b181e18  178b0a94 bl       #0xfffffe000b424a74; CALL 0xfffffe000b424a74 sz=0x3c 
