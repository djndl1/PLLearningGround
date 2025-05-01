.intel_syntax noprefix

.section .data

.section .text
.global _start

_start:

    call    _main

    mov     ebx, eax
    mov     eax, 1
    int     0x80

_main:
    push    ebp
    mov     ebp, esp

    pop     ebp
    ret
