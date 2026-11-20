0xfffffe000b184854  7f2303d5 pacibsp  
0xfffffe000b184858  ffc301d1 sub      sp, sp, #0x70
0xfffffe000b18485c  fc6f01a9 stp      x28, x27, [sp, #0x10]
0xfffffe000b184860  fa6702a9 stp      x26, x25, [sp, #0x20]
0xfffffe000b184864  f85f03a9 stp      x24, x23, [sp, #0x30]
0xfffffe000b184868  f65704a9 stp      x22, x21, [sp, #0x40]
0xfffffe000b18486c  f44f05a9 stp      x20, x19, [sp, #0x50]
0xfffffe000b184870  fd7b06a9 stp      x29, x30, [sp, #0x60]
0xfffffe000b184874  fd830191 add      x29, sp, #0x60
0xfffffe000b184878  95360090 adrp     x21, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b18487c  b5822191 add      x21, x21, #0x860; 0xfffffe000b854860 ?
0xfffffe000b184880  93d038d5 mrs      x19, tpidr_el1
0xfffffe000b184884  98360090 adrp     x24, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184888  97360090 adrp     x23, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b18488c  19008252 mov      w25, #0x1000
0xfffffe000b184890  da300090 adrp     x26, #0xfffffe000b79c000; page 0xfffffe000b79c000
0xfffffe000b184894  fbff9f52 mov      w27, #0xffff
0xfffffe000b184898  14008452 mov      w20, #0x2000
0xfffffe000b18489c  16008652 mov      w22, #0x3000
0xfffffe000b1848a0  080080d2 mov      x8, #0
0xfffffe000b1848a4  69fa44b9 ldr      w9, [x19, #0x4f8]
0xfffffe000b1848a8  a97ee8c8 casa     x8, x9, [x21]
0xfffffe000b1848ac  1f0100f1 cmp      x8, #0
0xfffffe000b1848b0  e1190054 b.ne     #0xfffffe000b184bec; -> 0xfffffe000b184bec FUNC 0xfffffe000b184854
0xfffffe000b1848b4  1fc308b9 str      wzr, [x24, #0x8c0]
0xfffffe000b1848b8  e85244f9 ldr      x8, [x23, #0x8a0]; [0xfffffe000b8548a0] ?
0xfffffe000b1848bc  a80000b4 cbz      x8, #0xfffffe000b1848d0
0xfffffe000b1848c0  09410091 add      x9, x8, #0x10
0xfffffe000b1848c4  291136b8 ldclr    w22, w9, [x9]
0xfffffe000b1848c8  080140f9 ldr      x8, [x8]
0xfffffe000b1848cc  a8ffffb5 cbnz     x8, #0xfffffe000b1848c0
0xfffffe000b1848d0  08008052 mov      w8, #0
0xfffffe000b1848d4  03000014 b        #0xfffffe000b1848e0; -> 0xfffffe000b1848e0 FUNC 0xfffffe000b184854
0xfffffe000b1848d8  08c348b9 ldr      w8, [x24, #0x8c0]; [0xfffffe000b8548c0] ?
0xfffffe000b1848dc  48190034 cbz      w8, #0xfffffe000b184c04
0xfffffe000b1848e0  fc5244f9 ldr      x28, [x23, #0x8a0]; [0xfffffe000b8548a0] ?
0xfffffe000b1848e4  dcffffb4 cbz      x28, #0xfffffe000b1848dc
0xfffffe000b1848e8  080080d2 mov      x8, #0
0xfffffe000b1848ec  69fa44b9 ldr      w9, [x19, #0x4f8]
0xfffffe000b1848f0  8a430191 add      x10, x28, #0x50
0xfffffe000b1848f4  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1848f8  1f0100f1 cmp      x8, #0
0xfffffe000b1848fc  c1130054 b.ne     #0xfffffe000b184b74; -> 0xfffffe000b184b74 FUNC 0xfffffe000b184854
0xfffffe000b184900  881740b9 ldr      w8, [x28, #0x14]
0xfffffe000b184904  a8040034 cbz      w8, #0xfffffe000b184998
0xfffffe000b184908  881340b9 ldr      w8, [x28, #0x10]
0xfffffe000b18490c  28016837 tbnz     w8, #0xd, #0xfffffe000b184930
0xfffffe000b184910  48046037 tbnz     w8, #0xc, #0xfffffe000b184998
0xfffffe000b184914  881740b9 ldr      w8, [x28, #0x14]
0xfffffe000b184918  891b40b9 ldr      w9, [x28, #0x18]
0xfffffe000b18491c  1f01096b cmp      w8, w9
0xfffffe000b184920  c0030054 b.eq     #0xfffffe000b184998; -> 0xfffffe000b184998 FUNC 0xfffffe000b184854
0xfffffe000b184924  88430091 add      x8, x28, #0x10
0xfffffe000b184928  083139b8 ldset    w25, w8, [x8]
0xfffffe000b18492c  06000014 b        #0xfffffe000b184944; -> 0xfffffe000b184944 FUNC 0xfffffe000b184854
0xfffffe000b184930  88430091 add      x8, x28, #0x10
0xfffffe000b184934  081134b8 ldclr    w20, w8, [x8]
0xfffffe000b184938  08c348b9 ldr      w8, [x24, #0x8c0]; [0xfffffe000b8548c0] ?
0xfffffe000b18493c  08050051 sub      w8, w8, #1
0xfffffe000b184940  08c308b9 str      w8, [x24, #0x8c0]
0xfffffe000b184944  f1031caa mov      x17, x28
0xfffffe000b184948  308e42f8 ldr      x16, [x17, #0x28]!
0xfffffe000b18494c  91a7f0f2 movk     x17, #0x853c, lsl #48
0xfffffe000b184950  301ac1da autda    x16, x17
0xfffffe000b184954  080240b9 ldr      w8, [x16]
0xfffffe000b184958  1f090071 cmp      w8, #2
0xfffffe000b18495c  e1010054 b.ne     #0xfffffe000b184998; -> 0xfffffe000b184998 FUNC 0xfffffe000b184854
0xfffffe000b184960  f1031caa mov      x17, x28
0xfffffe000b184964  308e43f8 ldr      x16, [x17, #0x38]!
0xfffffe000b184968  900100b4 cbz      x16, #0xfffffe000b184998
0xfffffe000b18496c  d136e2f2 movk     x17, #0x11b6, lsl #48
0xfffffe000b184970  301ac1da autda    x16, x17
0xfffffe000b184974  300100b4 cbz      x16, #0xfffffe000b184998
0xfffffe000b184978  f50310aa mov      x21, x16
0xfffffe000b18497c  081240f9 ldr      x8, [x16, #0x20]
0xfffffe000b184980  090940f9 ldr      x9, [x8, #0x10]
0xfffffe000b184984  4a4f43f9 ldr      x10, [x26, #0x698]; [0xfffffe000b79c698] ?
0xfffffe000b184988  3f010aeb cmp      x9, x10
0xfffffe000b18498c  61000054 b.ne     #0xfffffe000b184998; -> 0xfffffe000b184998 FUNC 0xfffffe000b184854
0xfffffe000b184990  08914039 ldrb     w8, [x8, #0x24]
0xfffffe000b184994  48012037 tbnz     w8, #4, #0xfffffe000b1849bc
0xfffffe000b184998  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b18499c  89430191 add      x9, x28, #0x50
0xfffffe000b1849a0  e20308aa mov      x2, x8
0xfffffe000b1849a4  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1849a8  5f00086b cmp      w2, w8
0xfffffe000b1849ac  210f0054 b.ne     #0xfffffe000b184b90; -> 0xfffffe000b184b90 FUNC 0xfffffe000b184854
0xfffffe000b1849b0  9c0340f9 ldr      x28, [x28]
0xfffffe000b1849b4  bcf9ffb5 cbnz     x28, #0xfffffe000b1848e8
0xfffffe000b1849b8  c8ffff17 b        #0xfffffe000b1848d8; -> 0xfffffe000b1848d8 FUNC 0xfffffe000b184854
0xfffffe000b1849bc  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b1849c0  89430191 add      x9, x28, #0x50
0xfffffe000b1849c4  e20308aa mov      x2, x8
0xfffffe000b1849c8  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1849cc  5f00086b cmp      w2, w8
0xfffffe000b1849d0  810e0054 b.ne     #0xfffffe000b184ba0; -> 0xfffffe000b184ba0 FUNC 0xfffffe000b184854
0xfffffe000b1849d4  a8020f91 add      x8, x21, #0x3c0; 0xfffffe000b854c20 ?
0xfffffe000b1849d8  1f0115eb cmp      x8, x21
0xfffffe000b1849dc  89280054 b.ls     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b1849e0  a91240f9 ldr      x9, [x21, #0x20]; [0xfffffe000b854880] ?
0xfffffe000b1849e4  283940f9 ldr      x8, [x9, #0x70]
0xfffffe000b1849e8  c80000b4 cbz      x8, #0xfffffe000b184a00
0xfffffe000b1849ec  e00315aa mov      x0, x21
0xfffffe000b1849f0  01008052 mov      w1, #0
0xfffffe000b1849f4  b1679ed2 mov      x17, #0xf33d
0xfffffe000b1849f8  11093fd7 blraa    x8, x17
0xfffffe000b1849fc  03000014 b        #0xfffffe000b184a08; -> 0xfffffe000b184a08 FUNC 0xfffffe000b184854
0xfffffe000b184a00  280940f9 ldr      x8, [x9, #0x10]
0xfffffe000b184a04  000940f9 ldr      x0, [x8, #0x10]; [0xfffffe000b854c30] ?
0xfffffe000b184a08  08008052 mov      w8, #0
0xfffffe000b184a0c  69fa44b9 ldr      w9, [x19, #0x4f8]
0xfffffe000b184a10  0a200091 add      x10, x0, #8
0xfffffe000b184a14  497de888 casa     w8, w9, [x10]
0xfffffe000b184a18  1f010071 cmp      w8, #0
0xfffffe000b184a1c  010d0054 b.ne     #0xfffffe000b184bbc; -> 0xfffffe000b184bbc FUNC 0xfffffe000b184854
0xfffffe000b184a20  a83e42b9 ldr      w8, [x21, #0x23c]; [0xfffffe000b854a9c] ?
0xfffffe000b184a24  08050011 add      w8, w8, #1
0xfffffe000b184a28  a83e02b9 str      w8, [x21, #0x23c]
0xfffffe000b184a2c  a0c20191 add      x0, x21, #0x70; 0xfffffe000b8548d0 ?
0xfffffe000b184a30  c1008052 mov      w1, #6
0xfffffe000b184a34  3bccff97 bl       #0xfffffe000b177b20; CALL 0xfffffe000b177b20 sz=0x27c 'y/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/kpi_socketfil'; 'crementAtomic64(&net_api_stats.nas_sfltr_register_os_count) > 0'; 's.nas_sfltr_register_os_count) > 0'
0xfffffe000b184a38  c00b0035 cbnz     w0, #0xfffffe000b184bb0
0xfffffe000b184a3c  a8c24339 ldrb     w8, [x21, #0xf0]; [0xfffffe000b854950] ?
0xfffffe000b184a40  a8240036 tbz      w8, #0, #0xfffffe000b184ed4
0xfffffe000b184a44  e00315aa mov      x0, x21
0xfffffe000b184a48  01008052 mov      w1, #0
0xfffffe000b184a4c  fc89ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b184a50  a84640f9 ldr      x8, [x21, #0x88]; [0xfffffe000b8548e8] ?
0xfffffe000b184a54  e14770b2 mov      x1, #0x3ffff0000
0xfffffe000b184a58  81fe9ff2 movk     x1, #0xfff4
0xfffffe000b184a5c  880700b4 cbz      x8, #0xfffffe000b184b4c
0xfffffe000b184a60  09c348b9 ldr      w9, [x24, #0x8c0]; [0xfffffe000b8548c0] ?
0xfffffe000b184a64  03000014 b        #0xfffffe000b184a70; -> 0xfffffe000b184a70 FUNC 0xfffffe000b184854
0xfffffe000b184a68  080540f9 ldr      x8, [x8, #8]; [0xfffffe000b854c28] ?
0xfffffe000b184a6c  080700b4 cbz      x8, #0xfffffe000b184b4c
0xfffffe000b184a70  ed0308aa mov      x13, x8
0xfffffe000b184a74  03000014 b        #0xfffffe000b184a80; -> 0xfffffe000b184a80 FUNC 0xfffffe000b184854
0xfffffe000b184a78  ad0140f9 ldr      x13, [x13]
0xfffffe000b184a7c  6dffffb4 cbz      x13, #0xfffffe000b184a68
0xfffffe000b184a80  aa394079 ldrh     w10, [x13, #0x1c]
0xfffffe000b184a84  5f390071 cmp      w10, #0xe
0xfffffe000b184a88  81ffff54 b.ne     #0xfffffe000b184a78; -> 0xfffffe000b184a78 FUNC 0xfffffe000b184854
0xfffffe000b184a8c  aa1940b9 ldr      w10, [x13, #0x18]
0xfffffe000b184a90  5f310071 cmp      w10, #0xc
0xfffffe000b184a94  23ffff54 b.lo     #0xfffffe000b184a78; -> 0xfffffe000b184a78 FUNC 0xfffffe000b184854
0xfffffe000b184a98  aa3d4079 ldrh     w10, [x13, #0x1e]
0xfffffe000b184a9c  8a000037 tbnz     w10, #0, #0xfffffe000b184aac
0xfffffe000b184aa0  aa810391 add      x10, x13, #0xe0
0xfffffe000b184aa4  ab010891 add      x11, x13, #0x200
0xfffffe000b184aa8  04000014 b        #0xfffffe000b184ab8; -> 0xfffffe000b184ab8 FUNC 0xfffffe000b184854
0xfffffe000b184aac  ab3140b9 ldr      w11, [x13, #0x30]
0xfffffe000b184ab0  aa1140f9 ldr      x10, [x13, #0x20]
0xfffffe000b184ab4  4b010b8b add      x11, x10, x11
0xfffffe000b184ab8  ae0940f9 ldr      x14, [x13, #0x10]
0xfffffe000b184abc  5f010eeb cmp      x10, x14
0xfffffe000b184ac0  68210054 b.hi     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184ac4  cc310091 add      x12, x14, #0xc
0xfffffe000b184ac8  9f010beb cmp      x12, x11
0xfffffe000b184acc  08210054 b.hi     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184ad0  cf0540b9 ldr      w15, [x14, #4]
0xfffffe000b184ad4  ff011b6b cmp      w15, w27
0xfffffe000b184ad8  01fdff54 b.ne     #0xfffffe000b184a78; -> 0xfffffe000b184a78 FUNC 0xfffffe000b184854
0xfffffe000b184adc  cf0940b9 ldr      w15, [x14, #8]
0xfffffe000b184ae0  ff050071 cmp      w15, #1
0xfffffe000b184ae4  a1fcff54 b.ne     #0xfffffe000b184a78; -> 0xfffffe000b184a78 FUNC 0xfffffe000b184854
0xfffffe000b184ae8  cd0140b9 ldr      w13, [x14]
0xfffffe000b184aec  ad01018b add      x13, x13, x1
0xfffffe000b184af0  adfd42d3 lsr      x13, x13, #2
0xfffffe000b184af4  bf050071 cmp      w13, #1
0xfffffe000b184af8  8bfbff54 b.lt     #0xfffffe000b184a68; -> 0xfffffe000b184a68 FUNC 0xfffffe000b184854
0xfffffe000b184afc  0e008052 mov      w14, #0
0xfffffe000b184b00  9f010beb cmp      x12, x11
0xfffffe000b184b04  421f0054 b.hs     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184b08  9f010aeb cmp      x12, x10
0xfffffe000b184b0c  031f0054 b.lo     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184b10  8f8540f8 ldr      x15, [x12], #8
0xfffffe000b184b14  f00d41b8 ldr      w16, [x15, #0x10]!
0xfffffe000b184b18  30016037 tbnz     w16, #0xc, #0xfffffe000b184b3c
0xfffffe000b184b1c  11061432 orr      w17, w16, #0x3000
0xfffffe000b184b20  e00310aa mov      x0, x16
0xfffffe000b184b24  f17da088 cas      w0, w17, [x15]
0xfffffe000b184b28  1f00106b cmp      w0, w16
0xfffffe000b184b2c  f00300aa mov      x16, x0
0xfffffe000b184b30  41ffff54 b.ne     #0xfffffe000b184b18; -> 0xfffffe000b184b18 FUNC 0xfffffe000b184854
0xfffffe000b184b34  29050011 add      w9, w9, #1
0xfffffe000b184b38  09c308b9 str      w9, [x24, #0x8c0]
0xfffffe000b184b3c  ce050011 add      w14, w14, #1
0xfffffe000b184b40  df010d6b cmp      w14, w13
0xfffffe000b184b44  e1fdff54 b.ne     #0xfffffe000b184b00; -> 0xfffffe000b184b00 FUNC 0xfffffe000b184854
0xfffffe000b184b48  c8ffff17 b        #0xfffffe000b184a68; -> 0xfffffe000b184a68 FUNC 0xfffffe000b184854
0xfffffe000b184b4c  e00315aa mov      x0, x21
0xfffffe000b184b50  01008052 mov      w1, #0
0xfffffe000b184b54  7d96ff97 bl       #0xfffffe000b16a548; CALL 0xfffffe000b16a548 sz=0xdc 
0xfffffe000b184b58  a0c20191 add      x0, x21, #0x70; 0xfffffe000b8548d0 ?
0xfffffe000b184b5c  21008052 mov      w1, #1
0xfffffe000b184b60  8ccdff97 bl       #0xfffffe000b178190; CALL 0xfffffe000b178190 sz=0x324 '/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_s'; '(sb->sb_flags & SB_LOCK) || (so->so_state & SS_DEFUNCT) || (so->so_flags1 & SOF1_DEFUNCTINPROG)'; '%s: null so, sb=%p sb_flags=0x%x lr=%p @%s:%d'
0xfffffe000b184b64  e00315aa mov      x0, x21
0xfffffe000b184b68  21008052 mov      w1, #1
0xfffffe000b184b6c  b489ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b184b70  90ffff17 b        #0xfffffe000b1849b0; -> 0xfffffe000b1849b0 FUNC 0xfffffe000b184854
0xfffffe000b184b74  80230191 add      x0, x28, #0x48
0xfffffe000b184b78  e10313aa mov      x1, x19
0xfffffe000b184b7c  02008052 mov      w2, #0
0xfffffe000b184b80  0f3ae997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b184b84  881740b9 ldr      w8, [x28, #0x14]
0xfffffe000b184b88  08ecff35 cbnz     w8, #0xfffffe000b184908
0xfffffe000b184b8c  83ffff17 b        #0xfffffe000b184998; -> 0xfffffe000b184998 FUNC 0xfffffe000b184854
0xfffffe000b184b90  80230191 add      x0, x28, #0x48
0xfffffe000b184b94  e10313aa mov      x1, x19
0xfffffe000b184b98  023de997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b184b9c  85ffff17 b        #0xfffffe000b1849b0; -> 0xfffffe000b1849b0 FUNC 0xfffffe000b184854
0xfffffe000b184ba0  80230191 add      x0, x28, #0x48
0xfffffe000b184ba4  e10313aa mov      x1, x19
0xfffffe000b184ba8  fe3ce997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b184bac  8affff17 b        #0xfffffe000b1849d4; -> 0xfffffe000b1849d4 FUNC 0xfffffe000b184854
0xfffffe000b184bb0  e00315aa mov      x0, x21
0xfffffe000b184bb4  21008052 mov      w1, #1
0xfffffe000b184bb8  a189ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b184bbc  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b184bc0  e20308aa mov      x2, x8
0xfffffe000b184bc4  95360090 adrp     x21, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184bc8  b5822191 add      x21, x21, #0x860; 0xfffffe000b854860 ?
0xfffffe000b184bcc  bffea288 casl     w2, wzr, [x21]
0xfffffe000b184bd0  5f00086b cmp      w2, w8
0xfffffe000b184bd4  60e6ff54 b.eq     #0xfffffe000b1848a0; -> 0xfffffe000b1848a0 FUNC 0xfffffe000b184854
0xfffffe000b184bd8  80360090 adrp     x0, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184bdc  00602191 add      x0, x0, #0x858; 0xfffffe000b854858 ?
0xfffffe000b184be0  e10313aa mov      x1, x19
0xfffffe000b184be4  ef3ce997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b184be8  2effff17 b        #0xfffffe000b1848a0; -> 0xfffffe000b1848a0 FUNC 0xfffffe000b184854
0xfffffe000b184bec  80360090 adrp     x0, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184bf0  00602191 add      x0, x0, #0x858; 0xfffffe000b854858 ?
0xfffffe000b184bf4  e10313aa mov      x1, x19
0xfffffe000b184bf8  02008052 mov      w2, #0
0xfffffe000b184bfc  f039e997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b184c00  2dffff17 b        #0xfffffe000b1848b4; -> 0xfffffe000b1848b4 FUNC 0xfffffe000b184854
0xfffffe000b184c04  c8300090 adrp     x8, #0xfffffe000b79c000; page 0xfffffe000b79c000
0xfffffe000b184c08  08a186b9 ldrsw    x8, [x8, #0x6a0]; [0xfffffe000b79c6a0] ?
0xfffffe000b184c0c  280a0034 cbz      w8, #0xfffffe000b184d50
0xfffffe000b184c10  09f17dd3 lsl      x9, x8, #3
0xfffffe000b184c14  1f050031 cmn      w8, #1
0xfffffe000b184c18  0800f0d2 mov      x8, #-0x8000000000000000
0xfffffe000b184c1c  34c1889a csel     x20, x9, x8, gt
0xfffffe000b184c20  886cfe90 adrp     x8, #0xfffffe0007f14000; page 0xfffffe0007f14000
0xfffffe000b184c24  08e11b91 add      x8, x8, #0x6f8; 0xfffffe0007f146f8 ?
0xfffffe000b184c28  000140b2 orr      x0, x8, #1
0xfffffe000b184c2c  e10314aa mov      x1, x20
0xfffffe000b184c30  02008052 mov      w2, #0
0xfffffe000b184c34  030080d2 mov      x3, #0
0xfffffe000b184c38  a024e997 bl       #0xfffffe000abcdeb8; CALL 0xfffffe000abcdeb8 sz=0x160 
0xfffffe000b184c3c  1500148b add      x21, x0, x20; 0xfffffe000b854946 ?
0xfffffe000b184c40  100015ca eor      x16, x0, x21
0xfffffe000b184c44  1f264af2 tst      x16, #-0x40000000000000
0xfffffe000b184c48  40000054 b.eq     #0xfffffe000b184c50; -> 0xfffffe000b184c50 FUNC 0xfffffe000b184854
0xfffffe000b184c4c  5514f9f2 movk     x21, #0xc8a2, lsl #48
0xfffffe000b184c50  98360090 adrp     x24, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184c54  005b04f9 str      x0, [x24, #0x8b0]
0xfffffe000b184c58  96360090 adrp     x22, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184c5c  d55e04f9 str      x21, [x22, #0x8b8]
0xfffffe000b184c60  89360090 adrp     x9, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184c64  29812191 add      x9, x9, #0x860; 0xfffffe000b854860 ?
0xfffffe000b184c68  e00700b4 cbz      x0, #0xfffffe000b184d64
0xfffffe000b184c6c  f95244f9 ldr      x25, [x23, #0x8a0]; [0xfffffe000b8548a0] ?
0xfffffe000b184c70  590900b4 cbz      x25, #0xfffffe000b184d98
0xfffffe000b184c74  17008052 mov      w23, #0
0xfffffe000b184c78  3a008052 mov      w26, #1
0xfffffe000b184c7c  fb130432 mov      w27, #-0xfffffff
0xfffffe000b184c80  fc0300aa mov      x28, x0
0xfffffe000b184c84  080080d2 mov      x8, #0
0xfffffe000b184c88  69fa44b9 ldr      w9, [x19, #0x4f8]
0xfffffe000b184c8c  2a430191 add      x10, x25, #0x50
0xfffffe000b184c90  497de8c8 casa     x8, x9, [x10]
0xfffffe000b184c94  1f0100f1 cmp      x8, #0
0xfffffe000b184c98  a1030054 b.ne     #0xfffffe000b184d0c; -> 0xfffffe000b184d0c FUNC 0xfffffe000b184854
0xfffffe000b184c9c  281740b9 ldr      w8, [x25, #0x14]
0xfffffe000b184ca0  48020034 cbz      w8, #0xfffffe000b184ce8
0xfffffe000b184ca4  28474039 ldrb     w8, [x25, #0x11]
0xfffffe000b184ca8  08022037 tbnz     w8, #4, #0xfffffe000b184ce8
0xfffffe000b184cac  281740b9 ldr      w8, [x25, #0x14]
0xfffffe000b184cb0  291b40b9 ldr      w9, [x25, #0x18]
0xfffffe000b184cb4  1f01096b cmp      w8, w9
0xfffffe000b184cb8  81010054 b.ne     #0xfffffe000b184ce8; -> 0xfffffe000b184ce8 FUNC 0xfffffe000b184854
0xfffffe000b184cbc  28530091 add      x8, x25, #0x14
0xfffffe000b184cc0  09013ab8 ldadd    w26, w9, [x8]
0xfffffe000b184cc4  29011b0b add      w9, w9, w27
0xfffffe000b184cc8  3f011b6b cmp      w9, w27
0xfffffe000b184ccc  29110054 b.ls     #0xfffffe000b184ef0; -> 0xfffffe000b184ef0 FUNC 0xfffffe000b184854
0xfffffe000b184cd0  9f0315eb cmp      x28, x21
0xfffffe000b184cd4  c2100054 b.hs     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184cd8  9f0300eb cmp      x28, x0
0xfffffe000b184cdc  83100054 b.lo     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184ce0  998700f8 str      x25, [x28], #8
0xfffffe000b184ce4  f7060011 add      w23, w23, #1
0xfffffe000b184ce8  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b184cec  29430191 add      x9, x25, #0x50
0xfffffe000b184cf0  e20308aa mov      x2, x8
0xfffffe000b184cf4  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b184cf8  5f00086b cmp      w2, w8
0xfffffe000b184cfc  a1010054 b.ne     #0xfffffe000b184d30; -> 0xfffffe000b184d30 FUNC 0xfffffe000b184854
0xfffffe000b184d00  390340f9 ldr      x25, [x25]
0xfffffe000b184d04  19fcffb5 cbnz     x25, #0xfffffe000b184c84
0xfffffe000b184d08  25000014 b        #0xfffffe000b184d9c; -> 0xfffffe000b184d9c FUNC 0xfffffe000b184854
0xfffffe000b184d0c  e00700f9 str      x0, [sp, #8]
0xfffffe000b184d10  20230191 add      x0, x25, #0x48
0xfffffe000b184d14  e10313aa mov      x1, x19
0xfffffe000b184d18  02008052 mov      w2, #0
0xfffffe000b184d1c  a839e997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b184d20  e00740f9 ldr      x0, [sp, #8]
0xfffffe000b184d24  281740b9 ldr      w8, [x25, #0x14]
0xfffffe000b184d28  e8fbff35 cbnz     w8, #0xfffffe000b184ca4
0xfffffe000b184d2c  efffff17 b        #0xfffffe000b184ce8; -> 0xfffffe000b184ce8 FUNC 0xfffffe000b184854
0xfffffe000b184d30  e00700f9 str      x0, [sp, #8]
0xfffffe000b184d34  20230191 add      x0, x25, #0x48
0xfffffe000b184d38  e10313aa mov      x1, x19
0xfffffe000b184d3c  993ce997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b184d40  e00740f9 ldr      x0, [sp, #8]
0xfffffe000b184d44  390340f9 ldr      x25, [x25]
0xfffffe000b184d48  f9f9ffb5 cbnz     x25, #0xfffffe000b184c84
0xfffffe000b184d4c  14000014 b        #0xfffffe000b184d9c; -> 0xfffffe000b184d9c FUNC 0xfffffe000b184854
0xfffffe000b184d50  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b184d54  e20308aa mov      x2, x8
0xfffffe000b184d58  89360090 adrp     x9, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184d5c  29812191 add      x9, x9, #0x860; 0xfffffe000b854860 ?
0xfffffe000b184d60  03000014 b        #0xfffffe000b184d6c; -> 0xfffffe000b184d6c FUNC 0xfffffe000b184854
0xfffffe000b184d64  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b184d68  e20308aa mov      x2, x8
0xfffffe000b184d6c  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b184d70  5f00086b cmp      w2, w8
0xfffffe000b184d74  210c0054 b.ne     #0xfffffe000b184ef8; -> 0xfffffe000b184ef8 FUNC 0xfffffe000b184854
0xfffffe000b184d78  fd7b46a9 ldp      x29, x30, [sp, #0x60]
0xfffffe000b184d7c  f44f45a9 ldp      x20, x19, [sp, #0x50]
0xfffffe000b184d80  f65744a9 ldp      x22, x21, [sp, #0x40]
0xfffffe000b184d84  f85f43a9 ldp      x24, x23, [sp, #0x30]
0xfffffe000b184d88  fa6742a9 ldp      x26, x25, [sp, #0x20]
0xfffffe000b184d8c  fc6f41a9 ldp      x28, x27, [sp, #0x10]
0xfffffe000b184d90  ffc30191 add      sp, sp, #0x70
0xfffffe000b184d94  ff0f5fd6 retab    
0xfffffe000b184d98  17008052 mov      w23, #0
0xfffffe000b184d9c  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b184da0  e20308aa mov      x2, x8
0xfffffe000b184da4  89360090 adrp     x9, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184da8  29812191 add      x9, x9, #0x860; 0xfffffe000b854860 ?
0xfffffe000b184dac  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b184db0  5f00086b cmp      w2, w8
0xfffffe000b184db4  a10b0054 b.ne     #0xfffffe000b184f28; -> 0xfffffe000b184f28 FUNC 0xfffffe000b184854
0xfffffe000b184db8  135b44f9 ldr      x19, [x24, #0x8b0]; [0xfffffe000b8548b0] ?
0xfffffe000b184dbc  ff060071 cmp      w23, #1
0xfffffe000b184dc0  8b060054 b.lt     #0xfffffe000b184e90; -> 0xfffffe000b184e90 FUNC 0xfffffe000b184854
0xfffffe000b184dc4  d95e44f9 ldr      x25, [x22, #0x8b8]; [0xfffffe000b8548b8] ?
0xfffffe000b184dc8  fa060011 add      w26, w23, #1
0xfffffe000b184dcc  fb0313aa mov      x27, x19
0xfffffe000b184dd0  05000014 b        #0xfffffe000b184de4; -> 0xfffffe000b184de4 FUNC 0xfffffe000b184854
0xfffffe000b184dd4  7b230091 add      x27, x27, #8
0xfffffe000b184dd8  5a070051 sub      w26, w26, #1
0xfffffe000b184ddc  5f070071 cmp      w26, #1
0xfffffe000b184de0  a9030054 b.ls     #0xfffffe000b184e54; -> 0xfffffe000b184e54 FUNC 0xfffffe000b184854
0xfffffe000b184de4  7f0319eb cmp      x27, x25
0xfffffe000b184de8  22080054 b.hs     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184dec  7f0313eb cmp      x27, x19
0xfffffe000b184df0  e3070054 b.lo     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184df4  680340f9 ldr      x8, [x27]
0xfffffe000b184df8  f10308aa mov      x17, x8
0xfffffe000b184dfc  308e42f8 ldr      x16, [x17, #0x28]!
0xfffffe000b184e00  91a7f0f2 movk     x17, #0x853c, lsl #48
0xfffffe000b184e04  301ac1da autda    x16, x17
0xfffffe000b184e08  090240b9 ldr      w9, [x16]
0xfffffe000b184e0c  3f090071 cmp      w9, #2
0xfffffe000b184e10  21feff54 b.ne     #0xfffffe000b184dd4; -> 0xfffffe000b184dd4 FUNC 0xfffffe000b184854
0xfffffe000b184e14  108d43f8 ldr      x16, [x8, #0x38]!; [0xfffffe0007f14730] ?
0xfffffe000b184e18  f0fdffb4 cbz      x16, #0xfffffe000b184dd4
0xfffffe000b184e1c  f10308aa mov      x17, x8
0xfffffe000b184e20  d136e2f2 movk     x17, #0x11b6, lsl #48
0xfffffe000b184e24  301ac1da autda    x16, x17
0xfffffe000b184e28  70fdffb4 cbz      x16, #0xfffffe000b184dd4
0xfffffe000b184e2c  f50310aa mov      x21, x16
0xfffffe000b184e30  e00310aa mov      x0, x16
0xfffffe000b184e34  01008052 mov      w1, #0
0xfffffe000b184e38  c495ff97 bl       #0xfffffe000b16a548; CALL 0xfffffe000b16a548 sz=0xdc 
0xfffffe000b184e3c  e00315aa mov      x0, x21
0xfffffe000b184e40  358cff97 bl       #0xfffffe000b167f14; CALL 0xfffffe000b167f14 sz=0x180 'sb->sb_flags & SB_LOCK'
0xfffffe000b184e44  e00315aa mov      x0, x21
0xfffffe000b184e48  01008052 mov      w1, #0
0xfffffe000b184e4c  fc88ff97 bl       #0xfffffe000b16723c; CALL 0xfffffe000b16723c sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'uipc_socket.c'; 'socket_unlock'
0xfffffe000b184e50  e1ffff17 b        #0xfffffe000b184dd4; -> 0xfffffe000b184dd4 FUNC 0xfffffe000b184854
0xfffffe000b184e54  135b44f9 ldr      x19, [x24, #0x8b0]; [0xfffffe000b8548b0] ?
0xfffffe000b184e58  d55e44f9 ldr      x21, [x22, #0x8b8]; [0xfffffe000b8548b8] ?
0xfffffe000b184e5c  f7060011 add      w23, w23, #1
0xfffffe000b184e60  f90313aa mov      x25, x19
0xfffffe000b184e64  3f0315eb cmp      x25, x21
0xfffffe000b184e68  22040054 b.hs     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184e6c  3f0313eb cmp      x25, x19
0xfffffe000b184e70  e3030054 b.lo     #0xfffffe000b184eec; -> 0xfffffe000b184eec FUNC 0xfffffe000b184854
0xfffffe000b184e74  218740f8 ldr      x1, [x25], #8
0xfffffe000b184e78  00008092 mov      x0, #-1
0xfffffe000b184e7c  b9d1fc97 bl       #0xfffffe000b0b9560; CALL 0xfffffe000b0b9560 sz=0x1f8 
0xfffffe000b184e80  f7060051 sub      w23, w23, #1
0xfffffe000b184e84  ff060071 cmp      w23, #1
0xfffffe000b184e88  ecfeff54 b.gt     #0xfffffe000b184e64; -> 0xfffffe000b184e64 FUNC 0xfffffe000b184854
0xfffffe000b184e8c  135b44f9 ldr      x19, [x24, #0x8b0]; [0xfffffe000b8548b0] ?
0xfffffe000b184e90  1f5b04f9 str      xzr, [x24, #0x8b0]
0xfffffe000b184e94  08018052 mov      w8, #8
0xfffffe000b184e98  c85e04f9 str      x8, [x22, #0x8b8]
0xfffffe000b184e9c  886cfe90 adrp     x8, #0xfffffe0007f14000; page 0xfffffe0007f14000
0xfffffe000b184ea0  08211d91 add      x8, x8, #0x748; 0xfffffe0007f14748 ?
0xfffffe000b184ea4  000140b2 orr      x0, x8, #1
0xfffffe000b184ea8  e10313aa mov      x1, x19
0xfffffe000b184eac  e20314aa mov      x2, x20
0xfffffe000b184eb0  fd7b46a9 ldp      x29, x30, [sp, #0x60]
0xfffffe000b184eb4  f44f45a9 ldp      x20, x19, [sp, #0x50]
0xfffffe000b184eb8  f65744a9 ldp      x22, x21, [sp, #0x40]
0xfffffe000b184ebc  f85f43a9 ldp      x24, x23, [sp, #0x30]
0xfffffe000b184ec0  fa6742a9 ldp      x26, x25, [sp, #0x20]
0xfffffe000b184ec4  fc6f41a9 ldp      x28, x27, [sp, #0x10]
0xfffffe000b184ec8  ffc30191 add      sp, sp, #0x70
0xfffffe000b184ecc  ff2303d5 autibsp  
0xfffffe000b184ed0  7925e917 b        #0xfffffe000abce4b4; -> 0xfffffe000abce4b4 FUNC 0xfffffe000abce4b4
0xfffffe000b184ed4  20f9fd90 adrp     x0, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b184ed8  00a40991 add      x0, x0, #0x269; 0xfffffe00070a8269 STR "so->so_rcv.sb_flags & SB_LOCK"
0xfffffe000b184edc  01f9fdf0 adrp     x1, #0xfffffe00070a7000; page 0xfffffe00070a7000
0xfffffe000b184ee0  21c43a91 add      x1, x1, #0xeb1; 0xfffffe00070a7eb1 STR "/Library/Caches/com.apple.xbs/D9089588-4191-473E-9025-574E023945ED/TemporaryDirectory.nLq3V8/Sources/xnu/bsd/kern/uipc_usrreq.c"
0xfffffe000b184ee4  224f8152 mov      w2, #0xa79
0xfffffe000b184ee8  f1c60a94 bl       #0xfffffe000b436aac; CALL 0xfffffe000b436aac sz=0x34 'uipc_socket.c'
0xfffffe000b184eec  20a32ad4 brk      #0x5519; -> 0x5519 ?
0xfffffe000b184ef0  e00308aa mov      x0, x8
0xfffffe000b184ef4  44d80a94 bl       #0xfffffe000b43b004; CALL 0xfffffe000b43b004 sz=0x44 'refcnt.c'
0xfffffe000b184ef8  80360090 adrp     x0, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184efc  00602191 add      x0, x0, #0x858; 0xfffffe000b854858 ?
0xfffffe000b184f00  e10313aa mov      x1, x19
0xfffffe000b184f04  fd7b46a9 ldp      x29, x30, [sp, #0x60]
0xfffffe000b184f08  f44f45a9 ldp      x20, x19, [sp, #0x50]
0xfffffe000b184f0c  f65744a9 ldp      x22, x21, [sp, #0x40]
0xfffffe000b184f10  f85f43a9 ldp      x24, x23, [sp, #0x30]
0xfffffe000b184f14  fa6742a9 ldp      x26, x25, [sp, #0x20]
0xfffffe000b184f18  fc6f41a9 ldp      x28, x27, [sp, #0x10]
0xfffffe000b184f1c  ffc30191 add      sp, sp, #0x70
0xfffffe000b184f20  ff2303d5 autibsp  
0xfffffe000b184f24  1f3ce917 b        #0xfffffe000abd3fa0; -> 0xfffffe000abd3fa0 FUNC 0xfffffe000abd3fa0
0xfffffe000b184f28  80360090 adrp     x0, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b184f2c  00602191 add      x0, x0, #0x858; 0xfffffe000b854858 ?
0xfffffe000b184f30  e10313aa mov      x1, x19
0xfffffe000b184f34  1b3ce997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b184f38  a0ffff17 b        #0xfffffe000b184db8; -> 0xfffffe000b184db8 FUNC 0xfffffe000b184854
