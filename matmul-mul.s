////////////////////////////////////////////////////////////////////////////////
// ~~~~~~~~ARM mult and add IMPLEMENTATION~~~~~~~~~~~~~~~~~~~
//
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A, height of matrix B
//! @param wB         width of matrix B
//
//  Note that while A, B, and C represent two-dimensional matrices,
//  they have all been allocated linearly. This means that the elements
//  in each row are sequential in memory, and that the first element
//  of the second row immedialely follows the last element in the first
//  row, etc. 
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[k * wB + j];
//      }
//      C[i * wB + j] = sum;
//    }
//}
////////////////////////////////////////////////////////////////////////////////

	.arch armv8-a
	.global matmul
matmul:

	//matmul(P.elements, M.elements, N.elements, HM, WM, WN);
	stp x29, x30, [sp, -128]!   // Store FP, LR, move SP, reserve 6+4 registers space
	mov x29, sp                // Make FP = new SP
	stp x19, x20, [sp, 16]
	stp x21, x22, [sp, 32]
	stp x23, x24, [sp, 48]
	stp x25, x26, [sp, 64]		//i and j
	stp x27, x28, [sp, 80]		//k and sum
 
	//P = M*N or C = A*B
	str x0, [sp, 88]	    //C.elements
	str x1, [sp, 96]	//A.elements
	str x2, [sp, 104]	//B.elements
	mov x22, x3		//hA height A
	mov x23, x4		//wA width A
	mov x24, x5		//wB width B

	//for (unsigned int i = 0; i < 4*hA; i = i+4)	//factor of 4 since each matrix is int
	mov x25, #0	//i = 0
outloop:	//outer loop
	cmp x25, x22
	b.ge endoutloop
		//for (unsigned int j = 0; j < wB; ++j)
	mov x26, #0	//j = 0
inloop:		//inner loop
	cmp x26, x24
	b.ge endinloop
	//int sum = 0
	mov x28, #0
			//for (unsigned int k = 0; k < wA; ++k)
	mov x27, #0	//k = 0
ininloop:	//inner inner loop
	cmp x27, x23
	b.ge endininloop
	//sum += A[i * wA + k] * B[k * wB + j];

	mul x19, x25, x23
	add x19, x19, x27
	mov x0, #4
	mul x19, x19, x0

	// pull x20 (A.elements) from stack and put in x20
    ldr x20, [sp, 96]  // x20 is A.elements (address)
	ldr w20, [x20, x19] // new x20 is element wanted
	//B
	mul x19, x27, x24
	add x19, x19, x26
	mov x0, #4
	mul x19, x19, x0

	//pull x21(B.elements) from stack and put in 
	ldr x21, [sp, 104]
	ldr w21, [x21, x19]// B[k * wB + j] ???
	mul x19, x21, x20
	add x28, x28, x19
	add x27, x27, #1
	b ininloop

endininloop:
	
	//C[i * wB + j] = sum;
	// i * wB
	// i * wB + j (i * wB still in x0)
	mul x20, x25, x24
	add x20, x20, x26
	mov x0, #4
	mul x20, x20, x0

	// Index into C
	ldr x19, [sp, 88]
	str w28, [x19, x20]
	add x26, x26, #1
	b inloop

endinloop:
	add x25, x25, #1
	b outloop

endoutloop:
	// Restore stack pointer
	// Restore callee saved
	ldp   x19, x20, [sp, 16]
	ldp   x21, x22, [sp, 32]
	ldp   x23, x24, [sp, 48]
	ldp   x25, x26, [sp, 64]
	ldp   x27, x28, [sp, 80]
	ldp   x29, x30, [sp], 128  //restore FP and LR, restore SP, deallocate
	ret
