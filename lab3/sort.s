##############################################################################
# File: sort.s
# Skeleton for ECE 154A
##############################################################################

	.data
student:
	.asciz "Student:\n" 	# Place your name in the quotations in place of Student
	.globl	student
nl:	.asciz "\n"
	.globl nl
sort_print:
	.asciz "[Info] Sorted values\n"
	.globl sort_print
initial_print:
	.asciz "[Info] Initial values\n"
	.globl initial_print
read_msg: 
	.asciz "[Info] Reading input data\n"
	.globl read_msg
code_start_msg:
	.asciz "[Info] Entering your section of code\n"
	.globl code_start_msg

key:	.word 268632064			# Provide the base address of array where input key is stored(Assuming 0x10030000 as base address)
output:	.word 268632144			# Provide the base address of array where sorted output will be stored (Assuming 0x10030050 as base address)
numkeys:	.word 6				# Provide the number of inputs
maxnumber:	.word 10			# Provide the maximum key value


## Specify your input data-set in any order you like. I'll change the data set to verify
data1:	.word 1
data2:	.word 2
data3:	.word 3
data4:	.word 5
data5:	.word 6
data6:	.word 8

	.text

	.globl main
main:					# main has to be a global label
	addi	sp, sp, -4		# Move the stack pointer
	sw 	ra, 0(sp)		# save the return address
			
	li	a7, 4			# print_str (system call 4)
	la	a0, student		# takes the address of string as an argument 
	ecall	

	jal process_arguments
	jal read_data			# Read the input data

	j	ready

process_arguments:
	
	la	t0, key
	lw	a0, 0(t0)
	la	t0, output
	lw	a1, 0(t0)
	la	t0, numkeys
	lw	a2, 0(t0)
	la	t0, maxnumber
	lw	a3, 0(t0)
	jr	ra	

### This instructions will make sure you read the data correctly
read_data:
	mv t1, a0
	li a7, 4
	la a0, read_msg
	ecall
	mv a0, t1

	la t0, data1
	lw t4, 0(t0)
	sw t4, 0(a0)
	la t0, data2
	lw t4, 0(t0)
	sw t4, 4(a0)
	la t0, data3
	lw t4, 0(t0)
	sw t4, 8(a0)
	la t0, data4
	lw t4, 0(t0)
	sw t4, 12(a0)
	la t0, data5
	lw t4, 0(t0)
	sw t4, 16(a0)
	la t0, data6
	lw t4, 0(t0)
	sw t4, 20(a0)

	jr	ra


counting_sort:
######################### 
## your code goes here ##
#########################

	# a0 = keys[] base address
    # a1 = output[] base address
    # a2 = numkeys
    # a3 = maxnumber

	addi t0, a3, 1 		# t0 = maxnumber + 1;
	slli t0, t0, 2 		# t0 *= 4;

	sub sp, sp, t0 		# int count[maxnumber + 1];
	addi t1, zero, 0 	# n = 0;

for1:
	bgt t1, a3, done1 	# for (n = 0; n <= maxnumber; n++) {
	slli t0, t1, 2 		# 	t0 = n * 4;
	add t0, sp, t0 		# 	t0 = &count[n];
	sw zero, 0(t0) 		# 	count[n] = 0;
	addi t1, t1, 1 		# 	n = n + 1;
	j for1 				# }

done1:
	addi t1, zero, 0 	# n = 0;

for2:
	bge t1, a2, done2 	# for (n = 1; n < numkeys; n++) {
	slli t0, t1, 2 		# 	t0 = n * 4;
	add t0, a0, t0 		# 	t0 = &keys[n];
	lw t2, 0(t0) 		# 	t2 = keys[n];
	slli t2, t2, 2 		# 	t2 = t2 * 4
	add t2, sp, t2 		# 	t2 = &count[keys[n]];
	lw t3, 0(t2) 		# 	t3 = count[keys[n]];

	addi t3, t3, 1		# 	t3 = count[keys[n]] + 1;
	sw t3, 0(t2) 		# 	count[keys[n]] = t3;
	addi t1, t1, 1 		# 	n = n + 1;
	j for2 				# }

done2:
	addi t1, zero, 1 	# n = 1;

for3:
	bgt t1, a3, done3 	# for (n = 1; n <= maxnumber; n++) {
	slli t0, t1, 2 		# 	t0 = n * 4;
	add t0, sp, t0 		# 	t0 = &count[n];
	lw t2, 0(t0) 		# 	t2 = count[n];
	addi t3, t0, -4 	# 	t3 = &count[n - 1];
	lw t4, 0(t3) 		# 	t4 = count[n - 1];
	add t2, t2, t4 		# 	t2 = t2 + t4;
	sw t2, 0(t0) 		# 	count[n] = t2;
	addi t1, t1, 1		# 	n = n + 1;
	j for3 				# }

done3:
	addi t1, zero, 0 	# n = 0;

for4:
	bge t1, a2, done4 	# for (n = 1; n < numkeys; n++) {
	slli t0, t1, 2 		# 	t0 = n * 4;
	add t0, a0, t0 		# 	t0 = &keys[n];
	lw t2, 0(t0)	 	# 	t2 = keys[n];
	addi t5, t2, 0 		# 	t5 = keys[n];
	slli t2, t2, 2 		# 	t2 = t2 * 4
	add t2, sp, t2 		# 	t2 = &count[keys[n]];
	lw t3, 0(t2) 		# 	t3 = count[keys[n]];
	addi t4, t3, -1 	# 	t4 = count[keys[n]] - 1;
	slli t4, t4, 2 		# 	t4 = t4 * 4
	add t4, a1, t4 		# 	t4 = &output[count[keys[n]] - 1];
	sw t5, 0(t4) 		# 	output[count[keys[n]] - 1] = keys[n];
	addi t3, t3, -1 	# 	t3 = count[keys[n]] - 1;
	sw t3, 0(t2) 		# 	count[keys[n]] = t3;
	addi t1, t1, 1 		# 	n = n + 1;
	j for4 				# }

done4:
	addi t0, a3, 1 		# t0 = maxnumber + 1;
	slli t0, t0, 2 		# t0 = t0 * 4;
	add sp, sp, t0 		# delete count[maxnumber + 1];


#########################
 	jr ra
#########################


##################################
#Dont modify code below this line
##################################
ready:
	jal	initial_values		# print operands to the console
	
	mv 	t2, a0
	li 	a7, 4
	la 	a0, code_start_msg
	ecall
	mv 	a0, t2

	jal	counting_sort		# call counting sort algorithm

	jal	sorted_list_print


				# Usual stuff at the end of the main
	lw	ra, 0(sp)		# restore the return address
	addi	sp, sp, 4
	jr	ra			# return to the main program

print_results:
	add t0, zero, a2 # No of elements in the list
	add t1, zero, a0 # Base address of the array
	mv t2, a0    # Save a0, which contains base address of the array

loop:	
	beq t0, zero, end_print
	addi, t0, t0, -1
	lw t3, 0(t1)
	
	li a7, 1
	mv a0, t3
	ecall

	li a7, 4
	la a0, nl
	ecall

	addi t1, t1, 4
	j loop
end_print:
	mv a0, t2 
	jr ra	

initial_values: 
	mv 	t2, a0
        addi	sp, sp, -4		# Move the stack pointer
	sw 	ra, 0(sp)		# save the return address

	li a7, 4
	la a0, initial_print
	ecall
	
	mv 	a0, t2
	jal print_results
 	
	lw	ra, 0(sp)		# restore the return address
	addi	sp, sp, 4

	jr ra

sorted_list_print:
	mv 	t2, a0
	addi	sp, sp, -4		# Move the stack pointer
	sw 	ra, 0(sp)		# save the return address

	li a7,4
	la a0,sort_print
	ecall
	
	mv a0, t2
	
	#swap a0,a1
	mv t2, a0
	mv a0, a1
	mv a1, t2
	
	jal print_results
	
    #swap back a1,a0
	mv t2, a0
	mv a0, a1
	mv a1, t2
	
	lw	ra, 0(sp)		# restore the return address
	addi	sp, sp, 4	
	jr ra
