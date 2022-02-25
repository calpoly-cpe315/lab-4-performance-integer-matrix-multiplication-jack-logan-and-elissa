////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
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
	stp x29, x30, [sp, -64]!   // Store FP, LR, move SP, reserve 6 registers space
	mov x29, sp                // Make FP = new SP
	stp x19, x20, [sp, 16]
	stp x21, x22, [sp, 32]
	stp x23, x24, [sp, 48]

	mov x19, x0					//P.elements?

	// Restore callee saved
	ldp   x19, x20, [sp, 16]
	ldp   x21, x22, [sp, 32]
	ldp   x23, x24, [sp, 48]
	ldp x29, x30, [sp], 64  //restore FP and LR, restore SP, deallocate
	ret