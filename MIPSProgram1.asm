# MIPS Program 3
# Shyue Shi Leong

# begin data segment
	.data
num:	.word  12				# reserve space for a number and initialize it to 12
i:	.space   12				# counter variable
space:	.asciiz  " "				# space to insert between numbers
	.align   2				# align data segment after each string
value:  .word  700				# reserve space for a number and initialize to 700

# end data segment

#============================================================================================================

# begin text segment

	.text					# instruction start here
MAIN:   la   $s0, num				# load address of num for use
        lw   $s0, 0($s0)			# load value of num in register
        la   $s1, value				# load address of value for use
        lw   $s1, 0($s1)			# load value into register
        la   $s2, space				# load the address of space for use
        addi $s3, $zero, 0			# i = 0
LOOP:   slt  $t0, $s3, $s0			# i < num
        beq  $t0, $zero, EXIT			# go to EXIT when done
        add  $a0, $zero, $s1			# put value in $a0 to print
        addi $v0, $zero, 1			# set up for int print
        syscall					# print int
        add  $a0, $zero, $s2			# put space in $a0 to print
        addi $v0, $zero, 4			# set up for int print
        syscall					# print string
        addi $s3, $s3, 1			# i++
        addi $s1, $s1, -7			# value - 7
        j	LOOP				# loop
EXIT:   addi $v0, $zero, 10			# system call for exit
        syscall					# clean termination for program