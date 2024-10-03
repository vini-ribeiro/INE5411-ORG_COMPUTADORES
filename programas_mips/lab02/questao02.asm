.data
	a: .half 128
.text
	#lw	$t0, a
	sw	$t0, 0xffff0012
LOOP:
	j	LOOP