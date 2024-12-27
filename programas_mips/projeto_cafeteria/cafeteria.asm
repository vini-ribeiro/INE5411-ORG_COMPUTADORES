# feito por Vinicius Henrique Ribeiro (23200351) e Lucas Furlanetto Pascoali (23204339)

.data
	# introdução
	limpar:			.asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	titulo1:     		.asciiz "=====================\n"  	# Linha superior do banner
	titulo2:     		.asciiz "    Cafeteria 2000    \n" 	# Nome da cafeteria
	titulo3:     		.asciiz "=====================\n"  	# Linha inferior do banner

	key:			.word 	0x11, 0x21, 0x41, 0x81, 0x12, 0x22, 0x42, 0x82, 0x14, 0x24, 0x44, 0x84, 0x18, 0x28, 0x48, 0x88
	d7_code: 		.word 	63 6 91 79 102 109 125 7 127 111 119 124 57 94 121 113
	msg_tipo_cafe:		.asciiz	"1 – Café puro; 2 – Café com Leite; 3 – Mochaccino; 5 - Reabastecer.\n"
	msg_tam_cafe:		.asciiz	"1 – copo pequeno; 2 – copo grande.\n"
	msg_acucar:		.asciiz	"Adicionar açúcar? (1 – sim; 0 – não).\n"
	msg_reabastecer:	.asciiz "1 - café; 2 - leite; 3 - chcolate; 4 - açúcar.\n"
	msg_reabastecido:	.asciiz "Reabastecido!\nAperte qualquer tecla...\n"
	reservatorio:		.word	20 20 20 20	# café, leite, chocolate e açúcar
	msg_falta_insumo:	.asciiz "Reabasteça para esta opção.\nAperte qualquer tecla...\n"
	msg_fazendo_cafe:	.asciiz "Aguarde, estou fazendo seu café!\n"
	msg_cafe_pronto:	.asciiz "Seu café está pronto!\nAperte qualquer tecla...\n"
.text	

Main:	
	# impressão do cabeçalho
	jal	LerDoTeclado
	la	$a0, limpar
	li	$v0, 4
	syscall
	la	$a0, titulo1
	li	$v0, 4
	syscall
	la	$a0, titulo2
	li	$v0, 4
	syscall
	la	$a0, titulo3
	li	$v0, 4
	syscall
	# impressão do cabeçalho
	
	jal	LeituraInformacoes
	beq	$s0, 0, finishProgram		# encerra o programa
	bne	$s0, 5, verificarInsumos	# desvia caso queira fazer a bebida
	la	$a0, msg_reabastecer		# se não desviar, entra no menu para reabastecer
	li	$v0, 4
	syscall
	jal	LerDoTeclado
	addi	$v0, $v0, -1
	move	$a0, $v0
	jal 	Reabastecer
	la	$a0, msg_reabastecido
	li	$v0, 4
	syscall
	j	Main
verificarInsumos:			# faz a verificação dos insumos necessários para a bebida
	beq	$s2, 0, verificarCafe	# pula se o insumo não é usado
	move	$a0, $s1
	li	$a1, 3
	jal	TemInsumo		# verifica se tem insumo
	beq	$v0, 1 verificarCafe
	la	$a0, msg_falta_insumo	# imprime mensagem para reabastecer
	li	$v0, 4
	syscall
	j	Main			# volta para o menu
verificarCafe:				# verifica se tem pó de café
	move	$a0, $s1
	li	$a1, 0
	jal	TemInsumo
	beq	$v0, 1 verificarLeite	# se tem avança
	la	$a0, msg_falta_insumo	# se não tem manda reabastecer
	li	$v0, 4
	syscall
	j	Main			# volta para o menu
verificarLeite:				# verifica se tem pó de leite
	beq	$s0, 1, fazerBebida	# caso não use, avança
	move	$a0, $s1
	li	$a1, 1
	jal	TemInsumo
	beq	$v0, 1 verificarChocolate # caso tenha, vai para o próximo
	la	$a0, msg_falta_insumo	  # manda reabastecer
	li	$v0, 4
	syscall
	j	Main			# volta pro menu
verificarChocolate:			# verifica se tem pó de chocolate
	bne	$s0, 3, fazerBebida	# se não for usar, avança
	move	$a0, $s1
	li	$a1, 2
	jal	TemInsumo
	beq	$v0, 1 fazerBebida
	la	$a0, msg_falta_insumo	# manda reabastecer
	li	$v0, 4
	syscall
	j	Main			# volta para o main
fazerBebida:				# começa a produção da bebida
	la	$a0, msg_fazendo_cafe
	li	$v0, 4
	syscall
	beq	$s2, 0, botarCafe	# caso o café seja sem açúcar, avança
	move	$a0, $s1
	li	$a1, 3
	jal	UsarInsumo
botarCafe:				# toda bebida usa pó de café
	move	$a0, $s1
	li	$a1, 0
	jal	UsarInsumo
botarLeite:				
	beq	$s0, 1, finaliza	# caso seja café puro, finaliza
	move	$a0, $s1
	li	$a1, 1
	jal	UsarInsumo
botarChocolate:
	bne	$s0, 3, finaliza	# caso não seja mochoccino, finaliza
	move	$a0, $s1
	li	$a1, 2
	jal	UsarInsumo
finaliza:
	move	$a0, $s1
	jal	LiberarAgua		# usa função para liberar água
	la	$a0, msg_cafe_pronto	# imprime mensagem de pronto
	li	$v0, 4
	syscall
	j	Main			# volta para o menu


# ------------------------- FUNÇÃO PARA SIMULAR TEMPO DE PREPARO --------------
# a0 = tempo em segundos
SimularPreparo:
	addi	$sp, $sp, -4
	sw	$a0, 0($sp)
	
	mul	$a0, $a0, 1000	# transforma para milissegundos
	li	$v0, 32		# sleep
	syscall
	
	lw	$a0, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
# ------------------------- FUNÇÃO PARA SIMULAR TEMPO DE PREPARO --------------

# ------------------------- FUNÇÃO PARA LIBERAR ÁGUA --------------------------
# a0 = 1 copo pequeno, 2 copo grande
LiberarAgua:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$a0, 0($sp)
	
	mul	$a0, $a0, 5
	jal	SimularPreparo
	
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr 	$ra
# ------------------------- FUNÇÃO PARA LIBERAR ÁGUA --------------------------

# ------------------------- FUNÇÃO PARA REABASTECER ----------------------------	
# a0 = tipo de pó
Reabastecer:
	addi	$sp, $sp, -8
	sw	$a0, 4($sp)
	sw	$t0, 0($sp)
	
	# bota o 20 na posição do pó reabastecido no array
	la	$t0, reservatorio
	sll	$a0, $a0, 2
	add	$t0, $t0, $a0
	li	$a0, 20
	sw	$a0, 0($t0)
	
	lw	$t0, 0($sp)
	lw	$a0, 4($sp)
	addi	$sp, $sp, 8
	jr 	$ra
# ------------------------- FUNÇÃO PARA REABASTECER ----------------------------	

# ------------------------- FUNÇÃO PARA USAR INSUMOS ---------------------------
# a0 = quantas doses
# a1 = tipo de pó (0 - café, 1 - leite, 2 - chocolate e 3 - açúcar)
UsarInsumo:
	addi	$sp, $sp, -20		# desloca pilha
	sw	$a1, 16($sp)
	sw	$a0, 12($sp)
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
	lw	$a0, 12($sp)
	lw	$a1, 16($sp)
	addi	$sp, $sp, 20	
	jr	$ra
# ------------------------- FUNÇÃO PARA USAR INSUMOS ---------------------------

# ------------------------- FUNÇÃO PARA VERIFICAR INSUMOS ----------------------
# a0 = quantidade de doses
# a1 = tipo de pó (0 - café, 1 - leite, 2 - chocolate e 3 - açúcar)
# v0 = 1 se tiver, v0 = 0 se não.
TemInsumo:
	addi	$sp, $sp, -12		# desloca pilha
	sw	$t0, 0($sp)		# salva contexto
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	
	la	$t0, reservatorio
	sll	$a1, $a1, 2		# multiplica por 4 para acessar o endereço
	add	$t0, $t0, $a1		# desloca o ponteiro para o insumo desejado
	lw	$t0, 0($t0)
	sge	$v0, $t0, $a0		# v0 recebe 1 caso tenha insumos para o café
	
	lw	$t0, 0($sp)		# restaura contexto
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	addi	$sp, $sp, 12
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
# s0 = tipo de cafe
# s1 = tamanho
# s2 = se quer açúcar
LeituraInformacoes:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	la	$a0, msg_tipo_cafe
	li	$v0, 4
	syscall
	jal 	LerDoTeclado
	move	$s0, $v0
	beq	$s0, 5, terminaLeitura	# para reabastecer
	beq	$s0, 0, terminaLeitura	# para encerrar o programa
	
	la	$a0, msg_tam_cafe	# entrada do tamanho do café
	li	$v0, 4
	syscall
	jal 	LerDoTeclado
	move	$s1, $v0
	
	la	$a0, msg_acucar		# entrada da opção de adoçar
	li	$v0, 4
	syscall
	jal 	LerDoTeclado
	move	$s2, $v0
terminaLeitura:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
# ------------------------- FUNÇÃO PARA SALVAR AS ENTRADAS ---------------------	

# finaliza o programa
finishProgram:
	nop
