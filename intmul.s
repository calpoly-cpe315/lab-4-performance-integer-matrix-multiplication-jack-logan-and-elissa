// Replace this file with your own implementation
	.arch armv8-a
	.global intmul

intmul:
       stp     x29, x30, [sp, -48]! // Store FP, LR    + reserve space for 4 more registers
       mov     x29, sp
    // Calle Setup
       stp     x23, x24, [sp, 16]
       stp     x25, x26, [sp, 32]

       mov     x23, x0 // numA
       mov     x24, x1 // numB
       mov     x25, #0 // result
loop:

       cmp     x24, 0
       b.eq    endfunc

       and     x26, x24, #1         // x26 is to see if x24 (numB) has LSR all the way to 0
       cmp     x26, #0
       b.eq    skip

    // Result += a
       mov     x0, x25
       mov     x1, x23
       bl      intadd
       mov     x25, x0
    
    // b -= 1
       mov     x0, x24
       mov     x1, #1
       bl      intsub
       mov     x24, x0

skip:  lsl     x23, x23, #1
       lsr     x24, x24, #1
       b       loop

endfunc:
       mov     x0, x25
       ldp     x23, x24, [sp, 16]
       ldp     x25, x26, [sp, 32]
       ldp     x29, x30, [sp], 48   // Caller Teardown
       ret
