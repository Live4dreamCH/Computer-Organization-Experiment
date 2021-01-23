//registers ordered by instruction format: rs rt rd

initialize:
    //n => $31 (=4*9=36)
    lw $0 $31 e0h*4=0380h

    //head => $30
    addi $0 $30 f0h*4=03c0h

    //tail => $29, tail=head+n
    add $30 $31 $29

    //i => $28, i=head
    add $0 $30 $28

    //4 => $25
    addi $0 $25 4

    //tail-4 => $24
    sub $29 $25 $24

for_i:
    //min_addr => $26, min_addr=i
    add $0 $28 $26

    //min_value => $1, min_value=a[i]
    lw $28 $1 0

    //a[i] => $4
    add $0 $1 $4

    //j => $27, j=i+4
    addi $28 $27 4

    for_j:
        //a[j] => $2
        lw $27 $2 0

        //a[j]<min_value => $3
        sltu $2 $1 $3

        //if($3==0) jump to j_tail
        beq $0 $3 2

        //else: min_addr=j
        add $0 $27 $26

        //min_value=a[j]
        add $0 $2 $1
    j_tail:
        //j++
        addi $27 $27 4

        //if(j!=tail) jump to for_j
        bne $27 $29 16'd(-7)

    //if(min_addr==i) jump to i_tail
    beq $26 $28 2

    //array[min_addr]=a[i]
    sw $26 $4 0

    //a[i]=min_value
    sw $28 $1 0

i_tail:
    //i++
    addi $28 $28 4

    //if(i!=tail-4) jump to for_i
    bne $28 $24 16'd(-16)

halt:
    //nop
    nop

    //nop
    nop

    //nop
    nop

    //nop
    nop
