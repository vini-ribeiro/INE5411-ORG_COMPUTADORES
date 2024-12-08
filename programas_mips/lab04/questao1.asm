.data
	matrix:	.space	1024		# 4 * 16 * 16
.text
main:
	li	$t0, 0			# Row counter
	li	$t2, 0			# Value counter
preenche_linha:
	beq	$t0, 16, EXIT
	move	$a0, $t0
	li	$t1, 0			# Column counter
	move	$a1, $t1
	move	$a2, $t2
	jal	preenche_dado_loop
	move	$t2, $v0
	addi	$t0, $t0, 1
	j	preenche_linha
preenche_dado_loop:
	bge	$a1, 16, EXIT_LOOP
	mul	$t4, $a0, 64		# Row * 16 * 4 (word size)		
	mul	$t5, $a1, 4		# Column * 4 (word size)	
	add	$s0, $t4, $t5		# Matrix index
	sw	$a2, matrix($s0)
	addi	$a2, $a2, 1
	addi	$a1, $a1, 1
	j	preenche_dado_loop
EXIT_LOOP:
	move	$v0, $a2
	li	$a0, 0
	li	$a1, 0
	li	$a2, 0
	jr	$ra
EXIT:
	nop

	
		 
