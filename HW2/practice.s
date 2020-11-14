
    .data
	MSG1: .asciiz "Please Enter in a single number: "

    .text

main:

    li $v0, 4
    la $a0, MSG1
    syscall

    li $v0, 5
    syscall

    move $s0, $v0
    li $v0, 1
    move $a0, $s0
    syscall

    jr $ra

