.data
	n: 		.word 20
	x:		.double 0.0
	dois:		.double 2.0
	estimativa:	.double 1.0

.text
MAIN:
	li	$v0, 7 
	syscall
	s.d	$f0, x
		
	jal	raiz_quadrada
	
	l.d	$f4, x
	sqrt.d 	$f4, $f4
	
	j	EXIT
	
	
raiz_quadrada:
	lw	$t0, n
	l.d	$f2, x
	l.d 	$f4, estimativa
	l.d	$f8, dois
raiz_loop:
	beq 	$t0, $zero, end_loop
	
	div.d	$f6, $f2, $f4
	add.d	$f4, $f6, $f4
	div.d	$f4, $f4, $f8
	sub	$t0, $t0, 1 
	j	raiz_loop
	
end_loop:
	mov.d	$f0, $f4	
	jr $ra
	
EXIT: 	nop
	
