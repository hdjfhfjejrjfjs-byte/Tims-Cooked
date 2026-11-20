0xfffffe000b1b2ed4  7f2303d5 pacibsp  
0xfffffe000b1b2ed8  ffc300d1 sub      sp, sp, #0x30
0xfffffe000b1b2edc  f44f01a9 stp      x20, x19, [sp, #0x10]
0xfffffe000b1b2ee0  fd7b02a9 stp      x29, x30, [sp, #0x20]
0xfffffe000b1b2ee4  fd830091 add      x29, sp, #0x20
0xfffffe000b1b2ee8  08384079 ldrh     w8, [x0, #0x1c]
0xfffffe000b1b2eec  88230034 cbz      w8, #0xfffffe000b1b335c
0xfffffe000b1b2ef0  f40300aa mov      x20, x0
0xfffffe000b1b2ef4  130040f9 ldr      x19, [x0]
0xfffffe000b1b2ef8  083c4079 ldrh     w8, [x0, #0x1e]
0xfffffe000b1b2efc  e8000836 tbz      w8, #1, #0xfffffe000b1b2f18
0xfffffe000b1b2f00  e00314aa mov      x0, x20
0xfffffe000b1b2f04  9e240094 bl       #0xfffffe000b1bc17c; CALL 0xfffffe000b1bc17c sz=0x74 
0xfffffe000b1b2f08  e00314aa mov      x0, x20
0xfffffe000b1b2f0c  010080d2 mov      x1, #0
0xfffffe000b1b2f10  5445ff97 bl       #0xfffffe000b184460; CALL 0xfffffe000b184460 sz=0x148 '/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_m'; 'm->m_flags & M_PKTHDR'; 'lock_rw_old.c'
0xfffffe000b1b2f14  883e4079 ldrh     w8, [x20, #0x1e]
0xfffffe000b1b2f18  e8140036 tbz      w8, #0, #0xfffffe000b1b31b4
0xfffffe000b1b2f1c  892240f9 ldr      x9, [x20, #0x40]
0xfffffe000b1b2f20  2a1d4079 ldrh     w10, [x9, #0xe]
0xfffffe000b1b2f24  48090012 and      w8, w10, #7
0xfffffe000b1b2f28  1f110071 cmp      w8, #4
0xfffffe000b1b2f2c  81000054 b.ne     #0xfffffe000b1b2f3c; -> 0xfffffe000b1b2f3c FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2f30  280140f9 ldr      x8, [x9]
0xfffffe000b1b2f34  1f0114eb cmp      x8, x20
0xfffffe000b1b2f38  40070054 b.eq     #0xfffffe000b1b3020; -> 0xfffffe000b1b3020 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2f3c  28154079 ldrh     w8, [x9, #0xa]
0xfffffe000b1b2f40  e8070034 cbz      w8, #0xfffffe000b1b303c
0xfffffe000b1b2f44  881640f9 ldr      x8, [x20, #0x28]
0xfffffe000b1b2f48  2b114079 ldrh     w11, [x9, #8]
0xfffffe000b1b2f4c  4a010012 and      w10, w10, #1
0xfffffe000b1b2f50  29290091 add      x9, x9, #0xa
0xfffffe000b1b2f54  0c008012 mov      w12, #-1
0xfffffe000b1b2f58  2901ec78 ldaddalh w12, w9, [x9]
0xfffffe000b1b2f5c  29050051 sub      w9, w9, #1
0xfffffe000b1b2f60  7f21296b cmp      w11, w9, uxth
0xfffffe000b1b2f64  4009407a ccmp     w10, #0, #0, eq
0xfffffe000b1b2f68  20030054 b.eq     #0xfffffe000b1b2fcc; -> 0xfffffe000b1b2fcc FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2f6c  7f21296b cmp      w11, w9, uxth
0xfffffe000b1b2f70  4409407a ccmp     w10, #0, #4, eq
0xfffffe000b1b2f74  00120054 b.eq     #0xfffffe000b1b31b4; -> 0xfffffe000b1b31b4 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2f78  892240f9 ldr      x9, [x20, #0x40]
0xfffffe000b1b2f7c  291d4079 ldrh     w9, [x9, #0xe]
0xfffffe000b1b2f80  491d1037 tbnz     w9, #2, #0xfffffe000b1b3328
0xfffffe000b1b2f84  8a3a4079 ldrh     w10, [x20, #0x1c]
0xfffffe000b1b2f88  e92e00b0 adrp     x9, #0xfffffe000b78f000; page 0xfffffe000b78f000
0xfffffe000b1b2f8c  29010691 add      x9, x9, #0x180; 0xfffffe000b78f180 ?
0xfffffe000b1b2f90  5f7d0071 cmp      w10, #0x1f
0xfffffe000b1b2f94  c8060054 b.hi     #0xfffffe000b1b306c; -> 0xfffffe000b1b306c FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2f98  8bd038d5 mrs      x11, tpidr_el1
0xfffffe000b1b2f9c  6bd940f9 ldr      x11, [x11, #0x1b0]
0xfffffe000b1b2fa0  2b418b8b add      x11, x9, x11, asr #16; 0xfffffe000b78f265 ?
0xfffffe000b1b2fa4  6a090aab adds     x10, x11, x10, lsl #2
0xfffffe000b1b2fa8  c0000054 b.eq     #0xfffffe000b1b2fc0; -> 0xfffffe000b1b2fc0 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2fac  6c010291 add      x12, x11, #0x80; 0xfffffe000b78f2e5 ?
0xfffffe000b1b2fb0  5f010ceb cmp      x10, x12
0xfffffe000b1b2fb4  221d0054 b.hs     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2fb8  5f010beb cmp      x10, x11
0xfffffe000b1b2fbc  e31c0054 b.lo     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2fc0  0b008012 mov      w11, #-1
0xfffffe000b1b2fc4  4a012bb8 ldadd    w11, w10, [x10]
0xfffffe000b1b2fc8  3a000014 b        #0xfffffe000b1b30b0; -> 0xfffffe000b1b30b0 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2fcc  480400b4 cbz      x8, #0xfffffe000b1b3054
0xfffffe000b1b2fd0  10000090 adrp     x16, #0xfffffe000b1b2000; page 0xfffffe000b1b2000
0xfffffe000b1b2fd4  10b22391 add      x16, x16, #0x8ec; 0xfffffe000b1b28ec FUNC 0xfffffe000b1b28ec
0xfffffe000b1b2fd8  314698d2 mov      x17, #0xc231
0xfffffe000b1b2fdc  3002c1da pacia    x16, x17
0xfffffe000b1b2fe0  1f0110eb cmp      x8, x16
0xfffffe000b1b2fe4  c00a0054 b.eq     #0xfffffe000b1b313c; -> 0xfffffe000b1b313c FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b2fe8  10000090 adrp     x16, #0xfffffe000b1b2000; page 0xfffffe000b1b2000
0xfffffe000b1b2fec  10722391 add      x16, x16, #0x8dc; 0xfffffe000b1b28dc FUNC 0xfffffe000b1b28dc
0xfffffe000b1b2ff0  314698d2 mov      x17, #0xc231
0xfffffe000b1b2ff4  3002c1da pacia    x16, x17
0xfffffe000b1b2ff8  1f0110eb cmp      x8, x16
0xfffffe000b1b2ffc  a00b0054 b.eq     #0xfffffe000b1b3170; -> 0xfffffe000b1b3170 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3000  801240f9 ldr      x0, [x20, #0x20]
0xfffffe000b1b3004  813240b9 ldr      w1, [x20, #0x30]
0xfffffe000b1b3008  400000b4 cbz      x0, #0xfffffe000b1b3010
0xfffffe000b1b300c  611a0034 cbz      w1, #0xfffffe000b1b3358
0xfffffe000b1b3010  821e40f9 ldr      x2, [x20, #0x38]
0xfffffe000b1b3014  314698d2 mov      x17, #0xc231
0xfffffe000b1b3018  11093fd7 blraa    x8, x17
0xfffffe000b1b301c  5b000014 b        #0xfffffe000b1b3188; -> 0xfffffe000b1b3188 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3020  e00314aa mov      x0, x20
0xfffffe000b1b3024  72010094 bl       #0xfffffe000b1b35ec; CALL 0xfffffe000b1b35ec sz=0x1b8 '/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_m'; '(m->m_flags & M_EXT) && (MEXT_FLAGS(m) & EXTF_PAIRED)'; 'm_free_func != NULL'
0xfffffe000b1b3028  c0140035 cbnz     w0, #0xfffffe000b1b32c0
0xfffffe000b1b302c  892240f9 ldr      x9, [x20, #0x40]
0xfffffe000b1b3030  2a1d4079 ldrh     w10, [x9, #0xe]; [0xfffffe000b78f18e] ?
0xfffffe000b1b3034  28154079 ldrh     w8, [x9, #0xa]; [0xfffffe000b78f18a] ?
0xfffffe000b1b3038  68f8ff35 cbnz     w8, #0xfffffe000b1b2f44
0xfffffe000b1b303c  a0f7fd90 adrp     x0, #0xfffffe00070a7000; page 0xfffffe00070a7000
0xfffffe000b1b3040  004c0791 add      x0, x0, #0x1d3; 0xfffffe00070a71d3 STR "MEXT_REF(m) != 0"
0xfffffe000b1b3044  81f7fdf0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b1b3048  219c2c91 add      x1, x1, #0xb27; 0xfffffe00070a6b27 STR "/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b1b304c  02818052 mov      w2, #0x408
0xfffffe000b1b3050  606b0b94 bl       #0xfffffe000b48ddd0; CALL 0xfffffe000b48ddd0 sz=0x34 'uipc_socket.c'
0xfffffe000b1b3054  811240f9 ldr      x1, [x20, #0x20]
0xfffffe000b1b3058  610000b4 cbz      x1, #0xfffffe000b1b3064
0xfffffe000b1b305c  883240b9 ldr      w8, [x20, #0x30]
0xfffffe000b1b3060  c8170034 cbz      w8, #0xfffffe000b1b3358
0xfffffe000b1b3064  40048052 mov      w0, #0x22
0xfffffe000b1b3068  47000014 b        #0xfffffe000b1b3184; -> 0xfffffe000b1b3184 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b306c  5ffd0371 cmp      w10, #0xff
0xfffffe000b1b3070  08020054 b.hi     #0xfffffe000b1b30b0; -> 0xfffffe000b1b30b0 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3074  0b3200b0 adrp     x11, #0xfffffe000b7f4000; page 0xfffffe000b7f4000
0xfffffe000b1b3078  6bf11291 add      x11, x11, #0x4bc; 0xfffffe000b7f44bc ?
0xfffffe000b1b307c  6a050a8b add      x10, x11, x10, lsl #1; 0xfffffe000b7f45a0 ?
0xfffffe000b1b3080  4a7100b1 adds     x10, x10, #0x1c
0xfffffe000b1b3084  20010054 b.eq     #0xfffffe000b1b30a8; -> 0xfffffe000b1b30a8 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3088  0b3200b0 adrp     x11, #0xfffffe000b7f4000; page 0xfffffe000b7f4000
0xfffffe000b1b308c  6b611b91 add      x11, x11, #0x6d8; 0xfffffe000b7f46d8 ?
0xfffffe000b1b3090  5f010beb cmp      x10, x11
0xfffffe000b1b3094  22160054 b.hs     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3098  0b3200b0 adrp     x11, #0xfffffe000b7f4000; page 0xfffffe000b7f4000
0xfffffe000b1b309c  6b611391 add      x11, x11, #0x4d8; 0xfffffe000b7f44d8 ?
0xfffffe000b1b30a0  5f010beb cmp      x10, x11
0xfffffe000b1b30a4  a3150054 b.lo     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b30a8  0b008012 mov      w11, #-1
0xfffffe000b1b30ac  4a012b78 ldaddh   w11, w10, [x10]
0xfffffe000b1b30b0  8ad038d5 mrs      x10, tpidr_el1
0xfffffe000b1b30b4  4ad940f9 ldr      x10, [x10, #0x1b0]; [0xfffffe000b7f4750] ?
0xfffffe000b1b30b8  29418a8b add      x9, x9, x10, asr #16; 0xfffffe000b78f264 ?
0xfffffe000b1b30bc  2a010291 add      x10, x9, #0x80; 0xfffffe000b78f2e4 ?
0xfffffe000b1b30c0  5f0109eb cmp      x10, x9
0xfffffe000b1b30c4  a9140054 b.ls     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b30c8  2a008052 mov      w10, #1
0xfffffe000b1b30cc  29012ab8 ldadd    w10, w9, [x9]
0xfffffe000b1b30d0  2900e0d2 mov      x9, #0x1000000000000
0xfffffe000b1b30d4  890e00f9 str      x9, [x20, #0x18]
0xfffffe000b1b30d8  9f7e00a9 stp      xzr, xzr, [x20]
0xfffffe000b1b30dc  892240f9 ldr      x9, [x20, #0x40]
0xfffffe000b1b30e0  2a1d4079 ldrh     w10, [x9, #0xe]; [0xfffffe000b78f272] ?
0xfffffe000b1b30e4  4a791e12 and      w10, w10, #0xfffffffd
0xfffffe000b1b30e8  2a1d0079 strh     w10, [x9, #0xe]
0xfffffe000b1b30ec  480300b4 cbz      x8, #0xfffffe000b1b3154
0xfffffe000b1b30f0  f0fffff0 adrp     x16, #0xfffffe000b1b2000; page 0xfffffe000b1b2000
0xfffffe000b1b30f4  10b22391 add      x16, x16, #0x8ec; 0xfffffe000b1b28ec FUNC 0xfffffe000b1b28ec
0xfffffe000b1b30f8  314698d2 mov      x17, #0xc231
0xfffffe000b1b30fc  3002c1da pacia    x16, x17
0xfffffe000b1b3100  1f0110eb cmp      x8, x16
0xfffffe000b1b3104  800e0054 b.eq     #0xfffffe000b1b32d4; -> 0xfffffe000b1b32d4 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3108  f0fffff0 adrp     x16, #0xfffffe000b1b2000; page 0xfffffe000b1b2000
0xfffffe000b1b310c  10722391 add      x16, x16, #0x8dc; 0xfffffe000b1b28dc FUNC 0xfffffe000b1b28dc
0xfffffe000b1b3110  314698d2 mov      x17, #0xc231
0xfffffe000b1b3114  3002c1da pacia    x16, x17
0xfffffe000b1b3118  1f0110eb cmp      x8, x16
0xfffffe000b1b311c  21110054 b.ne     #0xfffffe000b1b3340; -> 0xfffffe000b1b3340 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3120  810e48b2 orr      x1, x20, #0xf00000000000000
0xfffffe000b1b3124  e80301cb neg      x8, x1
0xfffffe000b1b3128  880200f9 str      x8, [x20]
0xfffffe000b1b312c  e367fef0 adrp     x3, #0xfffffe0007eb2000; page 0xfffffe0007eb2000
0xfffffe000b1b3130  63e00a91 add      x3, x3, #0x2b8; 0xfffffe0007eb22b8 ?
0xfffffe000b1b3134  e0048052 mov      w0, #0x27
0xfffffe000b1b3138  6d000014 b        #0xfffffe000b1b32ec; -> 0xfffffe000b1b32ec FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b313c  811240f9 ldr      x1, [x20, #0x20]
0xfffffe000b1b3140  610000b4 cbz      x1, #0xfffffe000b1b314c
0xfffffe000b1b3144  883240b9 ldr      w8, [x20, #0x30]
0xfffffe000b1b3148  88100034 cbz      w8, #0xfffffe000b1b3358
0xfffffe000b1b314c  60048052 mov      w0, #0x23
0xfffffe000b1b3150  0d000014 b        #0xfffffe000b1b3184; -> 0xfffffe000b1b3184 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3154  810e48b2 orr      x1, x20, #0xf00000000000000
0xfffffe000b1b3158  e80301cb neg      x8, x1
0xfffffe000b1b315c  880200f9 str      x8, [x20]
0xfffffe000b1b3160  e367fef0 adrp     x3, #0xfffffe0007eb2000; page 0xfffffe0007eb2000
0xfffffe000b1b3164  63e00a91 add      x3, x3, #0x2b8; 0xfffffe0007eb22b8 ?
0xfffffe000b1b3168  a0048052 mov      w0, #0x25
0xfffffe000b1b316c  60000014 b        #0xfffffe000b1b32ec; -> 0xfffffe000b1b32ec FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3170  811240f9 ldr      x1, [x20, #0x20]
0xfffffe000b1b3174  610000b4 cbz      x1, #0xfffffe000b1b3180
0xfffffe000b1b3178  883240b9 ldr      w8, [x20, #0x30]
0xfffffe000b1b317c  e80e0034 cbz      w8, #0xfffffe000b1b3358
0xfffffe000b1b3180  80048052 mov      w0, #0x24
0xfffffe000b1b3184  b393eb97 bl       #0xfffffe000ac98050; CALL 0xfffffe000ac98050 sz=0x254 
0xfffffe000b1b3188  812240f9 ldr      x1, [x20, #0x40]
0xfffffe000b1b318c  28104079 ldrh     w8, [x1, #8]; [0xfffffe00070a6b2f] ?
0xfffffe000b1b3190  29144079 ldrh     w9, [x1, #0xa]; [0xfffffe00070a6b31] ?
0xfffffe000b1b3194  1f01096b cmp      w8, w9
0xfffffe000b1b3198  010b0054 b.ne     #0xfffffe000b1b32f8; -> 0xfffffe000b1b32f8 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b319c  00048052 mov      w0, #0x20
0xfffffe000b1b31a0  ac93eb97 bl       #0xfffffe000ac98050; CALL 0xfffffe000ac98050 sz=0x254 
0xfffffe000b1b31a4  883e4079 ldrh     w8, [x20, #0x1e]
0xfffffe000b1b31a8  480b0036 tbz      w8, #0, #0xfffffe000b1b3310
0xfffffe000b1b31ac  9f1600f9 str      xzr, [x20, #0x28]
0xfffffe000b1b31b0  9ffe03a9 stp      xzr, xzr, [x20, #0x38]
0xfffffe000b1b31b4  883a4079 ldrh     w8, [x20, #0x1c]
0xfffffe000b1b31b8  1f7d0071 cmp      w8, #0x1f
0xfffffe000b1b31bc  e8010054 b.hi     #0xfffffe000b1b31f8; -> 0xfffffe000b1b31f8 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b31c0  89d038d5 mrs      x9, tpidr_el1
0xfffffe000b1b31c4  29d940f9 ldr      x9, [x9, #0x1b0]; [0xfffffe000b78f414] ?
0xfffffe000b1b31c8  ea2e0090 adrp     x10, #0xfffffe000b78f000; page 0xfffffe000b78f000
0xfffffe000b1b31cc  4a010691 add      x10, x10, #0x180; 0xfffffe000b78f180 ?
0xfffffe000b1b31d0  4941898b add      x9, x10, x9, asr #16; 0xfffffe000b78f263 ?
0xfffffe000b1b31d4  280908ab adds     x8, x9, x8, lsl #2
0xfffffe000b1b31d8  a0000054 b.eq     #0xfffffe000b1b31ec; -> 0xfffffe000b1b31ec FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b31dc  2a010291 add      x10, x9, #0x80; 0xfffffe000b78f2e3 ?
0xfffffe000b1b31e0  1f010aeb cmp      x8, x10
0xfffffe000b1b31e4  003149fa ccmp     x8, x9, #0, lo
0xfffffe000b1b31e8  830b0054 b.lo     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b31ec  09008012 mov      w9, #-1
0xfffffe000b1b31f0  080129b8 ldadd    w9, w8, [x8]
0xfffffe000b1b31f4  11000014 b        #0xfffffe000b1b3238; -> 0xfffffe000b1b3238 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b31f8  1ffd0371 cmp      w8, #0xff
0xfffffe000b1b31fc  e8010054 b.hi     #0xfffffe000b1b3238; -> 0xfffffe000b1b3238 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3200  093200b0 adrp     x9, #0xfffffe000b7f4000; page 0xfffffe000b7f4000
0xfffffe000b1b3204  29f11291 add      x9, x9, #0x4bc; 0xfffffe000b7f44bc ?
0xfffffe000b1b3208  2805088b add      x8, x9, x8, lsl #1; 0xfffffe000b7f459e ?
0xfffffe000b1b320c  087100b1 adds     x8, x8, #0x1c
0xfffffe000b1b3210  00010054 b.eq     #0xfffffe000b1b3230; -> 0xfffffe000b1b3230 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3214  093200b0 adrp     x9, #0xfffffe000b7f4000; page 0xfffffe000b7f4000
0xfffffe000b1b3218  29611b91 add      x9, x9, #0x6d8; 0xfffffe000b7f46d8 ?
0xfffffe000b1b321c  1f0109eb cmp      x8, x9
0xfffffe000b1b3220  093200b0 adrp     x9, #0xfffffe000b7f4000; page 0xfffffe000b7f4000
0xfffffe000b1b3224  29611391 add      x9, x9, #0x4d8; 0xfffffe000b7f44d8 ?
0xfffffe000b1b3228  003149fa ccmp     x8, x9, #0, lo
0xfffffe000b1b322c  63090054 b.lo     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3230  09008012 mov      w9, #-1
0xfffffe000b1b3234  08012978 ldaddh   w9, w8, [x8]
0xfffffe000b1b3238  88d038d5 mrs      x8, tpidr_el1
0xfffffe000b1b323c  08d940f9 ldr      x8, [x8, #0x1b0]; [0xfffffe000b7f474e] ?
0xfffffe000b1b3240  e92e0090 adrp     x9, #0xfffffe000b78f000; page 0xfffffe000b78f000
0xfffffe000b1b3244  29010691 add      x9, x9, #0x180; 0xfffffe000b78f180 ?
0xfffffe000b1b3248  2841888b add      x8, x9, x8, asr #16; 0xfffffe000b78f262 ?
0xfffffe000b1b324c  09010291 add      x9, x8, #0x80; 0xfffffe000b78f2e2 ?
0xfffffe000b1b3250  3f0108eb cmp      x9, x8
0xfffffe000b1b3254  29080054 b.ls     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3258  29008052 mov      w9, #1
0xfffffe000b1b325c  080129b8 ldadd    w9, w8, [x8]
0xfffffe000b1b3260  4800e0d2 mov      x8, #0x2000000000000
0xfffffe000b1b3264  00e4006f movi     v0.2d, #0000000000000000
0xfffffe000b1b3268  8002803d str      q0, [x20]
0xfffffe000b1b326c  9f2201a9 stp      xzr, x8, [x20, #0x10]
0xfffffe000b1b3270  800201ad stp      q0, q0, [x20, #0x20]
0xfffffe000b1b3274  9f2200f9 str      xzr, [x20, #0x40]
0xfffffe000b1b3278  e80314aa mov      x8, x20
0xfffffe000b1b327c  000d853c str      q0, [x8, #0x50]!
0xfffffe000b1b3280  89820291 add      x9, x20, #0xa0
0xfffffe000b1b3284  8a220391 add      x10, x20, #0xc8
0xfffffe000b1b3288  9f4e00f9 str      xzr, [x20, #0x98]
0xfffffe000b1b328c  3f010aeb cmp      x9, x10
0xfffffe000b1b3290  48060054 b.hi     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b3294  3f1100f9 str      xzr, [x9, #0x20]
0xfffffe000b1b3298  200100ad stp      q0, q0, [x9]
0xfffffe000b1b329c  9f7600b9 str      wzr, [x20, #0x74]
0xfffffe000b1b32a0  89820391 add      x9, x20, #0xe0
0xfffffe000b1b32a4  1f0109eb cmp      x8, x9
0xfffffe000b1b32a8  82050054 b.hs     #0xfffffe000b1b3358; -> 0xfffffe000b1b3358 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b32ac  9f7e0da9 stp      xzr, xzr, [x20, #0xd0]
0xfffffe000b1b32b0  9f3e0079 strh     wzr, [x20, #0x1e]
0xfffffe000b1b32b4  20048052 mov      w0, #0x21
0xfffffe000b1b32b8  e10314aa mov      x1, x20
0xfffffe000b1b32bc  6593eb97 bl       #0xfffffe000ac98050; CALL 0xfffffe000ac98050 sz=0x254 
0xfffffe000b1b32c0  e00313aa mov      x0, x19
0xfffffe000b1b32c4  fd7b42a9 ldp      x29, x30, [sp, #0x20]
0xfffffe000b1b32c8  f44f41a9 ldp      x20, x19, [sp, #0x10]
0xfffffe000b1b32cc  ffc30091 add      sp, sp, #0x30
0xfffffe000b1b32d0  ff0f5fd6 retab    
0xfffffe000b1b32d4  810e48b2 orr      x1, x20, #0xf00000000000000
0xfffffe000b1b32d8  e80301cb neg      x8, x1
0xfffffe000b1b32dc  880200f9 str      x8, [x20]
0xfffffe000b1b32e0  e367fef0 adrp     x3, #0xfffffe0007eb2000; page 0xfffffe0007eb2000
0xfffffe000b1b32e4  63e00a91 add      x3, x3, #0x2b8; 0xfffffe0007eb22b8 ?
0xfffffe000b1b32e8  c0048052 mov      w0, #0x26
0xfffffe000b1b32ec  22008052 mov      w2, #1
0xfffffe000b1b32f0  ae92eb97 bl       #0xfffffe000ac97da8; CALL 0xfffffe000ac97da8 sz=0x1f8 
0xfffffe000b1b32f4  f3ffff17 b        #0xfffffe000b1b32c0; -> 0xfffffe000b1b32c0 FUNC 0xfffffe000b1b2ed4
0xfffffe000b1b32f8  a0f7fd90 adrp     x0, #0xfffffe00070a7000; page 0xfffffe00070a7000
0xfffffe000b1b32fc  00900791 add      x0, x0, #0x1e4; 0xfffffe00070a71e4 STR "rfa->minref == rfa->refcnt"
0xfffffe000b1b3300  81f7fdf0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b1b3304  219c2c91 add      x1, x1, #0xb27; 0xfffffe00070a6b27 STR "/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b1b3308  62648052 mov      w2, #0x323
0xfffffe000b1b330c  b16a0b94 bl       #0xfffffe000b48ddd0; CALL 0xfffffe000b48ddd0 sz=0x34 'uipc_socket.c'
0xfffffe000b1b3310  a0f7fd90 adrp     x0, #0xfffffe00070a7000; page 0xfffffe00070a7000
0xfffffe000b1b3314  00fc0791 add      x0, x0, #0x1ff; 0xfffffe00070a71ff STR "m->m_flags & M_EXT"
0xfffffe000b1b3318  81f7fdf0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b1b331c  219c2c91 add      x1, x1, #0xb27; 0xfffffe00070a6b27 STR "/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b1b3320  423a8052 mov      w2, #0x1d2
0xfffffe000b1b3324  ab6a0b94 bl       #0xfffffe000b48ddd0; CALL 0xfffffe000b48ddd0 sz=0x34 'uipc_socket.c'
0xfffffe000b1b3328  80f7fdf0 adrp     x0, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b1b332c  00d83091 add      x0, x0, #0xc36; 0xfffffe00070a6c36 STR "!(MEXT_FLAGS(m) & EXTF_PAIRED)"
0xfffffe000b1b3330  81f7fdf0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b1b3334  219c2c91 add      x1, x1, #0xb27; 0xfffffe00070a6b27 STR "/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b1b3338  02cd8052 mov      w2, #0x668
0xfffffe000b1b333c  a56a0b94 bl       #0xfffffe000b48ddd0; CALL 0xfffffe000b48ddd0 sz=0x34 'uipc_socket.c'
0xfffffe000b1b3340  80f7fdf0 adrp     x0, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b1b3344  00543191 add      x0, x0, #0xc55; 0xfffffe00070a6c55 STR "m_free_func == m_16kfree"
0xfffffe000b1b3348  81f7fdf0 adrp     x1, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b1b334c  219c2c91 add      x1, x1, #0xb27; 0xfffffe00070a6b27 STR "/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_mbuf.c"
0xfffffe000b1b3350  c2cf8052 mov      w2, #0x67e
0xfffffe000b1b3354  9f6a0b94 bl       #0xfffffe000b48ddd0; CALL 0xfffffe000b48ddd0 sz=0x34 'uipc_socket.c'
0xfffffe000b1b3358  20a32ad4 brk      #0x5519; -> 0x5519 ?
0xfffffe000b1b335c  88f7fdf0 adrp     x8, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b1b3360  08a93091 add      x8, x8, #0xc2a; 0xfffffe00070a6c2a STR "uipc_mbuf.c"
0xfffffe000b1b3364  29c88052 mov      w9, #0x641
0xfffffe000b1b3368  e82700a9 stp      x8, x9, [sp]
0xfffffe000b1b336c  80f7fdf0 adrp     x0, #0xfffffe00070a6000; page 0xfffffe00070a6000
0xfffffe000b1b3370  00f42f91 add      x0, x0, #0xbfd; 0xfffffe00070a6bfd STR "m_free: freeing an already freed mbuf @%s:%d"
0xfffffe000b1b3374  2b220b94 bl       #0xfffffe000b47bc20; CALL 0xfffffe000b47bc20 sz=0x3c 
