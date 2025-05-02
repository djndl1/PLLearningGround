.intel_syntax noprefix
.section .data

.section .text
.global main
.global exit

main:
    lea     ecx, [esp+4]
    and     esp, -16
    push    dword ptr [ecx-4]
    // restablish a fake stack base

    push    ebp
    mov     ebp, esp
    push    ecx // the real stack base
    sub     esp, 4

    mov     eax, 0

    mov     ecx, dword ptr [ebp-4]
    leave   // shrink back and restore ebp
    lea     esp, [ecx-4]
    ret
