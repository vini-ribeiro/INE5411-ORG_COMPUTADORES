.data
	VAR: .word 55 # cria variavel de teste

.text
main:	
	addi 	$t0, $t0, 1
	li 	$t0, 6
	li	$t1, 7
	add	$s0, $t0, $t1
	j 	main
	