# MIPS Simple Sort Program
# Shyue Shi Leong

# begin data segment
	.data
str:	.asciiz  "The elements sorted in ascending order are: "		# create a null terminated string "The elements stored in ascending order are: "
	.align 2							# align the data segment after each string
space:	.asciiz  ", "							# space to insert between numbers
	.align 2							# align data segment after each string
n:   	.word 0								# reserve space for a number and initialize it to 0
list:	.space 400							# create an array to store numbers
i:	.space 100							# counter variable

# end of data segment

#===================================================================================================================================================================

# begin text segment

	.text								# instruction start here
MAIN:   la   $s0, str							# load the address of string str
        la   $s1, space							# load the address of string space
        la   $s2, n							# load the address of n
        lw   $s2, 0($s2)						# load the value of n into register
        la   $s3, list							# load the base address of arr
        addi $v0, $zero, 5						# set up to prompt user input
        syscall								# prompt user to enter number
        add  $s2, $zero, $v0						# store the prompted number into size
        addi $s4, $zero, 0						# i = 0
LOOP:   slt  $t0, $s4, $s2						# i < n
        beq  $t0, $zero, EXIT						# go to EL1 when done
        addi $v0, $zero, 5						# set up to prompt user
      	syscall								# prompt user to enter number
        add  $t0, $zero, $v0						# store the number in $t0 register
        sll  $t1, $s4, 2						# i * 4
        add  $t1, $s3, $t1						# address of arr[i]
        sw   $t0, 0($t1)						# arr[i] = $v0
        addi $s4, $s4, 1						# i++
        j	LOOP							# loop
EXIT:   add  $a0, $zero, $s3						# store the base address of arr to be parsed into function
        add  $a1, $zero, $s2						# store the size of array to be parsed into function
        jal  SORT							# enter the sort function
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
      
SORT:   addi $sp, $sp, -12						# allocate space to store data in stack
        sw   $s0, 0($sp)						# store $s0
        sw   $s1, 4($sp)						# store $s1
        sw   $s2, 8($sp)						# store $s2
        addi $t0, $a1, -1						# n - 1
        addi $s0, $zero, 0						# c = 0
OFOR:   slt  $t1, $s0, $t0						# i < n - 1
        beq  $t1, $zero, RET						# go to RET when done
        addi $s1, $zero, 0						# j = 0
        sub  $t1, $a1, $s0						# n- c
        addi $t1, $t1, -1						# n - c - 1
IFOR:   slt  $t2, $s1, $t1						# j < n - c - 1
        beq  $t2, $zero, ELOOP						# go to ELOOP when done
        sll  $t2, $s1, 2						# d * 4
        add  $t2, $t2, $a0						# add offset to base address
        lw   $t3, 0($t2)						# value of arr[d]
        addi $t4, $s1, 1						# d + 1
        sll  $t4, $t4, 2						# (d + 1) * 4
        add  $t4, $t4, $a0						# add offset to base address
        lw   $t5, 0($t4)						# value of arr[d+1]
        slt  $t6, $t5, $t3						# arr[d+1]<arr[d]
        beq  $t6, $zero, ELSE						# go to ELSE if false
        add  $s2, $zero, $t3						# temp = arr[d]
        sw   $t5, 0($t2)						# arr[d] = arr[d+1]
        sw   $s2, 0($t4)						# arr[d+1] = temp
ELSE:   addi $s1, $s1, 1						# d++
        j 	IFOR							# jump back to inner for loop
ELOOP:	addi $s0, $s0, 1						# c++
	j	OFOR							# jump back to outer for loop
RET:    add $v0, $zero, $a0						# return the base address of the array
        lw   $s0, 0($sp)						# restore $s0
        lw   $s1, 4($sp)						# restore $s1
        lw   $s2, 8($sp)						# restore $s2
        addi $sp, $sp, 12						# pop stack
        jr	$ra							# return
                	
