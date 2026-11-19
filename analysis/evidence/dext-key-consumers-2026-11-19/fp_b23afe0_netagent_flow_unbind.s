0xfffffe000b23afe0  7f2303d5 pacibsp  
0xfffffe000b23afe4  ff0301d1 sub      sp, sp, #0x40
0xfffffe000b23afe8  f44f02a9 stp      x20, x19, [sp, #0x20]
0xfffffe000b23afec  fd7b03a9 stp      x29, x30, [sp, #0x30]
0xfffffe000b23aff0  fdc30091 add      x29, sp, #0x30
0xfffffe000b23aff4  28204139 ldrb     w8, [x1, #0x48]
0xfffffe000b23aff8  48032837 tbnz     w8, #5, #0xfffffe000b23b060
0xfffffe000b23affc  000840f9 ldr      x0, [x0, #0x10]
0xfffffe000b23b000  080c40f9 ldr      x8, [x0, #0x18]
0xfffffe000b23b004  082140f9 ldr      x8, [x8, #0x40]
0xfffffe000b23b008  083940f9 ldr      x8, [x8, #0x70]
0xfffffe000b23b00c  088944f9 ldr      x8, [x8, #0x910]
0xfffffe000b23b010  21004079 ldrh     w1, [x1]
0xfffffe000b23b014  f1188ad2 mov      x17, #0x50c7
0xfffffe000b23b018  11093fd7 blraa    x8, x17
0xfffffe000b23b01c  f30300aa mov      x19, x0
0xfffffe000b23b020  20020034 cbz      w0, #0xfffffe000b23b064
0xfffffe000b23b024  a82b00f0 adrp     x8, #0xfffffe000b7b2000; page 0xfffffe000b7b2000
0xfffffe000b23b028  014145f9 ldr      x1, [x8, #0xa80]; [0xfffffe000b7b2a80] ?
0xfffffe000b23b02c  88d038d5 mrs      x8, tpidr_el1
0xfffffe000b23b030  08614379 ldrh     w8, [x8, #0x1b0]; [0xfffffe000b7b21b0] ?
0xfffffe000b23b034  c9f3fdf0 adrp     x9, #0xfffffe00070b6000; page 0xfffffe00070b6000
0xfffffe000b23b038  29113491 add      x9, x9, #0xd04; 0xfffffe00070b6d04 STR "nx_netif_netagent_flow_unbind"
0xfffffe000b23b03c  e9cf00a9 stp      x9, x19, [sp, #8]
0xfffffe000b23b040  e80300f9 str      x8, [sp]
0xfffffe000b23b044  80eefdb0 adrp     x0, #0xfffffe000700c000; page 0xfffffe000700c000
0xfffffe000b23b048  00000091 add      x0, x0, #0; 0xfffffe000700c000 ?
0xfffffe000b23b04c  83f6fdf0 adrp     x3, #0xfffffe000710e000; page 0xfffffe000710e000
0xfffffe000b23b050  63043d91 add      x3, x3, #0xf41; 0xfffffe000710ef41 ?
0xfffffe000b23b054  02028052 mov      w2, #0x10
0xfffffe000b23b058  c9d50194 bl       #0xfffffe000b2b077c; CALL 0xfffffe000b2b077c sz=0x54 
0xfffffe000b23b05c  02000014 b        #0xfffffe000b23b064; -> 0xfffffe000b23b064 FUNC 0xfffffe000b23afe0
0xfffffe000b23b060  b3058052 mov      w19, #0x2d
0xfffffe000b23b064  e00313aa mov      x0, x19
0xfffffe000b23b068  fd7b43a9 ldp      x29, x30, [sp, #0x30]
0xfffffe000b23b06c  f44f42a9 ldp      x20, x19, [sp, #0x20]
0xfffffe000b23b070  ff030191 add      sp, sp, #0x40
0xfffffe000b23b074  ff0f5fd6 retab    
