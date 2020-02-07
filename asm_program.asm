/*
Utah McEntire
Assembly Math
( W / X ) - ( Y * Z )
*/


.global main
.extern printf                  /* printf c function from library */

.text
main:
    mov $0, %rbx                /* iterator init at 0, into rbx */

    loop:
        cmp $13, %rbx           /* compare 13 and iterator value */
        je  exit                /* stops loop at 13 */
        
                                /* put array values into registers */
                                /* for maths function call */
        mov arr(,%rbx,8), %rdi  /* rbx(0) * 8 = index 0  */
        inc %rbx                /* rbx(0) + 1 = rbx(1)   */
        mov arr(,%rbx,8), %rsi  /* rbx(1) * 8 = index 8  */
        inc %rbx                /* rbx(1) + 1 = rbx(2)   */
        mov arr(,%rbx,8), %rdx  /* rbx(2) * 8 = index 16 */
        inc %rbx                /* rbx(2) + 1 = rbx(3)   */
        mov arr(,%rbx,8), %rcx  /* rbx(3) * 8 = index 24 */
        
        call maths              /* maths function call */
        
        mov %rax, %r9           /* move result to correct parameter */
                                /* register AFTER maths func return */

                                /* put array values into registers */
                                /* for printf function call */
        sub $3, %rbx            /* rbx(3) - 3 = rbx(0)   */
        mov arr(,%rbx,8), %rsi  /* rbx(0) * 8 = index 0  */
        inc %rbx                /* rbx(0) + 1 = rbx(1)   */
        mov arr(,%rbx,8), %rdx  /* rbx(1) * 8 = index 8  */
        inc %rbx                /* rbx(1) + 1 = rbx(2)   */
        mov arr(,%rbx,8), %rcx  /* rbx(2) * 8 = index 16 */
        inc %rbx                /* rbx(2) + 1 = rbx(3)   */
        mov arr(,%rbx,8), %r8   /* rbx(3) * 8 = index 24 */
        mov $eqn, %rdi

        mov $0, %al             /* for printf to stop segmentation fault */ 
        call printf             /* printf function call */
        
        sub $2, %rbx            /* sub 2 from iterator/counter */

        jmp loop                /* restart loop */
    

/* maths function (W/X)-(Y*Z) */
maths:
    mov %rdx, %r10              /* backup rdx before div */
    mov $0, %rdx                /* 0's out rdx to avoid float pt exception */
    
    mov %rdi, %rax              /* division prep */
    div %rsi                    /* divide rsi/rax */
    mov %rax, %r8               /* result of div op in r8 */
    
    mov %rcx, %rax              /* multiplication  prep*/
    mul %r10                    /* multiplies r10*rax */
    mov %rax, %r9               /* result of mul op in r9 */
    
    mov %r8, %rax               /* move div result into rax */
    sub %r9, %rax               /* result of sub op in rax */
     
    ret

exit:
    mov $60, %rax               /* system call 60 is exit */
    mov $0, %rdi                /* exit code 0 */
    syscall

.data
                                /* array random numbers */
    arr:    .quad  2,3,5,4,7,6,2,5,3,2,4,6,4,5,2,2
                                /* string for printing */
    eqn:    .ascii "( %i / %i ) - ( %i * %i ) = %i\n\0"
