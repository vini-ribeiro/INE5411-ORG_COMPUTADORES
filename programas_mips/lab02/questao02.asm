.data
	key:		.word 	0x11, 0x21, 0x41, 0x81, 0x12, 0x22, 0x42, 0x82, 0x14, 0x24, 0x44, 0x84, 0x18, 0x28, 0x48, 0x88
	d7_code: 	.word 	63 6 91 79 102 109 125 7 127 111 119 124 57 94 121 113
.text	
MAIN:
	li 	$s0, 0xffff0012		# salva o endereço linha para leitura do teclado
	li 	$s1, 0xffff0014		# salva o endereço do código da tecla
	j	CAPTURA_TECLA

CAPTURA_TECLA:
	li	$t0, 1
	LOOP_LER_TECLA:
		sb 	$t0, 0($s0)
		lw 	$t1, 0($s1)
		bnez	$t1, CLICOU_TECLA # sai do loop caso precione alguma tecla
		
		add	$t0, $t0, $t0	# 1, 2, 4, 8
		beq 	$t0, 16, CAPTURA_TECLA
	
		j	LOOP_LER_TECLA	# se não apertar nada, continua esperando
		
	CLICOU_TECLA:
		la	$t2, key
		li	$t3, 0
		LOOP_QUAL_TECLA:
			lw	$t4, 0($t2)
			sub	$t5, $t4, $t1
			beq	$t5, $zero, IMPRIMIR_D7SEG
			addi	$t2, $t2, 4
			addi	$t3, $t3, 4
			j	LOOP_QUAL_TECLA
	IMPRIMIR_D7SEG:
		lw	$t4, d7_code($t3)
		sw	$t4, 0xffff0010
		
				
			

