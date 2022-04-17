# MIPS Program 2
# Shyue Shi Leong

# begin data segment
	.data
sum:	.word  0			# reserve space for a number and initalize it to 0
i: 	.space 10			# counter variable
space:   .asciiz  " "			# space to insert between numbers
	.align 2			# align data segment after each string

# end of data segment 	

#==================================================================================================

# begin text segment

	.text				# instructions start here
MAIN:  la   $s0, sum			# load the address of sum for use
       lw   $s0, 0($s0)			# load value of sum into register
       la   $s1, space			# load the address of space for use
       addi $s2, $zero, 0		# set i to 0
WHILE: slti $t0, $s2, 10		# i < 10
       beq  $t0, $zero, END		# go to end when done
       add  $s0, $s0, $s2		# sum = sum + i
       add  $a0, $zero, $s0		# put sum in $a0 to print
       addi $v0, $zero, 1		# set up for int print
       syscall				# print int
       add  $a0, $zero, $s1		# put space in $a0
       addi $v0, $zero, 4		# set up for print string
       syscall				# print string
       addi $s2, $s2, 1			# i++
       j	WHILE			# loop
END:   addi $v0, $zero, 10		# system call for exit
       syscall				# clean termination of program