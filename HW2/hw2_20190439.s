 # 20190439 Gyubin Lee, CS311 HW2

    .data
    const_1: .word 1664525
    const_2: .word 22695477
    const_3: .word -4
    nextLine: .asciiz "\n"

    .text
main:

    li $v0, 5
    syscall
    move $s1, $v0
    addi $s1, $s1, -1 # save {(the number of input) -1} in $s1  
    move $t1, $s1

    move $s0, $sp # save the address of first element in $s0
    addi $s0, $s0, -4 

    j while_take_input_condition

while_take_input_body: # take input and put it into the stack
    li $v0, 5
    syscall
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    addi $t1, $t1, -1
    j while_take_input_condition

while_take_input_condition:
    slt $t0, $t1, $zero
    beq $t0, $zero, while_take_input_body

    addi $sp, $sp, -4
    sw $ra, ($sp) # save the original $ra
    
    move $a1, $zero
    move $a2, $s1

    jal quicksort # call quicksort ($a1 stands for low, $a2 stands for high)

    jal print_stack # after finish sort, print the result

    lw $ra, ($sp) # load the original $ra 
    addi $sp, $sp, 4

    jr $ra
################################################ end of main

partition:

    xor $t3, $t3, $t3 # initialize $t3 to 0
    add $t3, $t3, $a1
    lw $t7, const_1
    multu $a2, $t7 # 1664525*(unsigned)high
    mflo $t4
    lw $t7, const_2
    multu $a1, $t7 # 22695477*(unsigned)low
    mflo $t5
    add $t4, $t4, $t5
    sub $t6, $a2, $a1
    addi $t6, $t6, 1 # (high-low+1)
    div $t4, $t6
    mfhi $t7
    add $t3, $t3, $t7 # $t2 stands for i

    ## pivot = A[i]
    xor $t4, $t4, $t4 # initailize $t4 to 0
    xor $t5, $t5, $t5 # initialize $t5 to 0
    lw $t7, const_3
    mult $t3, $t7
    mflo $t5 # $t5 = (-4)*i
    add $t4, $s0, $t5 # $t4 is address of (i+1)th input
    lw $t2, ($t4) # $t2 stands for variable 'pivot'

    ## A[i] = A[low]
    mult $a1, $t7
    mflo $t6 # $t6 = (-4)*low
    add $t4, $s0, $t6 # $t4 is address of (low+1)th input

    mult $t3, $t7
    mflo $t6 # $t6 = (-4)*i
    add $t5, $s0, $t6 # $t5 is address of (i+1)th input

    lw $t6, ($t4)
    lw $t8, ($t5)
    sw $t6, ($t5)
    sw $t6, ($t4)

    ## A[low] = pivot
    mult $a1, $t7
    mflo $t6 # $t6 = (-4)*low
    add $t4, $s0, $t6 # $t4 is address of (low+1)th input

    sw $t2, ($t4)

    addi $t3, $a1, 1 # i = low + 1
    move $t4, $a1 # $t4 stands for mid_left
    move $t5, $a2 # t5 stands for mid_right

while_true:
    j while_1_condition    

while_1_body:
    addi $t5, $t5, -1

while_1_condition:
    # check mid_right >= i(<=> i-1 < mid_right) for first
    addi $t6, $t3, -1 # $t6 = i-1
    slt $t0, $t6, $t5 # if $t6 is smaller than $t5, $t0 becomes 1
    beq $t0, $zero, while_2_condition # if condition is false, go to the next while loop
    # check A[mid_right] > pivot
    lw $t6, const_3
    mult $t5, $t6
    mflo $t6
    add $t7, $s0, $t6 # $t7 is address of A[mid_right]
    lw $t8, ($t7) # $t8 = A[mid_right]
    slt $t0, $t2, $t8 # if $t2 is smaller than $t8, $t0 becomes 1
    beq $t0, $zero, while_2_condition # if condition is false, go to the next while loop
    j while_1_body
    
while_2_body:
    # A[mid_left++] = A[i]
    lw $t6, const_3
    mult $t4, $t6
    mflo $t6
    add $t7, $s0, $t6 # $t7 is address of A[mid_left]
    lw $t6, const_3
    mult $t3, $t6
    mflo $t6
    add $t8, $s0, $t6 # $t8 is address of A[i]
    lw $t9, ($t8)
    sw $t9, ($t7)
    addi $t4, $t4, 1
    # A[i++] = pivot
    lw $t6, const_3
    mult $t3, $t6
    mflo $t6
    add $t7, $s0, $t6 # $t7 is address of A[i]
    sw $t2, ($t7)
    addi $t3, $t3, 1

while_2_condition:
    # check mid_right >= i(<=> i-1 < mid_right) for first
    addi $t6, $t3, -1 # $t6 = i-1
    slt $t0, $t6, $t5 # if $t6 is smaller than $t5, $t0 becomes 1
    beq $t0, $zero, if_condition # if condition is false, go to the if statement
    # check A[i] <= pivot (<=> A[i] < pivot + 1)
    lw $t6, const_3
    mult $t3, $t6
    mflo $t6
    add $t7, $s0, $t6 # $t7 is address of A[i]
    lw $t8, ($t7) # $t8 = A[i]
    addi $t6, $t2, 1 # $t6 = pivot + 1
    slt $t0, $t8, $t6 # if $t8 is smaller than $t6m $t0 becomes 1 
    beq $t0, $zero, if_condition # if condition is false, go to the if statement
    j while_2_body

if_condition:
    slt $t0, $t3, $t5
    beq $t0, $zero, end_of_partition

if_true_expr:
    # A[mid_left++] = A[mid_right]
    lw $t6, const_3
    mult $t4, $t6
    mflo $t6
    add $t7, $s0, $t6 # $t7 is address of A[mid_left]
    lw $t6, const_3    
    mult $t5, $t6
    mflo $t6
    add $t8, $s0, $t6 # $t8 is address of A[mid_right]
    lw $t9, ($t8)
    sw $t9, ($t7)
    addi $t4, $t4, 1
    # A[mid_right--] = A[i]
    lw $t6, const_3
    mult $t5, $t6
    mflo $t6
    add $t7, $s0, $t6 # $t7 is address of A[mid_right]
    lw $t6, const_3
    mult $t3, $t6
    mflo $t6
    add $t8, $s0, $t6 # $t8 is address of A[i]
    lw $t9, ($t8)
    sw $t9, ($t7)
    addi $t5, $t5, -1
    # A[i++] = pivot   
    lw $t6, const_3
    mult $t3, $t6
    mflo $t6
    add $t7, $s0, $t6 # $t7 is address of A[i]
    sw $t2, ($t7)
    addi $t3, $t3, 1

    j while_true

end_of_partition:

    move $s2, $t4 # $s2 stands for mid_left_o
    move $s3, $t5 # $s3 stands for mid_right_o

    jr $ra

################################################ end of partition

quicksort:

    addi $sp, $sp, -20 # save original $ra, $a1, $a2, $s2, $s3
    sw $s2, 16($sp)
    sw $s3, 12($sp)
    sw $ra, 8($sp)
    sw $a1, 4($sp)
    sw $a2, ($sp)
    
    slt $t0, $a1, $a2 # if (low >= high) go to end_of_quicksort
    beq $t0, $zero, end_of_quicksort
 
    jal partition

    addi $a2, $s2, -1 # $a2 = mid_left - 1
    jal quicksort

    lw $a2, ($sp) # $a2 = high
    addi $a1, $s3, 1 # $a1 = mid_right + 1
    jal quicksort

end_of_quicksort:
    lw $s2, 16($sp) # load original $ra, $a1, $a2, $s2, $s3
    lw $s3, 12($sp)    
    lw $ra, 8($sp)
    lw $a1, 4($sp)
    lw $a2, ($sp)
    addi $sp, $sp, 20
    jr $ra

################################################ end of quicksort

print_stack:

    move $t4, $s0 # load the base address of items to $t4
    move $t5, $s1 # load max index to $t5
    j while_print_stack_condition

while_print_stack_body:
    lw $a0, 0($t4)
    addi $t4, $t4, -4
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, nextLine
    syscall
    addi $t5, $t5, -1
    j while_print_stack_condition

while_print_stack_condition:
    slt $t6, $t5, $zero
    beq $t6, $zero, while_print_stack_body

    jr $ra

################################################ end of print_stack
