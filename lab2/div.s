##############################################################################
# File: div.s
# Skeleton for ECE 154a project
##############################################################################

	.data
student:
	.asciz "Student" 	# Place your name in the quotations in place of Student
	.globl	student
nl:	.asciz "\n"
	.globl nl


op1:	.word 7				# divisor for testing
op2:	.word 19			# dividend for testing


	.text

	.globl main
main:					# main has to be a global label
	addi	sp, sp, -4		# Move the stack pointer
	sw 	ra, 0(sp)		# save the return address

	mv	t0, a0			# Store argc
	mv	t1, a1			# Store argv
				
	li	a7, 4			# print_str (system call 4)
	la	a0, student		# takes the address of string as an argument 
	ecall	

	slti	t2, t0, 2		# check number of arguments
	bne     t2, zero, operands
	j	ready

operands:
	la	t0, op1
	lw	a0, 0(t0)
	la	t0, op2
	lw	a1, 0(t0)
		

ready:
	jal	divide			# go to divide code

	jal	print_result		# print operands to the console

					# Usual stuff at the end of the main
	lw	ra, 0(sp)		# restore the return address
	addi	sp, sp, 4

	li      a7, 10
	ecall


divide:
##############################################################################
# Your code goes here.
# Should have the same functionality as running
#	divu	a2, a1, a0
# 	remu    a3, a1, a0 
# assuming a1 is unsigned divident, and a0 is unsigned divisor
##############################################################################
 
	addi s0, a0, 0			# s0 = a0;
	slli s0, s0, 8			# s0 = s0 << 8;
	addi a3, a1, 0			# a3 = a1;
	addi s8, zero, 9		# s8 = 9;
	addi s9, zero, 0		# s9 = 0;

do:							# do {
	sub a3, a3, s0			# 	a3 = a3 - s0;
	slli a2, a2, 1			# 	a2 = a2 << 1;
	bge a3, zero quotient	#	if (a3 < 0) {
	add a3, a3, s0			# 		a3 = a3 + s0;
	j shift
quotient:					#	}
	blt a3, zero, shift		# 	else if (a3 >= 0) {
	addi a2, a2, 1			#		a2 = a2 + 1;
shift:						#	}
	srli s0, s0, 1			#	s0 = s0 >> 1;
	addi s9, s9, 1			#	s9++;
	blt s9, s8, do			# } while (s9 < 9);

##############################################################################
# Do not edit below this line
##############################################################################
	jr	ra


# Prints a0, a1, a2, a3
print_result:
	mv	t0, a0
	li	a7, 4
	la	a0, nl
	ecall

	mv	a0, t0
	li	a7, 1
	ecall
	li	a7, 4
	la	a0, nl
	ecall

	li	a7, 1
	mv	a0, a1
	ecall
	li	a7, 4
	la	a0, nl
	ecall

	li	a7, 1
	mv	a0, a2
	ecall
	li	a7, 4
	la	a0, nl
	ecall

	li	a7, 1
	mv	a0, a3
	ecall
	li	a7, 4
	la	a0, nl
	ecall

	jr ra
