.data
	A: .word 10
	B: .word 15
	C: .word 20
	D: .word 25
	E: .word 30
	F: .word 35
	G: .word 0,0,0,0
	H: .word 0,0,0,0

.text
	# carrega os valores para os registradores de $s0 até  $s5
	lw 	$s0, A
	lw 	$s1, B
	lw 	$s2, C
	lw 	$s3, D
	lw 	$s4, E
	lw 	$s5, F
	
	# carrega o endereço base de G e H para $s6 e $s7
	la 	$s6, G
	la 	$s7, H
	
	# letra a
	add	$t0, $s1, $s2
	add	$t1, $s0, $s5
	sub	$t0, $t1, $t0
	sw	$t0, 0($s6)
	
	#letra b
	sub 	$t0, $s0, $s1
	sub 	$t1, $s1, $s2
	
	# logica para deixar o primeiro operador sempre positivo
	bge	$t0, $zero, END_IF 		# primeiro operador do produto é positivo, não há nada para fazer
	sub	$t0, $zero, $t0			# inverte o sinal do operador para positivo
	sub	$t1, $zero, $t1			# o sinal do primeiro operador passa para o segundo
END_IF:
	
	add	$t2, $zero, $zero		# inicializa a variavel para incremento no multiply

MULTIPLY:
	ble	$t0, $zero, END_MULTIPLY	# quando t0 chegar a zero o loop termina
	addi	$t0, $t0, -1			# decrementa para chegar em zero
	add	$t2, $t2, $t1			# "multiplica" o t1 t0 vezes
	j	MULTIPLY			# reinicia o laço
END_MULTIPLY:
	
	sub	$t0, $s4, $t2			# faz o último cálculo
	sw	$t0, 4($s6)			# salva na memória
	
	# letra c
	lw	$t0, 4($s6)	# puxa o valor da memoria para t0
	sub	$t0, $t0, $s2	# subtrai o valor de C e guarda no mesmo registrador
	sw	$t0, 8($s6)	# guarda em G[2]
	
	# letra d
	lw	$t0, 0($s6)	# carrega G[0] para t0
	lw	$t1, 8($s6)	# carrega G[2] para t1
	add	$t0, $t0, $t1	# soma os dois acima e guarda em t0
	sw	$t0, 12($s6)	# salva na memoria em G[3]
	
	# letra e
	sub 	$t0, $s1, $s2	# faz B - C
	sw	$t0, 0($s7)	# salva em H[0]
	
	# letra f
	add	$t0, $s0, $s2	# A + C
	sw	$t0, 4($s7)	# H[1] = A + C
	
	# A letra g e h do primeiro exercicio é muito simples, segue a mesma lógica destas últimas
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	