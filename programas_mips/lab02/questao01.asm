# VINICIUS HENRIQUE RIBEIRO E LUCAS FURLANETTO PASCOALI

# 1(6-meio) 1(5-cima-esquerda) 1(4-baixo-esquerda) 1(3-baixo) 1(2-baixo-direita) 1(1-cima-direita) 1(0-cima)

.data
	_0_: .word 63	# 0111111
	_1_: .word 6	# 0000110
	_2_: .word 91	# 1011011
	_3_: .word 79	# 1001111
	_4_: .word 102	# 1100110
	_5_: .word 109	# 1101101
	_6_: .word 125	# 1111101
	_7_: .word 7	# 0000111
	_8_: .word 127	# 1111111
	_9_: .word 111	# 1101111

.text
	lw	$t0, _0_
	sw	$t0, 0xffff0010
	
	li	$a0, 1000
	li	$v0, 32
	syscall
	
	lw	$t0, _1_
	sw	$t0, 0xffff0010

	syscall
		
	lw	$t0, _2_
	sw	$t0, 0xffff0010
	
	syscall
	
	lw	$t0, _3_
	sw	$t0, 0xffff0010
	
	syscall
	
	lw	$t0, _4_
	sw	$t0, 0xffff0010
	
	syscall
	
	lw	$t0, _5_
	sw	$t0, 0xffff0010
	
	syscall
	
	lw	$t0, _6_
	sw	$t0, 0xffff0010
	
	syscall
	
	lw	$t0, _7_
	sw	$t0, 0xffff0010
	
	syscall
	
	lw	$t0, _8_
	sw	$t0, 0xffff0010
	
	syscall
	
	lw	$t0, _9_
	sw	$t0, 0xffff0010
	
	syscall
