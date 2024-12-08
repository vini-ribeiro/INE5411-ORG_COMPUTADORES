.data
	MAX: 	.word	300	# Matrix Size
.text
MAIN:
	lw	$s0, MAX
	
	move	$a0, $s0
	jal	MATRIX_CREATE
	move	$s1, $v0	# Pointer to Matrix A
	
	move	$a0, $s0
	jal	MATRIX_CREATE
	move	$s2, $v0	# Pointer to Matrix B
	
	move	$a0, $s0	# Passing MAX as param
	move	$a1, $s1	# Passing Pointer to A as param
	move	$a2, $s2	# Passing Pointer to B as param
	jal 	MATRIX_ADD_A_TRANSPOSED_B
	
	j	EXIT

MATRIX_ADD_A_TRANSPOSED_B:
	li	$t0, 0		# Row counter
ROW_ITERATOR_SUM:
	li	$t1, 0		# Column counter
COLUMN_ITERATOR_SUM:
	mul	$t2, $t0, $a0 	# Row Page (row * max)
	add	$t2, $t2, $t1	# Page offset ((row * max) + column)
	sll	$t2, $t2, 2
	add	$t3, $a1, $t2	# Pointer to A[i, j]
	
	mul	$t2, $t1, $a0	# Column Page (column * max)
	add	$t2, $t2, $t0	# Page offset ((column * max) + row)
	sll	$t2, $t2, 2
	add 	$t4, $a2, $t2	# Pointer to B[j, i]
	
	lw	$t5, 0($t3)	# A[i, j]
	lw	$t6, 0($t4)	# B[j, i]
	add	$t7, $t5, $t6	# A[i, j] + B[j, i]
	 
	sw	$t7, 0($t3)
	
	addi	$t1, $t1, 1	# Column counter++
	bne	$t1, $a0, COLUMN_ITERATOR_SUM
	addi	$t0, $t0, 1	# Row counter++
	bne	$t0, $a0, ROW_ITERATOR_SUM
	
	jr	$ra

MATRIX_CREATE:
	li	$t0, 0		# Row counter
	li	$t2, 0		# Value counter
	move	$t3, $a0	# Max
	
	
	mul	$t4, $t3, $t3	
	sll	$t4, $t4, 2	# Matrix Size: max * max * 4
	
	li	$v0, 9		# Allocating matrix memory
	move	$a0, $t4
	syscall
	
	move	$t7, $v0	# Pointer to allocated memory
	
ROW_ITERATOR:			
	li	$t1, 0		# Column counter
COLUMN_ITERATOR:
	mul 	$t5, $t0, $t3	# Row Page (row * max)
	add	$t5, $t5, $t1	# Page offset ((row * max) + column)
	sll	$t5, $t5, 2	
	add	$t5, $t5, $t7	# Add offset to pointer
	
	sw	$t2, 0($t5)
	addi 	$t2, $t2, 1	# Value counter++
	addi	$t1, $t1, 1	# Column counter++
	bne	$t1, $t3, COLUMN_ITERATOR
	
	addi	$t0, $t0, 1	# Row counter++
	bne	$t0, $t3, ROW_ITERATOR

	jr	$ra
	
EXIT:
	nop
	
	
