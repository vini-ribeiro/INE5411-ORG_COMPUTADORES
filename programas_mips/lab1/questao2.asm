# VINICIUS HENRIQUE RIBEIRO E LUCAS FURLANETTO PASCOALI
		
.data
	c_: .word 25
	msg_b: .asciiz "Entre com o valor de b: "
	msg_d: .asciiz "Entre com o valor de d: "
	msg_e: .asciiz "Entre com o valor de e: "
	
.text
	la	$a0, msg_b
	li	$v0, 4
	syscall			# printa string para entrada de b
	li 	$v0, 5
	syscall
	add 	$s0, $zero, $v0 # lê b
	
	la	$a0, msg_d
	li	$v0, 4
	syscall			# printa string para entrada de d
	li 	$v0, 5
	syscall
	add 	$s1, $zero, $v0 # lê d
	
	la	$a0, msg_e
	li	$v0, 4
	syscall			# printa string para entrada de e
	li 	$v0, 5
	syscall
	add 	$s2, $zero, $v0 # lê e
	
	addi	$t0, $s0, 35 	# a = b + 35
	add	$t1, $t0, $s2	# a + e
	mul	$t2, $s1, $s1 	# d²
	mul	$t2, $s1, $t2 	# d³
	sub	$t3, $t2, $t1	# t2 = d³ - (a + e)	
	sw	$t3, c_		# guarda o valor de t3 em c
	
	li	$v0, 1
	add	$a0, $zero, $t3
	syscall 		# printa o valor de t3 (c) no terminal
	
