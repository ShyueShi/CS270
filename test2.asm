	.text	
	.globl		main
main:
	la $t0, bT
	la $t1, num1
L1:	lb $t2, ($t0)
	beq $t2, $zero, end
	sb $t2, ($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j L1
end:
	la $t0, bF
L2:	lb $t2, ($t0)
	beq $t2, $zero, end2
	sb $t2, ($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j L2
end2:
	la $t1, num1
	li $v0, 4
	move $a0, $t1
	syscall
	li $v0, 10
	syscall
	.data	
	.align		4
newl:	.asciiz		"\n"
	.align		2
space:	.asciiz		" "
	.align		2
bT:	.asciiz		"true"
	.align		2
bF:	.asciiz		"false"
	.align		2
num1:	.space		256
num2:	.space		256
