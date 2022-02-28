    // intsub function in this file

    .arch armv8-a
    .global intsub

intsub:
       stp     x29, x30, [sp, -48]! // Store FP, LR
       mov     x29, sp
    // Calle Setup
       stp     x19, x20, [sp, 16]
       stp     x21, x22, [sp, 32]

       mov     x19, x0              // 1st number
       mov     x20, x1              // 2nd number
    // x21 and x22 are used for carry



loop:
       cmp     x20, #0              // Continue until carry is 0
       b.eq    endloop
    // Carry = ~x & y
       mov     x22, #-1
       eor     x22, x19, x22

       and     x21, x22, x20 

    // XOR (or eor I guess)
       eor     x19, x20, x19

    // Compute carry
       lsl     x20, x21, #1         // Shift left
    // loop
       b       loop

endloop:
       mov     x0, x19
       ldp     x19, x20, [sp, 16]   // x19 = numA, x20 = numB
       ldp     x21, x22, [sp, 32]   // x21 = carry1, x22 = carry2
       ldp     x29, x30, [sp], 48   // Caller Teardown
       ret
