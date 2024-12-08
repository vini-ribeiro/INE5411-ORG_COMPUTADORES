.data
	key:		.word 	0x11, 0x21, 0x41, 0x81, 0x12, 0x22, 0x42, 0x82, 0x14, 0x24, 0x44, 0x84, 0x18, 0x28, 0x48, 0x88
	d7_code: 	.word 	63 6 91 79 102 109 125 7 127 111 119 124 57 94 121 113
	escolha_cafe:	.asciiz	"1 – Café puro; 2 – Café com Leite; 3 – Mochaccino.\n"
	reservatorio:	.word	20 20 20 20
.text	
MAIN:
	li 	$v0, 4
	la	$a0, escolha_cafe
	syscall

loop:
	jal	DISPLAY7SEG
	move	$s0, $v0		# s0 recebe o tipo do café
	bne	$s0, 0, loop

	
	j	finish_program

DISPLAY7SEG:
	# salva o contexto dos registradores para o retorno ideal ao main
	addi	$sp, $sp, -20
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$t4, 16($sp)
CAPTURA_TECLA:
	li	$t0, 1
LOOP_LER_TECLA:
	sb 	$t0, 0xffff0012			# insere o código da linha
	lw 	$t1, 0xffff0014			# pega o valor na memória, pela tecla apertada
	bnez	$t1, CLICOU_TECLA 		# sai do loop caso precione alguma tecla
	add	$t0, $t0, $t0			# 1, 2, 4, 8
	beq 	$t0, 16, CAPTURA_TECLA		# reseta o indicador de linha (t0 = 1)
	j	LOOP_LER_TECLA			# se não apertar nada, continua iterando
CLICOU_TECLA:
	la	$t0, key		# t0 = endereço do vetor key
	li	$t2, 0			# inicializa t3 como contador
LOOP_QUAL_TECLA:
	lw	$t3, 0($t0)		# t3 = t0[0]
	sub	$t4, $t3, $t1		# t4 = 0 indica que t0[i] é a tecla
	beqz	$t4, IMPRIMIR_D7SEG	# desvia para imprimir a tecla
	addi	$t0, $t0, 4		# t0[++i]
	addi	$t2, $t2, 4		# t2[++i]
	j	LOOP_QUAL_TECLA
IMPRIMIR_D7SEG:
	lw	$t3, d7_code($t2)	# pega o d7seg correspondente ao valor de t2
	sw	$t3, 0xffff0010		# guarda na memória para o MARS imprimir no d7seg
	div	$v0, $t2, 4		# retorna o valor da tecla (0, 1, ..., 15)
	li	$t0, 1
LOOP_CONFERE:
	sb 	$t0, 0xffff0012			# insere o código da linha
	lw 	$t1, 0xffff0014			# pega o valor na memória, pela tecla apertada
	bne	$t1, 0, LOOP_CONFERE  	# sai do loop caso precione alguma tecla
FINALIZA_LEITURA:

	# restaura o contexto do main para os registradores utilizados
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	lw	$t4, 16($sp)
	addi	$sp, $sp, 20
	jr 	$ra

finish_program:
