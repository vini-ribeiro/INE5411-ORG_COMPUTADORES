.data
	
	msg_g: .asciiz "Insira o G: "
	msg_h: .asciiz "Insira o H: "
	msg_i: .asciiz "Insira o I: "
	msg_j: .asciiz "Insira o J: "
	
.text

	j	MAIN

LE_INTEIRO:
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	jr	$ra

PUSH_SP:
	

MAIN:
	la	$a0, msg_g	# carrega a mensagem para o G
	jal	LE_INTEIRO	# chama o procedimento
	add	$s0, $zero, $v0	# pega o retorno da função e guarda em $s0
	addi	$sp, $sp, -4	# aumento uma posição na pilha
	sw	$s0, 0($sp)	# salvo no lugar em que ele aponta

	la	$a0, msg_h	# carrega a mensagem para o H
	jal	LE_INTEIRO	# chama o procedimento
	add	$s0, $zero, $v0	# pega o retorno da função e guarda em $s1
	addi	$sp, $sp, -4	# aumento uma posição na pilha
	sw	$s0, 0($sp)	# salvo no lugar em que ele aponta
	
	la	$a0, msg_i	# carrega a mensagem para o I
	jal	LE_INTEIRO	# chama o procedimento
	add	$s0, $zero, $v0	# pega o retorno da função e guarda em $s2
	addi	$sp, $sp, -4	# aumento uma posição na pilha
	sw	$s0, 0($sp)	# salvo no lugar em que ele aponta

	la	$a0, msg_j	# carrega a mensagem para o J
	jal	LE_INTEIRO	# chama o procedimento
	add	$s0, $zero, $v0	# pega o retorno da função e guarda em $s3
	addi	$sp, $sp, -4	# aumento uma posição na pilha
	sw	$s0, 0($sp)	# salvo no lugar em que ele aponta
	
	lw	$s1, 0($sp)
	addi	$sp, $sp, 4
	lw	$s1, 0($sp)
	addi	$sp, $sp, 4