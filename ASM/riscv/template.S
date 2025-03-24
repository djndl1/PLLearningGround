.global main


main:
	addi 	sp, sp, -16 // grow the stack
	sd	ra, 8(sp)   // push the return address onto the stack, ra may be used by later calls and must be saved
	sd	s0, 0(sp)   // push last stack frame pointer to the stack
	addi	s0, sp, 16  // set the current frame pointer

	li	a0, 1 	// return value in a0

	ld	ra, 8(sp) // retrieve the return address
	ld	s0, 0(sp) // restore the last stack frame 
	addi	sp, sp, 16 // shrink the stack
	jr	ra 	// return to the last frame



