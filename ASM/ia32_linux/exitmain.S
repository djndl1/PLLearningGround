.intel_syntax noprefix
.section .data

.section .text
.global main
.global exit

main:
    lea     ecx, [esp+4]
    and     esp, -16
    push    dword ptr [ecx-4]

    push    ebp
    mov     ebp, esp
    push    ecx
    sub     esp, 4

    sub     esp, 12
    push    1
    call    exit

    mov     ecx, dword ptr [ebp-4]
    leave
    lea     esp, [ecx-4]
    ret
