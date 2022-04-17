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
MAIN:   li $v0, 4
	move $a0, \n
	syscall