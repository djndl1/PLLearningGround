.intel_syntax noprefix

.section .data
correct_msg:    .string "The sum is correct!\n"
scan_fmt:   .string "%d %d"

.section .text

.global main
.global printf
.global scanf

main:
    push    rbp
    mov rbp, rsp

    sub rsp, 32
    lea rdi, [rip + scan_fmt]
    lea rsi, [rsp]
    lea rdx, [rsp + 4]
    xor al, al
    call scanf

    mov eax, dword ptr [rsp]
    add eax, dword ptr [rsp + 4]

    cmp eax, 150
    jne ret_main

.correct_sum:
    push    rax
    lea rdi,    [rip + correct_msg]
    xor al, al
    call    printf
    pop     rax

ret_main:
    add rsp, 32
    pop rbp
    ret
