 # 20190439 Gyubin Lee, CS311 HW1

    .data

    output_true_string: .asciiz "true\n"
    output_false_string: .asciiz "false\n"

    .text
main:

    li $v0, 5   #system call code for read_int
    syscall #read_int(saved in $v0)
    move $s0, $v0   #save number in $s0
    
    slt $t0, $s0, $zero #if $s0 is smaller than 0, $t0 becomes 1
    bne $t0, $zero, false

    li $s1, 0   #declare and initialize new integer
    add $t1, $s0, $zero #copy the value of $s0 to $t1
    li $t3, 10  #save 10 in $t3

while_condition:
    beq $t1, $zero, end #if $t1 is 0, go to end

while_contents:
    div $t1, $t3
    mflo $t1 #$t1 = $t1/10
    mfhi $t2 #$t2 = $t1%10
    
    mult $s1, $t3
    mflo $s1
    add $s1, $s1, $t2 #$s1 = 10*$s1 + $t2

    j while_condition

end:
    bne $s0, $s1 false #if $s1 != $s2, it means $s0 is not palindrome

    li $v0, 4   #system call code for print_string
    la $a0, output_true_string    #argument of print_string
    syscall #print_string(output_true_string)

    jr $ra

false:

    li $v0, 4   #system call code for print_string
    la $a0, output_false_string #argument of print_string
    syscall #print_string(output_false_string)
    
    jr $ra  #exit the program

    