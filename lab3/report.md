<div style="text-align:right;">Bharat Kathi</div>
<div style="text-align:right;">ECE 154A</div>
<div style="text-align:right;">10/27/23</div>

# Lab 3 Report

## Number of hours spent on lab

I spent about 6 hours on this lab.

## `sort.s`

```assembly
counting_sort:
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
	jr ra
```