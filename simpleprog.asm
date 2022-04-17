# MIPS Simple Program
# Shyue Shi Leong

# begin data segment
	.data
str1:	.asciiz  "The array in reverse is: "		# create a null terminated string "The array in reverse is: "
	.align 2					# align data segment after each string
str2:	.asciiz  "The largest element is: "		# create a null terminated string "The largest element is: "
	.align 2					# align data segment after each string
str3:	.asciiz  "Thank you and have a nice day!"	# create a null terminated string "Thank you and have a nice day!"
	.align 2					# align data segment after each string
next:   .asciiz  "\n"					# create a null terminated string "\n"
	.align 2					# align data segment after each string
space:	.asciiz  ", "					# space to insert between numbers
	.align 2					# align data segment after each string
i:	.space 100					# counter variable
big:  	.word 0						# reserve space for a number and initialize it to 0
arr:	.space 400					# create an array that can store up to 100 integers


# end of data segment

#==================================================================================================

# begin text segment

	.text						# instruction start here
MAIN:  la   $s0, str1					# load the address of strng str1
       la   $s1, str2					# load the address of strng str2
       la   $s2, str3					# load the address of strng str3
       la   $s3, space					# load the address of string space
       addi $v0, $zero, 5				# set up to prompt user
       syscall						# prompt user to enter a number
       add  $s4, $zero, $v0				# store the number in $s4 register
       slti $t0, $s4, 1					# if promopted number smaller than 1
       bne  $t0, $zero, IF0				# jump to print message
       la   $s5, big					# load the address of big for use
       lw   $s5, 0($s5)					# load the value of big into register
       la   $s6, arr					# load the base address of arr for use
       addi $s7, $zero, 0				# i = 0
LOOP:  slt  $t0, $s7, $s4				# i < $s4 (number entered by user)
       beq  $t0, $zero, EXIT				# go to EXIT when done
       addi $v0, $zero, 5				# set up to prompt user
       syscall						# prompt user to enter number
       add  $t1, $zero, $v0				# store the number in $t1 register
       sll  $t2, $s7, 2					# i * 4
       add  $t2, $s6, $t2				# address of A[i]
       sw   $t1, 0($t2)					# A[i] = $v0
       addi $s7, $s7, 1					# i++
       j	LOOP					# loop
EXIT:  add  $a0, $zero, $s0				# put address of str1 in $a0 to print
       addi $v0, $zero, 4				# put 4 into $v0 for printing a string
       syscall						# print string
       lw   $t0, 0($s6)					# get the first value in the array
       add  $s5, $zero, $t0				# set big to the first element 
       addi $s4, $s4, -1				# $s4 - 1 to get index of array
       add  $s7, $zero, $s4				# i = value in $s4
LOOP2: slt  $t0, $zero, $s7				# i >= 0
       beq  $t0, $zero, END				# go to END when done
       sll  $t1, $s7, 2					# i * 4
       add  $t1, $s6, $t1				# address of A[i]
       lw   $t2, 0($t1)					# value of A[i] 
       add  $a0, $zero, $t2				# put A[i] in $a0 to print
       addi $v0, $zero, 1				# set up for int print
       syscall						# print int
       add  $a0, $zero, $s3				# put space in $a0
       addi $v0, $zero, 4				# set up for print string
       syscall						# print string
       slt  $t3, $s5, $t2				# A[i] > big
       beq  $t3, $zero, ELSE				# go to else if big > A[i]
       add  $s5, $zero, $t2				# big = A[i]
ELSE:  addi $s7, $s7, -1				# i--
       j	LOOP2					# loop
END:   lw   $t1, 0($s6)					# load the value of the first element in the array
       add  $a0, $zero, $t1				# put A[0] in $a0 to print
       addi $v0, $zero, 1				# set up for int print
       syscall						# print int
       la   $t2, next					# load the address of next to print
       add  $a0, $zero, $t2				# put next in $a0
       addi $v0, $zero, 4				# set up for string print
       syscall						# print string
       add  $a0, $zero, $s1				# put address of str2 in $a0 to print
       addi $v0, $zero, 4				# put 4 into $v0 to print string
       syscall						# print string
       add  $a0, $zero, $s5				# put big in $a0 to print
       addi $v0, $zero, 1				# set up for int print
       syscall						# print int
       add  $a0, $zero, $t2				# put next in $a0
       addi $v0, $zero, 4				# set up for string print
       syscall						# print string
IF0:   add  $a0, $zero, $s2				# put address of str3 in $a0 to print
       addi $v0, $zero, 4				# put 4 into $v0 to print string
       syscall						# print string
       addi $v0, $zero, 10				# system call for exit
       syscall						# clean termination of program
