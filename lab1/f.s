.arch armv7-a
.data
    fmt:.asciz "%d\n"
    fmt1:.asciz "%d"
    n:.word 0
.text
.global main
main:
    stmfd sp!,{lr}
    ldr r0, =fmt1
    ldr r1,=n
    bl scanf 
    ldr r0,=n
    ldr r0,[r0]
    bl fun
    mov r0,#0
    ldmfd sp!,{lr}
    mov pc,lr
.global fun
fun:    
    str fp, [sp, #-4]!
    mov fp,sp
    sub sp,sp,#20
    str r0,[fp, #-8]@r0 = n=[fp,#-8]
    mov r3,#0
    str r3,[fp, #-12]@a=0
    mov r1,r3 @r3=a=r1
    ldr r0,=fmt
    bl printf
    mov r3,#1
    str r3,[fp, #-16]@b=1
    mov r1,r3@r3=b=r1
    ldr r0,=fmt
    bl printf
    mov r3,#1
    str r3,[fp, #-20]@i=1
    b .check
.check:
    ldr r0, [fp, #-20]
    ldr r1, [fp, #-8]
    cmp r0,r1
    blt .loop
    b .l
    
.loop:
    ldr r0, [fp, #-16] @r0= b=t
    ldr r1, [fp, #-12] @r1=a
    add r3, r0, r1 @r3 = a+b
    str r3, [fp, #-16] @b= b
    str r0, [fp, #-12] @ a=t
    ldr r1, [fp, #-16] @r1=b
    ldr r0, =fmt
    bl printf
    ldr r0, [fp, #-20]
    add r0 , r0 , #1
    str r0,[fp, #-20]
    b .check
.l:@end this program
    mov r0,#0
    mov r7,#1
    swi 0
.end
    



