	.text	
	.globl		main
main:
	la		$t2, null
	la		$t0, str
L1:
	lb		$t1, ($t0)
	beq		$t1, $zero, L2
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L1
L2:
	sb		$zero, 0($t2)
	la		$t2, x
	la		$t0, abc
L3:
	lb		$t1, ($t0)
	beq		$t1, $zero, L4
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L3
L4:
	sb		$zero, 0($t2)
	la		$t2, y
	la		$t0, def
L5:
	lb		$t1, ($t0)
	beq		$t1, $zero, L6
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L5
L6:
	sb		$zero, 0($t2)
	la		$t2, z
	la		$t0, x
L7:
	lb		$t1, ($t0)
	beq		$t1, $zero, L8
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L7
L8:
	la		$t0, y
L9:
	lb		$t1, ($t0)
	beq		$t1, $zero, L10
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L9
L10:
	sb		$zero, 0($t2)
	la		$t2, w
	la		$t0, z
L11:
	lb		$t1, ($t0)
	beq		$t1, $zero, L12
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L11
L12:
	la		$t0, y
L13:
	lb		$t1, ($t0)
	beq		$t1, $zero, L14
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L13
L14:
	sb		$zero, 0($t2)
	la		$t0, z
	li		$v0, 4
	move		$a0, $t0
	syscall	
	li		$v0, 4
	la		$a0, newl
	syscall	
	la		$t0, w
	li		$v0, 4
	move		$a0, $t0
	syscall	
	li		$v0, 4
	la		$a0, newl
	syscall	
	la		$t2, w
	la		$t0, x
L15:
	lb		$t1, ($t0)
	beq		$t1, $zero, L16
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L15
L16:
	la		$t0, null
L17:
	lb		$t1, ($t0)
	beq		$t1, $zero, L18
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L17
L18:
	sb		$zero, 0($t2)
	la		$t0, w
	li		$v0, 4
	move		$a0, $t0
	syscall	
	li		$v0, 4
	la		$a0, newl
	syscall	
	la		$t2, w
	la		$t0, x
L19:
	lb		$t1, ($t0)
	beq		$t1, $zero, L20
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L19
L20:
	la		$t0, x
L21:
	lb		$t1, ($t0)
	beq		$t1, $zero, L22
	sb		$t1, ($t2)
	addi		$t0, $t0, 1
	addi		$t2, $t2, 1
	j		L21
L22:
	sb		$zero, 0($t2)
	la		$t0, w
	li		$v0, 4
	move		$a0, $t0
	syscall	
	li		$v0, 4
	la		$a0, newl
	syscall	
	li		$v0, 10
	syscall	
	.data	
	.align		4
newl:	.asciiz		"\n"
	.align		2
str:	.asciiz		""
	.align		2
def:	.asciiz		"def"
	.align		2
null:	.space		4
w:	.space		160
x:	.space		40
y:	.space		40
z:	.space		80
abc:	.asciiz		"abc"
	.align		2
