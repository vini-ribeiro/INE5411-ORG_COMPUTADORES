.data
	quebra_linha: 	.asciiz "\n"
.text
	li	$v0, 5
	syscall
	move	$s0, $v0	# salvo o inteiro lido em s0
	
	mtc1.d	$s0, $f2	# passa o inteiro para o coprocessador 1
	cvt.d.w	$f2, $f2	# converte o inteiro para double em f2 para inicializar o acumulador
	
fatorial:
	addi	$s0, $s0, -1

	mtc1.d	$s0, $f0	# passa o inteiro para o coprocessador 1
	cvt.d.w	$f0, $f0	# converte o inteiro para double
	
	mul.d	$f2, $f2, $f0	# multiplica e acumula
	bgt	$s0, 2, fatorial

	li	$v0, 4
	la	$a0, quebra_linha
	syscall
	
	li	$v0, 3
	mov.d	$f12, $f2
	syscall