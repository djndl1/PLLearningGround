segment _DATA   PUBLIC  CLASS=DATA  ALIGN=2
    resb 0x10

segment STACK   STACK   CLASS=STACK ALIGN=16
    resb 1024

group DGROUP    _DATA   STACK

segment _TEXT   PUBLIC  CLASS=CODE  ALIGN=2
..start:
    jmp    _main

_main:
    mov     ax, DGROUP
    mov     ds, ax

    mov     bx, STACK
    sub     bx, ax
    shl     bx, 4

    mov     ss, ax
    add     sp, bx

    mov     al, 0

    mov     ah, 0x4c
    int     0x21
