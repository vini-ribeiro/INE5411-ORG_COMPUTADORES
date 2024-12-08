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
	jal	LER_TECLADO
	move	$s0, $v0		# s0 recebe o tipo do café
	bne	$s0, 0, loop

	
	j	finish_program

LER_TECLADO:
	# salva o contexto dos registradores para o retorno ideal ao main
	addi	$sp, $sp, -16
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
CAPTURA_TECLA:
	li	$t0, 1
LER_TECLA:
	sb 	$t0, 0xffff0012			# insere o código da linha
	lw 	$t1, 0xffff0014			# pega o valor na memória, pela tecla apertada
	bnez	$t1, CLICOU 		# sai do loop caso precione alguma tecla
	add	$t0, $t0, $t0			# 1, 2, 4, 8
	beq 	$t0, 16, CAPTURA_TECLA		# reseta o indicador de linha (t0 = 1)
	j	LER_TECLA			# se não apertar nada, continua iterando
CLICOU:
	la	$t0, key		# t0 = endereço do vetor key
	li	$t2, 0			# t2 será o contador
LOOP_QUAL_TECLA:
	lw	$t3, 0($t0)	# t3 = t0[0]
	sub	$t3, $t3, $t1	# t4 = 0 indica que t0[i] é a tecla
	beqz	$t3, RETORNA	# desvia para imprimir a tecla
	addi	$t0, $t0, 4	# t0[++i]
	addi	$t2, $t2, 1	# t2++
	j	LOOP_QUAL_TECLA
RETORNA:
	li	$t0, 1
SOLTAR_TECLA:
	sb 	$t0, 0xffff0012		# insere o código da linha
	lw 	$t1, 0xffff0014		# pega o valor na memória, pela tecla apertada
	bnez	$t1, SOLTAR_TECLA 	# sai do loop caso precione alguma tecla

	move	$v0, $t2
	
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	addi	$sp, $sp, 16
	
	jr	$ra

finish_program:
