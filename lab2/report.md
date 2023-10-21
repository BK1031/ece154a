<div style="text-align:right;">Bharat Kathi</div>
<div style="text-align:right;">ECE 154A</div>
<div style="text-align:right;">10/20/23</div>

# Lab 2 Report

## Number of hours spent on lab

I spent about 4 hours on this lab.

## `mult.s`

```assembly
multiply:
	addi s0, a0, 0          #	s0 = a0;
	addi s1, a1, 0          #	s1 = a1;
	addi s2, zero, 8        #	s2 = 8;
	addi s3, zero, 0        #	s3 = 0;

do:                         #   do {
	andi t3, s1, 1          #		t3 = s1[0];
	beq t3, zero, shift	    #	if (t3 != 0) {
	add a2, a2, s0 	        #		a2 = a2 + s0;
shift:                      #	}
	slli s0, s0, 1          #	s0 = s0 << 1;
	srli s1, s1, 1          #	s1 = s1 >> 1;
	addi s3, s3, 1          #		s3 = s3 + 1;
	blt s3, s2, do          #	} while (s3 < 8);
```

## `div.s`

```assembly
divide:
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
```