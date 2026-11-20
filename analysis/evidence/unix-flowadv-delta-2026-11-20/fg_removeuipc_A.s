0xfffffe000b185334  7f2303d5 pacibsp  
0xfffffe000b185338  ff4302d1 sub      sp, sp, #0x90
0xfffffe000b18533c  fc6f03a9 stp      x28, x27, [sp, #0x30]
0xfffffe000b185340  fa6704a9 stp      x26, x25, [sp, #0x40]
0xfffffe000b185344  f85f05a9 stp      x24, x23, [sp, #0x50]
0xfffffe000b185348  f65706a9 stp      x22, x21, [sp, #0x60]
0xfffffe000b18534c  f44f07a9 stp      x20, x19, [sp, #0x70]
0xfffffe000b185350  fd7b08a9 stp      x29, x30, [sp, #0x80]
0xfffffe000b185354  fd030291 add      x29, sp, #0x80
0xfffffe000b185358  f30300aa mov      x19, x0
0xfffffe000b18535c  6517eb97 bl       #0xfffffe000ac4b0f0; CALL 0xfffffe000ac4b0f0 sz=0x98 
0xfffffe000b185360  080c40f9 ldr      x8, [x0, #0x18]
0xfffffe000b185364  282700b4 cbz      x8, #0xfffffe000b185848
0xfffffe000b185368  e81700f9 str      x8, [sp, #0x28]
0xfffffe000b18536c  683e4079 ldrh     w8, [x19, #0x1e]
0xfffffe000b185370  88000037 tbnz     w8, #0, #0xfffffe000b185380
0xfffffe000b185374  7c820391 add      x28, x19, #0xe0
0xfffffe000b185378  76020891 add      x22, x19, #0x200
0xfffffe000b18537c  04000014 b        #0xfffffe000b18538c; -> 0xfffffe000b18538c FUNC 0xfffffe000b185334
0xfffffe000b185380  683240b9 ldr      w8, [x19, #0x30]
0xfffffe000b185384  7c1240f9 ldr      x28, [x19, #0x20]
0xfffffe000b185388  9603088b add      x22, x28, x8
0xfffffe000b18538c  680a40f9 ldr      x8, [x19, #0x10]
0xfffffe000b185390  17310091 add      x23, x8, #0xc
0xfffffe000b185394  9f0308eb cmp      x28, x8
0xfffffe000b185398  e29256fa ccmp     x23, x22, #2, ls
0xfffffe000b18539c  88270054 b.hi     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b1853a0  080140b9 ldr      w8, [x8]
0xfffffe000b1853a4  e94770b2 mov      x9, #0x3ffff0000
0xfffffe000b1853a8  89fe9ff2 movk     x9, #0xfff4
0xfffffe000b1853ac  1301098b add      x19, x8, x9
0xfffffe000b1853b0  75fe42d3 lsr      x21, x19, #2
0xfffffe000b1853b4  b47e7e93 sbfiz    x20, x21, #2, #0x20
0xfffffe000b1853b8  806bfef0 adrp     x0, #0xfffffe0007ef8000; page 0xfffffe0007ef8000
0xfffffe000b1853bc  00403091 add      x0, x0, #0xc10; 0xfffffe0007ef8c10 ?
0xfffffe000b1853c0  e10314aa mov      x1, x20
0xfffffe000b1853c4  02008052 mov      w2, #0
0xfffffe000b1853c8  030080d2 mov      x3, #0
0xfffffe000b1853cc  bb22e997 bl       #0xfffffe000abcdeb8; CALL 0xfffffe000abcdeb8 sz=0x160 
0xfffffe000b1853d0  fb0300aa mov      x27, x0
0xfffffe000b1853d4  f40700f9 str      x20, [sp, #8]
0xfffffe000b1853d8  0800148b add      x8, x0, x20; 0xfffffe0007ef8cfe ?
0xfffffe000b1853dc  100008ca eor      x16, x0, x8
0xfffffe000b1853e0  1f264af2 tst      x16, #-0x40000000000000
0xfffffe000b1853e4  40000054 b.eq     #0xfffffe000b1853ec; -> 0xfffffe000b1853ec FUNC 0xfffffe000b185334
0xfffffe000b1853e8  4814f9f2 movk     x8, #0xc8a2, lsl #48
0xfffffe000b1853ec  e81300f9 str      x8, [sp, #0x20]
0xfffffe000b1853f0  a01500b4 cbz      x0, #0xfffffe000b1856a4
0xfffffe000b1853f4  080080d2 mov      x8, #0
0xfffffe000b1853f8  98d038d5 mrs      x24, tpidr_el1
0xfffffe000b1853fc  09fb44b9 ldr      w9, [x24, #0x4f8]
0xfffffe000b185400  f41740f9 ldr      x20, [sp, #0x28]
0xfffffe000b185404  8a620391 add      x10, x20, #0xd8
0xfffffe000b185408  497de8c8 casa     x8, x9, [x10]
0xfffffe000b18540c  1f0100f1 cmp      x8, #0
0xfffffe000b185410  21220054 b.ne     #0xfffffe000b185854; -> 0xfffffe000b185854 FUNC 0xfffffe000b185334
0xfffffe000b185414  e00314aa mov      x0, x20
0xfffffe000b185418  e10315aa mov      x1, x21
0xfffffe000b18541c  d9d1fc97 bl       #0xfffffe000b0b9b80; CALL 0xfffffe000b0b9b80 sz=0xf0 
0xfffffe000b185420  60140034 cbz      w0, #0xfffffe000b1856ac
0xfffffe000b185424  f50300f9 str      x21, [sp]
0xfffffe000b185428  bf060071 cmp      w21, #1
0xfffffe000b18542c  4b140054 b.lt     #0xfffffe000b1856b4; -> 0xfffffe000b1856b4 FUNC 0xfffffe000b185334
0xfffffe000b185430  140080d2 mov      x20, #0
0xfffffe000b185434  688242d3 ubfx     x8, x19, #2, #0x1f
0xfffffe000b185438  e80f00f9 str      x8, [sp, #0x18]
0xfffffe000b18543c  f5031baa mov      x21, x27
0xfffffe000b185440  150100b4 cbz      x21, #0xfffffe000b185460
0xfffffe000b185444  e81340f9 ldr      x8, [sp, #0x20]
0xfffffe000b185448  bf0208eb cmp      x21, x8
0xfffffe000b18544c  02220054 b.hs     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b185450  e20315aa mov      x2, x21
0xfffffe000b185454  bf021beb cmp      x21, x27
0xfffffe000b185458  62000054 b.hs     #0xfffffe000b185464; -> 0xfffffe000b185464 FUNC 0xfffffe000b185334
0xfffffe000b18545c  0c010014 b        #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b185460  020080d2 mov      x2, #0
0xfffffe000b185464  e01740f9 ldr      x0, [sp, #0x28]
0xfffffe000b185468  01008052 mov      w1, #0
0xfffffe000b18546c  e4d7fc97 bl       #0xfffffe000b0bb3fc; CALL 0xfffffe000b0bb3fc sz=0x120 
0xfffffe000b185470  00170035 cbnz     w0, #0xfffffe000b185750
0xfffffe000b185474  94060091 add      x20, x20, #1
0xfffffe000b185478  b5120091 add      x21, x21, #4
0xfffffe000b18547c  e80f40f9 ldr      x8, [sp, #0x18]
0xfffffe000b185480  1f0114eb cmp      x8, x20
0xfffffe000b185484  e1fdff54 b.ne     #0xfffffe000b185440; -> 0xfffffe000b185440 FUNC 0xfffffe000b185334
0xfffffe000b185488  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b18548c  ea1740f9 ldr      x10, [sp, #0x28]
0xfffffe000b185490  49610391 add      x9, x10, #0xd8
0xfffffe000b185494  e20308aa mov      x2, x8
0xfffffe000b185498  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b18549c  5f00086b cmp      w2, w8
0xfffffe000b1854a0  811f0054 b.ne     #0xfffffe000b185890; -> 0xfffffe000b185890 FUNC 0xfffffe000b185334
0xfffffe000b1854a4  130080d2 mov      x19, #0
0xfffffe000b1854a8  19f9fdf0 adrp     x25, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1854ac  396f0991 add      x25, x25, #0x25b; 0xfffffe00070a825b STR "fg_removeuipc"
0xfffffe000b1854b0  f70b00f9 str      x23, [sp, #0x10]
0xfffffe000b1854b4  682e00d0 adrp     x8, #0xfffffe000b753000; page 0xfffffe000b753000
0xfffffe000b1854b8  08012f91 add      x8, x8, #0xbc0; 0xfffffe000b753bc0 ?
0xfffffe000b1854bc  000540a9 ldp      x0, x1, [x8]
0xfffffe000b1854c0  82009052 mov      w2, #0x8004
0xfffffe000b1854c4  5bf5ea97 bl       #0xfffffe000ac42a30; CALL 0xfffffe000ac42a30 sz=0x164 
0xfffffe000b1854c8  e80300aa mov      x8, x0
0xfffffe000b1854cc  29008052 mov      w9, #1
0xfffffe000b1854d0  090501b8 str      w9, [x8], #0x10
0xfffffe000b1854d4  f50e138b add      x21, x23, x19, lsl #3
0xfffffe000b1854d8  bf0216eb cmp      x21, x22
0xfffffe000b1854dc  821d0054 b.hs     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b1854e0  bf021ceb cmp      x21, x28
0xfffffe000b1854e4  431d0054 b.lo     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b1854e8  fa0300aa mov      x26, x0
0xfffffe000b1854ec  b10240f9 ldr      x17, [x21]
0xfffffe000b1854f0  910000b4 cbz      x17, #0xfffffe000b185500
0xfffffe000b1854f4  f00308aa mov      x16, x8
0xfffffe000b1854f8  b08ee1f2 movk     x16, #0xc75, lsl #48
0xfffffe000b1854fc  110ac1da pacda    x17, x16
0xfffffe000b185500  f7031baa mov      x23, x27
0xfffffe000b185504  090080d2 mov      x9, #0
0xfffffe000b185508  110100f9 str      x17, [x8]
0xfffffe000b18550c  b40240f9 ldr      x20, [x21]
0xfffffe000b185510  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b185514  0ac341b9 ldr      w10, [x24, #0x1c0]
0xfffffe000b185518  4a050011 add      w10, w10, #1
0xfffffe000b18551c  0ac301b9 str      w10, [x24, #0x1c0]
0xfffffe000b185520  080564b2 orr      x8, x8, #0x30000000
0xfffffe000b185524  8a420191 add      x10, x20, #0x50
0xfffffe000b185528  487de9c8 casa     x9, x8, [x10]
0xfffffe000b18552c  3f0100f1 cmp      x9, #0
0xfffffe000b185530  61090054 b.ne     #0xfffffe000b18565c; -> 0xfffffe000b18565c FUNC 0xfffffe000b185334
0xfffffe000b185534  fb0314aa mov      x27, x20
0xfffffe000b185538  68cf41b8 ldr      w8, [x27, #0x1c]!
0xfffffe000b18553c  e8010836 tbz      w8, #1, #0xfffffe000b185578
0xfffffe000b185540  80220191 add      x0, x20, #0x48
0xfffffe000b185544  213be997 bl       #0xfffffe000abd41c8; CALL 0xfffffe000abd41c8 sz=0x74 
0xfffffe000b185548  680340b9 ldr      w8, [x27]
0xfffffe000b18554c  08011e32 orr      w8, w8, #4
0xfffffe000b185550  680300b9 str      w8, [x27]
0xfffffe000b185554  85220191 add      x5, x20, #0x48
0xfffffe000b185558  e0031baa mov      x0, x27
0xfffffe000b18555c  01008052 mov      w1, #0
0xfffffe000b185560  e20319aa mov      x2, x25
0xfffffe000b185564  030080d2 mov      x3, #0
0xfffffe000b185568  040080d2 mov      x4, #0
0xfffffe000b18556c  841cfe97 bl       #0xfffffe000b10c77c; CALL 0xfffffe000b10c77c sz=0x40c 'unknown'
0xfffffe000b185570  680340b9 ldr      w8, [x27]
0xfffffe000b185574  68fe0f37 tbnz     w8, #1, #0xfffffe000b185540
0xfffffe000b185578  891a40b9 ldr      w9, [x20, #0x18]
0xfffffe000b18557c  29050071 subs     w9, w9, #1
0xfffffe000b185580  891a00b9 str      w9, [x20, #0x18]
0xfffffe000b185584  a0010054 b.eq     #0xfffffe000b1855b8; -> 0xfffffe000b1855b8 FUNC 0xfffffe000b185334
0xfffffe000b185588  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b18558c  89420191 add      x9, x20, #0x50
0xfffffe000b185590  e20308aa mov      x2, x8
0xfffffe000b185594  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b185598  5f00086b cmp      w2, w8
0xfffffe000b18559c  fb0317aa mov      x27, x23
0xfffffe000b1855a0  f70b40f9 ldr      x23, [sp, #0x10]
0xfffffe000b1855a4  20020054 b.eq     #0xfffffe000b1855e8; -> 0xfffffe000b1855e8 FUNC 0xfffffe000b185334
0xfffffe000b1855a8  80220191 add      x0, x20, #0x48
0xfffffe000b1855ac  e10318aa mov      x1, x24
0xfffffe000b1855b0  7c3ae997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b1855b4  0d000014 b        #0xfffffe000b1855e8; -> 0xfffffe000b1855e8 FUNC 0xfffffe000b185334
0xfffffe000b1855b8  08011d32 orr      w8, w8, #8
0xfffffe000b1855bc  881e00b9 str      w8, [x20, #0x1c]
0xfffffe000b1855c0  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b1855c4  89420191 add      x9, x20, #0x50
0xfffffe000b1855c8  e20308aa mov      x2, x8
0xfffffe000b1855cc  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1855d0  5f00086b cmp      w2, w8
0xfffffe000b1855d4  fb0317aa mov      x27, x23
0xfffffe000b1855d8  e1050054 b.ne     #0xfffffe000b185694; -> 0xfffffe000b185694 FUNC 0xfffffe000b185334
0xfffffe000b1855dc  a00240f9 ldr      x0, [x21]
0xfffffe000b1855e0  f3f5ff97 bl       #0xfffffe000b182dac; CALL 0xfffffe000b182dac sz=0x220 
0xfffffe000b1855e4  f70b40f9 ldr      x23, [sp, #0x10]
0xfffffe000b1855e8  080080d2 mov      x8, #0
0xfffffe000b1855ec  09fb44b9 ldr      w9, [x24, #0x4f8]
0xfffffe000b1855f0  eb1740f9 ldr      x11, [sp, #0x28]
0xfffffe000b1855f4  6a610391 add      x10, x11, #0xd8
0xfffffe000b1855f8  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1855fc  1f0100f1 cmp      x8, #0
0xfffffe000b185600  81030054 b.ne     #0xfffffe000b185670; -> 0xfffffe000b185670 FUNC 0xfffffe000b185334
0xfffffe000b185604  680b138b add      x8, x27, x19, lsl #2
0xfffffe000b185608  e91340f9 ldr      x9, [sp, #0x20]
0xfffffe000b18560c  1f0109eb cmp      x8, x9
0xfffffe000b185610  e2130054 b.hs     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b185614  1f011beb cmp      x8, x27
0xfffffe000b185618  a3130054 b.lo     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b18561c  010140b9 ldr      w1, [x8]; [0xfffffe000b753bc0] ?
0xfffffe000b185620  f41740f9 ldr      x20, [sp, #0x28]
0xfffffe000b185624  e00314aa mov      x0, x20
0xfffffe000b185628  e2031aaa mov      x2, x26
0xfffffe000b18562c  91d0fc97 bl       #0xfffffe000b0b9870; CALL 0xfffffe000b0b9870 sz=0xec 
0xfffffe000b185630  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b185634  89620391 add      x9, x20, #0xd8
0xfffffe000b185638  e20308aa mov      x2, x8
0xfffffe000b18563c  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b185640  5f00086b cmp      w2, w8
0xfffffe000b185644  01020054 b.ne     #0xfffffe000b185684; -> 0xfffffe000b185684 FUNC 0xfffffe000b185334
0xfffffe000b185648  73060091 add      x19, x19, #1
0xfffffe000b18564c  e80f40f9 ldr      x8, [sp, #0x18]
0xfffffe000b185650  7f0208eb cmp      x19, x8
0xfffffe000b185654  01f3ff54 b.ne     #0xfffffe000b1854b4; -> 0xfffffe000b1854b4 FUNC 0xfffffe000b185334
0xfffffe000b185658  1d000014 b        #0xfffffe000b1856cc; -> 0xfffffe000b1856cc FUNC 0xfffffe000b185334
0xfffffe000b18565c  80220191 add      x0, x20, #0x48
0xfffffe000b185660  e10318aa mov      x1, x24
0xfffffe000b185664  22008052 mov      w2, #1
0xfffffe000b185668  5537e997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b18566c  b2ffff17 b        #0xfffffe000b185534; -> 0xfffffe000b185534 FUNC 0xfffffe000b185334
0xfffffe000b185670  60410391 add      x0, x11, #0xd0
0xfffffe000b185674  e10318aa mov      x1, x24
0xfffffe000b185678  02008052 mov      w2, #0
0xfffffe000b18567c  5037e997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b185680  e1ffff17 b        #0xfffffe000b185604; -> 0xfffffe000b185604 FUNC 0xfffffe000b185334
0xfffffe000b185684  80420391 add      x0, x20, #0xd0
0xfffffe000b185688  e10318aa mov      x1, x24
0xfffffe000b18568c  453ae997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b185690  eeffff17 b        #0xfffffe000b185648; -> 0xfffffe000b185648 FUNC 0xfffffe000b185334
0xfffffe000b185694  80220191 add      x0, x20, #0x48
0xfffffe000b185698  e10318aa mov      x1, x24
0xfffffe000b18569c  413ae997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b1856a0  cfffff17 b        #0xfffffe000b1855dc; -> 0xfffffe000b1855dc FUNC 0xfffffe000b185334
0xfffffe000b1856a4  99018052 mov      w25, #0xc
0xfffffe000b1856a8  43000014 b        #0xfffffe000b1857b4; -> 0xfffffe000b1857b4 FUNC 0xfffffe000b185334
0xfffffe000b1856ac  00058052 mov      w0, #0x28
0xfffffe000b1856b0  3a000014 b        #0xfffffe000b185798; -> 0xfffffe000b185798 FUNC 0xfffffe000b185334
0xfffffe000b1856b4  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b1856b8  89620391 add      x9, x20, #0xd8
0xfffffe000b1856bc  e20308aa mov      x2, x8
0xfffffe000b1856c0  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1856c4  5f00086b cmp      w2, w8
0xfffffe000b1856c8  810d0054 b.ne     #0xfffffe000b185878; -> 0xfffffe000b185878 FUNC 0xfffffe000b185334
0xfffffe000b1856cc  9f0317eb cmp      x28, x23
0xfffffe000b1856d0  e80d0054 b.hi     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b1856d4  e81340f9 ldr      x8, [sp, #0x20]
0xfffffe000b1856d8  08011bcb sub      x8, x8, x27
0xfffffe000b1856dc  e90740f9 ldr      x9, [sp, #8]
0xfffffe000b1856e0  3f0108eb cmp      x9, x8
0xfffffe000b1856e4  480d0054 b.hi     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b1856e8  c80217cb sub      x8, x22, x23
0xfffffe000b1856ec  e90740f9 ldr      x9, [sp, #8]
0xfffffe000b1856f0  3f0108eb cmp      x9, x8
0xfffffe000b1856f4  c80c0054 b.hi     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b1856f8  e00317aa mov      x0, x23
0xfffffe000b1856fc  e1031baa mov      x1, x27
0xfffffe000b185700  f30740f9 ldr      x19, [sp, #8]
0xfffffe000b185704  e20313aa mov      x2, x19
0xfffffe000b185708  72e60a94 bl       #0xfffffe000b43f0d0; CALL 0xfffffe000b43f0d0 sz=0x1b0 
0xfffffe000b18570c  e002138b add      x0, x23, x19
0xfffffe000b185710  c80200eb subs     x8, x22, x0
0xfffffe000b185714  c30b0054 b.lo     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b185718  9f0300eb cmp      x28, x0
0xfffffe000b18571c  880b0054 b.hi     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b185720  e90740f9 ldr      x9, [sp, #8]
0xfffffe000b185724  3f0108eb cmp      x9, x8
0xfffffe000b185728  280b0054 b.hi     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b18572c  e10740f9 ldr      x1, [sp, #8]
0xfffffe000b185730  d4e60a94 bl       #0xfffffe000b43f280; CALL 0xfffffe000b43f280 sz=0xb0 
0xfffffe000b185734  19008052 mov      w25, #0
0xfffffe000b185738  e80340f9 ldr      x8, [sp]
0xfffffe000b18573c  e803084b neg      w8, w8
0xfffffe000b185740  693600f0 adrp     x9, #0xfffffe000b854000; page 0xfffffe000b854000
0xfffffe000b185744  29a12191 add      x9, x9, #0x868; 0xfffffe000b854868 ?
0xfffffe000b185748  280128b8 ldadd    w8, w8, [x9]
0xfffffe000b18574c  31000014 b        #0xfffffe000b185810; -> 0xfffffe000b185810 FUNC 0xfffffe000b185334
0xfffffe000b185750  140200b4 cbz      x20, #0xfffffe000b185790
0xfffffe000b185754  f90300aa mov      x25, x0
0xfffffe000b185758  b51200d1 sub      x21, x21, #4
0xfffffe000b18575c  94060091 add      x20, x20, #1
0xfffffe000b185760  e81340f9 ldr      x8, [sp, #0x20]
0xfffffe000b185764  bf0208eb cmp      x21, x8
0xfffffe000b185768  22090054 b.hs     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b18576c  bf021beb cmp      x21, x27
0xfffffe000b185770  e3080054 b.lo     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b185774  a1c65fb8 ldr      w1, [x21], #0xfffffffffffffffc
0xfffffe000b185778  e01740f9 ldr      x0, [sp, #0x28]
0xfffffe000b18577c  78d0fc97 bl       #0xfffffe000b0b995c; CALL 0xfffffe000b0b995c sz=0x174 
0xfffffe000b185780  940600d1 sub      x20, x20, #1
0xfffffe000b185784  9f0600f1 cmp      x20, #1
0xfffffe000b185788  ccfeff54 b.gt     #0xfffffe000b185760; -> 0xfffffe000b185760 FUNC 0xfffffe000b185334
0xfffffe000b18578c  e00319aa mov      x0, x25
0xfffffe000b185790  f50340f9 ldr      x21, [sp]
0xfffffe000b185794  f41740f9 ldr      x20, [sp, #0x28]
0xfffffe000b185798  f90300aa mov      x25, x0
0xfffffe000b18579c  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b1857a0  89620391 add      x9, x20, #0xd8
0xfffffe000b1857a4  e20308aa mov      x2, x8
0xfffffe000b1857a8  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1857ac  5f00086b cmp      w2, w8
0xfffffe000b1857b0  c1050054 b.ne     #0xfffffe000b185868; -> 0xfffffe000b185868 FUNC 0xfffffe000b185334
0xfffffe000b1857b4  f80315aa mov      x24, x21
0xfffffe000b1857b8  bf060071 cmp      w21, #1
0xfffffe000b1857bc  8b010054 b.lt     #0xfffffe000b1857ec; -> 0xfffffe000b1857ec FUNC 0xfffffe000b185334
0xfffffe000b1857c0  738242d3 ubfx     x19, x19, #2, #0x1f
0xfffffe000b1857c4  f40317aa mov      x20, x23
0xfffffe000b1857c8  9f0216eb cmp      x20, x22
0xfffffe000b1857cc  02060054 b.hs     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b1857d0  9f021ceb cmp      x20, x28
0xfffffe000b1857d4  c3050054 b.lo     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b1857d8  808640f8 ldr      x0, [x20], #8
0xfffffe000b1857dc  01008092 mov      x1, #-1
0xfffffe000b1857e0  0cf5ff97 bl       #0xfffffe000b182c10; CALL 0xfffffe000b182c10 sz=0x19c 'fg_removeuipc'
0xfffffe000b1857e4  730600f1 subs     x19, x19, #1
0xfffffe000b1857e8  01ffff54 b.ne     #0xfffffe000b1857c8; -> 0xfffffe000b1857c8 FUNC 0xfffffe000b185334
0xfffffe000b1857ec  9f0317eb cmp      x28, x23
0xfffffe000b1857f0  e8040054 b.hi     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b1857f4  087f60d3 lsl      x8, x24, #0x20
0xfffffe000b1857f8  01fd5d93 asr      x1, x8, #0x1d
0xfffffe000b1857fc  c80217cb sub      x8, x22, x23
0xfffffe000b185800  3f0008eb cmp      x1, x8
0xfffffe000b185804  48040054 b.hi     #0xfffffe000b18588c; -> 0xfffffe000b18588c FUNC 0xfffffe000b185334
0xfffffe000b185808  e00317aa mov      x0, x23
0xfffffe000b18580c  9de60a94 bl       #0xfffffe000b43f280; CALL 0xfffffe000b43f280 sz=0xb0 
0xfffffe000b185810  806bfef0 adrp     x0, #0xfffffe0007ef8000; page 0xfffffe0007ef8000
0xfffffe000b185814  00403091 add      x0, x0, #0xc10; 0xfffffe0007ef8c10 ?
0xfffffe000b185818  e1031baa mov      x1, x27
0xfffffe000b18581c  e20740f9 ldr      x2, [sp, #8]
0xfffffe000b185820  2523e997 bl       #0xfffffe000abce4b4; CALL 0xfffffe000abce4b4 sz=0x130 
0xfffffe000b185824  e00319aa mov      x0, x25
0xfffffe000b185828  fd7b48a9 ldp      x29, x30, [sp, #0x80]
0xfffffe000b18582c  f44f47a9 ldp      x20, x19, [sp, #0x70]
0xfffffe000b185830  f65746a9 ldp      x22, x21, [sp, #0x60]
0xfffffe000b185834  f85f45a9 ldp      x24, x23, [sp, #0x50]
0xfffffe000b185838  fa6744a9 ldp      x26, x25, [sp, #0x40]
0xfffffe000b18583c  fc6f43a9 ldp      x28, x27, [sp, #0x30]
0xfffffe000b185840  ff430291 add      sp, sp, #0x90
0xfffffe000b185844  ff0f5fd6 retab    
0xfffffe000b185848  886bfef0 adrp     x8, #0xfffffe0007ef8000; page 0xfffffe0007ef8000
0xfffffe000b18584c  085947f9 ldr      x8, [x8, #0xeb0]; [0xfffffe0007ef8eb0] ?
0xfffffe000b185850  c6feff17 b        #0xfffffe000b185368; -> 0xfffffe000b185368 FUNC 0xfffffe000b185334
0xfffffe000b185854  80420391 add      x0, x20, #0xd0
0xfffffe000b185858  e10318aa mov      x1, x24
0xfffffe000b18585c  02008052 mov      w2, #0
0xfffffe000b185860  d736e997 bl       #0xfffffe000abd33bc; CALL 0xfffffe000abd33bc sz=0x418 
0xfffffe000b185864  ecfeff17 b        #0xfffffe000b185414; -> 0xfffffe000b185414 FUNC 0xfffffe000b185334
0xfffffe000b185868  80420391 add      x0, x20, #0xd0
0xfffffe000b18586c  e10318aa mov      x1, x24
0xfffffe000b185870  cc39e997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b185874  d0ffff17 b        #0xfffffe000b1857b4; -> 0xfffffe000b1857b4 FUNC 0xfffffe000b185334
0xfffffe000b185878  80420391 add      x0, x20, #0xd0
0xfffffe000b18587c  e10318aa mov      x1, x24
0xfffffe000b185880  c839e997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b185884  9f0317eb cmp      x28, x23
0xfffffe000b185888  69f2ff54 b.ls     #0xfffffe000b1856d4; -> 0xfffffe000b1856d4 FUNC 0xfffffe000b185334
0xfffffe000b18588c  20a32ad4 brk      #0x5519; -> 0x5519 ?
0xfffffe000b185890  40410391 add      x0, x10, #0xd0
0xfffffe000b185894  e10318aa mov      x1, x24
0xfffffe000b185898  c239e997 bl       #0xfffffe000abd3fa0; CALL 0xfffffe000abd3fa0 sz=0x1a8 
0xfffffe000b18589c  02ffff17 b        #0xfffffe000b1854a4; -> 0xfffffe000b1854a4 FUNC 0xfffffe000b185334
