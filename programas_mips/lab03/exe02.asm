.data
	
.text
main:
	li	$a0, 10
	li	$a1, 0
	jal	potencia_n
	j	exit_programa


seno_x:
	move	$s0, $a0	# salva x em s0
	li	$t7, 1		# configura uma variável para alterar o sinal da operação dos monômios
	li	$t0, 1		# inicializa t0 (expoente e fatorial)
loop_seno:
	bgt	$t0, 41, exit_loop_seno
	move	$a0, $s0	# x é passado como base no argumento de potencia_n
	move	$a1, $t0	# éxpoente da potencia_n
	jal	potencia_n	# chamada da função potencia_n
	move	$t1, $v0	# pega o retorno de potencia_n
	move	$a0, $t0	# passa o argumento para fatorial
	jal	fatorial
	move	$t2, $v0	# salva em t2 o resultado de fatorial
	div	$t3, $t1, $t2	# faz x^n/n!
	mul	$t3, $t3, $t7	# configura o sinal do monômio
	sub	$t7, $zero, $t7	# inverte o sinal para a próxima iteração
	add	$t4, $t4, $t3	# soma o monômio no acumulador
	addi	$t0, $t0, 2	# incrementa o expoente e fatorial para a próxima iteração
	j	loop_seno	
exit_loop_seno:
	move	$v0, $t4
	jr	$ra
	
	


# procedimento para calcular a n-ésima potência (a0, a1) = (base, expoente)
potencia_n:	
	li	$v0, 1		# configura o retorno
loop_pot:
	beqz	$a1, exit_loop_pot
	addi	$a1, $a1, -1	# decrementa o expoente
	mul	$v0, $v0, $a0	# acrescente no acumulador a parcela da potência
	j	loop_pot
exit_loop_pot:
	jr	$ra	# fim do procedimento potencia_n



# fatorial de um número dado
fatorial:
	li	$v0, 1		# contador do loop
loop_fat:
	ble	$a0, 1, exit_loop_fat	# t0 vai decrementando até chegar em 1
	mul	$v0, $v0, $a0		# acumulador para as multiplicações
	addi	$a0, $a0, -1		# decrementa a0 para achar o próximo multiplicador
	j	loop_fat
exit_loop_fat:
	jr	$ra	# fim do procedimento do fatorial



exit_programa:	# label para quando a main terminar (fim do programa)