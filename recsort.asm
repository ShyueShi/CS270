# MIPS Recursive Sort Program
# Shyue Shi Leong

# begin data segment

	.data
str:	.asciiz  "The elements sorted in ascending order are: "		# create a null terminated string "The elements stored in ascending order are: "
	.align 2							# align the data segment after each string
space:	.asciiz  ", "							# space to insert between numbers
	.align 2							# align data segment after each string
size:  	.word 0								# reserve space for a number and initialize it to 0
arr:	.space 400							# create an array to store numbers
i:	.space 100							# counter variable
Aux:	.space 80							# create an array to store numbers

# end of data segment

#===================================================================================================================================================================

# begin text segment

	.text								# instruction start here
MAIN:   la   $s0, str							# load the address of string str
        la   $s1, space							# load the address of string space
        la   $s2, size							# load the address of size
        lw   $s2, 0($s2)						# load the value of size into register
        la   $s3, arr							# load the base address of arr
        addi $v0, $zero, 5						# set up to prompt user input
        syscall								# prompt user to enter number
        add  $s2, $zero, $v0						# store the prompted number into size
        addi $s4, $zero, 0						# i = 0
LOOP:   slt  $t0, $s4, $s2						# i < size
        beq  $t0, $zero, EXIT						# go to EXIT when done
        addi $v0, $zero, 5						# set up to prompt user
      	syscall								# prompt user to enter number
        add  $t0, $zero, $v0						# store the number in $t0 register
        sll  $t1, $s4, 2						# i * 4
        add  $t1, $s3, $t1						# address of arr[i]
        sw   $t0, 0($t1)						# arr[i] = $v0
        addi $s4, $s4, 1						# i++
        j	LOOP							# loop
EXIT:   add  $a0, $zero, $s3						# put base address of array into $a0
	add  $a1, $zero, $s2						# put the size of array into $a1
	jal  	MS							# jump to function
	add  $a0, $zero, $s0						# put str into $a0 to print
        add  $v0, $zero, 4						# set up for string print
        syscall								# print string
        addi $s4, $zero, 0						# i = 0
LOOP2:  slt  $t0, $s4, $s2						# i < temp
        beq  $t0, $zero, END						# go to END when done
        sll  $t0, $s4, 2						# i * 4
        add  $t0, $t0, $s3						# add offset to the base address
        lw   $t1, 0($t0)						# load the value of arr[i]
        add  $a0, $zero, $t1						# put arr[i] into $a0 to print
        add  $v0, $zero, 1						# set up for int print
        syscall								# print int
        addi $t2, $s2, -1						# temp = size - 1
        beq  $s4, $t2, EL2						# go to EL2 if i = size - 1
        add  $a0, $zero, $s1						# put space into $a0 to print
        add  $v0, $zero, 4						# set up for string print
        syscall 							# print string
EL2:    addi $s4, $s4, 1						# i++
        j 	LOOP2							# loop
END:    addi $v0, $zero, 10						# system call for exit
        syscall								# clean termination of program
                          
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
MS:	addi $sp, $sp, -8						# allocated space in the stack 
        sw   $s0, 0($sp)						# store $s0
        sw   $ra, 4($sp)						# store $ra
        la   $s0, Aux							# load the address of Aux for use
        addi $a3, $a1, -1						# size - 1
        addi $a2, $zero, 0						# $a2 = 0
        add  $a1, $zero, $s0						# $a1 = Aux
        jal	MS1							# function call mergesort1
        lw   $s0, 0($sp)						# restore $s0
        lw   $ra, 4($sp)						# restore $ra
        addi $sp, $sp, 8						# pop stack
        jr	$ra							# return

MS1:	addi $sp, $sp, -24						# allocate space in the stack
	sw   $a0, 0($sp)						# store $a0 register
	sw   $a1, 4($sp)						# store $a1 register
	sw   $a2, 8($sp)						# store $a2 register
	sw   $a3, 12($sp)						# store $a3 register
	sw   $ra, 16($sp)						# store $ra register
	sw   $s0, 20($sp)						# store $s0 register
	slt  $t0, $a2, $a3						# s < e
	beq  $t0, $zero, RET						# go to RET when done
	add  $t0, $a2, $a3						# s + e
	srl  $t0, $t0, 1						# (s + e) / 2
	add  $a3, $zero, $t0						# $a3 = (s + e) / 2
	jal	MS1							# recursive call
	lw   $a3, 12($sp)						# load original value of e
	add  $t1, $a2, $a3						# s + e
	srl  $t1, $t1, 1						# (s + e) / 2
	addi $t1, $t1, 1						# (s + e) / 2 + 1
	add  $a2, $zero, $t1						# $a2 = (s + e) / 2 + 1
	jal	MS1							# recursive call
	lw   $a3, 12($sp)						# reload the value e from stack
	add  $s0, $zero, $a3						# $s0 = 5th argument
	sw   $s0, -4($sp)						# store the 5th argument to stack
	lw   $a2, 8($sp)						# reload the value of s from stack
	add  $t0, $a2,$a3						# s + e
	srl  $t0, $t0, 1						# (s + e) / 2
	addi $t0, $t0, 1						# ((s + e) / 2) + 1
	add  $a3, $zero, $t0						# $a3 = ((s + e) / 2) + 1
	jal MERGE							# jump to merge call
RET:    lw   $a0, 0($sp)						# restore $a0 register
	lw   $a1, 4($sp)						# restore $a1 register
	lw   $a2, 8($sp)						# restore $a2 register
	lw   $a3, 12($sp)						# restore $a3 register
	lw   $ra, 16($sp)						# restore $ra register
	lw   $s0, 20($sp)						# restore $s0 register
	addi $sp, $sp, 24						# pop stack
	jr	$ra							# return

MERGE:  addi $sp, $sp, -20						# allocate space in stack
	sw   $s0, 0($sp)						# store $s0 register
	sw   $s1, 4($sp)						# store $s1 register
	sw   $s2, 8($sp)						# store $s2 register
	sw   $s3, 12($sp)						# store $s3 register
	lw   $s3, 16($sp)						# load the 5th argument
	add  $s0, $zero, $a2						# i = s1
	add  $s1, $zero, $a3						# j = s2
	add  $s2, $zero, $a2						# k = s1
L1:	slt  $t0, $s0, $a3						# i < s2
	beq  $t0, $zero, L2						# go to E1 if i > s2
	slt  $t0, $s3, $s1						# j > e2
	bne  $t0, $zero, L2						# go to E1 if j < e2
	sll  $t0, $s0, 2						# i * 4
	add  $t0, $t0, $a0						# add offset to base address
	lw   $t1, 0($t0)						# value of Y[i]
	sll  $t2, $s1, 2						# j * 4
	add  $t2, $t2, $a0						# add offset to base address
	lw   $t3, 0($t2)						# value of Y[j]
	sll  $t4, $s2, 2						# k * 4
	add  $t4, $t4, $a1						# add offset to base address
I1:	slt  $t6, $t1, $t3						# Y[i] < Y[j]
	beq  $t6, $zero, ELSE						# go to EL1 if Y[i] > Y[j]
	sw   $t1, 0($t4)						# A[k] = Y[i]
	addi $s0, $s0, 1						# i++
	j	E1							# jump to E1
ELSE:   sw   $t3, 0($t4)						# A[k] = Y[j]
	addi $s1, $s1, 1						# j++
E1:	addi $s2, $s2, 1						# k++
	j	L1							# loop!
L2:	slt  $t0, $s0, $a3						# i < s2
	beq  $t0, $zero, E2						# go to E2 when done
	sll  $t0, $s0, 2						# i * 4		
	add  $t0, $t0, $a0						# add offset to base address
	lw   $t1, 0($t0)						# value of Y[i]
	sll  $t2, $s2, 2						# k * 4
	add  $t2, $t2, $a1						# add offset to base address
	sw   $t1, 0($t2)						# A[k] = Y[i]
	addi $s0, $s0, 1						# i++
	addi $s2, $s2, 1						# k++
	j	L2							# loop!
E2:     slt  $t0, $s3, $s1						# j > e2
	bne  $t0, $zero, E3						# go to E3 when done
	sll  $t0, $s1, 2						# j * 4
	add  $t0, $t0, $a0						# add offset to base address
	lw   $t1, 0($t0)						# value of Y[j]
	sll  $t2, $s1, 2						# k * 4
	add  $t2, $t2, $a1						# add offset to base address
	sw   $t1, 0($t2)						# A[k] = Y[j]
	addi $s1, $s1, 1						# j++
	addi $s2, $s2, 1						# k++
	j	E2							# loop!
E3: 	add  $s0, $zero, $a2						# i = s1
L3:     slt  $t0, $s3, $s0						# i > e2
	bne  $t0, $zero, E4						# go to E4 when done
	sll  $t0, $s0, 2						# i * 4
	add  $t1, $t0, $a1						# add offset to base address
	add  $t2, $t0, $a0						# add offset to base address
	lw   $t3, 0($t1)						# value of A[i]
	sw   $t3, 0($t2)						# Y[i] = A[i]
	addi $s0, $s0, 1						# i++
	j	L3							# loop!
E4:	lw   $s0, 0($sp)						# restore $s0
	lw   $s1, 4($sp)						# restore $s1
	lw   $s2, 8($sp)						# restore $s2
	lw   $s3, 12($sp)						# restore $s3
	addi $sp, $sp, 20						# pop stack
	jr	$ra							# return
