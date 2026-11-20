0xfffffe000b15d0c8  7f2303d5 pacibsp  
0xfffffe000b15d0cc  ffc300d1 sub      sp, sp, #0x30
0xfffffe000b15d0d0  f44f01a9 stp      x20, x19, [sp, #0x10]
0xfffffe000b15d0d4  fd7b02a9 stp      x29, x30, [sp, #0x20]
0xfffffe000b15d0d8  fd830091 add      x29, sp, #0x20
0xfffffe000b15d0dc  08384079 ldrh     w8, [x0, #0x1c]
0xfffffe000b15d0e0  88230034 cbz      w8, #0xfffffe000b15d550
0xfffffe000b15d0e4  f40300aa mov      x20, x0
0xfffffe000b15d0e8  130040f9 ldr      x19, [x0]
0xfffffe000b15d0ec  083c4079 ldrh     w8, [x0, #0x1e]
0xfffffe000b15d0f0  e8000836 tbz      w8, #1, #0xfffffe000b15d10c
0xfffffe000b15d0f4  e00314aa mov      x0, x20
0xfffffe000b15d0f8  a4240094 bl       #0xfffffe000b166388; CALL 0xfffffe000b166388 sz=0x74 
0xfffffe000b15d0fc  e00314aa mov      x0, x20
0xfffffe000b15d100  010080d2 mov      x1, #0
0xfffffe000b15d104  4f46ff97 bl       #0xfffffe000b12ea40; CALL 0xfffffe000b12ea40 sz=0x148 '/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_m'; 'm->m_flags & M_PKTHDR'; 'lock_rw_old.c'
0xfffffe000b15d108  883e4079 ldrh     w8, [x20, #0x1e]
0xfffffe000b15d10c  e8140036 tbz      w8, #0, #0xfffffe000b15d3a8
0xfffffe000b15d110  892240f9 ldr      x9, [x20, #0x40]
0xfffffe000b15d114  2a1d4079 ldrh     w10, [x9, #0xe]
0xfffffe000b15d118  48090012 and      w8, w10, #7
0xfffffe000b15d11c  1f110071 cmp      w8, #4
0xfffffe000b15d120  81000054 b.ne     #0xfffffe000b15d130; -> 0xfffffe000b15d130 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d124  280140f9 ldr      x8, [x9]
0xfffffe000b15d128  1f0114eb cmp      x8, x20
0xfffffe000b15d12c  40070054 b.eq     #0xfffffe000b15d214; -> 0xfffffe000b15d214 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d130  28154079 ldrh     w8, [x9, #0xa]
0xfffffe000b15d134  e8070034 cbz      w8, #0xfffffe000b15d230
0xfffffe000b15d138  881640f9 ldr      x8, [x20, #0x28]
0xfffffe000b15d13c  2b114079 ldrh     w11, [x9, #8]
0xfffffe000b15d140  4a010012 and      w10, w10, #1
0xfffffe000b15d144  29290091 add      x9, x9, #0xa
0xfffffe000b15d148  0c008012 mov      w12, #-1
0xfffffe000b15d14c  2901ec78 ldaddalh w12, w9, [x9]
0xfffffe000b15d150  29050051 sub      w9, w9, #1
0xfffffe000b15d154  7f21296b cmp      w11, w9, uxth
0xfffffe000b15d158  4009407a ccmp     w10, #0, #0, eq
0xfffffe000b15d15c  20030054 b.eq     #0xfffffe000b15d1c0; -> 0xfffffe000b15d1c0 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d160  7f21296b cmp      w11, w9, uxth
0xfffffe000b15d164  4409407a ccmp     w10, #0, #4, eq
0xfffffe000b15d168  00120054 b.eq     #0xfffffe000b15d3a8; -> 0xfffffe000b15d3a8 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d16c  892240f9 ldr      x9, [x20, #0x40]
0xfffffe000b15d170  291d4079 ldrh     w9, [x9, #0xe]
0xfffffe000b15d174  491d1037 tbnz     w9, #2, #0xfffffe000b15d51c
0xfffffe000b15d178  8a3a4079 ldrh     w10, [x20, #0x1c]
0xfffffe000b15d17c  c92e00d0 adrp     x9, #0xfffffe000b737000; page 0xfffffe000b737000
0xfffffe000b15d180  29010691 add      x9, x9, #0x180; 0xfffffe000b737180 ?
0xfffffe000b15d184  5f7d0071 cmp      w10, #0x1f
0xfffffe000b15d188  c8060054 b.hi     #0xfffffe000b15d260; -> 0xfffffe000b15d260 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d18c  8bd038d5 mrs      x11, tpidr_el1
0xfffffe000b15d190  6bd940f9 ldr      x11, [x11, #0x1b0]
0xfffffe000b15d194  2b418b8b add      x11, x9, x11, asr #16; 0xfffffe000b737265 ?
0xfffffe000b15d198  6a090aab adds     x10, x11, x10, lsl #2
0xfffffe000b15d19c  c0000054 b.eq     #0xfffffe000b15d1b4; -> 0xfffffe000b15d1b4 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d1a0  6c010291 add      x12, x11, #0x80; 0xfffffe000b7372e5 ?
0xfffffe000b15d1a4  5f010ceb cmp      x10, x12
0xfffffe000b15d1a8  221d0054 b.hs     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d1ac  5f010beb cmp      x10, x11
0xfffffe000b15d1b0  e31c0054 b.lo     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d1b4  0b008012 mov      w11, #-1
0xfffffe000b15d1b8  4a012bb8 ldadd    w11, w10, [x10]
0xfffffe000b15d1bc  3a000014 b        #0xfffffe000b15d2a4; -> 0xfffffe000b15d2a4 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d1c0  480400b4 cbz      x8, #0xfffffe000b15d248
0xfffffe000b15d1c4  f0fffff0 adrp     x16, #0xfffffe000b15c000; page 0xfffffe000b15c000
0xfffffe000b15d1c8  10822b91 add      x16, x16, #0xae0; 0xfffffe000b15cae0 FUNC 0xfffffe000b15cae0
0xfffffe000b15d1cc  314698d2 mov      x17, #0xc231
0xfffffe000b15d1d0  3002c1da pacia    x16, x17
0xfffffe000b15d1d4  1f0110eb cmp      x8, x16
0xfffffe000b15d1d8  c00a0054 b.eq     #0xfffffe000b15d330; -> 0xfffffe000b15d330 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d1dc  f0fffff0 adrp     x16, #0xfffffe000b15c000; page 0xfffffe000b15c000
0xfffffe000b15d1e0  10422b91 add      x16, x16, #0xad0; 0xfffffe000b15cad0 FUNC 0xfffffe000b15cad0
0xfffffe000b15d1e4  314698d2 mov      x17, #0xc231
0xfffffe000b15d1e8  3002c1da pacia    x16, x17
0xfffffe000b15d1ec  1f0110eb cmp      x8, x16
0xfffffe000b15d1f0  a00b0054 b.eq     #0xfffffe000b15d364; -> 0xfffffe000b15d364 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d1f4  801240f9 ldr      x0, [x20, #0x20]
0xfffffe000b15d1f8  813240b9 ldr      w1, [x20, #0x30]
0xfffffe000b15d1fc  400000b4 cbz      x0, #0xfffffe000b15d204
0xfffffe000b15d200  611a0034 cbz      w1, #0xfffffe000b15d54c
0xfffffe000b15d204  821e40f9 ldr      x2, [x20, #0x38]
0xfffffe000b15d208  314698d2 mov      x17, #0xc231
0xfffffe000b15d20c  11093fd7 blraa    x8, x17
0xfffffe000b15d210  5b000014 b        #0xfffffe000b15d37c; -> 0xfffffe000b15d37c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d214  e00314aa mov      x0, x20
0xfffffe000b15d218  78010094 bl       #0xfffffe000b15d7f8; CALL 0xfffffe000b15d7f8 sz=0x1b8 '/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_m'; '(m->m_flags & M_EXT) && (MEXT_FLAGS(m) & EXTF_PAIRED)'; 'm_free_func != NULL'
0xfffffe000b15d21c  c0140035 cbnz     w0, #0xfffffe000b15d4b4
0xfffffe000b15d220  892240f9 ldr      x9, [x20, #0x40]
0xfffffe000b15d224  2a1d4079 ldrh     w10, [x9, #0xe]; [0xfffffe000b73718e] ?
0xfffffe000b15d228  28154079 ldrh     w8, [x9, #0xa]; [0xfffffe000b73718a] ?
0xfffffe000b15d22c  68f8ff35 cbnz     w8, #0xfffffe000b15d138
0xfffffe000b15d230  40fafdb0 adrp     x0, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d234  00d41e91 add      x0, x0, #0x7b5; 0xfffffe00070a67b5 STR "MEXT_REF(m) != 0"
0xfffffe000b15d238  41fafdb0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d23c  21240491 add      x1, x1, #0x109; 0xfffffe00070a6109 STR "/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b15d240  02818052 mov      w2, #0x408
0xfffffe000b15d244  1a660b94 bl       #0xfffffe000b436aac; CALL 0xfffffe000b436aac sz=0x34 'uipc_socket.c'
0xfffffe000b15d248  811240f9 ldr      x1, [x20, #0x20]
0xfffffe000b15d24c  610000b4 cbz      x1, #0xfffffe000b15d258
0xfffffe000b15d250  883240b9 ldr      w8, [x20, #0x30]
0xfffffe000b15d254  c8170034 cbz      w8, #0xfffffe000b15d54c
0xfffffe000b15d258  40048052 mov      w0, #0x22
0xfffffe000b15d25c  47000014 b        #0xfffffe000b15d378; -> 0xfffffe000b15d378 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d260  5ffd0371 cmp      w10, #0xff
0xfffffe000b15d264  08020054 b.hi     #0xfffffe000b15d2a4; -> 0xfffffe000b15d2a4 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d268  eb3100f0 adrp     x11, #0xfffffe000b79c000; page 0xfffffe000b79c000
0xfffffe000b15d26c  6bf10e91 add      x11, x11, #0x3bc; 0xfffffe000b79c3bc ?
0xfffffe000b15d270  6a050a8b add      x10, x11, x10, lsl #1; 0xfffffe000b79c4a0 ?
0xfffffe000b15d274  4a7100b1 adds     x10, x10, #0x1c
0xfffffe000b15d278  20010054 b.eq     #0xfffffe000b15d29c; -> 0xfffffe000b15d29c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d27c  eb3100f0 adrp     x11, #0xfffffe000b79c000; page 0xfffffe000b79c000
0xfffffe000b15d280  6b611791 add      x11, x11, #0x5d8; 0xfffffe000b79c5d8 ?
0xfffffe000b15d284  5f010beb cmp      x10, x11
0xfffffe000b15d288  22160054 b.hs     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d28c  eb3100f0 adrp     x11, #0xfffffe000b79c000; page 0xfffffe000b79c000
0xfffffe000b15d290  6b610f91 add      x11, x11, #0x3d8; 0xfffffe000b79c3d8 ?
0xfffffe000b15d294  5f010beb cmp      x10, x11
0xfffffe000b15d298  a3150054 b.lo     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d29c  0b008012 mov      w11, #-1
0xfffffe000b15d2a0  4a012b78 ldaddh   w11, w10, [x10]
0xfffffe000b15d2a4  8ad038d5 mrs      x10, tpidr_el1
0xfffffe000b15d2a8  4ad940f9 ldr      x10, [x10, #0x1b0]; [0xfffffe000b79c650] ?
0xfffffe000b15d2ac  29418a8b add      x9, x9, x10, asr #16; 0xfffffe000b737264 ?
0xfffffe000b15d2b0  2a010291 add      x10, x9, #0x80; 0xfffffe000b7372e4 ?
0xfffffe000b15d2b4  5f0109eb cmp      x10, x9
0xfffffe000b15d2b8  a9140054 b.ls     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d2bc  2a008052 mov      w10, #1
0xfffffe000b15d2c0  29012ab8 ldadd    w10, w9, [x9]
0xfffffe000b15d2c4  2900e0d2 mov      x9, #0x1000000000000
0xfffffe000b15d2c8  890e00f9 str      x9, [x20, #0x18]
0xfffffe000b15d2cc  9f7e00a9 stp      xzr, xzr, [x20]
0xfffffe000b15d2d0  892240f9 ldr      x9, [x20, #0x40]
0xfffffe000b15d2d4  2a1d4079 ldrh     w10, [x9, #0xe]; [0xfffffe000b737272] ?
0xfffffe000b15d2d8  4a791e12 and      w10, w10, #0xfffffffd
0xfffffe000b15d2dc  2a1d0079 strh     w10, [x9, #0xe]
0xfffffe000b15d2e0  480300b4 cbz      x8, #0xfffffe000b15d348
0xfffffe000b15d2e4  f0fffff0 adrp     x16, #0xfffffe000b15c000; page 0xfffffe000b15c000
0xfffffe000b15d2e8  10822b91 add      x16, x16, #0xae0; 0xfffffe000b15cae0 FUNC 0xfffffe000b15cae0
0xfffffe000b15d2ec  314698d2 mov      x17, #0xc231
0xfffffe000b15d2f0  3002c1da pacia    x16, x17
0xfffffe000b15d2f4  1f0110eb cmp      x8, x16
0xfffffe000b15d2f8  800e0054 b.eq     #0xfffffe000b15d4c8; -> 0xfffffe000b15d4c8 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d2fc  f0fffff0 adrp     x16, #0xfffffe000b15c000; page 0xfffffe000b15c000
0xfffffe000b15d300  10422b91 add      x16, x16, #0xad0; 0xfffffe000b15cad0 FUNC 0xfffffe000b15cad0
0xfffffe000b15d304  314698d2 mov      x17, #0xc231
0xfffffe000b15d308  3002c1da pacia    x16, x17
0xfffffe000b15d30c  1f0110eb cmp      x8, x16
0xfffffe000b15d310  21110054 b.ne     #0xfffffe000b15d534; -> 0xfffffe000b15d534 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d314  810e48b2 orr      x1, x20, #0xf00000000000000
0xfffffe000b15d318  e80301cb neg      x8, x1
0xfffffe000b15d31c  880200f9 str      x8, [x20]
0xfffffe000b15d320  236afeb0 adrp     x3, #0xfffffe0007ea2000; page 0xfffffe0007ea2000
0xfffffe000b15d324  63e00a91 add      x3, x3, #0x2b8; 0xfffffe0007ea22b8 ?
0xfffffe000b15d328  e0048052 mov      w0, #0x27
0xfffffe000b15d32c  6d000014 b        #0xfffffe000b15d4e0; -> 0xfffffe000b15d4e0 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d330  811240f9 ldr      x1, [x20, #0x20]
0xfffffe000b15d334  610000b4 cbz      x1, #0xfffffe000b15d340
0xfffffe000b15d338  883240b9 ldr      w8, [x20, #0x30]
0xfffffe000b15d33c  88100034 cbz      w8, #0xfffffe000b15d54c
0xfffffe000b15d340  60048052 mov      w0, #0x23
0xfffffe000b15d344  0d000014 b        #0xfffffe000b15d378; -> 0xfffffe000b15d378 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d348  810e48b2 orr      x1, x20, #0xf00000000000000
0xfffffe000b15d34c  e80301cb neg      x8, x1
0xfffffe000b15d350  880200f9 str      x8, [x20]
0xfffffe000b15d354  236afeb0 adrp     x3, #0xfffffe0007ea2000; page 0xfffffe0007ea2000
0xfffffe000b15d358  63e00a91 add      x3, x3, #0x2b8; 0xfffffe0007ea22b8 ?
0xfffffe000b15d35c  a0048052 mov      w0, #0x25
0xfffffe000b15d360  60000014 b        #0xfffffe000b15d4e0; -> 0xfffffe000b15d4e0 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d364  811240f9 ldr      x1, [x20, #0x20]
0xfffffe000b15d368  610000b4 cbz      x1, #0xfffffe000b15d374
0xfffffe000b15d36c  883240b9 ldr      w8, [x20, #0x30]
0xfffffe000b15d370  e80e0034 cbz      w8, #0xfffffe000b15d54c
0xfffffe000b15d374  80048052 mov      w0, #0x24
0xfffffe000b15d378  eba5eb97 bl       #0xfffffe000ac46b24; CALL 0xfffffe000ac46b24 sz=0x254 
0xfffffe000b15d37c  812240f9 ldr      x1, [x20, #0x40]
0xfffffe000b15d380  28104079 ldrh     w8, [x1, #8]; [0xfffffe00070a6111] ?
0xfffffe000b15d384  29144079 ldrh     w9, [x1, #0xa]; [0xfffffe00070a6113] ?
0xfffffe000b15d388  1f01096b cmp      w8, w9
0xfffffe000b15d38c  010b0054 b.ne     #0xfffffe000b15d4ec; -> 0xfffffe000b15d4ec FUNC 0xfffffe000b15d0c8
0xfffffe000b15d390  00048052 mov      w0, #0x20
0xfffffe000b15d394  e4a5eb97 bl       #0xfffffe000ac46b24; CALL 0xfffffe000ac46b24 sz=0x254 
0xfffffe000b15d398  883e4079 ldrh     w8, [x20, #0x1e]
0xfffffe000b15d39c  480b0036 tbz      w8, #0, #0xfffffe000b15d504
0xfffffe000b15d3a0  9f1600f9 str      xzr, [x20, #0x28]
0xfffffe000b15d3a4  9ffe03a9 stp      xzr, xzr, [x20, #0x38]
0xfffffe000b15d3a8  883a4079 ldrh     w8, [x20, #0x1c]
0xfffffe000b15d3ac  1f7d0071 cmp      w8, #0x1f
0xfffffe000b15d3b0  e8010054 b.hi     #0xfffffe000b15d3ec; -> 0xfffffe000b15d3ec FUNC 0xfffffe000b15d0c8
0xfffffe000b15d3b4  89d038d5 mrs      x9, tpidr_el1
0xfffffe000b15d3b8  29d940f9 ldr      x9, [x9, #0x1b0]; [0xfffffe000b737414] ?
0xfffffe000b15d3bc  ca2e00d0 adrp     x10, #0xfffffe000b737000; page 0xfffffe000b737000
0xfffffe000b15d3c0  4a010691 add      x10, x10, #0x180; 0xfffffe000b737180 ?
0xfffffe000b15d3c4  4941898b add      x9, x10, x9, asr #16; 0xfffffe000b737263 ?
0xfffffe000b15d3c8  280908ab adds     x8, x9, x8, lsl #2
0xfffffe000b15d3cc  a0000054 b.eq     #0xfffffe000b15d3e0; -> 0xfffffe000b15d3e0 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d3d0  2a010291 add      x10, x9, #0x80; 0xfffffe000b7372e3 ?
0xfffffe000b15d3d4  1f010aeb cmp      x8, x10
0xfffffe000b15d3d8  003149fa ccmp     x8, x9, #0, lo
0xfffffe000b15d3dc  830b0054 b.lo     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d3e0  09008012 mov      w9, #-1
0xfffffe000b15d3e4  080129b8 ldadd    w9, w8, [x8]
0xfffffe000b15d3e8  11000014 b        #0xfffffe000b15d42c; -> 0xfffffe000b15d42c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d3ec  1ffd0371 cmp      w8, #0xff
0xfffffe000b15d3f0  e8010054 b.hi     #0xfffffe000b15d42c; -> 0xfffffe000b15d42c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d3f4  e93100f0 adrp     x9, #0xfffffe000b79c000; page 0xfffffe000b79c000
0xfffffe000b15d3f8  29f10e91 add      x9, x9, #0x3bc; 0xfffffe000b79c3bc ?
0xfffffe000b15d3fc  2805088b add      x8, x9, x8, lsl #1; 0xfffffe000b79c49e ?
0xfffffe000b15d400  087100b1 adds     x8, x8, #0x1c
0xfffffe000b15d404  00010054 b.eq     #0xfffffe000b15d424; -> 0xfffffe000b15d424 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d408  e93100f0 adrp     x9, #0xfffffe000b79c000; page 0xfffffe000b79c000
0xfffffe000b15d40c  29611791 add      x9, x9, #0x5d8; 0xfffffe000b79c5d8 ?
0xfffffe000b15d410  1f0109eb cmp      x8, x9
0xfffffe000b15d414  e93100f0 adrp     x9, #0xfffffe000b79c000; page 0xfffffe000b79c000
0xfffffe000b15d418  29610f91 add      x9, x9, #0x3d8; 0xfffffe000b79c3d8 ?
0xfffffe000b15d41c  003149fa ccmp     x8, x9, #0, lo
0xfffffe000b15d420  63090054 b.lo     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d424  09008012 mov      w9, #-1
0xfffffe000b15d428  08012978 ldaddh   w9, w8, [x8]
0xfffffe000b15d42c  88d038d5 mrs      x8, tpidr_el1
0xfffffe000b15d430  08d940f9 ldr      x8, [x8, #0x1b0]; [0xfffffe000b79c64e] ?
0xfffffe000b15d434  c92e00d0 adrp     x9, #0xfffffe000b737000; page 0xfffffe000b737000
0xfffffe000b15d438  29010691 add      x9, x9, #0x180; 0xfffffe000b737180 ?
0xfffffe000b15d43c  2841888b add      x8, x9, x8, asr #16; 0xfffffe000b737262 ?
0xfffffe000b15d440  09010291 add      x9, x8, #0x80; 0xfffffe000b7372e2 ?
0xfffffe000b15d444  3f0108eb cmp      x9, x8
0xfffffe000b15d448  29080054 b.ls     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d44c  29008052 mov      w9, #1
0xfffffe000b15d450  080129b8 ldadd    w9, w8, [x8]
0xfffffe000b15d454  4800e0d2 mov      x8, #0x2000000000000
0xfffffe000b15d458  00e4006f movi     v0.2d, #0000000000000000
0xfffffe000b15d45c  8002803d str      q0, [x20]
0xfffffe000b15d460  9f2201a9 stp      xzr, x8, [x20, #0x10]
0xfffffe000b15d464  800201ad stp      q0, q0, [x20, #0x20]
0xfffffe000b15d468  9f2200f9 str      xzr, [x20, #0x40]
0xfffffe000b15d46c  e80314aa mov      x8, x20
0xfffffe000b15d470  000d853c str      q0, [x8, #0x50]!
0xfffffe000b15d474  89820291 add      x9, x20, #0xa0
0xfffffe000b15d478  8a220391 add      x10, x20, #0xc8
0xfffffe000b15d47c  9f4e00f9 str      xzr, [x20, #0x98]
0xfffffe000b15d480  3f010aeb cmp      x9, x10
0xfffffe000b15d484  48060054 b.hi     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d488  3f1100f9 str      xzr, [x9, #0x20]
0xfffffe000b15d48c  200100ad stp      q0, q0, [x9]
0xfffffe000b15d490  9f7600b9 str      wzr, [x20, #0x74]
0xfffffe000b15d494  89820391 add      x9, x20, #0xe0
0xfffffe000b15d498  1f0109eb cmp      x8, x9
0xfffffe000b15d49c  82050054 b.hs     #0xfffffe000b15d54c; -> 0xfffffe000b15d54c FUNC 0xfffffe000b15d0c8
0xfffffe000b15d4a0  9f7e0da9 stp      xzr, xzr, [x20, #0xd0]
0xfffffe000b15d4a4  9f3e0079 strh     wzr, [x20, #0x1e]
0xfffffe000b15d4a8  20048052 mov      w0, #0x21
0xfffffe000b15d4ac  e10314aa mov      x1, x20
0xfffffe000b15d4b0  9da5eb97 bl       #0xfffffe000ac46b24; CALL 0xfffffe000ac46b24 sz=0x254 
0xfffffe000b15d4b4  e00313aa mov      x0, x19
0xfffffe000b15d4b8  fd7b42a9 ldp      x29, x30, [sp, #0x20]
0xfffffe000b15d4bc  f44f41a9 ldp      x20, x19, [sp, #0x10]
0xfffffe000b15d4c0  ffc30091 add      sp, sp, #0x30
0xfffffe000b15d4c4  ff0f5fd6 retab    
0xfffffe000b15d4c8  810e48b2 orr      x1, x20, #0xf00000000000000
0xfffffe000b15d4cc  e80301cb neg      x8, x1
0xfffffe000b15d4d0  880200f9 str      x8, [x20]
0xfffffe000b15d4d4  236afeb0 adrp     x3, #0xfffffe0007ea2000; page 0xfffffe0007ea2000
0xfffffe000b15d4d8  63e00a91 add      x3, x3, #0x2b8; 0xfffffe0007ea22b8 ?
0xfffffe000b15d4dc  c0048052 mov      w0, #0x26
0xfffffe000b15d4e0  22008052 mov      w2, #1
0xfffffe000b15d4e4  e6a4eb97 bl       #0xfffffe000ac4687c; CALL 0xfffffe000ac4687c sz=0x1f8 
0xfffffe000b15d4e8  f3ffff17 b        #0xfffffe000b15d4b4; -> 0xfffffe000b15d4b4 FUNC 0xfffffe000b15d0c8
0xfffffe000b15d4ec  40fafdb0 adrp     x0, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d4f0  00181f91 add      x0, x0, #0x7c6; 0xfffffe00070a67c6 STR "rfa->minref == rfa->refcnt"
0xfffffe000b15d4f4  41fafdb0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d4f8  21240491 add      x1, x1, #0x109; 0xfffffe00070a6109 STR "/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b15d4fc  62648052 mov      w2, #0x323
0xfffffe000b15d500  6b650b94 bl       #0xfffffe000b436aac; CALL 0xfffffe000b436aac sz=0x34 'uipc_socket.c'
0xfffffe000b15d504  40fafdb0 adrp     x0, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d508  00841f91 add      x0, x0, #0x7e1; 0xfffffe00070a67e1 STR "m->m_flags & M_EXT"
0xfffffe000b15d50c  41fafdb0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d510  21240491 add      x1, x1, #0x109; 0xfffffe00070a6109 STR "/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b15d514  423a8052 mov      w2, #0x1d2
0xfffffe000b15d518  65650b94 bl       #0xfffffe000b436aac; CALL 0xfffffe000b436aac sz=0x34 'uipc_socket.c'
0xfffffe000b15d51c  40fafdb0 adrp     x0, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d520  00600891 add      x0, x0, #0x218; 0xfffffe00070a6218 STR "!(MEXT_FLAGS(m) & EXTF_PAIRED)"
0xfffffe000b15d524  41fafdb0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d528  21240491 add      x1, x1, #0x109; 0xfffffe00070a6109 STR "/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b15d52c  02cd8052 mov      w2, #0x668
0xfffffe000b15d530  5f650b94 bl       #0xfffffe000b436aac; CALL 0xfffffe000b436aac sz=0x34 'uipc_socket.c'
0xfffffe000b15d534  40fafdb0 adrp     x0, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d538  00dc0891 add      x0, x0, #0x237; 0xfffffe00070a6237 STR "m_free_func == m_16kfree"
0xfffffe000b15d53c  41fafdb0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d540  21240491 add      x1, x1, #0x109; 0xfffffe00070a6109 STR "/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b15d544  c2cf8052 mov      w2, #0x67e
0xfffffe000b15d548  59650b94 bl       #0xfffffe000b436aac; CALL 0xfffffe000b436aac sz=0x34 'uipc_socket.c'
0xfffffe000b15d54c  20a32ad4 brk      #0x5519; -> 0x5519 ?
0xfffffe000b15d550  48fafdb0 adrp     x8, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d554  08310891 add      x8, x8, #0x20c; 0xfffffe00070a620c STR "uipc_mbuf.c"
0xfffffe000b15d558  29c88052 mov      w9, #0x641
0xfffffe000b15d55c  e82700a9 stp      x8, x9, [sp]
0xfffffe000b15d560  40fafdb0 adrp     x0, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b15d564  007c0791 add      x0, x0, #0x1df; 0xfffffe00070a61df STR "m_free: freeing an already freed mbuf @%s:%d"
0xfffffe000b15d568  431d0b94 bl       #0xfffffe000b424a74; CALL 0xfffffe000b424a74 sz=0x3c 
