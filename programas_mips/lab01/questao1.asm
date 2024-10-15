# VINICIUS HENRIQUE RIBEIRO E LUCAS FURLANETTO PASCOALI

.data
	b_: .word 1
	d_: .word 2
	e_: .word 3
	c_: .word 4

.text
	lw	$s0, b_
	lw	$s1, d_
	lw	$s2, e_
	
	addi	$t0, $s0, 35 	# a = b + 35
	add	$t1, $t0, $s2	# a + e
	mul	$t2, $s1, $s1 	# d²
	mul	$t2, $s1, $t2 	# d³
	sub	$t3, $t2, $t1	# t2 = d³ - (a + e)	
	sw	$t3, c_ 	# c = t2
	
	
	
	
