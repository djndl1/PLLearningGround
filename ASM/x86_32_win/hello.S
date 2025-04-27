.intel_syntax noprefix

.section .data
msg:    .string "Hello from %s!\n"

.section .text

.global _main
.global _printf                  ;

_main:
    push    ebp
    mov     ebp, esp

    mov     eax, [ebp + 12] // ebp, ret address, argc, argv
    mov     eax, [eax]
    push    eax

    lea     eax, [msg]
    push    eax

    call    _printf
    add     esp, 8

    pop     ebp
    ret
