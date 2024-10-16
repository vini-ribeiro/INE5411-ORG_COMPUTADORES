.data
	x: 		.double -5.5 -4 -1 0, 3.141592, 4, 5, 10, 15, 17, 18, 19
	sinal_monomio: 	.double 1
	numero_1:	.double 1
	resultado:	.double 0
.text
main:
	la	$s0, x
	li 	$s1, 0
loop_testes:
	bge	$s1, 12, loop_testes_exit
	addi	$s1, $s1, 1
	l.d	$f0, 0($s0)
	addi	$s0, $s0, 8
	jal	seno_x
	j loop_testes
loop_testes_exit:
	
	j	exit_programa

# recebe o argumento em f0 e retorna em f2
seno_x:
	addi	$sp, $sp, -4		# incrementa a pilha
	sw	$ra, 4($sp)		# salva o endereço de retorno

	mov.d	$f4, $f0		# salva x em f4
	l.d	$f6, sinal_monomio	# configura uma variável para alterar o sinal da operação dos monômios
	l.d	$f8, resultado			# acumulador do resultado
	li	$t0, 1			# inicializa t0 (expoente e fatorial)
loop_seno:
	bgt	$t0, 41, exit_loop_seno		# condição para o loop
	
	#move	$a0, $s0	# x é passado como base no argumento de potencia_n
	move	$a0, $t0	# a0 é o expoente
	mov.d	$f0, $f4	# coloco o valor de x na base
	jal	potencia_n	# chamada da função potencia_n
	# retorno de potencia_n está em f2

	move	$a0, $t0	# passa o argumento para fatorial
	jal	fatorial	# o resultado do fatorial está f10
	
	div.d	$f2, $f2, $f10	# pega o retorno e divide t1, guardando no próprio t1
	
	mul.d	$f2, $f2, $f6	# configura o sinal do monômio
	neg.d	$f6, $f6	# inverte o sinal para o próximo monômio

	add.d	$f8, $f8, $f2	# soma o monômio no acumulador
	
	addi	$t0, $t0, 2	# incrementa o expoente e fatorial para a próxima iteração
	j	loop_seno	
exit_loop_seno:
	mov.d	$f2, $f8
	addi	$sp, $sp, 4
	lw	$ra, 0($sp)
	jr	$ra
	
	


# procedimento para calcular a n-ésima potência (f0, a0) = (base, expoente) e retorna em f2 também
# utiliza f0 e f2
potencia_n:	
	l.d	$f2, numero_1		# configura o retorno
loop_pot:
	beqz	$a0, exit_loop_pot
	addi	$a0, $a0, -1	# decrementa o expoente
	mul.d	$f2, $f2, $f0	# acrescente no acumulador a parcela da potência
	j	loop_pot
exit_loop_pot:
	jr	$ra	# fim do procedimento potencia_n



# fatorial de um número dado (recebe em a0 e retorna em v0)
fatorial:
	l.d	$f10, numero_1		# configura o retorno
loop_fat:
	ble	$a0, 1, exit_loop_fat	# a0 vai decrementar até chegar a 1
	mtc1.d	$a0, $f12		# passa o inteiro para f12
	cvt.d.w	$f12, $f12		# converte para double
	mul.d	$f10, $f10, $f12	# acumulador para as multiplicações
	addi	$a0, $a0, -1		# decrementa a0 para achar o próximo multiplicador
	j	loop_fat
exit_loop_fat:
	jr	$ra	# fim do procedimento do fatorial



exit_programa:	# label para quando a main terminar (fim do programa)
