.intel_syntax noprefix
.section .data

.section .text
.global main
.global exit

main:
    push    ebp
    mov     ebp, esp

    push    1
    call    exit

    pop     ebp
    ret
