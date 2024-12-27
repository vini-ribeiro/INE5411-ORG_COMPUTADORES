main:
    # Ler os switches
    li $v0, 0xFF    # Syscall para ler os switches
    syscall
    move $t0, $v0   # Salva o valor lido no registrador $t0

    # Escrever nos LEDs
    li $v0, 0xFE    # Syscall para escrever nos LEDs
    move $a0, $t0   # Move o valor lido para $a0
    syscall

    # Loop infinito
    j main