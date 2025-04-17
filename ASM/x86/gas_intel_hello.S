.intel_syntax noprefix

.section .rodata
greeting:      .string "Hello World!\n"

.section .text
.global main
.global printf

add8:
    push    rbp
    mov     rbp, rsp

    xor     eax, eax
    add     eax, edi
    add     eax, esi
    add     eax, edx
    add     eax, ecx
    add     eax, r8d
    add     eax, r9d
    add     eax, DWORD PTR [rbp+16]
    add     eax, DWORD PTR [rbp+24]

    leave
    ret

main:
    push    rbp
    mov     rbp, rsp
    lea     rdi, [rip + greeting]
    mov     al, 0
    call    printf

    mov     edi, 1
    mov     esi, 2
    mov     edx, 3
    mov     ecx, 4
    mov     r8d, 5
    mov     r9d, 6
    push    8
    push    7
    call    add8
    add     rsp, 16

    leave
    ret
