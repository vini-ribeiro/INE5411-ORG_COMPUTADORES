.data

.text



potencia_n:	# procedimento para calcular a n-ésima potência
	move	$t0, $a0	# pega a base
	move	$t1, $a1	# pega o expoente
	li	$t2, 1
loop_pot:
	beq	$t1, $zero, exit_loop_pot
	addi	$t1, $t1, -1
	mul	$t2, $t2, $t0
	j	loop_pot
exit_loop_pot:
	move	$v0, $t2
	jr	$ra


f_fatorial:	# fatorial de um número dado
	move 	$t0, $a0	# t0 guarda o argumento
	li	$t1, 1		# contador do loop
	move	$t2, $a0	# acumulador do multiplicador
loop_fat:
	beq	$t0, $t1, exit_loop_fat	# t0 vai decrementando até chegar em 1
	addi	$t0, $t0, -1
	mul	$t2, $t2, $t0		# multiplica o valor de t0 pelo acumulado guardado em t2
	j	loop_fat
exit_loop_fat:
	move 	$v0, $t2	# bota o acumulado em v0 para retorno
	jr	$ra	# volta para a função chamada
