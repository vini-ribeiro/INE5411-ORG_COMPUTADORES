.data
	key:		.word 	0x11, 0x21, 0x41, 0x81, 0x12, 0x22, 0x42, 0x82, 0x14, 0x24, 0x44, 0x84, 0x18, 0x28, 0x48, 0x88
	d7_code: 	.word 	63 6 91 79 102 109 125 7 127 111 119 124 57 94 121 113
	msg_tipo_cafe:	.asciiz	"1 – Café puro; 2 – Café com Leite; 3 – Mochaccino; 5 - Reabastecer.\n"
	msg_tam_cafe:	.asciiz	"g – copo grande; p – copo pequeno.\n"
	msg_acucar:	.asciiz	"Adicionar açúcar? (s – sim; n – não).\n"
	reservatorio:	.word	20 16 12 10	# café, leite, chocolate e açúcar
	
	e_tipo_cafe:	.word
	e_tam_cafe:	.word
	e_acucar:	.word
.text	

Main:
	li	$a0, 25
	li	$a1, 3
	jal	TemInsumo
	move	$s0, $v0
	j	finish_program

# ------------------------- FUNÇÃO PARA SIMULAR TEMPO DE PREPARO --------------
# a0 = tempo em segundos
SimularPreparo:
	mul	$a0, $a0, 1000	# transforma para milissegundos
	li	$v0, 32		# sleep
	syscall
	jr	$ra
# ------------------------- FUNÇÃO PARA SIMULAR TEMPO DE PREPARO --------------

# ------------------------- FUNÇÃO PARA LIBERAR ÁGUA --------------------------
# a0 = 1 copo pequeno, 2 copo grande
LiberarAgua:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	mul	$a0, $a0, 5
	jal	SimularPreparo
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr 	$ra
# ------------------------- FUNÇÃO PARA LIBERAR ÁGUA --------------------------

# ------------------------- FUNÇÃO PARA REABASTECER ----------------------------	
# a0 = tipo de pó
Reabastecer:
	addi	$sp, $sp, -4
	sw	$t0, 0($sp)
	la	$t0, reservatorio
	sll	$a0, $a0, 2
	add	$t0, $t0, $a0
	li	$a0, 20
	sw	$a0, 0($t0)
	lw	$t0, 0($sp)
	addi	$sp, $sp, 4
	jr 	$ra
# ------------------------- FUNÇÃO PARA REABASTECER ----------------------------	

# ------------------------- FUNÇÃO PARA USAR INSUMOS ---------------------------
# a0 = quantas doses
# a1 = tipo de pó
UsarInsumo:
	addi	$sp, $sp, -12		# desloca pilha
	sw	$ra, 8($sp)		# salva contexto
	sw	$t0, 4($sp)		# salva contexto
	sw	$t1, 0($sp)		# salva contexto
	
	la	$t0, reservatorio
	sll	$a1, $a1, 2		# multiplica por 4 para acessar o endereço
	add	$t0, $t0, $a1		# desloca o ponteiro para o insumo desejado
	lw	$t1, 0($t0)
	sub	$t1, $t1, $a0		# diminui as doses usadas
	jal	SimularPreparo
	sw	$t1, 0($t0)		# salva o resultado
	
	lw	$t1, 0($sp)		# restaura contexto
	lw	$t0, 4($sp)		# restaura contexto
	lw	$ra, 8($sp)		# salva contexto
	addi	$sp, $sp, 12		
	jr	$ra
# ------------------------- FUNÇÃO PARA USAR INSUMOS ---------------------------

# ------------------------- FUNÇÃO PARA VERIFICAR INSUMOS ----------------------
# a0 = quantidade de doses
# a1 = tipo de pó (0 - café, 1 - leite, 2 - chocolate e 3 - açúcar)
# v0 = 1 se tiver, v0 = 0 se não.
TemInsumo:
	addi	$sp, $sp, -4		# desloca pilha
	sw	$t0, 0($sp)		# salva contexto
	
	la	$t0, reservatorio
	sll	$a1, $a1, 2		# multiplica por 4 para acessar o endereço
	add	$t0, $t0, $a1		# desloca o ponteiro para o insumo desejado
	lw	$t0, 0($t0)
	sge	$v0, $t0, $a0		# v0 recebe 1 caso tenha insumos para o café
	
	lw	$t0, 0($sp)		# restaura contexto
	addi	$sp, $sp, 4
	jr	$ra
# ------------------------- FUNÇÃO PARA VERIFICAR INSUMOS ----------------------

# ------------------------- FUNÇÃO PARA LER DO TECLADO -------------------------
LerDoTeclado:
	# salva o contexto dos registradores para o retorno ideal ao main
	addi	$sp, $sp, -16
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
loopIinicializacao:
	li	$t0, 1
loopLerTecla:
	sb 	$t0, 0xffff0012			# insere o código da linha
	lw 	$t1, 0xffff0014			# pega o valor na memória, pela tecla apertada
	bnez	$t1, clicou 			# sai do loop caso precione alguma tecla
	add	$t0, $t0, $t0			# 1, 2, 4, 8
	beq 	$t0, 16, loopIinicializacao	# reseta o indicador de linha (t0 = 1)
	j	loopLerTecla			# se não apertar nada, continua iterando
clicou:
	sb 	$t0, 0xffff0012		# continua lendo a mesma linha da LER_TECLA
	lw 	$t2, 0xffff0014		# t2 = tecla precionada
	bnez	$t2, clicou		# caso a tecla permaneça precionada, matém no loop
	
	la	$t0, key	# t0 = endereço do vetor key
	li	$t2, 0		# t2 será o contador
loopQualTecla:
	lw	$t3, 0($t0)			# t3 = t0[0]
	sub	$t3, $t3, $t1			# t4 = 0 indica que t0[i] é a tecla
	beqz	$t3, return_LerDoTeclado	# desvia para imprimir a tecla
	addi	$t0, $t0, 4			# t0[++i]
	addi	$t2, $t2, 1			# t2++
	j	loopQualTecla
return_LerDoTeclado:	
	move	$v0, $t2	# atribui t2 ao retorno
	
	lw	$t0, 0($sp)	# restaura contexto
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	addi	$sp, $sp, 16
	jr	$ra
# ------------------------- FUNÇÃO PARA LER DO TECLADO -------------------------

# ------------------------- FUNÇÃO PARA SALVAR AS ENTRADAS ---------------------
LeituraInformacoes:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	la	$a0, msg_tipo_cafe
	li	$v0, 4
	syscall
	jal 	LerDoTeclado
	la	$a0, e_tipo_cafe
	sw	$v0, 0($a0)
	beq	$v0, 5, terminaLeitura:
	
	la	$a0, msg_tam_cafe
	li	$v0, 4
	syscall
	jal 	LerDoTeclado
	la	$a0, e_tam_cafe
	sw	$v0, 0($a0)
	
	la	$a0, msg_acucar
	li	$v0, 4
	syscall
	jal 	LerDoTeclado
	la	$a0, e_acucar
	sw	$v0, 0($a0)
terminaLeitura:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
# ------------------------- FUNÇÃO PARA SALVAR AS ENTRADAS ---------------------	
	


finish_program:







# ------------------------- FUNÇÃO PARA BLOQUEAR MÁQUINA -----------------------
BloquearMaquina:
	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)
loopBloqueia:
	jal	LerDoTeclado
	bne	$v0, 0x22, loopBloqueia	# não sai do loop enquanto a tecla 5 não for apertada
	lw	$ra, 0($sp)
	addi 	$sp, $sp, 4
	jr 	$ra
# ------------------------- FUNÇÃO PARA BLOQUEAR MÁQUINA -----------------------	