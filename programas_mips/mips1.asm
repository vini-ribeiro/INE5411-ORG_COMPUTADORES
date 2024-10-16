.data

.text
main:
	# Carregar 0.0 em double usando registradores de ponto flutuante
	li    $t0, 0x00000000       # parte superior de 0.0
	mtc1  $t0, $f12             # move para a parte superior do registrador de ponto flutuante
	li    $t1, 0x00000000       # parte inferior de 0.0
	mtc1  $t1, $f13             # move para a parte inferior do registrador de ponto flutuante

	jal	seno_x
	mov.d	$f20, $f0           # Move o resultado do seno para $f20
	j	exit_programa


seno_x:
	mov.d	$f10, $f12	        # salva x em $f10
	# Carregar 1.0 em double
	li    $t0, 0x3ff00000       # parte superior de 1.0
	mtc1  $t0, $f6              # move para a parte superior do registrador de ponto flutuante
	li    $t1, 0x00000000       # parte inferior de 1.0
	mtc1  $t1, $f7              # move para a parte inferior do registrador de ponto flutuante

	li	$t0, 1                 # inicializa t0 (expoente e fatorial)
	# Inicializa acumulador em 0.0
	li    $t0, 0x00000000       # parte superior de 0.0
	mtc1  $t0, $f4              # move para a parte superior do acumulador
	li    $t1, 0x00000000       # parte inferior de 0.0
	mtc1  $t1, $f5              # move para a parte inferior do acumulador

	addi	$sp, $sp, -8	        # incrementa a pilha
	sw	$ra, 8($sp)	        # salva o endereço de retorno

loop_seno:
	bgt	$t0, 41, exit_loop_seno	# condição para sair do loop

	mov.d	$f12, $f10	        # x é passado como base no argumento de potencia_n
	move	$a1, $t0	        # expoente para potencia_n
	jal	potencia_n	        # chamada da função potencia_n
	mov.d	$f2, $f0	        # pega o retorno de potencia_n

	move	$a0, $t0	        # passa o argumento para fatorial
	jal	fatorial

	div.d	$f2, $f2, $f0	    # divide o retorno de potencia_n pelo fatorial

	mul.d	$f2, $f2, $f6	    # aplica o sinal no monômio
	sub.d	$f6, $f0, $f6	    # inverte o sinal para a próxima iteração

	add.d	$f4, $f4, $f2	    # soma o monômio no acumulador

	addi	$t0, $t0, 2	        # incrementa o expoente e fatorial para a próxima iteração
	j	loop_seno	

exit_loop_seno:
	mov.d	$f0, $f4	        # retorna o valor acumulado
	addi	$sp, $sp, 8
	lw	$ra, 0($sp)
	jr	$ra


# Função para calcular a n-ésima potência de x
potencia_n:	
	# Inicializa o retorno como 1.0
	li    $t0, 0x3ff00000       # parte superior de 1.0
	mtc1  $t0, $f0              # move para a parte superior do registrador de ponto flutuante
	li    $t1, 0x00000000       # parte inferior de 1.0
	mtc1  $t1, $f1              # move para a parte inferior do registrador de ponto flutuante

loop_pot:
	beqz	$a1, exit_loop_pot
	addi	$a1, $a1, -1	    # decrementa o expoente
	mul.d	$f0, $f0, $f12	    # multiplica o acumulador pela base (x)
	j	loop_pot
exit_loop_pot:
	jr	$ra	# fim da função potencia_n


# Função para calcular o fatorial
fatorial:
	li	$v0, 1		# inicializa o retorno como 1
loop_fat:
	ble	$a0, 1, exit_loop_fat
	mul	$v0, $v0, $a0	# multiplica acumulando o fatorial
	addi	$a0, $a0, -1	# decrementa para o próximo multiplicador
	j	loop_fat
exit_loop_fat:
	mtc1	$v0, $f0	# converte o resultado para ponto flutuante
	jr	$ra	# fim da função fatorial


exit_programa:	# label para o fim do programa
