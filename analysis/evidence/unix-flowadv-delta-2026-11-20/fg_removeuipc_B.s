0xfffffe000b1db1cc  7f2303d5 pacibsp  
0xfffffe000b1db1d0  ff8302d1 sub      sp, sp, #0xa0
0xfffffe000b1db1d4  fc6f04a9 stp      x28, x27, [sp, #0x40]
0xfffffe000b1db1d8  fa6705a9 stp      x26, x25, [sp, #0x50]
0xfffffe000b1db1dc  f85f06a9 stp      x24, x23, [sp, #0x60]
0xfffffe000b1db1e0  f65707a9 stp      x22, x21, [sp, #0x70]
0xfffffe000b1db1e4  f44f08a9 stp      x20, x19, [sp, #0x80]
0xfffffe000b1db1e8  fd7b09a9 stp      x29, x30, [sp, #0x90]
0xfffffe000b1db1ec  fd430291 add      x29, sp, #0x90
0xfffffe000b1db1f0  f30300aa mov      x19, x0
0xfffffe000b1db1f4  0a05eb97 bl       #0xfffffe000ac9c61c; CALL 0xfffffe000ac9c61c sz=0x98 
0xfffffe000b1db1f8  170c40f9 ldr      x23, [x0, #0x18]
0xfffffe000b1db1fc  d70000b4 cbz      x23, #0xfffffe000b1db214
0xfffffe000b1db200  683e4079 ldrh     w8, [x19, #0x1e]
0xfffffe000b1db204  08010037 tbnz     w8, #0, #0xfffffe000b1db224
0xfffffe000b1db208  76820391 add      x22, x19, #0xe0
0xfffffe000b1db20c  7c020891 add      x28, x19, #0x200
0xfffffe000b1db210  08000014 b        #0xfffffe000b1db230; -> 0xfffffe000b1db230 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db214  6869feb0 adrp     x8, #0xfffffe0007f08000; page 0xfffffe0007f08000
0xfffffe000b1db218  17d547f9 ldr      x23, [x8, #0xfa8]; [0xfffffe0007f08fa8] ?
0xfffffe000b1db21c  683e4079 ldrh     w8, [x19, #0x1e]
0xfffffe000b1db220  48ff0736 tbz      w8, #0, #0xfffffe000b1db208
0xfffffe000b1db224  683240b9 ldr      w8, [x19, #0x30]
0xfffffe000b1db228  761240f9 ldr      x22, [x19, #0x20]
0xfffffe000b1db22c  dc02088b add      x28, x22, x8
0xfffffe000b1db230  730a40f9 ldr      x19, [x19, #0x10]
0xfffffe000b1db234  68320091 add      x8, x19, #0xc
0xfffffe000b1db238  df0213eb cmp      x22, x19
0xfffffe000b1db23c  e81b00f9 str      x8, [sp, #0x30]
0xfffffe000b1db240  02915cfa ccmp     x8, x28, #2, ls
0xfffffe000b1db244  28230054 b.hi     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db248  680240b9 ldr      w8, [x19]
0xfffffe000b1db24c  e94770b2 mov      x9, #0x3ffff0000
0xfffffe000b1db250  89fe9ff2 movk     x9, #0xfff4
0xfffffe000b1db254  1a01098b add      x26, x8, x9; 0xfffffe0007f080e3 ?
0xfffffe000b1db258  55ff42d3 lsr      x21, x26, #2
0xfffffe000b1db25c  b47e7e93 sbfiz    x20, x21, #2, #0x20
0xfffffe000b1db260  6069feb0 adrp     x0, #0xfffffe0007f08000; page 0xfffffe0007f08000
0xfffffe000b1db264  00203491 add      x0, x0, #0xd08; 0xfffffe0007f08d08 ?
0xfffffe000b1db268  e10314aa mov      x1, x20
0xfffffe000b1db26c  02008052 mov      w2, #0
0xfffffe000b1db270  030080d2 mov      x3, #0
0xfffffe000b1db274  0410e997 bl       #0xfffffe000ac1f284; CALL 0xfffffe000ac1f284 sz=0x160 
0xfffffe000b1db278  fb0300aa mov      x27, x0
0xfffffe000b1db27c  f40b00f9 str      x20, [sp, #0x10]
0xfffffe000b1db280  0800148b add      x8, x0, x20; 0xfffffe0007f08df6 ?
0xfffffe000b1db284  100008ca eor      x16, x0, x8
0xfffffe000b1db288  1f264af2 tst      x16, #-0x40000000000000
0xfffffe000b1db28c  40000054 b.eq     #0xfffffe000b1db294; -> 0xfffffe000b1db294 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db290  4814f9f2 movk     x8, #0xc8a2, lsl #48
0xfffffe000b1db294  e81f00f9 str      x8, [sp, #0x38]
0xfffffe000b1db298  401700b4 cbz      x0, #0xfffffe000b1db580
0xfffffe000b1db29c  080080d2 mov      x8, #0
0xfffffe000b1db2a0  98d038d5 mrs      x24, tpidr_el1
0xfffffe000b1db2a4  09fb44b9 ldr      w9, [x24, #0x4f8]
0xfffffe000b1db2a8  ea620391 add      x10, x23, #0xd8
0xfffffe000b1db2ac  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1db2b0  1f0100f1 cmp      x8, #0
0xfffffe000b1db2b4  c1250054 b.ne     #0xfffffe000b1db76c; -> 0xfffffe000b1db76c FUNC 0xfffffe000b1db1cc
0xfffffe000b1db2b8  e00317aa mov      x0, x23
0xfffffe000b1db2bc  e10315aa mov      x1, x21
0xfffffe000b1db2c0  2fd0fc97 bl       #0xfffffe000b10f37c; CALL 0xfffffe000b10f37c sz=0xf0 
0xfffffe000b1db2c4  20160034 cbz      w0, #0xfffffe000b1db588
0xfffffe000b1db2c8  f50700f9 str      x21, [sp, #8]
0xfffffe000b1db2cc  bf060071 cmp      w21, #1
0xfffffe000b1db2d0  0b1d0054 b.lt     #0xfffffe000b1db670; -> 0xfffffe000b1db670 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db2d4  140080d2 mov      x20, #0
0xfffffe000b1db2d8  488342d3 ubfx     x8, x26, #2, #0x1f
0xfffffe000b1db2dc  e81700f9 str      x8, [sp, #0x28]
0xfffffe000b1db2e0  f5031baa mov      x21, x27
0xfffffe000b1db2e4  150100b4 cbz      x21, #0xfffffe000b1db304
0xfffffe000b1db2e8  e81f40f9 ldr      x8, [sp, #0x38]
0xfffffe000b1db2ec  bf0208eb cmp      x21, x8
0xfffffe000b1db2f0  c21d0054 b.hs     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db2f4  e20315aa mov      x2, x21
0xfffffe000b1db2f8  bf021beb cmp      x21, x27
0xfffffe000b1db2fc  62000054 b.hs     #0xfffffe000b1db308; -> 0xfffffe000b1db308 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db300  ea000014 b        #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db304  020080d2 mov      x2, #0
0xfffffe000b1db308  e00317aa mov      x0, x23
0xfffffe000b1db30c  01008052 mov      w1, #0
0xfffffe000b1db310  3ad6fc97 bl       #0xfffffe000b110bf8; CALL 0xfffffe000b110bf8 sz=0x120 
0xfffffe000b1db314  c01c0035 cbnz     w0, #0xfffffe000b1db6ac
0xfffffe000b1db318  94060091 add      x20, x20, #1
0xfffffe000b1db31c  b5120091 add      x21, x21, #4
0xfffffe000b1db320  e81740f9 ldr      x8, [sp, #0x28]
0xfffffe000b1db324  1f0114eb cmp      x8, x20
0xfffffe000b1db328  e1fdff54 b.ne     #0xfffffe000b1db2e4; -> 0xfffffe000b1db2e4 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db32c  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b1db330  e9620391 add      x9, x23, #0xd8
0xfffffe000b1db334  e20308aa mov      x2, x8
0xfffffe000b1db338  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1db33c  5f00086b cmp      w2, w8
0xfffffe000b1db340  01230054 b.ne     #0xfffffe000b1db7a0; -> 0xfffffe000b1db7a0 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db344  130080d2 mov      x19, #0
0xfffffe000b1db348  79f6fdb0 adrp     x25, #0xfffffe00070a8000; page 0xfffffe00070a8000
0xfffffe000b1db34c  39e73191 add      x25, x25, #0xc79; 0xfffffe00070a8c79 STR "fg_removeuipc"
0xfffffe000b1db350  f7ef01a9 stp      x23, x27, [sp, #0x18]
0xfffffe000b1db354  882e0090 adrp     x8, #0xfffffe000b7ab000; page 0xfffffe000b7ab000
0xfffffe000b1db358  08013291 add      x8, x8, #0xc80; 0xfffffe000b7abc80 ?
0xfffffe000b1db35c  000540a9 ldp      x0, x1, [x8]
0xfffffe000b1db360  82009052 mov      w2, #0x8004
0xfffffe000b1db364  fee2ea97 bl       #0xfffffe000ac93f5c; CALL 0xfffffe000ac93f5c sz=0x164 
0xfffffe000b1db368  e80300aa mov      x8, x0
0xfffffe000b1db36c  29008052 mov      w9, #1
0xfffffe000b1db370  090501b8 str      w9, [x8], #0x10
0xfffffe000b1db374  e91b40f9 ldr      x9, [sp, #0x30]
0xfffffe000b1db378  340d138b add      x20, x9, x19, lsl #3
0xfffffe000b1db37c  9f021ceb cmp      x20, x28
0xfffffe000b1db380  42190054 b.hs     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db384  9f0216eb cmp      x20, x22
0xfffffe000b1db388  03190054 b.lo     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db38c  fa0300aa mov      x26, x0
0xfffffe000b1db390  900240f9 ldr      x16, [x20]
0xfffffe000b1db394  f50314aa mov      x21, x20
0xfffffe000b1db398  1593fdf2 movk     x21, #0xec98, lsl #48
0xfffffe000b1db39c  b00000b4 cbz      x16, #0xfffffe000b1db3b0
0xfffffe000b1db3a0  f10308aa mov      x17, x8
0xfffffe000b1db3a4  b01ac1da autda    x16, x21
0xfffffe000b1db3a8  b18ee1f2 movk     x17, #0xc75, lsl #48
0xfffffe000b1db3ac  300ac1da pacda    x16, x17
0xfffffe000b1db3b0  100100f9 str      x16, [x8]
0xfffffe000b1db3b4  900240f9 ldr      x16, [x20]
0xfffffe000b1db3b8  b00000b4 cbz      x16, #0xfffffe000b1db3cc
0xfffffe000b1db3bc  f10315aa mov      x17, x21
0xfffffe000b1db3c0  301ac1da autda    x16, x17
0xfffffe000b1db3c4  fb0310aa mov      x27, x16
0xfffffe000b1db3c8  02000014 b        #0xfffffe000b1db3d0; -> 0xfffffe000b1db3d0 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db3cc  1b0080d2 mov      x27, #0
0xfffffe000b1db3d0  f7031caa mov      x23, x28
0xfffffe000b1db3d4  080080d2 mov      x8, #0
0xfffffe000b1db3d8  09fb44b9 ldr      w9, [x24, #0x4f8]
0xfffffe000b1db3dc  0ac341b9 ldr      w10, [x24, #0x1c0]
0xfffffe000b1db3e0  4a050011 add      w10, w10, #1
0xfffffe000b1db3e4  0ac301b9 str      w10, [x24, #0x1c0]
0xfffffe000b1db3e8  290564b2 orr      x9, x9, #0x30000000
0xfffffe000b1db3ec  6a430191 add      x10, x27, #0x50
0xfffffe000b1db3f0  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1db3f4  1f0100f1 cmp      x8, #0
0xfffffe000b1db3f8  010a0054 b.ne     #0xfffffe000b1db538; -> 0xfffffe000b1db538 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db3fc  fc031baa mov      x28, x27
0xfffffe000b1db400  88cf41b8 ldr      w8, [x28, #0x1c]!
0xfffffe000b1db404  e8010836 tbz      w8, #1, #0xfffffe000b1db440
0xfffffe000b1db408  60230191 add      x0, x27, #0x48
0xfffffe000b1db40c  6228e997 bl       #0xfffffe000ac25594; CALL 0xfffffe000ac25594 sz=0x74 
0xfffffe000b1db410  880340b9 ldr      w8, [x28]
0xfffffe000b1db414  08011e32 orr      w8, w8, #4
0xfffffe000b1db418  880300b9 str      w8, [x28]
0xfffffe000b1db41c  65230191 add      x5, x27, #0x48
0xfffffe000b1db420  e0031caa mov      x0, x28
0xfffffe000b1db424  01008052 mov      w1, #0
0xfffffe000b1db428  e20319aa mov      x2, x25
0xfffffe000b1db42c  030080d2 mov      x3, #0
0xfffffe000b1db430  040080d2 mov      x4, #0
0xfffffe000b1db434  351bfe97 bl       #0xfffffe000b162108; CALL 0xfffffe000b162108 sz=0x40c 'unknown'
0xfffffe000b1db438  880340b9 ldr      w8, [x28]
0xfffffe000b1db43c  68fe0f37 tbnz     w8, #1, #0xfffffe000b1db408
0xfffffe000b1db440  691b40b9 ldr      w9, [x27, #0x18]
0xfffffe000b1db444  29050071 subs     w9, w9, #1
0xfffffe000b1db448  691b00b9 str      w9, [x27, #0x18]
0xfffffe000b1db44c  a0010054 b.eq     #0xfffffe000b1db480; -> 0xfffffe000b1db480 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db450  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b1db454  69430191 add      x9, x27, #0x50
0xfffffe000b1db458  e20308aa mov      x2, x8
0xfffffe000b1db45c  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1db460  5f00086b cmp      w2, w8
0xfffffe000b1db464  fc0317aa mov      x28, x23
0xfffffe000b1db468  f40f40f9 ldr      x20, [sp, #0x18]
0xfffffe000b1db46c  e0020054 b.eq     #0xfffffe000b1db4c8; -> 0xfffffe000b1db4c8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db470  60230191 add      x0, x27, #0x48
0xfffffe000b1db474  e10318aa mov      x1, x24
0xfffffe000b1db478  bd27e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1db47c  13000014 b        #0xfffffe000b1db4c8; -> 0xfffffe000b1db4c8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db480  08011d32 orr      w8, w8, #8
0xfffffe000b1db484  681f00b9 str      w8, [x27, #0x1c]
0xfffffe000b1db488  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b1db48c  69430191 add      x9, x27, #0x50
0xfffffe000b1db490  e20308aa mov      x2, x8
0xfffffe000b1db494  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1db498  5f00086b cmp      w2, w8
0xfffffe000b1db49c  fc0317aa mov      x28, x23
0xfffffe000b1db4a0  81060054 b.ne     #0xfffffe000b1db570; -> 0xfffffe000b1db570 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db4a4  900240f9 ldr      x16, [x20]
0xfffffe000b1db4a8  f40f40f9 ldr      x20, [sp, #0x18]
0xfffffe000b1db4ac  b00000b4 cbz      x16, #0xfffffe000b1db4c0
0xfffffe000b1db4b0  f10315aa mov      x17, x21
0xfffffe000b1db4b4  301ac1da autda    x16, x17
0xfffffe000b1db4b8  e00310aa mov      x0, x16
0xfffffe000b1db4bc  02000014 b        #0xfffffe000b1db4c4; -> 0xfffffe000b1db4c4 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db4c0  000080d2 mov      x0, #0
0xfffffe000b1db4c4  dbf5ff97 bl       #0xfffffe000b1d8c30; CALL 0xfffffe000b1d8c30 sz=0x220 
0xfffffe000b1db4c8  080080d2 mov      x8, #0
0xfffffe000b1db4cc  09fb44b9 ldr      w9, [x24, #0x4f8]
0xfffffe000b1db4d0  8a620391 add      x10, x20, #0xd8
0xfffffe000b1db4d4  497de8c8 casa     x8, x9, [x10]
0xfffffe000b1db4d8  1f0100f1 cmp      x8, #0
0xfffffe000b1db4dc  81030054 b.ne     #0xfffffe000b1db54c; -> 0xfffffe000b1db54c FUNC 0xfffffe000b1db1cc
0xfffffe000b1db4e0  fb1340f9 ldr      x27, [sp, #0x20]
0xfffffe000b1db4e4  680b138b add      x8, x27, x19, lsl #2
0xfffffe000b1db4e8  e91f40f9 ldr      x9, [sp, #0x38]
0xfffffe000b1db4ec  1f0109eb cmp      x8, x9
0xfffffe000b1db4f0  c20d0054 b.hs     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db4f4  1f011beb cmp      x8, x27
0xfffffe000b1db4f8  830d0054 b.lo     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db4fc  010140b9 ldr      w1, [x8]; [0xfffffe000b7abc80] ?
0xfffffe000b1db500  e00314aa mov      x0, x20
0xfffffe000b1db504  e2031aaa mov      x2, x26
0xfffffe000b1db508  d9cefc97 bl       #0xfffffe000b10f06c; CALL 0xfffffe000b10f06c sz=0xec 
0xfffffe000b1db50c  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b1db510  89620391 add      x9, x20, #0xd8
0xfffffe000b1db514  e20308aa mov      x2, x8
0xfffffe000b1db518  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1db51c  5f00086b cmp      w2, w8
0xfffffe000b1db520  01020054 b.ne     #0xfffffe000b1db560; -> 0xfffffe000b1db560 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db524  73060091 add      x19, x19, #1
0xfffffe000b1db528  e81740f9 ldr      x8, [sp, #0x28]
0xfffffe000b1db52c  7f0208eb cmp      x19, x8
0xfffffe000b1db530  21f1ff54 b.ne     #0xfffffe000b1db354; -> 0xfffffe000b1db354 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db534  55000014 b        #0xfffffe000b1db688; -> 0xfffffe000b1db688 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db538  60230191 add      x0, x27, #0x48
0xfffffe000b1db53c  e10318aa mov      x1, x24
0xfffffe000b1db540  22008052 mov      w2, #1
0xfffffe000b1db544  9124e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1db548  adffff17 b        #0xfffffe000b1db3fc; -> 0xfffffe000b1db3fc FUNC 0xfffffe000b1db1cc
0xfffffe000b1db54c  80420391 add      x0, x20, #0xd0
0xfffffe000b1db550  e10318aa mov      x1, x24
0xfffffe000b1db554  02008052 mov      w2, #0
0xfffffe000b1db558  8c24e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1db55c  e1ffff17 b        #0xfffffe000b1db4e0; -> 0xfffffe000b1db4e0 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db560  80420391 add      x0, x20, #0xd0
0xfffffe000b1db564  e10318aa mov      x1, x24
0xfffffe000b1db568  8127e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1db56c  eeffff17 b        #0xfffffe000b1db524; -> 0xfffffe000b1db524 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db570  60230191 add      x0, x27, #0x48
0xfffffe000b1db574  e10318aa mov      x1, x24
0xfffffe000b1db578  7d27e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1db57c  caffff17 b        #0xfffffe000b1db4a4; -> 0xfffffe000b1db4a4 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db580  99018052 mov      w25, #0xc
0xfffffe000b1db584  09000014 b        #0xfffffe000b1db5a8; -> 0xfffffe000b1db5a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db588  00058052 mov      w0, #0x28
0xfffffe000b1db58c  f90300aa mov      x25, x0
0xfffffe000b1db590  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b1db594  e9620391 add      x9, x23, #0xd8
0xfffffe000b1db598  e20308aa mov      x2, x8
0xfffffe000b1db59c  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1db5a0  5f00086b cmp      w2, w8
0xfffffe000b1db5a4  e10e0054 b.ne     #0xfffffe000b1db780; -> 0xfffffe000b1db780 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db5a8  f80315aa mov      x24, x21
0xfffffe000b1db5ac  bf060071 cmp      w21, #1
0xfffffe000b1db5b0  eb020054 b.lt     #0xfffffe000b1db60c; -> 0xfffffe000b1db60c FUNC 0xfffffe000b1db1cc
0xfffffe000b1db5b4  548342d3 ubfx     x20, x26, #2, #0x1f
0xfffffe000b1db5b8  77320091 add      x23, x19, #0xc
0xfffffe000b1db5bc  f31b40f9 ldr      x19, [sp, #0x30]
0xfffffe000b1db5c0  0b000014 b        #0xfffffe000b1db5ec; -> 0xfffffe000b1db5ec FUNC 0xfffffe000b1db1cc
0xfffffe000b1db5c4  f10317aa mov      x17, x23
0xfffffe000b1db5c8  1193fdf2 movk     x17, #0xec98, lsl #48
0xfffffe000b1db5cc  301ac1da autda    x16, x17
0xfffffe000b1db5d0  e00310aa mov      x0, x16
0xfffffe000b1db5d4  01008092 mov      x1, #-1
0xfffffe000b1db5d8  2ff5ff97 bl       #0xfffffe000b1d8a94; CALL 0xfffffe000b1d8a94 sz=0x19c 'fg_removeuipc'
0xfffffe000b1db5dc  73220091 add      x19, x19, #8
0xfffffe000b1db5e0  f7220091 add      x23, x23, #8
0xfffffe000b1db5e4  940600f1 subs     x20, x20, #1
0xfffffe000b1db5e8  20010054 b.eq     #0xfffffe000b1db60c; -> 0xfffffe000b1db60c FUNC 0xfffffe000b1db1cc
0xfffffe000b1db5ec  7f021ceb cmp      x19, x28
0xfffffe000b1db5f0  c2050054 b.hs     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db5f4  7f0216eb cmp      x19, x22
0xfffffe000b1db5f8  83050054 b.lo     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db5fc  700240f9 ldr      x16, [x19]
0xfffffe000b1db600  30feffb5 cbnz     x16, #0xfffffe000b1db5c4
0xfffffe000b1db604  000080d2 mov      x0, #0
0xfffffe000b1db608  f3ffff17 b        #0xfffffe000b1db5d4; -> 0xfffffe000b1db5d4 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db60c  e81b40f9 ldr      x8, [sp, #0x30]
0xfffffe000b1db610  df0208eb cmp      x22, x8
0xfffffe000b1db614  a8040054 b.hi     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db618  087f60d3 lsl      x8, x24, #0x20
0xfffffe000b1db61c  01fd5d93 asr      x1, x8, #0x1d
0xfffffe000b1db620  e81b40f9 ldr      x8, [sp, #0x30]
0xfffffe000b1db624  880308cb sub      x8, x28, x8
0xfffffe000b1db628  3f0008eb cmp      x1, x8
0xfffffe000b1db62c  e8030054 b.hi     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db630  e01b40f9 ldr      x0, [sp, #0x30]
0xfffffe000b1db634  dbeb0a94 bl       #0xfffffe000b4965a0; CALL 0xfffffe000b4965a0 sz=0xb0 
0xfffffe000b1db638  6069feb0 adrp     x0, #0xfffffe0007f08000; page 0xfffffe0007f08000
0xfffffe000b1db63c  00203491 add      x0, x0, #0xd08; 0xfffffe0007f08d08 ?
0xfffffe000b1db640  e1031baa mov      x1, x27
0xfffffe000b1db644  e20b40f9 ldr      x2, [sp, #0x10]
0xfffffe000b1db648  8e10e997 bl       #0xfffffe000ac1f880; CALL 0xfffffe000ac1f880 sz=0x130 
0xfffffe000b1db64c  e00319aa mov      x0, x25
0xfffffe000b1db650  fd7b49a9 ldp      x29, x30, [sp, #0x90]
0xfffffe000b1db654  f44f48a9 ldp      x20, x19, [sp, #0x80]
0xfffffe000b1db658  f65747a9 ldp      x22, x21, [sp, #0x70]
0xfffffe000b1db65c  f85f46a9 ldp      x24, x23, [sp, #0x60]
0xfffffe000b1db660  fa6745a9 ldp      x26, x25, [sp, #0x50]
0xfffffe000b1db664  fc6f44a9 ldp      x28, x27, [sp, #0x40]
0xfffffe000b1db668  ff830291 add      sp, sp, #0xa0
0xfffffe000b1db66c  ff0f5fd6 retab    
0xfffffe000b1db670  08fb44b9 ldr      w8, [x24, #0x4f8]
0xfffffe000b1db674  e9620391 add      x9, x23, #0xd8
0xfffffe000b1db678  e20308aa mov      x2, x8
0xfffffe000b1db67c  3ffda288 casl     w2, wzr, [x9]
0xfffffe000b1db680  5f00086b cmp      w2, w8
0xfffffe000b1db684  61080054 b.ne     #0xfffffe000b1db790; -> 0xfffffe000b1db790 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db688  e81b40f9 ldr      x8, [sp, #0x30]
0xfffffe000b1db68c  df0208eb cmp      x22, x8
0xfffffe000b1db690  c8000054 b.hi     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db694  e81f40f9 ldr      x8, [sp, #0x38]
0xfffffe000b1db698  08011bcb sub      x8, x8, x27
0xfffffe000b1db69c  e90b40f9 ldr      x9, [sp, #0x10]
0xfffffe000b1db6a0  3f0108eb cmp      x9, x8
0xfffffe000b1db6a4  89020054 b.ls     #0xfffffe000b1db6f4; -> 0xfffffe000b1db6f4 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db6a8  20a32ad4 brk      #0x5519; -> 0x5519 ?
0xfffffe000b1db6ac  d40500b4 cbz      x20, #0xfffffe000b1db764
0xfffffe000b1db6b0  f90300aa mov      x25, x0
0xfffffe000b1db6b4  b51200d1 sub      x21, x21, #4
0xfffffe000b1db6b8  94060091 add      x20, x20, #1
0xfffffe000b1db6bc  e81f40f9 ldr      x8, [sp, #0x38]
0xfffffe000b1db6c0  bf0208eb cmp      x21, x8
0xfffffe000b1db6c4  22ffff54 b.hs     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db6c8  bf021beb cmp      x21, x27
0xfffffe000b1db6cc  e3feff54 b.lo     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db6d0  a1c65fb8 ldr      w1, [x21], #0xfffffffffffffffc
0xfffffe000b1db6d4  e00317aa mov      x0, x23
0xfffffe000b1db6d8  a0cefc97 bl       #0xfffffe000b10f158; CALL 0xfffffe000b10f158 sz=0x174 
0xfffffe000b1db6dc  940600d1 sub      x20, x20, #1
0xfffffe000b1db6e0  9f0600f1 cmp      x20, #1
0xfffffe000b1db6e4  ccfeff54 b.gt     #0xfffffe000b1db6bc; -> 0xfffffe000b1db6bc FUNC 0xfffffe000b1db1cc
0xfffffe000b1db6e8  e00319aa mov      x0, x25
0xfffffe000b1db6ec  f50740f9 ldr      x21, [sp, #8]
0xfffffe000b1db6f0  a7ffff17 b        #0xfffffe000b1db58c; -> 0xfffffe000b1db58c FUNC 0xfffffe000b1db1cc
0xfffffe000b1db6f4  e81b40f9 ldr      x8, [sp, #0x30]
0xfffffe000b1db6f8  880308cb sub      x8, x28, x8
0xfffffe000b1db6fc  e90b40f9 ldr      x9, [sp, #0x10]
0xfffffe000b1db700  3f0108eb cmp      x9, x8
0xfffffe000b1db704  28fdff54 b.hi     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db708  f41b40f9 ldr      x20, [sp, #0x30]
0xfffffe000b1db70c  e00314aa mov      x0, x20
0xfffffe000b1db710  e1031baa mov      x1, x27
0xfffffe000b1db714  f30b40f9 ldr      x19, [sp, #0x10]
0xfffffe000b1db718  e20313aa mov      x2, x19
0xfffffe000b1db71c  35eb0a94 bl       #0xfffffe000b4963f0; CALL 0xfffffe000b4963f0 sz=0x1b0 
0xfffffe000b1db720  8002138b add      x0, x20, x19
0xfffffe000b1db724  880300eb subs     x8, x28, x0
0xfffffe000b1db728  03fcff54 b.lo     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db72c  df0200eb cmp      x22, x0
0xfffffe000b1db730  c8fbff54 b.hi     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db734  e90b40f9 ldr      x9, [sp, #0x10]
0xfffffe000b1db738  3f0108eb cmp      x9, x8
0xfffffe000b1db73c  68fbff54 b.hi     #0xfffffe000b1db6a8; -> 0xfffffe000b1db6a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db740  e10b40f9 ldr      x1, [sp, #0x10]
0xfffffe000b1db744  97eb0a94 bl       #0xfffffe000b4965a0; CALL 0xfffffe000b4965a0 sz=0xb0 
0xfffffe000b1db748  19008052 mov      w25, #0
0xfffffe000b1db74c  e80740f9 ldr      x8, [sp, #8]
0xfffffe000b1db750  e803084b neg      w8, w8
0xfffffe000b1db754  893600b0 adrp     x9, #0xfffffe000b8ac000; page 0xfffffe000b8ac000
0xfffffe000b1db758  29212991 add      x9, x9, #0xa48; 0xfffffe000b8aca48 ?
0xfffffe000b1db75c  280128b8 ldadd    w8, w8, [x9]
0xfffffe000b1db760  b6ffff17 b        #0xfffffe000b1db638; -> 0xfffffe000b1db638 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db764  f50740f9 ldr      x21, [sp, #8]
0xfffffe000b1db768  89ffff17 b        #0xfffffe000b1db58c; -> 0xfffffe000b1db58c FUNC 0xfffffe000b1db1cc
0xfffffe000b1db76c  e0420391 add      x0, x23, #0xd0
0xfffffe000b1db770  e10318aa mov      x1, x24
0xfffffe000b1db774  02008052 mov      w2, #0
0xfffffe000b1db778  0424e997 bl       #0xfffffe000ac24788; CALL 0xfffffe000ac24788 sz=0x418 
0xfffffe000b1db77c  cffeff17 b        #0xfffffe000b1db2b8; -> 0xfffffe000b1db2b8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db780  e0420391 add      x0, x23, #0xd0
0xfffffe000b1db784  e10318aa mov      x1, x24
0xfffffe000b1db788  f926e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1db78c  87ffff17 b        #0xfffffe000b1db5a8; -> 0xfffffe000b1db5a8 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db790  e0420391 add      x0, x23, #0xd0
0xfffffe000b1db794  e10318aa mov      x1, x24
0xfffffe000b1db798  f526e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1db79c  bbffff17 b        #0xfffffe000b1db688; -> 0xfffffe000b1db688 FUNC 0xfffffe000b1db1cc
0xfffffe000b1db7a0  e0420391 add      x0, x23, #0xd0
0xfffffe000b1db7a4  e10318aa mov      x1, x24
0xfffffe000b1db7a8  f126e997 bl       #0xfffffe000ac2536c; CALL 0xfffffe000ac2536c sz=0x1a8 
0xfffffe000b1db7ac  e6feff17 b        #0xfffffe000b1db344; -> 0xfffffe000b1db344 FUNC 0xfffffe000b1db1cc
