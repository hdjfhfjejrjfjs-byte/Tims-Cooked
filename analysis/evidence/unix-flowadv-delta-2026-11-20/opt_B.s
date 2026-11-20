0xfffffe000b1da6d8  7f2303d5 pacibsp  
0xfffffe000b1da6dc  ffc301d1 sub      sp, sp, #0x70
0xfffffe000b1da6e0  fc6f01a9 stp      x28, x27, [sp, #0x10]
0xfffffe000b1da6e4  fa6702a9 stp      x26, x25, [sp, #0x20]
0xfffffe000b1da6e8  f85f03a9 stp      x24, x23, [sp, #0x30]
0xfffffe000b1da6ec  f65704a9 stp      x22, x21, [sp, #0x40]
0xfffffe000b1da6f0  f44f05a9 stp      x20, x19, [sp, #0x50]
0xfffffe000b1da6f4  fd7b06a9 stp      x29, x30, [sp, #0x60]
0xfffffe000b1da6f8  fd830191 add      x29, sp, #0x60
0xfffffe000b1da6fc  953600d0 adrp     x21, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1da700  b5022991 add      x21, x21, #0xa40; 0xfffffe000b8aca40 ?
0xfffffe000b1da704  93d038d5 mrs      x19, tpidr_el1
0xfffffe000b1da708  983600d0 adrp     x24, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1da70c  973600d0 adrp     x23, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1da710  19008252 mov      w25, #0x1000
0xfffffe000b1da714  da3000d0 adrp     x26, #0xfffffe000b7f4000; page 0xfffffe000b7f4000
0xfffffe000b1da718  fbff9f52 mov      w27, #0xffff
0xfffffe000b1da71c  14008452 mov      w20, #0x2000
0xfffffe000b1da720  16008652 mov      w22, #0x3000
0xfffffe000b1da724  080080d2 mov      x8, #0
0xfffffe000b1da728  69fa44b9 ldr      w9, [x19, #0x4f8]
0xfffffe000b1da72c  a97ee8c8 casa     x8, x9, [x21]
0xfffffe000b1da730  1f0100f1 cmp      x8, #0
0xfffffe000b1da734  811a0054 b.ne     #0xfffffe000b1daa84; -> 0xfffffe000b1daa84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da738  1fa30ab9 str      wzr, [x24, #0xaa0]
0xfffffe000b1da73c  e84245f9 ldr      x8, [x23, #0xa80]; [0xfffffe000b8aca80] ?
0xfffffe000b1da740  a80000b4 cbz      x8, #0xfffffe000b1da754
0xfffffe000b1da744  09410091 add      x9, x8, #0x10
0xfffffe000b1da748  291136b8 ldclr    w22, w9, [x9]
0xfffffe000b1da74c  080140f9 ldr      x8, [x8]
0xfffffe000b1da750  a8ffffb5 cbnz     x8, #0xfffffe000b1da744
0xfffffe000b1da754  08008052 mov      w8, #0
0xfffffe000b1da758  03000014 b        #0xfffffe000b1da764; -> 0xfffffe000b1da764 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da75c  08a34ab9 ldr      w8, [x24, #0xaa0]; [0xfffffe000b8acaa0] ?
0xfffffe000b1da760  e8190034 cbz      w8, #0xfffffe000b1daa9c
0xfffffe000b1da764  fc4245f9 ldr      x28, [x23, #0xa80]; [0xfffffe000b8aca80] ?
0xfffffe000b1da768  dcffffb4 cbz      x28, #0xfffffe000b1da760
0xfffffe000b1da76c  080080d2 mov      x8, #0
0xfffffe000b1da770  69fa44b9 ldr      w9, [x19, #0x4f8]
0xfffffe000b1da774  8a430191 add      x10, x28, #0x50
0xfffffe000b1da778  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1da77c  1f0100f1 cmp      x8, #0
0xfffffe000b1da780  61140054 b.ne     #0xfffffe000b1daa0c; -> 0xfffffe000b1daa0c FUNC 0xfffffe000b1da6d8
0xfffffe000b1da784  881740b9 ldr      w8, [x28, #0x14]
0xfffffe000b1da788  a8040034 cbz      w8, #0xfffffe000b1da81c
0xfffffe000b1da78c  881340b9 ldr      w8, [x28, #0x10]
0xfffffe000b1da790  28016837 tbnz     w8, #0xd, #0xfffffe000b1da7b4
0xfffffe000b1da794  48046037 tbnz     w8, #0xc, #0xfffffe000b1da81c
0xfffffe000b1da798  881740b9 ldr      w8, [x28, #0x14]
0xfffffe000b1da79c  891b40b9 ldr      w9, [x28, #0x18]
0xfffffe000b1da7a0  1f01096b cmp      w8, w9
0xfffffe000b1da7a4  c0030054 b.eq     #0xfffffe000b1da81c; -> 0xfffffe000b1da81c FUNC 0xfffffe000b1da6d8
0xfffffe000b1da7a8  88430091 add      x8, x28, #0x10
0xfffffe000b1da7ac  083139b8 ldset    w25, w8, [x8]
0xfffffe000b1da7b0  06000014 b        #0xfffffe000b1da7c8; -> 0xfffffe000b1da7c8 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da7b4  88430091 add      x8, x28, #0x10
0xfffffe000b1da7b8  081134b8 ldclr    w20, w8, [x8]
0xfffffe000b1da7bc  08a34ab9 ldr      w8, [x24, #0xaa0]; [0xfffffe000b8acaa0] ?
0xfffffe000b1da7c0  08050051 sub      w8, w8, #1
0xfffffe000b1da7c4  08a30ab9 str      w8, [x24, #0xaa0]
0xfffffe000b1da7c8  f1031caa mov      x17, x28
0xfffffe000b1da7cc  308e42f8 ldr      x16, [x17, #0x28]!
0xfffffe000b1da7d0  91a7f0f2 movk     x17, #0x853c, lsl #48
0xfffffe000b1da7d4  301ac1da autda    x16, x17
0xfffffe000b1da7d8  080240b9 ldr      w8, [x16]
0xfffffe000b1da7dc  1f090071 cmp      w8, #2
0xfffffe000b1da7e0  e1010054 b.ne     #0xfffffe000b1da81c; -> 0xfffffe000b1da81c FUNC 0xfffffe000b1da6d8
0xfffffe000b1da7e4  f1031caa mov      x17, x28
0xfffffe000b1da7e8  308e43f8 ldr      x16, [x17, #0x38]!
0xfffffe000b1da7ec  900100b4 cbz      x16, #0xfffffe000b1da81c
0xfffffe000b1da7f0  d136e2f2 movk     x17, #0x11b6, lsl #48
0xfffffe000b1da7f4  301ac1da autda    x16, x17
0xfffffe000b1da7f8  300100b4 cbz      x16, #0xfffffe000b1da81c
0xfffffe000b1da7fc  f50310aa mov      x21, x16
0xfffffe000b1da800  081240f9 ldr      x8, [x16, #0x20]
0xfffffe000b1da804  090940f9 ldr      x9, [x8, #0x10]
0xfffffe000b1da808  4acf43f9 ldr      x10, [x26, #0x798]; [0xfffffe000b7f4798] ?
0xfffffe000b1da80c  3f010aeb cmp      x9, x10
0xfffffe000b1da810  61000054 b.ne     #0xfffffe000b1da81c; -> 0xfffffe000b1da81c FUNC 0xfffffe000b1da6d8
0xfffffe000b1da814  08914039 ldrb     w8, [x8, #0x24]
0xfffffe000b1da818  48012037 tbnz     w8, #4, #0xfffffe000b1da840
0xfffffe000b1da81c  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b1da820  89430191 add      x9, x28, #0x50
0xfffffe000b1da824  e20308aa mov      x2, x8
0xfffffe000b1da828  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1da82c  5f00086b cmp      w2, w8
0xfffffe000b1da830  c10f0054 b.ne     #0xfffffe000b1daa28; -> 0xfffffe000b1daa28 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da834  9c0340f9 ldr      x28, [x28]
0xfffffe000b1da838  bcf9ffb5 cbnz     x28, #0xfffffe000b1da76c
0xfffffe000b1da83c  c8ffff17 b        #0xfffffe000b1da75c; -> 0xfffffe000b1da75c FUNC 0xfffffe000b1da6d8
0xfffffe000b1da840  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b1da844  89430191 add      x9, x28, #0x50
0xfffffe000b1da848  e20308aa mov      x2, x8
0xfffffe000b1da84c  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1da850  5f00086b cmp      w2, w8
0xfffffe000b1da854  210f0054 b.ne     #0xfffffe000b1daa38; -> 0xfffffe000b1daa38 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da858  a8020f91 add      x8, x21, #0x3c0; 0xfffffe000b8ace00 ?
0xfffffe000b1da85c  1f0115eb cmp      x8, x21
0xfffffe000b1da860  29290054 b.ls     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da864  a91240f9 ldr      x9, [x21, #0x20]; [0xfffffe000b8aca60] ?
0xfffffe000b1da868  283940f9 ldr      x8, [x9, #0x70]
0xfffffe000b1da86c  c80000b4 cbz      x8, #0xfffffe000b1da884
0xfffffe000b1da870  e00315aa mov      x0, x21
0xfffffe000b1da874  01008052 mov      w1, #0
0xfffffe000b1da878  b1679ed2 mov      x17, #0xf33d
0xfffffe000b1da87c  11093fd7 blraa    x8, x17
0xfffffe000b1da880  03000014 b        #0xfffffe000b1da88c; -> 0xfffffe000b1da88c FUNC 0xfffffe000b1da6d8
0xfffffe000b1da884  280940f9 ldr      x8, [x9, #0x10]
0xfffffe000b1da888  000940f9 ldr      x0, [x8, #0x10]; [0xfffffe000b8ace10] ?
0xfffffe000b1da88c  08008052 mov      w8, #0
0xfffffe000b1da890  69fa44b9 ldr      w9, [x19, #0x4f8]
0xfffffe000b1da894  0a200091 add      x10, x0, #8
0xfffffe000b1da898  497de888 casa     w8, w9, [x10]
0xfffffe000b1da89c  1f010071 cmp      w8, #0
0xfffffe000b1da8a0  a10d0054 b.ne     #0xfffffe000b1daa54; -> 0xfffffe000b1daa54 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da8a4  a83e42b9 ldr      w8, [x21, #0x23c]; [0xfffffe000b8acc7c] ?
0xfffffe000b1da8a8  08050011 add      w8, w8, #1
0xfffffe000b1da8ac  a83e02b9 str      w8, [x21, #0x23c]
0xfffffe000b1da8b0  a0c20191 add      x0, x21, #0x70; 0xfffffe000b8acab0 ?
0xfffffe000b1da8b4  c1008052 mov      w1, #6
0xfffffe000b1da8b8  1bccff97 bl       #0xfffffe000b1cd924; CALL 0xfffffe000b1cd924 sz=0x27c '/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_s'; 'crementAtomic64(&net_api_stats.nas_sfltr_register_os_count) > 0'; 's.nas_sfltr_register_os_count) > 0'
0xfffffe000b1da8bc  600c0035 cbnz     w0, #0xfffffe000b1daa48
0xfffffe000b1da8c0  a8c24339 ldrb     w8, [x21, #0xf0]; [0xfffffe000b8acb30] ?
0xfffffe000b1da8c4  48250036 tbz      w8, #0, #0xfffffe000b1dad6c
0xfffffe000b1da8c8  e00315aa mov      x0, x21
0xfffffe000b1da8cc  01008052 mov      w1, #0
0xfffffe000b1da8d0  dc89ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b1da8d4  a84640f9 ldr      x8, [x21, #0x88]; [0xfffffe000b8acac8] ?
0xfffffe000b1da8d8  e14770b2 mov      x1, #0x3ffff0000
0xfffffe000b1da8dc  81fe9ff2 movk     x1, #0xfff4
0xfffffe000b1da8e0  280800b4 cbz      x8, #0xfffffe000b1da9e4
0xfffffe000b1da8e4  09a34ab9 ldr      w9, [x24, #0xaa0]; [0xfffffe000b8acaa0] ?
0xfffffe000b1da8e8  03000014 b        #0xfffffe000b1da8f4; -> 0xfffffe000b1da8f4 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da8ec  080540f9 ldr      x8, [x8, #8]; [0xfffffe000b8ace08] ?
0xfffffe000b1da8f0  a80700b4 cbz      x8, #0xfffffe000b1da9e4
0xfffffe000b1da8f4  ec0308aa mov      x12, x8
0xfffffe000b1da8f8  03000014 b        #0xfffffe000b1da904; -> 0xfffffe000b1da904 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da8fc  8c0140f9 ldr      x12, [x12]
0xfffffe000b1da900  6cffffb4 cbz      x12, #0xfffffe000b1da8ec
0xfffffe000b1da904  8a394079 ldrh     w10, [x12, #0x1c]
0xfffffe000b1da908  5f390071 cmp      w10, #0xe
0xfffffe000b1da90c  81ffff54 b.ne     #0xfffffe000b1da8fc; -> 0xfffffe000b1da8fc FUNC 0xfffffe000b1da6d8
0xfffffe000b1da910  8a1940b9 ldr      w10, [x12, #0x18]
0xfffffe000b1da914  5f310071 cmp      w10, #0xc
0xfffffe000b1da918  23ffff54 b.lo     #0xfffffe000b1da8fc; -> 0xfffffe000b1da8fc FUNC 0xfffffe000b1da6d8
0xfffffe000b1da91c  8a3d4079 ldrh     w10, [x12, #0x1e]
0xfffffe000b1da920  8a000037 tbnz     w10, #0, #0xfffffe000b1da930
0xfffffe000b1da924  8a810391 add      x10, x12, #0xe0
0xfffffe000b1da928  8b010891 add      x11, x12, #0x200
0xfffffe000b1da92c  04000014 b        #0xfffffe000b1da93c; -> 0xfffffe000b1da93c FUNC 0xfffffe000b1da6d8
0xfffffe000b1da930  8b3140b9 ldr      w11, [x12, #0x30]
0xfffffe000b1da934  8a1140f9 ldr      x10, [x12, #0x20]
0xfffffe000b1da938  4b010b8b add      x11, x10, x11
0xfffffe000b1da93c  8d0940f9 ldr      x13, [x12, #0x10]
0xfffffe000b1da940  5f010deb cmp      x10, x13
0xfffffe000b1da944  08220054 b.hi     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da948  b1310091 add      x17, x13, #0xc
0xfffffe000b1da94c  3f020beb cmp      x17, x11
0xfffffe000b1da950  a8210054 b.hi     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da954  ae0540b9 ldr      w14, [x13, #4]
0xfffffe000b1da958  df011b6b cmp      w14, w27
0xfffffe000b1da95c  01fdff54 b.ne     #0xfffffe000b1da8fc; -> 0xfffffe000b1da8fc FUNC 0xfffffe000b1da6d8
0xfffffe000b1da960  ae0940b9 ldr      w14, [x13, #8]
0xfffffe000b1da964  df050071 cmp      w14, #1
0xfffffe000b1da968  a1fcff54 b.ne     #0xfffffe000b1da8fc; -> 0xfffffe000b1da8fc FUNC 0xfffffe000b1da6d8
0xfffffe000b1da96c  ac0140b9 ldr      w12, [x13]
0xfffffe000b1da970  8c01018b add      x12, x12, x1
0xfffffe000b1da974  8cfd42d3 lsr      x12, x12, #2
0xfffffe000b1da978  9f050071 cmp      w12, #1
0xfffffe000b1da97c  8bfbff54 b.lt     #0xfffffe000b1da8ec; -> 0xfffffe000b1da8ec FUNC 0xfffffe000b1da6d8
0xfffffe000b1da980  0d008052 mov      w13, #0
0xfffffe000b1da984  3f020beb cmp      x17, x11
0xfffffe000b1da988  e21f0054 b.hs     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da98c  3f020aeb cmp      x17, x10
0xfffffe000b1da990  a31f0054 b.lo     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da994  2e220091 add      x14, x17, #8
0xfffffe000b1da998  300240f9 ldr      x16, [x17]
0xfffffe000b1da99c  1193fdf2 movk     x17, #0xec98, lsl #48
0xfffffe000b1da9a0  301ac1da autda    x16, x17
0xfffffe000b1da9a4  111240b9 ldr      w17, [x16, #0x10]
0xfffffe000b1da9a8  0f420091 add      x15, x16, #0x10
0xfffffe000b1da9ac  31016037 tbnz     w17, #0xc, #0xfffffe000b1da9d0
0xfffffe000b1da9b0  30061432 orr      w16, w17, #0x3000
0xfffffe000b1da9b4  e00311aa mov      x0, x17
0xfffffe000b1da9b8  f07da088 cas      w0, w16, [x15]
0xfffffe000b1da9bc  1f00116b cmp      w0, w17
0xfffffe000b1da9c0  f10300aa mov      x17, x0
0xfffffe000b1da9c4  41ffff54 b.ne     #0xfffffe000b1da9ac; -> 0xfffffe000b1da9ac FUNC 0xfffffe000b1da6d8
0xfffffe000b1da9c8  29050011 add      w9, w9, #1
0xfffffe000b1da9cc  09a30ab9 str      w9, [x24, #0xaa0]
0xfffffe000b1da9d0  ad050011 add      w13, w13, #1
0xfffffe000b1da9d4  f1030eaa mov      x17, x14
0xfffffe000b1da9d8  bf010c6b cmp      w13, w12
0xfffffe000b1da9dc  41fdff54 b.ne     #0xfffffe000b1da984; -> 0xfffffe000b1da984 FUNC 0xfffffe000b1da6d8
0xfffffe000b1da9e0  c3ffff17 b        #0xfffffe000b1da8ec; -> 0xfffffe000b1da8ec FUNC 0xfffffe000b1da6d8
0xfffffe000b1da9e4  e00315aa mov      x0, x21
0xfffffe000b1da9e8  01008052 mov      w1, #0
0xfffffe000b1da9ec  5896ff97 bl       #0xfffffe000b1c034c; CALL 0xfffffe000b1c034c sz=0xdc 
0xfffffe000b1da9f0  a0c20191 add      x0, x21, #0x70; 0xfffffe000b8acab0 ?
0xfffffe000b1da9f4  21008052 mov      w1, #1
0xfffffe000b1da9f8  67cdff97 bl       #0xfffffe000b1cdf94; CALL 0xfffffe000b1cdf94 sz=0x324 '/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_s'; '(sb->sb_flags & SB_LOCK) || (so->so_state & SS_DEFUNCT) || (so->so_flags1 & SOF1_DEFUNCTINPROG)'; '%s: null so, sb=%p sb_flags=0x%x lr=%p @%s:%d'
0xfffffe000b1da9fc  e00315aa mov      x0, x21
0xfffffe000b1daa00  21008052 mov      w1, #1
0xfffffe000b1daa04  8f89ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b1daa08  8bffff17 b        #0xfffffe000b1da834; -> 0xfffffe000b1da834 FUNC 0xfffffe000b1da6d8
0xfffffe000b1daa0c  80230191 add      x0, x28, #0x48
0xfffffe000b1daa10  e10313aa mov      x1, x19
0xfffffe000b1daa14  02008052 mov      w2, #0
0xfffffe000b1daa18  5c27e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1daa1c  881740b9 ldr      w8, [x28, #0x14]
0xfffffe000b1daa20  68ebff35 cbnz     w8, #0xfffffe000b1da78c
0xfffffe000b1daa24  7effff17 b        #0xfffffe000b1da81c; -> 0xfffffe000b1da81c FUNC 0xfffffe000b1da6d8
0xfffffe000b1daa28  80230191 add      x0, x28, #0x48
0xfffffe000b1daa2c  e10313aa mov      x1, x19
0xfffffe000b1daa30  4f2ae997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1daa34  80ffff17 b        #0xfffffe000b1da834; -> 0xfffffe000b1da834 FUNC 0xfffffe000b1da6d8
0xfffffe000b1daa38  80230191 add      x0, x28, #0x48
0xfffffe000b1daa3c  e10313aa mov      x1, x19
0xfffffe000b1daa40  4b2ae997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1daa44  85ffff17 b        #0xfffffe000b1da858; -> 0xfffffe000b1da858 FUNC 0xfffffe000b1da6d8
0xfffffe000b1daa48  e00315aa mov      x0, x21
0xfffffe000b1daa4c  21008052 mov      w1, #1
0xfffffe000b1daa50  7c89ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b1daa54  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b1daa58  e20308aa mov      x2, x8
0xfffffe000b1daa5c  953600d0 adrp     x21, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1daa60  b5022991 add      x21, x21, #0xa40; 0xfffffe000b8aca40 ?
0xfffffe000b1daa64  bffea288 casl     w2, wzr, [x21]
0xfffffe000b1daa68  5f00086b cmp      w2, w8
0xfffffe000b1daa6c  c0e5ff54 b.eq     #0xfffffe000b1da724; -> 0xfffffe000b1da724 FUNC 0xfffffe000b1da6d8
0xfffffe000b1daa70  803600d0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1daa74  00e02891 add      x0, x0, #0xa38; 0xfffffe000b8aca38 ?
0xfffffe000b1daa78  e10313aa mov      x1, x19
0xfffffe000b1daa7c  3c2ae997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1daa80  29ffff17 b        #0xfffffe000b1da724; -> 0xfffffe000b1da724 FUNC 0xfffffe000b1da6d8
0xfffffe000b1daa84  803600d0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1daa88  00e02891 add      x0, x0, #0xa38; 0xfffffe000b8aca38 ?
0xfffffe000b1daa8c  e10313aa mov      x1, x19
0xfffffe000b1daa90  02008052 mov      w2, #0
0xfffffe000b1daa94  3d27e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1daa98  28ffff17 b        #0xfffffe000b1da738; -> 0xfffffe000b1da738 FUNC 0xfffffe000b1da6d8
0xfffffe000b1daa9c  c83000d0 adrp     x8, #0xfffffe000b7f4000; page 0xfffffe000b7f4000
0xfffffe000b1daaa0  08a187b9 ldrsw    x8, [x8, #0x7a0]; [0xfffffe000b7f47a0] ?
0xfffffe000b1daaa4  280a0034 cbz      w8, #0xfffffe000b1dabe8
0xfffffe000b1daaa8  09f17dd3 lsl      x9, x8, #3
0xfffffe000b1daaac  1f050031 cmn      w8, #1
0xfffffe000b1daab0  0800f0d2 mov      x8, #-0x8000000000000000
0xfffffe000b1daab4  34c1889a csel     x20, x9, x8, gt
0xfffffe000b1daab8  486afed0 adrp     x8, #0xfffffe0007f24000; page 0xfffffe0007f24000
0xfffffe000b1daabc  08812f91 add      x8, x8, #0xbe0; 0xfffffe0007f24be0 ?
0xfffffe000b1daac0  000140b2 orr      x0, x8, #1
0xfffffe000b1daac4  e10314aa mov      x1, x20
0xfffffe000b1daac8  02008052 mov      w2, #0
0xfffffe000b1daacc  030080d2 mov      x3, #0
0xfffffe000b1daad0  ed11e997 bl       #0xfffffe000ac1f284; CALL 0xfffffe000ac1f284 sz=0x160 
0xfffffe000b1daad4  1500148b add      x21, x0, x20; 0xfffffe000b8acb26 ?
0xfffffe000b1daad8  100015ca eor      x16, x0, x21
0xfffffe000b1daadc  1f264af2 tst      x16, #-0x40000000000000
0xfffffe000b1daae0  40000054 b.eq     #0xfffffe000b1daae8; -> 0xfffffe000b1daae8 FUNC 0xfffffe000b1da6d8
0xfffffe000b1daae4  5514f9f2 movk     x21, #0xc8a2, lsl #48
0xfffffe000b1daae8  983600d0 adrp     x24, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1daaec  004b05f9 str      x0, [x24, #0xa90]
0xfffffe000b1daaf0  963600d0 adrp     x22, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1daaf4  d54e05f9 str      x21, [x22, #0xa98]
0xfffffe000b1daaf8  893600d0 adrp     x9, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1daafc  29012991 add      x9, x9, #0xa40; 0xfffffe000b8aca40 ?
0xfffffe000b1dab00  e00700b4 cbz      x0, #0xfffffe000b1dabfc
0xfffffe000b1dab04  f94245f9 ldr      x25, [x23, #0xa80]; [0xfffffe000b8aca80] ?
0xfffffe000b1dab08  590900b4 cbz      x25, #0xfffffe000b1dac30
0xfffffe000b1dab0c  17008052 mov      w23, #0
0xfffffe000b1dab10  3a008052 mov      w26, #1
0xfffffe000b1dab14  fb130432 mov      w27, #-0xfffffff
0xfffffe000b1dab18  fc0300aa mov      x28, x0
0xfffffe000b1dab1c  080080d2 mov      x8, #0
0xfffffe000b1dab20  69fa44b9 ldr      w9, [x19, #0x4f8]
0xfffffe000b1dab24  2a430191 add      x10, x25, #0x50
0xfffffe000b1dab28  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1dab2c  1f0100f1 cmp      x8, #0
0xfffffe000b1dab30  a1030054 b.ne     #0xfffffe000b1daba4; -> 0xfffffe000b1daba4 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dab34  281740b9 ldr      w8, [x25, #0x14]
0xfffffe000b1dab38  48020034 cbz      w8, #0xfffffe000b1dab80
0xfffffe000b1dab3c  28474039 ldrb     w8, [x25, #0x11]
0xfffffe000b1dab40  08022037 tbnz     w8, #4, #0xfffffe000b1dab80
0xfffffe000b1dab44  281740b9 ldr      w8, [x25, #0x14]
0xfffffe000b1dab48  291b40b9 ldr      w9, [x25, #0x18]
0xfffffe000b1dab4c  1f01096b cmp      w8, w9
0xfffffe000b1dab50  81010054 b.ne     #0xfffffe000b1dab80; -> 0xfffffe000b1dab80 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dab54  28530091 add      x8, x25, #0x14
0xfffffe000b1dab58  09013ab8 ldadd    w26, w9, [x8]
0xfffffe000b1dab5c  29011b0b add      w9, w9, w27
0xfffffe000b1dab60  3f011b6b cmp      w9, w27
0xfffffe000b1dab64  29110054 b.ls     #0xfffffe000b1dad88; -> 0xfffffe000b1dad88 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dab68  9f0315eb cmp      x28, x21
0xfffffe000b1dab6c  c2100054 b.hs     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dab70  9f0300eb cmp      x28, x0
0xfffffe000b1dab74  83100054 b.lo     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dab78  998700f8 str      x25, [x28], #8
0xfffffe000b1dab7c  f7060011 add      w23, w23, #1
0xfffffe000b1dab80  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b1dab84  29430191 add      x9, x25, #0x50
0xfffffe000b1dab88  e20308aa mov      x2, x8
0xfffffe000b1dab8c  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1dab90  5f00086b cmp      w2, w8
0xfffffe000b1dab94  a1010054 b.ne     #0xfffffe000b1dabc8; -> 0xfffffe000b1dabc8 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dab98  390340f9 ldr      x25, [x25]
0xfffffe000b1dab9c  19fcffb5 cbnz     x25, #0xfffffe000b1dab1c
0xfffffe000b1daba0  25000014 b        #0xfffffe000b1dac34; -> 0xfffffe000b1dac34 FUNC 0xfffffe000b1da6d8
0xfffffe000b1daba4  e00700f9 str      x0, [sp, #8]
0xfffffe000b1daba8  20230191 add      x0, x25, #0x48
0xfffffe000b1dabac  e10313aa mov      x1, x19
0xfffffe000b1dabb0  02008052 mov      w2, #0
0xfffffe000b1dabb4  f526e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1dabb8  e00740f9 ldr      x0, [sp, #8]
0xfffffe000b1dabbc  281740b9 ldr      w8, [x25, #0x14]
0xfffffe000b1dabc0  e8fbff35 cbnz     w8, #0xfffffe000b1dab3c
0xfffffe000b1dabc4  efffff17 b        #0xfffffe000b1dab80; -> 0xfffffe000b1dab80 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dabc8  e00700f9 str      x0, [sp, #8]
0xfffffe000b1dabcc  20230191 add      x0, x25, #0x48
0xfffffe000b1dabd0  e10313aa mov      x1, x19
0xfffffe000b1dabd4  e629e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1dabd8  e00740f9 ldr      x0, [sp, #8]
0xfffffe000b1dabdc  390340f9 ldr      x25, [x25]
0xfffffe000b1dabe0  f9f9ffb5 cbnz     x25, #0xfffffe000b1dab1c
0xfffffe000b1dabe4  14000014 b        #0xfffffe000b1dac34; -> 0xfffffe000b1dac34 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dabe8  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b1dabec  e20308aa mov      x2, x8
0xfffffe000b1dabf0  893600d0 adrp     x9, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1dabf4  29012991 add      x9, x9, #0xa40; 0xfffffe000b8aca40 ?
0xfffffe000b1dabf8  03000014 b        #0xfffffe000b1dac04; -> 0xfffffe000b1dac04 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dabfc  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b1dac00  e20308aa mov      x2, x8
0xfffffe000b1dac04  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1dac08  5f00086b cmp      w2, w8
0xfffffe000b1dac0c  210c0054 b.ne     #0xfffffe000b1dad90; -> 0xfffffe000b1dad90 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dac10  fd7b46a9 ldp      x29, x30, [sp, #0x60]
0xfffffe000b1dac14  f44f45a9 ldp      x20, x19, [sp, #0x50]
0xfffffe000b1dac18  f65744a9 ldp      x22, x21, [sp, #0x40]
0xfffffe000b1dac1c  f85f43a9 ldp      x24, x23, [sp, #0x30]
0xfffffe000b1dac20  fa6742a9 ldp      x26, x25, [sp, #0x20]
0xfffffe000b1dac24  fc6f41a9 ldp      x28, x27, [sp, #0x10]
0xfffffe000b1dac28  ffc30191 add      sp, sp, #0x70
0xfffffe000b1dac2c  ff0f5fd6 retab    
0xfffffe000b1dac30  17008052 mov      w23, #0
0xfffffe000b1dac34  68fa44b9 ldr      w8, [x19, #0x4f8]
0xfffffe000b1dac38  e20308aa mov      x2, x8
0xfffffe000b1dac3c  893600d0 adrp     x9, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1dac40  29012991 add      x9, x9, #0xa40; 0xfffffe000b8aca40 ?
0xfffffe000b1dac44  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1dac48  5f00086b cmp      w2, w8
0xfffffe000b1dac4c  a10b0054 b.ne     #0xfffffe000b1dadc0; -> 0xfffffe000b1dadc0 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dac50  134b45f9 ldr      x19, [x24, #0xa90]; [0xfffffe000b8aca90] ?
0xfffffe000b1dac54  ff060071 cmp      w23, #1
0xfffffe000b1dac58  8b060054 b.lt     #0xfffffe000b1dad28; -> 0xfffffe000b1dad28 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dac5c  d94e45f9 ldr      x25, [x22, #0xa98]; [0xfffffe000b8aca98] ?
0xfffffe000b1dac60  fa060011 add      w26, w23, #1
0xfffffe000b1dac64  fb0313aa mov      x27, x19
0xfffffe000b1dac68  05000014 b        #0xfffffe000b1dac7c; -> 0xfffffe000b1dac7c FUNC 0xfffffe000b1da6d8
0xfffffe000b1dac6c  7b230091 add      x27, x27, #8
0xfffffe000b1dac70  5a070051 sub      w26, w26, #1
0xfffffe000b1dac74  5f070071 cmp      w26, #1
0xfffffe000b1dac78  a9030054 b.ls     #0xfffffe000b1dacec; -> 0xfffffe000b1dacec FUNC 0xfffffe000b1da6d8
0xfffffe000b1dac7c  7f0319eb cmp      x27, x25
0xfffffe000b1dac80  22080054 b.hs     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dac84  7f0313eb cmp      x27, x19
0xfffffe000b1dac88  e3070054 b.lo     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dac8c  680340f9 ldr      x8, [x27]
0xfffffe000b1dac90  f10308aa mov      x17, x8
0xfffffe000b1dac94  308e42f8 ldr      x16, [x17, #0x28]!
0xfffffe000b1dac98  91a7f0f2 movk     x17, #0x853c, lsl #48
0xfffffe000b1dac9c  301ac1da autda    x16, x17
0xfffffe000b1daca0  090240b9 ldr      w9, [x16]
0xfffffe000b1daca4  3f090071 cmp      w9, #2
0xfffffe000b1daca8  21feff54 b.ne     #0xfffffe000b1dac6c; -> 0xfffffe000b1dac6c FUNC 0xfffffe000b1da6d8
0xfffffe000b1dacac  108d43f8 ldr      x16, [x8, #0x38]!; [0xfffffe0007f24c18] ?
0xfffffe000b1dacb0  f0fdffb4 cbz      x16, #0xfffffe000b1dac6c
0xfffffe000b1dacb4  f10308aa mov      x17, x8
0xfffffe000b1dacb8  d136e2f2 movk     x17, #0x11b6, lsl #48
0xfffffe000b1dacbc  301ac1da autda    x16, x17
0xfffffe000b1dacc0  70fdffb4 cbz      x16, #0xfffffe000b1dac6c
0xfffffe000b1dacc4  f50310aa mov      x21, x16
0xfffffe000b1dacc8  e00310aa mov      x0, x16
0xfffffe000b1daccc  01008052 mov      w1, #0
0xfffffe000b1dacd0  9f95ff97 bl       #0xfffffe000b1c034c; CALL 0xfffffe000b1c034c sz=0xdc 
0xfffffe000b1dacd4  e00315aa mov      x0, x21
0xfffffe000b1dacd8  108cff97 bl       #0xfffffe000b1bdd18; CALL 0xfffffe000b1bdd18 sz=0x180 'y.14N5mt/Sources/xnu/bsd/kern/kpi_socket.c'
0xfffffe000b1dacdc  e00315aa mov      x0, x21
0xfffffe000b1dace0  01008052 mov      w1, #0
0xfffffe000b1dace4  d788ff97 bl       #0xfffffe000b1bd040; CALL 0xfffffe000b1bd040 sz=0x1a4 '%s: null so_proto so=%p @%s:%d'; 'socket_unlock'; 'uipc_socket.c'
0xfffffe000b1dace8  e1ffff17 b        #0xfffffe000b1dac6c; -> 0xfffffe000b1dac6c FUNC 0xfffffe000b1da6d8
0xfffffe000b1dacec  134b45f9 ldr      x19, [x24, #0xa90]; [0xfffffe000b8aca90] ?
0xfffffe000b1dacf0  d54e45f9 ldr      x21, [x22, #0xa98]; [0xfffffe000b8aca98] ?
0xfffffe000b1dacf4  f7060011 add      w23, w23, #1
0xfffffe000b1dacf8  f90313aa mov      x25, x19
0xfffffe000b1dacfc  3f0315eb cmp      x25, x21
0xfffffe000b1dad00  22040054 b.hs     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dad04  3f0313eb cmp      x25, x19
0xfffffe000b1dad08  e3030054 b.lo     #0xfffffe000b1dad84; -> 0xfffffe000b1dad84 FUNC 0xfffffe000b1da6d8
0xfffffe000b1dad0c  218740f8 ldr      x1, [x25], #8
0xfffffe000b1dad10  00008092 mov      x0, #-1
0xfffffe000b1dad14  12d0fc97 bl       #0xfffffe000b10ed5c; CALL 0xfffffe000b10ed5c sz=0x1f8 
0xfffffe000b1dad18  f7060051 sub      w23, w23, #1
0xfffffe000b1dad1c  ff060071 cmp      w23, #1
0xfffffe000b1dad20  ecfeff54 b.gt     #0xfffffe000b1dacfc; -> 0xfffffe000b1dacfc FUNC 0xfffffe000b1da6d8
0xfffffe000b1dad24  134b45f9 ldr      x19, [x24, #0xa90]; [0xfffffe000b8aca90] ?
0xfffffe000b1dad28  1f4b05f9 str      xzr, [x24, #0xa90]
0xfffffe000b1dad2c  08018052 mov      w8, #8
0xfffffe000b1dad30  c84e05f9 str      x8, [x22, #0xa98]
0xfffffe000b1dad34  486afed0 adrp     x8, #0xfffffe0007f24000; page 0xfffffe0007f24000
0xfffffe000b1dad38  08c13091 add      x8, x8, #0xc30; 0xfffffe0007f24c30 ?
0xfffffe000b1dad3c  000140b2 orr      x0, x8, #1
0xfffffe000b1dad40  e10313aa mov      x1, x19
0xfffffe000b1dad44  e20314aa mov      x2, x20
0xfffffe000b1dad48  fd7b46a9 ldp      x29, x30, [sp, #0x60]
0xfffffe000b1dad4c  f44f45a9 ldp      x20, x19, [sp, #0x50]
0xfffffe000b1dad50  f65744a9 ldp      x22, x21, [sp, #0x40]
0xfffffe000b1dad54  f85f43a9 ldp      x24, x23, [sp, #0x30]
0xfffffe000b1dad58  fa6742a9 ldp      x26, x25, [sp, #0x20]
0xfffffe000b1dad5c  fc6f41a9 ldp      x28, x27, [sp, #0x10]
0xfffffe000b1dad60  ffc30191 add      sp, sp, #0x70
0xfffffe000b1dad64  ff2303d5 autibsp  
0xfffffe000b1dad68  c612e917 b        #0xfffffe000ac1f880; -> 0xfffffe000ac1f880 FUNC 0xfffffe000ac1f880
0xfffffe000b1dad6c  60f6fdd0 adrp     x0, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1dad70  001c3291 add      x0, x0, #0xc87; 0xfffffe00070a8c87 STR "so->so_rcv.sb_flags & SB_LOCK"
0xfffffe000b1dad74  61f6fdd0 adrp     x1, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1dad78  213c2391 add      x1, x1, #0x8cf; 0xfffffe00070a88cf STR "/Library/Caches/com.apple.xbs/FBE73862-C372-4A76-BC3C-8E79BBE064EA/TemporaryDirectory.14N5mt/Sources/xnu/bsd/kern/uipc_usrreq.c"
0xfffffe000b1dad7c  02508152 mov      w2, #0xa80
0xfffffe000b1dad80  14cc0a94 bl       #0xfffffe000b48ddd0; CALL 0xfffffe000b48ddd0 sz=0x34 'uipc_socket.c'
0xfffffe000b1dad84  20a32ad4 brk      #0x5519; -> 0x5519 ?
0xfffffe000b1dad88  e00308aa mov      x0, x8
0xfffffe000b1dad8c  67dd0a94 bl       #0xfffffe000b492328; CALL 0xfffffe000b492328 sz=0x44 'refcnt.c'
0xfffffe000b1dad90  803600d0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1dad94  00e02891 add      x0, x0, #0xa38; 0xfffffe000b8aca38 ?
0xfffffe000b1dad98  e10313aa mov      x1, x19
0xfffffe000b1dad9c  fd7b46a9 ldp      x29, x30, [sp, #0x60]
0xfffffe000b1dada0  f44f45a9 ldp      x20, x19, [sp, #0x50]
0xfffffe000b1dada4  f65744a9 ldp      x22, x21, [sp, #0x40]
0xfffffe000b1dada8  f85f43a9 ldp      x24, x23, [sp, #0x30]
0xfffffe000b1dadac  fa6742a9 ldp      x26, x25, [sp, #0x20]
0xfffffe000b1dadb0  fc6f41a9 ldp      x28, x27, [sp, #0x10]
0xfffffe000b1dadb4  ffc30191 add      sp, sp, #0x70
0xfffffe000b1dadb8  ff2303d5 autibsp  
0xfffffe000b1dadbc  6c29e917 b        #0xfffffe000ac2536c; -> 0xfffffe000ac2536c FUNC 0xfffffe000ac2536c
0xfffffe000b1dadc0  803600d0 adrp     x0, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1dadc4  00e02891 add      x0, x0, #0xa38; 0xfffffe000b8aca38 ?
0xfffffe000b1dadc8  e10313aa mov      x1, x19
0xfffffe000b1dadcc  6829e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1dadd0  a0ffff17 b        #0xfffffe000b1dac50; -> 0xfffffe000b1dac50 FUNC 0xfffffe000b1da6d8
