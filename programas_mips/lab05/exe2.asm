.data
	quebra_linha: 	.asciiz "\n"
	um:	.double	1.0
.text
	li	$v0, 5
	syscall
	
	move	$a0, $v0	# passando argumento para fatorial
	jal 	fatorial	# chamanda a função
	
	li	$v0, 3		# imprimir double
	syscall		# valor já se encontra em f12
	
	j	exit_main	# encerra o programa


# return a0 * fatorial(a0 - 1)
fatorial:
	ble	$a0, 1, exit_fatorial	# verifica o caso base para encerrar as chamadas recursivas
	addi 	$sp, $sp, -8	# move sp para empilhar o contexto atual
	sw	$ra, 4($sp)	# salva o registrador de retorno
	sw	$a0, 0($sp)	# salva o argumento
	addi	$a0, $a0, -1	# configura o argumento para a proxima chamada
	jal	fatorial	# chama a função
	lw	$a0, 0($sp)	# tira o argumenta da pilha
	lw	$ra, 4($sp)	# tira o registrador de retorno da pilha
	addi 	$sp, $sp, 8	# move sp para cima

	mtc1.d	$a0, $f2	# passa o inteiro para o coprocessador 1
	cvt.d.w	$f2, $f2	# converte o inteiro para double em f2 para multiplicar o retorno

	mul.d	$f12, $f2, $f12	# multiplica o retorno da chamada com o argumento atual
	jr	$ra
exit_fatorial:
	la	$t0, um		# pega o endereço de 1 em double
	l.d	$f12, ($t0)	# põe 1 em f12 para retorno
	jr	$ra		# retorno


exit_main:
