.data
	MAX:		.word	300
	BLOCK_SIZE: 	.word	60
.text
	lw	$s0, MAX
	lw	$s1, BLOCK_SIZE
	
	move	$a0, $s0	# Passing MAX as param
	jal	MATRIX_CREATE
	move 	$s2, $v0	# Pointer to Matrix A
	
	move	$a0, $s0	# Passing MAX as param
	jal	MATRIX_CREATE
	move 	$s3, $v0	# Pointer to Matrix B
	
	move	$a0, $s0	# Passing MAX as param
	move	$a1, $s1	# Passing BLOCK_SIZE as param
	move	$a2, $s2	# Passing Pointer to Matrix A as param
	move	$a3, $s3	# Passing Pointer to Matrix B as param
	jal	MATRIX_ADD_A_TRANSPOSED_B_WITH_BLOCK_SIZE
	
	j 	EXIT

MATRIX_ADD_A_TRANSPOSED_B_WITH_BLOCK_SIZE:
	li	$t0, 0			# i counter
i_iterator:
	li	$t1, 0			# j counter
j_iterator:
	move	$t2, $t0		# ii counter
ii_iterator:
	move	$t3, $t1		# jj counter
jj_iterator:
	mul	$t4, $t2, $a0		# ii as row: (ii * row) 
	add	$t4, $t4, $t3		# (ii * row) + jj
	sll	$t4, $t4, 2		# Offset calculated
	add	$t4, $t4, $a2		# Pointer to A[ii,jj]
	
	mul	$t5, $t3, $a0		# jj as row: (jj * row)
	add	$t5, $t5, $t2		# (jj * row) + ii
	sll	$t5, $t5, 2		# Offset calculated
	add	$t5, $t5, $a3		# Pointer to B[jj, ii]
	
	lw	$t6, 0($t4)		# A[ii,jj] value
	lw	$t7, 0($t5)		# B[jj, ii] value
	add	$t8, $t6, $t7		# A[ii,jj] + B[jj, ii]
	sw	$t8, 0($t4)		# A[ii,jj] = A[ii,jj] + B[jj, ii]
	
	addi	$t3, $t3, 1		# jj++
	add	$t9, $t1, $a1		# j + block_size
	bne	$t3, $t9, jj_iterator	# jj < j + block_size
	
	addi	$t2, $t2, 1		# ii++
	add	$t9, $t0, $a1		# i + block_size
	bne	$t2, $t9, ii_iterator	# ii < i + block_size
	
	add	$t1, $t1, $a1		# j += block_size
	bne	$t1, $a0, j_iterator	# j < MAX
	
	add	$t0, $t0, $a1		# i += block_size
	bne	$t0, $a0, i_iterator	# i < MAX
	
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
