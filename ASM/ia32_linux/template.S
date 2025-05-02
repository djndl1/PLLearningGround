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
    lea     ecx, [esp+4]
    and     esp, -16
    push    dword ptr [ecx-4]
    push    ebp
    mov     ebp, esp
    push    ecx
    sub     esp, 4

    mov     ecx, dword ptr [ebp-4]
    leave
    lea     esp, [ecx-4]
    ret
