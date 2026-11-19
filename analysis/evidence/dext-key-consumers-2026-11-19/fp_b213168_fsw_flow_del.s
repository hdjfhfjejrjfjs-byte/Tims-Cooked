0xfffffe000b213168  7f2303d5 pacibsp  
0xfffffe000b21316c  ff4303d1 sub      sp, sp, #0xd0
0xfffffe000b213170  fc6f07a9 stp      x28, x27, [sp, #0x70]
0xfffffe000b213174  fa6708a9 stp      x26, x25, [sp, #0x80]
0xfffffe000b213178  f85f09a9 stp      x24, x23, [sp, #0x90]
0xfffffe000b21317c  f6570aa9 stp      x22, x21, [sp, #0xa0]
0xfffffe000b213180  f44f0ba9 stp      x20, x19, [sp, #0xb0]
0xfffffe000b213184  fd7b0ca9 stp      x29, x30, [sp, #0xc0]
0xfffffe000b213188  fd030391 add      x29, sp, #0xc0
0xfffffe000b21318c  fb0303aa mov      x27, x3
0xfffffe000b213190  fc0302aa mov      x28, x2
0xfffffe000b213194  f60301aa mov      x22, x1
0xfffffe000b213198  f30300aa mov      x19, x0
0xfffffe000b21319c  282900b0 adrp     x8, #0xfffffe000b738000; page 0xfffffe000b738000
0xfffffe000b2131a0  08010091 add      x8, x8, #0; 0xfffffe000b738000 ?
0xfffffe000b2131a4  080140f9 ldr      x8, [x8]; [0xfffffe000b738000] ?
0xfffffe000b2131a8  a8831af8 stur     x8, [x29, #-0x58]
0xfffffe000b2131ac  152840f9 ldr      x21, [x0, #0x50]
0xfffffe000b2131b0  1a0c40f9 ldr      x26, [x0, #0x18]
0xfffffe000b2131b4  39e040f9 ldr      x25, [x1, #0x1c0]
0xfffffe000b2131b8  37f881b9 ldrsw    x23, [x1, #0x1f8]
0xfffffe000b2131bc  384840b9 ldr      w24, [x1, #0x48]
0xfffffe000b2131c0  77b5ff97 bl       #0xfffffe000b20079c; CALL 0xfffffe000b20079c sz=0xc4 
0xfffffe000b2131c4  a00a0034 cbz      w0, #0xfffffe000b213318
0xfffffe000b2131c8  a8a648a9 ldp      x8, x9, [x21, #0x88]
0xfffffe000b2131cc  ea0ac99a udiv     x10, x23, x9
0xfffffe000b2131d0  49dd091b msub     w9, w10, w9, w23
0xfffffe000b2131d4  aa4e40f9 ldr      x10, [x21, #0x98]
0xfffffe000b2131d8  5421099b madd     x20, x10, x9, x8
0xfffffe000b2131dc  540100b4 cbz      x20, #0xfffffe000b213204
0xfffffe000b2131e0  a95240f9 ldr      x9, [x21, #0xa0]
0xfffffe000b2131e4  0a01098b add      x10, x8, x9; 0xfffffe000b7380e3 ?
0xfffffe000b2131e8  10010aca eor      x16, x8, x10
0xfffffe000b2131ec  1f264af2 tst      x16, #-0x40000000000000
0xfffffe000b2131f0  40000054 b.eq     #0xfffffe000b2131f8; -> 0xfffffe000b2131f8 FUNC 0xfffffe000b213168
0xfffffe000b2131f4  4a14f9f2 movk     x10, #0xc8a2, lsl #48
0xfffffe000b2131f8  9f020aeb cmp      x20, x10
0xfffffe000b2131fc  803248fa ccmp     x20, x8, #0, lo
0xfffffe000b213200  631d0054 b.lo     #0xfffffe000b2135ac; -> 0xfffffe000b2135ac FUNC 0xfffffe000b213168
0xfffffe000b213204  fa1b00f9 str      x26, [sp, #0x30]
0xfffffe000b213208  080080d2 mov      x8, #0
0xfffffe000b21320c  95d038d5 mrs      x21, tpidr_el1
0xfffffe000b213210  a9fa44b9 ldr      w9, [x21, #0x4f8]
0xfffffe000b213214  aac241b9 ldr      w10, [x21, #0x1c0]
0xfffffe000b213218  4a050011 add      w10, w10, #1
0xfffffe000b21321c  aac201b9 str      w10, [x21, #0x1c0]
0xfffffe000b213220  290564b2 orr      x9, x9, #0x30000000
0xfffffe000b213224  8a220091 add      x10, x20, #8
0xfffffe000b213228  497de8c8 casa     x8, x9, [x10]
0xfffffe000b21322c  1f0100f1 cmp      x8, #0
0xfffffe000b213230  c1110054 b.ne     #0xfffffe000b213468; -> 0xfffffe000b213468 FUNC 0xfffffe000b213168
0xfffffe000b213234  fc3f00b9 str      w28, [sp, #0x3c]
0xfffffe000b213238  9aa20091 add      x26, x20, #0x28
0xfffffe000b21323c  88324079 ldrh     w8, [x20, #0x18]
0xfffffe000b213240  1f050072 tst      w8, #3
0xfffffe000b213244  a0020054 b.eq     #0xfffffe000b213298; -> 0xfffffe000b213298 FUNC 0xfffffe000b213168
0xfffffe000b213248  1cf5fdb0 adrp     x28, #0xfffffe00070b4000; page 0xfffffe00070b4000
0xfffffe000b21324c  9cdf1391 add      x28, x28, #0x4f7; 0xfffffe00070b44f7 STR "fsw_flow_del"
0xfffffe000b213250  883a4079 ldrh     w8, [x20, #0x1c]
0xfffffe000b213254  09050011 add      w9, w8, #1
0xfffffe000b213258  0a090011 add      w10, w8, #2
0xfffffe000b21325c  3f011072 tst      w9, #0x10000
0xfffffe000b213260  4815881a csinc    w8, w10, w8, ne
0xfffffe000b213264  883a0079 strh     w8, [x20, #0x1c]
0xfffffe000b213268  9f021aeb cmp      x20, x26
0xfffffe000b21326c  021a0054 b.hs     #0xfffffe000b2135ac; -> 0xfffffe000b2135ac FUNC 0xfffffe000b213168
0xfffffe000b213270  80720091 add      x0, x20, #0x1c
0xfffffe000b213274  a1028152 mov      w1, #0x815
0xfffffe000b213278  e2031caa mov      x2, x28
0xfffffe000b21327c  030080d2 mov      x3, #0
0xfffffe000b213280  040080d2 mov      x4, #0
0xfffffe000b213284  e50314aa mov      x5, x20
0xfffffe000b213288  3de5fb97 bl       #0xfffffe000b10c77c; CALL 0xfffffe000b10c77c sz=0x40c 'unknown'
0xfffffe000b21328c  88324079 ldrh     w8, [x20, #0x18]
0xfffffe000b213290  1f050072 tst      w8, #3
0xfffffe000b213294  e1fdff54 b.ne     #0xfffffe000b213250; -> 0xfffffe000b213250 FUNC 0xfffffe000b213168
0xfffffe000b213298  08011f32 orr      w8, w8, #2
0xfffffe000b21329c  88320079 strh     w8, [x20, #0x18]
0xfffffe000b2132a0  9f021aeb cmp      x20, x26
0xfffffe000b2132a4  42180054 b.hs     #0xfffffe000b2135ac; -> 0xfffffe000b2135ac FUNC 0xfffffe000b213168
0xfffffe000b2132a8  032b0a53 ubfx     w3, w24, #0xa, #1
0xfffffe000b2132ac  e00314aa mov      x0, x20
0xfffffe000b2132b0  e10317aa mov      x1, x23
0xfffffe000b2132b4  e20319aa mov      x2, x25
0xfffffe000b2132b8  54100094 bl       #0xfffffe000b217408; CALL 0xfffffe000b217408 sz=0x60 
0xfffffe000b2132bc  f90300aa mov      x25, x0
0xfffffe000b2132c0  1c400291 add      x28, x0, #0x90
0xfffffe000b2132c4  800400b4 cbz      x0, #0xfffffe000b213354
0xfffffe000b2132c8  e00314aa mov      x0, x20
0xfffffe000b2132cc  bf03e797 bl       #0xfffffe000abd41c8; CALL 0xfffffe000abd41c8 sz=0x74 
0xfffffe000b2132d0  c1320191 add      x1, x22, #0x4c
0xfffffe000b2132d4  e00319aa mov      x0, x25
0xfffffe000b2132d8  64100094 bl       #0xfffffe000b217468; CALL 0xfffffe000b217468 sz=0xd4 
0xfffffe000b2132dc  e00000b4 cbz      x0, #0xfffffe000b2132f8
0xfffffe000b2132e0  e10300aa mov      x1, x0
0xfffffe000b2132e4  e00319aa mov      x0, x25
0xfffffe000b2132e8  e23f40b9 ldr      w2, [sp, #0x3c]
0xfffffe000b2132ec  e3031baa mov      x3, x27
0xfffffe000b2132f0  040080d2 mov      x4, #0
0xfffffe000b2132f4  681a0094 bl       #0xfffffe000b219c94; CALL 0xfffffe000b219c94 sz=0x2d8 'N_QUERY || disp == TB_MESSAGE_DISPOSITION_ERROR" ", " "%hhu" " (%s:%d)" @%s:%d'; 'dba_buflet[i], tmplen + buf_off) == 0'; 'en + buf_off) == 0'
0xfffffe000b2132f8  280f40f9 ldr      x8, [x25, #0x18]
0xfffffe000b2132fc  a80000b5 cbnz     x8, #0xfffffe000b213310
0xfffffe000b213300  28d34039 ldrb     w8, [x25, #0x34]
0xfffffe000b213304  68000036 tbz      w8, #0, #0xfffffe000b213310
0xfffffe000b213308  282b40f9 ldr      x8, [x25, #0x50]
0xfffffe000b21330c  c80600b4 cbz      x8, #0xfffffe000b2133e4
0xfffffe000b213310  18008052 mov      w24, #0
0xfffffe000b213314  11000014 b        #0xfffffe000b213358; -> 0xfffffe000b213358 FUNC 0xfffffe000b213168
0xfffffe000b213318  e82c00f0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b21331c  014145f9 ldr      x1, [x8, #0xa80]; [0xfffffe000b7b2a80] ?
0xfffffe000b213320  88d038d5 mrs      x8, tpidr_el1
0xfffffe000b213324  08614379 ldrh     w8, [x8, #0x1b0]; [0xfffffe000b7b21b0] ?
0xfffffe000b213328  09f5fdb0 adrp     x9, #0xfffffe00070b4000; page 0xfffffe00070b4000
0xfffffe000b21332c  29dd1391 add      x9, x9, #0x4f7; 0xfffffe00070b44f7 STR "fsw_flow_del"
0xfffffe000b213330  e82700a9 stp      x8, x9, [sp]
0xfffffe000b213334  c0effdb0 adrp     x0, #0xfffffe000700c000; page 0xfffffe000700c000
0xfffffe000b213338  00000091 add      x0, x0, #0; 0xfffffe000700c000 ?
0xfffffe000b21333c  a3f7fdf0 adrp     x3, #0xfffffe000710a000; page 0xfffffe000710a000
0xfffffe000b213340  639c1891 add      x3, x3, #0x627; 0xfffffe000710a627 ?
0xfffffe000b213344  02028052 mov      w2, #0x10
0xfffffe000b213348  0d750294 bl       #0xfffffe000b2b077c; CALL 0xfffffe000b2b077c sz=0x54 
0xfffffe000b21334c  d8008052 mov      w24, #6
0xfffffe000b213350  16000014 b        #0xfffffe000b2133a8; -> 0xfffffe000b2133a8 FUNC 0xfffffe000b213168
0xfffffe000b213354  58008052 mov      w24, #2
0xfffffe000b213358  e82c00f0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b21335c  08ed6939 ldrb     w8, [x8, #0xa7b]; [0xfffffe000b7b2a7b] ?
0xfffffe000b213360  e8082037 tbnz     w8, #4, #0xfffffe000b21347c
0xfffffe000b213364  e00314aa mov      x0, x20
0xfffffe000b213368  08ac4178 ldrh     w8, [x0, #0x1a]!; [0xfffffe000700c01a] ?
0xfffffe000b21336c  09e05f78 ldurh    w9, [x0, #-2]
0xfffffe000b213370  29791e12 and      w9, w9, #0xfffffffd
0xfffffe000b213374  09e01f78 sturh    w9, [x0, #-2]
0xfffffe000b213378  c80b0035 cbnz     w8, #0xfffffe000b2134f0
0xfffffe000b21337c  e00314aa mov      x0, x20
0xfffffe000b213380  08cc4178 ldrh     w8, [x0, #0x1c]!; [0xfffffe000700c01c] ?
0xfffffe000b213384  080c0035 cbnz     w8, #0xfffffe000b213504
0xfffffe000b213388  a8fa44b9 ldr      w8, [x21, #0x4f8]
0xfffffe000b21338c  89220091 add      x9, x20, #8
0xfffffe000b213390  e20308aa mov      x2, x8
0xfffffe000b213394  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b213398  5f00086b cmp      w2, w8
0xfffffe000b21339c  e10b0054 b.ne     #0xfffffe000b213518; -> 0xfffffe000b213518 FUNC 0xfffffe000b213168
0xfffffe000b2133a0  e00313aa mov      x0, x19
0xfffffe000b2133a4  2fb5ff97 bl       #0xfffffe000b200860; CALL 0xfffffe000b200860 sz=0xd4 
0xfffffe000b2133a8  a8835af8 ldur     x8, [x29, #-0x58]
0xfffffe000b2133ac  292900b0 adrp     x9, #0xfffffe000b738000; page 0xfffffe000b738000
0xfffffe000b2133b0  29010091 add      x9, x9, #0; 0xfffffe000b738000 ?
0xfffffe000b2133b4  290140f9 ldr      x9, [x9]; [0xfffffe000b738000] ?
0xfffffe000b2133b8  3f0108eb cmp      x9, x8
0xfffffe000b2133bc  a10f0054 b.ne     #0xfffffe000b2135b0; -> 0xfffffe000b2135b0 FUNC 0xfffffe000b213168
0xfffffe000b2133c0  e00318aa mov      x0, x24
0xfffffe000b2133c4  fd7b4ca9 ldp      x29, x30, [sp, #0xc0]
0xfffffe000b2133c8  f44f4ba9 ldp      x20, x19, [sp, #0xb0]
0xfffffe000b2133cc  f6574aa9 ldp      x22, x21, [sp, #0xa0]
0xfffffe000b2133d0  f85f49a9 ldp      x24, x23, [sp, #0x90]
0xfffffe000b2133d4  fa6748a9 ldp      x26, x25, [sp, #0x80]
0xfffffe000b2133d8  fc6f47a9 ldp      x28, x27, [sp, #0x70]
0xfffffe000b2133dc  ff430391 add      sp, sp, #0xd0
0xfffffe000b2133e0  ff0f5fd6 retab    
0xfffffe000b2133e4  ea1b40f9 ldr      x10, [sp, #0x30]
0xfffffe000b2133e8  58010491 add      x24, x10, #0x100; 0xfffffe000b7381e3 ?
0xfffffe000b2133ec  21734079 ldrh     w1, [x25, #0x38]
0xfffffe000b2133f0  a8fa44b9 ldr      w8, [x21, #0x4f8]
0xfffffe000b2133f4  89220091 add      x9, x20, #8
0xfffffe000b2133f8  e20308aa mov      x2, x8
0xfffffe000b2133fc  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b213400  5f00086b cmp      w2, w8
0xfffffe000b213404  610b0054 b.ne     #0xfffffe000b213570; -> 0xfffffe000b213570 FUNC 0xfffffe000b213168
0xfffffe000b213408  5f0118eb cmp      x10, x24
0xfffffe000b21340c  020d0054 b.hs     #0xfffffe000b2135ac; -> 0xfffffe000b2135ac FUNC 0xfffffe000b213168
0xfffffe000b213410  e01b40f9 ldr      x0, [sp, #0x30]
0xfffffe000b213414  080c40f9 ldr      x8, [x0, #0x18]; [0xfffffe000700c018] ?
0xfffffe000b213418  082140f9 ldr      x8, [x8, #0x40]; [0xfffffe000b7b2040] ?
0xfffffe000b21341c  083940f9 ldr      x8, [x8, #0x70]; [0xfffffe000b7b2070] ?
0xfffffe000b213420  088944f9 ldr      x8, [x8, #0x910]; [0xfffffe000b7b2910] ?
0xfffffe000b213424  f1188ad2 mov      x17, #0x50c7
0xfffffe000b213428  11093fd7 blraa    x8, x17
0xfffffe000b21342c  080080d2 mov      x8, #0
0xfffffe000b213430  a9fa44b9 ldr      w9, [x21, #0x4f8]
0xfffffe000b213434  8a220091 add      x10, x20, #8
0xfffffe000b213438  497de8c8 casa     x8, x9, [x10]
0xfffffe000b21343c  1f0100f1 cmp      x8, #0
0xfffffe000b213440  a10a0054 b.ne     #0xfffffe000b213594; -> 0xfffffe000b213594 FUNC 0xfffffe000b213168
0xfffffe000b213444  3f031ceb cmp      x25, x28
0xfffffe000b213448  220b0054 b.hs     #0xfffffe000b2135ac; -> 0xfffffe000b2135ac FUNC 0xfffffe000b213168
0xfffffe000b21344c  e00314aa mov      x0, x20
0xfffffe000b213450  e10319aa mov      x1, x25
0xfffffe000b213454  782b0094 bl       #0xfffffe000b21e234; CALL 0xfffffe000b21e234 sz=0x1d8 'flow_owner_free'
0xfffffe000b213458  18008052 mov      w24, #0
0xfffffe000b21345c  1c0080d2 mov      x28, #0
0xfffffe000b213460  190080d2 mov      x25, #0
0xfffffe000b213464  bdffff17 b        #0xfffffe000b213358; -> 0xfffffe000b213358 FUNC 0xfffffe000b213168
0xfffffe000b213468  e00314aa mov      x0, x20
0xfffffe000b21346c  e10315aa mov      x1, x21
0xfffffe000b213470  22008052 mov      w2, #1
0xfffffe000b213474  d2ffe697 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b213478  6fffff17 b        #0xfffffe000b213234; -> 0xfffffe000b213234 FUNC 0xfffffe000b213168
0xfffffe000b21347c  ffd305f8 stur     xzr, [sp, #0x5d]
0xfffffe000b213480  00e4006f movi     v0.2d, #0000000000000000
0xfffffe000b213484  e00302ad stp      q0, q0, [sp, #0x40]
0xfffffe000b213488  e82c00f0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b21348c  1a4145f9 ldr      x26, [x8, #0xa80]; [0xfffffe000b7b2a80] ?
0xfffffe000b213490  bb624379 ldrh     w27, [x21, #0x1b0]
0xfffffe000b213494  b90400b4 cbz      x25, #0xfffffe000b213528
0xfffffe000b213498  28430291 add      x8, x25, #0x90
0xfffffe000b21349c  1f011ceb cmp      x8, x28
0xfffffe000b2134a0  68080054 b.hi     #0xfffffe000b2135ac; -> 0xfffffe000b2135ac FUNC 0xfffffe000b213168
0xfffffe000b2134a4  37d30191 add      x23, x25, #0x74
0xfffffe000b2134a8  393340b9 ldr      w25, [x25, #0x30]
0xfffffe000b2134ac  fc030191 add      x28, sp, #0x40
0xfffffe000b2134b0  c0320191 add      x0, x22, #0x4c
0xfffffe000b2134b4  e1030191 add      x1, sp, #0x40
0xfffffe000b2134b8  6c720294 bl       #0xfffffe000b2afe68; CALL 0xfffffe000b2afe68 sz=0x90 'e IOKit root nub @%s:%d'
0xfffffe000b2134bc  fc6302a9 stp      x28, x24, [sp, #0x20]
0xfffffe000b2134c0  f76701a9 stp      x23, x25, [sp, #0x10]
0xfffffe000b2134c4  08f5fdb0 adrp     x8, #0xfffffe00070b4000; page 0xfffffe00070b4000
0xfffffe000b2134c8  08dd1391 add      x8, x8, #0x4f7; 0xfffffe00070b44f7 STR "fsw_flow_del"
0xfffffe000b2134cc  fb2300a9 stp      x27, x8, [sp]
0xfffffe000b2134d0  c0effdb0 adrp     x0, #0xfffffe000700c000; page 0xfffffe000700c000
0xfffffe000b2134d4  00000091 add      x0, x0, #0; 0xfffffe000700c000 ?
0xfffffe000b2134d8  a3f7fdf0 adrp     x3, #0xfffffe000710a000; page 0xfffffe000710a000
0xfffffe000b2134dc  63201991 add      x3, x3, #0x648; 0xfffffe000710a648 ?
0xfffffe000b2134e0  e1031aaa mov      x1, x26
0xfffffe000b2134e4  02008052 mov      w2, #0
0xfffffe000b2134e8  a5740294 bl       #0xfffffe000b2b077c; CALL 0xfffffe000b2b077c sz=0x54 
0xfffffe000b2134ec  9effff17 b        #0xfffffe000b213364; -> 0xfffffe000b213364 FUNC 0xfffffe000b213168
0xfffffe000b2134f0  1f000079 strh     wzr, [x0]
0xfffffe000b2134f4  01008052 mov      w1, #0
0xfffffe000b2134f8  02008052 mov      w2, #0
0xfffffe000b2134fc  cd91e797 bl       #0xfffffe000abf7c30; CALL 0xfffffe000abf7c30 sz=0xec 'thread_wakeup_nthreads_prim'; 'sched_prim.c'
0xfffffe000b213500  9fffff17 b        #0xfffffe000b21337c; -> 0xfffffe000b21337c FUNC 0xfffffe000b213168
0xfffffe000b213504  1f000079 strh     wzr, [x0]
0xfffffe000b213508  01008052 mov      w1, #0
0xfffffe000b21350c  02008052 mov      w2, #0
0xfffffe000b213510  c891e797 bl       #0xfffffe000abf7c30; CALL 0xfffffe000abf7c30 sz=0xec 'thread_wakeup_nthreads_prim'; 'sched_prim.c'
0xfffffe000b213514  9dffff17 b        #0xfffffe000b213388; -> 0xfffffe000b213388 FUNC 0xfffffe000b213168
0xfffffe000b213518  e00314aa mov      x0, x20
0xfffffe000b21351c  e10315aa mov      x1, x21
0xfffffe000b213520  a002e797 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b213524  9fffff17 b        #0xfffffe000b2133a0; -> 0xfffffe000b2133a0 FUNC 0xfffffe000b213168
0xfffffe000b213528  f9030191 add      x25, sp, #0x40
0xfffffe000b21352c  c0320191 add      x0, x22, #0x4c
0xfffffe000b213530  e1030191 add      x1, sp, #0x40
0xfffffe000b213534  4d720294 bl       #0xfffffe000b2afe68; CALL 0xfffffe000b2afe68 sz=0x90 'e IOKit root nub @%s:%d'
0xfffffe000b213538  e80318aa mov      x8, x24
0xfffffe000b21353c  f9a301a9 stp      x25, x8, [sp, #0x18]
0xfffffe000b213540  08f5fdb0 adrp     x8, #0xfffffe00070b4000; page 0xfffffe00070b4000
0xfffffe000b213544  08dd1391 add      x8, x8, #0x4f7; 0xfffffe00070b44f7 STR "fsw_flow_del"
0xfffffe000b213548  e8df00a9 stp      x8, x23, [sp, #8]
0xfffffe000b21354c  fb0300f9 str      x27, [sp]
0xfffffe000b213550  c0effdb0 adrp     x0, #0xfffffe000700c000; page 0xfffffe000700c000
0xfffffe000b213554  00000091 add      x0, x0, #0; 0xfffffe000700c000 ?
0xfffffe000b213558  a3f7fdf0 adrp     x3, #0xfffffe000710a000; page 0xfffffe000710a000
0xfffffe000b21355c  63d01991 add      x3, x3, #0x674; 0xfffffe000710a674 ?
0xfffffe000b213560  e1031aaa mov      x1, x26
0xfffffe000b213564  02008052 mov      w2, #0
0xfffffe000b213568  85740294 bl       #0xfffffe000b2b077c; CALL 0xfffffe000b2b077c sz=0x54 
0xfffffe000b21356c  7effff17 b        #0xfffffe000b213364; -> 0xfffffe000b213364 FUNC 0xfffffe000b213168
0xfffffe000b213570  e00314aa mov      x0, x20
0xfffffe000b213574  fa0301aa mov      x26, x1
0xfffffe000b213578  e10315aa mov      x1, x21
0xfffffe000b21357c  8902e797 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b213580  e1031aaa mov      x1, x26
0xfffffe000b213584  ea1b40f9 ldr      x10, [sp, #0x30]
0xfffffe000b213588  5f0118eb cmp      x10, x24
0xfffffe000b21358c  23f4ff54 b.lo     #0xfffffe000b213410; -> 0xfffffe000b213410 FUNC 0xfffffe000b213168
0xfffffe000b213590  07000014 b        #0xfffffe000b2135ac; -> 0xfffffe000b2135ac FUNC 0xfffffe000b213168
0xfffffe000b213594  e00314aa mov      x0, x20
0xfffffe000b213598  e10315aa mov      x1, x21
0xfffffe000b21359c  02008052 mov      w2, #0
0xfffffe000b2135a0  87ffe697 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b2135a4  3f031ceb cmp      x25, x28
0xfffffe000b2135a8  23f5ff54 b.lo     #0xfffffe000b21344c; -> 0xfffffe000b21344c FUNC 0xfffffe000b213168
0xfffffe000b2135ac  20a32ad4 brk      #0x5519; -> 0x5519 ?
0xfffffe000b2135b0  50420894 bl       #0xfffffe000b423ef0; CALL 0xfffffe000b423ef0 sz=0x2c 'stack_protector.c'
