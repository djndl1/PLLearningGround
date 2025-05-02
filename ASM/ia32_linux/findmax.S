.intel_syntax noprefix

.section .data

data_items: .long   3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text
.global _start

_start:
    call    _main

    mov     ebx, eax
    mov     eax, 1
    int     0x80

.func   main,_main
_main:
    lea     ecx, [esp+4]
    and     esp, -16
    push    dword ptr [ecx-4]
    push    ebp
    mov     ebp, esp
    push    ecx
    sub     esp, 4

    sub     esp, 16
    mov     dword ptr [esp+12], ebx

    mov     edi, 0
    mov     eax, dword ptr [data_items+4*edi]
    mov     ebx, eax
begin_find:
    cmp     eax, 0
    je      end_find

    inc     edi
    mov     eax, dword ptr [data_items+4*edi]

    cmp     eax, ebx
    jle     begin_find
    mov     ebx, eax

    jmp     begin_find
end_find:
    mov     eax, ebx

    mov     ebx, dword ptr [esp+12]
    add     esp, 16

    mov     ecx, dword ptr [ebp-4]
    leave
    lea     esp, [ecx-4]
    ret
.endfunc
